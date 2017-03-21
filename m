From: Tyler Baicar <tbaicar@codeaurora.org>
Subject: [PATCH V13 05/10] acpi: apei: handle SEA notification type for ARMv8
Date: Tue, 21 Mar 2017 16:47:00 -0600
Message-ID: <1490136425-4324-6-git-send-email-tbaicar@codeaurora.org>
References: <1490136425-4324-1-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <1490136425-4324-1-git-send-email-tbaicar@codeaurora.org>
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

ARM APEI extension proposal added SEA (Synchronous External Abort)
notification type for ARMv8.
Add a new GHES error source handling function for SEA. If an error
source's notification type is SEA, then this function can be registered
into the SEA exception handler. That way GHES will parse and report
SEA exceptions when they occur.
An SEA can interrupt code that had interrupts masked and is treated as
an NMI. To aid this the page of address space for mapping APEI buffers
while in_nmi() is always reserved, and ghes_ioremap_pfn_nmi() is
changed to use the helper methods to find the prot_t to map with in
the same way as ghes_ioremap_pfn_irq().

Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
CC: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
Reviewed-by: James Morse <james.morse@arm.com>
---
 arch/arm64/Kconfig        |  2 ++
 arch/arm64/mm/fault.c     | 13 +++++++++
 drivers/acpi/apei/Kconfig | 15 ++++++++++
 drivers/acpi/apei/ghes.c  | 70 +++++++++++++++++++++++++++++++++++++++++++----
 include/acpi/ghes.h       |  7 +++++
 5 files changed, 101 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 8c7c244..d542d17 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -18,6 +18,7 @@ config ARM64
 	select ARCH_HAS_STRICT_KERNEL_RWX
 	select ARCH_HAS_STRICT_MODULE_RWX
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
+	select ARCH_HAVE_NMI_SAFE_CMPXCHG if ACPI_APEI_SEA
 	select ARCH_USE_CMPXCHG_LOCKREF
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_SUPPORTS_NUMA_BALANCING
@@ -92,6 +93,7 @@ config ARM64
 	select HAVE_IRQ_TIME_ACCOUNTING
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP if NUMA
+	select HAVE_NMI if ACPI_APEI_SEA
 	select HAVE_PATA_PLATFORM
 	select HAVE_PERF_EVENTS
 	select HAVE_PERF_REGS
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index e17633d..f7372ce 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -42,6 +42,8 @@
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 
+#include <acpi/ghes.h>
+
 static const char *fault_name(unsigned int esr);
 
 #ifdef CONFIG_KPROBES
@@ -499,6 +501,17 @@ static int do_sea(unsigned long addr, unsigned int esr, struct pt_regs *regs)
 	pr_err("Synchronous External Abort: %s (0x%08x) at 0x%016lx\n",
 		 fault_name(esr), esr, addr);
 
+	/*
+	 * Synchronous aborts may interrupt code which had interrupts masked.
+	 * Before calling out into the wider kernel tell the interested
+	 * subsystems.
+	 */
+	if (IS_ENABLED(CONFIG_ACPI_APEI_SEA)) {
+		nmi_enter();
+		ghes_notify_sea();
+		nmi_exit();
+	}
+
 	info.si_signo = SIGBUS;
 	info.si_errno = 0;
 	info.si_code  = 0;
diff --git a/drivers/acpi/apei/Kconfig b/drivers/acpi/apei/Kconfig
index b0140c8..de14d49 100644
--- a/drivers/acpi/apei/Kconfig
+++ b/drivers/acpi/apei/Kconfig
@@ -39,6 +39,21 @@ config ACPI_APEI_PCIEAER
 	  PCIe AER errors may be reported via APEI firmware first mode.
 	  Turn on this option to enable the corresponding support.
 
+config ACPI_APEI_SEA
+	bool "APEI Synchronous External Abort logging/recovering support"
+	depends on ARM64 && ACPI_APEI_GHES
+	default y
+	help
+	  This option should be enabled if the system supports
+	  firmware first handling of SEA (Synchronous External Abort).
+	  SEA happens with certain faults of data abort or instruction
+	  abort synchronous exceptions on ARMv8 systems. If a system
+	  supports firmware first handling of SEA, the platform analyzes
+	  and handles hardware error notifications from SEA, and it may then
+	  form a HW error record for the OS to parse and handle. This
+	  option allows the OS to look for such hardware error record, and
+	  take appropriate action.
+
 config ACPI_APEI_MEMORY_FAILURE
 	bool "APEI memory error recovering support"
 	depends on ACPI_APEI && MEMORY_FAILURE
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 9ddbb93..b735a5c 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -115,11 +115,7 @@
  * Two virtual pages are used, one for IRQ/PROCESS context, the other for
  * NMI context (optionally).
  */
-#ifdef CONFIG_HAVE_ACPI_APEI_NMI
 #define GHES_IOREMAP_PAGES           2
-#else
-#define GHES_IOREMAP_PAGES           1
-#endif
 #define GHES_IOREMAP_IRQ_PAGE(base)	(base)
 #define GHES_IOREMAP_NMI_PAGE(base)	((base) + PAGE_SIZE)
 
