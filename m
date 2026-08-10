Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169723385B6;
	Mon, 10 Aug 2026 17:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786383462; cv=none; b=Az6YRvcVcxz0Bs4qqWcWXTZSDNUvHIjlqc2L2h1392mnJ3WyrGNKuJsI/yEnebCn4atacOPVpcLFqnZEGJDwzZqT43X354SDyDnHv0MZlR5k+yUnnsZvi7mVyzSShI/u0nDhrUkb5Sv2QehK4I/FCv2crkWYCrUZ6xozX/ECZ0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786383462; c=relaxed/simple;
	bh=lTTO9OXw5vNLQl5pdoQbMXm3INgyM9+VRXRssH2A4/k=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=H0lmMrbJd3+Gt9dOk7wmD6kokzA5BcteDnIgiNybXdD49Dot+ibCRKRBqJf6Xb23ZA6z25awJMn6UO1TFCDGcX6HgaNMR36a/mrFNHnUnc5jd+KrSE+q6eB7Z3b5CQPC3avaT74Sq0zBu4U+N8NOMKfirw2p+kbQuWAOlWWMoJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O9zHXe+a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O9zHXe+a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DCF11F000E9;
	Mon, 10 Aug 2026 17:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786383460;
	bh=cCkjfXypJR2v+/AHSNaCI4DX4ZfH0QJoQz2XhQgPjXU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=O9zHXe+aARtSwL33CnDRJn0/woco1aLTR1Z2ZIE4QuWj35vrgiuJJdBGrLFraulje
	 Pj0zjNswaahLPJ8+fcpuSwf1M7QXI+6WN1T/AULK0vSdpkRFHOJ6q94FFTW//sAs2g
	 KqgGx3OiiQACXiIIWuRqW1g1m5zIplFu1l3shpgA0BfF85h303+OJicPsB6Uch9i5d
	 W0rdsZf0K8N+CzKUixzQ55JBeoZde4YUOL7zlG+Oh0BbWSFvJqVM7j68dBxuXPZi5V
	 RlPLho30bUzMWJU0F30JghzGH91ALkZkSmbg/2d380nZnV/b9sA9uJx1PEvpS5n7P7
	 bqfmsi1LgKrrQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: George Guo <dongtai.guo@linux.dev>
Cc: chenhuacai@kernel.org,  rppt@kernel.org,  pasha.tatashin@soleen.com,
  pratyush@kernel.org,  shuah@kernel.org,  ardb@kernel.org,
  guodongtai@kylinos.cn,  kernel@xen0n.name,  graf@amazon.com,
  loongarch@lists.linux.dev,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kselftest@vger.kernel.org,  linux-efi@vger.kernel.org,  Kexin Liu
 <liukexin@kylinos.cn>
Subject: Re: [PATCH v4 2/4] LoongArch: kexec: add KHO support
In-Reply-To: <20260807103714.33074-3-dongtai.guo@linux.dev> (George Guo's
	message of "Fri, 7 Aug 2026 18:37:12 +0800")
References: <20260807103714.33074-1-dongtai.guo@linux.dev>
	<20260807103714.33074-3-dongtai.guo@linux.dev>
Date: Mon, 10 Aug 2026 19:37:36 +0200
Message-ID: <2vxzo6f96fmn.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Fri, Aug 07 2026, George Guo wrote:

