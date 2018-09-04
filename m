From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Subject: [PATCH V3 4/5] x86/efi: Add efi page fault handler to recover from the page faults caused by firmware
Date: Tue,  4 Sep 2018 15:12:28 -0700
Message-ID: <1536099149-12564-5-git-send-email-sai.praneeth.prakhya@intel.com>
References: <1536099149-12564-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1536099149-12564-1-git-send-email-sai.praneeth.prakhya@intel.com>
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
an efi specific page fault handler which detects illegal accesses by the
firmware and if the access is to any region other than
EFI_RUNTIME_SERVICES_<CODE/DATA>, then
1. The efi page fault handler freezes efi_rts_wq and schedules a new
   process.
2. If the efi runtime service is efi_reset_system(), then the efi page
   fault handler will reboot the machine through BIOS and not through
   efi_reset_system().

The efi specific page fault handler offers us two advantages:
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
 arch/x86/include/asm/efi.h              |   5 ++
 arch/x86/mm/fault.c                     |   9 ++
 arch/x86/platform/efi/quirks.c          | 140 ++++++++++++++++++++++++++++++++
 drivers/firmware/efi/runtime-wrappers.c |   7 ++
 include/linux/efi.h                     |   1 +
 5 files changed, 162 insertions(+)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 788ed4cbce22..f3d9c3c2359e 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -143,8 +143,13 @@ extern void efi_switch_mm(struct mm_struct *mm);
 
 #ifdef CONFIG_EFI_WARN_ON_ILLEGAL_ACCESS
 extern void __init efi_save_original_memmap(void);
+extern int efi_illegal_accesses_fixup(unsigned long phys_addr);
 #else
 static inline void __init efi_save_original_memmap(void) { }
