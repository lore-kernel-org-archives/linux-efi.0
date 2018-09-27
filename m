From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 02/11] efi/arm: libstub: add a root memreserve config table
Date: Thu, 27 Sep 2018 10:50:29 +0200
Message-ID: <20180927085039.8391-3-ard.biesheuvel@linaro.org>
References: <20180927085039.8391-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180927085039.8391-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, Aaron Ma <aaron.ma@canonical.com>, Alistair Strachan <astrachan@google.com>, Ben Hutchings <ben@decadent.org.uk>, Bhupesh Sharma <bhsharma@redhat.com>, Hans de Goede <hdegoede@redhat.com>, Ivan Hu <ivan.hu@canonical.com>, Jeremy Linton <jeremy.linton@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>, Peter Robinson <pbrobinson@redhat.com>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Stefan Agner <stefan@agner.ch>
List-Id: linux-efi@vger.kernel.org

Installing UEFI configuration tables can only be done before calling
ExitBootServices(), so if we want to use the new MEMRESRVE config table
from the kernel proper, we need to install a dummy entry from the stub.

Tested-by: Jeremy Linton <jeremy.linton@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/libstub/arm-stub.c | 27 +++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index 6920033de6d4..30ac0c975f8a 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -69,6 +69,31 @@ static struct screen_info *setup_graphics(efi_system_table_t *sys_table_arg)
 	return si;
 }
 
+void install_memreserve_table(efi_system_table_t *sys_table_arg)
+{
+	struct linux_efi_memreserve *rsv;
+	efi_guid_t memreserve_table_guid = LINUX_EFI_MEMRESERVE_TABLE_GUID;
+	efi_status_t status;
+
+	status = efi_call_early(allocate_pool, EFI_LOADER_DATA, sizeof(*rsv),
+				(void **)&rsv);
+	if (status != EFI_SUCCESS) {
+		pr_efi_err(sys_table_arg, "Failed to allocate memreserve entry!\n");
+		return;
+	}
+
+	rsv->next = 0;
+	rsv->base = 0;
+	rsv->size = 0;
+
+	status = efi_call_early(install_configuration_table,
+				&memreserve_table_guid,
+				rsv);
+	if (status != EFI_SUCCESS)
+		pr_efi_err(sys_table_arg, "Failed to install memreserve config table!\n");
+}
+
+
 /*
  * This function handles the architcture specific differences between arm and
  * arm64 regarding where the kernel image must be loaded and any memory that
@@ -235,6 +260,8 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 		}
 	}
 
+	install_memreserve_table(sys_table);
+
 	new_fdt_addr = fdt_addr;
 	status = allocate_new_fdt_and_exit_boot(sys_table, handle,
 				&new_fdt_addr, efi_get_max_fdt_addr(dram_base),
-- 
2.18.0
