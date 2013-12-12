From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 08/14] efi: export efi runtime memory mapping to sysfs
Date: Thu, 12 Dec 2013 10:36:17 +0800
Message-ID: <20131212023617.GF3751@dhcp-16-126.nay.redhat.com>
References: <1386582147-9802-1-git-send-email-dyoung@redhat.com>
 <1386582147-9802-9-git-send-email-dyoung@redhat.com>
 <20131211185520.GG23793@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131211185520.GG23793-fF5Pk5pvG8Y@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, toshi.kani-VXdhtT5mjnY@public.gmane.org, matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

> > +++ b/Documentation/ABI/testing/sysfs-firmware-efi-runtime-map
> > @@ -0,0 +1,36 @@
> > +What:		/sys/firmware/efi/runtime-map/
> > +Date:		December 2013
> > +Contact:	Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > +Description:
> 
> This could start at the same line as Description

Ok.

[snip]
> > +
> > +		Above values are all hexadecimal numbers with the '0x' prefix.
> > +
> 
> Superfluous newline.

Will remove

> 
> > +Users:		Kexec
> > diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> > index 3e8b760..8289e0c 100644
> > --- a/arch/x86/platform/efi/efi.c
> > +++ b/arch/x86/platform/efi/efi.c
> > @@ -76,6 +76,9 @@ static __initdata efi_config_table_type_t arch_tables[] = {
> >  	{NULL_GUID, NULL, NULL},
> >  };
> >  
> > +void *efi_runtime_map;
> > +int nr_efi_runtime_map;
> > +
> >  /*
> >   * Returns 1 if 'facility' is enabled, 0 otherwise.
> >   */
> > @@ -810,6 +813,19 @@ static void __init efi_merge_regions(void)
> >  	}
> >  }
> >  
> > +static int __init save_runtime_map(efi_memory_desc_t *md, int idx)
> > +{
> > +	void *p;
> > +	p = krealloc(efi_runtime_map, (idx + 1) * memmap.desc_size, GFP_KERNEL);
> > +	if (!p)
> > +		return -ENOMEM;
> > +
> > +	efi_runtime_map = p;
> > +	memcpy(efi_runtime_map + idx * memmap.desc_size, md, memmap.desc_size);
> > +
> > +	return 0;
> > +}
> > +
> >  /*
> >   * Map efi memory ranges for runtime serivce and update new_memmap with virtual
> >   * addresses.
> > @@ -820,6 +836,7 @@ static void * __init efi_map_regions(int *count)
> >  	void *p, *tmp, *new_memmap = NULL;
> >  	unsigned long size;
> >  	u64 end, systab;
> > +	int err = 0;
> >  
> >  	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
> >  		md = p;
> > @@ -848,10 +865,21 @@ static void * __init efi_map_regions(int *count)
> >  		new_memmap = tmp;
> >  		memcpy(new_memmap + (*count * memmap.desc_size), md,
> >  		       memmap.desc_size);
> > +		if (md->type != EFI_BOOT_SERVICES_CODE &&
> > +		    md->type != EFI_BOOT_SERVICES_DATA) {
> > +			err = save_runtime_map(md, nr_efi_runtime_map);
> > +			if (err)
> > +				goto out_save_runtime;
> > +			nr_efi_runtime_map++;
> > +		}
> 
> So why don't you move that code to save_runtime_map?
> 
> 
> It would looks like this:
> 
> ...
>                 new_memmap = tmp;
>                 memcpy(new_memmap + (*count * memmap.desc_size), md,
>                        memmap.desc_size);
> 
>                 save_runtime_map(md);
>                 (*count)++;
> 
>  [nr_efi_runtime_map is global, no need to pass it to save_runtime_map() ]

nr_efi_runtime_map is handled in diffrent way for 1st kernel and kexec kernel

For 1st kernel (boot from firmware) it's increased one by one in above function.

But for kexec kernel it is directly calculated from setup_data array len.
And increasing nr_efi_runtime_map in save_runtime_map is not ok the main reason
is I need the value firstly for the loop counter max value like below:
static int __init map_regions_fixed(void)
{
	[snip]
	for (i = 0, md = data->map; i < nr_efi_runtime_map; i++, md++) {
		[snip]
		save_runtime_map(md, i);
	[snip]
}

> 
> and the EFI_BOOT* tests can be done in save_runtime_map and also the
> error handling can happen there. This way efi_map_regions() won't
> need to know about anything. This way, you can later move the whole
> save_runtime_map() function to efi-kexec.c just by taking it without any
> need for untangling.
> 
> > +out_save_runtime:
> > +       kfree(efi_runtime_map);
> > +       nr_efi_runtime_map = 0;
> > +       efi_runtime_map = NULL;
> 
> This can go there too.

This section can go the save_runtime_map but it looks clearer to put them here.

> 
> >  out_krealloc:
> >  	kfree(new_memmap);
> >  	return NULL;
> > diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
> > index 3150aa4..3d8d6f6 100644
> > --- a/drivers/firmware/efi/Kconfig
> > +++ b/drivers/firmware/efi/Kconfig
> > @@ -39,4 +39,15 @@ config EFI_VARS_PSTORE_DEFAULT_DISABLE
> >  config UEFI_CPER
> >  	def_bool n
> >  
> > +config EFI_RUNTIME_MAP
> > +	bool "Export efi runtime maps to sysfs" if EXPERT
> 
> What's with the EXPERT? It depends on KEXEC already.

EXPERT can be removed safely, will do.

> 
> > +	depends on X86 && EFI && KEXEC
> > +	default y
> > +	help
> > +	  Export efi runtime memory maps to /sys/firmware/efi/runtime-map.
> > +	  That memory map is used for example by kexec to set up efi virtual
> > +	  mapping the 2nd kernel, but can also be used for debugging purposes.
> > +
> > +	  See also Documentation/ABI/testing/sysfs-firmware-efi-runtime-map.
> > +
> >  endmenu
> 
> ...
> 
> > +static int __init efi_runtime_map_init(void)
> > +{
> > +	int i, j, ret = 0;
> > +	struct efi_runtime_map_entry *entry;
> > +
> > +	if (!efi_kobj)
> > +		return 0;
> > +
> > +	if (!efi_runtime_map)
> > +		return 0;
> > +
> > +	map_entries = kzalloc(nr_efi_runtime_map * sizeof(entry), GFP_KERNEL);
> > +	if (!map_entries) {
> > +		ret = -ENOMEM;
> > +		goto out;
> > +	}
> > +
> > +	for (i = 0; i < nr_efi_runtime_map; i++) {
> > +		entry = add_sysfs_runtime_map_entry(i);
> > +		if (IS_ERR(entry)) {
> > +			ret = PTR_ERR(entry);
> > +			goto out_add_entry;
> > +		}
> > +		*(map_entries + i) = entry;
> > +	}
> > +
> > +	return 0;
> > +out_add_entry:
> > +	for (j = i - 1; j > 0; j--) {
> > +		entry = *(map_entries + j);
> > +		kobject_put(&entry->kobj);
> > +	}
> > +	if (map_kset)
> > +		kset_unregister(map_kset);
> > +out:
> > +	return ret;
> > +}
> > +
> > +subsys_initcall(efi_runtime_map_init);
> 
> Let me repeat myself:
> 
> Why an initcall? Can't we run this from efisubsys_init()?

Sorry that I forgot to explain this in changelog, should ask you before.

I did try moving it to efisubsys_init but it need add extern declaration
for efi_runtime_map_init. Since link order will ensure it being called after
efisubsys_init I think it's fine with this static function.

--
Thanks for review
Dave
