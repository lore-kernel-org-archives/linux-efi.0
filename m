From: James Bottomley <jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH] efivars: Make efivarfs autoloading on mount request
Date: Thu, 28 Feb 2013 10:26:22 +0000
Message-ID: <1362047181.3128.22.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Content-ID: <ACC57149E6B5F7438D9D892BD0E2EF4E-ruSsrxOD6xDby3iVrkZq2A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Currently you can't mount efivarfs unless the efivar module is already
inserted.  This is contrary to the usual way in linux, where we autoload
the necessary filesystem modules when a mount request is received.  The
reason this doesn't happen for efivarfs is because the module is called
efivars not efivarfs.  Fix this by adding a module alias for efivarfs.

Signed-off-by: James Bottomley <JBottomley-MU7nAjRaF3makBO8gow8eQ@public.gmane.org>

---

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index f5596db..62386a0 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -93,6 +93,7 @@ MODULE_AUTHOR("Matt Domsch <Matt_Domsch-DYMqY+WieiM@public.gmane.org>");
 MODULE_DESCRIPTION("sysfs interface to EFI Variables");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(EFIVARS_VERSION);
+MODULE_ALIAS("efivarfs");	/* we export the efivarfs filesystem */
 
 #define DUMP_NAME_LEN 52
 
