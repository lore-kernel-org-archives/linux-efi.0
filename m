From: Tyler Baicar <tbaicar@codeaurora.org>
Subject: [PATCH V2 6/9] acpi: apei: handle SEA notification type for ARMv8
Date: Wed,  6 Apr 2016 09:12:55 -0600
Message-ID: <1459955578-24602-7-git-send-email-tbaicar@codeaurora.org>
References: <1459955578-24602-1-git-send-email-tbaicar@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459955578-24602-1-git-send-email-tbaicar@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: fu.wei@linaro.org, timur@codeaurora.org, harba@codeaurora.org, rruigrok@codeaurora.org, ahs3@redhat.com, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, devel@acpica.org
Cc: Tyler Baicar <tbaicar@codeaurora.org>, "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>, Naveen Kaje <nkaje@codeaurora.org>
List-Id: linux-efi@vger.kernel.org

ARM APEI extension proposal added SEA (Synchrounous External
Abort) notification type for ARMv8.
Add a new GHES error source handling function for SEA. If an error
source's notification type is SEA, then this function can be registered
into the SEA exception handler. That way GHES will parse and report
SEA exceptions when they occur.

Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
Signed-off-by: Naveen Kaje <nkaje@codeaurora.org>
---
 arch/arm64/Kconfig        |  1 +
 drivers/acpi/apei/Kconfig | 14 ++++++++
 drivers/acpi/apei/ghes.c  | 83 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 98 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 08952ec..6a7e166 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -4,6 +4,7 @@ config ARM64
 	select ACPI_GENERIC_GSI if ACPI
 	select ACPI_REDUCED_HARDWARE_ONLY if ACPI
 	select HAVE_ACPI_APEI if ACPI
+	select HAVE_ACPI_APEI_SEA if ACPI
 	select ARCH_HAS_DEVMEM_IS_ALLOWED
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select ARCH_HAS_ELF_RANDOMIZE
diff --git a/drivers/acpi/apei/Kconfig b/drivers/acpi/apei/Kconfig
index b0140c8..2d6cd9b 100644
--- a/drivers/acpi/apei/Kconfig
+++ b/drivers/acpi/apei/Kconfig
@@ -4,6 +4,20 @@ config HAVE_ACPI_APEI
 config HAVE_ACPI_APEI_NMI
 	bool
 
+config HAVE_ACPI_APEI_SEA
+	bool "APEI Synchronous External Abort logging/recovering support"
+	help
+	  This option should be enabled if the system supports
+	  firmware first handling of SEA (Synchronous External Abort).
+	  SEA happens with certain faults of data abort or instruction
+	  abort synchronous exceptions on ARMv8 systems. If a system
+	  supports firmware first handling of SEA, the platform analyzes
+	  and handles hardware error notifications with SEA, and it may then
+	  form a HW error record for the OS to parse and handle. This
+	  option allows the OS to look for such HW error record, and
+	  take appropriate action.
+
 config ACPI_APEI
 	bool "ACPI Platform Error Interface (APEI)"
 	select MISC_FILESYSTEMS
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index a6848706..aae5ca0 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -50,6 +50,10 @@
 #include <acpi/apei.h>
 #include <asm/tlbflush.h>
 
+#ifdef CONFIG_HAVE_ACPI_APEI_SEA
+#include <asm/system_misc.h>
+#endif
+
 #include "apei-internal.h"
 
 #define GHES_PFX	"GHES: "
@@ -789,6 +793,62 @@ static struct notifier_block ghes_notifier_sci = {
 	.notifier_call = ghes_notify_sci,
 };
 
