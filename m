From: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH V2 1/2] efi: print unrecognized CPER section
Date: Tue,  8 Sep 2015 14:29:20 -0700
Message-ID: <1441747761-12012-2-git-send-email-zjzhang@codeaurora.org>
References: <1441747761-12012-1-git-send-email-zjzhang@codeaurora.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441747761-12012-1-git-send-email-zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, fu.wei-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, al.stone-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, gong.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org
Cc: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linaro-acpi-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, vgandhi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>

UEFI spec allows for non-standard section in Common Platform Error
Record. This is defined in section N.2.3 of UEFI version 2.5.

Currently if the CPER section's type (UUID) does not match with
one of the section types that the kernel knows how to parse, the
section is skipped. Therefore, user is not able to see
such CPER data, for instace, error record of non-standard section.

For above mentioned case, this change prints out the raw data in
hex in dmesg buffer. Data length is taken from Error Data length
field of Generic Error Data Entry.

Following is a sample output from dmesg:
[  115.771702] {1}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 2
[  115.779042] {1}[Hardware Error]: It has been corrected by h/w and requires no further action
[  115.787456] {1}[Hardware Error]: event severity: corrected
[  115.792927] {1}[Hardware Error]:  Error 0, type: corrected
[  115.798415] {1}[Hardware Error]:  fru_id: 00000000-0000-0000-0000-000000000000
[  115.805596] {1}[Hardware Error]:  fru_text:
[  115.816105] {1}[Hardware Error]:  section type: d2e2621c-f936-468d-0d84-15a4ed015c8b
[  115.823880] {1}[Hardware Error]:  section length: 88
[  115.828779] {1}[Hardware Error]:   00000000: 01000001 00000002 5f434345 525f4543
[  115.836153] {1}[Hardware Error]:   00000010: 0000574d 00000000 00000000 00000000
[  115.843531] {1}[Hardware Error]:   00000020: 00000000 00000000 00000000 00000000
[  115.850908] {1}[Hardware Error]:   00000030: 00000000 00000000 00000000 00000000
[  115.858288] {1}[Hardware Error]:   00000040: fe800000 00000000 00000004 5f434345
[  115.865665] {1}[Hardware Error]:   00000050: 525f4543 0000574d

Change-Id: I663a6e3ae6dcf68e4e389f76d555e9106ffee165
Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
---
 drivers/firmware/efi/cper.c | 39 +++++++++++++++++++++++++++++++--------
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index d42537425438..8a58b2927408 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -32,12 +32,31 @@
 #include <linux/acpi.h>
 #include <linux/pci.h>
 #include <linux/aer.h>
+#include <linux/printk.h>
 
 #define INDENT_SP	" "
 
+#define ROW_SIZE 16
+#define GROUP_SIZE 4
+
 static char rcd_decode_str[CPER_REC_LEN];
 
 /*
+ * cper_print_hex - print hex from a CPER data buffer
+ * @pfx: prefix for each line, including log level and prefix string
+ * @buf: buffer pointer
+ * @len: size of buffer
+ *
+ * print_hex_dump() expects log level and prefix string to be passed
+ * in two different paramters. Internally it concatenates them. In
+ * our case, those two are already concatenated in pfx.
+ */
+#define cper_print_hex(pfx, buf, len)				\
+	print_hex_dump(pfx, "",					\
+		DUMP_PREFIX_OFFSET, ROW_SIZE, GROUP_SIZE,	\
+		buf, len, 0)
+
+/*
  * CPER record ID need to be unique even after reboot, because record
  * ID is used as index for ERST storage, while CPER records from
  * multiple boot may co-exist in ERST.
@@ -392,7 +411,9 @@ static void cper_estatus_print_section(
 	uuid_le *sec_type = (uuid_le *)gdata->section_type;
 	__u16 severity;
 	char newpfx[64];
+	u32 len;
 
+	len = gdata->error_data_length;
 	severity = gdata->error_severity;
 	printk("%s""Error %d, type: %s\n", pfx, sec_no,
 	       cper_severity_str(severity));
@@ -405,28 +426,30 @@ static void cper_estatus_print_section(
 	if (!uuid_le_cmp(*sec_type, CPER_SEC_PROC_GENERIC)) {
 		struct cper_sec_proc_generic *proc_err = (void *)(gdata + 1);
 		printk("%s""section_type: general processor error\n", newpfx);
-		if (gdata->error_data_length >= sizeof(*proc_err))
+		if (len >= sizeof(*proc_err))
 			cper_print_proc_generic(newpfx, proc_err);
 		else
 			goto err_section_too_small;
 	} else if (!uuid_le_cmp(*sec_type, CPER_SEC_PLATFORM_MEM)) {
 		struct cper_sec_mem_err *mem_err = (void *)(gdata + 1);
 		printk("%s""section_type: memory error\n", newpfx);
-		if (gdata->error_data_length >=
-		    sizeof(struct cper_sec_mem_err_old))
-			cper_print_mem(newpfx, mem_err,
-				       gdata->error_data_length);
+		if (len >= sizeof(struct cper_sec_mem_err_old))
+			cper_print_mem(newpfx, mem_err, len);
 		else
 			goto err_section_too_small;
 	} else if (!uuid_le_cmp(*sec_type, CPER_SEC_PCIE)) {
 		struct cper_sec_pcie *pcie = (void *)(gdata + 1);
 		printk("%s""section_type: PCIe error\n", newpfx);
-		if (gdata->error_data_length >= sizeof(*pcie))
+		if (len >= sizeof(*pcie))
 			cper_print_pcie(newpfx, pcie, gdata);
 		else
 			goto err_section_too_small;
-	} else
-		printk("%s""section type: unknown, %pUl\n", newpfx, sec_type);
+	} else {
+		const void *raw_err = gdata + 1;
+		printk("%ssection type: %pUl\n", pfx, sec_type);
+		printk("%ssection length: %d\n", pfx, len);
+		cper_print_hex(newpfx, raw_err, len);
+	}
 
 	return;
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
