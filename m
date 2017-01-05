From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/2] efi: efi_mem_reserve(): don't reserve through
 memblock after mm_init()
Date: Thu, 5 Jan 2017 17:12:42 +0800
Message-ID: <20170105091242.GA11021@dhcp-128-65.nay.redhat.com>
References: <20161222102340.2689-1-nicstange@gmail.com>
 <20161222102340.2689-2-nicstange@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161222102340.2689-2-nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mika =?iso-8859-1?Q?Penttil=E4?= <mika.penttila-MRsr7dthA9VWk0Htik3J/w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 12/22/16 at 11:23am, Nicolai Stange wrote:
> Before invoking the arch specific handler, efi_mem_reserve() reserves
> the given memory region through memblock.
> 
> efi_mem_reserve() can get called after mm_init() though -- through
> efi_bgrt_init(), for example. After mm_init(), memblock is dead and should
> not be used anymore.

It did not fail during previous test so we did not catch this bug, if memblock
can not be used after mm_init(), IMHO it should fail instead of silently succeed.

Matt, can we move the efi_mem_reserve to earlier code for example in
efi_memblock_x86_reserve_range just after reserving the memmap?

> 
> Let efi_mem_reserve() check whether memblock is dead and not do the
> reservation if so. Emit a warning from the generic efi_arch mem_reserve()
> in this case: if the architecture doesn't provide any other means of
> registering the region as reserved, the operation would be a nop.
> 
> Fixes: 4bc9f92e64c8 ("x86/efi-bgrt: Use efi_mem_reserve() to avoid copying image data")
> Signed-off-by: Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  Changes to v1:
>  Change the if condition from slab_is_available() to !slab_is_available
>  as pointed out by Mika Penttilä at
>  http://lkml.kernel.org/r/c7bf34ba-56f0-8346-36d1-7069f2115dcf-MRsr7dthA9VWk0Htik3J/w@public.gmane.org
> 
>  drivers/firmware/efi/efi.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 92914801e388..158a8df2f4af 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -403,7 +403,10 @@ u64 __init efi_mem_desc_end(efi_memory_desc_t *md)
>  	return end;
>  }
>  
> -void __init __weak efi_arch_mem_reserve(phys_addr_t addr, u64 size) {}
> +void __init __weak efi_arch_mem_reserve(phys_addr_t addr, u64 size)
> +{
> +	WARN(slab_is_available(), "efi_mem_reserve() has no effect");
> +}
>  
>  /**
>   * efi_mem_reserve - Reserve an EFI memory region
> @@ -419,7 +422,7 @@ void __init __weak efi_arch_mem_reserve(phys_addr_t addr, u64 size) {}
>   */
>  void __init efi_mem_reserve(phys_addr_t addr, u64 size)
>  {
> -	if (!memblock_is_region_reserved(addr, size))
> +	if (!slab_is_available() && !memblock_is_region_reserved(addr, size))
>  		memblock_reserve(addr, size);
>  
>  	/*
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks
Dave
