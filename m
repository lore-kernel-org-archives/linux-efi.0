From: Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 2/2] efi/capsule: Add support for Quark security header
Date: Wed, 15 Feb 2017 19:14:40 +0100
Message-ID: <47e493c47aa79b68be52f743ac1790fddab22938.1487182480.git.jan.kiszka@siemens.com>
References: <cover.1487182480.git.jan.kiszka@siemens.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1487182480.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1487182480.git.jan.kiszka@siemens.com>
References: <cover.1487182480.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Shevchenko <andy.shevchenko@gmail.com>
List-Id: linux-efi@vger.kernel.org

The firmware for Quark X102x prepends a security header to the capsule
which is needed to support the mandatory secure boot on this processor.
The header can be detected by checking for the "_CSH" signature and -
to avoid any GUID conflict - validating its size field to contain the
expected value. Then we need to look for the EFI header right after the
security header and pass the image offset to efi_capsule_update while
keeping the whole image in RAM - the firmware will look for the header
on its own.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 drivers/firmware/efi/capsule-loader.c | 73 ++++++++++++++++++++++++++++++-----
 1 file changed, 63 insertions(+), 10 deletions(-)

diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
index 63ceca9..571d931 100644
--- a/drivers/firmware/efi/capsule-loader.c
+++ b/drivers/firmware/efi/capsule-loader.c
@@ -26,10 +26,32 @@ struct capsule_info {
 	long		index;
 	size_t		count;
 	size_t		total_size;
+	unsigned int	efi_hdr_offset;
 	struct page	**pages;
 	size_t		page_bytes_remain;
 };
 
+#define QUARK_CSH_SIGNATURE		0x5f435348	/* _CSH */
+#define QUARK_SECURITY_HEADER_SIZE	0x400
+
+struct efi_quark_security_header {
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
 /**
  * efi_free_all_buff_pages - free all previous allocated buffer pages
  * @cap_info: pointer to current instance of capsule_info structure
@@ -56,18 +78,46 @@ static void efi_free_all_buff_pages(struct capsule_info *cap_info)
 static ssize_t efi_capsule_setup_info(struct capsule_info *cap_info,
 				      void *kbuff, size_t hdr_bytes)
 {
+	struct efi_quark_security_header *quark_hdr;
 	efi_capsule_header_t *cap_hdr;
 	size_t pages_needed;
 	int ret;
 	void *temp_page;
 
-	/* Only process data block that is larger than efi header size */
-	if (hdr_bytes < sizeof(efi_capsule_header_t))
+	/* Only process data block that is larger than the security header
+	 * (which is larger than the EFI header) */
+	if (hdr_bytes < sizeof(struct efi_quark_security_header))
 		return 0;
 
 	/* Reset back to the correct offset of header */
 	cap_hdr = kbuff - cap_info->count;
-	pages_needed = ALIGN(cap_hdr->imagesize, PAGE_SIZE) >> PAGE_SHIFT;
+
+	quark_hdr = (struct efi_quark_security_header *)cap_hdr;
+
+	if (quark_hdr->csh_signature == QUARK_CSH_SIGNATURE &&
+	    quark_hdr->headersize == QUARK_SECURITY_HEADER_SIZE) {
+		/* Only process data block if EFI header is included */
+		if (hdr_bytes < QUARK_SECURITY_HEADER_SIZE +
+				sizeof(efi_capsule_header_t))
+			return 0;
+
+		pr_debug("%s: Quark security header detected\n", __func__);
+
+		if (quark_hdr->rsvd_next_header != 0) {
+			pr_err("%s: multiple security headers not supported\n",
+			       __func__);
+			return -EINVAL;
+		}
+
+		cap_hdr = (void *)cap_hdr + quark_hdr->headersize;
+		cap_info->total_size = quark_hdr->modulesize;
+		cap_info->efi_hdr_offset = quark_hdr->headersize;
+	} else {
+		cap_info->total_size = cap_hdr->imagesize;
+		cap_info->efi_hdr_offset = 0;
+	}
+
+	pages_needed = ALIGN(cap_info->total_size, PAGE_SIZE) >> PAGE_SHIFT;
 
 	if (pages_needed == 0) {
 		pr_err("%s: pages count invalid\n", __func__);
@@ -76,7 +126,7 @@ static ssize_t efi_capsule_setup_info(struct capsule_info *cap_info,
 
 	/* Check if the capsule binary supported */
 	ret = efi_capsule_supported(cap_hdr->guid, cap_hdr->flags,
-				    cap_hdr->imagesize,
+				    cap_info->total_size,
 				    &cap_info->reset_type);
 	if (ret) {
 		pr_err("%s: efi_capsule_supported() failed\n",
@@ -84,7 +134,6 @@ static ssize_t efi_capsule_setup_info(struct capsule_info *cap_info,
 		return ret;
 	}
 
-	cap_info->total_size = cap_hdr->imagesize;
 	temp_page = krealloc(cap_info->pages,
 			     pages_needed * sizeof(void *),
 			     GFP_KERNEL | __GFP_ZERO);
@@ -106,18 +155,22 @@ static ssize_t efi_capsule_setup_info(struct capsule_info *cap_info,
  **/
 static ssize_t efi_capsule_submit_update(struct capsule_info *cap_info)
 {
+	efi_capsule_header_t *cap_hdr;
+	void *mapped_pages;
 	int ret;
-	void *cap_hdr_temp;
 
-	cap_hdr_temp = vmap(cap_info->pages, cap_info->index,
+	mapped_pages = vmap(cap_info->pages, cap_info->index,
 			VM_MAP, PAGE_KERNEL);
-	if (!cap_hdr_temp) {
+	if (!mapped_pages) {
 		pr_debug("%s: vmap() failed\n", __func__);
 		return -EFAULT;
 	}
 
-	ret = efi_capsule_update(cap_hdr_temp, 0, cap_info->pages);
-	vunmap(cap_hdr_temp);
+	cap_hdr = mapped_pages + cap_info->efi_hdr_offset;
+
+	ret = efi_capsule_update(cap_hdr, cap_info->efi_hdr_offset,
+				 cap_info->pages);
+	vunmap(mapped_pages);
 	if (ret) {
 		pr_err("%s: efi_capsule_update() failed\n", __func__);
 		return ret;
-- 
2.1.4
