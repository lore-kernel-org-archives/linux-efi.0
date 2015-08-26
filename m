From: Leif Lindholm <leif.lindholm@linaro.org>
Subject: [PATCH 1/3] efi/x86: move efi=debug option parsing to core
Date: Wed, 26 Aug 2015 14:24:56 +0100
Message-ID: <1440595498-30630-2-git-send-email-leif.lindholm@linaro.org>
References: <1440595498-30630-1-git-send-email-leif.lindholm@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1440595498-30630-1-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, matt.fleming@intel.com, ard.biesheuvel@linaro.org, msalter@redhat.com
List-Id: linux-efi@vger.kernel.org

fed6cefe3b6e ("x86/efi: Add a "debug" option to the efi= cmdline")
adds the DBG flag, but does so for x86 only. Move this early param
parsing to core code.

Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
---
 arch/x86/platform/efi/efi.c | 2 --
 drivers/firmware/efi/efi.c  | 3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index e4308fe..9757b79 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -979,8 +979,6 @@ static int __init arch_parse_efi_cmdline(char *str)
 
 	if (parse_option_str(str, "old_map"))
 		set_bit(EFI_OLD_MEMMAP, &efi.flags);
-	if (parse_option_str(str, "debug"))
-		set_bit(EFI_DBG, &efi.flags);
 
 	return 0;
 }
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index d6144e3..78de0bd 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -63,6 +63,9 @@ static int __init parse_efi_cmdline(char *str)
 		return -EINVAL;
 	}
 
+	if (parse_option_str(str, "debug"))
+		set_bit(EFI_DBG, &efi.flags);
+
 	if (parse_option_str(str, "noruntime"))
 		disable_runtime = true;
 
-- 
2.1.4
