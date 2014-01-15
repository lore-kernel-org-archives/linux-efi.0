From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFT][PATCH] ACPI / init: Run acpi_early_init() before
 efi_enter_virtual_mode()
Date: Wed, 15 Jan 2014 15:18:02 +0800
Message-ID: <1389770282.24105.259.camel@linux-s257.site>
References: <1387439053-8711-1-git-send-email-jlee@suse.com>
	 <3476450.BMEcId2Lgj@vostro.rjw.lan>
	 <20131221122148.GB29501@console-pimps.org>
	 <2530951.HFPX8MI38t@vostro.rjw.lan>
	 <1389672548.24105.252.camel@linux-s257.site> <52D57B54.7080509@zytor.com>
	 <1389731547.1792.296.camel@misato.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389731547.1792.296.camel-RbGIw1UOYPVo/CpIj0byZw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Elliott-VXdhtT5mjnY@public.gmane.org, samer.el-haj-mahmoud-VXdhtT5mjnY@public.gmane.org, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, werner-IBi9RG/b67k@public.gmane.org, trenn-l3A5Bk7waGM@public.gmane.org, JBeulich-IBi9RG/b67k@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E4=BA=8C=EF=BC=8C2014-01-14 =E6=96=BC 13:32 -0700=EF=BC=8CTo=
shi Kani =E6=8F=90=E5=88=B0=EF=BC=9A
> > > +       acpi_early_init();
> > >         timekeeping_init();
> > >         time_init();
> > >         sched_clock_postinit();
> > > @@ -641,7 +642,6 @@ asmlinkage void __init start_kernel(void)
> > > =20
> > >         check_bugs();
> > > =20
> > > -       acpi_early_init(); /* before LAPIC and SMP init */
> > >         sfi_init_late();
> > > =20
> > >         if (efi_enabled(EFI_RUNTIME_SERVICES)) {
> > >=20
> >=20
> > Hi Toshi,
> >=20
> > Could you try this variant, too?  If this works as well then we end
> up
> > solving two problems in one patch...
>=20
> Hi Peter,
>=20
> Yes, this version works fine as well.
>=20
> Tested-by: Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
>=20
> Thanks,
> -Toshi

Thanks a lot for your testing.

I will re-send a formal patch with changelog to everybody.

Regards
Joey Lee
