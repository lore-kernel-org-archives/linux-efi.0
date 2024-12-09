Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2222F13C695;
	Mon,  9 Dec 2024 16:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733761527; cv=none; b=nWeaBtKya0JXkeAbIkjoVPFpeTFeFSsbxt0llr6P9cVlp7VTPvJ8DPfmSwc5xa2Hczwf3nBUsGx47DYcvR57c4dNLfhoCO/7dY1umlmq6gERqX798sccwTKnGAvbg0/ESe5+e/mNBfgdpi1QkvxRt+WNHeL9ud37O70YUYNpJq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733761527; c=relaxed/simple;
	bh=QSK/vSymPGTeHpx3RHeoxGLbar7l+kJmZS8bFEMDBNE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l/RRBeawwizyS8spUG90RpOdzCWlEALY+EnJ44m46uuHb+xEY3BKzRswWUN7q6UlDV5I/h1KYkXvo9qfXIFMkipVORxAnen4bLOQOBgDye0cZ4kqdKPOTUrZDhYmS1aEEPJ0fc/xDRVPAWVveU4FY4olZ+di9cgzyzB7qEzU+pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=T5vZn/01; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="T5vZn/01"
Received: from hm-sls2.corp.microsoft.com (bras-base-toroon4332w-grc-63-70-49-166-4.dsl.bell.ca [70.49.166.4])
	by linux.microsoft.com (Postfix) with ESMTPSA id 55A2F20ACD6A;
	Mon,  9 Dec 2024 08:25:24 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 55A2F20ACD6A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1733761525;
	bh=uHfphiDuA8WevVGeduwntUadDdTNUNYToRUGXAajlY4=;
	h=From:To:Cc:Subject:Date:From;
	b=T5vZn/01VKhQnfBxy6cObEdNN7+O9B3v7bH5M0fej1JCzJa+6iX9ekM52cnNeq+0U
	 4+sEb4qxGTClGnrsEpBo3+TFimLVC3ClGXBNbpbqz794QiGpHB/7wiKa6ik/CLXsXi
	 07gG4TidHwqkdms/QcHHFaqQe4g/2e8s4bzSmpZ8=
From: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
To: linux-efi@vger.kernel.org
Cc: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	stable@vger.kernel.org,
	Tyler Hicks <code@tyhicks.com>,
	Brian Nguyen <nguyenbrian@microsoft.com>,
	Jacob Pan <panj@microsoft.com>,
	Allen Pais <apais@microsoft.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Jonathan Marek <jonathan@marek.ca>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Jeremy Linton <jeremy.linton@arm.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	=?UTF-8?q?KONDO=20KAZUMA=28=E8=BF=91=E8=97=A4=E3=80=80=E5=92=8C=E7=9C=9F=29?= <kazuma-kondo@nec.com>,
	Kees Cook <kees@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Yuntao Wang <ytcoode@gmail.com>,
	Aditya Garg <gargaditya08@live.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] efi: make the min and max mmap slack slots configurable
Date: Mon,  9 Dec 2024 11:24:34 -0500
Message-ID: <20241209162449.48390-1-hamzamahfooz@linux.microsoft.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Recent platforms require more slack slots than the current value of
EFI_MMAP_NR_SLACK_SLOTS, otherwise they fail to boot. So, introduce
EFI_MIN_NR_MMAP_SLACK_SLOTS and EFI_MAX_NR_MMAP_SLACK_SLOTS
and use them to determine a number of slots that the platform
is willing to accept.

Cc: stable@vger.kernel.org
Cc: Tyler Hicks <code@tyhicks.com>
Tested-by: Brian Nguyen <nguyenbrian@microsoft.com>
Tested-by: Jacob Pan <panj@microsoft.com>
Reviewed-by: Allen Pais <apais@microsoft.com>
Signed-off-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
---
 drivers/firmware/efi/Kconfig                  | 23 +++++++++++++++++
 .../firmware/efi/libstub/efi-stub-helper.c    |  2 +-
 drivers/firmware/efi/libstub/efistub.h        | 15 +----------
 drivers/firmware/efi/libstub/kaslr.c          |  2 +-
 drivers/firmware/efi/libstub/mem.c            | 25 +++++++++++++++----
 drivers/firmware/efi/libstub/randomalloc.c    |  2 +-
 drivers/firmware/efi/libstub/relocate.c       |  2 +-
 drivers/firmware/efi/libstub/x86-stub.c       |  8 +++---
 8 files changed, 52 insertions(+), 27 deletions(-)

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index e312d731f4a3..7fedc271d543 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -155,6 +155,29 @@ config EFI_TEST
 	  Say Y here to enable the runtime services support via /dev/efi_test.
 	  If unsure, say N.
 
