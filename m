From: Tyler Baicar <tbaicar@codeaurora.org>
Subject: [PATCH V4 09/10] trace, ras: add ARM processor error trace event
Date: Fri, 21 Oct 2016 11:30:12 -0600
Message-ID: <1477071013-29563-10-git-send-email-tbaicar@codeaurora.org>
References: <1477071013-29563-1-git-send-email-tbaicar@codeaurora.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1477071013-29563-1-git-send-email-tbaicar@codeaurora.org>
Sender: kvm-owner@vger.kernel.org
To: marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, nkaje@codeaurora.org, zjzhang@codeaurora.org, mark.rutland@arm.com, james.morse@arm.com, akpm@linux-foundation.org, eun.taik.lee@samsung.com, sandeepa.s.prabhu@gmail.com, shijie.huang@arm.com, rruigrok@codeaurora.org, paul.gortmaker@windriver.com, tomasz.nowicki@linaro.org, fu.wei@linaro.org, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, Suzuki.Poulose@arm.com, punit.agrawal
Cc: Tyler Baicar <tbaicar@codeaurora.org>
List-Id: linux-efi@vger.kernel.org

Currently there are trace events for the various RAS
errors with the exception of ARM processor type errors.
Add a new trace event for such errors so that the user
will know when they occur. These trace events are
consistent with the ARM processor error section type
defined in UEFI 2.6 spec section N.2.4.4.

Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
---
 drivers/acpi/apei/ghes.c    |  9 +++++++-
 drivers/firmware/efi/cper.c |  1 +
 drivers/ras/ras.c           |  1 +
 include/ras/ras_event.h     | 55 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 65 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index b1a1edb..ae6dedb 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -515,7 +515,14 @@ static void ghes_do_proc(struct ghes *ghes,
 
 		}
 #endif
-		else {
+		else if (!uuid_le_cmp(sec_type, CPER_SEC_PROC_ARMV8)) {
+			struct cper_sec_proc_armv8 *armv8_err;
+			struct cper_armv8_err_info *err_info;
+
+			armv8_err = acpi_hest_generic_data_payload(gdata);
+			err_info = (void *)(armv8_err +1);
+			trace_arm_event(armv8_err, err_info);
+		} else {
 			void *unknown_err = acpi_hest_generic_data_payload(gdata);
 			trace_unknown_sec_event(&sec_type,
 					fru_id, fru_text, sec_sev,
diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index 866a623..3a1a867 100644
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
@@ -28,3 +28,4 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(extlog_mem_event);
 #endif
 EXPORT_TRACEPOINT_SYMBOL_GPL(mc_event);
 EXPORT_TRACEPOINT_SYMBOL_GPL(unknown_sec_event);
+EXPORT_TRACEPOINT_SYMBOL_GPL(arm_event);
diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
index 5861b6f..0060bba 100644
--- a/include/ras/ras_event.h
+++ b/include/ras/ras_event.h
@@ -162,6 +162,61 @@ TRACE_EVENT(mc_event,
 );
 
 /*
+ * ARM Processor Events Report
+ *
+ * This event is generated when hardware detects an ARM processor error
+ * has occurred. UEFI 2.6 spec section N.2.4.4.
+ */
+TRACE_EVENT(arm_event,
+
+	TP_PROTO(const struct cper_sec_proc_armv8 *proc,
+		 struct cper_armv8_err_info *err_info),
+
+	TP_ARGS(proc, err_info),
+
+	TP_STRUCT__entry(
+		__field(u64, mpidr)
+		__field(u64, midr)
+		__field(u64, info)
+		__field(u64, virt_fault_addr)
+		__field(u64, phys_fault_addr)
+		__field(u32, running_state)
+		__field(u32, psci_state)
+		__field(u16, err_count)
+		__field(u8, affinity)
+		__field(u8, version)
+		__field(u8, type)
+		__field(u8, flags)
+	),
+
+	TP_fast_assign(
+		__entry->affinity = proc->affinity_level;
+		__entry->mpidr = proc->mpidr;
+		__entry->midr = proc->midr;
+		__entry->running_state = proc->running_state;
+		__entry->psci_state = proc->psci_state;
+		__entry->version = err_info->version;
+		__entry->type = err_info->type;
+		__entry->err_count = err_info->multiple_error;
+		__entry->flags = err_info->flags;
+		__entry->info = err_info->error_info;
+		__entry->virt_fault_addr = err_info->virt_fault_addr;
+		__entry->phys_fault_addr = err_info->physical_fault_addr;
+	),
+
+	TP_printk("affinity level: %d; MPIDR: %016llx; MIDR: %016llx; "
+		  "running state: %d; PSCI state: %d; version: %d; type: %d; "
+		  "error count: 0x%04x; flags: 0x%02x; info: %016llx; "
+		  "virtual fault address: %016llx; "
+		  "physical fault address: %016llx",
+		  __entry->affinity, __entry->mpidr, __entry->midr,
+		  __entry->running_state, __entry->psci_state, __entry->version,
+		  __entry->type, __entry->err_count, __entry->flags,
+		  __entry->info, __entry->virt_fault_addr,
+		  __entry->phys_fault_addr)
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

