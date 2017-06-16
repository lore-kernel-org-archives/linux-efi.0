From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: [PATCH v7 03/36] x86, mpparse, x86/acpi, x86/PCI, x86/dmi,
	SFI: Use memremap for RAM mappings
Date: Fri, 16 Jun 2017 13:50:23 -0500
Message-ID: <20170616185023.18967.72831.stgit@tlendack-t1.amdoffice.net>
References: <20170616184947.18967.84890.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20170616184947.18967.84890.stgit-qCXWGYdRb2BnqfbPTmsdiZQ+2ll4COg0XqFh9Ls21Oc@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Cc: Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, Toshimitsu Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Radim =?utf-8?b?S3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The ioremap() function is intended for mapping MMIO. For RAM, the
memremap() function should be used. Convert calls from ioremap() to
memremap() when re-mapping RAM.

This will be used later by SME to control how the encryption mask is
applied to memory mappings, with certain memory locations being mapped
decrypted vs encrypted.

Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
---
 arch/x86/include/asm/dmi.h   |    8 ++++----
 arch/x86/kernel/acpi/boot.c  |    6 +++---
 arch/x86/kernel/kdebugfs.c   |   34 +++++++++++-----------------------
 arch/x86/kernel/ksysfs.c     |   28 ++++++++++++++--------------
 arch/x86/kernel/mpparse.c    |   10 +++++-----
 arch/x86/pci/common.c        |    4 ++--
 drivers/firmware/dmi-sysfs.c |    5 +++--
 drivers/firmware/pcdp.c      |    4 ++--
 drivers/sfi/sfi_core.c       |   22 +++++++++++-----------
 9 files changed, 55 insertions(+), 66 deletions(-)

diff --git a/arch/x86/include/asm/dmi.h b/arch/x86/include/asm/dmi.h
index 3c69fed..a8e15b0 100644
--- a/arch/x86/include/asm/dmi.h
+++ b/arch/x86/include/asm/dmi.h
@@ -13,9 +13,9 @@ static __always_inline __init void *dmi_alloc(unsigned len)
 }
 
 /* Use early IO mappings for DMI because it's initialized early */
-#define dmi_early_remap		early_ioremap
-#define dmi_early_unmap		early_iounmap
-#define dmi_remap		ioremap_cache
-#define dmi_unmap		iounmap
+#define dmi_early_remap		early_memremap
+#define dmi_early_unmap		early_memunmap
+#define dmi_remap(_x, _l)	memremap(_x, _l, MEMREMAP_WB)
+#define dmi_unmap(_x)		memunmap(_x)
 
 #endif /* _ASM_X86_DMI_H */
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 6bb6806..850160a 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -115,7 +115,7 @@
 #define	ACPI_INVALID_GSI		INT_MIN
 
 /*
- * This is just a simple wrapper around early_ioremap(),
+ * This is just a simple wrapper around early_memremap(),
  * with sanity checks for phys == 0 and size == 0.
  */
 char *__init __acpi_map_table(unsigned long phys, unsigned long size)
@@ -124,7 +124,7 @@ char *__init __acpi_map_table(unsigned long phys, unsigned long size)
 	if (!phys || !size)
 		return NULL;
 
-	return early_ioremap(phys, size);
+	return early_memremap(phys, size);
 }
 
 void __init __acpi_unmap_table(char *map, unsigned long size)
@@ -132,7 +132,7 @@ void __init __acpi_unmap_table(char *map, unsigned long size)
 	if (!map || !size)
 		return;
 
-	early_iounmap(map, size);
+	early_memunmap(map, size);
 }
 
 #ifdef CONFIG_X86_LOCAL_APIC
