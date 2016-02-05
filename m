From: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH V1 2/6] ras: acpi/apei: cper: generic error data entry v3 per ACPI 6.1
Date: Fri,  5 Feb 2016 12:13:24 -0700
Message-ID: <1454699608-22760-3-git-send-email-tbaicar@codeaurora.org>
References: <1454699608-22760-1-git-send-email-tbaicar@codeaurora.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454699608-22760-1-git-send-email-tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: fu.wei-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, harba-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, rruigrok-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, ahs3-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Robert Moore <robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lv Zheng <lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-E0kO6a4B6psdnm+yROfE0A@public.gmane.org
Cc: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Naveen Kaje <nkaje-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Currently when a RAS error is reported it is not timestamped.
The ACPI 6.1 spec adds the timestamp field to the generic error
data entry v3 structure. The timestamp of when the firmware
generated the error is now being reported.

Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Signed-off-by: Richard Ruigrok <rruigrok-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Signed-off-by: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Signed-off-by: Naveen Kaje <nkaje-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
---
 drivers/acpi/apei/ghes.c    |  35 ++++++++++++--
 drivers/firmware/efi/cper.c | 108 +++++++++++++++++++++++++++++++++++++-------
 include/acpi/actbl1.h       |  19 ++++++++
 3 files changed, 142 insertions(+), 20 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index db67711..6c68100 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -414,7 +414,15 @@ static void ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata, int
 	int flags = -1;
 	int sec_sev = ghes_severity(gdata->error_severity);
 	struct cper_sec_mem_err *mem_err;
-	mem_err = (struct cper_sec_mem_err *)(gdata + 1);
+	struct acpi_hest_generic_data_v3 *gdata_v3 = NULL;
+
+	if ((gdata->revision >> 8) >= 0x03)
+		gdata_v3 = (struct acpi_hest_generic_data_v3 *)gdata;
+
+	if (gdata_v3)
+		mem_err = (struct cper_sec_mem_err *)(gdata_v3 + 1);
+	else
+		mem_err = (struct cper_sec_mem_err *)(gdata + 1);
 
 	if (!(mem_err->validation_bits & CPER_MEM_VALID_PA))
 		return;
