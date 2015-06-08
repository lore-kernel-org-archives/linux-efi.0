From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efi: Work around ia64 build problem with ESRT driver.
Date: Mon, 8 Jun 2015 11:09:34 +0100
Message-ID: <20150608100934.GB20042@codeblueprint.co.uk>
References: <20150605191329.GA23480@redhat.com>
 <1433531694-24439-1-git-send-email-pjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1433531694-24439-1-git-send-email-pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 05 Jun, at 03:14:54PM, Peter Jones wrote:
> So, I'm told this problem exists in the world:
> ----------------------------------------------
> Subject: Build error in -next due to 'efi: Add esrt support'
> 
> Building ia64:defconfig ... failed
> --------------
> Error log:
> 
> drivers/firmware/efi/esrt.c:28:31: fatal error: asm/early_ioremap.h: No
> such file or directory
> ----------------------------------------------
> 
> I'm not really sure how it's okay that we have things in asm-generic on
> some platforms but not others - is having it the same everywhere not the
> whole point of asm-generic?
> 
> That said, ia64 doesn't have early-ioremap.h .  So instead, since it's
> difficult to imagine new IA64 machines with UEFI 2.5, just don't build
> this code there.
> 
> To me this looks like a workaround - doing something like:
> 
> generic-y += early_ioremap.h
> 
> in arch/ia64/include/asm/Kbuild would appear to be more correct, but
> ia64 has its own early_memremap() decl in arch/ia64/include/asm/io.h ,
> and it's a macro.  So adding the above /and/ requiring that asm/io.h be
> included /after/ asm/early_ioremap.h in all cases would fix it, but
> that's pretty ugly as well.  Since I'm not going to spend the rest of my
> life rectifying ia64 headers vs "generic" headers that aren't generic,
> it's much simpler to just not build there.
> 
> Note that I've only actually tried to build this patch on x86_64, but
> esrt.o still gets built there, and that would seem to demonstrate that
> the conditional building is working correctly at all the places the code
> built before.  I no longer have any ia64 machines handy to test that the
> exclusion actually works there.
> 
> Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Acked-by: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/firmware/efi/Kconfig  | 5 +++++
>  drivers/firmware/efi/Makefile | 3 ++-
>  include/linux/efi.h           | 4 ++++
>  3 files changed, 11 insertions(+), 1 deletion(-)
 
Thanks Peter, I picked this up with everyone's Ack/Test tags.

But now let's Cc some more people that can answer the questions you
posed above, which would be the people mentioned in commit 9e5c33d7aeee
("mm: create generic early_ioremap() support").

Folks, is it legitimate to have headers in include/asm-generic/ that
aren't available to all architectures? The build failure incurred by
directly including asm/early_ioremap.h is noted above.

> diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
> index 8de4da5..54071c1 100644
> --- a/drivers/firmware/efi/Kconfig
> +++ b/drivers/firmware/efi/Kconfig
> @@ -18,6 +18,11 @@ config EFI_VARS
>  	  Subsequent efibootmgr releases may be found at:
>  	  <http://github.com/vathpela/efibootmgr>
>  
> +config EFI_ESRT
> +	bool
> +	depends on EFI && !IA64
> +	default y
> +
>  config EFI_VARS_PSTORE
>  	tristate "Register efivars backend for pstore"
>  	depends on EFI_VARS && PSTORE
> diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
> index 26eabbc..6fd3da9 100644
> --- a/drivers/firmware/efi/Makefile
> +++ b/drivers/firmware/efi/Makefile
> @@ -1,8 +1,9 @@
>  #
>  # Makefile for linux kernel
>  #
> -obj-$(CONFIG_EFI)			+= efi.o esrt.o vars.o reboot.o
> +obj-$(CONFIG_EFI)			+= efi.o vars.o reboot.o
>  obj-$(CONFIG_EFI_VARS)			+= efivars.o
> +obj-$(CONFIG_EFI_ESRT)			+= esrt.o
>  obj-$(CONFIG_EFI_VARS_PSTORE)		+= efi-pstore.o
>  obj-$(CONFIG_UEFI_CPER)			+= cper.o
>  obj-$(CONFIG_EFI_RUNTIME_MAP)		+= runtime-map.o
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 024c27e..2092965 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -879,7 +879,11 @@ static inline efi_status_t efi_query_variable_store(u32 attributes, unsigned lon
>  #endif
>  extern void __iomem *efi_lookup_mapped_addr(u64 phys_addr);
>  extern int efi_config_init(efi_config_table_type_t *arch_tables);
> +#ifdef CONFIG_EFI_ESRT
>  extern void __init efi_esrt_init(void);
> +#else
> +static inline void efi_esrt_init(void) { }
> +#endif
>  extern int efi_config_parse_tables(void *config_tables, int count, int sz,
>  				   efi_config_table_type_t *arch_tables);
>  extern u64 efi_get_iobase (void);
> -- 
> 2.4.2
> 

-- 
Matt Fleming, Intel Open Source Technology Center
