From: Tyler Baicar <tbaicar@codeaurora.org>
Subject: [PATCH V6 10/10] arm/arm64: KVM: add guest SEA support
Date: Wed,  7 Dec 2016 14:48:23 -0700
Message-ID: <1481147303-7979-11-git-send-email-tbaicar@codeaurora.org>
References: <1481147303-7979-1-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <1481147303-7979-1-git-send-email-tbaicar@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, nkaje@codeaurora.org, zjzhang@codeaurora.org, mark.rutland@arm.com, james.morse@arm.com, akpm@linux-foundation.org, eun.taik.lee@samsung.com, sandeepa.s.prabhu@gmail.com, labbott@redhat.com, shijie.huang@arm.com, rruigrok@codeaurora.org, paul.gortmaker@windriver.com, tn@semihalf.com, fu.wei@linaro.org, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, devel@acpica.org, Suzuki.Poulose@arm.com, punit.agrawal@arm.com, astone@redhat.com, harba@codeaur
Cc: Tyler Baicar <tbaicar@codeaurora.org>
List-Id: linux-efi@vger.kernel.org

Currently external aborts are unsupported by the guest abort
handling. Add handling for SEAs so that the host kernel reports
SEAs which occur in the guest kernel.

Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
---
 arch/arm/include/asm/kvm_arm.h       |  1 +
 arch/arm/include/asm/system_misc.h   |  5 +++++
 arch/arm/kvm/mmu.c                   | 18 ++++++++++++++++--
 arch/arm64/include/asm/kvm_arm.h     |  1 +
 arch/arm64/include/asm/system_misc.h |  2 ++
 arch/arm64/mm/fault.c                | 13 +++++++++++++
 6 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/kvm_arm.h b/arch/arm/include/asm/kvm_arm.h
index e22089f..33a77509 100644
--- a/arch/arm/include/asm/kvm_arm.h
+++ b/arch/arm/include/asm/kvm_arm.h
@@ -187,6 +187,7 @@
 #define FSC_FAULT	(0x04)
 #define FSC_ACCESS	(0x08)
 #define FSC_PERM	(0x0c)
+#define FSC_EXTABT	(0x10)
 
 /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
 #define HPFAR_MASK	(~0xf)
diff --git a/arch/arm/include/asm/system_misc.h b/arch/arm/include/asm/system_misc.h
index a3d61ad..ea45d94 100644
--- a/arch/arm/include/asm/system_misc.h
+++ b/arch/arm/include/asm/system_misc.h
@@ -24,4 +24,9 @@ extern unsigned int user_debug;
 
 #endif /* !__ASSEMBLY__ */
 
+static inline int handle_guest_sea(unsigned long addr, unsigned int esr)
+{
+	return -1;
+}
+
 #endif /* __ASM_ARM_SYSTEM_MISC_H */
diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index e9a5c0e..1152966 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -29,6 +29,7 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
 #include <asm/virt.h>
+#include <asm/system_misc.h>
 
 #include "trace.h"
 
@@ -1441,8 +1442,21 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 	/* Check the stage-2 fault is trans. fault or write fault */
 	fault_status = kvm_vcpu_trap_get_fault_type(vcpu);
-	if (fault_status != FSC_FAULT && fault_status != FSC_PERM &&
-	    fault_status != FSC_ACCESS) {
+
+	/* The host kernel will handle the synchronous external abort. There
+	 * is no need to pass the error into the guest.
+	 */
+	if (fault_status == FSC_EXTABT) {
+		if(handle_guest_sea((unsigned long)fault_ipa,
+				    kvm_vcpu_get_hsr(vcpu))) {
+			kvm_err("Failed to handle guest SEA, FSC: EC=%#x xFSC=%#lx ESR_EL2=%#lx\n",
+				kvm_vcpu_trap_get_class(vcpu),
+				(unsigned long)kvm_vcpu_trap_get_fault(vcpu),
+				(unsigned long)kvm_vcpu_get_hsr(vcpu));
+			return -EFAULT;
+		}
+	} else if (fault_status != FSC_FAULT && fault_status != FSC_PERM &&
+		   fault_status != FSC_ACCESS) {
 		kvm_err("Unsupported FSC: EC=%#x xFSC=%#lx ESR_EL2=%#lx\n",
 			kvm_vcpu_trap_get_class(vcpu),
 			(unsigned long)kvm_vcpu_trap_get_fault(vcpu),
diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 4b5c977..be0efb6 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -201,6 +201,7 @@
 #define FSC_FAULT	ESR_ELx_FSC_FAULT
 #define FSC_ACCESS	ESR_ELx_FSC_ACCESS
 #define FSC_PERM	ESR_ELx_FSC_PERM
+#define FSC_EXTABT	ESR_ELx_FSC_EXTABT
 
 /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
 #define HPFAR_MASK	(~UL(0xf))
diff --git a/arch/arm64/include/asm/system_misc.h b/arch/arm64/include/asm/system_misc.h
index 9040e1d..3a142a5 100644
--- a/arch/arm64/include/asm/system_misc.h
+++ b/arch/arm64/include/asm/system_misc.h
@@ -77,4 +77,6 @@ extern void (*arm_pm_restart)(enum reboot_mode reboot_mode, const char *cmd);
 int register_synchronous_ext_abort_notifier(struct notifier_block *nb);
 void unregister_synchronous_ext_abort_notifier(struct notifier_block *nb);
 
+int handle_guest_sea(unsigned long addr, unsigned int esr);
+
 #endif	/* __ASM_SYSTEM_MISC_H */
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index fcc49f1..691399e 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -597,6 +597,19 @@ static const char *fault_name(unsigned int esr)
 }
 
 /*
+ * Handle Synchronous External Aborts that occur in a guest kernel.
+ */
+int handle_guest_sea(unsigned long addr, unsigned int esr)
+{
+	atomic_notifier_call_chain(&sea_handler_chain, 0, NULL);
+
+	pr_err("Synchronous External Abort: %s (0x%08x) at 0x%016lx\n",
+		fault_name(esr), esr, addr);
+
+	return 0;
+}
+
+/*
  * Dispatch a data abort to the relevant handler.
  */
 asmlinkage void __exception do_mem_abort(unsigned long addr, unsigned int esr,
-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
