From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [patch 5/7 v2] export efi runtime memory mapping to sysfs
Date: Wed, 13 Nov 2013 15:50:27 +0000
Message-ID: <20131113155027.GC17248@console-pimps.org>
References: <20131105082007.872550445@dhcp-16-126.nay.redhat.com>
 <20131105082718.185728964@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131105082718.185728964-je1gSBvt1TcFLmT5oZ11vB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 05 Nov, at 04:20:12PM, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> kexec kernel will need exactly same mapping for
> efi runtime memory ranges. Thus here export the
> runtime ranges mapping to sysfs, kexec-tools
> will assemble them and pass to 2nd kernel via
> setup_data.
> 
> Introducing a new directly /sys/firmware/efi/efi-runtime-map
> Just like /sys/firmware/memmap. Containing below attribute
> in each file of that directory:
> attribute  num_pages  phys_addr  type  virt_addr
> 
> It will not work for efi 32bit. Only x86_64 currently.
> 
> Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  Documentation/ABI/testing/sysfs-efi-runtime-map |   45 ++++++
>  arch/x86/include/asm/efi.h                      |    3 
>  arch/x86/platform/efi/efi.c                     |   11 +
>  drivers/firmware/efi/Kconfig                    |   10 +
>  drivers/firmware/efi/Makefile                   |    1 
>  drivers/firmware/efi/efi-runtime-map.c          |  164 ++++++++++++++++++++++++
>  drivers/firmware/efi/efi.c                      |    3 
>  include/linux/efi.h                             |    6 
>  8 files changed, 242 insertions(+), 1 deletion(-)

[...]

> @@ -852,6 +855,14 @@ static void efi_map_regions(void **new_m
>  
>  		memcpy(*new_memmap + (*count * memmap.desc_size), md,
>  		       memmap.desc_size);
> +		if (md->type != EFI_BOOT_SERVICES_CODE &&
> +			md->type != EFI_BOOT_SERVICES_DATA) {
> +			efi_runtime_map = krealloc(efi_runtime_map,
> +					(nr_efi_runtime_map + 1) *
> +					sizeof(efi_memory_desc_t), GFP_KERNEL);
> +			*(efi_runtime_map + nr_efi_runtime_map) = *md;
> +			nr_efi_runtime_map++;
> +		}
>  		(*count)++;
>  	}

You really need to be using 'memmap.desc_size' here and not
sizeof(efi_memory_desc_t) as the two may differ. Also, you should be
checking for failure of krealloc() and using memcpy() instead of
directly dereferencing 'md'.

> --- linux-2.6.orig/drivers/firmware/efi/Makefile
> +++ linux-2.6/drivers/firmware/efi/Makefile
> @@ -4,3 +4,4 @@
>  obj-y					+= efi.o vars.o
>  obj-$(CONFIG_EFI_VARS)			+= efivars.o
>  obj-$(CONFIG_EFI_VARS_PSTORE)		+= efi-pstore.o
> +obj-$(CONFIG_EFI_RUNTIME_MAP)		+= efi-runtime-map.o
> --- /dev/null
> +++ linux-2.6/drivers/firmware/efi/efi-runtime-map.c

Small nit but I wouldn't bother prefixing the filename with "efi-",
since you can't build this file as a module.

> +/*
> + * These are default attributes that are added for every memmap entry.
> + */
> +static struct attribute *def_attrs[] = {
> +	&map_type_attr.attr,
> +	&map_phys_addr_attr.attr,
> +	&map_virt_addr_attr.attr,
> +	&map_num_pages_attr.attr,
> +	&map_attribute_attr.attr,
> +	NULL
> +};

If the UEFI spec ever releases an update for the memory descriptor
structure, and bumps 'memmap.desc_version', how are we going to signal
the incompatibility to legacy versions of kexec tools?

-- 
Matt Fleming, Intel Open Source Technology Center
