From: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH V3 05/10] acpi: apei: handle SEA notification type for ARMv8
Date: Fri,  7 Oct 2016 15:31:17 -0600
Message-ID: <1475875882-2604-6-git-send-email-tbaicar@codeaurora.org>
References: <1475875882-2604-1-git-send-email-tbaicar@codeaurora.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475875882-2604-1-git-send-email-tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, james.morse-5wv7dgnIgG8@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, sandeepa.s.prabhu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shijie.huang-5wv7dgnIgG8@public.gmane.org, paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org, tomasz.nowicki-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, fu.wei-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, Dkvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-E0kO6a4B6psdnm+yROfE0A@public.gmane.org
Cc: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Naveen Kaje <nkaje-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

ARM APEI extension proposal added SEA (Synchrounous External
Abort) notification type for ARMv8.
Add a new GHES error source handling function for SEA. If an error
source's notification type is SEA, then this function can be registered
into the SEA exception handler. That way GHES will parse and report
SEA exceptions when they occur.

Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Signed-off-by: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Signed-off-by: Naveen Kaje <nkaje-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
---
 arch/arm64/Kconfig        |  1 +
 drivers/acpi/apei/Kconfig | 15 +++++++++
 drivers/acpi/apei/ghes.c  | 83 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 99 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b380c87..ae34349 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -53,6 +53,7 @@ config ARM64
 	select HANDLE_DOMAIN_IRQ
 	select HARDIRQS_SW_RESEND
 	select HAVE_ACPI_APEI if (ACPI && EFI)
+	select HAVE_ACPI_APEI_SEA if (ACPI && EFI)
 	select HAVE_ALIGNED_STRUCT_PAGE if SLUB
 	select HAVE_ARCH_AUDITSYSCALL
 	select HAVE_ARCH_BITREVERSE
diff --git a/drivers/acpi/apei/Kconfig b/drivers/acpi/apei/Kconfig
index b0140c8..fb99c1c 100644
--- a/drivers/acpi/apei/Kconfig
+++ b/drivers/acpi/apei/Kconfig
@@ -4,6 +4,21 @@ config HAVE_ACPI_APEI
 config HAVE_ACPI_APEI_NMI
 	bool
 
+config HAVE_ACPI_APEI_SEA
+	bool "APEI Synchronous External Abort logging/recovering support"
+	depends on ARM64
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
index c8488f1..28d5a09 100644
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
@@ -779,6 +783,62 @@ static struct notifier_block ghes_notifier_sci = {
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
@@ -1023,6 +1083,14 @@ static int ghes_probe(struct platform_device *ghes_dev)
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
@@ -1034,6 +1102,13 @@ static int ghes_probe(struct platform_device *ghes_dev)
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
@@ -1088,6 +1163,11 @@ static int ghes_probe(struct platform_device *ghes_dev)
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
@@ -1130,6 +1210,9 @@ static int ghes_remove(struct platform_device *ghes_dev)
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
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
