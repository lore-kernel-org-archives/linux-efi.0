From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/8] efi/capsule: Fix return code on failing kmap/vmap
Date: Wed,  5 Apr 2017 10:23:10 +0100
Message-ID: <20170405092317.27921-2-ard.biesheuvel@linaro.org>
References: <20170405092317.27921-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170405092317.27921-1-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org, hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, sascha.weisenberger-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org, jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>

If kmap or vmap fail, it means we ran out of memory. There are no
user-provided addressed involved that would justify EFAULT.

Signed-off-by: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/capsule-loader.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
index 9ae6c116c474..91e91f7a8807 100644
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
2.9.3
