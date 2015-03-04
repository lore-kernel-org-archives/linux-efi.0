From: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 12/15] x86: kill not used setup_data handling code
Date: Wed,  4 Mar 2015 00:00:45 -0800
Message-ID: <1425456048-16236-13-git-send-email-yinghai@kernel.org>
References: <1425456048-16236-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1425456048-16236-1-git-send-email-yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 arch/x86/kernel/kdebugfs.c | 142 ---------------------------------------------
 arch/x86/kernel/setup.c    |  17 ------
 2 files changed, 159 deletions(-)

diff --git a/arch/x86/kernel/kdebugfs.c b/arch/x86/kernel/kdebugfs.c
index dc1404b..c8ca86c 100644
--- a/arch/x86/kernel/kdebugfs.c
+++ b/arch/x86/kernel/kdebugfs.c
@@ -21,142 +21,6 @@ struct dentry *arch_debugfs_dir;
 EXPORT_SYMBOL(arch_debugfs_dir);
 
 #ifdef CONFIG_DEBUG_BOOT_PARAMS
-struct setup_data_node {
-	u64 paddr;
-	u32 type;
-	u32 len;
-};
-
-static ssize_t setup_data_read(struct file *file, char __user *user_buf,
-			       size_t count, loff_t *ppos)
-{
-	struct setup_data_node *node = file->private_data;
-	unsigned long remain;
-	loff_t pos = *ppos;
-	struct page *pg;
-	void *p;
-	u64 pa;
-
-	if (pos < 0)
-		return -EINVAL;
-
-	if (pos >= node->len)
-		return 0;
-
-	if (count > node->len - pos)
-		count = node->len - pos;
-
-	pa = node->paddr + sizeof(struct setup_data) + pos;
-	pg = pfn_to_page((pa + count - 1) >> PAGE_SHIFT);
-	if (PageHighMem(pg)) {
-		p = ioremap_cache(pa, count);
-		if (!p)
-			return -ENXIO;
-	} else
-		p = __va(pa);
-
-	remain = copy_to_user(user_buf, p, count);
-
-	if (PageHighMem(pg))
-		iounmap(p);
-
-	if (remain)
-		return -EFAULT;
-
-	*ppos = pos + count;
-
-	return count;
-}
-
-static const struct file_operations fops_setup_data = {
-	.read		= setup_data_read,
-	.open		= simple_open,
-	.llseek		= default_llseek,
-};
-
-static int __init
-create_setup_data_node(struct dentry *parent, int no,
-		       struct setup_data_node *node)
-{
-	struct dentry *d, *type, *data;
-	char buf[16];
-
-	sprintf(buf, "%d", no);
-	d = debugfs_create_dir(buf, parent);
-	if (!d)
-		return -ENOMEM;
-
-	type = debugfs_create_x32("type", S_IRUGO, d, &node->type);
-	if (!type)
-		goto err_dir;
-
-	data = debugfs_create_file("data", S_IRUGO, d, node, &fops_setup_data);
-	if (!data)
-		goto err_type;
-
-	return 0;
-
-err_type:
-	debugfs_remove(type);
-err_dir:
-	debugfs_remove(d);
-	return -ENOMEM;
-}
-
-static int __init create_setup_data_nodes(struct dentry *parent)
-{
-	struct setup_data_node *node;
-	struct setup_data *data;
-	int error;
-	struct dentry *d;
-	struct page *pg;
-	u64 pa_data;
-	int no = 0;
-
-	d = debugfs_create_dir("setup_data", parent);
-	if (!d)
-		return -ENOMEM;
-
-	pa_data = boot_params.hdr.setup_data;
-
-	while (pa_data) {
-		node = kmalloc(sizeof(*node), GFP_KERNEL);
-		if (!node) {
-			error = -ENOMEM;
-			goto err_dir;
-		}
-
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
-
-		node->paddr = pa_data;
-		node->type = data->type;
-		node->len = data->len;
-		error = create_setup_data_node(d, no, node);
-		pa_data = data->next;
-
-		if (PageHighMem(pg))
-			iounmap(data);
-		if (error)
-			goto err_dir;
-		no++;
-	}
-
-	return 0;
-
-err_dir:
-	debugfs_remove(d);
-	return error;
-}
-
 static struct debugfs_blob_wrapper boot_params_blob = {
 	.data		= &boot_params,
 	.size		= sizeof(boot_params),
@@ -181,14 +45,8 @@ static int __init boot_params_kdebugfs_init(void)
 	if (!data)
 		goto err_version;
 
-	error = create_setup_data_nodes(dbp);
-	if (error)
-		goto err_data;
-
 	return 0;
 
-err_data:
-	debugfs_remove(data);
 err_version:
 	debugfs_remove(version);
 err_dir:
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index b1296d3..9a18078 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -481,20 +481,6 @@ static void __init parse_setup_data(void)
 	boot_params.hdr.setup_data = 0; /* all done */
 }
 
-static void __init memblock_x86_reserve_range_setup_data(void)
-{
-	struct setup_data *data;
-	u64 pa_data;
-
-	pa_data = boot_params.hdr.setup_data;
-	while (pa_data) {
-		data = early_memremap(pa_data, sizeof(*data));
-		memblock_reserve(pa_data, sizeof(*data) + data->len);
-		pa_data = data->next;
-		early_iounmap(data, sizeof(*data));
-	}
-}
-
 /*
  * --------- Crashkernel reservation ------------------------------
  */
@@ -1001,9 +987,6 @@ void __init setup_arch(char **cmdline_p)
 
 	x86_report_nx();
 
-	/* after early param, so could get panic from serial */
-	memblock_x86_reserve_range_setup_data();
-
 	if (acpi_mps_check()) {
 #ifdef CONFIG_X86_LOCAL_APIC
 		disable_apic = 1;
-- 
1.8.4.5
