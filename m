From: Tyler Baicar <tbaicar@codeaurora.org>
Subject: [PATCH V17 09/11] ras: acpi / apei: generate trace event for
 unrecognized CPER section
Date: Fri, 19 May 2017 14:32:11 -0600
Message-ID: <1495225933-4410-10-git-send-email-tbaicar@codeaurora.org>
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

The UEFI spec includes non-standard section type support in the
Common Platform Error Record. This is defined in section N.2.3 of
UEFI version 2.5.

Currently if the CPER section's type (UUID) does not match any
section type that the kernel knows how to parse, a trace event is
not generated.

Generate a trace event which contains the raw error data for
non-standard section type error records.

Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
CC: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
Tested-by: Shiju Jose <shiju.jose@huawei.com>
---
 drivers/acpi/apei/ghes.c  | 27 +++++++++++++++++++++++----
 drivers/ras/ras.c         | 10 +++++++++-
 include/linux/ras.h       | 12 ++++++++++++
 include/ras/ras_event.h   | 45 +++++++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/uuid.h |  6 ++++--
 5 files changed, 93 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index fadfb43..16adbc8 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -45,11 +45,14 @@
 #include <linux/aer.h>
 #include <linux/nmi.h>
 #include <linux/sched/clock.h>
+#include <linux/uuid.h>
+#include <linux/ras.h>
 
 #include <acpi/actbl1.h>
 #include <acpi/ghes.h>
 #include <acpi/apei.h>
 #include <asm/tlbflush.h>
+#include <ras/ras_event.h>
 
 #include "apei-internal.h"
 
