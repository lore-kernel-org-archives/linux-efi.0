From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efi: Add esrt support.
Date: Thu, 15 Jan 2015 21:25:55 +0000
Message-ID: <20150115212555.GC12079@codeblueprint.co.uk>
References: <20150112130332.GG26589@codeblueprint.co.uk>
 <1421070174-27513-1-git-send-email-pjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1421070174-27513-1-git-send-email-pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 12 Jan, at 08:42:54AM, Peter Jones wrote:
> Add sysfs files for the EFI System Resource Table (ESRT) under
> /sys/firmware/efi/esrt and for each EFI System Resource Entry under
> entries/ as a subdir.
> 
> The EFI System Resource Table (ESRT) provides a read-only catalog of
> system components for which the system accepts firmware upgrades via
> UEFI's "Capsule Update" feature.  This module allows userland utilities
> to evaluate what firmware updates can be applied to this system, and
> potentially arrange for those updates to occur.
> 
> The ESRT is described as part of the UEFI specification, in version 2.5
> which should be available from http://uefi.org/specifications in early
> 2015.  If you're a member of the UEFI Forum, information about its
> addition to the standard is available as UEFI Mantis 1090.
> 
> For some hardware platforms, additional restrictions may be found at
> http://msdn.microsoft.com/en-us/library/windows/hardware/jj128256.aspx ,
> and additional documentation may be found at
> http://download.microsoft.com/download/5/F/5/5F5D16CD-2530-4289-8019-94C6A20BED3C/windows-uefi-firmware-update-platform.docx
> .
> 
> Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/firmware/efi/Makefile |   2 +-
>  drivers/firmware/efi/efi.c    |  63 ++++++-
>  drivers/firmware/efi/esrt.c   | 402 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/efi.h           |   7 +
>  4 files changed, 472 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/firmware/efi/esrt.c

[...]

> +/*
> + * ioremap the table, copy it to kmalloced pages, and unmap it.
> + */
> +static int esrt_duplicate_pages(void)
> +{
> +	struct efi_system_resource_table *tmpesrt;
> +	struct efi_system_resource_entry *entries;
> +	size_t size, max;
> +	efi_memory_desc_t md;
> +	int err = -EINVAL;
> +	int rc;
> +
> +	if (!esrt_table_exists())
> +		return err;
> +
> +	rc = efi_mem_desc_lookup(efi.esrt, &md);
> +	if (rc < 0) {
> +		pr_err("ESRT header is not in the memory map.\n");
> +		return err;

Probably wanna return 'rc' here? Since efi_mem_desc_lookup() now may
return -ENOENT or -EINVAL on failure.

> +	}
> +
> +	max = efi_mem_desc_end(&md);
> +	if (max < 0) {
> +		pr_err("EFI memory descriptor is invalid.\n");
> +		return err;
> +	}
> +
> +	size = sizeof(*esrt);
> +
> +	if (max < size) {
> +		pr_err("ESRT header doen't fit on single memory map entry.\n");
> +		return err;
> +	}

This doesn't look right. You're comparing an address 'max' and a size
'size'. Unless we have memory descriptors at address 0x0, this condition
will never be false.

> +
> +	tmpesrt = ioremap(efi.esrt, size);
> +	if (!tmpesrt) {
> +		pr_err("ioremap failed.\n");
> +		return -ENOMEM;
> +	}
> +
> +	if (tmpesrt->fw_resource_count > 0 && max - size < sizeof(*entries)) {
> +		pr_err("ESRT memory map entry can only hold the header.\n");
> +		goto err_iounmap;
> +	}

Ditto. Is this ever going to be false?

> +	/*
> +	 * The format doesn't really give us any boundary to test here,
> +	 * so I'm making up 128 as the max number of individually updatable
> +	 * components we support.
> +	 * 128 should be pretty excessive, but there's still some chance
> +	 * somebody will do that someday and we'll need to raise this.
> +	 */
> +	if (tmpesrt->fw_resource_count > 128) {
> +		pr_err("ESRT says fw_resource_count has very large value %d.\n",
> +		       tmpesrt->fw_resource_count);
> +		goto err_iounmap;
> +	}
> +
> +	/*
> +	 * We know it can't be larger than N * sizeof() here, and N is limited
> +	 * by the previous test to a small number, so there's no overflow.
> +	 */
> +	size += tmpesrt->fw_resource_count * sizeof(*entries);
> +	if (max < size) {
> +		pr_err("ESRT does not fit on single memory map entry.\n");
> +		goto err_iounmap;
> +	}

Ditto^2

> +	esrt = kmalloc(size, GFP_KERNEL);
> +	if (!esrt) {
> +		err = -ENOMEM;
> +		goto err_iounmap;
> +	}
> +
> +	memcpy(esrt, tmpesrt, size);
> +	err = 0;
> +err_iounmap:
> +	iounmap(tmpesrt);
> +	return err;
> +}
> +
> +static int register_entries(void)
> +{
> +	struct efi_system_resource_entry *entries = esrt->entries;
> +	int i, rc;
> +
> +	if (!esrt_table_exists())
> +		return 0;
> +
> +	for (i = 0; i < le32_to_cpu(esrt->fw_resource_count); i++) {

This caught my eye. Do any of the architectures with UEFI support
running in big endian mode?

-- 
Matt Fleming, Intel Open Source Technology Center
