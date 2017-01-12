From: Tyler Baicar <tbaicar@codeaurora.org>
Subject: [PATCH V7 02/10] ras: acpi/apei: cper: generic error data entry v3
 per ACPI 6.1
Date: Thu, 12 Jan 2017 11:15:16 -0700
Message-ID: <1484244924-24786-3-git-send-email-tbaicar@codeaurora.org>
References: <1484244924-24786-1-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <1484244924-24786-1-git-send-email-tbaicar@codeaurora.org>
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

Currently when a RAS error is reported it is not timestamped.
The ACPI 6.1 spec adds the timestamp field to the generic error
data entry v3 structure. The timestamp of when the firmware
generated the error is now being reported.

Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
Signed-off-by: Richard Ruigrok <rruigrok@codeaurora.org>
Signed-off-by: Naveen Kaje <nkaje@codeaurora.org>
Reviewed-by: James Morse <james.morse@arm.com>
---
 drivers/acpi/apei/ghes.c    |  9 ++++---
 drivers/firmware/efi/cper.c | 63 +++++++++++++++++++++++++++++++++++----------
 include/acpi/ghes.h         | 22 ++++++++++++++++
 3 files changed, 77 insertions(+), 17 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index b23160d..2acbc60 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -420,7 +420,8 @@ static void ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata, int
 	int flags = -1;
 	int sec_sev = ghes_severity(gdata->error_severity);
 	struct cper_sec_mem_err *mem_err;
-	mem_err = (struct cper_sec_mem_err *)(gdata + 1);
+
+	mem_err = acpi_hest_generic_data_payload(gdata);
 
 	if (!(mem_err->validation_bits & CPER_MEM_VALID_PA))
 		return;
