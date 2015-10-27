From: Saurabh Sengar <saurabh.truth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] efi: replace GFP_KERNEL with GFP_ATOMIC
Date: Wed, 28 Oct 2015 00:12:29 +0530
Message-ID: <1445971349-3322-1-git-send-email-saurabh.truth@gmail.com>
References: <saurabh.truth@gmail.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <saurabh.truth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Saurabh Sengar <saurabh.truth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

replace GFP_KERNEL with GFP_ATOMIC, as code while holding a spinlock
should be atomic
GFP_KERNEL may sleep and can cause deadlock, where as GFP_ATOMIC may
fail but certainly avoids deadlock

Signed-off-by: Saurabh Sengar <saurabh.truth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/firmware/efi/vars.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index 70a0fb1..c07de85 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -334,7 +334,7 @@ static void dup_variable_bug(efi_char16_t *str16, efi_guid_t *vendor_guid,
 	 */
 	efivar_wq_enabled = false;
 
-	str8 = kzalloc(len8, GFP_KERNEL);
+	str8 = kzalloc(len8, GFP_ATOMIC);
 	if (!str8)
 		return;
 
-- 
1.9.1
