From: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 13/17] Allow efi_free() to be called with size of 0, and do nothing in that case.
Date: Mon, 16 Sep 2013 21:11:29 -0700
Message-ID: <1379391093-27948-14-git-send-email-roy.franz@linaro.org>
References: <1379391093-27948-1-git-send-email-roy.franz@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1379391093-27948-1-git-send-email-roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Make efi_free() safely callable with size of 0, similar to free() being
callable with NULL pointers.
Remove size checks that this makes redundant.  This also avoids some
size checks in the ARM EFI stub code that will be added as well.

Signed-off-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/x86/boot/compressed/eboot.c       |    3 +--
 drivers/firmware/efi/efi-stub-helper.c |    3 +++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index e1fbb2e..2bf1f83 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -506,8 +506,7 @@ struct boot_params *make_boot_params(void *handle, efi_system_table_t *_table)
 
 	return boot_params;
 fail2:
-	if (options_size)
-		efi_free(sys_table, options_size, hdr->cmd_line_ptr);
+	efi_free(sys_table, options_size, hdr->cmd_line_ptr);
 fail:
 	efi_free(sys_table, 0x4000, (unsigned long)boot_params);
 	return NULL;
diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index ca1592b..06ef01c 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -253,6 +253,9 @@ static void efi_free(efi_system_table_t *sys_table_arg, unsigned long size,
 {
 	unsigned long nr_pages;
 
+	if (!size)
+		return;
+
 	nr_pages = round_up(size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
 	efi_call_phys2(sys_table_arg->boottime->free_pages, addr, nr_pages);
 }
-- 
1.7.10.4
