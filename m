From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/5] efi: efi-stub-helper cleanup
Date: Fri,  4 Apr 2014 13:25:46 +0100
Message-ID: <1396614350-20889-2-git-send-email-leif.lindholm@linaro.org>
References: <1396614350-20889-1-git-send-email-leif.lindholm@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1396614350-20889-1-git-send-email-leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

An #ifdef CONFIG_ARM clause in efi-stub-helper.c got included with some
of the generic stub rework by Roy Franz. Drop it here to make subsequent
patches less confusing.

Also, In handle_cmdline_files(), fh is not initialized, and while the
overall logic around this handling appears safe, gcc does not always
pick this up. Initialize to NULL to remove the resulting warning.

Signed-off-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/efi-stub-helper.c |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index ff50aee..61230cb 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -267,7 +267,7 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 	struct file_info *files;
 	unsigned long file_addr;
 	u64 file_size_total;
-	efi_file_handle_t *fh;
+	efi_file_handle_t *fh = NULL;
 	efi_status_t status;
 	int nr_files;
 	char *str;
@@ -536,18 +536,8 @@ static char *efi_convert_cmdline_to_ascii(efi_system_table_t *sys_table_arg,
 	}
 
 	options_size++;  /* NUL termination */
-#ifdef CONFIG_ARM
-	/*
-	 * For ARM, allocate at a high address to avoid reserved
-	 * regions at low addresses that we don't know the specfics of
-	 * at the time we are processing the command line.
-	 */
-	status = efi_high_alloc(sys_table_arg, options_size, 0,
-			    &cmdline_addr, 0xfffff000);
-#else
-	status = efi_low_alloc(sys_table_arg, options_size, 0,
-			    &cmdline_addr);
-#endif
+
+	status = efi_low_alloc(sys_table_arg, options_size, 0, &cmdline_addr);
 	if (status != EFI_SUCCESS)
 		return NULL;
 
-- 
1.7.10.4
