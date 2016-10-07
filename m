From: Tyler Baicar <tbaicar@codeaurora.org>
Subject: [PATCH V3 08/10] ras: acpi / apei: generate trace event for unrecognized CPER section
Date: Fri,  7 Oct 2016 15:31:20 -0600
Message-ID: <1475875882-2604-9-git-send-email-tbaicar@codeaurora.org>
References: <1475875882-2604-1-git-send-email-tbaicar@codeaurora.org>
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1475875882-2604-1-git-send-email-tbaicar@codeaurora.org>
Sender: linux-acpi-owner@vger.kernel.org
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, mark.rutland@arm.com, james.morse@arm.com, akpm@linux-foundation.org, sandeepa.s.prabhu@gmail.com, shijie.huang@arm.com, paul.gortmaker@windriver.com, tomasz.nowicki@linaro.org, fu.wei@linaro.org, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Dkvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, devel@acpica.org
Cc: Tyler Baicar <tbaicar@codeaurora.org>, "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>
List-Id: linux-efi@vger.kernel.org

UEFI spec allows for non-standard section in Common Platform Error
Record. This is defined in section N.2.3 of UEFI version 2.5.

Currently if the CPER section's type (UUID) does not match with
any section type that the kernel knows how to parse, trace event
is not generated for such section. And thus user is not able to know
happening of such hardware error, including error record of
non-standard section.

This commit generates a trace event which contains raw error data
for unrecognized CPER section.

Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
---
 drivers/acpi/apei/ghes.c | 18 +++++++++++++++++-
 drivers/ras/ras.c        |  1 +
 include/ras/ras_event.h  | 45 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 36894c8..cb4c7f4 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -49,6 +49,7 @@
 #include <acpi/ghes.h>
 #include <acpi/apei.h>
 #include <asm/tlbflush.h>
+#include <ras/ras_event.h>
 
 #ifdef CONFIG_HAVE_ACPI_APEI_SEA
 #include <asm/system_misc.h>
@@ -468,12 +469,21 @@ static void ghes_do_proc(struct ghes *ghes,
 	int sev, sec_sev;
 	struct acpi_hest_generic_data *gdata;
 	uuid_le sec_type;
+	uuid_le *fru_id;
+	char *fru_text = "";
 
 	sev = ghes_severity(estatus->error_severity);
 	apei_estatus_for_each_section(estatus, gdata) {
 		sec_sev = ghes_severity(gdata->error_severity);
 		sec_type = *(uuid_le *)gdata->section_type;
 
+		if (gdata->validation_bits & CPER_SEC_VALID_FRU_ID)
+			fru_id = (uuid_le *)gdata->fru_id;
+		else
+			fru_id = &NULL_UUID_LE;
+		if (gdata->validation_bits & CPER_SEC_VALID_FRU_TEXT)
+			fru_text = gdata->fru_text;
+
 		if (!uuid_le_cmp(sec_type,
 				 CPER_SEC_PLATFORM_MEM)) {
 			struct cper_sec_mem_err *mem_err;
@@ -485,7 +495,7 @@ static void ghes_do_proc(struct ghes *ghes,
 			ghes_handle_memory_failure(gdata, sev);
 		}
 #ifdef CONFIG_ACPI_APEI_PCIEAER
-		else if (!uuid_le_cmp(*(uuid_le *)gdata->section_type,
+		else if (!uuid_le_cmp(sec_type,
 				      CPER_SEC_PCIE)) {
 			struct cper_sec_pcie *pcie_err;
 
@@ -518,6 +528,12 @@ static void ghes_do_proc(struct ghes *ghes,
 
 		}
 #endif
+		else {
+			void *unknown_err = acpi_hest_generic_data_payload(gdata);
+			trace_unknown_sec_event(&sec_type,
+					fru_id, fru_text, sec_sev,
+					unknown_err, gdata->error_data_length);
+		}
 	}
 }
 
diff --git a/drivers/ras/ras.c b/drivers/ras/ras.c
index b67dd36..fb2500b 100644
--- a/drivers/ras/ras.c
+++ b/drivers/ras/ras.c
@@ -27,3 +27,4 @@ subsys_initcall(ras_init);
 EXPORT_TRACEPOINT_SYMBOL_GPL(extlog_mem_event);
 #endif
 EXPORT_TRACEPOINT_SYMBOL_GPL(mc_event);
+EXPORT_TRACEPOINT_SYMBOL_GPL(unknown_sec_event);
diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
index 1791a12..5861b6f 100644
--- a/include/ras/ras_event.h
+++ b/include/ras/ras_event.h
@@ -162,6 +162,51 @@ TRACE_EVENT(mc_event,
 );
 
 /*
+ * Unknown Section Report
+ *
+ * This event is generated when hardware detected a hardware
+ * error event, which may be of non-standard section as defined
+ * in UEFI spec appendix "Common Platform Error Record", or may
+ * be of sections for which TRACE_EVENT is not defined.
+ *
+ */
+TRACE_EVENT(unknown_sec_event,
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
+		__array(char, sec_type, 16)
+		__array(char, fru_id, 16)
+		__string(fru_text, fru_text)
+		__field(u8, sev)
+		__field(u32, len)
+		__dynamic_array(u8, buf, len)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->sec_type, sec_type, sizeof(uuid_le));
+		memcpy(__entry->fru_id, fru_id, sizeof(uuid_le));
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
-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.