@@ -158,10 +154,14 @@ static void ghes_ioremap_exit(void)
 static void __iomem *ghes_ioremap_pfn_nmi(u64 pfn)
 {
 	unsigned long vaddr;
+	phys_addr_t paddr;
+	pgprot_t prot;
 
 	vaddr = (unsigned long)GHES_IOREMAP_NMI_PAGE(ghes_ioremap_area->addr);
-	ioremap_page_range(vaddr, vaddr + PAGE_SIZE,
-			   pfn << PAGE_SHIFT, PAGE_KERNEL);
+
+	paddr = pfn << PAGE_SHIFT;
+	prot = arch_apei_get_mem_attribute(paddr);
+	ioremap_page_range(vaddr, vaddr + PAGE_SIZE, paddr, prot);
 
 	return (void __iomem *)vaddr;
 }
@@ -768,6 +768,50 @@ static int ghes_notify_sci(struct notifier_block *this,
 	.notifier_call = ghes_notify_sci,
 };
 
+#ifdef CONFIG_ACPI_APEI_SEA
+static LIST_HEAD(ghes_sea);
+
+void ghes_notify_sea(void)
+{
+	struct ghes *ghes;
+
+	/*
+	 * synchronize_rcu() will wait for nmi_exit(), so no need to
+	 * rcu_read_lock().
+	 */
+	list_for_each_entry_rcu(ghes, &ghes_sea, list) {
+		ghes_proc(ghes);
+	}
+}
+
+static void ghes_sea_add(struct ghes *ghes)
+{
+	mutex_lock(&ghes_list_mutex);
+	list_add_rcu(&ghes->list, &ghes_sea);
+	mutex_unlock(&ghes_list_mutex);
+}
+
+static void ghes_sea_remove(struct ghes *ghes)
+{
+	mutex_lock(&ghes_list_mutex);
+	list_del_rcu(&ghes->list);
+	mutex_unlock(&ghes_list_mutex);
+	synchronize_rcu();
+}
+#else /* CONFIG_ACPI_APEI_SEA */
+static inline void ghes_sea_add(struct ghes *ghes)
+{
+	pr_err(GHES_PFX "ID: %d, trying to add SEA notification which is not supported\n",
+	       ghes->generic->header.source_id);
+}
+
+static inline void ghes_sea_remove(struct ghes *ghes)
+{
+	pr_err(GHES_PFX "ID: %d, trying to remove SEA notification which is not supported\n",
+	       ghes->generic->header.source_id);
+}
+#endif /* CONFIG_ACPI_APEI_SEA */
+
 #ifdef CONFIG_HAVE_ACPI_APEI_NMI
 /*
  * printk is not safe in NMI context.  So in NMI handler, we allocate
@@ -1013,6 +1057,14 @@ static int ghes_probe(struct platform_device *ghes_dev)
 	case ACPI_HEST_NOTIFY_EXTERNAL:
 	case ACPI_HEST_NOTIFY_SCI:
 		break;
+	case ACPI_HEST_NOTIFY_SEA:
+		if (!IS_ENABLED(CONFIG_ACPI_APEI_SEA)) {
+			pr_warn(GHES_PFX "Generic hardware error source: %d notified via SEA is not supported\n",
+				generic->header.source_id);
+			rc = -ENOTSUPP;
+			goto err;
+		}
+		break;
 	case ACPI_HEST_NOTIFY_NMI:
 		if (!IS_ENABLED(CONFIG_HAVE_ACPI_APEI_NMI)) {
 			pr_warn(GHES_PFX "Generic hardware error source: %d notified via NMI interrupt is not supported!\n",
@@ -1078,6 +1130,9 @@ static int ghes_probe(struct platform_device *ghes_dev)
 		list_add_rcu(&ghes->list, &ghes_sci);
 		mutex_unlock(&ghes_list_mutex);
 		break;
+	case ACPI_HEST_NOTIFY_SEA:
+		ghes_sea_add(ghes);
+		break;
 	case ACPI_HEST_NOTIFY_NMI:
 		ghes_nmi_add(ghes);
 		break;
@@ -1120,6 +1175,9 @@ static int ghes_remove(struct platform_device *ghes_dev)
 			unregister_acpi_hed_notifier(&ghes_notifier_sci);
 		mutex_unlock(&ghes_list_mutex);
 		break;
+	case ACPI_HEST_NOTIFY_SEA:
+		ghes_sea_remove(ghes);
+		break;
 	case ACPI_HEST_NOTIFY_NMI:
 		ghes_nmi_remove(ghes);
 		break;
diff --git a/include/acpi/ghes.h b/include/acpi/ghes.h
index 6ae318b..18bc935 100644
--- a/include/acpi/ghes.h
+++ b/include/acpi/ghes.h
@@ -1,3 +1,6 @@
+#ifndef GHES_H
+#define GHES_H
+
 #include <acpi/apei.h>
 #include <acpi/hed.h>
 
@@ -95,3 +98,7 @@ static inline void *acpi_hest_generic_data_payload(struct acpi_hest_generic_data
 		(void *)(((struct acpi_hest_generic_data_v300 *)(gdata)) + 1) :
 		gdata + 1;
 }
+
+void ghes_notify_sea(void);
+
+#endif /* GHES_H */
-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
