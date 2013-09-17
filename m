From: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 07/17] Move relocate_kernel() to shared file.
Date: Mon, 16 Sep 2013 21:11:23 -0700
Message-ID: <1379391093-27948-8-git-send-email-roy.franz@linaro.org>
References: <1379391093-27948-1-git-send-email-roy.franz@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1379391093-27948-1-git-send-email-roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The relocate_kernel() function will be generalized and used
by all architectures, as they all have similar requirements.

Signed-off-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/x86/boot/compressed/eboot.c       |   34 -------------------------------
 drivers/firmware/efi/efi-stub-helper.c |   35 ++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 34 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 2a4430a..5bbba86 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -677,40 +677,6 @@ free_mem_map:
 	return status;
 }
 
-static efi_status_t relocate_kernel(struct setup_header *hdr)
-{
-	unsigned long start, nr_pages;
-	efi_status_t status;
-
-	/*
-	 * The EFI firmware loader could have placed the kernel image
-	 * anywhere in memory, but the kernel has various restrictions
-	 * on the max physical address it can run at. Attempt to move
-	 * the kernel to boot_params.pref_address, or as low as
-	 * possible.
-	 */
-	start = hdr->pref_address;
-	nr_pages = round_up(hdr->init_size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
-
-	status = efi_call_phys4(sys_table->boottime->allocate_pages,
-				EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
-				nr_pages, &start);
-	if (status != EFI_SUCCESS) {
-		status = efi_low_alloc(sys_table, hdr->init_size,
-				   hdr->kernel_alignment, &start);
-		if (status != EFI_SUCCESS)
-			efi_printk(sys_table, "Failed to alloc mem for kernel\n");
-	}
-
-	if (status == EFI_SUCCESS)
-		memcpy((void *)start, (void *)(unsigned long)hdr->code32_start,
-		       hdr->init_size);
-
-	hdr->pref_address = hdr->code32_start;
-	hdr->code32_start = (__u32)start;
-
-	return status;
-}
 
 /*
  * On success we return a pointer to a boot_params structure, and NULL
diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index 9e451c6..1d5f219 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -483,3 +483,38 @@ fail:
 
 	return status;
 }
+
+static efi_status_t relocate_kernel(struct setup_header *hdr)
+{
+	unsigned long start, nr_pages;
+	efi_status_t status;
+
+	/*
+	 * The EFI firmware loader could have placed the kernel image
+	 * anywhere in memory, but the kernel has various restrictions
+	 * on the max physical address it can run at. Attempt to move
+	 * the kernel to boot_params.pref_address, or as low as
+	 * possible.
+	 */
+	start = hdr->pref_address;
+	nr_pages = round_up(hdr->init_size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
+
+	status = efi_call_phys4(sys_table->boottime->allocate_pages,
+				EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
+				nr_pages, &start);
+	if (status != EFI_SUCCESS) {
+		status = efi_low_alloc(sys_table, hdr->init_size,
+				   hdr->kernel_alignment, &start);
+		if (status != EFI_SUCCESS)
+			efi_printk(sys_table, "Failed to alloc mem for kernel\n");
+	}
+
+	if (status == EFI_SUCCESS)
+		memcpy((void *)start, (void *)(unsigned long)hdr->code32_start,
+		       hdr->init_size);
+
+	hdr->pref_address = hdr->code32_start;
+	hdr->code32_start = (__u32)start;
+
+	return status;
+}
-- 
1.7.10.4
