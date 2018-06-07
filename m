From: Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH v4 3/3] x86: paravirt: make native_save_fl extern inline
Date: Thu,  7 Jun 2018 13:49:27 -0700
Message-ID: <20180607204927.219329-4-ndesaulniers@google.com>
References: <20180607204927.219329-1-ndesaulniers@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180607204927.219329-1-ndesaulniers@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, virtualization@lists.linux-foundation.org, astrachan@google.com, manojgupta@google.com, ghackmann@google.com, sedat.dilek@gmail.com, tstellar@redhat.com, keescook@google.com, yamada.masahiro@socionext.com, michal.lkml@markovi.net, linux-kbuild@vger.kernel.org, geert@linux-m68k.org, will.deacon@arm.com, mawilcox@microsoft.com, arnd@arndb.de, rientjes@google.com, acme@redhat.com, pombredanne@nexb.com, aryabinin@virtuozzo.com, kstewart@linuxfoundation.org, boris.ostrovsky@oracle.com, jan.kiszka@siemens.com, rostedt@goodmis.org, kirill.shutemov@linux.intel.com, ard.biesheuvel@linaro.org, akataria@vmware.com, brijesh.singh@amd.com, caoj.fnst@cn.fujitsu.com, gregkh@linuxfoundation.org, jarkko.sakkinen@linux.intel.co
List-Id: linux-efi@vger.kernel.org

native_save_fl() is marked static inline, but by using it as
a function pointer in arch/x86/kernel/paravirt.c, it MUST be outlined.

paravirt's use of native_save_fl() also requires that no GPRs other than
%rax are clobbered.

Compilers have different heuristics which they use to emit stack guard
code, the emittance of which can break paravirt's callee saved assumption
by clobbering %rcx.

Marking a function definition extern inline means that if this version
cannot be inlined, then the out-of-line version will be preferred. By
having the out-of-line version be implemented in assembly, it cannot be
instrumented with a stack protector, which might violate custom calling
conventions that code like paravirt rely on.

The semantics of extern inline has changed since gnu89. This means that
folks using GCC versions >= 5.1 may see symbol redefinition errors at
link time for subdirs that override KBUILD_CFLAGS (making the C standard
used implicit) regardless of this patch. This has been cleaned up
earlier in the patch set, but is left as a note in the commit message
for future travelers.

Reports:
https://lkml.org/lkml/2018/5/7/534
https://github.com/ClangBuiltLinux/linux/issues/16

Discussion:
https://bugs.llvm.org/show_bug.cgi?id=37512
https://lkml.org/lkml/2018/5/24/1371

Thanks to the many folks that participated in the discussion.

Debugged-by: Alistair Strachan <astrachan@google.com>
Debugged-by: Matthias Kaehlcke <mka@chromium.org>
Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Suggested-by: H. Peter Anvin <hpa@zytor.com>
Suggested-by: Tom Stellar <tstellar@redhat.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 arch/x86/include/asm/irqflags.h |  2 +-
 arch/x86/kernel/Makefile        |  1 +
 arch/x86/kernel/irqflags.S      | 26 ++++++++++++++++++++++++++
 3 files changed, 28 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kernel/irqflags.S

diff --git a/arch/x86/include/asm/irqflags.h b/arch/x86/include/asm/irqflags.h
index 89f08955fff7..c4fc17220df9 100644
--- a/arch/x86/include/asm/irqflags.h
+++ b/arch/x86/include/asm/irqflags.h
@@ -13,7 +13,7 @@
  * Interrupt control:
  */
 
-static inline unsigned long native_save_fl(void)
+extern inline unsigned long native_save_fl(void)
 {
 	unsigned long flags;
 
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 02d6f5cf4e70..8824d01c0c35 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -61,6 +61,7 @@ obj-y			+= alternative.o i8253.o hw_breakpoint.o
 obj-y			+= tsc.o tsc_msr.o io_delay.o rtc.o
 obj-y			+= pci-iommu_table.o
 obj-y			+= resource.o
+obj-y			+= irqflags.o
 
 obj-y				+= process.o
 obj-y				+= fpu/
diff --git a/arch/x86/kernel/irqflags.S b/arch/x86/kernel/irqflags.S
new file mode 100644
index 000000000000..ddeeaac8adda
--- /dev/null
+++ b/arch/x86/kernel/irqflags.S
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#include <asm/asm.h>
+#include <asm/export.h>
+#include <linux/linkage.h>
+
+/*
+ * unsigned long native_save_fl(void)
+ */
+ENTRY(native_save_fl)
+	pushf
+	pop %_ASM_AX
+	ret
+ENDPROC(native_save_fl)
+EXPORT_SYMBOL(native_save_fl)
+
+/*
+ * void native_restore_fl(unsigned long flags)
+ * %eax/%rdi: flags
+ */
+ENTRY(native_restore_fl)
+	push %_ASM_ARG1
+	popf
+	ret
+ENDPROC(native_restore_fl)
+EXPORT_SYMBOL(native_restore_fl)
-- 
2.17.1.1185.g55be947832-goog
