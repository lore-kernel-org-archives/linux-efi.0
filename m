From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 16/17] efi/capsule-loader: Don't output reset log when reset flags are not set
Date: Fri,  4 May 2018 08:00:02 +0200
Message-ID: <20180504060003.19618-17-ard.biesheuvel@linaro.org>
References: <20180504060003.19618-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180504060003.19618-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Shunyong Yang <shunyong.yang@hxt-semitech.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Shunyong Yang <shunyong.yang@hxt-semitech.com>

When reset flags in capsule header are not set, it means firmware
attempts to immediately process or launch the capsule. Moreover, reset
is not needed in this case. The current code will output log to indicate
reset.

This patch adds a branch to avoid reset log output when the flags are not
set.

Cc: Joey Zheng <yu.zheng@hxt-semitech.com>
Signed-off-by: Shunyong Yang <shunyong.yang@hxt-semitech.com>
[ardb: use braces in multi-line 'if', clarify comment and commit log]
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/capsule-loader.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
index e456f4602df1..96688986da56 100644
--- a/drivers/firmware/efi/capsule-loader.c
+++ b/drivers/firmware/efi/capsule-loader.c
@@ -134,10 +134,16 @@ static ssize_t efi_capsule_submit_update(struct capsule_info *cap_info)
 
 	/* Indicate capsule binary uploading is done */
 	cap_info->index = NO_FURTHER_WRITE_ACTION;
-	pr_info("Successfully upload capsule file with reboot type '%s'\n",
-		!cap_info->reset_type ? "RESET_COLD" :
-		cap_info->reset_type == 1 ? "RESET_WARM" :
-		"RESET_SHUTDOWN");
+
+	if (cap_info->header.flags & EFI_CAPSULE_PERSIST_ACROSS_RESET) {
+		pr_info("Successfully uploaded capsule file with reboot type '%s'\n",
+			!cap_info->reset_type ? "RESET_COLD" :
+			cap_info->reset_type == 1 ? "RESET_WARM" :
+			"RESET_SHUTDOWN");
+	} else {
+		pr_info("Successfully processed capsule file\n");
+	}
+
 	return 0;
 }
 
-- 
2.17.0
