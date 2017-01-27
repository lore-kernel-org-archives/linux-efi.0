From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH] x86/efi: Always map first physical page into EFI pagetables
Date: Fri, 27 Jan 2017 22:25:52 +0000
Message-ID: <20170127222552.22336-1-matt@codeblueprint.co.uk>
References: <20170127220604.21302-1-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170127220604.21302-1-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Hanka Pavlikova <hanka-+ZI9xUNit7I@public.gmane.org>, Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vojtech Pavlik <vojtech-+ZI9xUNit7I@public.gmane.org>, Waiman Long <waiman.long-ZPxbGqLxI0U@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>

Commit 129766708 ("x86/efi: Only map RAM into EFI page tables if in
mixed-mode") stopped creating 1:1 mapping for all RAM in case of running
in native 64bit mode.

It turns out though that there are 64bit EFI implementations in the wild
(this particular problem has been reported on Lenovo Yoga 710-11IKB) which
still make use of first physical page for their own private use even
though they explicitly mark it EFI_CONVENTIONAL_MEMORY in the memory map.

In case there is no mapping for this particular frame in EFI pagetables,
as soon as firmware tries to make use of it, triple fault occurs and the
system reboots (in case of Yoga 710-11IKB this is very early during boot).

Fix that by always mapping the first page of physical memory into EFI
pagetables. We're on a safe side, as trim_bios_range() will reserve the
first page and isolate it away from memory allocators anyway.

Note: just reverting 129766708 is not enough on v4.9-rc1+ to fix the
regression on affected hardware, as commit ab72a27da ("x86/efi:
Consolidate region mapping logic") later made the first physical frame not
to be mapped anyway.

Reported-by: Hanka Pavlikova <hanka-+ZI9xUNit7I@public.gmane.org>
Signed-off-by: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org # v4.8+
Cc: Waiman Long <waiman.long-ZPxbGqLxI0U@public.gmane.org>
Cc: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Cc: Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Vojtech Pavlik <vojtech-+ZI9xUNit7I@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Fixes: 129766708 ("x86/efi: Only map RAM into EFI page tables if in mixed-mode")
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 arch/x86/platform/efi/efi_64.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 319148bd4b05..79c21cac1133 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -269,6 +269,22 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 	efi_scratch.use_pgd = true;
 
 	/*
+	 * Certain firmware versions are way too sentimential and still believe
+	 * they are exclusive and unquestionable owners of first physical page
+	 * even though they explicitly mark it as EFI_CONVENTIONAL_MEMORY
+	 * (but then write-access it later during SetVirtualAddressMap()).
+	 *
+	 * Create 1:1 mapping for this page to avoid triple faults during early
+	 * boot with such firmware. We're on a safe side, as trim_bios_range()
+	 * will reserve the first page and isolate it away from memory
+	 * allocators anyway.
+	 */
+	if (kernel_map_pages_in_pgd(pgd, 0x0, 0x0, 1, _PAGE_RW)) {
+		pr_err("Failed to create 1:1 mapping of first page\n");
+		return 1;
+	}
+
+	/*
 	 * When making calls to the firmware everything needs to be 1:1
 	 * mapped and addressable with 32-bit pointers. Map the kernel
 	 * text and allocate a new stack because we can't rely on the
-- 
2.10.0