+#
+# An efi_boot_memmap is used by efi_get_memory_map() to return the
+# EFI memory map in a dynamically allocated buffer.
+#
+# The buffer allocated for the EFI memory map includes extra room for
+# a range of [EFI_MIN_NR_MMAP_SLACK_SLOTS, EFI_MAX_NR_MMAP_SLACK_SLOTS]
+# additional EFI memory descriptors. This facilitates the reuse of the
+# EFI memory map buffer when a second call to ExitBootServices() is
+# needed because of intervening changes to the EFI memory map. Other
+# related structures, e.g. x86 e820ext, need to factor in this headroom
+# requirement as well.
+#
+
+config EFI_MIN_NR_MMAP_SLACK_SLOTS
+	int
+	depends on EFI
+	default 8
+
+config EFI_MAX_NR_MMAP_SLACK_SLOTS
+	int
+	depends on EFI
+	default 64
+
 config EFI_DEV_PATH_PARSER
 	bool
 
diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index c0c81ca4237e..adf2b0c0dd34 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -432,7 +432,7 @@ efi_status_t efi_exit_boot_services(void *handle, void *priv,
 	if (efi_disable_pci_dma)
 		efi_pci_disable_bridge_busmaster();
 
-	status = efi_get_memory_map(&map, true);
+	status = efi_get_memory_map(&map, true, NULL);
 	if (status != EFI_SUCCESS)
 		return status;
 
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index 76e44c185f29..d86c6e13de5f 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -160,19 +160,6 @@ void efi_set_u64_split(u64 data, u32 *lo, u32 *hi)
  */
 #define EFI_100NSEC_PER_USEC	((u64)10)
 
-/*
- * An efi_boot_memmap is used by efi_get_memory_map() to return the
- * EFI memory map in a dynamically allocated buffer.
- *
- * The buffer allocated for the EFI memory map includes extra room for
- * a minimum of EFI_MMAP_NR_SLACK_SLOTS additional EFI memory descriptors.
- * This facilitates the reuse of the EFI memory map buffer when a second
- * call to ExitBootServices() is needed because of intervening changes to
- * the EFI memory map. Other related structures, e.g. x86 e820ext, need
- * to factor in this headroom requirement as well.
- */
-#define EFI_MMAP_NR_SLACK_SLOTS	8
-
 typedef struct efi_generic_dev_path efi_device_path_protocol_t;
 
 union efi_device_path_to_text_protocol {
@@ -1059,7 +1046,7 @@ void efi_apply_loadoptions_quirk(const void **load_options, u32 *load_options_si
 char *efi_convert_cmdline(efi_loaded_image_t *image);
 
 efi_status_t efi_get_memory_map(struct efi_boot_memmap **map,
-				bool install_cfg_tbl);
+				bool install_cfg_tbl, unsigned int *n);
 
 efi_status_t efi_allocate_pages(unsigned long size, unsigned long *addr,
 				unsigned long max);
diff --git a/drivers/firmware/efi/libstub/kaslr.c b/drivers/firmware/efi/libstub/kaslr.c
index 6318c40bda38..06e7a1ef34ab 100644
--- a/drivers/firmware/efi/libstub/kaslr.c
+++ b/drivers/firmware/efi/libstub/kaslr.c
@@ -62,7 +62,7 @@ static bool check_image_region(u64 base, u64 size)
 	bool ret = false;
 	int map_offset;
 
-	status = efi_get_memory_map(&map, false);
+	status = efi_get_memory_map(&map, false, NULL);
 	if (status != EFI_SUCCESS)
 		return false;
 
diff --git a/drivers/firmware/efi/libstub/mem.c b/drivers/firmware/efi/libstub/mem.c
index 4f1fa302234d..cab25183b790 100644
--- a/drivers/firmware/efi/libstub/mem.c
+++ b/drivers/firmware/efi/libstub/mem.c
@@ -13,32 +13,47 @@
  *			configuration table
  *
  * Retrieve the UEFI memory map. The allocated memory leaves room for
- * up to EFI_MMAP_NR_SLACK_SLOTS additional memory map entries.
+ * up to CONFIG_EFI_MAX_NR_MMAP_SLACK_SLOTS additional memory map entries.
  *
  * Return:	status code
  */
 efi_status_t efi_get_memory_map(struct efi_boot_memmap **map,
-				bool install_cfg_tbl)
+				bool install_cfg_tbl,
+				unsigned int *n)
 {
 	int memtype = install_cfg_tbl ? EFI_ACPI_RECLAIM_MEMORY
 				      : EFI_LOADER_DATA;
 	efi_guid_t tbl_guid = LINUX_EFI_BOOT_MEMMAP_GUID;
+	unsigned int nr = CONFIG_EFI_MIN_NR_MMAP_SLACK_SLOTS;
 	struct efi_boot_memmap *m, tmp;
 	efi_status_t status;
 	unsigned long size;
 
+	BUILD_BUG_ON(!is_power_of_2(CONFIG_EFI_MIN_NR_MMAP_SLACK_SLOTS) ||
+		     !is_power_of_2(CONFIG_EFI_MAX_NR_MMAP_SLACK_SLOTS) ||
+		     CONFIG_EFI_MIN_NR_MMAP_SLACK_SLOTS >=
+		     CONFIG_EFI_MAX_NR_MMAP_SLACK_SLOTS);
+
 	tmp.map_size = 0;
 	status = efi_bs_call(get_memory_map, &tmp.map_size, NULL, &tmp.map_key,
 			     &tmp.desc_size, &tmp.desc_ver);
 	if (status != EFI_BUFFER_TOO_SMALL)
 		return EFI_LOAD_ERROR;
 
-	size = tmp.map_size + tmp.desc_size * EFI_MMAP_NR_SLACK_SLOTS;
-	status = efi_bs_call(allocate_pool, memtype, sizeof(*m) + size,
-			     (void **)&m);
+	do {
+		size = tmp.map_size + tmp.desc_size * nr;
+		status = efi_bs_call(allocate_pool, memtype, sizeof(*m) + size,
+				     (void **)&m);
+		nr <<= 1;
+	} while (status == EFI_BUFFER_TOO_SMALL &&
+		 nr <= CONFIG_EFI_MAX_NR_MMAP_SLACK_SLOTS);
+
 	if (status != EFI_SUCCESS)
 		return status;
 
+	if (n)
+		*n = nr;
+
 	if (install_cfg_tbl) {
 		/*
 		 * Installing a configuration table might allocate memory, and
diff --git a/drivers/firmware/efi/libstub/randomalloc.c b/drivers/firmware/efi/libstub/randomalloc.c
index c41e7b2091cd..e80a65e7b87a 100644
--- a/drivers/firmware/efi/libstub/randomalloc.c
+++ b/drivers/firmware/efi/libstub/randomalloc.c
@@ -65,7 +65,7 @@ efi_status_t efi_random_alloc(unsigned long size,
 	efi_status_t status;
 	int map_offset;
 
-	status = efi_get_memory_map(&map, false);
+	status = efi_get_memory_map(&map, false, NULL);
 	if (status != EFI_SUCCESS)
 		return status;
 
diff --git a/drivers/firmware/efi/libstub/relocate.c b/drivers/firmware/efi/libstub/relocate.c
index d694bcfa1074..b7b0aad95ba4 100644
--- a/drivers/firmware/efi/libstub/relocate.c
+++ b/drivers/firmware/efi/libstub/relocate.c
@@ -28,7 +28,7 @@ efi_status_t efi_low_alloc_above(unsigned long size, unsigned long align,
 	unsigned long nr_pages;
 	int i;
 
-	status = efi_get_memory_map(&map, false);
+	status = efi_get_memory_map(&map, false, NULL);
 	if (status != EFI_SUCCESS)
 		goto fail;
 
diff --git a/drivers/firmware/efi/libstub/x86-stub.c b/drivers/firmware/efi/libstub/x86-stub.c
index 188c8000d245..cb14f0d2a3d9 100644
--- a/drivers/firmware/efi/libstub/x86-stub.c
+++ b/drivers/firmware/efi/libstub/x86-stub.c
@@ -740,15 +740,15 @@ static efi_status_t allocate_e820(struct boot_params *params,
 	struct efi_boot_memmap *map;
 	efi_status_t status;
 	__u32 nr_desc;
+	__u32 nr;
 
-	status = efi_get_memory_map(&map, false);
+	status = efi_get_memory_map(&map, false, &nr);
 	if (status != EFI_SUCCESS)
 		return status;
 
 	nr_desc = map->map_size / map->desc_size;
-	if (nr_desc > ARRAY_SIZE(params->e820_table) - EFI_MMAP_NR_SLACK_SLOTS) {
-		u32 nr_e820ext = nr_desc - ARRAY_SIZE(params->e820_table) +
-				 EFI_MMAP_NR_SLACK_SLOTS;
+	if (nr_desc > ARRAY_SIZE(params->e820_table) - nr) {
+		u32 nr_e820ext = nr_desc - ARRAY_SIZE(params->e820_table) + nr;
 
 		status = alloc_e820ext(nr_e820ext, e820ext, e820ext_size);
 	}
-- 
2.47.1

