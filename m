From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCHv2 5/6] efi/runtime-wrappers: remove redundant ifdefs
Date: Fri, 22 Apr 2016 14:51:22 +0100
Message-ID: <1461333083-15529-6-git-send-email-mark.rutland@arm.com>
References: <1461333083-15529-1-git-send-email-mark.rutland@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1461333083-15529-1-git-send-email-mark.rutland@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org
Cc: ard.biesheuvel@linaro.org, catalin.marinas@arm.com, hpa@zytor.com, leif.lindholm@linaro.org, linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org, mark.rutland@arm.com, matt@codeblueprint.co.uk, mingo@redhat.com, tglx@linutronix.de, will.deacon@arm.com
List-Id: linux-efi@vger.kernel.org

Now that all users of the EFI runtime wrappers (arm,arm64,x86) have been
migrated to the new setup/teardown macros, we don't need to support
overridden {__,}efi_call_virt implementations.

This patch removes the unnecessary ifdefs.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Leif Lindholm <leif.lindholm@linaro.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/firmware/efi/runtime-wrappers.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index 1b9fa54..a2c8e70 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -20,8 +20,6 @@
 #include <linux/spinlock.h>
 #include <asm/efi.h>
 
-
-#ifndef efi_call_virt
 #define efi_call_virt(f, args...)					\
 ({									\
 	efi_status_t __s;						\
@@ -30,16 +28,13 @@
 	arch_efi_call_virt_teardown();					\
 	__s;								\
 })
-#endif
 
-#ifndef __efi_call_virt
 #define __efi_call_virt(f, args...)					\
 ({									\
 	arch_efi_call_virt_setup();					\
 	arch_efi_call_virt(f, args);					\
 	arch_efi_call_virt_teardown();					\
 })
-#endif
 
 /*
  * According to section 7.1 of the UEFI spec, Runtime Services are not fully
-- 
1.9.1
