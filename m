From: bsz@semihalf.com
Subject: [PATCH 5/5] efi/arm: Retrieve TPM event log at efi_entry
Date: Mon, 11 Feb 2019 15:30:52 +0100
Message-ID: <20190211143052.3128-6-bsz@semihalf.com>
References: <20190211143052.3128-1-bsz@semihalf.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190211143052.3128-1-bsz@semihalf.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, peterhuewe@gmx.de, jarkko.sakkinen@linux.intel.com, ard.biesheuvel@linaro.org
Cc: tweek@google.com, mingo@kernel.org, hdegoede@redhat.com, leif.lindholm@linaro.org, mw@semihalf.com, Bartosz Szczepanek <bsz@semihalf.com>
List-Id: linux-efi@vger.kernel.org

From: Bartosz Szczepanek <bsz@semihalf.com>

Add efi_retrieve_tpm2_eventlog() call to ARM efi_entry() function.
There's no reason to assume that TPM2 EFI structures are not available
on ARM architecture.

Signed-off-by: Bartosz Szczepanek <bsz@semihalf.com>
---
 drivers/firmware/efi/libstub/arm-stub.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index eee42d5e25ee..d3af12ec32e4 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -197,6 +197,7 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 
 	/* Ask the firmware to clear memory on unclean shutdown */
 	efi_enable_reset_attack_mitigation(sys_table);
+	efi_retrieve_tpm2_eventlog(sys_table);
 
 	secure_boot = efi_get_secureboot(sys_table);
 
-- 
2.14.4
