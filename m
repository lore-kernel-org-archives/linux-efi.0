From: Ivan Hu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH 3/3] efi/efi_test: fix the uninitialized value rv
Date: Mon, 26 Sep 2016 11:14:51 +0800
Message-ID: <1474859691-8574-4-git-send-email-ivan.hu@canonical.com>
References: <1474859691-8574-1-git-send-email-ivan.hu@canonical.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474859691-8574-1-git-send-email-ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ivan Hu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Fix the minor issue found by CoverityScan
520        kfree(name);
CID 1358932 (#1 of 1): Uninitialized scalar variable (UNINIT)17.
uninit_use: Using uninitialized value rv.
521        return rv;
522}

Signed-off-by: Ivan Hu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 drivers/firmware/efi/test/efi_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/test/efi_test.c b/drivers/firmware/efi/test/efi_test.c
index 87394f0..39302e6 100644
--- a/drivers/firmware/efi/test/efi_test.c
+++ b/drivers/firmware/efi/test/efi_test.c
@@ -425,7 +425,7 @@ static long efi_runtime_get_nextvariablename(unsigned long arg)
 	efi_guid_t *vd = NULL;
 	efi_guid_t vendor_guid;
 	efi_char16_t *name = NULL;
-	int rv;
+	int rv = 0;
 
 	getnextvariablename_user = (struct efi_getnextvariablename __user *)arg;
 
-- 
1.9.1
