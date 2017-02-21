From: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH V11 05/10] acpi: apei: handle SEA notification type for ARMv8
Date: Tue, 21 Feb 2017 14:21:56 -0700
Message-ID: <1487712121-16688-6-git-send-email-tbaicar@codeaurora.org>
References: <1487712121-16688-1-git-send-email-tbaicar@codeaurora.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487712121-16688-1-git-send-email-tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, nkaje-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, james.morse-5wv7dgnIgG8@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, eun.taik.lee-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, sandeepa.s.prabhu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, shijie.huang-5wv7dgnIgG8@public.gmane.org, rruigrok-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org, tn-nYOzD4b6Jr9Wk0Htik3J/w@public.gmane.org, fu.wei-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
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

Signed-off-by: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
CC: Jonathan (Zhixiong) Zhang <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
---
 arch/arm64/Kconfig        |  1 +
 arch/arm64/mm/fault.c     | 13 ++++++++
 drivers/acpi/apei/Kconfig | 15 +++++++++
 drivers/acpi/apei/ghes.c  | 77 +++++++++++++++++++++++++++++++++++++++++++----
 include/acpi/ghes.h       |  7 +++++
 5 files changed, 107 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 1117421..fca4dc1 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -88,6 +88,7 @@ config ARM64
 	select HAVE_IRQ_TIME_ACCOUNTING
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP if NUMA
+	select HAVE_NMI if ACPI_APEI_SEA
 	select HAVE_PATA_PLATFORM
 	select HAVE_PERF_EVENTS
 	select HAVE_PERF_REGS
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index d178dc0..b2d57fc 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -41,6 +41,8 @@
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 
+#include <acpi/ghes.h>
+
 static const char *fault_name(unsigned int esr);
 
 #ifdef CONFIG_KPROBES
@@ -498,6 +500,17 @@ static int do_sea(unsigned long addr, unsigned int esr, struct pt_regs *regs)
 	pr_err("Synchronous External Abort: %s (0x%08x) at 0x%016lx\n",
 		 fault_name(esr), esr, addr);
 
+	/*
+	 * Synchronous aborts may interrupt code which had interrupts masked.
+	 * Before calling out into the wider kernel tell the interested
+	 * subsystems.
+	 */
+	if (IS_ENABLED(ACPI_APEI_SEA)) {
+		nmi_enter();
+		ghes_notify_sea();
+		nmi_exit();
+	}
+
 	info.si_signo = SIGBUS;
 	info.si_errno = 0;
 	info.si_code  = 0;
diff --git a/drivers/acpi/apei/Kconfig b/drivers/acpi/apei/Kconfig
index b0140c8..c545dd1 100644
--- a/drivers/acpi/apei/Kconfig
+++ b/drivers/acpi/apei/Kconfig
@@ -39,6 +39,21 @@ config ACPI_APEI_PCIEAER
 	  PCIe AER errors may be reported via APEI firmware first mode.
 	  Turn on this option to enable the corresponding support.
 
+config ACPI_APEI_SEA
+	bool "APEI Synchronous External Abort logging/recovering support"
+	depends on ARM64 && ACPI_APEI && ACPI_APEI_GHES
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
index b25e7cf..b0596ba 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -114,11 +114,7 @@
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
 
@@ -157,10 +153,14 @@ static void ghes_ioremap_exit(void)
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
@@ -767,6 +767,50 @@ static int ghes_notify_sci(struct notifier_block *this,
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
@@ -1012,6 +1056,14 @@ static int ghes_probe(struct platform_device *ghes_dev)
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
@@ -1023,6 +1075,13 @@ static int ghes_probe(struct platform_device *ghes_dev)
 		pr_warning(GHES_PFX "Generic hardware error source: %d notified via local interrupt is not supported!\n",
 			   generic->header.source_id);
 		goto err;
+	case ACPI_HEST_NOTIFY_GPIO:
+	case ACPI_HEST_NOTIFY_SEI:
+	case ACPI_HEST_NOTIFY_GSIV:
+		pr_warn(GHES_PFX "Generic hardware error source: %d notified via notification type %u is not supported\n",
+			generic->header.source_id, generic->header.source_id);
+		rc = -ENOTSUPP;
+		goto err;
 	default:
 		pr_warning(FW_WARN GHES_PFX "Unknown notification type: %u for generic hardware error source: %d\n",
 			   generic->notify.type, generic->header.source_id);
@@ -1077,6 +1136,9 @@ static int ghes_probe(struct platform_device *ghes_dev)
 		list_add_rcu(&ghes->list, &ghes_sci);
 		mutex_unlock(&ghes_list_mutex);
 		break;
+	case ACPI_HEST_NOTIFY_SEA:
+		ghes_sea_add(ghes);
+		break;
 	case ACPI_HEST_NOTIFY_NMI:
 		ghes_nmi_add(ghes);
 		break;
@@ -1119,6 +1181,9 @@ static int ghes_remove(struct platform_device *ghes_dev)
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
