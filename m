From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] x86/efi: Map EFI memmap entries in-order at runtime
Date: Tue, 8 Sep 2015 21:37:42 +0100
Message-ID: <20150908203630.GB2854@codeblueprint.co.uk>
References: <1441372447-23439-1-git-send-email-matt@codeblueprint.co.uk>
 <CAKv+Gu9bGcSVWuMkPVJGDkCPmWvFpjhh4odLWPBZ-wX3=LgGaw@mail.gmail.com>
 <20150904182307.GE2737@codeblueprint.co.uk>
 <CAKv+Gu-AQdgJNOtrgtEtqxsaSC_L=EANpC3pT8b6X2jmZ5qO_Q@mail.gmail.com>
 <20150908131622.GA2854@codeblueprint.co.uk>
 <CAKv+Gu_us3Nu_gMd4GxPe7z0eqtMfM4DM_UEmGW2MTqVDxg5vA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_us3Nu_gMd4GxPe7z0eqtMfM4DM_UEmGW2MTqVDxg5vA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, James Bottomley <JBottomley-wo1vFcy6AUs@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 08 Sep, at 03:21:17PM, Ard Biesheuvel wrote:
> 
> I noticed that the 64-bit version of efi_map_region() preserves the
> relative alignment with respect to a 2 MB boundary for /each/ region.
> Since the regions are mapped in reverse order, it is highly unlikely
> that each region starts at the same 2 MB relative alignment that the
> previous region ended at, so you are likely wasting quite a bit of VA
> space.
> 
> I don't think it is a bug, though, but it does not seem intentional.

Yeah, that's a very good catch. The existing code, that is, top-down
allocation scheme where we map ealier EFI memmap entries at higher
virtual addresses, does incur quite a bit of wasted address space.

That's not true of this patch, though, and it's also not true if we
map the entries in reverse order of the EFI memmap, that is, mapping
the last memmap entry at the highest virtual address.

So it's a bug in the original code, or rather an unintended feature.

Ard, based on your suggestion I cooked this patch up to show what
iterating the EFI memmap in reverse looks like in terms of code. The
below diff and the original patch from this thread give me identical
virtual address space layouts.

Admittedly the below is missing a whole bunch of comments so makes the
diff look smaller, but something like this could work,

---

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 691b333e0038..a2af35f6093a 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -704,6 +704,44 @@ out:
 	return ret;
 }
 
+static inline void *efi_map_next_entry_reverse(void *entry)
+{
+	if (!entry)
+		return memmap.map_end - memmap.desc_size;
+
+	entry -= memmap.desc_size;
+	if (entry < memmap.map)
+		return NULL;
+
+	return entry;
+}
+
+static void *efi_map_next_entry(void *entry)
+{
+	bool reverse = false;
+
+	if (!efi_enabled(EFI_OLD_MEMMAP) && efi_enabled(EFI_64BIT)) {
+		/*
+		 * Iterate the EFI memory map in reverse order because
+		 * the regions will be mapped top-down. The end result
+		 * is the same as if we had mapped things forward, but
+		 * doesn't require us to change the implementation of
+		 * efi_map_region().
+		 */
+		return efi_map_next_entry_reverse(entry);
+	}
+
+	/* Initial call */
+	if (!entry)
+		return memmap.map;
+
+	entry += memmap.desc_size;
+	if (entry >= memmap.map_end)
+		return NULL;
+
+	return entry;
+}
+
 /*
  * Map the efi memory ranges of the runtime services and update new_mmap with
  * virtual addresses.
@@ -718,7 +756,8 @@ static void * __init efi_map_regions(int *count, int *pg_shift)
 	start = -1UL;
 	end = 0;
 
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+	p = NULL;
+	while ((p = efi_map_next_entry(p))) {
 		md = p;
 		if (!(md->attribute & EFI_MEMORY_RUNTIME)) {
 #ifdef CONFIG_X86_64

-- 
Matt Fleming, Intel Open Source Technology Center