@@ -460,12 +463,22 @@ static void ghes_do_proc(struct ghes *ghes,
 {
 	int sev, sec_sev;
 	struct acpi_hest_generic_data *gdata;
+	uuid_le sec_type;
+	uuid_le *fru_id = &NULL_UUID_LE;
+	char *fru_text = "";
 
 	sev = ghes_severity(estatus->error_severity);
 	apei_estatus_for_each_section(estatus, gdata) {
 		sec_sev = ghes_severity(gdata->error_severity);
-		if (!uuid_le_cmp(*(uuid_le *)gdata->section_type,
-				 CPER_SEC_PLATFORM_MEM)) {
+		sec_type = *(uuid_le *)gdata->section_type;
+
+		if (gdata->validation_bits & CPER_SEC_VALID_FRU_ID)
+			fru_id = (uuid_le *)gdata->fru_id;
+
+		if (gdata->validation_bits & CPER_SEC_VALID_FRU_TEXT)
+			fru_text = gdata->fru_text;
+
+		if (!uuid_le_cmp(sec_type, CPER_SEC_PLATFORM_MEM)) {
 			struct cper_sec_mem_err *mem_err = acpi_hest_get_payload(gdata);
 
 			ghes_edac_report_mem_error(ghes, sev, mem_err);
@@ -474,8 +487,7 @@ static void ghes_do_proc(struct ghes *ghes,
 			ghes_handle_memory_failure(gdata, sev);
 		}
 #ifdef CONFIG_ACPI_APEI_PCIEAER
-		else if (!uuid_le_cmp(*(uuid_le *)gdata->section_type,
-				      CPER_SEC_PCIE)) {
+		else if (!uuid_le_cmp(sec_type, CPER_SEC_PCIE)) {
 			struct cper_sec_pcie *pcie_err = acpi_hest_get_payload(gdata);
 
 			if (sev == GHES_SEV_RECOVERABLE &&
@@ -506,6 +518,13 @@ static void ghes_do_proc(struct ghes *ghes,
 
 		}
 #endif
+		else {
+			void *err = acpi_hest_get_payload(gdata);
+
+			log_non_standard_event(&sec_type, fru_id, fru_text,
+					       sec_sev, err,
+					       gdata->error_data_length);
+		}
 	}
 }
 
diff --git a/drivers/ras/ras.c b/drivers/ras/ras.c
index 94f8038..e87fd9e 100644
--- a/drivers/ras/ras.c
+++ b/drivers/ras/ras.c
@@ -7,11 +7,19 @@
 
 #include <linux/init.h>
 #include <linux/ras.h>
+#include <linux/uuid.h>
 
 #define CREATE_TRACE_POINTS
 #define TRACE_INCLUDE_PATH ../../include/ras
 #include <ras/ras_event.h>
 
+void log_non_standard_event(const uuid_le *sec_type, const uuid_le *fru_id,
+			    const char *fru_text, const u8 sev, const u8 *err,
+			    const u32 len)
+{
+	trace_non_standard_event(sec_type, fru_id, fru_text, sev, err, len);
+}
+
 static int __init ras_init(void)
 {
 	int rc = 0;
@@ -27,7 +35,7 @@ static int __init ras_init(void)
 EXPORT_TRACEPOINT_SYMBOL_GPL(extlog_mem_event);
 #endif
 EXPORT_TRACEPOINT_SYMBOL_GPL(mc_event);
-
+EXPORT_TRACEPOINT_SYMBOL_GPL(non_standard_event);
 
 int __init parse_ras_param(char *str)
 {
diff --git a/include/linux/ras.h b/include/linux/ras.h
index ffb1471..a7f3ed3 100644
--- a/include/linux/ras.h
+++ b/include/linux/ras.h
@@ -2,6 +2,7 @@
 #define __RAS_H__
 
 #include <asm/errno.h>
+#include <linux/uuid.h>
 
 #ifdef CONFIG_DEBUG_FS
 int ras_userspace_consumers(void);
@@ -22,4 +23,15 @@ static inline void __init cec_init(void)	{ }
 static inline int cec_add_elem(u64 pfn)		{ return -ENODEV; }
 #endif
 
+#ifdef CONFIG_RAS
+void log_non_standard_event(const uuid_le *sec_type,
+			    const uuid_le *fru_id, const char *fru_text,
+			    const u8 sev, const u8 *err, const u32 len);
+#else
+static void log_non_standard_event(const uuid_le *sec_type,
+				   const uuid_le *fru_id, const char *fru_text,
+				   const u8 sev, const u8 *err,
+				   const u32 len) { return; }
+#endif
+
 #endif /* __RAS_H__ */
diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
index 1791a12..4f79ba9 100644
--- a/include/ras/ras_event.h
+++ b/include/ras/ras_event.h
@@ -162,6 +162,51 @@
 );
 
 /*
+ * Non-Standard Section Report
+ *
+ * This event is generated when hardware detected a hardware
+ * error event, which may be of non-standard section as defined
+ * in UEFI spec appendix "Common Platform Error Record", or may
+ * be of sections for which TRACE_EVENT is not defined.
+ *
+ */
+TRACE_EVENT(non_standard_event,
+
+	TP_PROTO(const uuid_le *sec_type,
+		 const uuid_le *fru_id,
+		 const char *fru_text,
+		 const u8 sev,
+		 const u8 *err,
+		 const u32 len),
+
+	TP_ARGS(sec_type, fru_id, fru_text, sev, err, len),
+
+	TP_STRUCT__entry(
+		__array(char, sec_type, UUID_SIZE)
+		__array(char, fru_id, UUID_SIZE)
+		__string(fru_text, fru_text)
+		__field(u8, sev)
+		__field(u32, len)
+		__dynamic_array(u8, buf, len)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->sec_type, sec_type, UUID_SIZE);
+		memcpy(__entry->fru_id, fru_id, UUID_SIZE);
+		__assign_str(fru_text, fru_text);
+		__entry->sev = sev;
+		__entry->len = len;
+		memcpy(__get_dynamic_array(buf), err, len);
+	),
+
+	TP_printk("severity: %d; sec type:%pU; FRU: %pU %s; data len:%d; raw data:%s",
+		  __entry->sev, __entry->sec_type,
+		  __entry->fru_id, __get_str(fru_text),
+		  __entry->len,
+		  __print_hex(__get_dynamic_array(buf), __entry->len))
+);
+
+/*
  * PCIe AER Trace event
  *
  * These events are generated when hardware detects a corrected or
diff --git a/include/uapi/linux/uuid.h b/include/uapi/linux/uuid.h
index 3738e5f..c477464 100644
--- a/include/uapi/linux/uuid.h
+++ b/include/uapi/linux/uuid.h
@@ -20,12 +20,14 @@
 #include <linux/types.h>
 #include <linux/string.h>
 
+#define UUID_SIZE 16
+
 typedef struct {
-	__u8 b[16];
+	__u8 b[UUID_SIZE];
 } uuid_le;
 
 typedef struct {
-	__u8 b[16];
+	__u8 b[UUID_SIZE];
 } uuid_be;
 
 #define UUID_LE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)		\
-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
