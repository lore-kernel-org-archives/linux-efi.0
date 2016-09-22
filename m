From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [RFC PATCH 3/3] efi: implement MMC proxy support for the UEFI variable store
Date: Thu, 22 Sep 2016 12:30:06 +0100
Message-ID: <1474543806-19210-4-git-send-email-ard.biesheuvel@linaro.org>
References: <1474543806-19210-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474543806-19210-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, glikely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org, haojian.zhuang-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

---
 drivers/firmware/efi/Kconfig     |   9 +
 drivers/firmware/efi/Makefile    |   1 +
 drivers/firmware/efi/arm-init.c  |   2 +
 drivers/firmware/efi/mmc-proxy.c | 222 ++++++++++++++++++++
 include/linux/efi.h              |   1 +
 5 files changed, 235 insertions(+)

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index c981be17d3c0..1933e186a9c2 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -129,6 +129,15 @@ config EFI_TEST
 	  Say Y here to enable the runtime services support via /dev/efi_test.
 	  If unsure, say N.
 
+config EFI_MMC_PROXY
+	bool "Expose Embedded MMC host protocol to the firmware"
+	depends on EFI && (ARM || ARM64)
+	help
+	  This driver exposes the MMC host whose DT node is annotated with the
+	  "linux,uefi-varstore" property to the firmware via a UEFI compatible
+	  protocol. This allows the EFI variable store to reside on an MMC
+	  volume that is owned by the OS at runtime.
+
 endmenu
 
 config UEFI_CPER
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index c8a439f6d715..88fdf0e13d6b 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -26,3 +26,4 @@ arm-obj-$(CONFIG_EFI)			:= arm-init.o arm-runtime.o
 obj-$(CONFIG_ARM)			+= $(arm-obj-y)
 obj-$(CONFIG_ARM64)			+= $(arm-obj-y)
 obj-$(CONFIG_EFI_CAPSULE_LOADER)	+= capsule-loader.o
+obj-$(CONFIG_EFI_MMC_PROXY)		+= mmc-proxy.o
diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
index 8efe13075c92..7a57253975a5 100644
--- a/drivers/firmware/efi/arm-init.c
+++ b/drivers/firmware/efi/arm-init.c
@@ -56,9 +56,11 @@ static phys_addr_t efi_to_phys(unsigned long addr)
 }
 
 static __initdata unsigned long screen_info_table = EFI_INVALID_TABLE_ADDR;
+unsigned long __initdata mmc_fv_emulation_table = EFI_INVALID_TABLE_ADDR;
 
 static __initdata efi_config_table_type_t arch_tables[] = {
 	{LINUX_EFI_ARM_SCREEN_INFO_TABLE_GUID, NULL, &screen_info_table},
+	{LINUX_MMC_FV_EMULATION_TABLE_GUID, NULL, &mmc_fv_emulation_table},
 	{NULL_GUID, NULL, NULL}
 };
 
