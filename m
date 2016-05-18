From: Alex Thorlton <athorlton@sgi.com>
Subject: [PATCH 1/3] Convert efi_call_virt to efi_call_virt_generic
Date: Wed, 18 May 2016 14:11:39 -0500
Message-ID: <1463598701-178201-2-git-send-email-athorlton@sgi.com>
References: <1463598701-178201-1-git-send-email-athorlton@sgi.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1463598701-178201-1-git-send-email-athorlton@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alex Thorlton <athorlton@sgi.com>, Matt Fleming <matt@codeblueprint.co.uk>, Borislav Petkov <bp@suse.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Mike Travis <travis@sgi.com>, Russ Anderson <rja@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>, x86@kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

This commit makes a few slight modifications to the efi_call_virt macro
to get it to work with function pointers that are stored in locations
other than efi.systab->runtime, and renames the macro to
efi_call_virt_generic.  The majority of the changes here are to pull
these macros up into header files so that they can be accessed from
outside of drivers/firmware/efi/runtime-wrappers.c.

The most significant change not directly related to the code move is to
add an extra "p" argument into the appropriate efi_call macros, and use
that new argument in place of the, formerly hard-coded,
efi.systab->runtime pointer.

The last piece of the puzzle was to add an efi_call_virt macro back into
drivers/firmware/efi/runtime-wrappers.c to wrap around the new
efi_call_virt_generic macro - this was mainly to keep the code from
looking too cluttered by adding a bunch of extra references to
efi.systab->runtime everywhere.

Note that I also broke up the code in the efi_call_virt_generic macro a
bit in the process of moving it.

Signed-off-by: Alex Thorlton <athorlton@sgi.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Borislav Petkov <bp@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mike Travis <travis@sgi.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>
Cc: x86@kernel.org
Cc: linux-efi@vger.kernel.org
---
 arch/x86/include/asm/efi.h              |  4 +--
 drivers/firmware/efi/runtime-wrappers.c | 53 +++++++--------------------------
 include/linux/efi.h                     | 51 +++++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+), 45 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 78d1e74..f310f0b 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -81,8 +81,8 @@ struct efi_scratch {
 	}								\
 })
 
-#define arch_efi_call_virt(f, args...)					\
-	efi_call((void *)efi.systab->runtime->f, args)			\
+#define arch_efi_call_virt(p, f, args...)					\
+	efi_call((void *)p->f, args)			\
 
 #define arch_efi_call_virt_teardown()					\
 ({									\
diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index 23bef6b..e8bc493 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -22,7 +22,16 @@
 #include <linux/stringify.h>
 #include <asm/efi.h>
 
-static void efi_call_virt_check_flags(unsigned long flags, const char *call)
+/*
+ * Wrap around the new efi_call_virt_generic macros so that the
+ * code doesn't get too cluttered
+ */
+#define efi_call_virt(f, args...)   \
+	efi_call_virt_generic(efi.systab->runtime, f, args)
+#define __efi_call_virt(f, args...) \
+	__efi_call_virt_generic(efi.systab->runtime, f, args)
+
+void efi_call_virt_check_flags(unsigned long flags, const char *call)
 {
 	unsigned long cur_flags, mismatch;
 
@@ -39,48 +48,6 @@ static void efi_call_virt_check_flags(unsigned long flags, const char *call)
 }
 
 /*
- * Arch code can implement the following three template macros, avoiding
- * reptition for the void/non-void return cases of {__,}efi_call_virt:
- *
- *  * arch_efi_call_virt_setup
- *
- *    Sets up the environment for the call (e.g. switching page tables,
- *    allowing kernel-mode use of floating point, if required).
- *
- *  * arch_efi_call_virt
- *
- *    Performs the call. The last expression in the macro must be the call
- *    itself, allowing the logic to be shared by the void and non-void
- *    cases.
- *
- *  * arch_efi_call_virt_teardown
- *
- *    Restores the usual kernel environment once the call has returned.
- */
-
-#define efi_call_virt(f, args...)					\
-({									\
-	efi_status_t __s;						\
-	unsigned long flags;						\
-	arch_efi_call_virt_setup();					\
-	local_save_flags(flags);					\
-	__s = arch_efi_call_virt(f, args);				\
-	efi_call_virt_check_flags(flags, __stringify(f));		\
-	arch_efi_call_virt_teardown();					\
-	__s;								\
-})
-
-#define __efi_call_virt(f, args...)					\
-({									\
-	unsigned long flags;						\
-	arch_efi_call_virt_setup();					\
-	local_save_flags(flags);					\
-	arch_efi_call_virt(f, args);					\
-	efi_call_virt_check_flags(flags, __stringify(f));		\
-	arch_efi_call_virt_teardown();					\
-})
-
-/*
  * According to section 7.1 of the UEFI spec, Runtime Services are not fully
  * reentrant, and there are particular combinations of calls that need to be
  * serialized. (source: UEFI Specification v2.4A)
diff --git a/include/linux/efi.h b/include/linux/efi.h
index df7acb5..8d1117ae 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1471,4 +1471,55 @@ efi_status_t efi_setup_gop(efi_system_table_t *sys_table_arg,
 			   unsigned long size);
 
 bool efi_runtime_disabled(void);
+extern void efi_call_virt_check_flags(unsigned long flags, const char *call);
+
+/*
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
+#define efi_call_virt_generic(p, f, args...)					\
+({									\
+	efi_status_t __s;						\
+	unsigned long flags;						\
+									\
+	arch_efi_call_virt_setup();					\
+									\
+	local_save_flags(flags);					\
+	__s = arch_efi_call_virt(p, f, args);				\
+	efi_call_virt_check_flags(flags, __stringify(f));		\
+									\
+	arch_efi_call_virt_teardown();					\
+									\
+	__s;								\
+})
+
+#define __efi_call_virt_generic(p, f, args...)					\
+({									\
+	unsigned long flags;						\
+									\
+	arch_efi_call_virt_setup();					\
+									\
+	local_save_flags(flags);					\
+	arch_efi_call_virt(p, f, args);					\
+	efi_call_virt_check_flags(flags, __stringify(f));		\
+									\
+	arch_efi_call_virt_teardown();					\
+})
+
 #endif /* _LINUX_EFI_H */
-- 
1.8.5.6
