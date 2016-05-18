From: Alex Thorlton <athorlton@sgi.com>
Subject: [PATCH 3/3] Update efi_thunk to use efi_call_virt_generic
Date: Wed, 18 May 2016 14:11:41 -0500
Message-ID: <1463598701-178201-4-git-send-email-athorlton@sgi.com>
References: <1463598701-178201-1-git-send-email-athorlton@sgi.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1463598701-178201-1-git-send-email-athorlton@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alex Thorlton <athorlton@sgi.com>, Matt Fleming <matt@codeblueprint.co.uk>, Borislav Petkov <bp@suse.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Mike Travis <travis@sgi.com>, Russ Anderson <rja@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>, x86@kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Now that we have efi_call_virt_generic, we no longer need to have an
entirely separate efi_thunk macro to handle the CONFIG_EFI_MIXED
scenario, where the function pointers cannot be read directly out of
efi.systab->runtime.

This commit creates a new set of arch_efi_call_virt* macros to mimic the
behavior of the old efi_thunk macro.  In the end, the code should be the
same, functionally, but we'll have eliminated a good chunk of code
duplication by splitting the efi_thunk macro up into the appropriate
arch_efi_call_virt bits and then just calling efi_call_virt_generic,
instead of efi_thunk.  I do go ahead and create a new efi_thunk macro in
arch/x86/platform/efi/efi_64.c, but this is mainly to keep the existing
code clean.

One thing to note here, is that this is not and absolutely *perfect* use
of the efi_call_virt_generic macro, in that it still has the
efi.systab->runtime pointer hard-coded into runtime_service32.  For now,
I think this should be fine, as the only users of the function already
assumed that this was where their function pointer would come from.  If
another CONFIG_EFI_MIXED user comes along and needs to use
efi_call_virt_generic, then we will need to re-think things a bit.

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
 arch/x86/include/asm/efi.h     | 47 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/platform/efi/efi_64.c | 49 ++++++++++--------------------------------
 2 files changed, 58 insertions(+), 38 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index f310f0b..6643f9b 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -68,6 +68,52 @@ struct efi_scratch {
 	u64	phys_stack;
 } __packed;
 
+#ifdef CONFIG_EFI_MIXED
+extern efi_status_t efi64_thunk(u32, ...);
+
+#define runtime_service32(func)						 \
+({									 \
+	u32 table = (u32)(unsigned long)efi.systab;			 \
+	u32 *rt, *___f;							 \
+									 \
+	rt = (u32 *)(table + offsetof(efi_system_table_32_t, runtime));	 \
+	___f = (u32 *)(*rt + offsetof(efi_runtime_services_32_t, func)); \
+	*___f;								 \
+})
+
+/*
+ * Switch to the EFI page tables early so that we can access the 1:1
+ * runtime services mappings which are not mapped in any other page
+ * tables. This function must be called before runtime_service32().
+ *
+ * Also, disable interrupts because the IDT points to 64-bit handlers,
+ * which aren't going to function correctly when we switch to 32-bit.
+ */
+#define arch_efi_call_virt_setup()					\
+({									\
+	efi_sync_low_kernel_mappings();					\
+	local_irq_save(flags);						\
+									\
+	efi_scratch.prev_cr3 = read_cr3();				\
+	write_cr3((unsigned long)efi_scratch.efi_pgt);			\
+	__flush_tlb_all();						\
+})
+
+#define arch_efi_call_virt(p, f, ...)					\
+({									\
+	u32 func = runtime_service32(f);				\
+	efi64_thunk(func, __VA_ARGS__);					\
+})
+
+#define arch_efi_call_virt_teardown()					\
+({									\
+	write_cr3(efi_scratch.prev_cr3);				\
+	__flush_tlb_all();						\
+	local_irq_restore(flags);					\
+})
+
+#else /* !CONFIG_EFI_MIXED */
+
 #define arch_efi_call_virt_setup()					\
 ({									\
 	efi_sync_low_kernel_mappings();					\
@@ -94,6 +140,7 @@ struct efi_scratch {
 	__kernel_fpu_end();						\
 	preempt_enable();						\
 })
+#endif
 
 extern void __iomem *__init efi_ioremap(unsigned long addr, unsigned long size,
 					u32 type, u64 attribute);
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 6e7242b..747bbc3 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -443,48 +443,21 @@ void __init efi_dump_pagetable(void)
 }
 
 #ifdef CONFIG_EFI_MIXED
-extern efi_status_t efi64_thunk(u32, ...);
-
-#define runtime_service32(func)						 \
-({									 \
-	u32 table = (u32)(unsigned long)efi.systab;			 \
-	u32 *rt, *___f;							 \
-									 \
-	rt = (u32 *)(table + offsetof(efi_system_table_32_t, runtime));	 \
-	___f = (u32 *)(*rt + offsetof(efi_runtime_services_32_t, func)); \
-	*___f;								 \
-})
 
 /*
- * Switch to the EFI page tables early so that we can access the 1:1
- * runtime services mappings which are not mapped in any other page
- * tables. This function must be called before runtime_service32().
+ * Note that we pass in NULL here instead of the systab/function name combo
+ * that usually gets us what we need.  This is because the EFI_MIXED code
+ * still assumes that all EFI callback function pointers will be in
+ * efi.systab->runtime.  Currently there are no users in the EFI_MIXED code
+ * that require efi_thunk to behave otherwise.
  *
- * Also, disable interrupts because the IDT points to 64-bit handlers,
- * which aren't going to function correctly when we switch to 32-bit.
+ * If EFI_MIXED users want to call runtime functions that *don't* live in
+ * efi.systab->runtime, runtime_service32 and some of the related macros
+ * will need to be updated to handle this.  Not a major headache, but
+ * something to keep in mind.
  */
-#define efi_thunk(f, ...)						\
-({									\
-	efi_status_t __s;						\
-	unsigned long flags;						\
-	u32 func;							\
-									\
-	efi_sync_low_kernel_mappings();					\
-	local_irq_save(flags);						\
-									\
-	efi_scratch.prev_cr3 = read_cr3();				\
-	write_cr3((unsigned long)efi_scratch.efi_pgt);			\
-	__flush_tlb_all();						\
-									\
-	func = runtime_service32(f);					\
-	__s = efi64_thunk(func, __VA_ARGS__);			\
-									\
-	write_cr3(efi_scratch.prev_cr3);				\
-	__flush_tlb_all();						\
-	local_irq_restore(flags);					\
-									\
-	__s;								\
-})
+#define efi_thunk(f, args...)   \
+	efi_call_virt_generic(NULL, f, args)
 
 efi_status_t efi_thunk_set_virtual_address_map(
 	void *phys_set_virtual_address_map,
-- 
1.8.5.6
