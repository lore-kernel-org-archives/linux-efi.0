From: Maksym Kokhan <maksym.kokhan@globallogic.com>
Subject: [PATCH 3/8] efi: modify EFI stub code for arm/arm64
Date: Thu, 27 Sep 2018 19:55:39 +0300
Message-ID: <1538067339-5826-1-git-send-email-maksym.kokhan@globallogic.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
Cc: Daniel Walker <dwalker@fifo99.com>, Daniel Walker <danielwa@cisco.com>, Andrii Bordunov <aborduno@cisco.com>, Ruslan Bilovol <rbilovol@cisco.com>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Original EFI stub code parses command line, using old configs: CMDLINE,
CMDLINE_EXTEND and CMDLINE_FORCE. New generic builtin command line use
new configs: CMDLINE_PREPEND, CMDLINE_APPEND and CMDLINE_OVERRIDE, which
depend on CMDLINE_BOOL.

Cc: Daniel Walker <dwalker@fifo99.com>
Cc: Daniel Walker <danielwa@cisco.com>
Signed-off-by: Maksym Kokhan <maksym.kokhan@globallogic.com>
---
 drivers/firmware/efi/libstub/arm-stub.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index 6920033..40396e1 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -146,12 +146,12 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 		goto fail;
 	}
 
-	if (IS_ENABLED(CONFIG_CMDLINE_EXTEND) ||
-	    IS_ENABLED(CONFIG_CMDLINE_FORCE) ||
-	    cmdline_size == 0)
-		efi_parse_options(CONFIG_CMDLINE);
+	#if IS_ENABLED(CONFIG_CMDLINE_BOOL)
+		efi_parse_options(CONFIG_CMDLINE_PREPEND);
+		efi_parse_options(CONFIG_CMDLINE_APPEND);
+	#endif
 
-	if (!IS_ENABLED(CONFIG_CMDLINE_FORCE) && cmdline_size > 0)
+	if (!IS_ENABLED(CONFIG_CMDLINE_OVERRIDE) && cmdline_size > 0)
 		efi_parse_options(cmdline_ptr);
 
 	pr_efi(sys_table, "Booting Linux Kernel...\n");
-- 
2.7.4
