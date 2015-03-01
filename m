From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 5/8] x86, boot: Add add_pci handler for SETUP_PCI
Date: Sat, 28 Feb 2015 18:17:36 -0800
Message-ID: <1425176259-30087-6-git-send-email-yinghai@kernel.org>
References: <1425176259-30087-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425176259-30087-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-pci@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
List-Id: linux-efi@vger.kernel.org

Let it reserve setup_data, and keep it's own list.

Also clear the hdr.setup_data, as all handler will handle or
reserve setup_data locally already.

Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: linux-pci@vger.kernel.org
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/pci.h |  2 ++
 arch/x86/kernel/setup.c    |  6 ++++++
 arch/x86/pci/common.c      | 42 ++++++++++++++++++++++++++++--------------
 3 files changed, 36 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index 4e370a5..aa25a22 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -155,4 +155,6 @@ struct pci_setup_rom {
 	uint8_t romdata[0];
 };
 
+void add_pci(u64 pa_data);
+
 #endif /* _ASM_X86_PCI_H */
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index c9b3e2f..93c0adb 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -460,6 +460,9 @@ static void __init parse_setup_data(void)
 		case SETUP_DTB:
 			add_dtb(pa_data);
 			break;
+		case SETUP_PCI:
+			add_pci(pa_data);
+			break;
 		case SETUP_EFI:
 			parse_efi_setup(pa_data, data_len);
 			break;
@@ -467,10 +470,13 @@ static void __init parse_setup_data(void)
 			parse_kaslr_setup(pa_data, data_len);
 			break;
 		default:
+			pr_warn("Unknown setup_data type: %d ignored!\n",
+				data_type);
 			break;
 		}
 		pa_data = pa_next;
 	}
+	boot_params.hdr.setup_data = 0; /* all done */
 }
 
 static void __init memblock_x86_reserve_range_setup_data(void)
diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 3d2612b..4846db7 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -9,6 +9,7 @@
 #include <linux/pci-acpi.h>
 #include <linux/ioport.h>
 #include <linux/init.h>
+#include <linux/memblock.h>
 #include <linux/dmi.h>
 #include <linux/slab.h>
 
@@ -667,31 +668,44 @@ unsigned int pcibios_assign_all_busses(void)
 	return (pci_probe & PCI_ASSIGN_ALL_BUSSES) ? 1 : 0;
 }
 
+static u64 pci_setup_data;
+void __init add_pci(u64 pa_data)
+{
+	struct setup_data *data;
+
+	data = early_memremap(pa_data, sizeof(*data));
+	memblock_reserve(pa_data, sizeof(*data) + data->len);
+	data->next = pci_setup_data;
+	pci_setup_data = pa_data;
+	early_memunmap(data, sizeof(*data));
+}
+
 int pcibios_add_device(struct pci_dev *dev)
 {
 	struct setup_data *data;
 	struct pci_setup_rom *rom;
 	u64 pa_data;
 
-	pa_data = boot_params.hdr.setup_data;
+	pa_data = pci_setup_data;
 	while (pa_data) {
 		data = ioremap(pa_data, sizeof(*rom));
 		if (!data)
 			return -ENOMEM;
 
-		if (data->type == SETUP_PCI) {
-			rom = (struct pci_setup_rom *)data;
-
-			if ((pci_domain_nr(dev->bus) == rom->segment) &&
-			    (dev->bus->number == rom->bus) &&
-			    (PCI_SLOT(dev->devfn) == rom->device) &&
-			    (PCI_FUNC(dev->devfn) == rom->function) &&
-			    (dev->vendor == rom->vendor) &&
-			    (dev->device == rom->devid)) {
-				dev->rom = pa_data +
-				      offsetof(struct pci_setup_rom, romdata);
-				dev->romlen = rom->pcilen;
-			}
+		rom = (struct pci_setup_rom *)data;
+
+		if ((pci_domain_nr(dev->bus) == rom->segment) &&
+		    (dev->bus->number == rom->bus) &&
+		    (PCI_SLOT(dev->devfn) == rom->device) &&
+		    (PCI_FUNC(dev->devfn) == rom->function) &&
+		    (dev->vendor == rom->vendor) &&
+		    (dev->device == rom->devid)) {
+			dev->rom = pa_data +
+			      offsetof(struct pci_setup_rom, romdata);
+			dev->romlen = rom->pcilen;
+			dev_printk(KERN_DEBUG, &dev->dev, "set rom to [%#010lx, %#010lx] via SETUP_PCI\n",
+				   (unsigned long)dev->rom,
+				   (unsigned long)(dev->rom + dev->romlen - 1));
 		}
 		pa_data = data->next;
 		iounmap(data);
-- 
1.8.4.5
