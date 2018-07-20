From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 7/9] efi/x86: replace references to efi_early->is64 with efi_is_64bit()
Date: Fri, 20 Jul 2018 10:47:24 +0900
Message-ID: <20180720014726.24031-8-ard.biesheuvel@linaro.org>
References: <20180720014726.24031-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180720014726.24031-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Hans de Goede <hdegoede@redhat.com>, Lukas Wunner <lukas@wunner.de>
List-Id: linux-efi@vger.kernel.org

There are a couple of places in the x86 EFI stub code where we select
between 32-bit and 64-bit versions of the support routines based on
the value of efi_early->is64. Referencing that field directly is a
bad idea, since it prevents the compiler from inferring that this
field can never be true on a 32-bit build, and can only become false
on a 64-bit build if support for mixed mode is compiled in. This
results in dead code to be retained in the uncompressed part of the
kernel image, which is wasteful.

So switch to the efi_is_64bit() helper, which will resolve to a
constant boolean unless building for 64-bit with mixed mode support.

Tested-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/boot/compressed/eboot.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 915c64edbe8e..1458b1700fc7 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -404,7 +404,7 @@ struct boot_params *make_boot_params(struct efi_config *c)
 	if (sys_table->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
 		return NULL;
 
-	if (efi_early->is64)
+	if (efi_is_64bit())
 		setup_boot_services64(efi_early);
 	else
 		setup_boot_services32(efi_early);
@@ -639,7 +639,6 @@ struct exit_boot_struct {
 	struct efi_info		*efi;
 	struct setup_data	*e820ext;
 	__u32			e820ext_size;
-	bool			is64;
 };
 
 static efi_status_t exit_boot_func(efi_system_table_t *sys_table_arg,
@@ -666,7 +665,8 @@ static efi_status_t exit_boot_func(efi_system_table_t *sys_table_arg,
 		first = false;
 	}
 
-	signature = p->is64 ? EFI64_LOADER_SIGNATURE : EFI32_LOADER_SIGNATURE;
+	signature = efi_is_64bit() ? EFI64_LOADER_SIGNATURE
+				   : EFI32_LOADER_SIGNATURE;
 	memcpy(&p->efi->efi_loader_signature, signature, sizeof(__u32));
 
 	p->efi->efi_systab		= (unsigned long)sys_table_arg;
@@ -683,8 +683,7 @@ static efi_status_t exit_boot_func(efi_system_table_t *sys_table_arg,
 	return EFI_SUCCESS;
 }
 
-static efi_status_t exit_boot(struct boot_params *boot_params,
-			      void *handle, bool is64)
+static efi_status_t exit_boot(struct boot_params *boot_params, void *handle)
 {
 	unsigned long map_sz, key, desc_size, buff_size;
 	efi_memory_desc_t *mem_map;
@@ -705,7 +704,6 @@ static efi_status_t exit_boot(struct boot_params *boot_params,
 	priv.efi		= &boot_params->efi_info;
 	priv.e820ext		= NULL;
 	priv.e820ext_size	= 0;
-	priv.is64		= is64;
 
 	/* Might as well exit boot services now */
 	status = efi_exit_boot_services(sys_table, handle, &map, &priv,
@@ -740,13 +738,11 @@ efi_main(struct efi_config *c, struct boot_params *boot_params)
 	struct desc_struct *desc;
 	void *handle;
 	efi_system_table_t *_table;
-	bool is64;
 
 	efi_early = c;
 
 	_table = (efi_system_table_t *)(unsigned long)efi_early->table;
 	handle = (void *)(unsigned long)efi_early->image_handle;
-	is64 = efi_early->is64;
 
 	sys_table = _table;
 
@@ -754,7 +750,7 @@ efi_main(struct efi_config *c, struct boot_params *boot_params)
 	if (sys_table->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
 		goto fail;
 
-	if (is64)
+	if (efi_is_64bit())
 		setup_boot_services64(efi_early);
 	else
 		setup_boot_services32(efi_early);
@@ -810,7 +806,7 @@ efi_main(struct efi_config *c, struct boot_params *boot_params)
 		hdr->code32_start = bzimage_addr;
 	}
 
-	status = exit_boot(boot_params, handle, is64);
+	status = exit_boot(boot_params, handle);
 	if (status != EFI_SUCCESS) {
 		efi_printk(sys_table, "exit_boot() failed!\n");
 		goto fail;
-- 
2.17.1
