From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH 31/40] efi/runtime-wrappers: Add {__,}efi_call_virt templates
Date: Mon, 25 Apr 2016 21:07:03 +0100
Message-ID: <1461614832-17633-32-git-send-email-matt@codeblueprint.co.uk>
References: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461614832-17633-1-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>

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
ability to add common code around the call with the call environment set
up. This can be used to detect common firmware issues (e.g. bad irq mask
management).

Signed-off-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Reviewed-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 drivers/firmware/efi/runtime-wrappers.c | 40 +++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index de6953039af6..0677577bdaa1 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -21,6 +21,46 @@
 #include <asm/efi.h>
 
 /*
+ * Arch code can implement the following three template macros, avoiding
+ * reptition for the void/non-void return cases of {__,}efi_call_virt:
+ *
+ *  * arch_efi_call_virt_setup
+ *
+ *    Sets up the environment for the call (e.g. switching page tables,
+ *    allowing kernel-mode use of floating point, if required).
+ *
+ *  * arch_efi_call_virt
+ *
+ *    Performs the call. The last expression in the macro must be the call
+ *    itself, allowing the logic to be shared by the void and non-void
+ *    cases.
+ *
+ *  * arch_efi_call_virt_teardown
+ *
+ *    Restores the usual kernel environment once the call has returned.
+ */
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
+/*
  * According to section 7.1 of the UEFI spec, Runtime Services are not fully
  * reentrant, and there are particular combinations of calls that need to be
  * serialized. (source: UEFI Specification v2.4A)
-- 
2.7.3
