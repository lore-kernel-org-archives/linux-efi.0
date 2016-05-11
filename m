From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] Xen: EFI: Parse DT parameters for Xen specific UEFI
Date: Wed, 11 May 2016 21:35:47 +0800
Message-ID: <57333533.2030206@linaro.org>
References: <1462523526-3172-1-git-send-email-zhaoshenglong@huawei.com>
 <20160511122730.GU2839@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160511122730.GU2839-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, sstabellini-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, stefano-yd54mjeZNzVBDgjK7y7TUQ@public.gmane.org, julien.grall-5wv7dgnIgG8@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 2016=E5=B9=B405=E6=9C=8811=E6=97=A5 20:27, Matt Fleming wrote:
> On Fri, 06 May, at 04:32:06PM, Shannon Zhao wrote:
>> > From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> >=20
>> > Add a new function to parse DT parameters for Xen specific UEFI ju=
st
>> > like the way for normal UEFI. Then it could reuse the existing cod=
es.
>> >=20
>> > If Xen supports EFI, initialize runtime services.
> =20
> This commit log would benefit from a little expansion. I'd like to se=
e
> information that answers the following questions,
>=20
>  - How do the Xen DT paramters differ from bare metal?
>  - What existing code is reused with your patch?
>  - How are Xen runtime services different from bare metal?
>  - Why is it OK to force enable EFI runtime services for Xen?
>=20
> I think it would also be good to explicitly state that we do not
> expect to find both Xen EFI DT parameters and bare metal EFI DT
> parameters when performing the search; the two should be mutually
> exclusive.
>=20
>> > CC: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
>> > Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> > ---
>> > Drop using of EFI_PARAVIRT. Discussion can be found from [1].
>> > [1] https://lkml.org/lkml/2016/4/29/8
>> > ---
>> >  arch/arm/include/asm/efi.h         |  2 +
>> >  arch/arm/xen/enlighten.c           | 16 ++++++++
>> >  arch/arm64/include/asm/efi.h       |  2 +
>> >  drivers/firmware/efi/arm-runtime.c | 70 +++++++++++++++++++++++--=
-------
>> >  drivers/firmware/efi/efi.c         | 81 +++++++++++++++++++++++++=
+++++--------
>> >  5 files changed, 137 insertions(+), 34 deletions(-)
>> >=20
>> > diff --git a/arch/arm/include/asm/efi.h b/arch/arm/include/asm/efi=
=2Eh
>> > index e0eea72..5ba4343 100644
>> > --- a/arch/arm/include/asm/efi.h
>> > +++ b/arch/arm/include/asm/efi.h
>> > @@ -52,9 +52,11 @@ static inline void efi_set_pgd(struct mm_struct=
 *mm)
