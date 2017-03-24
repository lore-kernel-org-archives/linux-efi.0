From: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 1/7] efi/capsule: Fix return code on failing kmap/vmap
Date: Fri, 24 Mar 2017 18:34:14 +0100
Message-ID: <d031a1bf1416b40143ae84a9e0f5f9df26c8fc2a.1490376860.git.jan.kiszka@siemens.com>
References: <cover.1490376860.git.jan.kiszka@siemens.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1490376860.git.jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
In-Reply-To: <cover.1490376860.git.jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
References: <cover.1490376860.git.jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>, Hock Leong Kweh <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Sascha Weisenberger <sascha.weisenberger-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

If kmap or vmap fail, it means we ran out of memory. There are no
user-provided addressed involved that would justify EFAULT.

Signed-off-by: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
---
 drivers/firmware/efi/capsule-loader.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
index 9ae6c11..91e91f7 100644
--- a/drivers/firmware/efi/capsule-loader.c
+++ b/drivers/firmware/efi/capsule-loader.c
@@ -113,7 +113,7 @@ static ssize_t efi_capsule_submit_update(struct capsule_info *cap_info)
 			VM_MAP, PAGE_KERNEL);
 	if (!cap_hdr_temp) {
 		pr_debug("%s: vmap() failed\n", __func__);
-		return -EFAULT;
+		return -ENOMEM;
 	}
 
 	ret = efi_capsule_update(cap_hdr_temp, cap_info->pages);
@@ -185,7 +185,7 @@ static ssize_t efi_capsule_write(struct file *file, const char __user *buff,
 	kbuff = kmap(page);
 	if (!kbuff) {
 		pr_debug("%s: kmap() failed\n", __func__);
-		ret = -EFAULT;
+		ret = -ENOMEM;
 		goto failed;
 	}
 	kbuff += PAGE_SIZE - cap_info->page_bytes_remain;
-- 
2.10.2
