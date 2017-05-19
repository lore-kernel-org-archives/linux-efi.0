From: Tyler Baicar <tbaicar@codeaurora.org>
Subject: [PATCH V17 10/11] trace, ras: add ARM processor error trace event
Date: Fri, 19 May 2017 14:32:12 -0600
Message-ID: <1495225933-4410-11-git-send-email-tbaicar@codeaurora.org>
References: <1495225933-4410-1-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <1495225933-4410-1-git-send-email-tbaicar@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, nkaje@codeaurora.org, zjzhang@codeaurora.org, mark.rutland@arm.com, james.morse@arm.com, akpm@linux-foundation.org, eun.taik.lee@samsung.com, sandeepa.s.prabhu@gmail.com, labbott@redhat.com, shijie.huang@arm.com, rruigrok@codeaurora.org, paul.gortmaker@windriver.com, tn@semihalf.com, fu.wei@linaro.org, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, Suzuki.Poulose@arm.com, punit.agrawal@arm.com, astone@redhat.com, harba@codeaurora.org, hanjun.gu
Cc: Tyler Baicar <tbaicar@codeaurora.org>
List-Id: linux-efi@vger.kernel.org

Currently there are trace events for the various RAS
errors with the exception of ARM processor type errors.
Add a new trace event for such errors so that the user
will know when they occur. These trace events are
consistent with the ARM processor error section type
defined in UEFI 2.6 spec section N.2.4.4.

Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Reviewed-by: Xie XiuQi <xiexiuqi@huawei.com>
---
 drivers/acpi/apei/ghes.c    |  6 +++++-
 drivers/firmware/efi/cper.c |  1 +
 drivers/ras/ras.c           |  6 ++++++
 include/linux/ras.h         |  3 +++
 include/ras/ras_event.h     | 45 +++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 60 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 16adbc8..a0ab5f3 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -518,7 +518,11 @@ static void ghes_do_proc(struct ghes *ghes,
 
 		}
 #endif
-		else {
+		else if (!uuid_le_cmp(sec_type, CPER_SEC_PROC_ARM)) {
+			struct cper_sec_proc_arm *err = acpi_hest_get_payload(gdata);
+
+			log_arm_hw_error(err);
+		} else {
 			void *err = acpi_hest_get_payload(gdata);
 
 			log_non_standard_event(&sec_type, fru_id, fru_text,
diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index d5a5855..48a8f69 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -35,6 +35,7 @@
 #include <linux/printk.h>
 #include <linux/bcd.h>
 #include <acpi/ghes.h>
+#include <ras/ras_event.h>
 
 #define INDENT_SP	" "
 
diff --git a/drivers/ras/ras.c b/drivers/ras/ras.c
index e87fd9e..39701a5 100644
--- a/drivers/ras/ras.c
+++ b/drivers/ras/ras.c
@@ -20,6 +20,11 @@ void log_non_standard_event(const uuid_le *sec_type, const uuid_le *fru_id,
 	trace_non_standard_event(sec_type, fru_id, fru_text, sev, err, len);
 }
 
+void log_arm_hw_error(struct cper_sec_proc_arm *err)
+{
+	trace_arm_event(err);
+}
+
 static int __init ras_init(void)
 {
 	int rc = 0;
@@ -36,6 +41,7 @@ static int __init ras_init(void)
 #endif
 EXPORT_TRACEPOINT_SYMBOL_GPL(mc_event);
 EXPORT_TRACEPOINT_SYMBOL_GPL(non_standard_event);
+EXPORT_TRACEPOINT_SYMBOL_GPL(arm_event);
 
 int __init parse_ras_param(char *str)
 {
diff --git a/include/linux/ras.h b/include/linux/ras.h
index a7f3ed3..7a14658 100644
--- a/include/linux/ras.h
+++ b/include/linux/ras.h
@@ -3,6 +3,7 @@
 
 #include <asm/errno.h>
 #include <linux/uuid.h>
+#include <linux/cper.h>
 
 #ifdef CONFIG_DEBUG_FS
 int ras_userspace_consumers(void);
@@ -27,11 +28,13 @@ static inline void __init cec_init(void)	{ }
 void log_non_standard_event(const uuid_le *sec_type,
 			    const uuid_le *fru_id, const char *fru_text,
 			    const u8 sev, const u8 *err, const u32 len);
+void log_arm_hw_error(struct cper_sec_proc_arm *err);
 #else
 static void log_non_standard_event(const uuid_le *sec_type,
 				   const uuid_le *fru_id, const char *fru_text,
 				   const u8 sev, const u8 *err,
 				   const u32 len) { return; }
+static void log_arm_hw_error(struct cper_sec_proc_arm *err) { return; }
 #endif
 
 #endif /* __RAS_H__ */
diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
index 4f79ba9..429f46f 100644
--- a/include/ras/ras_event.h
+++ b/include/ras/ras_event.h
@@ -162,6 +162,51 @@
 );
 
 /*
+ * ARM Processor Events Report
+ *
+ * This event is generated when hardware detects an ARM processor error
+ * has occurred. UEFI 2.6 spec section N.2.4.4.
+ */
+TRACE_EVENT(arm_event,
+
+	TP_PROTO(const struct cper_sec_proc_arm *proc),
+
+	TP_ARGS(proc),
+
+	TP_STRUCT__entry(
+		__field(u64, mpidr)
+		__field(u64, midr)
+		__field(u32, running_state)
+		__field(u32, psci_state)
+		__field(u8, affinity)
+	),
+
+	TP_fast_assign(
+		if (proc->validation_bits & CPER_ARM_VALID_AFFINITY_LEVEL)
+			__entry->affinity = proc->affinity_level;
+		else
+			__entry->affinity = ~0;
+		if (proc->validation_bits & CPER_ARM_VALID_MPIDR)
+			__entry->mpidr = proc->mpidr;
+		else
+			__entry->mpidr = 0ULL;
+		__entry->midr = proc->midr;
+		if (proc->validation_bits & CPER_ARM_VALID_RUNNING_STATE) {
+			__entry->running_state = proc->running_state;
+			__entry->psci_state = proc->psci_state;
+		} else {
+			__entry->running_state = ~0;
+			__entry->psci_state = ~0;
+		}
+	),
+
+	TP_printk("affinity level: %d; MPIDR: %016llx; MIDR: %016llx; "
+		  "running state: %d; PSCI state: %d",
+		  __entry->affinity, __entry->mpidr, __entry->midr,
+		  __entry->running_state, __entry->psci_state)
+);
+
+/*
  * Non-Standard Section Report
  *
  * This event is generated when hardware detected a hardware
-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
