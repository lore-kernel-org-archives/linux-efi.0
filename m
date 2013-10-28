From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [patch 3/6] Cleanup efi_enter_virtual_mode function
Date: Mon, 28 Oct 2013 10:32:06 +0100
Message-ID: <20131028093206.GB4314@pd.tnic>
References: <20131027034713.481920209@dhcp-16-126.nay.redhat.com>
 <20131027035923.081819853@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131027035923.081819853-je1gSBvt1TcFLmT5oZ11vB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, kexec-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Sun, Oct 27, 2013 at 11:47:16AM +0800, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> Add two small functions:
> efi_merge_regions and efi_map_regions, efi_enter_virtual_mode
> calls them instead of embedding two long for loop.
> 
> Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/x86/platform/efi/efi.c |   83 +++++++++++++++++++++++++++-----------------
>  1 file changed, 52 insertions(+), 31 deletions(-)
> 
> --- efi.orig/arch/x86/platform/efi/efi.c
> +++ efi/arch/x86/platform/efi/efi.c
> @@ -789,35 +789,13 @@ void __init old_map_region(efi_memory_de
>  		pr_err("ioremap of 0x%llX failed!\n",
>  		       (unsigned long long)md->phys_addr);
>  }
> -/*
> - * This function will switch the EFI runtime services to virtual mode.
> - * Essentially, look through the EFI memmap and map every region that
> - * has the runtime attribute bit set in its memory descriptor and update
> - * that memory descriptor with the virtual address obtained from ioremap().
> - * This enables the runtime services to be called without having to
> - * thunk back into physical mode for every invocation.
> - */
> -void __init efi_enter_virtual_mode(void)
> -{
> -	efi_memory_desc_t *md, *prev_md = NULL;
> -	void *p, *new_memmap = NULL;
> -	unsigned long size;
> -	efi_status_t status;
> -	u64 end, systab;
> -	int count = 0;
>  
> -	efi.systab = NULL;
> -
> -	/*
> -	 * We don't do virtual mode, since we don't do runtime services, on
> -	 * non-native EFI
> -	 */
> -	if (!efi_is_native()) {
> -		efi_unmap_memmap();
> -		return;
> -	}
> +/* Merge contiguous regions of the same type and attribute */
> +static void efi_merge_regions(void)
> +{
> +	void *p;
> + 	efi_memory_desc_t *md, *prev_md = NULL;
>  
> -	/* Merge contiguous regions of the same type and attribute */
>  	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
>  		u64 prev_size;
>  		md = p;
> @@ -844,6 +822,19 @@ void __init efi_enter_virtual_mode(void)
>  		prev_md = md;
>  
>  	}
> +}
> +
> +/*
> + * Map efi memory ranges for runtime serivce
> + * Return the new memmap with updated virtual addrresses.
> + */
> +void efi_map_regions(void **new_memmap, int *count)
> +{
> +	efi_memory_desc_t *md, *prev_md = NULL;

Applying: Cleanup efi_enter_virtual_mode function
/home/boris/kernel/linux-2.6/.git/rebase-apply/patch:42: space before tab in indent.
        efi_memory_desc_t *md, *prev_md = NULL;
error: patch failed: arch/x86/platform/efi/efi.c:862
error: arch/x86/platform/efi/efi.c: patch does not apply
Patch failed at 0001 Cleanup efi_enter_virtual_mode function

And I know git can be a bit pickier than patch but it doesn't apply with patch
either:

$ patch -p1 --dry-run -i .git/rebase-apply/patch
checking file arch/x86/platform/efi/efi.c
Hunk #3 FAILED at 853.
1 out of 3 hunks FAILED

For some reason, this patch doesn't apply and the .rej looks funny.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
