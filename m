From: Ingo Molnar <mingo@kernel.org>
Subject: [GIT PULL] EFI fixes
Date: Sun, 9 Dec 2018 22:59:21 +0100
Message-ID: <20181209215921.GA64177@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Linus,

Please pull the latest efi-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git efi-urgent-for-linus

   # HEAD: 79c2206d369b87b19ac29cb47601059b6bf5c291 x86/earlyprintk/efi: Fix infinite loop on some screen widths

Two fixes: a large-system fix and an earlyprintk fix with certain 
resolutions.

 Thanks,

	Ingo

------------------>
Eric Snowberg (1):
      x86/efi: Allocate e820 buffer before calling efi_exit_boot_service

YiFei Zhu (1):
      x86/earlyprintk/efi: Fix infinite loop on some screen widths


 arch/x86/boot/compressed/eboot.c     | 65 +++++++++++++++++++++++-------------
 arch/x86/platform/efi/early_printk.c |  2 +-
 2 files changed, 42 insertions(+), 25 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 8b4c5e001157..544ac4fafd11 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -1,3 +1,4 @@
+
 /* -----------------------------------------------------------------------
  *
  *   Copyright 2011 Intel Corporation; author Matt Fleming
@@ -634,37 +635,54 @@ static efi_status_t alloc_e820ext(u32 nr_desc, struct setup_data **e820ext,
 	return status;
 }
 
+static efi_status_t allocate_e820(struct boot_params *params,
+				  struct setup_data **e820ext,
+				  u32 *e820ext_size)
+{
+	unsigned long map_size, desc_size, buff_size;
+	struct efi_boot_memmap boot_map;
+	efi_memory_desc_t *map;
+	efi_status_t status;
+	__u32 nr_desc;
+
+	boot_map.map		= &map;
+	boot_map.map_size	= &map_size;
+	boot_map.desc_size	= &desc_size;
+	boot_map.desc_ver	= NULL;
+	boot_map.key_ptr	= NULL;
+	boot_map.buff_size	= &buff_size;
+
+	status = efi_get_memory_map(sys_table, &boot_map);
+	if (status != EFI_SUCCESS)
+		return status;
+
+	nr_desc = buff_size / desc_size;
+
+	if (nr_desc > ARRAY_SIZE(params->e820_table)) {
+		u32 nr_e820ext = nr_desc - ARRAY_SIZE(params->e820_table);
+
+		status = alloc_e820ext(nr_e820ext, e820ext, e820ext_size);
+		if (status != EFI_SUCCESS)
+			return status;
+	}
+
+	return EFI_SUCCESS;
+}
+
 struct exit_boot_struct {
 	struct boot_params	*boot_params;
 	struct efi_info		*efi;
-	struct setup_data	*e820ext;
-	__u32			e820ext_size;
 };
 
 static efi_status_t exit_boot_func(efi_system_table_t *sys_table_arg,
 				   struct efi_boot_memmap *map,
 				   void *priv)
 {
-	static bool first = true;
 	const char *signature;
 	__u32 nr_desc;
 	efi_status_t status;
 	struct exit_boot_struct *p = priv;
 
-	if (first) {
-		nr_desc = *map->buff_size / *map->desc_size;
-		if (nr_desc > ARRAY_SIZE(p->boot_params->e820_table)) {
-			u32 nr_e820ext = nr_desc -
-					ARRAY_SIZE(p->boot_params->e820_table);
-
-			status = alloc_e820ext(nr_e820ext, &p->e820ext,
-					       &p->e820ext_size);
-			if (status != EFI_SUCCESS)
-				return status;
-		}
-		first = false;
-	}
-
 	signature = efi_is_64bit() ? EFI64_LOADER_SIGNATURE
 				   : EFI32_LOADER_SIGNATURE;
 	memcpy(&p->efi->efi_loader_signature, signature, sizeof(__u32));
@@ -687,8 +705,8 @@ static efi_status_t exit_boot(struct boot_params *boot_params, void *handle)
 {
 	unsigned long map_sz, key, desc_size, buff_size;
 	efi_memory_desc_t *mem_map;
-	struct setup_data *e820ext;
-	__u32 e820ext_size;
+	struct setup_data *e820ext = NULL;
+	__u32 e820ext_size = 0;
 	efi_status_t status;
 	__u32 desc_version;
 	struct efi_boot_memmap map;
@@ -702,8 +720,10 @@ static efi_status_t exit_boot(struct boot_params *boot_params, void *handle)
 	map.buff_size		= &buff_size;
 	priv.boot_params	= boot_params;
 	priv.efi		= &boot_params->efi_info;
-	priv.e820ext		= NULL;
-	priv.e820ext_size	= 0;
+
+	status = allocate_e820(boot_params, &e820ext, &e820ext_size);
+	if (status != EFI_SUCCESS)
+		return status;
 
 	/* Might as well exit boot services now */
 	status = efi_exit_boot_services(sys_table, handle, &map, &priv,
@@ -711,9 +731,6 @@ static efi_status_t exit_boot(struct boot_params *boot_params, void *handle)
 	if (status != EFI_SUCCESS)
 		return status;
 
-	e820ext			= priv.e820ext;
-	e820ext_size		= priv.e820ext_size;
-
 	/* Historic? */
 	boot_params->alt_mem_k	= 32 * 1024;
 
diff --git a/arch/x86/platform/efi/early_printk.c b/arch/x86/platform/efi/early_printk.c
index 7476b3b097e1..7138bc7a265c 100644
--- a/arch/x86/platform/efi/early_printk.c
+++ b/arch/x86/platform/efi/early_printk.c
@@ -183,7 +183,7 @@ early_efi_write(struct console *con, const char *str, unsigned int num)
 			num--;
 		}
 
-		if (efi_x >= si->lfb_width) {
+		if (efi_x + font->width > si->lfb_width) {
 			efi_x = 0;
 			efi_y += font->height;
 		}
