From: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>
Subject: [PATCH 1/2] efi: parse vendor proprietary CPER section
Date: Tue, 21 Jul 2015 16:36:46 -0700
Message-ID: <1437521807-27571-2-git-send-email-zjzhang@codeaurora.org>
References: <1437521807-27571-1-git-send-email-zjzhang@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1437521807-27571-1-git-send-email-zjzhang@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>, tony.luck@intel.com, fu.wei@linaro.org, al.stone@linaro.org, rjw@rjwysocki.net, mchehab@redhat.com, mingo@redhat.com, bp@alien8.de
Cc: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org, vgandhi@codeaurora.org, linux-acpi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>

UEFI spec allows for non-standard section in Common Platform Error
Record. This is defined in section N.2.3 of UEFI version 2.5.

If Section Type field of Generic Error Data Entry indicates a
non-standard section (eg. matchs a vendor proprietary GUID as defined
in include/linux/cper.h), print out the raw data in hex in dmesg
buffer. Data length is taken from Error Data length field of
Generic Error Data Entry.

Following is a sample output from dmesg:
{1}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 2
{1}[Hardware Error]: It has been corrected by h/w and requires no further action
{1}[Hardware Error]: event severity: corrected
{1}[Hardware Error]:  Error 0, type: corrected
{1}[Hardware Error]:  fru_id: 00000000-0000-0000-0000-000000000000
{1}[Hardware Error]:  fru_text:
{1}[Hardware Error]:   section_type: Qualcomm Technologies Inc. proprietary error
{1}[Hardware Error]:   section length: 88
{1}[Hardware Error]:   00000000: 01002011 20150416 01000001 00000002
{1}[Hardware Error]:   00000010: 5f434345 525f4543 0000574d 00000000
{1}[Hardware Error]:   00000020: 00000000 00000000 00000000 00000000
{1}[Hardware Error]:   00000030: 00000000 00000000 00000000 00000000
{1}[Hardware Error]:   00000040: 00000000 00000000 fe800000 00000000
{1}[Hardware Error]:   00000050: 00000004 5f434345

---
checkpatch.pl gives following warnings on this patch:
    WARNING: printk() should include KERN_ facility level
This is a false warning as pfx parameter includes KERN_ facility
level. Also such practice is consistent with the rest of the file.
---

Change-Id: I9a5bb6039beef1c0a36097765268b382e6a28498
Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
---
 drivers/firmware/efi/cper.c | 61 +++++++++++++++++++++++++++++++++++++++++++--
 include/linux/cper.h        |  4 +++
 2 files changed, 63 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index 4fd9961d552e..29af8846ffd1 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -32,12 +32,50 @@
 #include <linux/acpi.h>
 #include <linux/pci.h>
 #include <linux/aer.h>
+#include <linux/printk.h>
 
 #define INDENT_SP	" "
 
+#define ROW_SIZE 16
+#define GROUP_SIZE 4
+
+struct sec_vendor {
+	uuid_le         guid;
+	const char      *name;
+};
+
+static struct sec_vendor sec_vendors[] = {
+	{CPER_SEC_QTI_ERR, "Qualcomm Technologies Inc. proprietary error"},
+	{NULL_UUID_LE, NULL},
+};
+
 static char rcd_decode_str[CPER_REC_LEN];
 
 /*
+ * In case of CPER error record, there should be only two message
+ * levels: KERN_ERR and KERN_WARNING
+ */
+static const char *cper_kern_level(const char *pfx)
+{
+	switch (printk_get_level(pfx)) {
+	case '3': return KERN_ERR;
+	case '4': return KERN_WARNING;
+	default:  return KERN_DEFAULT;
+	}
+}
+
+/*
+ * cper_print_hex - print hex from a binary buffer
+ * @pfx: prefix for each line, including log level and prefix string
+ * @buf: buffer pointer
+ * @len: size of buffer
+ */
+#define cper_print_hex(pfx, buf, len)					\
+	print_hex_dump(cper_kern_level(pfx), printk_skip_level(pfx),	\
+		DUMP_PREFIX_OFFSET, ROW_SIZE, GROUP_SIZE,		\
+		buf, len, 0)
+
+/*
  * CPER record ID need to be unique even after reboot, because record
  * ID is used as index for ERST storage, while CPER records from
  * multiple boot may co-exist in ERST.
@@ -379,6 +417,12 @@ static void cper_print_pcie(const char *pfx, const struct cper_sec_pcie *pcie,
 	pfx, pcie->bridge.secondary_status, pcie->bridge.control);
 }
 
+static void cper_print_vendor(const char *pfx, __u8 *vendor_err, __u32 len)
+{
+	printk("%ssection length: %d\n", pfx, len);
+	cper_print_hex(pfx, vendor_err, len);
+}
+
 static void cper_estatus_print_section(
 	const char *pfx, const struct acpi_hest_generic_data *gdata, int sec_no)
 {
@@ -416,9 +460,22 @@ static void cper_estatus_print_section(
 			cper_print_pcie(newpfx, pcie, gdata);
 		else
 			goto err_section_too_small;
-	} else
+	} else {
+		int i;
+		__u8 *vendor_err = (void *)(gdata + 1);
+
+		for (i = 0; uuid_le_cmp(sec_vendors[i].guid,
+		     NULL_UUID_LE); i++) {
+			if (!uuid_le_cmp(*sec_type, sec_vendors[i].guid)) {
+				printk("%ssection_type: %s", newpfx,
+					sec_vendors[i].name);
+				cper_print_vendor(newpfx, vendor_err,
+					gdata->error_data_length);
+				return;
+			}
+		}
 		printk("%s""section type: unknown, %pUl\n", newpfx, sec_type);
-
+	}
 	return;
 
 err_section_too_small:
diff --git a/include/linux/cper.h b/include/linux/cper.h
index 76abba4b238e..2bb38cc1219e 100644
--- a/include/linux/cper.h
+++ b/include/linux/cper.h
@@ -210,6 +210,10 @@ enum {
 #define CPER_SEC_DMAR_IOMMU						\
 	UUID_LE(0x036F84E1, 0x7F37, 0x428c, 0xA7, 0x9E, 0x57, 0x5F,	\
 		0xDF, 0xAA, 0x84, 0xEC)
+/* Qualcomm Technologies Inc. Proprietary Error */
+#define CPER_SEC_QTI_ERR						\
+	UUID_LE(0xD2E2621C, 0xF936, 0x468D, 0x0D, 0x84, 0x15, 0xA4,	\
+		0xED, 0x01, 0x5C, 0x8B)
 
 #define CPER_PROC_VALID_TYPE			0x0001
 #define CPER_PROC_VALID_ISA			0x0002
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
