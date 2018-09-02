From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Subject: [PATCH V2 4/6] x86/efi: Add efi page fault handler to fixup/recover from page faults caused by firmware
Date: Sun,  2 Sep 2018 02:46:32 -0700
Message-ID: <1535881594-25469-5-git-send-email-sai.praneeth.prakhya@intel.com>
References: <1535881594-25469-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1535881594-25469-1-git-send-email-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: ricardo.neri@intel.com, matt@codeblueprint.co.uk, Sai Praneeth <sai.praneeth.prakhya@intel.com>, Lee Chun-Yi <jlee@suse.com>, Al Stone <astone@redhat.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Bhupesh Sharma <bhsharma@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

EFI regions could briefly be divided into 3 types.
1. EFI_BOOT_SERVICES_<CODE/DATA> regions
2. EFI_RUNTIME_SERVICES_<CODE/DATA> regions
3. Other EFI regions like EFI_LOADER_<CODE/DATA> etc.

As per the UEFI specification, after the call to ExitBootServices(),
accesses by the firmware to any memory region except
EFI_RUNTIME_SERVICES_<CODE/DATA> regions is considered illegal. A buggy
firmware could trigger these illegal accesses during boot time or at
runtime (i.e. when the kernel is up and running). Presently, the kernel
can fix up illegal accesses to EFI_BOOT_SERVICES_<CODE/DATA> regions
*only* during kernel boot phase. If the firmware triggers illegal
accesses to *any* other EFI regions during kernel boot, the kernel
panics or if this happens during kernel runtime then the kernel hangs.

Kernel panics/hangs because the memory region requested by the firmware
isn't mapped, which causes a page fault in ring 0 and the kernel fails
to handle it, leading to die(). To save kernel from hanging, add an efi
specific page fault handler which detects illegal accesses by the
firmware and
1. If the illegally accessed region is EFI_BOOT_SERVICES_<CODE/DATA>,
   the efi page fault handler fixes it up by mapping the requested
   region.
2. If any other region (Eg: EFI_CONVENTIONAL_MEMORY or
   EFI_LOADER_<CODE/DATA>), then the efi page fault handler freezes
   efi_rts_wq and schedules a new process.
3. If the access is to any other efi region like above but if the efi
   runtime service is efi_reset_system(), then the efi page fault
   handler will reboot the machine through BIOS.

Illegal accesses to EFI_BOOT_SERVICES_<CODE/DATA> and to other regions
are dealt differently in efi page fault handler because, *generally*
EFI_BOOT_SERVICES_<CODE/DATA> regions are smaller in size relative to
other efi regions and hence could be reserved and can be dynamically
mapped. But other EFI regions like EFI_CONVENTIONAL_MEMORY and
EFI_LOADER_<CODE/DATA> cannot be reserved as they are very huge in size
and reserving them will make the kernel un-bootable.

The efi specific page fault handler offers us two advantages:
1. Avoid panics/hangs caused by buggy firmware.
2. Shout loud that the firmware is buggy and hence is not a kernel bug.

Finally, this new mapping will not impact a reboot from kexec, as kexec
is only concerned about runtime memory regions.

Suggested-by: Matt Fleming <matt@codeblueprint.co.uk>
Based-on-code-from: Ricardo Neri <ricardo.neri@intel.com>
Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: Lee Chun-Yi <jlee@suse.com>
Cc: Al Stone <astone@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Bhupesh Sharma <bhsharma@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/include/asm/efi.h              |   7 ++
 arch/x86/mm/fault.c                     |   9 ++
 arch/x86/platform/efi/quirks.c          | 152 ++++++++++++++++++++++++++++++++
 drivers/firmware/efi/runtime-wrappers.c |   7 ++
 include/linux/efi.h                     |   1 +
 5 files changed, 176 insertions(+)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index d9e5d9a6d138..68a28606909c 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -144,8 +144,15 @@ extern void efi_switch_mm(struct mm_struct *mm);
 
 #ifdef CONFIG_EFI_WARN_ON_ILLEGAL_ACCESS
 extern void __init efi_save_original_memmap(void);
+extern int efi_illegal_accesses_fixup(unsigned long phys_addr,
+				      struct pt_regs *regs);
 #else
 static inline void __init efi_save_original_memmap(void) { }
+static inline int efi_illegal_accesses_fixup(unsigned long phys_addr,
+					     struct pt_regs *regs)
+{
+	return 0;
+}
 #endif /* CONFIG_EFI_WARN_ON_ILLEGAL_ACCESS */
 
 struct efi_setup_data {
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 2aafa6ab6103..afd42e76058e 100644
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
+	 * which might page fault, try to fixup or recover from such faults.
+	 */
+	if (efi_illegal_accesses_fixup(address, regs))
+		return;
+
+	/*
 	 * Oops. The kernel tried to access some bad page. We'll have to
 	 * terminate things with extreme prejudice:
 	 */
diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 7fd53fa8c4dd..e38e823382ba 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -16,6 +16,7 @@
 #include <asm/efi.h>
 #include <asm/uv/uv.h>
 #include <asm/cpu_device_id.h>
+#include <asm/reboot.h>
 
 #define EFI_MIN_RESERVE 5120
 
@@ -702,4 +703,155 @@ void __init efi_save_original_memmap(void)
 
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
+ * Detect illegal accesses by the firmware and
+ * 1. If the illegally accessed region is EFI_BOOT_SERVICES_<CODE/DATA>,
+ *   fix it up by mapping the requested region.
+ * 2. If any other region (Eg: EFI_CONVENTIONAL_MEMORY or
+ *   EFI_LOADER_<CODE/DATA>), then
+ *   a. Freeze efi_rts_wq.
+ *   b. Return error status to the efi caller process.
+ *   c. Disable EFI Runtime Services forever and
+ *   d. Schedule another process by explicitly calling scheduler.
+ *
+ * @return: Return 1, if the page fault is handled by mapping the
+ * requested region. Return 0 otherwise.
+ */
+int efi_illegal_accesses_fixup(unsigned long phys_addr, struct pt_regs *regs)
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
+		pr_info("Original memory map not found, aborting fixing illegal "
+			"access by firmware\n");
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
+	 * Fix illegal accesses by firmware to EFI_BOOT_SERVICES_<CODE/DATA>
+	 * regions by creating VA->PA mappings. Further accesses to these
+	 * regions will not page fault.
+	 */
+	if (md->type == EFI_BOOT_SERVICES_CODE ||
+	    md->type == EFI_BOOT_SERVICES_DATA) {
+		efi_map_region(md);
+		pr_info("Fixed illegal access at PA: 0x%lx\n", phys_addr);
+		return 1;
+	}
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
+	 * Firmware didn't page fault on EFI_RUNTIME_SERVICES_<CODE/DATA> or
+	 * EFI_BOOT_SERVICES_<CODE/DATA> regions. This means that the
+	 * firmware has illegally accessed some other EFI region which can't
+	 * be fixed. Hence, freeze efi_rts_wq.
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
index 0ddd61b9a3e1..02f4a1376ed3 100644
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
