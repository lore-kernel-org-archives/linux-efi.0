From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [PATCH] x86, efi: retry ExitBootServices() on failure
Date: Wed, 22 May 2013 15:15:00 +0100
Message-ID: <1369232100-27232-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

ExitBootServices() can legitimately fail if any of the event handlers
that are signaled by its invocation change the memory map. In that case,
we need to get the memory map and exit boot services again. Only retry
once so that we don't get stuck if ExitBootServices() is returning a
genuine error value.

Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 arch/x86/boot/compressed/eboot.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 35ee62f..a88a81d 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -1037,6 +1037,7 @@ static efi_status_t exit_boot(struct boot_params *boot_params,
 	efi_memory_desc_t *mem_map;
 	efi_status_t status;
 	__u32 desc_version;
+	bool called_exit = false;
 	u8 nr_entries;
 	int i;
 
@@ -1049,9 +1050,10 @@ again:
 	if (status != EFI_SUCCESS)
 		return status;
 
+get_map:
 	status = efi_call_phys5(sys_table->boottime->get_memory_map, &size,
 				mem_map, &key, &desc_size, &desc_version);
-	if (status == EFI_BUFFER_TOO_SMALL) {
+	if (status == EFI_BUFFER_TOO_SMALL && !called_exit) {
 		low_free(_size, (unsigned long)mem_map);
 		goto again;
 	}
@@ -1074,8 +1076,20 @@ again:
 	/* Might as well exit boot services now */
 	status = efi_call_phys2(sys_table->boottime->exit_boot_services,
 				handle, key);
-	if (status != EFI_SUCCESS)
-		goto free_mem_map;
+	if (status != EFI_SUCCESS) {
+		/*
+		 * ExitBootServices() will fail if any of the event
+		 * handlers change the memory map. In which case, we
+		 * must be prepared to retry, but only once so that
+		 * we're guaranteed to exit on repeated failures instead
+		 * of spinning forever.
+		 */
+		if (called_exit)
+			goto free_mem_map;
+
+		called_exit = true;
+		goto get_map;
+	}
 
 	/* Historic? */
 	boot_params->alt_mem_k = 32 * 1024;
-- 
1.8.1.4
