From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 03/11] efi: add API to reserve memory persistently across kexec reboot
Date: Thu, 27 Sep 2018 10:50:30 +0200
Message-ID: <20180927085039.8391-4-ard.biesheuvel@linaro.org>
References: <20180927085039.8391-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180927085039.8391-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, Aaron Ma <aaron.ma@canonical.com>, Alistair Strachan <astrachan@google.com>, Ben Hutchings <ben@decadent.org.uk>, Bhupesh Sharma <bhsharma@redhat.com>, Hans de Goede <hdegoede@redhat.com>, Ivan Hu <ivan.hu@canonical.com>, Jeremy Linton <jeremy.linton@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>, Peter Robinson <pbrobinson@redhat.com>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Stefan Agner <stefan@agner.ch>
List-Id: linux-efi@vger.kernel.org

Add kernel plumbing to reserve memory regions persistently on a EFI
system by adding entries to the MEMRESERVE linked list.

Tested-by: Jeremy Linton <jeremy.linton@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/efi.c | 32 ++++++++++++++++++++++++++++++++
 include/linux/efi.h        |  1 +
 2 files changed, 33 insertions(+)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 688132ac8a0a..249eb70691b0 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -962,6 +962,38 @@ bool efi_is_table_address(unsigned long phys_addr)
 	return false;
 }
 
+static DEFINE_SPINLOCK(efi_mem_reserve_persistent_lock);
+
+int efi_mem_reserve_persistent(phys_addr_t addr, u64 size)
+{
+	struct linux_efi_memreserve *rsv, *parent;
+
+	if (efi.mem_reserve == EFI_INVALID_TABLE_ADDR)
+		return -ENODEV;
+
+	rsv = kmalloc(sizeof(*rsv), GFP_KERNEL);
+	if (!rsv)
+		return -ENOMEM;
+
+	parent = memremap(efi.mem_reserve, sizeof(*rsv), MEMREMAP_WB);
+	if (!parent) {
+		kfree(rsv);
+		return -ENOMEM;
+	}
+
+	rsv->base = addr;
+	rsv->size = size;
+
+	spin_lock(&efi_mem_reserve_persistent_lock);
+	rsv->next = parent->next;
+	parent->next = __pa(rsv);
+	spin_unlock(&efi_mem_reserve_persistent_lock);
+
+	memunmap(parent);
+
+	return 0;
+}
+
 #ifdef CONFIG_KEXEC
 static int update_efi_random_seed(struct notifier_block *nb,
 				  unsigned long code, void *unused)
diff --git a/include/linux/efi.h b/include/linux/efi.h
index a5cb580472c5..22e4de9d3700 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1043,6 +1043,7 @@ extern int __init efi_uart_console_only (void);
 extern u64 efi_mem_desc_end(efi_memory_desc_t *md);
 extern int efi_mem_desc_lookup(u64 phys_addr, efi_memory_desc_t *out_md);
 extern void efi_mem_reserve(phys_addr_t addr, u64 size);
+extern int efi_mem_reserve_persistent(phys_addr_t addr, u64 size);
 extern void efi_initialize_iomem_resources(struct resource *code_resource,
 		struct resource *data_resource, struct resource *bss_resource);
 extern void efi_reserve_boot_services(void);
-- 
2.18.0
