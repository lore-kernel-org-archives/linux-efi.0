From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH v4 07/12] efi: passing kexec necessary efi data via
 setup_data
Date: Wed, 27 Nov 2013 15:07:32 +0100
Message-ID: <20131127140732.GD32267@pd.tnic>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
 <1385445477-9665-8-git-send-email-dyoung@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1385445477-9665-8-git-send-email-dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org, toshi.kani-VXdhtT5mjnY@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, Nov 26, 2013 at 01:57:52PM +0800, Dave Young wrote:
> Add a new setup_data type SETUP_EFI for kexec use.
> Passing the saved fw_vendor, runtime, config tables and
> efi runtime mappings.
>=20
> When entering virtual mode, directly mapping the efi
> runtime ragions which we passed in previously. And skip
> the step to call SetVirtualAddressMap.
>=20
> Specially for HP z420 workstation it need another variable
> saving,

Why the special handling? Does that mean, this is going to be the case
for other HP UEFI implementations too?

> it's the smbios physical address, the HP bios
> also update the SMBIOS address after entering virtual mode
> besides of the standard fw_vendor,runtime and config table.
>=20
> Tested on ovmf+qemu, lenovo thinkpad, a dell laptop and an
> HP z420 workstation.
>=20
> v2: refresh based on previous patch changes, code cleanup.
> v3: use ioremap instead of phys_to_virt for esdata
>=20
> Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/x86/include/asm/efi.h            |  12 +++
>  arch/x86/include/uapi/asm/bootparam.h |   1 +
>  arch/x86/kernel/setup.c               |   3 +
>  arch/x86/platform/efi/efi.c           | 161 ++++++++++++++++++++++++=
++++++----
>  4 files changed, 160 insertions(+), 17 deletions(-)
>=20
> diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
> index 9fbaeb2..73d5643 100644
> --- a/arch/x86/include/asm/efi.h
> +++ b/arch/x86/include/asm/efi.h
> @@ -133,6 +133,18 @@ extern void efi_sync_low_kernel_mappings(void);
>  extern void efi_setup_page_tables(void);
>  extern void __init old_map_region(efi_memory_desc_t *md);
> =20
> +struct efi_setup_data {
> +	u64 fw_vendor;
> +	u64 runtime;
> +	u64 tables;
> +	u64 smbios;
> +	u64 reserved[8];

What's that for?

> +	efi_memory_desc_t map[0];
> +};
> +
> +extern void parse_efi_setup(u64 phys_addr, u32 data_len);
> +extern struct efi_setup_data *esdata;
> +
>  #ifdef CONFIG_EFI
> =20
>  static inline bool efi_is_native(void)

[ =E2=80=A6 ]

> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.=
c
> index c3a2aaa..fafeb40 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -504,8 +531,12 @@ static int __init efi_systab_init(void *phys)
>  		}
> =20
>  		efi_systab.hdr =3D systab64->hdr;
> -		efi_systab.fw_vendor =3D systab64->fw_vendor;
> -		tmp |=3D systab64->fw_vendor;
> +
> +		if (esdata)
> +			efi_systab.fw_vendor =3D (unsigned long)esdata->fw_vendor;
> +		else
> +			efi_systab.fw_vendor =3D systab64->fw_vendor;

		efi_systab.fw_vendor =3D esdata ? (unsigned long)esdata->fw_vendor
					      : systab64->fw_vendor;

> +		tmp |=3D efi_systab.fw_vendor;
>  		efi_systab.fw_revision =3D systab64->fw_revision;
>  		efi_systab.con_in_handle =3D systab64->con_in_handle;
>  		tmp |=3D systab64->con_in_handle;
> @@ -519,13 +550,21 @@ static int __init efi_systab_init(void *phys)
>  		tmp |=3D systab64->stderr_handle;
>  		efi_systab.stderr =3D systab64->stderr;
>  		tmp |=3D systab64->stderr;
> -		efi_systab.runtime =3D (void *)(unsigned long)systab64->runtime;
> -		tmp |=3D systab64->runtime;
> +		if (esdata)
> +			efi_systab.runtime =3D
> +				(void *)(unsigned long)esdata->runtime;
> +		else
> +			efi_systab.runtime =3D
> +				(void *)(unsigned long)systab64->runtime;

Ditto. Which would take care of these linebreaks which are ugly.

> +		tmp |=3D (unsigned long)efi_systab.runtime;
>  		efi_systab.boottime =3D (void *)(unsigned long)systab64->boottime;
>  		tmp |=3D systab64->boottime;
>  		efi_systab.nr_tables =3D systab64->nr_tables;
> -		efi_systab.tables =3D systab64->tables;
> -		tmp |=3D systab64->tables;
> +		if (esdata)
> +			efi_systab.tables =3D (unsigned long)esdata->tables;
> +		else
> +			efi_systab.tables =3D systab64->tables;

Ditto.

> +		tmp |=3D efi_systab.tables;
> =20
>  		early_iounmap(systab64, sizeof(*systab64));
>  #ifdef CONFIG_X86_32
> @@ -631,6 +670,41 @@ static int __init efi_memmap_init(void)
>  	return 0;
>  }
> =20
> +static int __init efi_reuse_config(u64 tables, int nr_tables)

Static function - no need for "efi_" prefix.

