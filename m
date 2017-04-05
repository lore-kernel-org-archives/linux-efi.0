From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 8/8] efi/capsule: Add support for Quark security header
Date: Wed,  5 Apr 2017 10:23:17 +0100
Message-ID: <20170405092317.27921-9-ard.biesheuvel@linaro.org>
References: <20170405092317.27921-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170405092317.27921-1-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org, hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, sascha.weisenberger-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org, jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>

The firmware for Quark X102x prepends a security header to the capsule
which is needed to support the mandatory secure boot on this processor.
The header can be detected by checking for the "_CSH" signature and -
to avoid any GUID conflict - validating its size field to contain the
expected value. Then we need to look for the EFI header right after the
security header and pass the real header to __efi_capsule_setup_info.

To be minimally invasive and maximally safe, the quirk version of
efi_capsule_identify_image is only effective on Quark processors.

Signed-off-by: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
[ardb: refactor using an override of efi_capsule_setup_info()]
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/x86/platform/efi/quirks.c | 112 ++++++++++++++++++++
 drivers/firmware/efi/Kconfig   |   9 ++
 2 files changed, 121 insertions(+)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 30031d5293c4..ee922e1b7008 100644
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
@@ -495,3 +549,61 @@ bool efi_poweroff_required(void)
 {
 	return acpi_gbl_reduced_hardware || acpi_no_s5;
 }
+
+#ifdef CONFIG_EFI_CAPSULE_QUIRK_QUARK_CSH
+
+static const struct x86_cpu_id quark_ids[] = {
+	{ X86_VENDOR_INTEL, 5, 9 },	/* Intel Quark X1000 */
+	{ }
+};
+
+int efi_capsule_setup_info(struct capsule_info *cap_info, void *kbuff,
+			   size_t hdr_bytes)
+{
+	struct quark_security_header *csh = kbuff;
+
+	cap_info->total_size = 0;
+
+	if (!x86_match_cpu(quark_ids))
+		goto fallback;
+
+	/* Only process data block that is larger than the security header */
+	if (hdr_bytes < sizeof(struct quark_security_header))
+		return 0;
+
+	if (csh->csh_signature != QUARK_CSH_SIGNATURE ||
+	    csh->headersize != QUARK_SECURITY_HEADER_SIZE)
+		goto fallback;
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
+	kbuff += csh->headersize;
+	cap_info->total_size = csh->headersize;
+
+	/*
+	 * Update the first page pointer to skip over the CSH header.
+	 */
+	cap_info->pages[0] += csh->headersize;
+
+fallback:
+	if (hdr_bytes < sizeof(efi_capsule_header_t))
+		return 0;
+
+	memcpy(&cap_info->header, kbuff, sizeof(cap_info->header));
+
+	cap_info->total_size += cap_info->header.imagesize;
+
+	return __efi_capsule_setup_info(cap_info);
+}
+
+#endif
diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 2e78b0b96d74..394db40ed374 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -112,6 +112,15 @@ config EFI_CAPSULE_LOADER
 
 	  Most users should say N.
 
+config EFI_CAPSULE_QUIRK_QUARK_CSH
+	boolean "Add support for Quark capsules with non-standard headers"
+	depends on X86 && !64BIT
+	select EFI_CAPSULE_LOADER
+	default y
+	help
+	  Add support for processing Quark X1000 EFI capsules, whose header
+	  layout deviates from the layout mandated by the UEFI specification.
+
 config EFI_TEST
 	tristate "EFI Runtime Service Tests Support"
 	depends on EFI
-- 
2.9.3
