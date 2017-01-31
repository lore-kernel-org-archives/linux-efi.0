From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 06/10] efi/esrt: Fix spelling mistake "doen't"
Date: Tue, 31 Jan 2017 13:21:38 +0000
Message-ID: <1485868902-20401-7-git-send-email-ard.biesheuvel@linaro.org>
References: <1485868902-20401-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1485868902-20401-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Colin Ian King <colin.king@canonical.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake "doen't" to "doesn't" in pr_err message

Cc: Matt Fleming <matt@codeblueprint.co.uk>
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/esrt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/esrt.c b/drivers/firmware/efi/esrt.c
index 14914074f716..08b026864d4e 100644
--- a/drivers/firmware/efi/esrt.c
+++ b/drivers/firmware/efi/esrt.c
@@ -269,7 +269,7 @@ void __init efi_esrt_init(void)
 	max -= efi.esrt;
 
 	if (max < size) {
-		pr_err("ESRT header doen't fit on single memory map entry. (size: %zu max: %zu)\n",
+		pr_err("ESRT header doesn't fit on single memory map entry. (size: %zu max: %zu)\n",
 		       size, max);
 		return;
 	}
-- 
2.7.4
