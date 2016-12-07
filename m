From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/4] efi: efi_print_memmap(): Call out invalid entries in the memory map early.
Date: Wed,  7 Dec 2016 16:38:27 -0500
Message-ID: <20161207213830.15984-1-pjones@redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Some machines, such as the Lenovo ThinkPad W541 with firmware GNET80WW
(2.28), include memory map entries with phys_addr=0x0 and num_pages=0.
Currently the log output for this case (with efi=debug) looks like:

[    0.000000] efi: mem45: [Reserved           |   |  |  |  |  |  |  |  |  |  |  |  ] range=[0x0000000000000000-0xffffffffffffffff] (0MB)

This is clearly wrong, and also not as informative as it could be.  This
patch changes it so that if we find obviously invalid memory map
entries, say so when we're printing the memory map.  It also detects the
display of the address range calculation overflow, so the new output is:

[    0.000000] efi: [Firmware Bug]: Invalid EFI memory map entry for 0x0 pages at 0x0000000000000000
[    0.000000] efi: mem45: [Reserved           |   |  |  |  |  |  |  |   |  |  |  |  ] range=[0x0000000000000000-0x0000000000000000] (0MB)

Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/platform/efi/efi.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 936a488..0263391 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -217,11 +217,27 @@ void __init efi_print_memmap(void)
 
 	for_each_efi_memory_desc(md) {
 		char buf[64];
+		bool valid = true;
+		u64 size = (md->num_pages << EFI_PAGE_SHIFT) - 1;
+
+		if (md->num_pages == 0) {
+			size = 0;
+			valid = false;
+		}
+
+		if (md->num_pages >= (((u64)-1LL) >> EFI_PAGE_SHIFT)) {
+			size = (u64)-1LL;
+			valid = false;
+		}
+
+		if (!valid)
+			pr_info(FW_BUG "Invalid EFI memory map entry for 0x%llx pages at 0x%016llx\n",
+				md->num_pages, md->phys_addr);
 
 		pr_info("mem%02u: %s range=[0x%016llx-0x%016llx] (%lluMB)\n",
 			i++, efi_md_typeattr_format(buf, sizeof(buf), md),
 			md->phys_addr,
-			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT) - 1,
+			md->phys_addr + size,
 			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
 	}
 }
-- 
2.9.3