> From: George Guo <guodongtai@kylinos.cn>
>
> Enable Kexec Handover (KHO) on LoongArch64.
>
> LoongArch has no boot FDT: the efistub passes the EFI system table and
> the command line to the core kernel directly, so the arm64 /chosen path
> (append linux,kho-fdt / linux,kho-scratch and let
> early_init_dt_check_kho() read them) does not apply.  Follow the x86
> model instead, which has no boot FDT either: carry the KHO pointer out of
> band and call kho_populate() directly.  The channel is the EFI
> configuration table entry added by the previous patch.
>
> - Kconfig: ARCH_SUPPORTS_KEXEC_HANDOVER is def_bool 64BIT.
> - machine_kexec_file.c: kho_load_data() builds a small handover blob
>   (struct linux_efi_kho_data) holding the KHO state FDT and scratch
>   addresses, and a new EFI configuration table with a
>   LINUX_EFI_KHO_TABLE_GUID entry pointing to it; both are loaded as kexec
>   segments.
> - machine_kexec.c: before jumping to the next kernel, switch the EFI
>   system table to the extended configuration table.
> - setup.c: kho_populate_from_efi() scans the configuration table for
>   LINUX_EFI_KHO_TABLE_GUID and calls kho_populate() from setup_arch(),
>   after efi_init() and before memblock_init().
>
> Handover is set up by the kexec_file_load() syscall only.  kho_load_data()
> runs from load_other_segments(), which the older kexec_load() syscall does
> not reach.  This matches x86, where KHO lives in the bzImage64 loader.
>
> Tested on a LoongArch machine booting through ACPI/UEFI.  After the kexec,
> the second kernel reports
>
>   KHO: found kexec handover data.
>
> and the two-stage test passes: luo_kexec_simple --stage 1, kexec into the
> second kernel, then luo_kexec_simple --stage 2.
>
> Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
> Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
> Signed-off-by: George Guo <guodongtai@kylinos.cn>
[...]
> @@ -55,6 +64,121 @@ static void cmdline_add_initrd(struct kimage *image, unsigned long *cmdline_tmpl
>  	*cmdline_tmplen += initrd_strlen;
>  }
>  
> +#ifdef CONFIG_KEXEC_HANDOVER
> +/*
> + * Hand the KHO state to the next kernel through a dedicated EFI configuration
> + * table entry.
> + *
> + * LoongArch has no boot FDT: the efistub passes the EFI system table and the
> + * command line to the core kernel directly.  So instead of the arm64 /chosen
> + * FDT path, build a small handover blob (struct linux_efi_kho_data) holding the
> + * KHO state FDT and scratch addresses, register it in the EFI configuration
> + * table under LINUX_EFI_KHO_TABLE_GUID, and let the next kernel read it and
> + * call kho_populate() directly.
> + *
> + * Both the blob and the extended configuration table are loaded as kexec
> + * segments; machine_kexec() switches st->tables to the new table before jumping.
> + *
> + * image->kho.fdt and image->kho.scratch are filled in by kho_fill_kimage()
> + * before the arch loader runs, so they are valid here.
> + */
> +static int kho_load_data(struct kimage *image)
> +{
> +	struct linux_efi_kho_data *kho;
> +	efi_system_table_t *st;
> +	efi_config_table_t *ct, *new_ct;
> +	size_t old_sz, new_sz;
> +	struct kexec_buf kbuf = {
> +		.image		= image,
> +		.buf_min	= 0,
> +		.buf_max	= ULONG_MAX,
> +		.top_down	= true,
> +	};
> +	int ret;
> +
> +	if (!image->kho.fdt || !image->kho.scratch)
> +		return 0;
> +
> +	if (!fw_arg2) {
> +		pr_err("KHO requires an EFI boot, no EFI system table found\n");
> +		return -EINVAL;
> +	}
> +
> +	/* Build the handover blob and load it as a kexec segment. */
> +	kho = kzalloc(sizeof(*kho), GFP_KERNEL);
> +	if (!kho)
> +		return -ENOMEM;
> +
> +	kho->fdt_addr     = image->kho.fdt;
> +	kho->fdt_size     = PAGE_SIZE;
> +	kho->scratch_addr = image->kho.scratch->mem;
> +	kho->scratch_size = image->kho.scratch->memsz;
> +
> +	kbuf.buffer	= kho;
> +	kbuf.bufsz	= sizeof(*kho);
> +	kbuf.memsz	= sizeof(*kho);
> +	kbuf.buf_align	= sizeof(u64);
> +	kbuf.mem	= KEXEC_BUF_MEM_UNKNOWN;
> +
> +	ret = kexec_add_buffer(&kbuf);
> +	if (ret) {
> +		kfree(kho);
> +		return ret;
> +	}
> +	image->arch.kho_data	 = kho;
> +	image->arch.kho_data_mem = kbuf.mem;
> +
> +	kexec_dprintk("Loaded KHO handover blob at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
> +		      image->arch.kho_data_mem, kbuf.bufsz, kbuf.memsz);
> +	kexec_dprintk("KHO fdt at 0x%llx, scratch at 0x%llx size 0x%llx\n",
> +		      kho->fdt_addr, kho->scratch_addr, kho->scratch_size);
> +
> +	/*
> +	 * Build a new EFI configuration table with a LINUX_EFI_KHO_TABLE_GUID
> +	 * entry appended, pointing at the handover blob, and load it as a kexec
> +	 * segment.  machine_kexec() updates st->tables / st->nr_tables to point
> +	 * to it before jumping.
> +	 *
> +	 * fw_arg2 is the EFI system table physical address passed by the
> +	 * firmware/bootloader.  Use it directly because image->arch.systable_ptr
> +	 * is set later in machine_kexec_prepare(), which runs after this.
> +	 */

This looks wrong. I don't think you should be modifying the EFI
configuration table in this way. You also should have this in
architecture-agnostic code.

I'm not an EFI expert, but I took a look at how the other Linux-specific
tables work. I picked LINUX_EFI_MEMRESERVE_TABLE_GUID as my example. The
table is allocated and installed from the EFI stub (see
install_memreserve_table()). Then efi_memreserve_map_root() maps the
table and it is used by efi_mem_reserve_persistent().

You should do something similar. Allocate and install the table from the
stub, and then just update it on kexec. This would also let other
architectures use this GUID without having to reinvent this again.

> +	st = (efi_system_table_t *)TO_CACHE(fw_arg2);
> +	ct = (efi_config_table_t *)TO_CACHE((unsigned long)st->tables);
> +	old_sz = st->nr_tables * sizeof(efi_config_table_t);
> +	new_sz = old_sz + sizeof(efi_config_table_t);
> +
> +	new_ct = kvmalloc(new_sz, GFP_KERNEL);
> +	if (!new_ct)
> +		return -ENOMEM;
> +
> +	memcpy(new_ct, ct, old_sz);
> +	new_ct[st->nr_tables].guid  = LINUX_EFI_KHO_TABLE_GUID;
> +	new_ct[st->nr_tables].table = (void *)image->arch.kho_data_mem;
> +
> +	kbuf.buffer	= new_ct;
> +	kbuf.bufsz	= new_sz;
> +	kbuf.memsz	= new_sz;
> +	kbuf.buf_align	= sizeof(void *);
> +	kbuf.mem	= KEXEC_BUF_MEM_UNKNOWN;
> +
> +	ret = kexec_add_buffer(&kbuf);
> +	if (ret) {
> +		kvfree(new_ct);
> +		return ret;
> +	}
> +	image->arch.efi_tables	   = new_ct;
> +	image->arch.efi_tables_mem = kbuf.mem;
> +	image->arch.efi_tables_cnt = st->nr_tables + 1;
> +
> +	kexec_dprintk("Loaded EFI config table at 0x%lx bufsz=0x%lx memsz=0x%lx nr_tables=%lu\n",
> +		      image->arch.efi_tables_mem, kbuf.bufsz, kbuf.memsz,
> +		      image->arch.efi_tables_cnt);
> +
> +	return 0;
> +}
> +#endif
> +
>  #ifdef CONFIG_CRASH_DUMP
>  
>  static int prepare_elf_headers(void **addr, unsigned long *sz)
> @@ -220,6 +344,13 @@ int load_other_segments(struct kimage *image,
>  		cmdline_add_initrd(image, &cmdline_tmplen, modified_cmdline, initrd_load_addr);
>  	}
>  
> +#ifdef CONFIG_KEXEC_HANDOVER
> +	/* Load the KHO handover blob and the extended EFI configuration table */
> +	ret = kho_load_data(image);
> +	if (ret)
> +		goto out_err;
> +#endif
> +
>  	if (cmdline_len + cmdline_tmplen > COMMAND_LINE_SIZE) {
>  		pr_err("Appending command line exceeds COMMAND_LINE_SIZE\n");
>  		ret = -EINVAL;
[...]

-- 
Regards,
Pratyush Yadav
