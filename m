From: Ivan Hu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH 2/3] efi/efi_test: fix the uninitialized value datasize
Date: Mon, 26 Sep 2016 11:14:50 +0800
Message-ID: <1474859691-8574-3-git-send-email-ivan.hu@canonical.com>
References: <1474859691-8574-1-git-send-email-ivan.hu@canonical.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474859691-8574-1-git-send-email-ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ivan Hu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Fix the minor issue found by CoverityScan
CID 1358931 (#1 of 1): Uninitialized scalar variable (UNINIT)9.
uninit_use: Using uninitialized value datasize.
199        prev_datasize = datasize;
200        status = efi.get_variable(name, vd, at, dz, data);

Signed-off-by: Ivan Hu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 drivers/firmware/efi/test/efi_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/test/efi_test.c b/drivers/firmware/efi/test/efi_test.c
index 5602c46..87394f0 100644
--- a/drivers/firmware/efi/test/efi_test.c
+++ b/drivers/firmware/efi/test/efi_test.c
@@ -156,7 +156,7 @@ static long efi_runtime_get_variable(unsigned long arg)
 {
 	struct efi_getvariable __user *getvariable_user;
 	struct efi_getvariable getvariable;
-	unsigned long datasize, prev_datasize, *dz;
+	unsigned long datasize = 0, prev_datasize, *dz;
 	efi_guid_t vendor_guid, *vd = NULL;
 	efi_status_t status;
 	efi_char16_t *name = NULL;
-- 
1.9.1
