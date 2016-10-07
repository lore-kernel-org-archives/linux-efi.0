From: Tyler Baicar <tbaicar@codeaurora.org>
Subject: [PATCH V3 02/10] ras: acpi/apei: cper: generic error data entry v3 per ACPI 6.1
Date: Fri,  7 Oct 2016 15:31:14 -0600
Message-ID: <1475875882-2604-3-git-send-email-tbaicar@codeaurora.org>
References: <1475875882-2604-1-git-send-email-tbaicar@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1475875882-2604-1-git-send-email-tbaicar@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, mark.rutland@arm.com, james.morse@arm.com, akpm@linux-foundation.org, sandeepa.s.prabhu@gmail.com, shijie.huang@arm.com, paul.gortmaker@windriver.com, tomasz.nowicki@linaro.org, fu.wei@linaro.org, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Dkvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, devel@acpica.org
Cc: Tyler Baicar <tbaicar@codeaurora.org>, "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>, Richard Ruigrok <rruigrok@codeaurora.org>, Naveen Kaje <nkaje@codeaurora.org>
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
 drivers/acpi/apei/ghes.c    | 25 ++++++++++--
 drivers/firmware/efi/cper.c | 97 +++++++++++++++++++++++++++++++++++++++------
 2 files changed, 105 insertions(+), 17 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 3021f0e..c8488f1 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -80,6 +80,10 @@
 	((struct acpi_hest_generic_status *)				\
 	 ((struct ghes_estatus_node *)(estatus_node) + 1))
 
