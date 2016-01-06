From: Sylvain Chouleur <sylvain.chouleur@gmail.com>
Subject: [PATCH v2 3/3] efi: implement interruptible runtime services
Date: Wed,  6 Jan 2016 23:33:57 +0100
Message-ID: <1452119637-10958-4-git-send-email-sylvain.chouleur@gmail.com>
References: <1450434591-31104-1-git-send-email-sylvain.chouleur@gmail.com>
 <1452119637-10958-1-git-send-email-sylvain.chouleur@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1452119637-10958-1-git-send-email-sylvain.chouleur@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: sylvain.chouleur@gmail.com
Cc: Sylvain Chouleur <sylvain.chouleur@intel.com>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-efi@vger.kernel.org

From: Sylvain Chouleur <sylvain.chouleur@intel.com>

This patch adds an implementation of EFI runtime services wappers which
allow interrupts and preemption during execution of BIOS code.

It's needed by Broxton platform which requires the OS to do the write
of the non volatile variables. To do that, the OS will receive an
interrupt coming from the firmware to notify that it must write the
data.

BIOS code must be executed using a specific PGD. This is currently
done by efi_call() which force value of CR3 before calling BIOS and
restore previous value after.

We use a dedicated kthread which will execute all interruptible runtime
services. This efi_kthread is special because it has it's own mm_struct
whereas kthread should not have one. This mm_struct contains the EFI PGD
so the scheduler will load it before running any BIOS code.

Obviously, an interruptible runtime service must never be called from an
interrupt context. EFI pstore is the only use case here, that's why we
require it to be disabled when activating interruptible runtime services.

Signed-off-by: Sylvain Chouleur <sylvain.chouleur@intel.com>
---
 arch/x86/Kconfig                          |  17 +++
 arch/x86/include/asm/efi.h                |   1 +
 arch/x86/platform/efi/Makefile            |   1 +
 arch/x86/platform/efi/efi_32.c            |   5 +
 arch/x86/platform/efi/efi_64.c            |   5 +
 arch/x86/platform/efi/efi_interruptible.c | 191 ++++++++++++++++++++++++++++++
 6 files changed, 220 insertions(+)
 create mode 100644 arch/x86/platform/efi/efi_interruptible.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index db3622f22b61..37301516f4e6 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1720,6 +1720,23 @@ config EFI_MIXED
 
 	   If unsure, say N.
 
+if X86_64
+config EFI_INTERRUPTIBLE
+	bool "Interruptible Efi Runtime Services"
+	depends on EFI && !EFI_VARS_PSTORE
+	default n
+	---help---
+	  Only use this if you really know what you are doing, you
+	  possibly risk to break your BIOS.
+
+	  This is an interruptible implementation of efi runtime
+	  services wrappers. If you say Y, BIOS code could be
+	  interrupted and preempted as a standard process. Enable this
+	  only if you are sure that your BIOS will support
+	  interruptible efi calls
+	  In doubt, say "N".
+endif
+
 config SECCOMP
 	def_bool y
 	prompt "Enable seccomp to safely compute untrusted bytecode"
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 0010c78c4998..5e9620b3688b 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -111,6 +111,7 @@ extern void __init efi_memory_uc(u64 addr, unsigned long size);
 extern void __init efi_map_region(efi_memory_desc_t *md);
 extern void __init efi_map_region_fixed(efi_memory_desc_t *md);
 extern void efi_sync_low_kernel_mappings(void);
+extern pgd_t *efi_get_pgd(void);
 extern int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages);
 extern void __init efi_cleanup_page_tables(unsigned long pa_memmap, unsigned num_pages);
 extern void __init old_map_region(efi_memory_desc_t *md);
diff --git a/arch/x86/platform/efi/Makefile b/arch/x86/platform/efi/Makefile
index 2846aaab5103..dcc894d1e603 100644
--- a/arch/x86/platform/efi/Makefile
+++ b/arch/x86/platform/efi/Makefile
@@ -2,3 +2,4 @@ obj-$(CONFIG_EFI) 		+= quirks.o efi.o efi_$(BITS).o efi_stub_$(BITS).o
 obj-$(CONFIG_ACPI_BGRT) += efi-bgrt.o
 obj-$(CONFIG_EARLY_PRINTK_EFI)	+= early_printk.o
 obj-$(CONFIG_EFI_MIXED)		+= efi_thunk_$(BITS).o
