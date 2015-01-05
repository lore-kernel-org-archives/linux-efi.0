From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [RFC PATCH] Add esrt support.
Date: Mon, 5 Jan 2015 13:51:13 +0000
Message-ID: <20150105135113.GA3163@console-pimps.org>
References: <20141211202119.GG17171@fenchurch.internal.datastacks.com>
 <1418329324-8975-1-git-send-email-pjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1418329324-8975-1-git-send-email-pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 11 Dec, at 03:22:04PM, Peter Jones wrote:
> Add sysfs files for EFI System Resource Table under
> /sys/firmware/efi/esrt and for each EFI System Resource Entry under
> entries/ as a subdir.
> 
> v2 with suggestions from bpetkov.
> v3 with me remembering checkpatch.
> v4 without me typing struct decls completely wrong somehow.
> 
> Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/firmware/efi/Makefile |   2 +-
>  drivers/firmware/efi/efi.c    |  46 ++++-
>  drivers/firmware/efi/esrt.c   | 393 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/efi.h           |   6 +
>  4 files changed, 445 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/firmware/efi/esrt.c
 
When this patch moves out of RFC I'd ideally like to see a much more
expansive commit message.

Why do we want this functionality, what's it going to be used for? What
does the patch actaully do?  Where can we go looking for more
information about ERST? You'll probably end up copying and pasting
things from the top of erst.c, but that's fine.

> @@ -220,6 +223,46 @@ err_put:
>  
>  subsys_initcall(efisubsys_init);
>  
> +/*
> + * Given a physicall address, determine if it exists within an EFI Memory Map
> + * entry, and if so, how much of that map exists at a higher address.  That
> + * is, if this is the address of something in an EFI map, what's the highest
> + * address at which it's likely to end.
> + */
> +u64 efi_mem_max_reasonable_size(u64 phys_addr)

Confused. I think I know what you're saying here, but I'm also doing a
fair bit of a guesswork.

Instead, how about,

extern struct efi_memory_desc_t *efi_mem_desc_lookup(u64 phys_addr);

/*
 * Return the end physical address of a EFI memory map region
 */
static inline u64 efi_mem_desc_end(struct efi_memory_desc_t *md)
{
	u64 size = md->num_pages << EFI_PAGE_SHIFT;

	return md->phys_addr + size;
}

The caller can then do,

	md = efi_mem_desc_lookup(phys_addr)
	if (!md)
		return -1;

	bytes = efi_mem_desc_end(md) - phys_addr;
	ioremap(phys_addr, bytes);

I think leaving this "remaining bytes" logic in the ioremap() caller is
the most robust solution because it's a quirky thing to want to do,
whereas the other functions (efi_mem_desc_lookup() and
efi_mem_desc_end()) are more general.

Thoughts?

[...]

> +static inline int esrt_table_exists(void)
> +{
> +	if (!efi_enabled(EFI_CONFIG_TABLES))
> +		return 0;
> +	if (efi.esrt == EFI_INVALID_TABLE_ADDR)
> +		return 0;
> +	return 1;
> +}

Minor detail: this should be using 'bool'.

-- 
Matt Fleming, Intel Open Source Technology Center
