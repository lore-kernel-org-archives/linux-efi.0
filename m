From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] efi: add comment to avoid future expanding of sysfs systab
Date: Tue, 5 Dec 2017 17:42:27 +0800
Message-ID: <20171205094227.GA16630@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org
List-Id: linux-efi@vger.kernel.org

/sys/firmware/efi/systab shows several different values, it breaks sysfs
one file one value design.  But since there are already userspace tools
depend on it eg. kexec-tools so add code comment to alert future expanding
of this file.

Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/firmware/efi/efi.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-x86.orig/drivers/firmware/efi/efi.c
+++ linux-x86/drivers/firmware/efi/efi.c
@@ -109,6 +109,8 @@ struct kobject *efi_kobj;
 /*
  * Let's not leave out systab information that snuck into
  * the efivars driver
+ * Note, do not add more fields in systab sysfs file as it breaks sysfs
+ * one value per file rule!
  */
 static ssize_t systab_show(struct kobject *kobj,
 			   struct kobj_attribute *attr, char *buf)