diff --git a/drivers/firmware/efi/mmc-proxy.c b/drivers/firmware/efi/mmc-proxy.c
new file mode 100644
index 000000000000..3702bb2a5af0
--- /dev/null
+++ b/drivers/firmware/efi/mmc-proxy.c
@@ -0,0 +1,222 @@
+/*
+ * Copyright (C) 2016 Linaro Ltd. <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/efi.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+
+#include <asm/efi.h>
+
+extern unsigned long mmc_fv_emulation_table;
+
+enum emmc_state {
+	mmc_invalid_state = 0,
+	mmc_hw_initialization_state,
+	mmc_idle_state,
+	mmc_ready_state,
+	mmc_identification_state,
+	mmc_standby_state,
+	mmc_transfer_state,
+	mmc_sending_data_state,
+	mmc_receive_data_state,
+	mmc_programming_state,
+	mmc_disconnect_state,
+};
+
+static char const emmc_state_string[][28] = {
+	"mmc_invalid_state",
+	"mmc_hw_initialization_state",
+	"mmc_idle_state",
+	"mmc_ready_state",
+	"mmc_identification_state",
+	"mmc_standby_state",
+	"mmc_transfer_state",
+	"mmc_sending_data_state",
+	"mmc_receive_data_state",
+	"mmc_programming_state",
+	"mmc_disconnect_state",
+};
+
+/*
+ * This MMC host protocol version is not in the UEFI spec, and lives under
+ * EmbeddedPkg/ in Tianocore/EDK2.
+ */
+struct emmc_host_protocol
+{
+	u32		revision;
+	bool		(*is_card_present)(struct emmc_host_protocol*);
+	bool		(*is_read_only)(struct emmc_host_protocol*);
+	efi_status_t	(*build_device_path)(struct emmc_host_protocol*,
+					     void*);
+	efi_status_t	(*notify_state)(struct emmc_host_protocol*,
+					enum emmc_state);
+	efi_status_t	(*send_command)(struct emmc_host_protocol*,
+					u32, u32);
+	efi_status_t	(*receive_response)(struct emmc_host_protocol*,
+					    u32, u32*);
+	efi_status_t	(*read_block_data)(struct emmc_host_protocol*,
+					   u64, unsigned long, u32*);
+	efi_status_t	(*write_block_data)(struct emmc_host_protocol*,
+					    u64, unsigned long, u32*);
+};
+
+static bool mmc_is_card_present(struct emmc_host_protocol *this)
+{
+	return true;
+}
+
+static bool mmc_is_read_only(struct emmc_host_protocol *this)
+{
+	return false;
+}
+
+static efi_status_t mmc_build_device_path(struct emmc_host_protocol *this,
+					  void *dpp)
+{
+	return EFI_UNSUPPORTED;
+}
+
+static efi_status_t mmc_notify_state(struct emmc_host_protocol *this,
+				     enum emmc_state state)
+{
+	struct efi_simd_reg_stash simd_stash;
+
+	arch_efi_stash_simd_regs(&simd_stash);
+	arch_efi_call_virt_teardown();
+
+	pr_warn("mmc-proxy: entered %s state\n", emmc_state_string[state]);
+	might_sleep();
+
+	arch_efi_call_virt_setup();
+	arch_efi_unstash_simd_regs(&simd_stash);
+
+	return EFI_SUCCESS;
+}
+
+static efi_status_t mmc_send_command(struct emmc_host_protocol *this, u32 cmd,
+				     u32 arg)
+{
+	struct efi_simd_reg_stash simd_stash;
+
+	arch_efi_stash_simd_regs(&simd_stash);
+	arch_efi_call_virt_teardown();
+
+	pr_warn("mmc-proxy: send command %d (0x%x)\n", cmd, arg);
+	might_sleep();
+
+	arch_efi_call_virt_setup();
+	arch_efi_unstash_simd_regs(&simd_stash);
+	return EFI_NOT_FOUND;
+}
+
+static efi_status_t mmc_receive_response(struct emmc_host_protocol *this,
+					 u32 mmc_response_type, u32 *buffer)
+{
+	struct efi_simd_reg_stash simd_stash;
+	u32 response[4] = {};
+
+	arch_efi_stash_simd_regs(&simd_stash);
+	arch_efi_call_virt_teardown();
+
+	pr_warn("mmc-proxy: receive response %d\n", mmc_response_type);
+	might_sleep();
+
+	arch_efi_call_virt_setup();
+	arch_efi_unstash_simd_regs(&simd_stash);
+	memcpy(buffer, response, sizeof(response));
+
+	return EFI_NOT_FOUND;
+}
+
+static efi_status_t mmc_read_block_data(struct emmc_host_protocol *this,
+					u64 lba, unsigned long len,
+					u32 *buffer)
+{
+	struct efi_simd_reg_stash simd_stash;
+	void *bounce;
+
+	arch_efi_stash_simd_regs(&simd_stash);
+	arch_efi_call_virt_teardown();
+
+	bounce = kmalloc(len, GFP_KERNEL);
+
+	pr_warn("mmc-proxy: read block data lba==%lld, len==%ld\n", lba, len);
+	might_sleep();
+
+	arch_efi_call_virt_setup();
+	arch_efi_unstash_simd_regs(&simd_stash);
+	memcpy(buffer, bounce, len);
+	kfree(bounce);
+
+	return EFI_NOT_FOUND;
+}
+
+static efi_status_t mmc_write_block_data(struct emmc_host_protocol *this,
+					 u64 lba, unsigned long len,
+					 u32 *buffer)
+{
+	struct efi_simd_reg_stash simd_stash;
+	void *bounce;
+
+	/*
+	 * 'buffer' may point to memory that is mapped via the EFI page tables,
+	 * so copy the data before switching back to the ordinary mappings.
+	 */
+	bounce = kmalloc(len, GFP_ATOMIC);
+	if (!bounce)
+		return EFI_OUT_OF_RESOURCES;
+	memcpy(bounce, buffer, len);
+
+	arch_efi_stash_simd_regs(&simd_stash);
+	arch_efi_call_virt_teardown();
+
+	pr_warn("mmc-proxy: write block data lba==%lld, len==%ld\n", lba, len);
+	might_sleep();
+
+	kfree(bounce);
+	arch_efi_call_virt_setup();
+	arch_efi_unstash_simd_regs(&simd_stash);
+	return EFI_NOT_FOUND;
+}
+
+static const struct emmc_host_protocol emmc_proxy =
+{
+	0x00010001,		// revision 1.1
+	mmc_is_card_present,
+	mmc_is_read_only,
+	mmc_build_device_path,
+	mmc_notify_state,
+	mmc_send_command,
+	mmc_receive_response,
+	mmc_read_block_data,
+	mmc_write_block_data
+};
+
+static int __init emmc_proxy_install(void)
+{
+	unsigned long *p;
+
+	if (mmc_fv_emulation_table == EFI_INVALID_TABLE_ADDR)
+		return 0;
+
+	p = memremap(mmc_fv_emulation_table, sizeof(*p), MEMREMAP_WB);
+	if (!p)
+		return -ENOMEM;
+
+	/*
+	 * We expect a NULL value here, since the firmware should have cleared
+	 * this value in its ExitBootServices() handler.
+	 */
+	if (!WARN_ON(*p != 0))
+		*p = (unsigned long)&emmc_proxy;
+
+	memunmap(p);
+	return 0;
+}
+late_initcall(emmc_proxy_install);
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 2d089487d2da..25a4ae648b6f 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -599,6 +599,7 @@ void efi_native_runtime_setup(void);
  */
 #define LINUX_EFI_ARM_SCREEN_INFO_TABLE_GUID	EFI_GUID(0xe03fc20a, 0x85dc, 0x406e,  0xb9, 0x0e, 0x4a, 0xb5, 0x02, 0x37, 0x1d, 0x95)
 #define LINUX_EFI_LOADER_ENTRY_GUID		EFI_GUID(0x4a67b082, 0x0a4c, 0x41cf,  0xb6, 0xc7, 0x44, 0x0b, 0x29, 0xbb, 0x8c, 0x4f)
+#define LINUX_MMC_FV_EMULATION_TABLE_GUID	EFI_GUID(0x44cd9912, 0xfda8, 0x4b7d,  0xa6, 0x13, 0x1b, 0x61, 0x34, 0xfc, 0xdc, 0x4a)
 
 typedef struct {
 	efi_guid_t guid;
-- 
2.7.4
