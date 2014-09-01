From: Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/5] ia64: efi: format EFI memory type & attrs with efi_md_typeattr_format()
Date: Mon,  1 Sep 2014 02:53:39 +0200
Message-ID: <1409532820-5027-5-git-send-email-lersek@redhat.com>
References: <1409532820-5027-1-git-send-email-lersek@redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1409532820-5027-1-git-send-email-lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-ia64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Signed-off-by: Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 arch/ia64/kernel/efi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/kernel/efi.c b/arch/ia64/kernel/efi.c
index 741b99c..c52d754 100644
--- a/arch/ia64/kernel/efi.c
+++ b/arch/ia64/kernel/efi.c
@@ -568,6 +568,7 @@ efi_init (void)
 		{
 			const char *unit;
 			unsigned long size;
+			char buf[64];
 
 			md = p;
 			size = md->num_pages << EFI_PAGE_SHIFT;
@@ -586,9 +587,10 @@ efi_init (void)
 				unit = "KB";
 			}
 
-			printk("mem%02d: type=%2u, attr=0x%016lx, "
+			printk("mem%02d: %s "
 			       "range=[0x%016lx-0x%016lx) (%4lu%s)\n",
-			       i, md->type, md->attribute, md->phys_addr,
+			       i, efi_md_typeattr_format(buf, sizeof(buf), md),
+			       md->phys_addr,
 			       md->phys_addr + efi_md_size(md), size, unit);
 		}
 	}
-- 
1.8.3.1
