From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Subject: [PATCH V4 2/3] x86/efi: Add efi page fault handler to recover from page faults caused by the firmware
Date: Thu,  6 Sep 2018 16:27:47 -0700
Message-ID: <1536276468-28499-3-git-send-email-sai.praneeth.prakhya@intel.com>
References: <1536276468-28499-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1536276468-28499-1-git-send-email-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc: ricardo.neri@intel.com, matt@codeblueprint.co.uk, Sai Praneeth <sai.praneeth.prakhya@intel.com>, Al Stone <astone@redhat.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Bhupesh Sharma <bhsharma@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

As per the UEFI specification, after the call to ExitBootServices(),
accesses by the firmware to any memory regions except
EFI_RUNTIME_SERVICES_<CODE/DATA> regions is considered illegal. A buggy
firmware could trigger these illegal accesses when an efi runtime
service is invoked and if this happens when the kernel is up and
running, the kernel hangs.

Kernel hangs because the memory region requested by the firmware isn't
mapped in efi_pgd, which causes a page fault in ring 0 and the kernel
fails to handle it, leading to die(). To save kernel from hanging, add
an efi specific page fault handler which recovers from such faults by
1. If the efi runtime service is efi_reset_system(), reboot the machine
   through BIOS.
2. If the efi runtime service is _not_ efi_reset_system(), then, freeze
   efi_rts_wq and schedule a new process.

The efi page fault handler offers us two advantages:
1. Recovers from potential hangs that could be caused by buggy firmware.
2. Shout loud that the firmware is buggy and hence is not a kernel bug.

Suggested-by: Matt Fleming <matt@codeblueprint.co.uk>
Based-on-code-from: Ricardo Neri <ricardo.neri@intel.com>
Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: Al Stone <astone@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Bhupesh Sharma <bhsharma@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/include/asm/efi.h              |  9 +++++
 arch/x86/mm/fault.c                     |  9 +++++
 arch/x86/platform/efi/quirks.c          | 70 +++++++++++++++++++++++++++++++++
 drivers/firmware/efi/runtime-wrappers.c |  7 ++++
 include/linux/efi.h                     |  1 +
 5 files changed, 96 insertions(+)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index cec5fae23eb3..afb1c80182f2 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -141,6 +141,15 @@ extern int __init efi_reuse_config(u64 tables, int nr_tables);
 extern void efi_delete_dummy_variable(void);
 extern void efi_switch_mm(struct mm_struct *mm);
 
