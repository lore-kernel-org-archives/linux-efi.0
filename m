From: Tyler Baicar <tbaicar@codeaurora.org>
Subject: [PATCH V17 02/11] ras: acpi/apei: cper: add support for generic data
 v3 structure
Date: Fri, 19 May 2017 14:32:04 -0600
Message-ID: <1495225933-4410-3-git-send-email-tbaicar@codeaurora.org>
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

The ACPI 6.1 spec adds a new revision of the generic error data
entry structure. Add support to handle the new structure as well
as properly verify and iterate through the generic data entries.

Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
CC: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
---
 drivers/acpi/apei/ghes.c    | 11 +++++------
 drivers/firmware/efi/cper.c | 37 ++++++++++++++++++++++---------------
 include/acpi/ghes.h         | 36 ++++++++++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+), 21 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index c072acf..626552e 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -428,8 +428,7 @@ static void ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata, int
 	unsigned long pfn;
 	int flags = -1;
 	int sec_sev = ghes_severity(gdata->error_severity);
-	struct cper_sec_mem_err *mem_err;
-	mem_err = (struct cper_sec_mem_err *)(gdata + 1);
+	struct cper_sec_mem_err *mem_err = acpi_hest_get_payload(gdata);
 
 	if (!(mem_err->validation_bits & CPER_MEM_VALID_PA))
 		return;
