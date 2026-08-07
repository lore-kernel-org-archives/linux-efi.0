Received: from out-182.mta1.migadu.com (mta1.migadu.com [37.59.57.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216063BF67A
	for <linux-efi@vger.kernel.org>; Fri,  7 Aug 2026 10:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.59.57.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786099133; cv=none; b=RP6r6UVmRm1D+6x7gHTJs+itWd9B00cG5+MVLQRxlHmULuI8IHPth97MM+78+Y/e9pNkuzwr46P5tLAYGOP4GhVU1kV7irBHFfZRcT9JnmnM8mE7qELbNmHY2u0IOItj+XqdfAV+e+P5WXopVXEwCLfkfvT9J5utj8mhMDtHE8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786099133; c=relaxed/simple;
	bh=k+Fcen4MYcZyNNi1i9NYfUKJmyV3iEObVy5P5Juo1cQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OwMRa63rauQYClBuruPh9UYy/4j4VHA6bf6bRDYMOwoR0MSDd4kdFLuVi5DVbc1X5mljyJS/0PlsYSgMc2xWGF6hPrmV+2BeKZSQqcpFF7NYoYFdFqTslcBHSpxoVXwBHJbGt7s52nP/3pqGt8DJt6NzcaqJ12XqVOxpP2Njbdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XELU+/Ps; arc=none smtp.client-ip=37.59.57.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XELU+/Ps"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786099127;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2//MdYBzQ2M55gfAcjDDNKMmJ4XWZ+o7gw3/S2yli2o=;
	b=XELU+/Ps0KysLZGkSe2/XepKTlyG2/Iw6LTmp9rcJetE5z4NuL6subolc2tDA9kFIpeT7F
	vL6zJzuLfQPDvYJCb2VFS5QzbR//eU8xCa7E3itPrKDMJHv1TB6fwxQ9aJWT5VBF4L5YHu
	UmXCnkNRVzonuzpaD0bwJ+z0PwN+GgY=
From: George Guo <dongtai.guo@linux.dev>
To: chenhuacai@kernel.org,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	shuah@kernel.org,
	ardb@kernel.org
Cc: guodongtai@kylinos.cn,
	kernel@xen0n.name,
	graf@amazon.com,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-efi@vger.kernel.org,
	Kexin Liu <liukexin@kylinos.cn>
Subject: [PATCH v4 2/4] LoongArch: kexec: add KHO support
Date: Fri,  7 Aug 2026 18:37:12 +0800
Message-ID: <20260807103714.33074-3-dongtai.guo@linux.dev>
In-Reply-To: <20260807103714.33074-1-dongtai.guo@linux.dev>
References: <20260807103714.33074-1-dongtai.guo@linux.dev>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: George Guo <guodongtai@kylinos.cn>

Enable Kexec Handover (KHO) on LoongArch64.

LoongArch has no boot FDT: the efistub passes the EFI system table and
the command line to the core kernel directly, so the arm64 /chosen path
(append linux,kho-fdt / linux,kho-scratch and let
early_init_dt_check_kho() read them) does not apply.  Follow the x86
model instead, which has no boot FDT either: carry the KHO pointer out of
band and call kho_populate() directly.  The channel is the EFI
configuration table entry added by the previous patch.

- Kconfig: ARCH_SUPPORTS_KEXEC_HANDOVER is def_bool 64BIT.
- machine_kexec_file.c: kho_load_data() builds a small handover blob
  (struct linux_efi_kho_data) holding the KHO state FDT and scratch
  addresses, and a new EFI configuration table with a
  LINUX_EFI_KHO_TABLE_GUID entry pointing to it; both are loaded as kexec
  segments.
- machine_kexec.c: before jumping to the next kernel, switch the EFI
  system table to the extended configuration table.
- setup.c: kho_populate_from_efi() scans the configuration table for
  LINUX_EFI_KHO_TABLE_GUID and calls kho_populate() from setup_arch(),
  after efi_init() and before memblock_init().

Handover is set up by the kexec_file_load() syscall only.  kho_load_data()
runs from load_other_segments(), which the older kexec_load() syscall does
not reach.  This matches x86, where KHO lives in the bzImage64 loader.

Tested on a LoongArch machine booting through ACPI/UEFI.  After the kexec,
the second kernel reports

  KHO: found kexec handover data.

and the two-stage test passes: luo_kexec_simple --stage 1, kexec into the
second kernel, then luo_kexec_simple --stage 2.

Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: George Guo <guodongtai@kylinos.cn>
---
 arch/loongarch/Kconfig                     |   3 +
 arch/loongarch/include/asm/kexec.h         |   7 ++
 arch/loongarch/kernel/machine_kexec.c      |  16 +++
 arch/loongarch/kernel/machine_kexec_file.c | 131 +++++++++++++++++++++
 arch/loongarch/kernel/setup.c              |  41 +++++++
 5 files changed, 198 insertions(+)

diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index d8d252325017..698828ef70f0 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -684,6 +684,9 @@ config ARCH_SUPPORTS_KEXEC
 config ARCH_SUPPORTS_KEXEC_FILE
 	def_bool 64BIT
 
+config ARCH_SUPPORTS_KEXEC_HANDOVER
+	def_bool 64BIT
+
 config ARCH_SELECTS_KEXEC_FILE
 	def_bool 64BIT
 	depends on KEXEC_FILE
diff --git a/arch/loongarch/include/asm/kexec.h b/arch/loongarch/include/asm/kexec.h
index 6be136e9f0a0..2bcc8bc0d3cc 100644
--- a/arch/loongarch/include/asm/kexec.h
+++ b/arch/loongarch/include/asm/kexec.h
@@ -39,6 +39,13 @@ struct kimage_arch {
 	unsigned long efi_boot;
 	unsigned long cmdline_ptr;
 	unsigned long systable_ptr;
+#ifdef CONFIG_KEXEC_HANDOVER
+	void *kho_data;			/* KHO handover blob buffer (virtual) */
+	unsigned long kho_data_mem;	/* physical address of the KHO handover blob */
+	void *efi_tables;		/* new EFI config table buffer (virtual) */
+	unsigned long efi_tables_mem;	/* physical address of new EFI config table */
+	unsigned long efi_tables_cnt;	/* number of entries in new EFI config table */
+#endif
 };
 
 struct kimage;
diff --git a/arch/loongarch/kernel/machine_kexec.c b/arch/loongarch/kernel/machine_kexec.c
index 1883cae93bc3..c98a5607684d 100644
--- a/arch/loongarch/kernel/machine_kexec.c
+++ b/arch/loongarch/kernel/machine_kexec.c
@@ -6,6 +6,7 @@
  */
 #include <linux/compiler.h>
 #include <linux/cpu.h>
+#include <linux/efi.h>
 #include <linux/kexec.h>
 #include <linux/crash_dump.h>
 #include <linux/delay.h>
@@ -287,6 +288,21 @@ void machine_kexec(struct kimage *image)
 	pr_notice("We will call new kernel at 0x%lx\n", start_addr);
 	pr_notice("Bye ...\n");
 
+#ifdef CONFIG_KEXEC_HANDOVER
+	/*
+	 * KHO: switch the EFI system table to the extended configuration table
+	 * built in kho_load_data(), which carries the LINUX_EFI_KHO_TABLE_GUID
+	 * entry the next kernel reads to find the KHO handover blob.
+	 */
+	if (internal->efi_tables_mem) {
+		efi_system_table_t *st =
+			(efi_system_table_t *)TO_CACHE(systable_ptr);
+
+		st->tables    = internal->efi_tables_mem;
+		st->nr_tables = internal->efi_tables_cnt;
+	}
+#endif
+
 	/* Make reboot code buffer available to the boot CPU. */
 	flush_cache_all();
 
diff --git a/arch/loongarch/kernel/machine_kexec_file.c b/arch/loongarch/kernel/machine_kexec_file.c
index 5584b798ba46..d4c2243b6cb0 100644
--- a/arch/loongarch/kernel/machine_kexec_file.c
+++ b/arch/loongarch/kernel/machine_kexec_file.c
@@ -10,6 +10,7 @@
 
 #define pr_fmt(fmt) "kexec_file: " fmt
 
+#include <linux/efi.h>
 #include <linux/ioport.h>
 #include <linux/kernel.h>
 #include <linux/kexec.h>
@@ -18,6 +19,7 @@
 #include <linux/string.h>
 #include <linux/types.h>
 #include <linux/vmalloc.h>
+#include <asm/addrspace.h>
 #include <asm/bootinfo.h>
 
 const struct kexec_file_ops * const kexec_file_loaders[] = {
@@ -32,6 +34,13 @@ int arch_kimage_file_post_load_cleanup(struct kimage *image)
 	image->elf_headers = NULL;
 	image->elf_headers_sz = 0;
 
+#ifdef CONFIG_KEXEC_HANDOVER
+	kfree(image->arch.kho_data);
+	image->arch.kho_data = NULL;
+	kvfree(image->arch.efi_tables);
+	image->arch.efi_tables = NULL;
+#endif
+
 	return kexec_image_post_load_cleanup_default(image);
 }
 
@@ -55,6 +64,121 @@ static void cmdline_add_initrd(struct kimage *image, unsigned long *cmdline_tmpl
 	*cmdline_tmplen += initrd_strlen;
 }
 
+#ifdef CONFIG_KEXEC_HANDOVER
+/*
+ * Hand the KHO state to the next kernel through a dedicated EFI configuration
+ * table entry.
+ *
+ * LoongArch has no boot FDT: the efistub passes the EFI system table and the
+ * command line to the core kernel directly.  So instead of the arm64 /chosen
+ * FDT path, build a small handover blob (struct linux_efi_kho_data) holding the
+ * KHO state FDT and scratch addresses, register it in the EFI configuration
+ * table under LINUX_EFI_KHO_TABLE_GUID, and let the next kernel read it and
+ * call kho_populate() directly.
+ *
+ * Both the blob and the extended configuration table are loaded as kexec
+ * segments; machine_kexec() switches st->tables to the new table before jumping.
+ *
+ * image->kho.fdt and image->kho.scratch are filled in by kho_fill_kimage()
+ * before the arch loader runs, so they are valid here.
+ */
+static int kho_load_data(struct kimage *image)
+{
+	struct linux_efi_kho_data *kho;
+	efi_system_table_t *st;
+	efi_config_table_t *ct, *new_ct;
+	size_t old_sz, new_sz;
+	struct kexec_buf kbuf = {
+		.image		= image,
+		.buf_min	= 0,
+		.buf_max	= ULONG_MAX,
+		.top_down	= true,
+	};
+	int ret;
+
+	if (!image->kho.fdt || !image->kho.scratch)
+		return 0;
+
+	if (!fw_arg2) {
+		pr_err("KHO requires an EFI boot, no EFI system table found\n");
+		return -EINVAL;
+	}
+
+	/* Build the handover blob and load it as a kexec segment. */
+	kho = kzalloc(sizeof(*kho), GFP_KERNEL);
+	if (!kho)
+		return -ENOMEM;
+
+	kho->fdt_addr     = image->kho.fdt;
+	kho->fdt_size     = PAGE_SIZE;
+	kho->scratch_addr = image->kho.scratch->mem;
+	kho->scratch_size = image->kho.scratch->memsz;
+
+	kbuf.buffer	= kho;
+	kbuf.bufsz	= sizeof(*kho);
+	kbuf.memsz	= sizeof(*kho);
+	kbuf.buf_align	= sizeof(u64);
+	kbuf.mem	= KEXEC_BUF_MEM_UNKNOWN;
+
+	ret = kexec_add_buffer(&kbuf);
+	if (ret) {
+		kfree(kho);
+		return ret;
+	}
+	image->arch.kho_data	 = kho;
+	image->arch.kho_data_mem = kbuf.mem;
+
+	kexec_dprintk("Loaded KHO handover blob at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
+		      image->arch.kho_data_mem, kbuf.bufsz, kbuf.memsz);
+	kexec_dprintk("KHO fdt at 0x%llx, scratch at 0x%llx size 0x%llx\n",
+		      kho->fdt_addr, kho->scratch_addr, kho->scratch_size);
+
+	/*
+	 * Build a new EFI configuration table with a LINUX_EFI_KHO_TABLE_GUID
+	 * entry appended, pointing at the handover blob, and load it as a kexec
+	 * segment.  machine_kexec() updates st->tables / st->nr_tables to point
+	 * to it before jumping.
+	 *
+	 * fw_arg2 is the EFI system table physical address passed by the
+	 * firmware/bootloader.  Use it directly because image->arch.systable_ptr
+	 * is set later in machine_kexec_prepare(), which runs after this.
+	 */
+	st = (efi_system_table_t *)TO_CACHE(fw_arg2);
+	ct = (efi_config_table_t *)TO_CACHE((unsigned long)st->tables);
+	old_sz = st->nr_tables * sizeof(efi_config_table_t);
+	new_sz = old_sz + sizeof(efi_config_table_t);
+
+	new_ct = kvmalloc(new_sz, GFP_KERNEL);
+	if (!new_ct)
+		return -ENOMEM;
+
+	memcpy(new_ct, ct, old_sz);
+	new_ct[st->nr_tables].guid  = LINUX_EFI_KHO_TABLE_GUID;
+	new_ct[st->nr_tables].table = (void *)image->arch.kho_data_mem;
+
+	kbuf.buffer	= new_ct;
+	kbuf.bufsz	= new_sz;
+	kbuf.memsz	= new_sz;
+	kbuf.buf_align	= sizeof(void *);
+	kbuf.mem	= KEXEC_BUF_MEM_UNKNOWN;
+
+	ret = kexec_add_buffer(&kbuf);
+	if (ret) {
+		kvfree(new_ct);
+		return ret;
+	}
+	image->arch.efi_tables	   = new_ct;
+	image->arch.efi_tables_mem = kbuf.mem;
+	image->arch.efi_tables_cnt = st->nr_tables + 1;
+
+	kexec_dprintk("Loaded EFI config table at 0x%lx bufsz=0x%lx memsz=0x%lx nr_tables=%lu\n",
+		      image->arch.efi_tables_mem, kbuf.bufsz, kbuf.memsz,
+		      image->arch.efi_tables_cnt);
+
+	return 0;
+}
+#endif
+
 #ifdef CONFIG_CRASH_DUMP
 
 static int prepare_elf_headers(void **addr, unsigned long *sz)
@@ -220,6 +344,13 @@ int load_other_segments(struct kimage *image,
 		cmdline_add_initrd(image, &cmdline_tmplen, modified_cmdline, initrd_load_addr);
 	}
 
+#ifdef CONFIG_KEXEC_HANDOVER
+	/* Load the KHO handover blob and the extended EFI configuration table */
+	ret = kho_load_data(image);
+	if (ret)
+		goto out_err;
+#endif
+
 	if (cmdline_len + cmdline_tmplen > COMMAND_LINE_SIZE) {
 		pr_err("Appending command line exceeds COMMAND_LINE_SIZE\n");
 		ret = -EINVAL;
diff --git a/arch/loongarch/kernel/setup.c b/arch/loongarch/kernel/setup.c
index 6fa4a22a58fd..1e2fbf37aecf 100644
--- a/arch/loongarch/kernel/setup.c
+++ b/arch/loongarch/kernel/setup.c
@@ -20,6 +20,7 @@
 #include <linux/initrd.h>
 #include <linux/ioport.h>
 #include <linux/kexec.h>
+#include <linux/kexec_handover.h>
 #include <linux/crash_dump.h>
 #include <linux/root_dev.h>
 #include <linux/console.h>
@@ -280,6 +281,45 @@ static void __init arch_reserve_crashkernel(void)
 	reserve_crashkernel_generic(crash_size, crash_base, low_size, high);
 }
 
+#ifdef CONFIG_KEXEC_HANDOVER
+/*
+ * On a KHO kexec boot the previous kernel registered a handover blob in the EFI
+ * configuration table under LINUX_EFI_KHO_TABLE_GUID (see
+ * arch/loongarch/kernel/machine_kexec_file.c).  Scan the configuration table
+ * for it, read the KHO state FDT and scratch addresses, and hand them to the
+ * KHO core.  fw_arg2 is the EFI system table physical address.
+ *
+ * This runs from setup_arch(), after efi_init() and before memblock_init(),
+ * which is where the generic reader early_init_dt_check_kho() would call
+ * kho_populate().
+ */
+static void __init kho_populate_from_efi(void)
+{
+	efi_system_table_t *st;
+	efi_config_table_t *ct;
+	struct linux_efi_kho_data *kho;
+	unsigned long i;
+
+	if (!fw_arg2)
+		return;
+
+	st = (efi_system_table_t *)TO_CACHE(fw_arg2);
+	ct = (efi_config_table_t *)TO_CACHE((unsigned long)st->tables);
+
+	for (i = 0; i < st->nr_tables; i++) {
+		if (efi_guidcmp(ct[i].guid, LINUX_EFI_KHO_TABLE_GUID))
+			continue;
+
+		kho = (struct linux_efi_kho_data *)TO_CACHE((unsigned long)ct[i].table);
+		kho_populate(kho->fdt_addr, kho->fdt_size,
+			     kho->scratch_addr, kho->scratch_size);
+		break;
+	}
+}
+#else
+static void __init kho_populate_from_efi(void) { }
+#endif
+
 static void __init fdt_setup(void)
 {
 #ifdef CONFIG_OF_EARLY_FLATTREE
@@ -599,6 +639,7 @@ void __init setup_arch(char **cmdline_p)
 
 	init_environ();
 	efi_init();
+	kho_populate_from_efi();
 	fdt_setup();
 	memblock_init();
 	pagetable_init();
-- 
2.53.0