+#ifdef CONFIG_EFI_PAGE_FAULT_HANDLER
+extern int efi_recover_from_page_fault(unsigned long phys_addr);
+#else
+static inline int efi_recover_from_page_fault(unsigned long phys_addr)
+{
+	return 0;
+}
+#endif /* CONFIG_EFI_PAGE_FAULT_HANDLER */
+
 struct efi_setup_data {
 	u64 fw_vendor;
 	u64 runtime;
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 2aafa6ab6103..cc2a2e3a4095 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -16,6 +16,7 @@
 #include <linux/prefetch.h>		/* prefetchw			*/
 #include <linux/context_tracking.h>	/* exception_enter(), ...	*/
 #include <linux/uaccess.h>		/* faulthandler_disabled()	*/
+#include <linux/efi.h>			/* efi_recover_from_page_fault()*/
 
 #include <asm/cpufeature.h>		/* boot_cpu_has, ...		*/
 #include <asm/traps.h>			/* dotraplinkage, ...		*/
@@ -24,6 +25,7 @@
 #include <asm/vsyscall.h>		/* emulate_vsyscall		*/
 #include <asm/vm86.h>			/* struct vm86			*/
 #include <asm/mmu_context.h>		/* vma_pkey()			*/
+#include <asm/efi.h>			/* efi_recover_from_page_fault()*/
 
 #define CREATE_TRACE_POINTS
 #include <asm/trace/exceptions.h>
@@ -790,6 +792,13 @@ no_context(struct pt_regs *regs, unsigned long error_code,
 		return;
 
 	/*
+	 * Buggy firmware could access regions which might page fault, try to
+	 * recover from such faults.
+	 */
+	if (efi_recover_from_page_fault(address))
+		return;
+
+	/*
 	 * Oops. The kernel tried to access some bad page. We'll have to
 	 * terminate things with extreme prejudice:
 	 */
diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 844d31cb8a0c..853742aba209 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -16,6 +16,7 @@
 #include <asm/efi.h>
 #include <asm/uv/uv.h>
 #include <asm/cpu_device_id.h>
+#include <asm/reboot.h>
 
 #define EFI_MIN_RESERVE 5120
 
@@ -654,3 +655,72 @@ int efi_capsule_setup_info(struct capsule_info *cap_info, void *kbuff,
 }
 
 #endif
+
+#ifdef CONFIG_EFI_PAGE_FAULT_HANDLER
+
+/*
+ * If any access by any efi runtime service causes a page fault, then,
+ * 1. If it's efi_reset_system(), reboot through BIOS.
+ * 2. If any other efi runtime service, then
+ *    a. Freeze efi_rts_wq.
+ *    b. Return error status to the efi caller process.
+ *    c. Disable EFI Runtime Services forever and
+ *    d. Schedule another process by explicitly calling scheduler.
+ *
+ * @return: Returns 0, if the page fault is not handled. This function
+ * will never return if the page fault is handled successfully.
+ */
+int efi_recover_from_page_fault(unsigned long phys_addr)
+{
+	/* Recover from page faults caused *only* by the firmware */
+	if (current->active_mm != &efi_mm)
+		return 0;
+
+	/*
+	 * Address range 0x0000 - 0x0fff is always mapped in the efi_pgd, so
+	 * page faulting on these addresses isn't expected.
+	 */
+	if (phys_addr >= 0x0000 && phys_addr <= 0x0fff)
+		return 0;
+
+	/*
+	 * Print stack trace as it might be useful to know which EFI Runtime
+	 * Service is buggy.
+	 */
+	WARN(1, FW_BUG "Page fault caused by firmware at PA: 0x%lx\n",
+	     phys_addr);
+
+	/*
+	 * Buggy efi_reset_system() is handled differently from other EFI
+	 * Runtime Services as it doesn't use efi_rts_wq. Although,
+	 * native_machine_emergency_restart() says that machine_real_restart()
+	 * could fail, it's better not to compilcate this fault handler
+	 * because this case occurs *very* rarely and hence could be improved
+	 * on a need by basis.
+	 */
+	if (efi_rts_work.efi_rts_id == RESET_SYSTEM) {
+		pr_info("efi_reset_system() buggy! Reboot through BIOS\n");
+		machine_real_restart(MRR_BIOS);
+		return 0;
+	}
+
+	/* Firmware has caused page fault, hence, freeze efi_rts_wq. */
+	set_current_state(TASK_UNINTERRUPTIBLE);
+
+	/*
+	 * Before calling EFI Runtime Service, the kernel has switched the
+	 * calling process to efi_mm. Hence, switch back to task_mm.
+	 */
+	arch_efi_call_virt_teardown();
+
+	/* Signal error status to the efi caller process */
+	efi_rts_work.status = EFI_ABORTED;
+	complete(&efi_rts_work.efi_rts_comp);
+
+	clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
+	pr_info("Froze efi_rts_wq and disabled EFI Runtime Services\n");
+	schedule();
+
+	return 0;
+}
+#endif /* CONFIG_EFI_PAGE_FAULT_HANDLER */
diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index b18b2d864c2c..de061bcad098 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -61,6 +61,11 @@ struct efi_runtime_work efi_rts_work;
 ({									\
 	efi_rts_work.status = EFI_ABORTED;				\
 									\
+	if (!efi_enabled(EFI_RUNTIME_SERVICES)) {			\
+		pr_info("Aborting! EFI Runtime Services disabled\n");	\
+		goto exit;						\
+	}								\
+									\
 	init_completion(&efi_rts_work.efi_rts_comp);			\
 	INIT_WORK_ONSTACK(&efi_rts_work.work, efi_call_rts);		\
 	efi_rts_work.arg1 = _arg1;					\
@@ -79,6 +84,7 @@ struct efi_runtime_work efi_rts_work;
 	else								\
 		pr_err("Failed to queue work to efi_rts_wq.\n");	\
 									\
+exit:									\
 	efi_rts_work.status;						\
 })
 
@@ -393,6 +399,7 @@ static void virt_efi_reset_system(int reset_type,
 			"could not get exclusive access to the firmware\n");
 		return;
 	}
+	efi_rts_work.efi_rts_id = RESET_SYSTEM;
 	__efi_call_virt(reset_system, reset_type, status, data_size, data);
 	up(&efi_runtime_lock);
 }
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 855992b15269..80433b6bd2c5 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1670,6 +1670,7 @@ enum efi_rts_ids {
 	SET_VARIABLE,
 	QUERY_VARIABLE_INFO,
 	GET_NEXT_HIGH_MONO_COUNT,
+	RESET_SYSTEM,
 	UPDATE_CAPSULE,
 	QUERY_CAPSULE_CAPS,
 };
-- 
2.7.4
