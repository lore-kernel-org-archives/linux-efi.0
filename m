From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2 13/15] x86, pci: convert SETUP_PCI data to list
Date: Wed,  4 Mar 2015 00:00:46 -0800
Message-ID: <1425456048-16236-14-git-send-email-yinghai@kernel.org>
References: <1425456048-16236-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <1425456048-16236-1-git-send-email-yinghai@kernel.org>
Sender: linux-pci-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-pci@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
List-Id: linux-efi@vger.kernel.org

So we could avoid ioremap every time later.

Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/pci.h |  2 ++
 arch/x86/kernel/setup.c    |  1 +
 arch/x86/pci/common.c      | 77 +++++++++++++++++++++++++++++++++++++---------
 3 files changed, 65 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index 7fbd5f3..99b261f 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -88,9 +88,11 @@ static inline void pci_dma_burst_advice(struct pci_dev *pdev,
 	*strategy_parameter = ~0UL;
 }
 void add_pci(u64 pa_data);
+int fill_setup_pci_entries(void);
 #else
 static inline void early_quirks(void) { }
 static inline void add_pci(u64 pa_data) { }
+static inline int fill_setup_pci_entries(void) { }
 #endif
 
 extern void pci_iommu_alloc(void);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 9a18078..215bea8 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1190,6 +1190,7 @@ void __init setup_arch(char **cmdline_p)
 	acpi_boot_init();
 	sfi_init();
 	x86_dtb_init();
+	fill_setup_pci_entries();
 
 	/*
 	 * get boot-time SMP configuration:
diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 4846db7..93577fb 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -668,7 +668,7 @@ unsigned int pcibios_assign_all_busses(void)
 	return (pci_probe & PCI_ASSIGN_ALL_BUSSES) ? 1 : 0;
 }
 
-static u64 pci_setup_data;
+static u64 pci_setup_data __initdata;
 void __init add_pci(u64 pa_data)
 {
 	struct setup_data *data;
@@ -680,36 +680,83 @@ void __init add_pci(u64 pa_data)
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
+	phys_addr_t romdata;
+};
+
+static LIST_HEAD(setup_pci_entries);
+
+int __init fill_setup_pci_entries(void)
 {
 	struct setup_data *data;
 	struct pci_setup_rom *rom;
+	struct firmware_setup_pci_entry *entry;
+	phys_addr_t pa_entry;
 	u64 pa_data;
 
 	pa_data = pci_setup_data;
 	while (pa_data) {
-		data = ioremap(pa_data, sizeof(*rom));
+		data  = early_memremap(pa_data, sizeof(*rom));
 		if (!data)
 			return -ENOMEM;
-
 		rom = (struct pci_setup_rom *)data;
 
-		if ((pci_domain_nr(dev->bus) == rom->segment) &&
-		    (dev->bus->number == rom->bus) &&
-		    (PCI_SLOT(dev->devfn) == rom->device) &&
-		    (PCI_FUNC(dev->devfn) == rom->function) &&
-		    (dev->vendor == rom->vendor) &&
-		    (dev->device == rom->devid)) {
-			dev->rom = pa_data +
-			      offsetof(struct pci_setup_rom, romdata);
-			dev->romlen = rom->pcilen;
+		pa_entry = memblock_alloc(sizeof(*entry), sizeof(long));
+		if (!pa_entry) {
+			early_memunmap(data, sizeof(*rom));
+			return -ENOMEM;
+		}
+
+		entry = phys_to_virt(pa_entry);
+		entry->segment = rom->segment;
+		entry->bus = rom->bus;
+		entry->device = rom->device;
+		entry->function = rom->function;
+		entry->vendor = rom->vendor;
+		entry->devid = rom->devid;
+		entry->pcilen = rom->pcilen;
+		entry->romdata = pa_data +
+				 offsetof(struct pci_setup_rom, romdata);
+
+		list_add(&entry->list, &setup_pci_entries);
+
+		memblock_free(pa_data, sizeof(*rom));
+		pa_data = data->next;
+		early_memunmap(data, sizeof(*rom));
+	}
+
+	pci_setup_data = 0;
+
+	return 0;
+}
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
+			dev->rom = entry->romdata;
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
