From: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 7/7] efi/capsule: Add support for Quark security header
Date: Fri, 24 Mar 2017 18:34:20 +0100
Message-ID: <cab06bccee2d89d7bd0e0408d9541bfd262212a9.1490376860.git.jan.kiszka@siemens.com>
References: <cover.1490376860.git.jan.kiszka@siemens.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1490376860.git.jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
In-Reply-To: <cover.1490376860.git.jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
References: <cover.1490376860.git.jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>, Hock Leong Kweh <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Sascha Weisenberger <sascha.weisenberger-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The firmware for Quark X102x prepends a security header to the capsule
which is needed to support the mandatory secure boot on this processor.
The header can be detected by checking for the "_CSH" signature and -
to avoid any GUID conflict - validating its size field to contain the
expected value. Then we need to look for the EFI header right after the
security header and pass the image displacement in cap_info.

To be minimal invasive and maximal safe, the quirk version of
efi_capsule_identify_image is only effective on Quark processors.

Signed-off-by: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
---
 arch/x86/platform/efi/quirks.c | 95 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 95 insertions(+)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 30031d5..7f16295 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -13,12 +13,66 @@
 #include <linux/dmi.h>
 #include <asm/efi.h>
 #include <asm/uv/uv.h>
+#include <asm/cpu_device_id.h>
 
 #define EFI_MIN_RESERVE 5120
 
 #define EFI_DUMMY_GUID \
 	EFI_GUID(0x4424ac57, 0xbe4b, 0x47dd, 0x9e, 0x97, 0xed, 0x50, 0xf0, 0x9f, 0x92, 0xa9)
 
+#define QUARK_CSH_SIGNATURE		0x5f435348	/* _CSH */
+#define QUARK_SECURITY_HEADER_SIZE	0x400
+
+/*
+ * Header prepended to the standard EFI capsule on Quark systems the are based
+ * on Intel firmware BSP.
+ * @csh_signature:	Unique identifier to sanity check signed module
+ * 			presence ("_CSH").
+ * @version:		Current version of CSH used. Should be one for Quark A0.
+ * @modulesize:		Size of the entire module including the module header
+ * 			and payload.
+ * @security_version_number_index: Index of SVN to use for validation of signed
+ * 			module.
+ * @security_version_number: Used to prevent against roll back of modules.
+ * @rsvd_module_id:	Currently unused for Clanton (Quark).
+ * @rsvd_module_vendor:	Vendor Identifier. For Intel products value is
+ * 			0x00008086.
+ * @rsvd_date:		BCD representation of build date as yyyymmdd, where
+ * 			yyyy=4 digit year, mm=1-12, dd=1-31.
+ * @headersize:		Total length of the header including including any
+ * 			padding optionally added by the signing tool.
+ * @hash_algo:		What Hash is used in the module signing.
+ * @cryp_algo:		What Crypto is used in the module signing.
+ * @keysize:		Total length of the key data including including any
+ * 			padding optionally added by the signing tool.
+ * @signaturesize:	Total length of the signature including including any
+ * 			padding optionally added by the signing tool.
+ * @rsvd_next_header:	32-bit pointer to the next Secure Boot Module in the
+ * 			chain, if there is a next header.
+ * @rsvd:		Reserved, padding structure to required size.
+ *
+ * See also QuartSecurityHeader_t in
+ * Quark_EDKII_v1.2.1.1/QuarkPlatformPkg/Include/QuarkBootRom.h
+ * from https://downloadcenter.intel.com/download/23197/Intel-Quark-SoC-X1000-Board-Support-Package-BSP
+ */
+struct quark_security_header {
+	u32 csh_signature;
+	u32 version;
+	u32 modulesize;
+	u32 security_version_number_index;
+	u32 security_version_number;
+	u32 rsvd_module_id;
+	u32 rsvd_module_vendor;
+	u32 rsvd_date;
+	u32 headersize;
+	u32 hash_algo;
+	u32 cryp_algo;
+	u32 keysize;
+	u32 signaturesize;
+	u32 rsvd_next_header;
+	u32 rsvd[2];
+};
+
 static efi_char16_t efi_dummy_name[6] = { 'D', 'U', 'M', 'M', 'Y', 0 };
 
 static bool efi_no_storage_paranoia;
@@ -495,3 +549,44 @@ bool efi_poweroff_required(void)
 {
 	return acpi_gbl_reduced_hardware || acpi_no_s5;
 }
+
+static const struct x86_cpu_id quark_ids[] = {
+	{ X86_VENDOR_INTEL, 5, 9 },	/* Intel Quark X1000 */
+	{ }
+};
+
+int efi_capsule_identify_image(struct efi_capsule_info *cap_info, void *header,
+			       size_t hdr_bytes)
+{
+	struct quark_security_header *csh = header;
+
+	if (!x86_match_cpu(quark_ids))
+		return __efi_capsule_identify_image(cap_info, header,
+						    hdr_bytes);
+
+	/* Only process data block that is larger than the security header */
+	if (hdr_bytes < sizeof(struct quark_security_header))
+		return 0;
+
+	if (csh->csh_signature != QUARK_CSH_SIGNATURE ||
+	    csh->headersize != QUARK_SECURITY_HEADER_SIZE)
+		return __efi_capsule_identify_image(cap_info, header,
+						    hdr_bytes);
+
+	/* Only process data block if EFI header is included */
+	if (hdr_bytes < QUARK_SECURITY_HEADER_SIZE +
+			sizeof(efi_capsule_header_t))
+		return 0;
+
+	pr_debug("Quark security header detected\n");
+
+	if (csh->rsvd_next_header != 0) {
+		pr_err("multiple Quark security headers not supported\n");
+		return -EINVAL;
+	}
+
+	cap_info->total_size = csh->modulesize;
+	cap_info->efi_hdr_displacement = csh->headersize;
+
+	return 1;
+}
-- 
2.10.2
