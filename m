From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 1/2] efi/capsule-loader: pr_err() strings should end with newlines
Date: Wed, 25 Oct 2017 11:14:18 +0100
Message-ID: <20171025101419.26369-2-ard.biesheuvel@linaro.org>
References: <20171025101419.26369-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171025101419.26369-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Arvind Yadav <arvind.yadav.cs@gmail.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>, Kweh Hock Leong <hock.leong.kweh@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

From: Arvind Yadav <arvind.yadav.cs@gmail.com>

pr_err() messages should terminated with a new-line to avoid
other messages being concatenated onto the end.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kweh Hock Leong <hock.leong.kweh@intel.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/capsule-loader.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
index ec8ac5c4dd84..51d2874942a2 100644
--- a/drivers/firmware/efi/capsule-loader.c
+++ b/drivers/firmware/efi/capsule-loader.c
@@ -49,7 +49,7 @@ int __efi_capsule_setup_info(struct capsule_info *cap_info)
 	pages_needed = ALIGN(cap_info->total_size, PAGE_SIZE) / PAGE_SIZE;
 
 	if (pages_needed == 0) {
-		pr_err("invalid capsule size");
+		pr_err("invalid capsule size\n");
 		return -EINVAL;
 	}
 
-- 
2.11.0