+#define acpi_hest_generic_data_version(gdata)			\
+	(gdata->revision >> 8)
+
+
 /*
  * This driver isn't really modular, however for the time being,
  * continuing to use module_param is the easiest way to remain
@@ -412,6 +416,13 @@ static void ghes_clear_estatus(struct ghes *ghes)
 	ghes->flags &= ~GHES_TO_CLEAR;
 }
 
+inline void *acpi_hest_generic_data_payload(struct acpi_hest_generic_data *gdata)
+{
+	return acpi_hest_generic_data_version(gdata) >= 3 ?
+		(void *)(((struct acpi_hest_generic_data_v300 *)(gdata)) + 1) :
+		gdata + 1;
+}
+
 static void ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata, int sev)
 {
 #ifdef CONFIG_ACPI_APEI_MEMORY_FAILURE
@@ -419,7 +430,8 @@ static void ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata, int
 	int flags = -1;
 	int sec_sev = ghes_severity(gdata->error_severity);
 	struct cper_sec_mem_err *mem_err;
-	mem_err = (struct cper_sec_mem_err *)(gdata + 1);
+
+	mem_err = acpi_hest_generic_data_payload(gdata);
 
 	if (!(mem_err->validation_bits & CPER_MEM_VALID_PA))
 		return;
@@ -449,14 +461,18 @@ static void ghes_do_proc(struct ghes *ghes,
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
-			mem_err = (struct cper_sec_mem_err *)(gdata+1);
+
+			mem_err = acpi_hest_generic_data_payload(gdata);
 			ghes_edac_report_mem_error(ghes, sev, mem_err);
 
 			arch_apei_report_mem_error(sev, mem_err);
@@ -466,7 +482,8 @@ static void ghes_do_proc(struct ghes *ghes,
 		else if (!uuid_le_cmp(*(uuid_le *)gdata->section_type,
 				      CPER_SEC_PCIE)) {
 			struct cper_sec_pcie *pcie_err;
-			pcie_err = (struct cper_sec_pcie *)(gdata+1);
+
+			pcie_err = acpi_hest_generic_data_payload(gdata);
 			if (sev == GHES_SEV_RECOVERABLE &&
 			    sec_sev == GHES_SEV_RECOVERABLE &&
 			    pcie_err->validation_bits & CPER_PCIE_VALID_DEVICE_ID &&
diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index d425374..9fa1317 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -32,9 +32,14 @@
 #include <linux/acpi.h>
 #include <linux/pci.h>
 #include <linux/aer.h>
+#include <linux/printk.h>
+#include <linux/bcd.h>
 
 #define INDENT_SP	" "
 
+#define acpi_hest_generic_data_version(gdata)		\
+	(gdata->revision >> 8)
+
 static char rcd_decode_str[CPER_REC_LEN];
 
 /*
@@ -386,13 +391,47 @@ static void cper_print_pcie(const char *pfx, const struct cper_sec_pcie *pcie,
 	pfx, pcie->bridge.secondary_status, pcie->bridge.control);
 }
 
+static inline void *acpi_hest_generic_data_payload(struct acpi_hest_generic_data *gdata)
+{
+	return acpi_hest_generic_data_version(gdata) >= 3 ?
+		(void *)(((struct acpi_hest_generic_data_v300 *)(gdata)) + 1) :
+		gdata + 1;
+}
+
+static void cper_estatus_print_section_v300(const char *pfx,
+	const struct acpi_hest_generic_data_v300 *gdata)
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
+}
+
 static void cper_estatus_print_section(
-	const char *pfx, const struct acpi_hest_generic_data *gdata, int sec_no)
+	const char *pfx, struct acpi_hest_generic_data *gdata, int sec_no)
 {
 	uuid_le *sec_type = (uuid_le *)gdata->section_type;
 	__u16 severity;
 	char newpfx[64];
 
+	if ((gdata->revision >> 8) >= 0x03)
+		cper_estatus_print_section_v300(pfx,
+			(const struct acpi_hest_generic_data_v300 *)gdata);
+
 	severity = gdata->error_severity;
 	printk("%s""Error %d, type: %s\n", pfx, sec_no,
 	       cper_severity_str(severity));
@@ -403,14 +442,18 @@ static void cper_estatus_print_section(
 
 	snprintf(newpfx, sizeof(newpfx), "%s%s", pfx, INDENT_SP);
 	if (!uuid_le_cmp(*sec_type, CPER_SEC_PROC_GENERIC)) {
-		struct cper_sec_proc_generic *proc_err = (void *)(gdata + 1);
+		struct cper_sec_proc_generic *proc_err;
+
+		proc_err = acpi_hest_generic_data_payload(gdata);
 		printk("%s""section_type: general processor error\n", newpfx);
 		if (gdata->error_data_length >= sizeof(*proc_err))
 			cper_print_proc_generic(newpfx, proc_err);
 		else
 			goto err_section_too_small;
 	} else if (!uuid_le_cmp(*sec_type, CPER_SEC_PLATFORM_MEM)) {
-		struct cper_sec_mem_err *mem_err = (void *)(gdata + 1);
+		struct cper_sec_mem_err *mem_err;
+
+		mem_err = acpi_hest_generic_data_payload(gdata);
 		printk("%s""section_type: memory error\n", newpfx);
 		if (gdata->error_data_length >=
 		    sizeof(struct cper_sec_mem_err_old))
@@ -419,7 +462,9 @@ static void cper_estatus_print_section(
 		else
 			goto err_section_too_small;
 	} else if (!uuid_le_cmp(*sec_type, CPER_SEC_PCIE)) {
-		struct cper_sec_pcie *pcie = (void *)(gdata + 1);
+		struct cper_sec_pcie *pcie;
+
+		pcie = acpi_hest_generic_data_payload(gdata);
 		printk("%s""section_type: PCIe error\n", newpfx);
 		if (gdata->error_data_length >= sizeof(*pcie))
 			cper_print_pcie(newpfx, pcie, gdata);
@@ -438,6 +483,7 @@ void cper_estatus_print(const char *pfx,
 			const struct acpi_hest_generic_status *estatus)
 {
 	struct acpi_hest_generic_data *gdata;
+	struct acpi_hest_generic_data_v300 *gdata_v3 = NULL;
 	unsigned int data_len, gedata_len;
 	int sec_no = 0;
 	char newpfx[64];
@@ -451,12 +497,22 @@ void cper_estatus_print(const char *pfx,
 	printk("%s""event severity: %s\n", pfx, cper_severity_str(severity));
 	data_len = estatus->data_length;
 	gdata = (struct acpi_hest_generic_data *)(estatus + 1);
+	if ((gdata->revision >> 8) >= 0x03)
+		gdata_v3 = (struct acpi_hest_generic_data_v300 *)gdata;
+
 	snprintf(newpfx, sizeof(newpfx), "%s%s", pfx, INDENT_SP);
+
 	while (data_len >= sizeof(*gdata)) {
 		gedata_len = gdata->error_data_length;
 		cper_estatus_print_section(newpfx, gdata, sec_no);
-		data_len -= gedata_len + sizeof(*gdata);
-		gdata = (void *)(gdata + 1) + gedata_len;
+		if(gdata_v3) {
+			data_len -= gedata_len + sizeof(*gdata_v3);
+			gdata_v3 = (void *)(gdata_v3 + 1) + gedata_len;
+			gdata = (struct acpi_hest_generic_data *)gdata_v3;
+		} else {
+			data_len -= gedata_len + sizeof(*gdata);
+			gdata = (void *)(gdata + 1) + gedata_len;
+		}
 		sec_no++;
 	}
 }
@@ -478,6 +534,7 @@ EXPORT_SYMBOL_GPL(cper_estatus_check_header);
 int cper_estatus_check(const struct acpi_hest_generic_status *estatus)
 {
 	struct acpi_hest_generic_data *gdata;
+	struct acpi_hest_generic_data_v300 *gdata_v3 = NULL;
 	unsigned int data_len, gedata_len;
 	int rc;
 
@@ -486,15 +543,29 @@ int cper_estatus_check(const struct acpi_hest_generic_status *estatus)
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
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
