From: Tyler Baicar <tbaicar@codeaurora.org>
Subject: [PATCH V11 09/10] trace, ras: add ARM processor error trace event
Date: Tue, 21 Feb 2017 14:22:00 -0700
Message-ID: <1487712121-16688-10-git-send-email-tbaicar@codeaurora.org>
References: <1487712121-16688-1-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <1487712121-16688-1-git-send-email-tbaicar@codeaurora.org>
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

Currently there are trace events for the various RAS
errors with the exception of ARM processor type errors.
Add a new trace event for such errors so that the user
will know when they occur. These trace events are
consistent with the ARM processor error section type
defined in UEFI 2.6 spec section N.2.4.4.

Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/acpi/apei/ghes.c    |  8 +++++++-
 drivers/firmware/efi/cper.c |  1 +
 drivers/ras/ras.c           |  1 +
 include/ras/ras_event.h     | 34 ++++++++++++++++++++++++++++++++++
 4 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 842c0cc..81d7b79 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -514,7 +514,13 @@ static void ghes_do_proc(struct ghes *ghes,
 		}
 #endif
 #ifdef CONFIG_RAS
-		else if (trace_unknown_sec_event_enabled()) {
+		else if (!uuid_le_cmp(sec_type, CPER_SEC_PROC_ARM) &&
+			 trace_arm_event_enabled()) {
+			struct cper_sec_proc_arm *arm_err;
+
+			arm_err = acpi_hest_generic_data_payload(gdata);
+			trace_arm_event(arm_err);
+		} else if (trace_unknown_sec_event_enabled()) {
 			void *unknown_err = acpi_hest_generic_data_payload(gdata);
 			trace_unknown_sec_event(&sec_type,
 					fru_id, fru_text, sec_sev,
diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index d1b6edc..fe0136f 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -35,6 +35,7 @@
 #include <linux/printk.h>
 #include <linux/bcd.h>
 #include <acpi/ghes.h>
+#include <ras/ras_event.h>
 
 #define INDENT_SP	" "
 
diff --git a/drivers/ras/ras.c b/drivers/ras/ras.c
index fb2500b..8ba5a94 100644
--- a/drivers/ras/ras.c
+++ b/drivers/ras/ras.c
@@ -28,3 +28,4 @@ static int __init ras_init(void)
 #endif
 EXPORT_TRACEPOINT_SYMBOL_GPL(mc_event);
 EXPORT_TRACEPOINT_SYMBOL_GPL(unknown_sec_event);
+EXPORT_TRACEPOINT_SYMBOL_GPL(arm_event);
diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
index 5861b6f..b36db48 100644
--- a/include/ras/ras_event.h
+++ b/include/ras/ras_event.h
@@ -162,6 +162,40 @@
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
+		__entry->affinity = proc->affinity_level;
+		__entry->mpidr = proc->mpidr;
+		__entry->midr = proc->midr;
+		__entry->running_state = proc->running_state;
+		__entry->psci_state = proc->psci_state;
+	),
+
+	TP_printk("affinity level: %d; MPIDR: %016llx; MIDR: %016llx; "
+		  "running state: %d; PSCI state: %d",
+		  __entry->affinity, __entry->mpidr, __entry->midr,
+		  __entry->running_state, __entry->psci_state)
+);
+
+/*
  * Unknown Section Report
  *
  * This event is generated when hardware detected a hardware
-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
