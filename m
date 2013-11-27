From: Roy Franz <roy.franz@linaro.org>
Subject: [PATCH V5 6/6] Add config EFI_STUB for ARM to Kconfig
Date: Wed, 27 Nov 2013 15:31:55 -0800
Message-ID: <1385595115-21488-7-git-send-email-roy.franz@linaro.org>
References: <1385595115-21488-1-git-send-email-roy.franz@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1385595115-21488-1-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com, linux@arm.linux.org.uk
Cc: leif.lindholm@linaro.org, grant.likely@linaro.org, dave.martin@arm.com, msalter@redhat.com, patches@linaro.org, Roy Franz <roy.franz@linaro.org>
List-Id: linux-efi@vger.kernel.org

Signed-off-by: Roy Franz <roy.franz@linaro.org>
---
 arch/arm/Kconfig |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index a1b4758..6601985 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1857,6 +1857,16 @@ config EFI
 	  This option is only useful on systems that have UEFI firmware.
 	  However, even with this option, the resultant kernel will
 	  continue to boot on non-UEFI platforms.
+config EFI_STUB
+	bool "EFI stub support"
+	depends on EFI && !CPU_BIG_ENDIAN
+	---help---
+	  This kernel feature allows a zImage to be loaded directly
+	  by EFI firmware without the use of a bootloader.  A PE/COFF
+	  header is added to the zImage in a way that makes the binary
+	  both a Linux zImage and an PE/COFF executable that can be
+	  executed directly by EFI firmware.
+	  See Documentation/efi-stub.txt for more information.
 
 config SECCOMP
 	bool
-- 
1.7.10.4
