From: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>
Subject: Re: [RFT][PATCH] ACPI / init: Run acpi_early_init() before efi_enter_virtual_mode() (was: Re: [RFC PATCH 00/14] Support timezone of ACPI TAD and EFI TIME)
Date: Tue, 14 Jan 2014 17:50:07 +0100
Message-ID: <3968853.Ss7q3HgE9J@vostro.rjw.lan>
References: <1387439053-8711-1-git-send-email-jlee@suse.com> <2530951.HFPX8MI38t@vostro.rjw.lan> <1389672548.24105.252.camel@linux-s257.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389672548.24105.252.camel-ONCj+Eqt86TasUa73XJKwA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Elliott-VXdhtT5mjnY@public.gmane.org, samer.el-haj-mahmoud-VXdhtT5mjnY@public.gmane.org, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, werner-IBi9RG/b67k@public.gmane.org, trenn-l3A5Bk7waGM@public.gmane.org, JBeulich-IBi9RG/b67k@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tuesday, January 14, 2014 12:09:08 PM joeyli wrote:
> =E6=96=BC =E6=97=A5=EF=BC=8C2014-01-12 =E6=96=BC 01:30 +0100=EF=BC=8C=
Rafael J. Wysocki =E6=8F=90=E5=88=B0=EF=BC=9A
> > OK
> >=20
> > I don't see any adverse effects of the patch below on a couple of m=
y
> > test
> > boxes, but (a) they are Intel-based and (b) they are non-EFI, so it
> > would be
> > good to give it a go on as many machines as reasonably possible.
> >=20
> > Thanks,
> > Rafael
> >=20
> > ---
> > From: Rafael J. Wysocki <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Subject: ACPI / init: Run acpi_early_init() before
> > efi_enter_virtual_mode()
> >=20
> > According to Matt Fleming, if acpi_early_init() was executed befpre
> > efi_enter_virtual_mode(), the EFI initialization could benefit from
> > it, so make that happen.
> >=20
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
> >  init/main.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > Index: linux-pm/init/main.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-pm.orig/init/main.c
> > +++ linux-pm/init/main.c
> > @@ -615,6 +615,7 @@ asmlinkage void __init start_kernel(void
> >         calibrate_delay();
> >         pidmap_init();
> >         anon_vma_init();
> > +       acpi_early_init();
> >  #ifdef CONFIG_X86
> >         if (efi_enabled(EFI_RUNTIME_SERVICES))
> >                 efi_enter_virtual_mode();
> > @@ -641,7 +642,6 @@ asmlinkage void __init start_kernel(void
> > =20
> >         check_bugs();
> > =20
> > -       acpi_early_init(); /* before LAPIC and SMP init */
> >         sfi_init_late();
> > =20
> >         if (efi_enabled(EFI_RUNTIME_SERVICES)) {
> >=20
> >=20
> >=20
>=20
> This patch works to me on Acer Gateway Z5WT2 UEFI notebook and Intel
> UEFI development board.
>=20
> Does it possible move acpi_early_init() to before timekeeping_init()?

We can do that if it doesn't cause any problems to happen.

Please resubmit your patch with a changelog and we'll ask everyone to t=
ry it.

Thanks!

> The position is also before efi_enter_virtual_mode() and that will be
> useful for parsing ACPI TAD to set system clock:
>=20
> diff --git a/init/main.c b/init/main.c
> index febc511..b6d93c8 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -565,6 +565,7 @@ asmlinkage void __init start_kernel(void)
>         init_timers();
>         hrtimers_init();
>         softirq_init();
> +       acpi_early_init();
>         timekeeping_init();
>         time_init();
>         sched_clock_postinit();
> @@ -641,7 +642,6 @@ asmlinkage void __init start_kernel(void)
> =20
>         check_bugs();
> =20
> -       acpi_early_init(); /* before LAPIC and SMP init */
>         sfi_init_late();
> =20
>         if (efi_enabled(EFI_RUNTIME_SERVICES)) {
>=20
>=20
> Thanks a lot!
> Joey Lee
>=20

--=20
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