diff --git a/arch/x86/kernel/kdebugfs.c b/arch/x86/kernel/kdebugfs.c
index 38b6458..fd6f8fb 100644
--- a/arch/x86/kernel/kdebugfs.c
+++ b/arch/x86/kernel/kdebugfs.c
@@ -33,7 +33,6 @@ static ssize_t setup_data_read(struct file *file, char __user *user_buf,
 	struct setup_data_node *node = file->private_data;
 	unsigned long remain;
 	loff_t pos = *ppos;
-	struct page *pg;
 	void *p;
 	u64 pa;
 
@@ -47,18 +46,13 @@ static ssize_t setup_data_read(struct file *file, char __user *user_buf,
 		count = node->len - pos;
 
 	pa = node->paddr + sizeof(struct setup_data) + pos;
-	pg = pfn_to_page((pa + count - 1) >> PAGE_SHIFT);
-	if (PageHighMem(pg)) {
-		p = ioremap_cache(pa, count);
-		if (!p)
-			return -ENXIO;
-	} else
-		p = __va(pa);
+	p = memremap(pa, count, MEMREMAP_WB);
+	if (!p)
+		return -ENOMEM;
 
 	remain = copy_to_user(user_buf, p, count);
 
-	if (PageHighMem(pg))
-		iounmap(p);
+	memunmap(p);
 
 	if (remain)
 		return -EFAULT;
@@ -109,7 +103,6 @@ static int __init create_setup_data_nodes(struct dentry *parent)
 	struct setup_data *data;
 	int error;
 	struct dentry *d;
-	struct page *pg;
 	u64 pa_data;
 	int no = 0;
 
@@ -126,16 +119,12 @@ static int __init create_setup_data_nodes(struct dentry *parent)
 			goto err_dir;
 		}
 
-		pg = pfn_to_page((pa_data+sizeof(*data)-1) >> PAGE_SHIFT);
-		if (PageHighMem(pg)) {
-			data = ioremap_cache(pa_data, sizeof(*data));
-			if (!data) {
-				kfree(node);
-				error = -ENXIO;
-				goto err_dir;
-			}
-		} else
-			data = __va(pa_data);
+		data = memremap(pa_data, sizeof(*data), MEMREMAP_WB);
+		if (!data) {
+			kfree(node);
+			error = -ENOMEM;
+			goto err_dir;
+		}
 
 		node->paddr = pa_data;
 		node->type = data->type;
@@ -143,8 +132,7 @@ static int __init create_setup_data_nodes(struct dentry *parent)
 		error = create_setup_data_node(d, no, node);
 		pa_data = data->next;
 
-		if (PageHighMem(pg))
-			iounmap(data);
+		memunmap(data);
 		if (error)
 			goto err_dir;
 		no++;
diff --git a/arch/x86/kernel/ksysfs.c b/arch/x86/kernel/ksysfs.c
index 4afc67f..ee51db9 100644
--- a/arch/x86/kernel/ksysfs.c
+++ b/arch/x86/kernel/ksysfs.c
@@ -16,8 +16,8 @@
 #include <linux/stat.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
+#include <linux/io.h>
 
-#include <asm/io.h>
 #include <asm/setup.h>
 
 static ssize_t version_show(struct kobject *kobj,
@@ -79,12 +79,12 @@ static int get_setup_data_paddr(int nr, u64 *paddr)
 			*paddr = pa_data;
 			return 0;
 		}
-		data = ioremap_cache(pa_data, sizeof(*data));
+		data = memremap(pa_data, sizeof(*data), MEMREMAP_WB);
 		if (!data)
 			return -ENOMEM;
 
 		pa_data = data->next;
-		iounmap(data);
+		memunmap(data);
 		i++;
 	}
 	return -EINVAL;
@@ -97,17 +97,17 @@ static int __init get_setup_data_size(int nr, size_t *size)
 	u64 pa_data = boot_params.hdr.setup_data;
 
 	while (pa_data) {
-		data = ioremap_cache(pa_data, sizeof(*data));
+		data = memremap(pa_data, sizeof(*data), MEMREMAP_WB);
 		if (!data)
 			return -ENOMEM;
 		if (nr == i) {
 			*size = data->len;
-			iounmap(data);
+			memunmap(data);
 			return 0;
 		}
 
 		pa_data = data->next;
-		iounmap(data);
+		memunmap(data);
 		i++;
 	}
 	return -EINVAL;
@@ -127,12 +127,12 @@ static ssize_t type_show(struct kobject *kobj,
 	ret = get_setup_data_paddr(nr, &paddr);
 	if (ret)
 		return ret;
-	data = ioremap_cache(paddr, sizeof(*data));
+	data = memremap(paddr, sizeof(*data), MEMREMAP_WB);
 	if (!data)
 		return -ENOMEM;
 
 	ret = sprintf(buf, "0x%x\n", data->type);
-	iounmap(data);
+	memunmap(data);
 	return ret;
 }
 
