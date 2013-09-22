From: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 18/18] resolve warnings found on ARM compile
Date: Sun, 22 Sep 2013 15:45:42 -0700
Message-ID: <1379889942-3135-19-git-send-email-roy.franz@linaro.org>
References: <1379889942-3135-1-git-send-email-roy.franz@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1379889942-3135-1-git-send-email-roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

warnings from gcc:
warning: label 'free_pool' defined but not used [-Wunused-label]
warning: value computed is not used [-Wunused-value]




Signed-off-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/efi-stub-helper.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index 4e4127b..2d22aa3 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -169,7 +169,6 @@ again:
 		*addr = max_addr;
 	}
 
-free_pool:
 	efi_call_phys1(sys_table_arg->boottime->free_pool, map);
 
 fail:
@@ -242,7 +241,6 @@ static efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
 	if (i == map_size / desc_size)
 		status = EFI_NOT_FOUND;
 
-free_pool:
 	efi_call_phys1(sys_table_arg->boottime->free_pool, map);
 fail:
 	return status;
@@ -358,7 +356,7 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 
 			if (*str == '/') {
 				*p++ = '\\';
-				*str++;
+				str++;
 			} else {
 				*p++ = *str++;
 			}
-- 
1.7.10.4
