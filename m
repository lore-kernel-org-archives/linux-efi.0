From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2 14/15] x86, boot: copy rom to kernel space
Date: Wed,  4 Mar 2015 00:00:47 -0800
Message-ID: <1425456048-16236-15-git-send-email-yinghai@kernel.org>
References: <1425456048-16236-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425456048-16236-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-pci@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
List-Id: linux-efi@vger.kernel.org

As EFI stub code could put them high when on 32bit or with exactmap=
on 64bit conf.

Check is the range is mapped, otherwise allocate new one and have
the rom data copied. So we could really avoid ioremap.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/common.c | 47 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 45 insertions(+), 2 deletions(-)

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 93577fb..a5de331 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -694,6 +694,48 @@ struct firmware_setup_pci_entry {
 
 static LIST_HEAD(setup_pci_entries);
 
+static phys_addr_t check_copy(phys_addr_t start, unsigned long size)
+{
+	unsigned long start_pfn = PFN_DOWN(start);
+	unsigned long end_pfn = PFN_UP(start + size);
+	unsigned char *p, *q;
+	phys_addr_t pa_p, pa_q;
+	long sz = size;
+
+	if (pfn_range_is_mapped(start_pfn, end_pfn))
+		return start;
+
+	/* allocate and copy */
+	pa_p = memblock_alloc(size, PAGE_SIZE);
+	if (!pa_p)
+		return start;
+
+	p = phys_to_virt(pa_p);
+
+	pa_q = start;
+	while (sz > 0) {
+		long chunk_size = 64<<10;
+
+		if (chunk_size > sz)
+			chunk_size = sz;
+
+		q = early_memremap(pa_q, chunk_size);
+		if (!q) {
+			memblock_free(pa_p, size);
+			return start;
+		}
+		memcpy(p, q, chunk_size);
+		early_memunmap(q, chunk_size);
+		p += chunk_size;
+		pa_q += chunk_size;
+		sz -= chunk_size;
+	}
+
+	early_memunmap(start, size);
+
+	return pa_p;
+}
+
 int __init fill_setup_pci_entries(void)
 {
 	struct setup_data *data;
@@ -723,8 +765,9 @@ int __init fill_setup_pci_entries(void)
 		entry->vendor = rom->vendor;
 		entry->devid = rom->devid;
 		entry->pcilen = rom->pcilen;
-		entry->romdata = pa_data +
-				 offsetof(struct pci_setup_rom, romdata);
+		entry->romdata = check_copy(pa_data +
+				      offsetof(struct pci_setup_rom, romdata),
+				      rom->pcilen);
 
 		list_add(&entry->list, &setup_pci_entries);
 
-- 
1.8.4.5
