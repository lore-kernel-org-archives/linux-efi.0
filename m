From: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
Subject: Re: [PATCH] efi: Work around ia64 build problem with ESRT driver.
Date: Fri, 5 Jun 2015 10:11:15 -0700
Message-ID: <20150605171115.GA22534@roeck-us.net>
References: <5571B70B.90108@roeck-us.net>
 <1433523746-21734-1-git-send-email-pjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1433523746-21734-1-git-send-email-pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Jun 05, 2015 at 01:02:26PM -0400, Peter Jones wrote:
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
> ---
>  drivers/firmware/efi/Makefile | 5 ++++-
>  include/linux/efi.h           | 4 ++++
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
> index 26eabbc..81c8527 100644
> --- a/drivers/firmware/efi/Makefile
> +++ b/drivers/firmware/efi/Makefile
> @@ -1,7 +1,10 @@
>  #
>  # Makefile for linux kernel
>  #
> -obj-$(CONFIG_EFI)			+= efi.o esrt.o vars.o reboot.o
> +obj-$(CONFIG_EFI)			+= efi.o vars.o reboot.o
> +ifeq ($(CONFIG_IA64),)
> +obj-$(CONFIG_EFI)			+= esrt.o
> +endif

Hi Peter,

How about adding a hidden Kconfig option instead ?

config EFI_ESRT
	bool
	depends on !IA64
	default true

Then you could use

obj-$(CONFIG_EFI_ESRT)	+= esrt.o

>  obj-$(CONFIG_EFI_VARS)			+= efivars.o
>  obj-$(CONFIG_EFI_VARS_PSTORE)		+= efi-pstore.o
>  obj-$(CONFIG_UEFI_CPER)			+= cper.o
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 024c27e..1983d17 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -879,7 +879,11 @@ static inline efi_status_t efi_query_variable_store(u32 attributes, unsigned lon
>  #endif
>  extern void __iomem *efi_lookup_mapped_addr(u64 phys_addr);
>  extern int efi_config_init(efi_config_table_type_t *arch_tables);
> +#ifdef CONFIG_IA64

and use CONFIG_EFI_ESRT here.

Thanks,
Guenter

> +static inline void efi_esrt_init(void) { }
> +#else
>  extern void __init efi_esrt_init(void);
> +#endif
>  extern int efi_config_parse_tables(void *config_tables, int count, int sz,
>  				   efi_config_table_type_t *arch_tables);
>  extern u64 efi_get_iobase (void);
> -- 
> 2.4.2
> 
