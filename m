From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCHv2 1/5] efi/runtime-wrappers: add {__,}efi_call_virt templates
Date: Thu, 21 Apr 2016 12:35:25 +0100
Message-ID: <1461238529-12810-2-git-send-email-mark.rutland@arm.com>
References: <1461238529-12810-1-git-send-email-mark.rutland@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1461238529-12810-1-git-send-email-mark.rutland@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org
Cc: ard.biesheuvel@linaro.org, catalin.marinas@arm.com, hpa@zytor.com, leif.lindholm@linaro.org, linux@arm.linux.org.uk, mark.rutland@arm.com, matt@codeblueprint.co.uk, mingo@redhat.com, tglx@linutronix.de, will.deacon@arm.com, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Currently each architecture must implement two macros, efi_call_virt and
__efi_call_virt, which only differ by the presence or absence of a
return type. Otherwise, the logic surrounding the call is identical.

As each architecture must define the entire body of each, we can't place
any generic manipulation (e.g. irq flag validation) in the middle.

This patch adds template implementations of these macros. With these,
arch code can implement three template macros, avoiding reptition for
the void/non-void return cases:

* arch_efi_call_virt_setup

  Sets up the environment for the call (e.g. switching page tables,
  allowing kernel-mode use of floating point, if required).

* arch_efi_call_virt

  Performs the call. The last expression in the macro must be the call
  itself, allowing the logic to be shared by the void and non-void
  cases.

* arch_efi_call_virt_teardown

  Restores the usual kernel environment once the call has returned.

While the savings from repition are minimal, we additionally gain the
ability to add common code around the call with the call enviroment set
up. This can be used to detect common firmware issues (e.g. bad irq mask
management).

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/firmware/efi/runtime-wrappers.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index de69530..1b9fa54 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -20,6 +20,27 @@
 #include <linux/spinlock.h>
 #include <asm/efi.h>
 
+
+#ifndef efi_call_virt
+#define efi_call_virt(f, args...)					\
+({									\
+	efi_status_t __s;						\
+	arch_efi_call_virt_setup();					\
+	__s = arch_efi_call_virt(f, args);				\
+	arch_efi_call_virt_teardown();					\
+	__s;								\
+})
+#endif
+
+#ifndef __efi_call_virt
+#define __efi_call_virt(f, args...)					\
+({									\
+	arch_efi_call_virt_setup();					\
+	arch_efi_call_virt(f, args);					\
+	arch_efi_call_virt_teardown();					\
+})
+#endif
+
 /*
  * According to section 7.1 of the UEFI spec, Runtime Services are not fully
  * reentrant, and there are particular combinations of calls that need to be
-- 
1.9.1
