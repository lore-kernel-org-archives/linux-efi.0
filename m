From: Ivan Hu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH 1/3 V2] efi/efi_test: use memdup_user() as a cleanup
Date: Wed,  5 Oct 2016 10:07:34 +0800
Message-ID: <1475633254-6815-1-git-send-email-ivan.hu@canonical.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ivan Hu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Fix coccicheck warning which recommends to use memdup_user()

This patch fixes below coccicheck warnings:
drivers/firmware/efi/test/efi_test.c:269:8-15: WARNING opportunity for
memdup_user

Signed-off-by: Ivan Hu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 drivers/firmware/efi/test/efi_test.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/firmware/efi/test/efi_test.c b/drivers/firmware/efi/test/efi_test.c
index f61bb52..5602c46 100644
--- a/drivers/firmware/efi/test/efi_test.c
+++ b/drivers/firmware/efi/test/efi_test.c
@@ -266,14 +266,10 @@ static long efi_runtime_set_variable(unsigned long arg)
 			return rv;
 	}
 
-	data = kmalloc(setvariable.data_size, GFP_KERNEL);
-	if (!data) {
+	data = memdup_user(setvariable.data, setvariable.data_size);
+	if (IS_ERR(data)) {
 		kfree(name);
-		return -ENOMEM;
-	}
-	if (copy_from_user(data, setvariable.data, setvariable.data_size)) {
-		rv = -EFAULT;
-		goto out;
+		return PTR_ERR(data);
 	}
 
 	status = efi.set_variable(name, &vendor_guid,
-- 
1.9.1
