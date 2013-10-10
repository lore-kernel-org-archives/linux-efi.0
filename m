From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 12/12] EFI: Runtime services virtual mapping
Date: Thu, 10 Oct 2013 16:06:35 +0800
Message-ID: <20131010080635.GA3692@dhcp-16-126.nay.redhat.com>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
 <20131008164551.GB16793@pd.tnic>
 <20131008164831.GD16793@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131008164831.GD16793-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fwts-devel-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 10/08/13 at 06:48pm, Borislav Petkov wrote:
> From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
> 
> We map the EFI regions needed for runtime services contiguously on
> virtual addresses starting from -4G down for a total max space of 64G.
> This way, we provide for stable runtime services addresses across
> kernels so that a kexec'd kernel can still use them.
> 
> This way, they're mapped in a separate pagetable so that we don't
> pollute the kernel namespace (you can see how the whole ioremapping and
> saving and restoring of PGDs is gone now).
> 
> Also, add a chicken bit called "efi=old_map" which can be used as a
> fallback to the old runtime services mapping method in case there's some
> b0rkage with a particular EFI implementation (haha, it is hard to hold
> up the sarcasm here...).
> 
> Add UEFI RT VA space to Documentation/x86/x86_64/mm.txt, while at it.
> 

Tested this new patch, the kexec kernel still get different mappings.
Same reason, in first kernel reserve boot service function the size is
set to 0.

With a little hack patch below (upon my previous test patches for kexec)
kexec and kdump works ok in qemu/ovmf, still not tried on real hardware.

--- bp.orig/arch/x86/platform/efi/efi.c
+++ bp/arch/x86/platform/efi/efi.c
@@ -445,10 +445,18 @@ static void __init print_efi_memmap(void
 #endif  /*  EFI_DEBUG  */
 }
 
+static bool inline overlap_with_ktext(u64 start, u64 size)
+{
+	return (start + size >= __pa_symbol(_text)
+				&& start <= __pa_symbol(_end));
+}
+
 void __init efi_reserve_boot_services(void)
 {
 	void *p;
 
+	if (kexecboot)
+		return;
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		efi_memory_desc_t *md = p;
 		u64 start = md->phys_addr;
@@ -463,13 +471,16 @@ void __init efi_reserve_boot_services(vo
 		 * - Not within any part of the kernel
 		 * - Not the bios reserved area
 		*/
-		if ((start+size >= __pa_symbol(_text)
-				&& start <= __pa_symbol(_end)) ||
+		if (overlap_with_ktext(start, size) ||
 			!e820_all_mapped(start, start+size, E820_RAM) ||
 			memblock_is_region_reserved(start, size)) {
 			/* Could not reserve, skip it */
-			md->num_pages = 0;
-			memblock_dbg("Could not reserve boot range "
+			if (overlap_with_ktext(start, size)) {
+				u64 s = __pa_symbol(_text) - start;
+				memblock_reserve(start, s);
+			} else
+				md->num_pages = 0;
+			memblock_dbg("Could not reserve whole boot range "
 					"[0x%010llx-0x%010llx]\n",
 						start, start+size-1);
 		} else
@@ -490,6 +501,8 @@ void __init efi_free_boot_services(void)
 {
 	void *p;
 
+	if (kexecboot)
+		return;
 	if (!efi_is_native())
 		return;
 
