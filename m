From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 7/8] x86, pci: convert SETUP_PCI data to list
Date: Sat, 28 Feb 2015 18:17:38 -0800
Message-ID: <1425176259-30087-8-git-send-email-yinghai@kernel.org>
References: <1425176259-30087-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <1425176259-30087-1-git-send-email-yinghai@kernel.org>
Sender: linux-pci-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-pci@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
List-Id: linux-efi@vger.kernel.org

So we could avoid ioremap every time later.

Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/common.c | 77 +++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 63 insertions(+), 14 deletions(-)

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 4846db7..7b6fb94 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -680,10 +680,41 @@ void __init add_pci(u64 pa_data)
 	early_memunmap(data, sizeof(*data));
 }
 
-int pcibios_add_device(struct pci_dev *dev)
+struct firmware_setup_pci_entry {
+	struct list_head list;
+	uint16_t vendor;
+	uint16_t devid;
+	uint64_t pcilen;
+	unsigned long segment;
+	unsigned long bus;
+	unsigned long device;
+	unsigned long function;
+	phys_addr_t rom;
+};
+
+static LIST_HEAD(setup_pci_entries);
+
+static void __init firmware_setup_pci_add_entry(struct pci_setup_rom *rom,
+					u64 pa_data,
+					struct firmware_setup_pci_entry *entry)
+{
+	entry->segment = rom->segment;
+	entry->bus = rom->bus;
+	entry->device = rom->device;
+	entry->function = rom->function;
+	entry->vendor = rom->vendor;
+	entry->devid = rom->devid;
+	entry->rom = pa_data + offsetof(struct pci_setup_rom, romdata);
+	entry->pcilen = rom->pcilen;
+
+	list_add(&entry->list, &setup_pci_entries);
+}
+
+static __init int fill_setup_pci_entries(void)
 {
 	struct setup_data *data;
 	struct pci_setup_rom *rom;
+	struct firmware_setup_pci_entry *entry;
 	u64 pa_data;
 
 	pa_data = pci_setup_data;
@@ -692,24 +723,42 @@ int pcibios_add_device(struct pci_dev *dev)
 		if (!data)
 			return -ENOMEM;
 
-		rom = (struct pci_setup_rom *)data;
-
-		if ((pci_domain_nr(dev->bus) == rom->segment) &&
-		    (dev->bus->number == rom->bus) &&
-		    (PCI_SLOT(dev->devfn) == rom->device) &&
-		    (PCI_FUNC(dev->devfn) == rom->function) &&
-		    (dev->vendor == rom->vendor) &&
-		    (dev->device == rom->devid)) {
-			dev->rom = pa_data +
-			      offsetof(struct pci_setup_rom, romdata);
-			dev->romlen = rom->pcilen;
+		entry = kzalloc(sizeof(struct firmware_setup_pci_entry),
+				GFP_ATOMIC);
+		if (!entry) {
+			iounmap(data);
+			return -ENOMEM;
+		}
+
+		firmware_setup_pci_add_entry((struct pci_setup_rom *)data,
+					     pa_data, entry);
+		pa_data = data->next;
+		iounmap(data);
+	}
+
+	return 0;
+}
+postcore_initcall(fill_setup_pci_entries);
+
+int pcibios_add_device(struct pci_dev *dev)
+{
+	struct firmware_setup_pci_entry *entry;
+
+	list_for_each_entry(entry, &setup_pci_entries, list) {
+		if ((pci_domain_nr(dev->bus) == entry->segment) &&
+		    (dev->bus->number == entry->bus) &&
+		    (PCI_SLOT(dev->devfn) == entry->device) &&
+		    (PCI_FUNC(dev->devfn) == entry->function) &&
+		    (dev->vendor == entry->vendor) &&
+		    (dev->device == entry->devid)) {
+			dev->rom = entry->rom;
+			dev->romlen = entry->pcilen;
 			dev_printk(KERN_DEBUG, &dev->dev, "set rom to [%#010lx, %#010lx] via SETUP_PCI\n",
 				   (unsigned long)dev->rom,
 				   (unsigned long)(dev->rom + dev->romlen - 1));
 		}
-		pa_data = data->next;
-		iounmap(data);
 	}
+
 	return 0;
 }
 
-- 
1.8.4.5