@@ -465,8 +464,8 @@ static void ghes_do_proc(struct ghes *ghes,
 		sec_sev = ghes_severity(gdata->error_severity);
 		if (!uuid_le_cmp(*(uuid_le *)gdata->section_type,
 				 CPER_SEC_PLATFORM_MEM)) {
-			struct cper_sec_mem_err *mem_err;
-			mem_err = (struct cper_sec_mem_err *)(gdata+1);
+			struct cper_sec_mem_err *mem_err = acpi_hest_get_payload(gdata);
+
 			ghes_edac_report_mem_error(ghes, sev, mem_err);
 
 			arch_apei_report_mem_error(sev, mem_err);
@@ -475,8 +474,8 @@ static void ghes_do_proc(struct ghes *ghes,
 #ifdef CONFIG_ACPI_APEI_PCIEAER
 		else if (!uuid_le_cmp(*(uuid_le *)gdata->section_type,
 				      CPER_SEC_PCIE)) {
-			struct cper_sec_pcie *pcie_err;
-			pcie_err = (struct cper_sec_pcie *)(gdata+1);
+			struct cper_sec_pcie *pcie_err = acpi_hest_get_payload(gdata);
+
 			if (sev == GHES_SEV_RECOVERABLE &&
 			    sec_sev == GHES_SEV_RECOVERABLE &&
 			    pcie_err->validation_bits & CPER_PCIE_VALID_DEVICE_ID &&
diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index d425374..9024757 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -32,6 +32,7 @@
 #include <linux/acpi.h>
 #include <linux/pci.h>
 #include <linux/aer.h>
+#include <acpi/ghes.h>
 
 #define INDENT_SP	" "
 
@@ -386,8 +387,9 @@ static void cper_print_pcie(const char *pfx, const struct cper_sec_pcie *pcie,
 	pfx, pcie->bridge.secondary_status, pcie->bridge.control);
 }
 
-static void cper_estatus_print_section(
-	const char *pfx, const struct acpi_hest_generic_data *gdata, int sec_no)
+static void
+cper_estatus_print_section(const char *pfx, struct acpi_hest_generic_data *gdata,
+			   int sec_no)
 {
 	uuid_le *sec_type = (uuid_le *)gdata->section_type;
 	__u16 severity;
@@ -403,14 +405,16 @@ static void cper_estatus_print_section(
 
 	snprintf(newpfx, sizeof(newpfx), "%s%s", pfx, INDENT_SP);
 	if (!uuid_le_cmp(*sec_type, CPER_SEC_PROC_GENERIC)) {
-		struct cper_sec_proc_generic *proc_err = (void *)(gdata + 1);
+		struct cper_sec_proc_generic *proc_err = acpi_hest_get_payload(gdata);
+
 		printk("%s""section_type: general processor error\n", newpfx);
 		if (gdata->error_data_length >= sizeof(*proc_err))
 			cper_print_proc_generic(newpfx, proc_err);
 		else
 			goto err_section_too_small;
 	} else if (!uuid_le_cmp(*sec_type, CPER_SEC_PLATFORM_MEM)) {
-		struct cper_sec_mem_err *mem_err = (void *)(gdata + 1);
+		struct cper_sec_mem_err *mem_err = acpi_hest_get_payload(gdata);
+
 		printk("%s""section_type: memory error\n", newpfx);
 		if (gdata->error_data_length >=
 		    sizeof(struct cper_sec_mem_err_old))
@@ -419,7 +423,8 @@ static void cper_estatus_print_section(
 		else
 			goto err_section_too_small;
 	} else if (!uuid_le_cmp(*sec_type, CPER_SEC_PCIE)) {
-		struct cper_sec_pcie *pcie = (void *)(gdata + 1);
+		struct cper_sec_pcie *pcie = acpi_hest_get_payload(gdata);
+
 		printk("%s""section_type: PCIe error\n", newpfx);
 		if (gdata->error_data_length >= sizeof(*pcie))
 			cper_print_pcie(newpfx, pcie, gdata);
@@ -438,7 +443,7 @@ void cper_estatus_print(const char *pfx,
 			const struct acpi_hest_generic_status *estatus)
 {
 	struct acpi_hest_generic_data *gdata;
-	unsigned int data_len, gedata_len;
+	unsigned int data_len;
 	int sec_no = 0;
 	char newpfx[64];
 	__u16 severity;
@@ -452,11 +457,11 @@ void cper_estatus_print(const char *pfx,
 	data_len = estatus->data_length;
 	gdata = (struct acpi_hest_generic_data *)(estatus + 1);
 	snprintf(newpfx, sizeof(newpfx), "%s%s", pfx, INDENT_SP);
-	while (data_len >= sizeof(*gdata)) {
-		gedata_len = gdata->error_data_length;
+
+	while (data_len >= acpi_hest_get_size(gdata)) {
 		cper_estatus_print_section(newpfx, gdata, sec_no);
-		data_len -= gedata_len + sizeof(*gdata);
-		gdata = (void *)(gdata + 1) + gedata_len;
+		data_len -= acpi_hest_get_record_size(gdata);
+		gdata = acpi_hest_get_next(gdata);
 		sec_no++;
 	}
 }
@@ -486,12 +491,14 @@ int cper_estatus_check(const struct acpi_hest_generic_status *estatus)
 		return rc;
 	data_len = estatus->data_length;
 	gdata = (struct acpi_hest_generic_data *)(estatus + 1);
-	while (data_len >= sizeof(*gdata)) {
-		gedata_len = gdata->error_data_length;
-		if (gedata_len > data_len - sizeof(*gdata))
+
+	while (data_len >= acpi_hest_get_size(gdata)) {
+		gedata_len = acpi_hest_get_error_length(gdata);
+		if (gedata_len > data_len - acpi_hest_get_size(gdata))
 			return -EINVAL;
-		data_len -= gedata_len + sizeof(*gdata);
-		gdata = (void *)(gdata + 1) + gedata_len;
+
+		data_len -= acpi_hest_get_record_size(gdata);
+		gdata = acpi_hest_get_next(gdata);
 	}
 	if (data_len)
 		return -EINVAL;
diff --git a/include/acpi/ghes.h b/include/acpi/ghes.h
index 68f088a..8f8fea00 100644
--- a/include/acpi/ghes.h
+++ b/include/acpi/ghes.h
@@ -73,3 +73,39 @@ static inline void ghes_edac_unregister(struct ghes *ghes)
 {
 }
 #endif
+
+static inline int acpi_hest_get_version(struct acpi_hest_generic_data *gdata)
+{
+	return gdata->revision >> 8;
+}
+
+static inline void *acpi_hest_get_payload(struct acpi_hest_generic_data *gdata)
+{
+	if (acpi_hest_get_version(gdata) >= 3)
+		return (void *)(((struct acpi_hest_generic_data_v300 *)(gdata)) + 1);
+
+	return gdata + 1;
+}
+
+static inline int acpi_hest_get_error_length(struct acpi_hest_generic_data *gdata)
+{
+	return ((struct acpi_hest_generic_data *)(gdata))->error_data_length;
+}
+
+static inline int acpi_hest_get_size(struct acpi_hest_generic_data *gdata)
+{
+	if (acpi_hest_get_version(gdata) >= 3)
+		return sizeof(struct acpi_hest_generic_data_v300);
+
+	return sizeof(struct acpi_hest_generic_data);
+}
+
+static inline int acpi_hest_get_record_size(struct acpi_hest_generic_data *gdata)
+{
+	return (acpi_hest_get_size(gdata) + acpi_hest_get_error_length(gdata));
+}
+
+static inline void *acpi_hest_get_next(struct acpi_hest_generic_data *gdata)
+{
+	return (void *)(gdata) + acpi_hest_get_record_size(gdata);
+}
-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
