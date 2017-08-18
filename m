From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 05/14] efi: arm/arm64: Add missing assignment of efi.config_table
Date: Fri, 18 Aug 2017 20:49:38 +0100
Message-ID: <20170818194947.19347-6-ard.biesheuvel@linaro.org>
References: <20170818194947.19347-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170818194947.19347-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

The ARM EFI init code never assigns the config_table member of the
efi struct, which means the sysfs device node is missing, and other
in-kernel users will not work correctly. So add the missing assignment.

Note that, for now, the runtime and fw_vendor members are still
omitted. This is deliberate: exposing physical addresses via sysfs nodes
encourages behavior that we would like to avoid on ARM (given how it is
more finicky about using correct memory attributes when mapping memory
in userland that may be mapped by the kernel already as well)

Cc: Matt Fleming <matt@codeblueprint.co.uk>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/arm-init.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
index 0aa4ce7b4fbb..80d1a885def5 100644
--- a/drivers/firmware/efi/arm-init.c
+++ b/drivers/firmware/efi/arm-init.c
@@ -145,6 +145,9 @@ static int __init uefi_init(void)
 					 sizeof(efi_config_table_t),
 					 arch_tables);
 
+	if (!retval)
+		efi.config_table = (unsigned long)efi.systab->tables;
+
 	early_memunmap(config_tables, table_size);
 out:
 	early_memunmap(efi.systab,  sizeof(efi_system_table_t));
-- 
2.11.0
