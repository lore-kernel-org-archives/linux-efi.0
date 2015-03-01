From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 8/8] x86, pci: export SETUP_PCI data via sysfs
Date: Sat, 28 Feb 2015 18:17:39 -0800
Message-ID: <1425176259-30087-9-git-send-email-yinghai@kernel.org>
References: <1425176259-30087-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425176259-30087-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-pci@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
List-Id: linux-efi@vger.kernel.org

So we could let kexec-tools to rebuild SETUP_PCI and pass it to
second kernel.
Now kexec-tools only can build SETUP_EFI and SETUP_E820EXT.

Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/common.c | 188 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 188 insertions(+)

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 7b6fb94..bf0209a 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -682,6 +682,8 @@ void __init add_pci(u64 pa_data)
 
 struct firmware_setup_pci_entry {
 	struct list_head list;
+	struct kobject kobj;
+	struct bin_attribute *rom_attr;
 	uint16_t vendor;
 	uint16_t devid;
 	uint64_t pcilen;
@@ -762,6 +764,192 @@ int pcibios_add_device(struct pci_dev *dev)
 	return 0;
 }
 
+#ifdef CONFIG_SYSFS
+static inline struct firmware_setup_pci_entry *
+to_setup_pci_entry(struct kobject *kobj)
+{
+	return container_of(kobj, struct firmware_setup_pci_entry, kobj);
+}
+
+static ssize_t vendor_show(struct firmware_setup_pci_entry *entry, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "0x%04llx\n",
+			(unsigned long long)entry->vendor);
+}
+
+static ssize_t devid_show(struct firmware_setup_pci_entry *entry, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "0x%04llx\n",
+			(unsigned long long)entry->devid);
+}
+
+static ssize_t pcilen_show(struct firmware_setup_pci_entry *entry, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "0x%llx\n",
+			(unsigned long long)entry->pcilen);
+}
+
+static ssize_t segment_show(struct firmware_setup_pci_entry *entry, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "0x%04llx\n",
+			(unsigned long long)entry->segment);
+}
+
+static ssize_t bus_show(struct firmware_setup_pci_entry *entry, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "0x%02llx\n",
+			(unsigned long long)entry->bus);
+}
+
+static ssize_t device_show(struct firmware_setup_pci_entry *entry, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "0x%02llx\n",
+			(unsigned long long)entry->device);
+}
+
+static ssize_t function_show(struct firmware_setup_pci_entry *entry, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "0x%1llx\n",
+			(unsigned long long)entry->function);
+}
+
+struct setup_pci_attribute {
+	struct attribute attr;
+	ssize_t (*show)(struct firmware_setup_pci_entry *entry, char *buf);
+};
+
+static inline struct setup_pci_attribute *to_setup_pci_attr(
+							struct attribute *attr)
+{
+	return container_of(attr, struct setup_pci_attribute, attr);
+}
+
+static ssize_t setup_pci_attr_show(struct kobject *kobj,
+				   struct attribute *attr, char *buf)
+{
+	struct firmware_setup_pci_entry *entry = to_setup_pci_entry(kobj);
+	struct setup_pci_attribute *setup_pci_attr = to_setup_pci_attr(attr);
+
+	return setup_pci_attr->show(entry, buf);
+}
+
+static struct setup_pci_attribute setup_pci_vendor_attr = __ATTR_RO(vendor);
+static struct setup_pci_attribute setup_pci_devid_attr = __ATTR_RO(devid);
+static struct setup_pci_attribute setup_pci_pcilen_attr = __ATTR_RO(pcilen);
+static struct setup_pci_attribute setup_pci_segment_attr = __ATTR_RO(segment);
+static struct setup_pci_attribute setup_pci_bus_attr = __ATTR_RO(bus);
+static struct setup_pci_attribute setup_pci_device_attr = __ATTR_RO(device);
+static struct setup_pci_attribute setup_pci_function_attr = __ATTR_RO(function);
+
+/*
+ * These are default attributes that are added for every memmap entry.
+ */
+static struct attribute *def_attrs[] = {
+	&setup_pci_vendor_attr.attr,
+	&setup_pci_devid_attr.attr,
+	&setup_pci_pcilen_attr.attr,
+	&setup_pci_segment_attr.attr,
+	&setup_pci_bus_attr.attr,
+	&setup_pci_device_attr.attr,
+	&setup_pci_function_attr.attr,
+	NULL
+};
+
+static const struct sysfs_ops setup_pci_attr_ops = {
+	.show = setup_pci_attr_show,
+};
+
+static struct kobj_type __refdata setup_pci_ktype = {
+	.sysfs_ops      = &setup_pci_attr_ops,
+	.default_attrs  = def_attrs,
+};
+
+static ssize_t setup_pci_rom_read(struct file *filp, struct kobject *kobj,
+				  struct bin_attribute *bin_attr, char *buf,
+				  loff_t off, size_t count)
+{
+	struct firmware_setup_pci_entry *entry = to_setup_pci_entry(kobj);
+
+	if (off >= entry->pcilen)
+		count = 0;
+	else {
+		unsigned long start_pfn, end_pfn;
+		void *rom;
+
+		if (off + count > entry->pcilen)
+			count = entry->pcilen - off;
+
+		start_pfn = PFN_DOWN(entry->rom + off);
+		end_pfn = PFN_UP(entry->rom + off + count);
+		if (pfn_range_is_mapped(start_pfn, end_pfn)) {
+			rom = phys_to_virt(entry->rom);
+			memcpy(buf, rom + off, count);
+		} else {
+			rom = ioremap(entry->rom + off, count);
+			if (rom) {
+				memcpy_fromio(buf, rom, count);
+				iounmap(rom);
+			} else
+				count = 0;
+		}
+	}
+
+	return count;
+}
+
+static int __init add_sysfs_fw_setup_pci_entry(
+					struct firmware_setup_pci_entry *entry)
+{
+	int retval = 0;
+	static int setup_pci_entries_nr;
+	static struct kset *setup_pci_kset;
+	struct bin_attribute *attr;
+
+	kobject_init(&entry->kobj, &setup_pci_ktype);
+
+	if (!setup_pci_kset) {
+		setup_pci_kset = kset_create_and_add("setup_pci", NULL,
+						     firmware_kobj);
+		if (!setup_pci_kset)
+			return -ENOMEM;
+	}
+
+	entry->kobj.kset = setup_pci_kset;
+	retval = kobject_add(&entry->kobj, NULL, "%d", setup_pci_entries_nr++);
+	if (retval) {
+		kobject_put(&entry->kobj);
+		return retval;
+	}
+
+	attr = kzalloc(sizeof(*attr), GFP_ATOMIC);
+	if (!attr)
+		return -ENOMEM;
+
+	sysfs_bin_attr_init(attr);
+	attr->size = entry->pcilen;
+	attr->attr.name = "rom";
+	attr->attr.mode = S_IRUSR;
+	attr->read = setup_pci_rom_read;
+	retval = sysfs_create_bin_file(&entry->kobj, attr);
+	if (retval)
+		kfree(attr);
+	entry->rom_attr = attr;
+
+	return retval;
+}
+
+static int __init firmware_setup_pci_init(void)
+{
+	struct firmware_setup_pci_entry *entry;
+
+	list_for_each_entry(entry, &setup_pci_entries, list)
+		add_sysfs_fw_setup_pci_entry(entry);
+
+	return 0;
+}
+late_initcall(firmware_setup_pci_init);
+#endif
+
 int pcibios_enable_device(struct pci_dev *dev, int mask)
 {
 	int err;
-- 
1.8.4.5