@@ -154,7 +154,7 @@ static ssize_t setup_data_data_read(struct file *fp,
 	ret = get_setup_data_paddr(nr, &paddr);
 	if (ret)
 		return ret;
-	data = ioremap_cache(paddr, sizeof(*data));
+	data = memremap(paddr, sizeof(*data), MEMREMAP_WB);
 	if (!data)
 		return -ENOMEM;
 
@@ -170,15 +170,15 @@ static ssize_t setup_data_data_read(struct file *fp,
 		goto out;
 
 	ret = count;
-	p = ioremap_cache(paddr + sizeof(*data), data->len);
+	p = memremap(paddr + sizeof(*data), data->len, MEMREMAP_WB);
 	if (!p) {
 		ret = -ENOMEM;
 		goto out;
 	}
 	memcpy(buf, p + off, count);
-	iounmap(p);
+	memunmap(p);
 out:
-	iounmap(data);
+	memunmap(data);
 	return ret;
 }
 
@@ -250,13 +250,13 @@ static int __init get_setup_data_total_num(u64 pa_data, int *nr)
 	*nr = 0;
 	while (pa_data) {
 		*nr += 1;
-		data = ioremap_cache(pa_data, sizeof(*data));
+		data = memremap(pa_data, sizeof(*data), MEMREMAP_WB);
 		if (!data) {
 			ret = -ENOMEM;
 			goto out;
 		}
 		pa_data = data->next;
-		iounmap(data);
+		memunmap(data);
 	}
 
 out:
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 0d904d7..fd37f39 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -436,9 +436,9 @@ static unsigned long __init get_mpc_size(unsigned long physptr)
 	struct mpc_table *mpc;
 	unsigned long size;
 
-	mpc = early_ioremap(physptr, PAGE_SIZE);
+	mpc = early_memremap(physptr, PAGE_SIZE);
 	size = mpc->length;
-	early_iounmap(mpc, PAGE_SIZE);
+	early_memunmap(mpc, PAGE_SIZE);
 	apic_printk(APIC_VERBOSE, "  mpc: %lx-%lx\n", physptr, physptr + size);
 
 	return size;
@@ -450,7 +450,7 @@ static int __init check_physptr(struct mpf_intel *mpf, unsigned int early)
 	unsigned long size;
 
 	size = get_mpc_size(mpf->physptr);
-	mpc = early_ioremap(mpf->physptr, size);
+	mpc = early_memremap(mpf->physptr, size);
 	/*
 	 * Read the physical hardware table.  Anything here will
 	 * override the defaults.
@@ -461,10 +461,10 @@ static int __init check_physptr(struct mpf_intel *mpf, unsigned int early)
 #endif
 		pr_err("BIOS bug, MP table errors detected!...\n");
 		pr_cont("... disabling SMP support. (tell your hw vendor)\n");
-		early_iounmap(mpc, size);
+		early_memunmap(mpc, size);
 		return -1;
 	}
-	early_iounmap(mpc, size);
+	early_memunmap(mpc, size);
 
 	if (early)
 		return -1;
diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 190e718..08cf71c 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -691,7 +691,7 @@ int pcibios_add_device(struct pci_dev *dev)
 
 	pa_data = boot_params.hdr.setup_data;
 	while (pa_data) {
-		data = ioremap(pa_data, sizeof(*rom));
+		data = memremap(pa_data, sizeof(*rom), MEMREMAP_WB);
 		if (!data)
 			return -ENOMEM;
 
@@ -710,7 +710,7 @@ int pcibios_add_device(struct pci_dev *dev)
 			}
 		}
 		pa_data = data->next;
-		iounmap(data);
+		memunmap(data);
 	}
 	set_dma_domain_ops(dev);
 	set_dev_domain_options(dev);
diff --git a/drivers/firmware/dmi-sysfs.c b/drivers/firmware/dmi-sysfs.c
index ef76e5e..d5de6ee 100644
--- a/drivers/firmware/dmi-sysfs.c
+++ b/drivers/firmware/dmi-sysfs.c
@@ -25,6 +25,7 @@
 #include <linux/slab.h>
 #include <linux/list.h>
 #include <linux/io.h>
+#include <asm/dmi.h>
 
 #define MAX_ENTRY_TYPE 255 /* Most of these aren't used, but we consider
 			      the top entry type is only 8 bits */
@@ -380,7 +381,7 @@ static ssize_t dmi_sel_raw_read_phys32(struct dmi_sysfs_entry *entry,
 	u8 __iomem *mapped;
 	ssize_t wrote = 0;
 
-	mapped = ioremap(sel->access_method_address, sel->area_length);
+	mapped = dmi_remap(sel->access_method_address, sel->area_length);
 	if (!mapped)
 		return -EIO;
 
@@ -390,7 +391,7 @@ static ssize_t dmi_sel_raw_read_phys32(struct dmi_sysfs_entry *entry,
 		wrote++;
 	}
 
-	iounmap(mapped);
+	dmi_unmap(mapped);
 	return wrote;
 }
 
diff --git a/drivers/firmware/pcdp.c b/drivers/firmware/pcdp.c
index 75273a25..e83d6ae 100644
--- a/drivers/firmware/pcdp.c
+++ b/drivers/firmware/pcdp.c
@@ -95,7 +95,7 @@
 	if (efi.hcdp == EFI_INVALID_TABLE_ADDR)
 		return -ENODEV;
 
-	pcdp = early_ioremap(efi.hcdp, 4096);
+	pcdp = early_memremap(efi.hcdp, 4096);
 	printk(KERN_INFO "PCDP: v%d at 0x%lx\n", pcdp->rev, efi.hcdp);
 
 	if (strstr(cmdline, "console=hcdp")) {
@@ -131,6 +131,6 @@
 	}
 
 out:
-	early_iounmap(pcdp, 4096);
+	early_memunmap(pcdp, 4096);
 	return rc;
 }
