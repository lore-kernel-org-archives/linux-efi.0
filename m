From: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>
Subject: [PATCH 2/2] ras: acpi/apei: trace event for vendor proprietary CPER section
Date: Tue, 21 Jul 2015 16:36:47 -0700
Message-ID: <1437521807-27571-3-git-send-email-zjzhang@codeaurora.org>
References: <1437521807-27571-1-git-send-email-zjzhang@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1437521807-27571-1-git-send-email-zjzhang@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>, tony.luck@intel.com, fu.wei@linaro.org, al.stone@linaro.org, rjw@rjwysocki.net, mchehab@redhat.com, mingo@redhat.com, bp@alien8.de
Cc: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org, vgandhi@codeaurora.org, linux-acpi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>

Trace event is generated when hardware detected a hardware error
event, which is of non-standard section as defined in UEFI
spec appendix "Common Platform Error Record" (section N.2.3 of
UEFI version 2.5).

The trace buffer contains length of error data and raw error data
in hex.

Following is a sample output of "perf script":
_________swapper_____0_[000]___133.521441:_ras:vendor_event:_len=88_raw=11_20_0
0_01_16_04_15_20_01_00_00_01_02_00_00_00_45_43_43_5f_43_45_5f_52_4d_57_00_00_00
_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00
00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_80_fe_00_00_00_00_04_0
0_00_00_45_43_43_5f

Change-Id: Ic8661310133b0ae51f6b299cdde3cd0fa5517464
Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
---
 drivers/acpi/apei/ghes.c | 29 +++++++++++++++++++++++++++--
 drivers/ras/ras.c        |  1 +
 include/ras/ras_event.h  | 30 ++++++++++++++++++++++++++++++
 3 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 67fc948da17a..03114d27d218 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -53,9 +53,15 @@
 #include <acpi/ghes.h>
 #include <acpi/apei.h>
 #include <asm/tlbflush.h>
+#include <ras/ras_event.h>
 
 #include "apei-internal.h"
 
+static uuid_le sec_vendor_uuids[] = {
+	CPER_SEC_QTI_ERR,
+	NULL_UUID_LE,
+};
+
 #define GHES_PFX	"GHES: "
 
 #define GHES_ESTATUS_MAX_SIZE		65536
@@ -440,11 +446,14 @@ static void ghes_do_proc(struct ghes *ghes,
 {
 	int sev, sec_sev;
 	struct acpi_hest_generic_data *gdata;
+	uuid_le sec_type;
 
 	sev = ghes_severity(estatus->error_severity);
 	apei_estatus_for_each_section(estatus, gdata) {
 		sec_sev = ghes_severity(gdata->error_severity);
-		if (!uuid_le_cmp(*(uuid_le *)gdata->section_type,
+		sec_type = *(uuid_le *)gdata->section_type;
+
+		if (!uuid_le_cmp(sec_type,
 				 CPER_SEC_PLATFORM_MEM)) {
 			struct cper_sec_mem_err *mem_err;
 			mem_err = (struct cper_sec_mem_err *)(gdata+1);
@@ -454,7 +463,7 @@ static void ghes_do_proc(struct ghes *ghes,
 			ghes_handle_memory_failure(gdata, sev);
 		}
 #ifdef CONFIG_ACPI_APEI_PCIEAER
-		else if (!uuid_le_cmp(*(uuid_le *)gdata->section_type,
+		else if (!uuid_le_cmp(sec_type,
 				      CPER_SEC_PCIE)) {
 			struct cper_sec_pcie *pcie_err;
 			pcie_err = (struct cper_sec_pcie *)(gdata+1);
@@ -486,6 +495,22 @@ static void ghes_do_proc(struct ghes *ghes,
 
 		}
 #endif
+		else {
+			int i;
+
+			for (i = 0; uuid_le_cmp(sec_vendor_uuids[i],
+			     NULL_UUID_LE); i++) {
+				if (!uuid_le_cmp(sec_type,
+				    sec_vendor_uuids[i])) {
+					const void *vendor_err;
+
+					vendor_err = gdata + 1;
+					trace_vendor_event(vendor_err,
+						gdata->error_data_length);
+					break;
+				}
+			}
+		}
 	}
 }
 
diff --git a/drivers/ras/ras.c b/drivers/ras/ras.c
index b67dd362b7b6..a656ff131249 100644
--- a/drivers/ras/ras.c
+++ b/drivers/ras/ras.c
@@ -27,3 +27,4 @@ subsys_initcall(ras_init);
 EXPORT_TRACEPOINT_SYMBOL_GPL(extlog_mem_event);
 #endif
 EXPORT_TRACEPOINT_SYMBOL_GPL(mc_event);
+EXPORT_TRACEPOINT_SYMBOL_GPL(vendor_event);
diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
index 79abb9c71772..a3038653f72d 100644
--- a/include/ras/ras_event.h
+++ b/include/ras/ras_event.h
@@ -161,6 +161,36 @@ TRACE_EVENT(mc_event,
 );
 
 /*
+ * Vendor Proprietary Events Report
+ *
+ * Those event is generated when hardware detected a hardware
+ * error event, which is of non-standard section as defined
+ * in UEFI spec appendix "Common Platform Error Record".
+ *
+ */
+TRACE_EVENT(vendor_event,
+
+	TP_PROTO(const u8 *err,
+		 const u32 len),
+
+	TP_ARGS(err, len),
+
+	TP_STRUCT__entry(
+		__field(u32, len)
+		__dynamic_array(u8, buf, len)
+	),
+
+	TP_fast_assign(
+		__entry->len = len;
+		memcpy(__get_dynamic_array(buf), err, len);
+	),
+
+	TP_printk("len=%d raw=%s",
+		  __entry->len,
+		  __print_hex(__get_dynamic_array(buf), __entry->len))
+);
+
+/*
  * PCIe AER Trace event
  *
  * These events are generated when hardware detects a corrected or
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
