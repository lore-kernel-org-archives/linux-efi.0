From: Tyler Baicar <tbaicar@codeaurora.org>
Subject: [PATCH V2 2/9] ras: acpi/apei: cper: generic error data entry v3 per ACPI 6.1
Date: Wed,  6 Apr 2016 09:12:51 -0600
Message-ID: <1459955578-24602-3-git-send-email-tbaicar@codeaurora.org>
References: <1459955578-24602-1-git-send-email-tbaicar@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459955578-24602-1-git-send-email-tbaicar@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: fu.wei@linaro.org, timur@codeaurora.org, harba@codeaurora.org, rruigrok@codeaurora.org, ahs3@redhat.com, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, devel@acpica.org
Cc: Tyler Baicar <tbaicar@codeaurora.org>, "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>, Naveen Kaje <nkaje@codeaurora.org>
List-Id: linux-efi@vger.kernel.org

Currently when a RAS error is reported it is not timestamped.
The ACPI 6.1 spec adds the timestamp field to the generic error
data entry v3 structure. The timestamp of when the firmware
generated the error is now being reported.

Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
Signed-off-by: Richard Ruigrok <rruigrok@codeaurora.org>
Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
Signed-off-by: Naveen Kaje <nkaje@codeaurora.org>
---
 drivers/acpi/apei/ghes.c    |  35 ++++++++++++--
 drivers/firmware/efi/cper.c | 111 +++++++++++++++++++++++++++++++++++++-------
 2 files changed, 126 insertions(+), 20 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 9b0543e..a6848706 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -419,7 +419,15 @@ static void ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata, int
 	int flags = -1;
 	int sec_sev = ghes_severity(gdata->error_severity);
 	struct cper_sec_mem_err *mem_err;
-	mem_err = (struct cper_sec_mem_err *)(gdata + 1);
+	struct acpi_hest_generic_data_v300 *gdata_v3 = NULL;
+
+	if ((gdata->revision >> 8) >= 0x03)
+		gdata_v3 = (struct acpi_hest_generic_data_v300 *)gdata;
+
+	if (gdata_v3)
+		mem_err = (struct cper_sec_mem_err *)(gdata_v3 + 1);
+	else
+		mem_err = (struct cper_sec_mem_err *)(gdata + 1);
 
 	if (!(mem_err->validation_bits & CPER_MEM_VALID_PA))
 		return;
@@ -449,14 +457,27 @@ static void ghes_do_proc(struct ghes *ghes,
 {
 	int sev, sec_sev;
 	struct acpi_hest_generic_data *gdata;
+	struct acpi_hest_generic_data_v300 *gdata_v3 = NULL;
+	uuid_le sec_type;
 
 	sev = ghes_severity(estatus->error_severity);
 	apei_estatus_for_each_section(estatus, gdata) {
 		sec_sev = ghes_severity(gdata->error_severity);
-		if (!uuid_le_cmp(*(uuid_le *)gdata->section_type,
+		sec_type = *(uuid_le *)gdata->section_type;
+
+		if ((gdata->revision >> 8) >= 0x03)
+			gdata_v3 = (struct acpi_hest_generic_data_v300 *)gdata;
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
@@ -466,7 +487,13 @@ static void ghes_do_proc(struct ghes *ghes,
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
index d425374..23f62962 100644
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
+	struct acpi_hest_generic_data_v300 *gdata_v3 = NULL;
+
+	if ((gdata->revision >> 8) >= 0x03)
+		gdata_v3 = (struct acpi_hest_generic_data_v300 *)gdata;
 
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
@@ -434,10 +455,38 @@ err_section_too_small:
 	pr_err(FW_WARN "error section length is too small\n");
 }
 
+static void cper_estatus_print_section_v300(const char *pfx,
+	const struct acpi_hest_generic_data_v300 *gdata, int sec_no)
+{
+	__u8 hour, min, sec, day, mon, year, century, *timestamp;
+
+	if (gdata->validation_bits & ACPI_HEST_GEN_VALID_TIMESTAMP) {
+		timestamp = (__u8 *)&(gdata->time_stamp);
+		memcpy(&sec, timestamp, 1);
+		memcpy(&min, timestamp + 1, 1);
+		memcpy(&hour, timestamp + 2, 1);
+		memcpy(&day, timestamp + 4, 1);
+		memcpy(&mon, timestamp + 5, 1);
+		memcpy(&year, timestamp + 6, 1);
+		memcpy(&century, timestamp + 7, 1);
+		printk("%stime: ", pfx);
+		printk("%7s", 0x01 & *(timestamp + 3) ? "precise" : "");
+		printk(" %02d:%02d:%02d %02d%02d-%02d-%02d\n",
+			bcd2bin(hour), bcd2bin(min), bcd2bin(sec),
+			bcd2bin(century), bcd2bin(year), bcd2bin(mon),
+			bcd2bin(day));
+	}
+
+	cper_estatus_print_section(pfx,
+				   (const struct acpi_hest_generic_data *)gdata,
+				   sec_no);
+}
+
 void cper_estatus_print(const char *pfx,
 			const struct acpi_hest_generic_status *estatus)
 {
 	struct acpi_hest_generic_data *gdata;
+	struct acpi_hest_generic_data_v300 *gdata_v3 = NULL;
 	unsigned int data_len, gedata_len;
 	int sec_no = 0;
 	char newpfx[64];
@@ -451,13 +500,28 @@ void cper_estatus_print(const char *pfx,
 	printk("%s""event severity: %s\n", pfx, cper_severity_str(severity));
 	data_len = estatus->data_length;
 	gdata = (struct acpi_hest_generic_data *)(estatus + 1);
+	if ((gdata->revision >> 8) >= 0x03)
+		gdata_v3 = (struct acpi_hest_generic_data_v300 *)gdata;
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
+			gedata_len = gdata_v3->error_data_length;
+			cper_estatus_print_section_v300(newpfx, gdata_v3,
+							sec_no);
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
@@ -478,6 +542,7 @@ EXPORT_SYMBOL_GPL(cper_estatus_check_header);
 int cper_estatus_check(const struct acpi_hest_generic_status *estatus)
 {
 	struct acpi_hest_generic_data *gdata;
+	struct acpi_hest_generic_data_v300 *gdata_v3 = NULL;
 	unsigned int data_len, gedata_len;
 	int rc;
 
@@ -486,15 +551,29 @@ int cper_estatus_check(const struct acpi_hest_generic_status *estatus)
 		return rc;
 	data_len = estatus->data_length;
 	gdata = (struct acpi_hest_generic_data *)(estatus + 1);
-	while (data_len >= sizeof(*gdata)) {
-		gedata_len = gdata->error_data_length;
-		if (gedata_len > data_len - sizeof(*gdata))
+
+	if ((gdata->revision >> 8) >= 0x03) {
+		gdata_v3 = (struct acpi_hest_generic_data_v300 *)gdata;
+		while (data_len >= sizeof(*gdata_v3)) {
+			gedata_len = gdata_v3->error_data_length;
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
-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