@@ -457,7 +458,8 @@ static void ghes_do_proc(struct ghes *ghes,
 		if (!uuid_le_cmp(*(uuid_le *)gdata->section_type,
 				 CPER_SEC_PLATFORM_MEM)) {
 			struct cper_sec_mem_err *mem_err;
-			mem_err = (struct cper_sec_mem_err *)(gdata+1);
+
+			mem_err = acpi_hest_generic_data_payload(gdata);
 			ghes_edac_report_mem_error(ghes, sev, mem_err);
 
 			arch_apei_report_mem_error(sev, mem_err);
@@ -467,7 +469,8 @@ static void ghes_do_proc(struct ghes *ghes,
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
index d425374..8fa4e23 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -32,6 +32,9 @@
 #include <linux/acpi.h>
 #include <linux/pci.h>
 #include <linux/aer.h>
+#include <linux/printk.h>
+#include <linux/bcd.h>
+#include <acpi/ghes.h>
 
 #define INDENT_SP	" "
 
@@ -386,13 +389,37 @@ static void cper_print_pcie(const char *pfx, const struct cper_sec_pcie *pcie,
 	pfx, pcie->bridge.secondary_status, pcie->bridge.control);
 }
 
+static void cper_estatus_print_section_v300(const char *pfx,
+	const struct acpi_hest_generic_data_v300 *gdata)
+{
+	__u8 hour, min, sec, day, mon, year, century, *timestamp;
+
+	if (gdata->validation_bits & ACPI_HEST_GEN_VALID_TIMESTAMP) {
+		timestamp = (__u8 *)&(gdata->time_stamp);
+		sec = bcd2bin(timestamp[0]);
+		min = bcd2bin(timestamp[1]);
+		hour = bcd2bin(timestamp[2]);
+		day = bcd2bin(timestamp[4]);
+		mon = bcd2bin(timestamp[5]);
+		year = bcd2bin(timestamp[6]);
+		century = bcd2bin(timestamp[7]);
+		printk("%stime: %7s %02d%02d-%02d-%02d %02d:%02d:%02d\n", pfx,
+			0x01 & *(timestamp + 3) ? "precise" : "", century,
+			year, mon, day, hour, min, sec);
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
 
+	if (acpi_hest_generic_data_version(gdata) >= 3)
+		cper_estatus_print_section_v300(pfx,
+			(const struct acpi_hest_generic_data_v300 *)gdata);
+
 	severity = gdata->error_severity;
 	printk("%s""Error %d, type: %s\n", pfx, sec_no,
 	       cper_severity_str(severity));
@@ -403,14 +430,18 @@ static void cper_estatus_print_section(
 
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
@@ -419,7 +450,9 @@ static void cper_estatus_print_section(
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
@@ -438,7 +471,7 @@ void cper_estatus_print(const char *pfx,
 			const struct acpi_hest_generic_status *estatus)
 {
 	struct acpi_hest_generic_data *gdata;
-	unsigned int data_len, gedata_len;
+	unsigned int data_len;
 	int sec_no = 0;
 	char newpfx[64];
 	__u16 severity;
@@ -451,12 +484,13 @@ void cper_estatus_print(const char *pfx,
 	printk("%s""event severity: %s\n", pfx, cper_severity_str(severity));
 	data_len = estatus->data_length;
 	gdata = (struct acpi_hest_generic_data *)(estatus + 1);
+
 	snprintf(newpfx, sizeof(newpfx), "%s%s", pfx, INDENT_SP);
-	while (data_len >= sizeof(*gdata)) {
-		gedata_len = gdata->error_data_length;
+
+	while (data_len >= acpi_hest_generic_data_size(gdata)) {
 		cper_estatus_print_section(newpfx, gdata, sec_no);
-		data_len -= gedata_len + sizeof(*gdata);
-		gdata = (void *)(gdata + 1) + gedata_len;
+		data_len -= acpi_hest_generic_data_record_size(gdata);
+		gdata = acpi_hest_generic_data_next(gdata);
 		sec_no++;
 	}
 }
@@ -486,12 +520,13 @@ int cper_estatus_check(const struct acpi_hest_generic_status *estatus)
 		return rc;
 	data_len = estatus->data_length;
 	gdata = (struct acpi_hest_generic_data *)(estatus + 1);
-	while (data_len >= sizeof(*gdata)) {
-		gedata_len = gdata->error_data_length;
-		if (gedata_len > data_len - sizeof(*gdata))
+
+	while (data_len >= acpi_hest_generic_data_size(gdata)) {
+		gedata_len = acpi_hest_generic_data_error_length(gdata);
+		if (gedata_len > data_len - acpi_hest_generic_data_size(gdata))
 			return -EINVAL;
-		data_len -= gedata_len + sizeof(*gdata);
-		gdata = (void *)(gdata + 1) + gedata_len;
+		data_len -= gedata_len + acpi_hest_generic_data_size(gdata);
+		gdata = acpi_hest_generic_data_next(gdata);
 	}
 	if (data_len)
 		return -EINVAL;
diff --git a/include/acpi/ghes.h b/include/acpi/ghes.h
index 68f088a..6ae318b 100644
--- a/include/acpi/ghes.h
+++ b/include/acpi/ghes.h
@@ -12,6 +12,18 @@
 #define GHES_TO_CLEAR		0x0001
 #define GHES_EXITING		0x0002
 
+#define acpi_hest_generic_data_error_length(gdata)	\
+	(((struct acpi_hest_generic_data *)(gdata))->error_data_length)
+#define acpi_hest_generic_data_size(gdata)		\
+	((acpi_hest_generic_data_version(gdata) >= 3) ?	\
+	sizeof(struct acpi_hest_generic_data_v300) :	\
+	sizeof(struct acpi_hest_generic_data))
+#define acpi_hest_generic_data_record_size(gdata)	\
+	(acpi_hest_generic_data_size(gdata) +		\
+	acpi_hest_generic_data_error_length(gdata))
+#define acpi_hest_generic_data_next(gdata)		\
+	((void *)(gdata) + acpi_hest_generic_data_record_size(gdata))
+
 struct ghes {
 	union {
 		struct acpi_hest_generic *generic;
@@ -73,3 +85,13 @@ static inline void ghes_edac_unregister(struct ghes *ghes)
 {
 }
 #endif
+
+#define acpi_hest_generic_data_version(gdata)			\
+	(gdata->revision >> 8)
+
+static inline void *acpi_hest_generic_data_payload(struct acpi_hest_generic_data *gdata)
+{
+	return acpi_hest_generic_data_version(gdata) >= 3 ?
+		(void *)(((struct acpi_hest_generic_data_v300 *)(gdata)) + 1) :
+		gdata + 1;
+}
-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