diff --git a/drivers/sfi/sfi_core.c b/drivers/sfi/sfi_core.c
index 296db7a..d5ce534 100644
--- a/drivers/sfi/sfi_core.c
+++ b/drivers/sfi/sfi_core.c
@@ -86,13 +86,13 @@
 /*
  * FW creates and saves the SFI tables in memory. When these tables get
  * used, they may need to be mapped to virtual address space, and the mapping
- * can happen before or after the ioremap() is ready, so a flag is needed
+ * can happen before or after the memremap() is ready, so a flag is needed
  * to indicating this
  */
-static u32 sfi_use_ioremap __read_mostly;
+static u32 sfi_use_memremap __read_mostly;
 
 /*
- * sfi_un/map_memory calls early_ioremap/iounmap which is a __init function
+ * sfi_un/map_memory calls early_memremap/memunmap which is a __init function
  * and introduces section mismatch. So use __ref to make it calm.
  */
 static void __iomem * __ref sfi_map_memory(u64 phys, u32 size)
@@ -100,10 +100,10 @@ static void __iomem * __ref sfi_map_memory(u64 phys, u32 size)
 	if (!phys || !size)
 		return NULL;
 
-	if (sfi_use_ioremap)
-		return ioremap_cache(phys, size);
+	if (sfi_use_memremap)
+		return memremap(phys, size, MEMREMAP_WB);
 	else
-		return early_ioremap(phys, size);
+		return early_memremap(phys, size);
 }
 
 static void __ref sfi_unmap_memory(void __iomem *virt, u32 size)
@@ -111,10 +111,10 @@ static void __ref sfi_unmap_memory(void __iomem *virt, u32 size)
 	if (!virt || !size)
 		return;
 
-	if (sfi_use_ioremap)
-		iounmap(virt);
+	if (sfi_use_memremap)
+		memunmap(virt);
 	else
-		early_iounmap(virt, size);
+		early_memunmap(virt, size);
 }
 
 static void sfi_print_table_header(unsigned long long pa,
@@ -507,8 +507,8 @@ void __init sfi_init_late(void)
 	length = syst_va->header.len;
 	sfi_unmap_memory(syst_va, sizeof(struct sfi_table_simple));
 
-	/* Use ioremap now after it is ready */
-	sfi_use_ioremap = 1;
+	/* Use memremap now after it is ready */
+	sfi_use_memremap = 1;
 	syst_va = sfi_map_memory(syst_pa, length);
 
 	sfi_acpi_init();