+obj-$(CONFIG_EFI_INTERRUPTIBLE)		+= efi_interruptible.o
diff --git a/arch/x86/platform/efi/efi_32.c b/arch/x86/platform/efi/efi_32.c
index ed5b67338294..02a3c616c59e 100644
--- a/arch/x86/platform/efi/efi_32.c
+++ b/arch/x86/platform/efi/efi_32.c
@@ -56,6 +56,11 @@ void __init efi_map_region(efi_memory_desc_t *md)
 void __init efi_map_region_fixed(efi_memory_desc_t *md) {}
 void __init parse_efi_setup(u64 phys_addr, u32 data_len) {}
 
+pgd_t *efi_get_pgd(void)
+{
+	return initial_page_table;
+}
+
 pgd_t * __init efi_call_phys_prolog(void)
 {
 	struct desc_ptr gdt_descr;
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index d347e854a5e4..67cffb69d405 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -143,6 +143,11 @@ void efi_sync_low_kernel_mappings(void)
 		sizeof(pgd_t) * num_pgds);
 }
 
+pgd_t *efi_get_pgd(void)
+{
+	return __va(efi_scratch.efi_pgt);
+}
+
 int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 {
 	unsigned long text;
diff --git a/arch/x86/platform/efi/efi_interruptible.c b/arch/x86/platform/efi/efi_interruptible.c
new file mode 100644
index 000000000000..d1f14fcb12a4
--- /dev/null
+++ b/arch/x86/platform/efi/efi_interruptible.c
@@ -0,0 +1,191 @@
+/*
+ * Copyright (c) 2015 Intel Corporation
+ * Author: Sylvain Chouleur <sylvain.chouleur@intel.com>
+ *
+ * Distributed under the terms of the GNU GPL, version 2
+ */
+
+#include <linux/module.h>
+#include <linux/kthread.h>
+#include <linux/efi.h>
+#include <asm/efi.h>
+
+static DEFINE_KTHREAD_WORKER(efi_kworker);
+
+#define efi_call_interruptible(f, ...)					\
+({									\
+	efi_status_t __s;						\
+	efi_sync_low_kernel_mappings();					\
+	__kernel_fpu_begin();						\
+	__s = efi_call((void *)efi.systab->runtime->f, __VA_ARGS__);	\
+	__kernel_fpu_end();						\
+	__s;								\
+})
+
+struct efi_work {
+	struct kthread_work work;
+	efi_status_t status;
+	unsigned long *name_size;
+	efi_char16_t *name;
+	efi_guid_t *vendor;
+	u32 *attr;
+	unsigned long *data_size;
+	void *data;
+};
+
+static void do_get_next_variable_interruptible(struct kthread_work *work)
+{
+	struct efi_work *ew = container_of(work, struct efi_work, work);
+
+	ew->status = efi_call_interruptible(get_next_variable, ew->name_size,
+					    ew->name, ew->vendor);
+}
+
+static void do_set_variable_interruptible(struct kthread_work *work)
+{
+	struct efi_work *ew = container_of(work, struct efi_work, work);
+
+	ew->status = efi_call_interruptible(set_variable, ew->name, ew->vendor,
+					    *ew->attr, *ew->data_size,
+					    ew->data);
+}
+
+static void do_get_variable_interruptible(struct kthread_work *work)
+{
+	struct efi_work *ew = container_of(work, struct efi_work, work);
+
+	ew->status = efi_call_interruptible(get_variable, ew->name, ew->vendor,
+					    ew->attr, ew->data_size, ew->data);
+}
+
+static efi_status_t execute_service(kthread_work_func_t service,
+				    unsigned long *name_size,
+				    efi_char16_t *name, efi_guid_t *vendor,
+				    u32 *attr, unsigned long *data_size,
+				    void *data)
+{
+	struct efi_work work = {
+		.name_size = name_size,
+		.name = name,
+		.vendor = vendor,
+		.attr = attr,
+		.data_size = data_size,
+		.data = data,
+	};
+
+	init_kthread_work(&work.work, service);
+	queue_kthread_work(&efi_kworker, &work.work);
+
+	flush_kthread_work(&work.work);
+	return work.status;
+}
+
+static efi_status_t get_next_variable_interruptible(unsigned long *name_size,
+					       efi_char16_t *name,
+					       efi_guid_t *vendor)
+{
+	return execute_service(do_get_next_variable_interruptible,
+			       name_size, name, vendor, NULL, NULL, NULL);
+}
+
+static efi_status_t set_variable_interruptible(efi_char16_t *name,
+					  efi_guid_t *vendor,
+					  u32 attr,
+					  unsigned long data_size,
+					  void *data)
+{
+	return execute_service(do_set_variable_interruptible,
+			       NULL, name, vendor, &attr, &data_size, data);
+}
+
+static efi_status_t
+non_blocking_not_allowed(__attribute__((unused)) efi_char16_t *name,
+			 __attribute__((unused)) efi_guid_t *vendor,
+			 __attribute__((unused)) u32 attr,
+			 __attribute__((unused)) unsigned long data_size,
+			 __attribute__((unused)) void *data)
+{
+	pr_err("efi_interruptible: non blocking operation is not allowed\n");
+	return EFI_UNSUPPORTED;
+}
+
+static efi_status_t get_variable_interruptible(efi_char16_t *name,
+					  efi_guid_t *vendor,
+					  u32 *attr,
+					  unsigned long *data_size,
+					  void *data)
+{
+	return execute_service(do_get_variable_interruptible,
+			       NULL, name, vendor, attr, data_size, data);
+}
+
+static struct efivars interruptible_efivars;
+
+static int efi_interruptible_panic_notifier_call(
+	struct notifier_block *notifier,
+	unsigned long what, void *data)
+{
+	static struct efivars generic_efivars;
+	static struct efivar_operations generic_ops;
+
+	generic_ops.get_variable = efi.get_variable;
+	generic_ops.set_variable = efi.set_variable;
+	generic_ops.get_next_variable = efi.get_next_variable;
+	generic_ops.query_variable_store = efi_query_variable_store;
+
+	efivars_register(&generic_efivars, &generic_ops, efivars_kobject());
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block panic_nb = {
+	.notifier_call = efi_interruptible_panic_notifier_call,
+	.priority = 100,
+};
+
+static struct task_struct *efi_kworker_task;
+static struct efivar_operations interruptible_ops;
+static __init int efi_interruptible_init(void)
+{
+	int ret;
+
+	efi_kworker_task = kthread_create(kthread_worker_fn, &efi_kworker,
+					  "efi_kthread");
+	if (IS_ERR(efi_kworker_task)) {
+		pr_err("efi_interruptible: Failed to create kthread\n");
+		ret = PTR_ERR(efi_kworker_task);
+		efi_kworker_task = NULL;
+		return ret;
+	}
+
+	efi_kworker_task->mm = mm_alloc();
+	efi_kworker_task->active_mm = efi_kworker_task->mm;
+	efi_kworker_task->mm->pgd = efi_get_pgd();
+	wake_up_process(efi_kworker_task);
+
+	atomic_notifier_chain_register(&panic_notifier_list, &panic_nb);
+
+	interruptible_ops.get_variable = get_variable_interruptible;
+	interruptible_ops.set_variable = set_variable_interruptible;
+	interruptible_ops.set_variable_nonblocking = non_blocking_not_allowed;
+	interruptible_ops.get_next_variable = get_next_variable_interruptible;
+	interruptible_ops.query_variable_store = efi_query_variable_store;
+	return efivars_register(&interruptible_efivars, &interruptible_ops,
+				efivars_kobject());
+}
+
+static void __exit efi_interruptible_exit(void)
+{
+	efivars_unregister(&interruptible_efivars);
+	atomic_notifier_chain_unregister(&panic_notifier_list, &panic_nb);
+	if (efi_kworker_task) {
+		kthread_stop(efi_kworker_task);
+		mmdrop(efi_kworker_task->mm);
+	}
+}
+
+module_init(efi_interruptible_init);
+module_exit(efi_interruptible_exit);
+
+MODULE_AUTHOR("Sylvain Chouleur <sylvain.chouleur@intel.com>");
+MODULE_LICENSE("GPL");
-- 
2.6.4
