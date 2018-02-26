From: Yazen Ghannam <Yazen.Ghannam@amd.com>
Subject: [PATCH v2 4/8] efi: Decode UEFI-defined IA32/X64 Error Structure GUIDs
Date: Mon, 26 Feb 2018 13:39:00 -0600
Message-ID: <20180226193904.20532-5-Yazen.Ghannam@amd.com>
References: <20180226193904.20532-1-Yazen.Ghannam@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180226193904.20532-1-Yazen.Ghannam@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org
Cc: Yazen Ghannam <Yazen.Ghannam@amd.com>, linux-kernel@vger.kernel.org, ard.biesheuvel@linaro.org, bp@suse.de, x86@kernel.org
List-Id: linux-efi@vger.kernel.org

From: Yazen Ghannam <yazen.ghannam@amd.com>

For easier handling, match the known IA32/X64 error structure GUIDs to
enums.

Also, print out the name of the matching Error Structure Type.

GUIDs taken from UEFI 2.7 section N.2.4.2.1 IA32/X64 Processor Error
Information Structure.

Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
---
Link:
https://lkml.kernel.org/r/20180223200333.6410-5-Yazen.Ghannam@amd.com

v1->v2:
* Change use of enum type to u8.
* Fix indentation on multi-line statements.

 drivers/firmware/efi/cper-x86.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/drivers/firmware/efi/cper-x86.c b/drivers/firmware/efi/cper-x86.c
index 417bd4e500a7..037986ca82dd 100644
--- a/drivers/firmware/efi/cper-x86.c
+++ b/drivers/firmware/efi/cper-x86.c
@@ -13,17 +13,53 @@
 #define VALID_CPUID_INFO		BIT_ULL(1)
 #define VALID_PROC_ERR_INFO_NUM(bits)	(((bits) & GENMASK_ULL(7, 2)) >> 2)
 
+#define INFO_ERR_STRUCT_TYPE_CACHE					\
+	GUID_INIT(0xA55701F5, 0xE3EF, 0x43DE, 0xAC, 0x72, 0x24, 0x9B,	\
+		  0x57, 0x3F, 0xAD, 0x2C)
+#define INFO_ERR_STRUCT_TYPE_TLB					\
+	GUID_INIT(0xFC06B535, 0x5E1F, 0x4562, 0x9F, 0x25, 0x0A, 0x3B,	\
+		  0x9A, 0xDB, 0x63, 0xC3)
+#define INFO_ERR_STRUCT_TYPE_BUS					\
+	GUID_INIT(0x1CF3F8B3, 0xC5B1, 0x49a2, 0xAA, 0x59, 0x5E, 0xEF,	\
+		  0x92, 0xFF, 0xA6, 0x3C)
+#define INFO_ERR_STRUCT_TYPE_MS						\
+	GUID_INIT(0x48AB7F57, 0xDC34, 0x4f6c, 0xA7, 0xD3, 0xB0, 0xB5,	\
+		  0xB0, 0xA7, 0x43, 0x14)
+
 #define INFO_VALID_CHECK_INFO		BIT_ULL(0)
 #define INFO_VALID_TARGET_ID		BIT_ULL(1)
 #define INFO_VALID_REQUESTOR_ID		BIT_ULL(2)
 #define INFO_VALID_RESPONDER_ID		BIT_ULL(3)
 #define INFO_VALID_IP			BIT_ULL(4)
 
+enum err_types {
+	ERR_TYPE_CACHE = 0,
+	ERR_TYPE_TLB,
+	ERR_TYPE_BUS,
+	ERR_TYPE_MS,
+	N_ERR_TYPES
+};
+
+static enum err_types cper_get_err_type(const guid_t *err_type)
+{
+	if (guid_equal(err_type, &INFO_ERR_STRUCT_TYPE_CACHE))
+		return ERR_TYPE_CACHE;
+	else if (guid_equal(err_type, &INFO_ERR_STRUCT_TYPE_TLB))
+		return ERR_TYPE_TLB;
+	else if (guid_equal(err_type, &INFO_ERR_STRUCT_TYPE_BUS))
+		return ERR_TYPE_BUS;
+	else if (guid_equal(err_type, &INFO_ERR_STRUCT_TYPE_MS))
+		return ERR_TYPE_MS;
+	else
+		return N_ERR_TYPES;
+}
+
 void cper_print_proc_ia(const char *pfx, const struct cper_sec_proc_ia *proc)
 {
 	int i;
 	struct cper_ia_err_info *err_info;
 	char newpfx[64];
+	u8 err_type;
 
 	printk("%sValidation Bits: 0x%016llx\n", pfx, proc->validation_bits);
 
@@ -45,6 +81,11 @@ void cper_print_proc_ia(const char *pfx, const struct cper_sec_proc_ia *proc)
 		printk("%sError Structure Type: %pUl\n", newpfx,
 		       &err_info->err_type);
 
+		err_type = cper_get_err_type(&err_info->err_type);
+		printk("%sError Structure Type: %s\n", newpfx,
+		       err_type < ARRAY_SIZE(cper_proc_error_type_strs) ?
+		       cper_proc_error_type_strs[err_type] : "unknown");
+
 		printk("%sValidation Bits: 0x%016llx\n",
 		       newpfx, err_info->validation_bits);
 
-- 
2.14.1
