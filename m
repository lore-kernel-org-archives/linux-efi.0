From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 02/13] efi/capsule: Fix return code on failing kmap/vmap
Date: Fri,  2 Jun 2017 13:51:56 +0000
Message-ID: <20170602135207.21708-3-ard.biesheuvel@linaro.org>
References: <20170602135207.21708-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170602135207.21708-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

If kmap or vmap fail, it means we ran out of memory. There are no
user-provided addressed involved that would justify EFAULT.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Reviewed-by: Matt Fleming <matt@codeblueprint.co.uk>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
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
