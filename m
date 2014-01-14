From: joeyli <jlee@suse.com>
Subject: Re: [RFT][PATCH] ACPI / init: Run acpi_early_init() before
 efi_enter_virtual_mode() (was: Re: [RFC PATCH 00/14] Support timezone of
 ACPI TAD and EFI TIME)
Date: Tue, 14 Jan 2014 12:09:08 +0800
Message-ID: <1389672548.24105.252.camel@linux-s257.site>
References: <1387439053-8711-1-git-send-email-jlee@suse.com>
	 <3476450.BMEcId2Lgj@vostro.rjw.lan>
	 <20131221122148.GB29501@console-pimps.org>
	 <2530951.HFPX8MI38t@vostro.rjw.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <2530951.HFPX8MI38t@vostro.rjw.lan>
Sender: linux-acpi-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Matt Fleming <matt@console-pimps.org>, "H. Peter Anvin" <hpa@zytor.com>, Alessandro Zummo <a.zummo@towertech.it>, Matthew Garrett <matthew.garrett@nebula.com>, Elliott@hp.com, samer.el-haj-mahmoud@hp.com, Oliver Neukum <oneukum@suse.de>, werner@suse.com, trenn@suse.de, JBeulich@suse.com, linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com, x86@kernel.org, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, linux-acpi@vger.kernel.org, Borislav Petkov <bp@suse.de>
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E6=97=A5=EF=BC=8C2014-01-12 =E6=96=BC 01:30 +0100=EF=BC=8CRa=
fael J. Wysocki =E6=8F=90=E5=88=B0=EF=BC=9A
> OK
>=20
> I don't see any adverse effects of the patch below on a couple of my
> test
> boxes, but (a) they are Intel-based and (b) they are non-EFI, so it
> would be
> good to give it a go on as many machines as reasonably possible.
>=20
> Thanks,
> Rafael
>=20
> ---
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Subject: ACPI / init: Run acpi_early_init() before
> efi_enter_virtual_mode()
>=20
> According to Matt Fleming, if acpi_early_init() was executed befpre
> efi_enter_virtual_mode(), the EFI initialization could benefit from
> it, so make that happen.
>=20
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  init/main.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> Index: linux-pm/init/main.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-pm.orig/init/main.c
> +++ linux-pm/init/main.c
> @@ -615,6 +615,7 @@ asmlinkage void __init start_kernel(void
>         calibrate_delay();
>         pidmap_init();
>         anon_vma_init();
> +       acpi_early_init();
>  #ifdef CONFIG_X86
>         if (efi_enabled(EFI_RUNTIME_SERVICES))
>                 efi_enter_virtual_mode();
> @@ -641,7 +642,6 @@ asmlinkage void __init start_kernel(void
> =20
>         check_bugs();
> =20
> -       acpi_early_init(); /* before LAPIC and SMP init */
>         sfi_init_late();
> =20
>         if (efi_enabled(EFI_RUNTIME_SERVICES)) {
>=20
>=20
>=20

This patch works to me on Acer Gateway Z5WT2 UEFI notebook and Intel
UEFI development board.

Does it possible move acpi_early_init() to before timekeeping_init()?
The position is also before efi_enter_virtual_mode() and that will be
useful for parsing ACPI TAD to set system clock:

diff --git a/init/main.c b/init/main.c
index febc511..b6d93c8 100644
--- a/init/main.c
+++ b/init/main.c
@@ -565,6 +565,7 @@ asmlinkage void __init start_kernel(void)
        init_timers();
        hrtimers_init();
        softirq_init();
+       acpi_early_init();
        timekeeping_init();
        time_init();
        sched_clock_postinit();
@@ -641,7 +642,6 @@ asmlinkage void __init start_kernel(void)
=20
        check_bugs();
=20
-       acpi_early_init(); /* before LAPIC and SMP init */
        sfi_init_late();
=20
        if (efi_enabled(EFI_RUNTIME_SERVICES)) {


Thanks a lot!
Joey Lee

--
To unsubscribe from this list: send the line "unsubscribe linux-acpi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
