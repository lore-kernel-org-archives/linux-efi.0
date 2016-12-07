From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/4] efi: efi_map_region(): traceback if we try to map invalid sized regions
Date: Wed,  7 Dec 2016 16:38:28 -0500
Message-ID: <20161207213830.15984-2-pjones@redhat.com>
References: <20161207213830.15984-1-pjones@redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161207213830.15984-1-pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Some machines, such as the Lenovo ThinkPad W541 with firmware GNET80WW
(2.28), include memory map entries with phys_addr=0x0 and num_pages=0.
We shouldn't ever try to map these errors, so if we get as far as
efi_map_region(), show a traceback.

This additionally makes should_map_region() say not to map them, but I
fixed both places in case another caller of efi_map_region() ever arises
in the future.

Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/platform/efi/efi.c    |  4 ++++
 arch/x86/platform/efi/efi_64.c | 19 ++++++++++++++++---
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 0263391..d9f7131 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -707,6 +707,10 @@ static bool should_map_region(efi_memory_desc_t *md)
 	if (IS_ENABLED(CONFIG_X86_32))
 		return false;
 
+	if (md->num_pages == 0 ||
+	    md->num_pages >= (((u64)-1LL) >> EFI_PAGE_SHIFT))
+		return false;
+
 	/*
 	 * Map all of RAM so that we can access arguments in the 1:1
 	 * mapping when making EFI runtime calls.
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 319148b..7ee5d97 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -313,11 +313,24 @@ static void __init __map_region(efi_memory_desc_t *md, u64 va)
 
 void __init efi_map_region(efi_memory_desc_t *md)
 {
-	unsigned long size = md->num_pages << PAGE_SHIFT;
+	u64 size = md->num_pages << PAGE_SHIFT;
 	u64 pa = md->phys_addr;
 
-	if (efi_enabled(EFI_OLD_MEMMAP))
-		return old_map_region(md);
+	/*
+	 * hah hah the system firmware is having a good one on us
+	 */
+	if (md->num_pages == 0 ||
+	    md->num_pages >= (((u64)-1LL) >> EFI_PAGE_SHIFT)) {
+		pr_err("memmap from %p to %p is unreasonable.  Not mapping it.\n",
+		       (void *)pa, (void *)(pa+size));
+		WARN_ON(1);
+		return;
+	}
+
+	if (efi_enabled(EFI_OLD_MEMMAP)) {
+		old_map_region(md);
+		return;
+	}
 
 	/*
 	 * Make sure the 1:1 mappings are present as a catch-all for b0rked
-- 
2.9.3