>> > =20
>> >  void efi_virtmap_load(void);
>> >  void efi_virtmap_unload(void);
>> > +int xen_arm_enable_runtime_services(void);
>> > =20
>> >  #else
>> >  #define efi_init()
>> > +#define xen_arm_enable_runtime_services() (0)
>> >  #endif /* CONFIG_EFI */
>> > =20
>> >  /* arch specific definitions used by the stub code */
>> > diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
>> > index 13e3e9f..3362870 100644
>> > --- a/arch/arm/xen/enlighten.c
>> > +++ b/arch/arm/xen/enlighten.c
>> > @@ -16,6 +16,7 @@
>> >  #include <asm/xen/hypervisor.h>
>> >  #include <asm/xen/hypercall.h>
>> >  #include <asm/system_misc.h>
>> > +#include <asm/efi.h>
>> >  #include <linux/interrupt.h>
>> >  #include <linux/irqreturn.h>
>> >  #include <linux/module.h>
>> > @@ -261,6 +262,13 @@ static int __init fdt_find_hyper_node(unsigne=
d long node, const char *uname,
>> >  	    !strncmp(hyper_node.prefix, s, strlen(hyper_node.prefix)))
>> >  		hyper_node.version =3D s + strlen(hyper_node.prefix);
>> > =20
>> > +	if (IS_ENABLED(CONFIG_XEN_EFI)) {
>> > +		/* Check if Xen supports EFI */
>> > +		if ((of_get_flat_dt_subnode_by_name(node, "uefi") > 0) &&
>> > +		    !efi_runtime_disabled())
>> > +			set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
>> > +	}
>> > +
>> >  	return 0;
>> >  }
>> > =20
> The above comment could do with including similar information to the
> commit log as to why we want to force enable runtime services. For x8=
6
> we have this,
>=20
> 	 *
> 	 * When EFI_PARAVIRT is in force then we could not map runtime
> 	 * service memory region because we do not have direct access to it.
> 	 * However, runtime services are available through proxy functions
> 	 * (e.g. in case of Xen dom0 EFI implementation they call special
> 	 * hypercall which executes relevant EFI functions) and that is why
> 	 * they are always enabled.
> 	 */
>=20
> We need something similar here.
>=20
>> > @@ -338,6 +346,7 @@ static int __init xen_guest_init(void)
>> >  {
>> >  	struct xen_add_to_physmap xatp;
>> >  	struct shared_info *shared_info_page =3D NULL;
>> > +	int ret;
>> > =20
>> >  	if (!xen_domain())
>> >  		return 0;
>> > @@ -352,6 +361,13 @@ static int __init xen_guest_init(void)
>> >  		return -ENODEV;
>> >  	}
>> > =20
>> > +	if (IS_ENABLED(CONFIG_XEN_EFI) && efi_enabled(EFI_BOOT) &&
>> > +	    efi_enabled(EFI_RUNTIME_SERVICES)) {
>> > +		ret =3D xen_arm_enable_runtime_services();
>> > +		if (ret)
>> > +			return ret;
>> > +	}
>> > +
> Is it ever possible to have EFI_RUNTIME_SERVICES set but
> efi_enabled(EFI_BOOT) and IS_ENABLED(CONFIG_XEN_EFI) be false inside
> this function? If the answer is "no", I'd suggest just reducing this
> down to,
>=20
> 	/*
> 	 * The fdt parsing code will have set EFI_RUNTIME_SERVICES if
> 	 * it found Xen EFI parameters. Force enable runtime services.
> 	 */=20
> 	if (efi_enabled(EFI_RUNTIME_SERVICES)) {
> 		ret =3D xen_arm_enable_runtime_services();
> 		if (ret)
> 			return ret;
> 	}
>=20
> But first, see my comments below.
>=20
>> > @@ -39,6 +40,33 @@ static struct mm_struct efi_mm =3D {
>> >  	.mmlist			=3D LIST_HEAD_INIT(efi_mm.mmlist),
>> >  };
>> > =20
>> > +static int __init efi_remap_init(void)
>> > +{
>> > +	u64 mapsize;
>> > +
>> > +	pr_info("Remapping and enabling EFI services.\n");
>> > +
>> > +	mapsize =3D memmap.map_end - memmap.map;
>> > +	memmap.map =3D (__force void *)ioremap_cache(memmap.phys_map,
>> > +						   mapsize);
>> > +	if (!memmap.map) {
>> > +		pr_err("Failed to remap EFI memory map\n");
>> > +		return -ENOMEM;
>> > +	}
>> > +	memmap.map_end =3D memmap.map + mapsize;
>> > +	efi.memmap =3D &memmap;
>> > +
>> > +	efi.systab =3D (__force void *)ioremap_cache(efi_system_table,
>> > +						   sizeof(efi_system_table_t));
>> > +	if (!efi.systab) {
>> > +		pr_err("Failed to remap EFI System Table\n");
>> > +		return -ENOMEM;
>> > +	}
>> > +	set_bit(EFI_SYSTEM_TABLES, &efi.flags);
>> > +
>> > +	return 0;
>> > +}
>> > +
>> >  static bool __init efi_virtmap_init(void)
>> >  {
>> >  	efi_memory_desc_t *md;
>> > @@ -75,7 +103,7 @@ static bool __init efi_virtmap_init(void)
>> >   */
>> >  static int __init arm_enable_runtime_services(void)
>> >  {
>> > -	u64 mapsize;
>> > +	int ret;
>> > =20
>> >  	if (!efi_enabled(EFI_BOOT)) {
>> >  		pr_info("EFI services will not be available.\n");
>> > @@ -87,25 +115,14 @@ static int __init arm_enable_runtime_services=
(void)
>> >  		return 0;
>> >  	}
>> > =20
>> > -	pr_info("Remapping and enabling EFI services.\n");
>> > -
>> > -	mapsize =3D memmap.map_end - memmap.map;
>> > -	memmap.map =3D (__force void *)ioremap_cache(memmap.phys_map,
>> > -						   mapsize);
>> > -	if (!memmap.map) {
>> > -		pr_err("Failed to remap EFI memory map\n");
>> > -		return -ENOMEM;
>> > +	if (efi_enabled(EFI_RUNTIME_SERVICES)) {
>> > +		pr_info("EFI runtime services access via paravirt.\n");
>> > +		return 0;
>> >  	}
>> > -	memmap.map_end =3D memmap.map + mapsize;
>> > -	efi.memmap =3D &memmap;
>> > =20
>> > -	efi.systab =3D (__force void *)ioremap_cache(efi_system_table,
>> > -						   sizeof(efi_system_table_t));
>> > -	if (!efi.systab) {
>> > -		pr_err("Failed to remap EFI System Table\n");
>> > -		return -ENOMEM;
>> > -	}
>> > -	set_bit(EFI_SYSTEM_TABLES, &efi.flags);
>> > +	ret =3D efi_remap_init();
>> > +	if (ret)
>> > +		return ret;
>> > =20
>> >  	if (!efi_virtmap_init()) {
>> >  		pr_err("No UEFI virtual mapping was installed -- runtime servic=
es will not be available\n");
>> > @@ -122,6 +139,23 @@ static int __init arm_enable_runtime_services=
(void)
>> >  }
>> >  early_initcall(arm_enable_runtime_services);
>> > =20
>> > +int __init xen_arm_enable_runtime_services(void)
>> > +{
>> > +	int ret;
>> > +
>> > +	ret =3D efi_remap_init();
>> > +	if (ret)
>> > +		return ret;
>> > +
>> > +	if (IS_ENABLED(CONFIG_XEN_EFI)) {
>> > +		/* Set up runtime services function pointers for Xen Dom0 */
>> > +		xen_efi_runtime_setup();
>> > +		efi.runtime_version =3D efi.systab->hdr.revision;
>> > +	}
>> > +
>> > +	return 0;
>> > +}
> Since you call efi_remap_init() in both of these functions, couldn't
> you leave the existing code alone and bail after setting up the memor=
y
> map and systab in arm_enable_runtime_services()?
>=20
> Also, why do you need to setup efi.runtime_version here? Isn't that
> done inside uefi_init()?
>=20
I don't see any codes which setup efi.runtime_version in uefi_init().

> Here is how I would have expected this patch to look:
>=20
>   - Add FDT code to find hypervisor EFI params
>=20
>   - Force enable EFI_RUNTIME_SERVICES for Xen and call
>     xen_efi_runtime_setup() inside xen_guest_init()
>=20
>   - Change arm_enable_runtime_services() to handle the case where
>     EFI_RUNTIME_SERVICES is already set
>=20
> Am I misunderstanding some ordering issues?

Since xen_guest_init() and arm_enable_runtime_services() are both
early_initcall and the calling order is random I think. And when we cal=
l
xen_efi_runtime_setup() and setup efi.runtime_version in
xen_guest_init(), the efi.systab might be NULL. So it needs to map the
systanle explicitly before we use efi.systab.

Thanks,
--=20
Shannon
