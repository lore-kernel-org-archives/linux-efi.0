From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 3/3] efi/arm*: libstub: invoke EFI_RNG_PROTOCOL to seed the UEFI RNG table
Date: Thu, 20 Oct 2016 12:21:26 +0100
Message-ID: <1476962486-18368-4-git-send-email-ard.biesheuvel@linaro.org>
References: <1476962486-18368-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476962486-18368-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
Cc: tytso-3s7WtUTddSA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Invoke the EFI_RNG_PROTOCOL protocol in the context of the stub and
install the Linux-specific RNG seed UEFI config table. This will be
picked up by the EFI routines in the core kernel to seed the kernel
entropy pool.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/libstub/arm-stub.c |  2 +
 drivers/firmware/efi/libstub/efistub.h  |  2 +
 drivers/firmware/efi/libstub/random.c   | 48 ++++++++++++++++++++
 include/linux/efi.h                     |  1 +
 4 files changed, 53 insertions(+)

diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index 993aa56755f6..b4f7d78f9e8b 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -340,6 +340,8 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 	if (status != EFI_SUCCESS)
 		pr_efi_err(sys_table, "Failed initrd from command line!\n");
 
+	efi_random_get_seed(sys_table);
+
 	new_fdt_addr = fdt_addr;
 	status = allocate_new_fdt_and_exit_boot(sys_table, handle,
 				&new_fdt_addr, dram_base + MAX_FDT_OFFSET,
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index fe1f22584c69..b98824e3800a 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -71,4 +71,6 @@ efi_status_t efi_random_alloc(efi_system_table_t *sys_table_arg,
 
 efi_status_t check_platform_features(efi_system_table_t *sys_table_arg);
 
+efi_status_t efi_random_get_seed(efi_system_table_t *sys_table_arg);
+
 #endif
diff --git a/drivers/firmware/efi/libstub/random.c b/drivers/firmware/efi/libstub/random.c
index 0c9f58c5ba50..4aa35c4fe029 100644
--- a/drivers/firmware/efi/libstub/random.c
+++ b/drivers/firmware/efi/libstub/random.c
@@ -141,3 +141,51 @@ efi_status_t efi_random_alloc(efi_system_table_t *sys_table_arg,
 
 	return status;
 }
+
+#define RANDOM_SEED_SIZE	32
+
+efi_status_t efi_random_get_seed(efi_system_table_t *sys_table_arg)
+{
+	efi_guid_t rng_proto = EFI_RNG_PROTOCOL_GUID;
+	efi_guid_t rng_algo_raw = EFI_RNG_ALGORITHM_RAW;
+	efi_guid_t rng_table_guid = LINUX_EFI_RANDOM_SEED_TABLE_GUID;
+	struct efi_rng_protocol *rng;
+	struct linux_efi_random_seed *seed;
+	efi_status_t status;
+
+	status = efi_call_early(locate_protocol, &rng_proto, NULL,
+				(void **)&rng);
+	if (status != EFI_SUCCESS)
+		return status;
+
+	status = efi_call_early(allocate_pool, EFI_RUNTIME_SERVICES_DATA,
+				sizeof(*seed) + RANDOM_SEED_SIZE,
+				(void **)&seed);
+	if (status != EFI_SUCCESS)
+		return status;
+
+	status = rng->get_rng(rng, &rng_algo_raw, RANDOM_SEED_SIZE,
+			      seed->bits);
+	if (status == EFI_UNSUPPORTED)
+		/*
+		 * Use whatever algorithm we have available if the raw algorithm
+		 * is not implemented.
+		 */
+		status = rng->get_rng(rng, NULL, RANDOM_SEED_SIZE,
+				      seed->bits);
+
+	if (status != EFI_SUCCESS)
+		goto err_freepool;
+
+	seed->size = RANDOM_SEED_SIZE;
+	status = efi_call_early(install_configuration_table, &rng_table_guid,
+				seed);
+	if (status != EFI_SUCCESS)
+		goto err_freepool;
+
+	return EFI_SUCCESS;
+
+err_freepool:
+	efi_call_early(free_pool, seed);
+	return status;
+}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 85e28b138cdd..f5a821d9b90c 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -589,6 +589,7 @@ void efi_native_runtime_setup(void);
 #define DEVICE_TREE_GUID			EFI_GUID(0xb1b621d5, 0xf19c, 0x41a5,  0x83, 0x0b, 0xd9, 0x15, 0x2c, 0x69, 0xaa, 0xe0)
 #define EFI_PROPERTIES_TABLE_GUID		EFI_GUID(0x880aaca3, 0x4adc, 0x4a04,  0x90, 0x79, 0xb7, 0x47, 0x34, 0x08, 0x25, 0xe5)
 #define EFI_RNG_PROTOCOL_GUID			EFI_GUID(0x3152bca5, 0xeade, 0x433d,  0x86, 0x2e, 0xc0, 0x1c, 0xdc, 0x29, 0x1f, 0x44)
+#define EFI_RNG_ALGORITHM_RAW			EFI_GUID(0xe43176d7, 0xb6e8, 0x4827,  0xb7, 0x84, 0x7f, 0xfd, 0xc4, 0xb6, 0x85, 0x61)
 #define EFI_MEMORY_ATTRIBUTES_TABLE_GUID	EFI_GUID(0xdcfa911d, 0x26eb, 0x469f,  0xa2, 0x20, 0x38, 0xb7, 0xdc, 0x46, 0x12, 0x20)
 #define EFI_CONSOLE_OUT_DEVICE_GUID		EFI_GUID(0xd3b36f2c, 0xd551, 0x11d4,  0x9a, 0x46, 0x00, 0x90, 0x27, 0x3f, 0xc1, 0x4d)
 
-- 
2.7.4
