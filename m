From: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH V11 08/10] ras: acpi / apei: generate trace event for unrecognized CPER section
Date: Tue, 21 Feb 2017 14:21:59 -0700
Message-ID: <1487712121-16688-9-git-send-email-tbaicar@codeaurora.org>
References: <1487712121-16688-1-git-send-email-tbaicar@codeaurora.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487712121-16688-1-git-send-email-tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, nkaje-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, james.morse-5wv7dgnIgG8@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, eun.taik.lee-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, sandeepa.s.prabhu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, shijie.huang-5wv7dgnIgG8@public.gmane.org, rruigrok-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org, tn-nYOzD4b6Jr9Wk0Htik3J/w@public.gmane.org, fu.wei-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
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

Signed-off-by: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
CC: Jonathan (Zhixiong) Zhang <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
---
 drivers/acpi/apei/ghes.c | 24 ++++++++++++++++++++++--
 drivers/ras/ras.c        |  1 +
 include/ras/ras_event.h  | 45 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 68 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index d6a3b9f..842c0cc 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -44,11 +44,13 @@
 #include <linux/pci.h>
 #include <linux/aer.h>
 #include <linux/nmi.h>
+#include <linux/uuid.h>
 
 #include <acpi/actbl1.h>
 #include <acpi/ghes.h>
 #include <acpi/apei.h>
 #include <asm/tlbflush.h>
+#include <ras/ras_event.h>
 
 #include "apei-internal.h"
 
@@ -453,11 +455,21 @@ static void ghes_do_proc(struct ghes *ghes,
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
+		sec_type = *(uuid_le *)gdata->section_type;
+
+		if (gdata->validation_bits & CPER_SEC_VALID_FRU_ID)
+			fru_id = (uuid_le *)gdata->fru_id;
+		if (gdata->validation_bits & CPER_SEC_VALID_FRU_TEXT)
+			fru_text = gdata->fru_text;
+
+		if (!uuid_le_cmp(sec_type,
 				 CPER_SEC_PLATFORM_MEM)) {
 			struct cper_sec_mem_err *mem_err;
 
@@ -468,7 +480,7 @@ static void ghes_do_proc(struct ghes *ghes,
 			ghes_handle_memory_failure(gdata, sev);
 		}
 #ifdef CONFIG_ACPI_APEI_PCIEAER
-		else if (!uuid_le_cmp(*(uuid_le *)gdata->section_type,
+		else if (!uuid_le_cmp(sec_type,
 				      CPER_SEC_PCIE)) {
 			struct cper_sec_pcie *pcie_err;
 
@@ -501,6 +513,14 @@ static void ghes_do_proc(struct ghes *ghes,
 
 		}
 #endif
+#ifdef CONFIG_RAS
+		else if (trace_unknown_sec_event_enabled()) {
+			void *unknown_err = acpi_hest_generic_data_payload(gdata);
+			trace_unknown_sec_event(&sec_type,
+					fru_id, fru_text, sec_sev,
+					unknown_err, gdata->error_data_length);
+		}
+#endif
 	}
 }
 
diff --git a/drivers/ras/ras.c b/drivers/ras/ras.c
index b67dd36..fb2500b 100644
--- a/drivers/ras/ras.c
+++ b/drivers/ras/ras.c
@@ -27,3 +27,4 @@ static int __init ras_init(void)
 EXPORT_TRACEPOINT_SYMBOL_GPL(extlog_mem_event);
 #endif
 EXPORT_TRACEPOINT_SYMBOL_GPL(mc_event);
+EXPORT_TRACEPOINT_SYMBOL_GPL(unknown_sec_event);
diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
index 1791a12..5861b6f 100644
--- a/include/ras/ras_event.h
+++ b/include/ras/ras_event.h
@@ -162,6 +162,51 @@
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
