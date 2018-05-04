From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 11/17] efi/libstub/tpm: Make function efi_retrieve_tpm2_eventlog_1_2() static
Date: Fri,  4 May 2018 07:59:57 +0200
Message-ID: <20180504060003.19618-12-ard.biesheuvel@linaro.org>
References: <20180504060003.19618-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180504060003.19618-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

Fixes the following sparse warning:

drivers/firmware/efi/libstub/tpm.c:62:6: warning:
 symbol 'efi_retrieve_tpm2_eventlog_1_2' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/libstub/tpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/tpm.c b/drivers/firmware/efi/libstub/tpm.c
index 9d08cea3f1b0..caa37a6dd9d4 100644
--- a/drivers/firmware/efi/libstub/tpm.c
+++ b/drivers/firmware/efi/libstub/tpm.c
@@ -59,7 +59,7 @@ void efi_enable_reset_attack_mitigation(efi_system_table_t *sys_table_arg)
 
 #endif
 
-void efi_retrieve_tpm2_eventlog_1_2(efi_system_table_t *sys_table_arg)
+static void efi_retrieve_tpm2_eventlog_1_2(efi_system_table_t *sys_table_arg)
 {
 	efi_guid_t tcg2_guid = EFI_TCG2_PROTOCOL_GUID;
 	efi_guid_t linux_eventlog_guid = LINUX_EFI_TPM_EVENT_LOG_GUID;
-- 
2.17.0