+static inline int efi_illegal_accesses_fixup(unsigned long phys_addr)
+{
+	return 0;
+}
 #endif /* CONFIG_EFI_WARN_ON_ILLEGAL_ACCESS */
 
 struct efi_setup_data {
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 2aafa6ab6103..4f6939d8e13f 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -16,6 +16,7 @@
 #include <linux/prefetch.h>		/* prefetchw			*/
 #include <linux/context_tracking.h>	/* exception_enter(), ...	*/
 #include <linux/uaccess.h>		/* faulthandler_disabled()	*/
+#include <linux/efi.h>			/* fixup for buggy UEFI firmware*/
 
 #include <asm/cpufeature.h>		/* boot_cpu_has, ...		*/
 #include <asm/traps.h>			/* dotraplinkage, ...		*/
@@ -24,6 +25,7 @@
 #include <asm/vsyscall.h>		/* emulate_vsyscall		*/
 #include <asm/vm86.h>			/* struct vm86			*/
 #include <asm/mmu_context.h>		/* vma_pkey()			*/
+#include <asm/efi.h>			/* fixup for buggy UEFI firmware*/
 
 #define CREATE_TRACE_POINTS
 #include <asm/trace/exceptions.h>
@@ -790,6 +792,13 @@ no_context(struct pt_regs *regs, unsigned long error_code,
 		return;
 
 	/*
+	 * Buggy firmware could trigger illegal accesses to some EFI regions
+	 * which might page fault, try to recover from such faults.
+	 */
+	if (efi_illegal_accesses_fixup(address))
+		return;
+
+	/*
 	 * Oops. The kernel tried to access some bad page. We'll have to
 	 * terminate things with extreme prejudice:
 	 */
diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 36b0b042ba56..2aba28a90800 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -16,6 +16,7 @@
 #include <asm/efi.h>
 #include <asm/uv/uv.h>
 #include <asm/cpu_device_id.h>
+#include <asm/reboot.h>
 
 #define EFI_MIN_RESERVE 5120
 
@@ -701,4 +702,143 @@ void __init efi_save_original_memmap(void)
 
 	original_memory_map_present = true;
 }
+
+/*
+ * From the original EFI memory map passed by the firmware, return a
+ * pointer to the memory descriptor that describes the given physical
+ * address. If not found, return NULL.
+ */
+static efi_memory_desc_t *efi_get_md(unsigned long phys_addr)
+{
+	efi_memory_desc_t *md;
+
+	for_each_efi_memory_desc_in_map(&original_memory_map, md) {
+		if (md->phys_addr <= phys_addr &&
+		    (phys_addr < (md->phys_addr +
+		    (md->num_pages << EFI_PAGE_SHIFT)))) {
+			return md;
+		}
+	}
+	return NULL;
+}
+
+/*
+ * Detect illegal access by the firmware and if the illegally accessed
+ * region is any region described by efi memory map and other than
+ * EFI_RUNTIME_SERVICES_<CODE/DATA>, then
+ * 1. If the efi runtime service is efi_reset_system(), then reboot
+ *    through BIOS.
+ * 2. If the efi runtime service is _not_ efi_reset_system(), then
+ *    a. Freeze efi_rts_wq.
+ *    b. Return error status to the efi caller process.
+ *    c. Disable EFI Runtime Services forever and
+ *    d. Schedule another process by explicitly calling scheduler.
+ *
+ * @return: Returns 0, if the page fault is not handled. This function
+ * will never return if the page fault is handled successfully.
+ */
+int efi_illegal_accesses_fixup(unsigned long phys_addr)
+{
+	char buf[64];
+	efi_memory_desc_t *md;
+	unsigned long long phys_addr_end, size_in_MB;
+
+	/* Fix page faults caused *only* by the firmware */
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
+	 * Original memory map is needed to retrieve the memory descriptor
+	 * that the firmware has faulted on. So, check if the kernel had
+	 * saved the original memory map passed by the firmware during boot.
+	 */
+	if (!original_memory_map_present) {
+		pr_info("Original memory map not found, abort recovering from "
+			"illegal access by firmware\n");
+		return 0;
+	}
+
+	/*
+	 * EFI Memory map could sometimes have holes, eg: SMRAM. So, make
+	 * sure that a valid memory descriptor is present for the physical
+	 * address that triggered page fault.
+	 */
+	md = efi_get_md(phys_addr);
+	if (!md) {
+		pr_info("Failed to find EFI memory descriptor for PA: 0x%lx\n",
+			phys_addr);
+		return 0;
+	}
+
+	/*
+	 * EFI_RUNTIME_SERVICES_<CODE/DATA> regions are mapped into efi_pgd
+	 * by the kernel during boot and hence accesses to these regions
+	 * should never page fault.
+	 */
+	if (md->type == EFI_RUNTIME_SERVICES_CODE ||
+	    md->type == EFI_RUNTIME_SERVICES_DATA) {
+		pr_info("Kernel shouldn't page fault on accesses to "
+			"EFI_RUNTIME_SERVICES_<CODE/DATA> regions\n");
+		return 0;
+	}
+
+	/*
+	 * Now it's clear that an illegal access by the firmware has caused
+	 * the page fault. Print stack trace and memory descriptor as it is
+	 * useful to know which EFI Runtime Service is buggy and what did it
+	 * try to access.
+	 */
+	phys_addr_end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT) - 1;
+	size_in_MB = md->num_pages >> (20 - EFI_PAGE_SHIFT);
+	WARN(1, FW_BUG "Detected illegal access by Firmware at PA: 0x%lx\n",
+	     phys_addr);
+	pr_info("EFI Memory Descriptor for offending PA is:\n");
+	pr_info("%s range=[0x%016llx-0x%016llx] (%lluMB)\n",
+		efi_md_typeattr_format(buf, sizeof(buf), md), md->phys_addr,
+		phys_addr_end, size_in_MB);
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
+	/*
+	 * Firmware didn't page fault on EFI_RUNTIME_SERVICES_<CODE/DATA>.
+	 * This means that the firmware has illegally accessed some other
+	 * EFI region which can't be fixed. Hence, freeze efi_rts_wq.
+	 */
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
 #endif /* CONFIG_EFI_WARN_ON_ILLEGAL_ACCESS */
diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index b18b2d864c2c..5ca44ca22011 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -61,6 +61,11 @@ struct efi_runtime_work efi_rts_work;
 ({									\
 	efi_rts_work.status = EFI_ABORTED;				\
 									\
+	if (!efi_enabled(EFI_RUNTIME_SERVICES)) {			\
+		pr_err("Aborting! EFI Runtime Services disabled\n");	\
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
index 6a07e3166fd1..aa64fb88d4c8 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1682,6 +1682,7 @@ enum efi_rts_ids {
 	SET_VARIABLE,
 	QUERY_VARIABLE_INFO,
 	GET_NEXT_HIGH_MONO_COUNT,
+	RESET_SYSTEM,
 	UPDATE_CAPSULE,
 	QUERY_CAPSULE_CAPS,
 };
-- 
2.7.4