> +{
> +	void *p, *tablep;
> +	int i, sz;
> +
> +	if (!efi_enabled(EFI_64BIT))
> +		return 0;
> +
> +	sz =3D sizeof(efi_config_table_64_t);
> +
> +	p =3D tablep =3D early_memremap(tables, nr_tables * sz);
> +	if (!p) {
> +		pr_err("Could not map Configuration table!\n");
> +		return -ENOMEM;
> +	}
> +
> +	for (i =3D 0; i < efi.systab->nr_tables; i++) {
> +		efi_guid_t guid;
> +
> +		guid =3D ((efi_config_table_64_t *)p)->guid;
> +
> +		/*
> +		HP z420 workstation smbios will be convert to
> +		virtual address after enter virtual mode.
> +		Thus in case kexec/kdump the physical address
> +		will be passed in setup_data.

Is that what the commit message above says? I'm having a hard time
parsing this text.

> +		*/
> +		if (!efi_guidcmp(guid, SMBIOS_TABLE_GUID))
> +			((efi_config_table_64_t *)p)->table =3D esdata->smbios;

=2E..and yet we do this for *every* UEFI box. Why not HP only?

> +		p +=3D sz;
> +	}
> +	early_iounmap(tablep, nr_tables * sz);
> +	return 0;
> +}
> +
>  void __init efi_init(void)
>  {
>  	efi_char16_t *c16;
> @@ -676,6 +750,9 @@ void __init efi_init(void)
>  		efi.systab->hdr.revision >> 16,
>  		efi.systab->hdr.revision & 0xffff, vendor);
> =20
> +	if (esdata && esdata->smbios)
> +		efi_reuse_config(efi.systab->tables, efi.systab->nr_tables);
> +
>  	if (efi_config_init(arch_tables))
>  		return;
> =20
> @@ -886,6 +963,43 @@ ret:
>  }
> =20
>  /*
> + * map efi regions which was passed via setup_data
> + * the virt_addr is a fixed addr which was used in
> + * 1st kernel of kexec boot.
> + */

Comment to 80 cols pls.

> +static void __init efi_map_regions_fixed(void)

Also no need for "efi_" prefix here.

> +{
> +	int i;
> +	unsigned long size;
> +	efi_memory_desc_t *md;
> +	u64 end, systab;
> +	void *p;
> +
> +	efi_runtime_map =3D kzalloc(nr_efi_runtime_map * memmap.desc_size,
> +				GFP_KERNEL);

Arg alignment.

> +	if (!efi_runtime_map)
> +		pr_err("Out of memory, EFI runtime on nested kexec non-functional!=
\n");
> +
> +	for (i =3D 0, p =3D efi_runtime_map; i < nr_efi_runtime_map; i++) {
> +		md =3D esdata->map + i;
> +		efi_map_region_fixed(md);

Gaah, this function should probably have a retval which signalizes
success/failure. For that I should probably teach __map_region to do
that too. On the TODO list.

> +		size =3D md->num_pages << PAGE_SHIFT;
> +		end =3D md->phys_addr + size;
> +
> +		systab =3D (u64) (unsigned long) efi_phys.systab;
> +		if (md->phys_addr <=3D systab && systab < end) {
> +			systab +=3D md->virt_addr - md->phys_addr;
> +			efi.systab =3D
> +				(efi_system_table_t *) (unsigned long) systab;

CHECK: No space is necessary after a cast
#219: FILE: arch/x86/platform/efi/efi.c:993:
+                       efi.systab =3D
+                               (efi_system_table_t *) (unsigned long) =
systab;


And also, those broken lines are ugly. Just let it stick out over 80 co=
ls.

> +		}
> +		if (efi_runtime_map) {
> +			memcpy(p, md, memmap.desc_size);
> +			p +=3D memmap.desc_size;
> +		}
> +	}
> +}
> +
> +/*
>   * This function will switch the EFI runtime services to virtual mod=
e.
>   * Essentially, we look through the EFI memmap and map every region =
that
>   * has the runtime attribute bit set in its memory descriptor into t=
he
> @@ -901,6 +1015,10 @@ ret:
>   * so that we're in a different address space when calling a runtime
>   * function. For function arguments passing we do copy the PGDs of t=
he
>   * kernel page table into ->trampoline_pgd prior to each call.
> + *
> + * Specially for kexec boot efi runtime maps in previous kernel shou=
ld

			  boot, ...

> + * be passed in via setup_data. In that case runtime ranges will be =
mapped

					   case, ...

> + * to fixed virtual addresses exactly same as the ones in previous k=
ernel.

"... to the same virtual addresses as the first kernel."

>   */
>  void __init efi_enter_virtual_mode(void)
>  {
> @@ -919,12 +1037,15 @@ void __init efi_enter_virtual_mode(void)
>  		return;
>  	}
> =20
> -	efi_merge_regions();
> -
> -	new_memmap =3D efi_map_regions(&count);
> -	if (!new_memmap) {
> -		pr_err("Error reallocating memory, EFI runtime non-functional!\n")=
;
> -		return;
> +	if (esdata)
> +		efi_map_regions_fixed();
> +	else {
> +		efi_merge_regions();
> +		new_memmap =3D efi_map_regions(&count);
> +		if (!new_memmap) {
> +			pr_err("Error reallocating memory, EFI runtime non-functional!\n"=
);
> +			return;
> +		}

CHECK: braces {} should be used on all arms of this statement
#253: FILE: arch/x86/platform/efi/efi.c:1040:
+       if (esdata)
[...]
+       else {
[...]

--=20
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