+#ifdef CONFIG_HAVE_ACPI_APEI_SEA
+static LIST_HEAD(ghes_sea);
+
+static int ghes_notify_sea(struct notifier_block *this,
+				  unsigned long event, void *data)
+{
+	struct ghes *ghes;
+	int ret = NOTIFY_DONE;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(ghes, &ghes_sea, list) {
+		if (!ghes_proc(ghes))
+			ret = NOTIFY_OK;
+	}
+	rcu_read_unlock();
+
+	return ret;
+}
+
+static struct notifier_block ghes_notifier_sea = {
+	.notifier_call = ghes_notify_sea,
+};
+
+static int ghes_sea_add(struct ghes *ghes)
+{
+	mutex_lock(&ghes_list_mutex);
+	if (list_empty(&ghes_sea))
+		sea_register_handler_chain(&ghes_notifier_sea);
+	list_add_rcu(&ghes->list, &ghes_sea);
+	mutex_unlock(&ghes_list_mutex);
+	return 0;
+}
+
+static void ghes_sea_remove(struct ghes *ghes)
+{
+	mutex_lock(&ghes_list_mutex);
+	list_del_rcu(&ghes->list);
+	if (list_empty(&ghes_sea))
+		sea_unregister_handler_chain(&ghes_notifier_sea);
+	mutex_unlock(&ghes_list_mutex);
+}
+#else /* CONFIG_HAVE_ACPI_APEI_SEA */
+static inline int ghes_sea_add(struct ghes *ghes)
+{
+	pr_err(GHES_PFX "ID: %d, trying to add SEA notification which is not supported\n",
+	       ghes->generic->header.source_id);
+	return -ENOTSUPP;
+}
+
+static inline void ghes_sea_remove(struct ghes *ghes)
+{
+	pr_err(GHES_PFX "ID: %d, trying to remove SEA notification which is not supported\n",
+	       ghes->generic->header.source_id);
+}
+#endif /* CONFIG_HAVE_ACPI_APEI_SEA */
+
 #ifdef CONFIG_HAVE_ACPI_APEI_NMI
 /*
  * printk is not safe in NMI context.  So in NMI handler, we allocate
@@ -1033,6 +1093,14 @@ static int ghes_probe(struct platform_device *ghes_dev)
 	case ACPI_HEST_NOTIFY_EXTERNAL:
 	case ACPI_HEST_NOTIFY_SCI:
 		break;
+	case ACPI_HEST_NOTIFY_SEA:
+		if (!IS_ENABLED(CONFIG_HAVE_ACPI_APEI_SEA)) {
+			pr_warn(GHES_PFX "Generic hardware error source: %d notified via SEA is not supported\n",
+				generic->header.source_id);
+			rc = -ENOTSUPP;
+			goto err;
+		}
+		break;
 	case ACPI_HEST_NOTIFY_NMI:
 		if (!IS_ENABLED(CONFIG_HAVE_ACPI_APEI_NMI)) {
 			pr_warn(GHES_PFX "Generic hardware error source: %d notified via NMI interrupt is not supported!\n",
@@ -1044,6 +1112,13 @@ static int ghes_probe(struct platform_device *ghes_dev)
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
@@ -1098,6 +1173,11 @@ static int ghes_probe(struct platform_device *ghes_dev)
 		list_add_rcu(&ghes->list, &ghes_sci);
 		mutex_unlock(&ghes_list_mutex);
 		break;
+	case ACPI_HEST_NOTIFY_SEA:
+		rc = ghes_sea_add(ghes);
+		if (rc)
+			goto err_edac_unreg;
+		break;
 	case ACPI_HEST_NOTIFY_NMI:
 		ghes_nmi_add(ghes);
 		break;
@@ -1140,6 +1220,9 @@ static int ghes_remove(struct platform_device *ghes_dev)
 			unregister_acpi_hed_notifier(&ghes_notifier_sci);
 		mutex_unlock(&ghes_list_mutex);
 		break;
+	case ACPI_HEST_NOTIFY_SEA:
+		ghes_sea_remove(ghes);
+		break;
 	case ACPI_HEST_NOTIFY_NMI:
 		ghes_nmi_remove(ghes);
 		break;
-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
