From: Alex Thorlton <athorlton@sgi.com>
Subject: [PATCH 1/2] Create UV efi_call macros
Date: Wed, 11 May 2016 14:55:44 -0500
Message-ID: <1462996545-98387-2-git-send-email-athorlton@sgi.com>
References: <1462996545-98387-1-git-send-email-athorlton@sgi.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1462996545-98387-1-git-send-email-athorlton@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alex Thorlton <athorlton@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>, Russ Anderson <rja@sgi.com>, Mike Travis <travis@sgi.com>, Matt Fleming <matt@codeblueprint.co.uk>, Borislav Petkov <bp@suse.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

We need a slightly different macro than the standard efi_call_virt,
since those macros all assume that the function pointer, f, that gets
passed in will live somewhere in efi.systab->runtime.  Our EFI function
pointer lives in efi.uv_systab, so we can't use the standard macros out
of the box.

This commit creates some new uv_* macros that are functionally
equivalent to the standard ones, with the exception of allowing us to
use a different function pointer.  I figure that we won't want to call
these uv_* in the end (we'll probably want something more generic), but
I thought I would get everyone's thoughts on how we might best reach
that goal instead of just trying to come up with a new implementation on
my own.

By itself, this commit does get our machines booting, but it needs the
small fix to the efi_call assembly code for our modules to work.

Signed-off-by: Alex Thorlton <athorlton@sgi.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: Mike Travis <travis@sgi.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Borislav Petkov <bp@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: linux-efi@vger.kernel.org
---
 arch/x86/include/asm/efi.h              |  3 ++
 arch/x86/platform/uv/bios_uv.c          |  3 +-
 drivers/firmware/efi/runtime-wrappers.c | 44 +-------------------------
 include/linux/efi.h                     | 55 +++++++++++++++++++++++++++++++++
 4 files changed, 60 insertions(+), 45 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 78d1e74..f384047 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -84,6 +84,9 @@ struct efi_scratch {
 #define arch_efi_call_virt(f, args...)					\
 	efi_call((void *)efi.systab->runtime->f, args)			\
 
+#define uv_efi_call_virt(f, args...)					\
+	efi_call((void *)f, args)			\
+
 #define arch_efi_call_virt_teardown()					\
 ({									\
 	if (efi_scratch.use_pgd) {					\
diff --git a/arch/x86/platform/uv/bios_uv.c b/arch/x86/platform/uv/bios_uv.c
index 815fec6..62a46cb 100644
--- a/arch/x86/platform/uv/bios_uv.c
+++ b/arch/x86/platform/uv/bios_uv.c
@@ -40,8 +40,7 @@ s64 uv_bios_call(enum uv_bios_cmd which, u64 a1, u64 a2, u64 a3, u64 a4, u64 a5)
 		 */
 		return BIOS_STATUS_UNIMPLEMENTED;
 
-	ret = efi_call((void *)__va(tab->function), (u64)which,
-			a1, a2, a3, a4, a5);
+	ret = uv_call_virt(tab->function, (u64)which, a1, a2, a3, a4, a5);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(uv_bios_call);
diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index 23bef6b..008a1a3 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -22,7 +22,7 @@
 #include <linux/stringify.h>
 #include <asm/efi.h>
 
-static void efi_call_virt_check_flags(unsigned long flags, const char *call)
+void efi_call_virt_check_flags(unsigned long flags, const char *call)
 {
 	unsigned long cur_flags, mismatch;
 
@@ -39,48 +39,6 @@ static void efi_call_virt_check_flags(unsigned long flags, const char *call)
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
index df7acb5..f429269 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1471,4 +1471,59 @@ efi_status_t efi_setup_gop(efi_system_table_t *sys_table_arg,
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
+#define efi_call_virt(f, args...)					\
+({									\
+	efi_status_t __s;						\
+	unsigned long flags;						\
+	arch_efi_call_virt_setup();					\
+	local_save_flags(flags);					\
+	__s = arch_efi_call_virt(f, args);				\
+	efi_call_virt_check_flags(flags, __stringify(f));		\
+	arch_efi_call_virt_teardown();					\
+	__s;								\
+})
+
+#define __efi_call_virt(f, args...)					\
+({									\
+	unsigned long flags;						\
+	arch_efi_call_virt_setup();					\
+	local_save_flags(flags);					\
+	arch_efi_call_virt(f, args);					\
+	efi_call_virt_check_flags(flags, __stringify(f));		\
+	arch_efi_call_virt_teardown();					\
+})
+
+#define uv_call_virt(f, args...)					\
+({									\
+	efi_status_t __s;						\
+	unsigned long flags;						\
+	arch_efi_call_virt_setup();					\
+	local_save_flags(flags);					\
+	__s = uv_efi_call_virt(f, args);				\
+	efi_call_virt_check_flags(flags, __stringify(f));		\
+	arch_efi_call_virt_teardown();					\
+	__s;								\
+})
 #endif /* _LINUX_EFI_H */
-- 
1.8.5.6
