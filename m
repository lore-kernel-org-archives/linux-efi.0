From: Tyler Baicar <tbaicar@codeaurora.org>
Subject: [PATCH V5 05/10] acpi: apei: handle SEA notification type for ARMv8
Date: Mon, 21 Nov 2016 15:35:58 -0700
Message-ID: <1479767763-27532-6-git-send-email-tbaicar@codeaurora.org>
References: <1479767763-27532-1-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <1479767763-27532-1-git-send-email-tbaicar@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, nkaje@codeaurora.org, zjzhang@codeaurora.org, mark.rutland@arm.com, james.morse@arm.com, akpm@linux-foundation.org, eun.taik.lee@samsung.com, sandeepa.s.prabhu@gmail.com, shijie.huang@arm.com, rruigrok@codeaurora.org, paul.gortmaker@windriver.com, tomasz.nowicki@linaro.org, fu.wei@linaro.org, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, Suzuki.Poulose@arm.com, punit.agrawal@arm.com, astone@redhat.com, harba@codeaurora.org, hanjun.guo@linaro.org
Cc: Tyler Baicar <tbaicar@codeaurora.org>
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
index b0140c8..3786ff1 100644
--- a/drivers/acpi/apei/Kconfig
+++ b/drivers/acpi/apei/Kconfig
@@ -4,6 +4,20 @@ config HAVE_ACPI_APEI
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
index 9063d68..839a0e2 100644
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
@@ -770,6 +774,62 @@ static struct notifier_block ghes_notifier_sci = {
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
+		register_synchronous_ext_abort_notifier(&ghes_notifier_sea);
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
+		unregister_synchronous_ext_abort_notifier(&ghes_notifier_sea);
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
@@ -1014,6 +1074,14 @@ static int ghes_probe(struct platform_device *ghes_dev)
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
@@ -1025,6 +1093,13 @@ static int ghes_probe(struct platform_device *ghes_dev)
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
@@ -1079,6 +1154,11 @@ static int ghes_probe(struct platform_device *ghes_dev)
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
@@ -1121,6 +1201,9 @@ static int ghes_remove(struct platform_device *ghes_dev)
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
