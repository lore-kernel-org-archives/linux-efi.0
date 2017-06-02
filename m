From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 07/13] efi/capsule: Remove NULL test on kmap()
Date: Fri,  2 Jun 2017 13:52:01 +0000
Message-ID: <20170602135207.21708-8-ard.biesheuvel@linaro.org>
References: <20170602135207.21708-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170602135207.21708-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Fabian Frederick <fabf@skynet.be>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Kweh Hock Leong <hock.leong.kweh@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>

kmap() can't fail.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Kweh Hock Leong <hock.leong.kweh@intel.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/capsule-loader.c | 4 ----
 drivers/firmware/efi/capsule.c        | 4 ----
 2 files changed, 8 deletions(-)

diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
index 5b012a467d7d..2357bcdcb44d 100644
--- a/drivers/firmware/efi/capsule-loader.c
+++ b/drivers/firmware/efi/capsule-loader.c
@@ -170,10 +170,6 @@ static ssize_t efi_capsule_write(struct file *file, const char __user *buff,
 	page = cap_info->pages[cap_info->index - 1];
 
 	kbuff = kmap(page);
-	if (!kbuff) {
-		ret = -ENOMEM;
-		goto failed;
-	}
 	kbuff += PAGE_SIZE - cap_info->page_bytes_remain;
 
 	/* Copy capsule binary data from user space to kernel space buffer */
diff --git a/drivers/firmware/efi/capsule.c b/drivers/firmware/efi/capsule.c
index 6eedff45e6d7..e603ccf39d80 100644
--- a/drivers/firmware/efi/capsule.c
+++ b/drivers/firmware/efi/capsule.c
@@ -247,10 +247,6 @@ int efi_capsule_update(efi_capsule_header_t *capsule, struct page **pages)
 		efi_capsule_block_desc_t *sglist;
 
 		sglist = kmap(sg_pages[i]);
-		if (!sglist) {
-			rv = -ENOMEM;
-			goto out;
-		}
 
 		for (j = 0; j < SGLIST_PER_PAGE && count > 0; j++) {
 			u64 sz = min_t(u64, imagesize, PAGE_SIZE);
-- 
2.9.3
