From: Ge Song <ge.song@hxt-semitech.com>
Subject: [PATCH 2/2] efi/capsule-loader: Request a contiguous virtual space for capsules
Date: Tue, 19 Dec 2017 18:46:52 +0800
Message-ID: <1513680412-5573-1-git-send-email-ge.song@hxt-semitech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Ge Song <ge.song@hxt-semitech.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Fleming <matt@codeblueprint.co.uk>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Use the start address of the contiguous virtual space to pass to efi
runtime service UpdateCapsule()

Signed-off-by: Ge Song <ge.song@hxt-semitech.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/firmware/efi/capsule-loader.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
index cbc3526953d5..efa4cce374d3 100644
--- a/drivers/firmware/efi/capsule-loader.c
+++ b/drivers/firmware/efi/capsule-loader.c
@@ -102,8 +102,17 @@ int __weak efi_capsule_setup_info(struct capsule_info *cap_info, void *kbuff,
 static ssize_t efi_capsule_submit_update(struct capsule_info *cap_info)
 {
 	int ret;
+	void *vm_cap_hdr;
+
+	/* Request a contiguous virtual space */
+	vm_cap_hdr = vmap(cap_info->pages, cap_info->index,
+					VM_MAP, PAGE_KERNEL);
+	if (!vm_cap_hdr)
+		return -ENOMEM;
+
+	ret = efi_capsule_update(vm_cap_hdr, cap_info->pages);
+		vunmap(vm_cap_hdr);
 
-	ret = efi_capsule_update(&cap_info->header, cap_info->pages);
 	if (ret) {
 		pr_err("capsule update failed\n");
 		return ret;
-- 
2.7.4