@@ -444,14 +452,27 @@ static void ghes_do_proc(struct ghes *ghes,
 {
 	int sev, sec_sev;
 	struct acpi_hest_generic_data *gdata;
+	struct acpi_hest_generic_data_v3 *gdata_v3 = NULL;
+	uuid_le sec_type;
 
 	sev = ghes_severity(estatus->error_severity);
 	apei_estatus_for_each_section(estatus, gdata) {
 		sec_sev = ghes_severity(gdata->error_severity);
-		if (!uuid_le_cmp(*(uuid_le *)gdata->section_type,
+		sec_type = *(uuid_le *)gdata->section_type;
+
+		if ((gdata->revision >> 8) >= 0x03)
+			gdata_v3 = (struct acpi_hest_generic_data_v3 *)gdata;
+
+		if (!uuid_le_cmp(sec_type,
 				 CPER_SEC_PLATFORM_MEM)) {
 			struct cper_sec_mem_err *mem_err;
-			mem_err = (struct cper_sec_mem_err *)(gdata+1);
+
+			if (gdata_v3)
+				mem_err = (struct cper_sec_mem_err *)
+					  (gdata_v3 + 1);
+			else
+				mem_err = (struct cper_sec_mem_err *)
+					  (gdata + 1);
 			ghes_edac_report_mem_error(ghes, sev, mem_err);
 
 			arch_apei_report_mem_error(sev, mem_err);
@@ -461,7 +482,13 @@ static void ghes_do_proc(struct ghes *ghes,
 		else if (!uuid_le_cmp(*(uuid_le *)gdata->section_type,
 				      CPER_SEC_PCIE)) {
 			struct cper_sec_pcie *pcie_err;
-			pcie_err = (struct cper_sec_pcie *)(gdata+1);
+
+			if (gdata_v3)
+				pcie_err = (struct cper_sec_pcie *)
+					   (gdata_v3 + 1);
+			else
+				pcie_err = (struct cper_sec_pcie *)
+					   (gdata + 1);
 			if (sev == GHES_SEV_RECOVERABLE &&
 			    sec_sev == GHES_SEV_RECOVERABLE &&
 			    pcie_err->validation_bits & CPER_PCIE_VALID_DEVICE_ID &&
diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index d425374..accd351 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -32,6 +32,8 @@
 #include <linux/acpi.h>
 #include <linux/pci.h>
 #include <linux/aer.h>
+#include <linux/printk.h>
+#include <linux/bcd.h>
 
 #define INDENT_SP	" "
 
@@ -392,6 +394,10 @@ static void cper_estatus_print_section(
 	uuid_le *sec_type = (uuid_le *)gdata->section_type;
 	__u16 severity;
 	char newpfx[64];
+	struct acpi_hest_generic_data_v3 *gdata_v3 = NULL;
+
+	if ((gdata->revision >> 8) >= 0x03)
+		gdata_v3 = (struct acpi_hest_generic_data_v3 *)gdata;
 
 	severity = gdata->error_severity;
 	printk("%s""Error %d, type: %s\n", pfx, sec_no,
@@ -403,14 +409,24 @@ static void cper_estatus_print_section(
 
 	snprintf(newpfx, sizeof(newpfx), "%s%s", pfx, INDENT_SP);
 	if (!uuid_le_cmp(*sec_type, CPER_SEC_PROC_GENERIC)) {
-		struct cper_sec_proc_generic *proc_err = (void *)(gdata + 1);
+		struct cper_sec_proc_generic *proc_err;
+
+		if (gdata_v3)
+			proc_err = (void *)(gdata_v3 + 1);
+		else
+			proc_err = (void *)(gdata + 1);
 		printk("%s""section_type: general processor error\n", newpfx);
 		if (gdata->error_data_length >= sizeof(*proc_err))
 			cper_print_proc_generic(newpfx, proc_err);
 		else
 			goto err_section_too_small;
 	} else if (!uuid_le_cmp(*sec_type, CPER_SEC_PLATFORM_MEM)) {
-		struct cper_sec_mem_err *mem_err = (void *)(gdata + 1);
+		struct cper_sec_mem_err *mem_err;
+
+		if (gdata_v3)
+			mem_err = (void *)(gdata_v3 + 1);
+		else
+			mem_err = (void *)(gdata + 1);
 		printk("%s""section_type: memory error\n", newpfx);
 		if (gdata->error_data_length >=
 		    sizeof(struct cper_sec_mem_err_old))
@@ -419,7 +435,12 @@ static void cper_estatus_print_section(
 		else
 			goto err_section_too_small;
 	} else if (!uuid_le_cmp(*sec_type, CPER_SEC_PCIE)) {
-		struct cper_sec_pcie *pcie = (void *)(gdata + 1);
+		struct cper_sec_pcie *pcie;
+
+		if (gdata_v3)
+			pcie = (void *)(gdata_v3 + 1);
+		else
+			pcie = (void *)(gdata + 1);
 		printk("%s""section_type: PCIe error\n", newpfx);
 		if (gdata->error_data_length >= sizeof(*pcie))
 			cper_print_pcie(newpfx, pcie, gdata);
@@ -434,10 +455,36 @@ err_section_too_small:
 	pr_err(FW_WARN "error section length is too small\n");
 }
 
+static void cper_estatus_print_section_v3(const char *pfx,
+	const struct acpi_hest_generic_data_v3 *gdata, int sec_no)
+{
+	__u8 hour, min, sec, day, mon, *timestamp;
+	__u16 year;
+
+		if (gdata->gdata_v2.validation_bits & GED_VALID_TIMESTAMP) {
+			timestamp = (__u8 *)&(gdata->timestamp);
+			memcpy(&sec, timestamp, 1);
+			memcpy(&min, timestamp + 1, 1);
+			memcpy(&hour, timestamp + 2, 1);
+			memcpy(&day, timestamp + 4, 1);
+			memcpy(&mon, timestamp + 5, 1);
+			memcpy(&year, timestamp + 6, 2);
+			printk("%stime: ", pfx);
+			printk("%7s", 0x01 & *(timestamp + 3) ? "precise" : "");
+			printk(" %02d:%02d:%02d %04d-%02d-%02d\n",
+				bcd2bin(hour), bcd2bin(min), bcd2bin(sec),
+				year, bcd2bin(mon),
+				bcd2bin(day));
+		}
+
+	cper_estatus_print_section(pfx, &(gdata->gdata_v2), sec_no);
+}
+
 void cper_estatus_print(const char *pfx,
 			const struct acpi_hest_generic_status *estatus)
 {
 	struct acpi_hest_generic_data *gdata;
+	struct acpi_hest_generic_data_v3 *gdata_v3 = NULL;
 	unsigned int data_len, gedata_len;
 	int sec_no = 0;
 	char newpfx[64];
@@ -451,13 +498,27 @@ void cper_estatus_print(const char *pfx,
 	printk("%s""event severity: %s\n", pfx, cper_severity_str(severity));
 	data_len = estatus->data_length;
 	gdata = (struct acpi_hest_generic_data *)(estatus + 1);
+	if ((gdata->revision >> 8) >= 0x03)
+		gdata_v3 = (struct acpi_hest_generic_data_v3 *)gdata;
+
 	snprintf(newpfx, sizeof(newpfx), "%s%s", pfx, INDENT_SP);
-	while (data_len >= sizeof(*gdata)) {
-		gedata_len = gdata->error_data_length;
-		cper_estatus_print_section(newpfx, gdata, sec_no);
-		data_len -= gedata_len + sizeof(*gdata);
-		gdata = (void *)(gdata + 1) + gedata_len;
-		sec_no++;
+
+	if (gdata_v3) {
+		while (data_len >= sizeof(*gdata_v3)) {
+			gedata_len = gdata_v3->gdata_v2.error_data_length;
+			cper_estatus_print_section_v3(newpfx, gdata_v3, sec_no);
+			data_len -= gedata_len + sizeof(*gdata_v3);
+			gdata_v3 = (void *)(gdata_v3 + 1) + gedata_len;
+			sec_no++;
+		}
+	} else {
+		while (data_len >= sizeof(*gdata)) {
+			gedata_len = gdata->error_data_length;
+			cper_estatus_print_section(newpfx, gdata, sec_no);
+			data_len -= gedata_len + sizeof(*gdata);
+			gdata = (void *)(gdata + 1) + gedata_len;
+			sec_no++;
+		}
 	}
 }
 EXPORT_SYMBOL_GPL(cper_estatus_print);
@@ -478,6 +539,7 @@ EXPORT_SYMBOL_GPL(cper_estatus_check_header);
 int cper_estatus_check(const struct acpi_hest_generic_status *estatus)
 {
 	struct acpi_hest_generic_data *gdata;
+	struct acpi_hest_generic_data_v3 *gdata_v3 = NULL;
 	unsigned int data_len, gedata_len;
 	int rc;
 
@@ -486,15 +548,29 @@ int cper_estatus_check(const struct acpi_hest_generic_status *estatus)
 		return rc;
 	data_len = estatus->data_length;
 	gdata = (struct acpi_hest_generic_data *)(estatus + 1);
-	while (data_len >= sizeof(*gdata)) {
-		gedata_len = gdata->error_data_length;
-		if (gedata_len > data_len - sizeof(*gdata))
+
+	if ((gdata->revision >> 8) >= 0x03) {
+		gdata_v3 = (struct acpi_hest_generic_data_v3 *)gdata;
+		while (data_len >= sizeof(*gdata_v3)) {
+			gedata_len = gdata_v3->gdata_v2.error_data_length;
+			if (gedata_len > data_len - sizeof(*gdata_v3))
+				return -EINVAL;
+			data_len -= gedata_len + sizeof(*gdata_v3);
+			gdata_v3 = (void *)(gdata_v3 + 1) + gedata_len;
+		}
+		if (data_len)
+			return -EINVAL;
+	} else {
+		while (data_len >= sizeof(*gdata)) {
+			gedata_len = gdata->error_data_length;
+			if (gedata_len > data_len - sizeof(*gdata))
+				return -EINVAL;
+			data_len -= gedata_len + sizeof(*gdata);
+			gdata = (void *)(gdata + 1) + gedata_len;
+		}
+		if (data_len)
 			return -EINVAL;
-		data_len -= gedata_len + sizeof(*gdata);
-		gdata = (void *)(gdata + 1) + gedata_len;
 	}
-	if (data_len)
-		return -EINVAL;
 
 	return 0;
 }
diff --git a/include/acpi/actbl1.h b/include/acpi/actbl1.h
index 82695c9..231ae1e 100644
--- a/include/acpi/actbl1.h
+++ b/include/acpi/actbl1.h
@@ -653,6 +653,25 @@ struct acpi_hest_generic_data {
 	u8 fru_text[20];
 };
 
+/* Generic Error Data entry version 3 as defined by ACPI 6.1 spec */
+
+struct acpi_hest_generic_data_v3 {
+	struct acpi_hest_generic_data gdata_v2;
+	__u64                         timestamp;
+};
+
+/*
+ * Validation bits definition for validation_bits in struct
+ * acpi_hest_generic_data[_v3]. If set, corresponding fields in
+ * the struct contain valid information.
+ */
+/* corresponds fru_id */
+#define GED_VALID_FRU_ID                  0x0001
+/* corresponds fru_text */
+#define GED_VALID_FRU_TEXT                0x0002
+/* corresponds timestamp */
+#define GED_VALID_TIMESTAMP               0x0004
+
 /*******************************************************************************
  *
  * MADT - Multiple APIC Description Table
-- 
1.8.2.1
