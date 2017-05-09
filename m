From: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] x86/efi: Correct ident mapping of efi old_map when
 kalsr enabled
Date: Tue, 9 May 2017 11:30:51 +0800
Message-ID: <20170509033051.GD21870@x1>
References: <1493294823-9315-1-git-send-email-bhe@redhat.com>
 <20170505204214.GB5225@codeblueprint.co.uk>
 <20170505233620.eka5md5mmnp4ituz@pd.tnic>
 <CACi5LpOJe+dpJBeuZxm80pd0dX9-V=DQv_R3TDzFmn4Q1XA1SA@mail.gmail.com>
 <20170508013649.GA2315@x1>
 <20170508152514.mc5j3lrhntd3qodj@pd.tnic>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="9jxsPFA5p3P2qPhR"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170508152514.mc5j3lrhntd3qodj-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, Mike Travis <travis-sJ/iWh9BUns@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 05/08/17 at 05:25pm, Borislav Petkov wrote:
> On Mon, May 08, 2017 at 09:36:49AM +0800, Baoquan He wrote:
> > Thanks for explaining, Bhupesh. 
> > 
> > BIOS issue of SGI uv1 is still not fixed. There's a quirk for uv1 to
> > use efi old map:
> > 
> > void __init efi_apply_memmap_quirks(void)
> > {
> > 	...
> > 	...
> >         /* UV2+ BIOS has a fix for this issue.  UV1 still needs the quirk. */
> >         if (dmi_check_system(sgi_uv1_dmi))
> >                 set_bit(EFI_OLD_MEMMAP, &efi.flags);
> > }
> > 
> > And because of some reasons, redhat also need efi old_map now.
> > 
> > Hi Matt,
> > 
> > This v2 patch works on my kvm guest, however there's still problem on
> > SGI system. I will post v3 later after it's handled. So nack this v2
> > patch.
> 
> Please do not top-post, you should know better.
> 
> Can you apply this debug patch and upload full dmesg?

Please check the attachment.

> 
> ---
> diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> index c488625c9712..ca9df6283040 100644
> --- a/arch/x86/platform/efi/efi_64.c
> +++ b/arch/x86/platform/efi/efi_64.c
> @@ -88,9 +88,18 @@ pgd_t * __init efi_call_phys_prolog(void)
>  	n_pgds = DIV_ROUND_UP((max_pfn << PAGE_SHIFT), PGDIR_SIZE);
>  	save_pgd = kmalloc_array(n_pgds, sizeof(*save_pgd), GFP_KERNEL);
>  
> +	pr_info("%s: PAGE_OFFSET: 0x%lx\n", __func__, PAGE_OFFSET);
> +
>  	for (pgd = 0; pgd < n_pgds; pgd++) {
>  		save_pgd[pgd] = *pgd_offset_k(pgd * PGDIR_SIZE);
>  		vaddress = (unsigned long)__va(pgd * PGDIR_SIZE);
> +
> +		pr_info("%s: pgd: 0x%x: va: 0x%lx, 0x%lx -> 0x%lx\n",
> +			__func__, pgd,
> +			vaddress,
> +			pgd_val(*pgd_offset_k(pgd * PGDIR_SIZE)),
> +			pgd_val(*pgd_offset_k(vaddress)));
> +
>  		set_pgd(pgd_offset_k(pgd * PGDIR_SIZE), *pgd_offset_k(vaddress));
>  	}
>  out:
> ---
> 
> Thanks.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Good mailing practices for 400: avoid top-posting and trim the reply.

--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="debug_for_boris.log"
Content-Transfer-Encoding: quoted-printable

[    0.000000] microcode: microcode updated early to revision 0xb00001d, da=
te =3D 2016-06-06
[    0.000000] Linux version 4.11.0+ (root-Je4m6I2aeZBG4dQ6rZ5bwQ9Y35r+6HzyY23lVrIENng@public.gmane.org=
=2Ecom) (gcc version 4.8.5 20150623 (Red Hat 4.8.5-14) (GCC) ) #8 SMP Mon M=
ay 8 20:59:49 EDT 2017
[    0.000000] Command line: BOOT_IMAGE=3D/vmlinuz-4.11.0+ root=3D/dev/mapp=
er/rhel_sgi--uv300--03-root ro add_efi_memmap earlyprintk=3DttyS0,115200n8 =
intel_idle.max_cstate=3D1 loglevel=3D9 nmi_watchdog=3D0 nobau processor.max=
_cstate=3D1 crashkernel=3Dauto rd.lvm.lv=3Drhel_sgi-uv300-03/root rd.lvm.lv=
=3Drhel_sgi-uv300-03/swap console=3DttyS0,115200n8 LANG=3Den_US.UTF-8 efi=
=3Dold_map efi=3Ddebug
[    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point=
 registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    0.000000] x86/fpu: Enabled xstate features 0x7, context size is 832 by=
tes, using 'standard' format.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000051fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000052000-0x000000000005afff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x000000000005b000-0x000000000009ffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000072829fff] usable
[    0.000000] BIOS-e820: [mem 0x000000007282a000-0x000000007282afff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x000000007282b000-0x0000000072837fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000072838000-0x0000000072a77fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000072a78000-0x00000000751fefff] usable
[    0.000000] BIOS-e820: [mem 0x00000000751ff000-0x0000000075efefff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000075eff000-0x0000000076efefff] ACPI =
NVS
[    0.000000] BIOS-e820: [mem 0x0000000076eff000-0x0000000076ffefff] ACPI =
data
[    0.000000] BIOS-e820: [mem 0x0000000076fff000-0x000000007effffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000080000000-0x000000008fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x0000001effffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000002000000000-0x000000207fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000004000000000-0x0000005efeffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000008000000000-0x0000009efeffffff] usable
[    0.000000] BIOS-e820: [mem 0x000000c000000000-0x000000defeffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000ff800000000-0x00000ff803dfffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000ff803f00000-0x00000ff803ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000ff807f00000-0x00000ff807ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000ff80bf00000-0x00000ff80bffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000ff80ff00000-0x00000ff80fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000ffa00000000-0x00000ffa02ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000ffa04000000-0x00000ffa06ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000ffa08000000-0x00000ffa0affffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000ffa0c000000-0x00000ffa0effffff] reser=
ved
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820: update [mem 0x73bf1018-0x73c05c57] usable =3D=3D> usab=
le
[    0.000000] extended physical RAM map:
[    0.000000] reserve setup_data: [mem 0x0000000000000000-0x0000000000051f=
ff] usable
[    0.000000] reserve setup_data: [mem 0x0000000000052000-0x000000000005af=
ff] reserved
[    0.000000] reserve setup_data: [mem 0x000000000005b000-0x000000000009ff=
ff] usable
[    0.000000] reserve setup_data: [mem 0x0000000000100000-0x0000000072829f=
ff] usable
[    0.000000] reserve setup_data: [mem 0x000000007282a000-0x000000007282af=
ff] reserved
[    0.000000] reserve setup_data: [mem 0x000000007282b000-0x0000000072837f=
ff] usable
[    0.000000] reserve setup_data: [mem 0x0000000072838000-0x0000000072a77f=
ff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000072a78000-0x0000000073bf10=
17] usable
[    0.000000] reserve setup_data: [mem 0x0000000073bf1018-0x0000000073c05c=
57] usable
[    0.000000] reserve setup_data: [mem 0x0000000073c05c58-0x00000000751fef=
ff] usable
[    0.000000] reserve setup_data: [mem 0x00000000751ff000-0x0000000075efef=
ff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000075eff000-0x0000000076efef=
ff] ACPI NVS
[    0.000000] reserve setup_data: [mem 0x0000000076eff000-0x0000000076ffef=
ff] ACPI data
[    0.000000] reserve setup_data: [mem 0x0000000076fff000-0x000000007effff=
ff] usable
[    0.000000] reserve setup_data: [mem 0x0000000080000000-0x000000008fffff=
ff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000f8000000-0x00000000fbffff=
ff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000100000000-0x0000001effffff=
ff] usable
[    0.000000] reserve setup_data: [mem 0x0000002000000000-0x000000207fffff=
ff] usable
[    0.000000] reserve setup_data: [mem 0x0000004000000000-0x0000005efeffff=
ff] usable
[    0.000000] reserve setup_data: [mem 0x0000008000000000-0x0000009efeffff=
ff] usable
[    0.000000] reserve setup_data: [mem 0x000000c000000000-0x000000defeffff=
ff] usable
[    0.000000] reserve setup_data: [mem 0x00000ff800000000-0x00000ff803dfff=
ff] reserved
[    0.000000] reserve setup_data: [mem 0x00000ff803f00000-0x00000ff803ffff=
ff] reserved
[    0.000000] reserve setup_data: [mem 0x00000ff807f00000-0x00000ff807ffff=
ff] reserved
[    0.000000] reserve setup_data: [mem 0x00000ff80bf00000-0x00000ff80bffff=
ff] reserved
[    0.000000] reserve setup_data: [mem 0x00000ff80ff00000-0x00000ff80fffff=
ff] reserved
[    0.000000] reserve setup_data: [mem 0x00000ffa00000000-0x00000ffa02ffff=
ff] reserved
[    0.000000] reserve setup_data: [mem 0x00000ffa04000000-0x00000ffa06ffff=
ff] reserved
[    0.000000] reserve setup_data: [mem 0x00000ffa08000000-0x00000ffa0affff=
ff] reserved
[    0.000000] reserve setup_data: [mem 0x00000ffa0c000000-0x00000ffa0effff=
ff] reserved
[    0.000000] efi: EFI v2.40 by EDK II
[    0.000000]                              BIOS ID: 0 BIOS ID:=02
[    0.000000] efi:  SMBIOS=3D0x753f0000  ACPI=3D0x76ffe000  ACPI 2.0=3D0x7=
6ffe014  UVsystab=3D0x753e5000=20
[    0.000000] efi: mem00: [Conventional Memory|   |  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x0000000000000000-0x0000000000000fff] (0MB)
[    0.000000] efi: mem01: [Loader Data        |   |  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x0000000000001000-0x0000000000001fff] (0MB)
[    0.000000] efi: mem02: [Conventional Memory|   |  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x0000000000002000-0x0000000000051fff] (0MB)
[    0.000000] efi: mem03: [Reserved           |   |  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x0000000000052000-0x000000000005afff] (0MB)
[    0.000000] efi: mem04: [Conventional Memory|   |  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x000000000005b000-0x000000000009ffff] (0MB)
[    0.000000] efi: mem05: [Conventional Memory|   |  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x0000000000100000-0x0000000000ffffff] (15MB)
[    0.000000] efi: mem06: [Loader Data        |   |  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x0000000001000000-0x00000000024c5fff] (20MB)
[    0.000000] efi: mem07: [Conventional Memory|   |  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x00000000024c6000-0x000000003d464fff] (943MB)
[    0.000000] efi: mem08: [Loader Data        |   |  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x000000003d465000-0x000000003fffffff] (43MB)
[    0.000000] efi: mem09: [Conventional Memory|   |  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x0000000040000000-0x0000000045c73fff] (92MB)
[    0.000000] efi: mem10: [Loader Data        |   |  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x0000000045c74000-0x00000000601fffff] (421MB)
[    0.000000] efi: mem11: [Boot Data          |   |  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x0000000060200000-0x000000006027ffff] (0MB)
[    0.000000] efi: mem12: [Conventional Memory|   |  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x0000000060280000-0x0000000062764fff] (36MB)
[    0.000000] efi: mem13: [Boot Data          |   |  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x0000000062765000-0x0000000072829fff] (256MB)
[    0.000000] efi: mem14: [Runtime Data       |RUN|  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x000000007282a000-0x000000007282afff] (0MB)
[    0.000000] efi: mem15: [Boot Data          |   |  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x000000007282b000-0x0000000072837fff] (0MB)
[    0.000000] efi: mem16: [Runtime Data       |RUN|  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x0000000072838000-0x0000000072a77fff] (2MB)
[    0.000000] efi: mem17: [Boot Data          |   |  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x0000000072a78000-0x00000000739fafff] (15MB)
[    0.000000] efi: mem18: [Boot Code          |   |  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x00000000739fb000-0x00000000739fbfff] (0MB)
[    0.000000] efi: mem19: [Conventional Memory|   |  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x00000000739fc000-0x0000000073bf0fff] (1MB)
[    0.000000] efi: mem20: [Loader Data        |   |  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x0000000073bf1000-0x0000000073dfefff] (2MB)
[    0.000000] efi: mem21: [Conventional Memory|   |  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x0000000073dff000-0x00000000740acfff] (2MB)
[    0.000000] efi: mem22: [Loader Code        |   |  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x00000000740ad000-0x00000000741fefff] (1MB)
[    0.000000] efi: mem23: [Conventional Memory|   |  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x00000000741ff000-0x0000000074a72fff] (8MB)
[    0.000000] efi: mem24: [Boot Code          |   |  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x0000000074a73000-0x00000000751fefff] (7MB)
[    0.000000] efi: mem25: [Runtime Data       |RUN|  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x00000000751ff000-0x00000000755fefff] (4MB)
[    0.000000] efi: mem26: [Runtime Code       |RUN|  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x00000000755ff000-0x0000000075dfefff] (8MB)
[    0.000000] efi: mem27: [Reserved           |   |  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x0000000075dff000-0x0000000075efefff] (1MB)
[    0.000000] efi: mem28: [ACPI Memory NVS    |   |  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x0000000075eff000-0x0000000076efefff] (16MB)
[    0.000000] efi: mem29: [ACPI Reclaim Memory|   |  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x0000000076eff000-0x0000000076ffefff] (1MB)
[    0.000000] efi: mem30: [Conventional Memory|   |  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x0000000076fff000-0x000000007d302fff] (99MB)
[    0.000000] efi: mem31: [Boot Data          |   |  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x000000007d303000-0x000000007d303fff] (0MB)
[    0.000000] efi: mem32: [Conventional Memory|   |  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x000000007d304000-0x000000007d324fff] (0MB)
[    0.000000] efi: mem33: [Boot Data          |   |  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x000000007d325000-0x000000007effffff] (28MB)
[    0.000000] efi: mem34: [Conventional Memory|   |  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x0000000100000000-0x0000001effffffff] (122880MB)
[    0.000000] efi: mem35: [Conventional Memory|   |  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x0000002000000000-0x000000207fffffff] (2048MB)
[    0.000000] efi: mem36: [Conventional Memory|   |  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x0000004000000000-0x0000005efeffffff] (126960MB)
[    0.000000] efi: mem37: [Conventional Memory|   |  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x0000008000000000-0x0000009efeffffff] (126960MB)
[    0.000000] efi: mem38: [Conventional Memory|   |  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x000000c000000000-0x000000defeffffff] (126960MB)
[    0.000000] efi: mem39: [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   | =
 |  |  |  ] range=3D[0x0000000080000000-0x000000008fffffff] (256MB)
[    0.000000] efi: mem40: [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   | =
 |  |  |UC] range=3D[0x00000000f8000000-0x00000000fbffffff] (64MB)
[    0.000000] efi: mem41: [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   | =
 |  |  |UC] range=3D[0x00000ff800000000-0x00000ff803dfffff] (62MB)
[    0.000000] efi: mem42: [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   | =
 |  |  |UC] range=3D[0x00000ff803f00000-0x00000ff803ffffff] (1MB)
[    0.000000] efi: mem43: [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   | =
 |  |  |UC] range=3D[0x00000ff807f00000-0x00000ff807ffffff] (1MB)
[    0.000000] efi: mem44: [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   | =
 |  |  |UC] range=3D[0x00000ff80bf00000-0x00000ff80bffffff] (1MB)
[    0.000000] efi: mem45: [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   | =
 |  |  |UC] range=3D[0x00000ff80ff00000-0x00000ff80fffffff] (1MB)
[    0.000000] efi: mem46: [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   | =
 |  |  |UC] range=3D[0x00000ffa00000000-0x00000ffa02ffffff] (48MB)
[    0.000000] efi: mem47: [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   | =
 |  |  |UC] range=3D[0x00000ffa04000000-0x00000ffa06ffffff] (48MB)
[    0.000000] efi: mem48: [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   | =
 |  |  |UC] range=3D[0x00000ffa08000000-0x00000ffa0affffff] (48MB)
[    0.000000] efi: mem49: [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   | =
 |  |  |UC] range=3D[0x00000ffa0c000000-0x00000ffa0effffff] (48MB)
[    0.000000] SMBIOS 3.0 present.
[    0.000000] DMI: SGI UV300/UV300, BIOS SGI UV 300 series BIOS 05/25/2016
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xdeff000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-DFFFF write-protect
[    0.000000]   E0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000080000000 mask 3FFF80000000 uncachable
[    0.000000]   1 base 0FF800000000 mask 3FF800000000 uncachable
[    0.000000]   2 base 100000000000 mask 300000000000 uncachable
[    0.000000]   3 base 00007F800000 mask 3FFFFFC00000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- WT=
 =20
Memory KASLR using RDRAND RDTSC...
[    0.000000] e820: last_pfn =3D 0x7f000 max_arch_pfn =3D 0x400000000
[    0.000000] Base memory trampoline at [ffff9469c0099000] 99000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] BRK [0x93e1488000, 0x93e1488fff] PGTABLE
[    0.000000] BRK [0x93e1489000, 0x93e1489fff] PGTABLE
[    0.000000] BRK [0x93e148a000, 0x93e148afff] PGTABLE
[    0.000000] BRK [0x93e148b000, 0x93e148bfff] PGTABLE
[    0.000000] BRK [0x93e148c000, 0x93e148cfff] PGTABLE
[    0.000000] BRK [0x93e148d000, 0x93e148dfff] PGTABLE
[    0.000000] BRK [0x93e148e000, 0x93e148efff] PGTABLE
[    0.000000] BRK [0x93e148f000, 0x93e148ffff] PGTABLE
[    0.000000] BRK [0x93e1490000, 0x93e1490fff] PGTABLE
[    0.000000] BRK [0x93e1491000, 0x93e1491fff] PGTABLE
[    0.000000] BRK [0x93e1492000, 0x93e1492fff] PGTABLE
[    0.000000] BRK [0x93e1493000, 0x93e1493fff] PGTABLE
[    0.000000] Secure boot could not be determined
[    0.000000] RAMDISK: [mem 0x3d465000-0x3fffafff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x0000000076FFE014 000024 (v02 INTEL )
[    0.000000] ACPI: XSDT 0x0000000076FFD0E8 000074 (v01 INTEL  TIANO    00=
000000      01000013)
[    0.000000] ACPI: FACP 0x0000000076FFC000 0000F4 (v04 INTEL  TIANO    00=
000000 MSFT 01000013)
[    0.000000] ACPI: DSDT 0x0000000076FF3000 007857 (v02 INTEL  TIANO    00=
000003 MSFT 01000013)
[    0.000000] ACPI: FACS 0x0000000076EFA000 000040
[    0.000000] ACPI: UEFI 0x0000000076EFC000 00005C (v01 INTEL  RstSataV 00=
000000      00000000)
[    0.000000] ACPI: HPET 0x0000000076FFB000 000038 (v01 INTEL  TIANO    00=
000001 MSFT 01000013)
[    0.000000] ACPI: SLIT 0x0000000076FF1000 00003C (v01 SGI3X  UVL      00=
000002 MSFT 00000001)
[    0.000000] ACPI: APIC 0x0000000076FEF000 000458 (v03 SGI3X  UVL      00=
000002 MSFT 00000001)
[    0.000000] ACPI: SRAT 0x0000000076FED000 000CF8 (v03 SGI3X  UVL      00=
000002 MSFT 00000001)
[    0.000000] ACPI: SSDT 0x0000000076FBF000 02D367 (v02 SGI3X  UVL      00=
000002 MSFT 01000013)
[    0.000000] ACPI: MCFG 0x0000000076FBE000 00007C (v01 SGI3X  UVL      00=
000002 MSFT 00000001)
[    0.000000] ACPI: SPCR 0x0000000076FBD000 000050 (v01                 00=
000000      00000000)
[    0.000000] ACPI: DMAR 0x0000000076FBC000 0000C4 (v01 INTEL  TIANO    00=
000001 MSFT 01000013)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] UV: rev:1 part#:9578 nodeid:0000 n_skt:7 pnmsk:7f pn:0
[    0.000000] UV: apicid_shift:0 apicid_mask:0x1f
[    0.000000] UV: socketid_shift:5 pnode_mask:0x7f
[    0.000000] UV: OEM IDs SGI3X/UVL, System/HUB Types 1/6, uv_apic 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0000 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0002 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0004 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0006 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0008 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x000a -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x000c -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x000e -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0010 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0012 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0014 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0016 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0018 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x001a -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x001c -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x001e -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x0020 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0022 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0024 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0026 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0028 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x002a -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x002c -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x002e -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0030 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0032 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0034 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0036 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0038 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x003a -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x003c -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x003e -> Node 1
[    0.000000] SRAT: PXM 2 -> APIC 0x0040 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x0042 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x0044 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x0046 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x0048 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x004a -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x004c -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x004e -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x0050 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x0052 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x0054 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x0056 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x0058 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x005a -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x005c -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x005e -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x0060 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x0062 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x0064 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x0066 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x0068 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x006a -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x006c -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x006e -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x0070 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x0072 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x0074 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x0076 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x0078 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x007a -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x007c -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x007e -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 0x0001 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0003 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0005 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0007 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0009 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x000b -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x000d -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x000f -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0011 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0013 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0015 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0017 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0019 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x001b -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x001d -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x001f -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x0021 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0023 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0025 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0027 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0029 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x002b -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x002d -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x002f -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0031 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0033 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0035 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0037 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0039 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x003b -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x003d -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x003f -> Node 1
[    0.000000] SRAT: PXM 2 -> APIC 0x0041 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x0043 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x0045 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x0047 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x0049 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x004b -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x004d -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x004f -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x0051 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x0053 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x0055 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x0057 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x0059 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x005b -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x005d -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x005f -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x0061 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x0063 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x0065 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x0067 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x0069 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x006b -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x006d -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x006f -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x0071 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x0073 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x0075 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x0077 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x0079 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x007b -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x007d -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x007f -> Node 3
[    0.000000] ACPI: SRAT: Node 0 PXM 0 [mem 0x00000000-0x7fffffff]
[    0.000000] ACPI: SRAT: Node 0 PXM 0 [mem 0x100000000-0x207fffffff]
[    0.000000] ACPI: SRAT: Node 1 PXM 1 [mem 0x4000000000-0x5fffffffff]
[    0.000000] ACPI: SRAT: Node 2 PXM 2 [mem 0x8000000000-0x9fffffffff]
[    0.000000] ACPI: SRAT: Node 3 PXM 3 [mem 0xc000000000-0xdfffffffff]
[    0.000000] NUMA: Initialized distance table, cnt=3D4
[    0.000000] NUMA: Node 0 [mem 0x00000000-0x7fffffff] + [mem 0x100000000-=
0x207fffffff] -> [mem 0x00000000-0x207fffffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x207ffd5000-0x207fffffff]
[    0.000000] NODE_DATA(1) allocated [mem 0x5efefd5000-0x5efeffffff]
[    0.000000] NODE_DATA(2) allocated [mem 0x9efefd5000-0x9efeffffff]
[    0.000000] NODE_DATA(3) allocated [mem 0xdefefd2000-0xdefeffcfff]
[    0.000000] kexec_core: crashkernel: memory value expected
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x000000defeffffff]
[    0.000000]   Device   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x0000000000051fff]
[    0.000000]   node   0: [mem 0x000000000005b000-0x000000000009ffff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x0000000072829fff]
[    0.000000]   node   0: [mem 0x000000007282b000-0x0000000072837fff]
[    0.000000]   node   0: [mem 0x0000000072a78000-0x00000000751fefff]
[    0.000000]   node   0: [mem 0x0000000076fff000-0x000000007effffff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x0000001effffffff]
[    0.000000]   node   0: [mem 0x0000002000000000-0x000000207fffffff]
[    0.000000]   node   1: [mem 0x0000004000000000-0x0000005efeffffff]
[    0.000000]   node   2: [mem 0x0000008000000000-0x0000009efeffffff]
[    0.000000]   node   3: [mem 0x000000c000000000-0x000000defeffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000207ffff=
fff]
[    0.000000] On node 0 totalpages: 32493397
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 22 pages reserved
[    0.000000]   DMA zone: 3990 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7935 pages used for memmap
[    0.000000]   DMA32 zone: 507839 pages, LIFO batch:31
[    0.000000]   Normal zone: 516096 pages used for memmap
[    0.000000]   Normal zone: 31981568 pages, LIFO batch:31
[    0.000000] Initmem setup node 1 [mem 0x0000004000000000-0x0000005efefff=
fff]
[    0.000000] On node 1 totalpages: 32501760
[    0.000000]   Normal zone: 507840 pages used for memmap
[    0.000000]   Normal zone: 32501760 pages, LIFO batch:31
[    0.000000] Initmem setup node 2 [mem 0x0000008000000000-0x0000009efefff=
fff]
[    0.000000] On node 2 totalpages: 32501760
[    0.000000]   Normal zone: 507840 pages used for memmap
[    0.000000]   Normal zone: 32501760 pages, LIFO batch:31
[    0.000000] Initmem setup node 3 [mem 0x000000c000000000-0x000000defefff=
fff]
[    0.000000] On node 3 totalpages: 32501760
[    0.000000]   Normal zone: 507840 pages used for memmap
[    0.000000]   Normal zone: 32501760 pages, LIFO batch:31
[    0.000000] tboot: non-0 tboot_addr but it is not of type E820_TYPE_RESE=
RVED
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] UV: rev:1 part#:9578 nodeid:0000 n_skt:7 pnmsk:7f pn:0
[    0.000000] UV: apicid_shift:0 apicid_mask:0x1f
[    0.000000] UV: socketid_shift:5 pnode_mask:0x7f
[    0.000000] UV: OEM IDs SGI3X/UVL, System/HUB Types 1/6, uv_apic 0
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-=
23
[    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec01000, GSI 24=
-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] smpboot: Allowing 128 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x00052000-0x0005afff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x7282a000-0x7282afff]
[    0.000000] PM: Registered nosave memory: [mem 0x72838000-0x72a77fff]
[    0.000000] PM: Registered nosave memory: [mem 0x73bf1000-0x73bf1fff]
[    0.000000] PM: Registered nosave memory: [mem 0x73c05000-0x73c05fff]
[    0.000000] PM: Registered nosave memory: [mem 0x751ff000-0x75efefff]
[    0.000000] PM: Registered nosave memory: [mem 0x75eff000-0x76efefff]
[    0.000000] PM: Registered nosave memory: [mem 0x76eff000-0x76ffefff]
[    0.000000] PM: Registered nosave memory: [mem 0x7f000000-0x7fffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x80000000-0x8fffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x90000000-0xf7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xffffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x1f00000000-0x1fffffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x2080000000-0x3fffffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x5eff000000-0x7fffffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x9eff000000-0xbfffffffff]
[    0.000000] e820: [mem 0x90000000-0xf7ffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0=
xffffffff, max_idle_ns: 1910969940391419 ns
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:128 nr_cpu_ids:12=
8 nr_node_ids:4
[    0.000000] percpu: Embedded 38 pages/cpu @ffff9489c3600000 s116376 r819=
2 d31080 u262144
[    0.000000] pcpu-alloc: s116376 r8192 d31080 u262144 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 000 001 002 003 004 005 006 007=20
[    0.000000] pcpu-alloc: [0] 008 009 010 011 012 013 014 015=20
[    0.000000] pcpu-alloc: [0] 064 065 066 067 068 069 070 071=20
[    0.000000] pcpu-alloc: [0] 072 073 074 075 076 077 078 079=20
[    0.000000] pcpu-alloc: [1] 016 017 018 019 020 021 022 023=20
[    0.000000] pcpu-alloc: [1] 024 025 026 027 028 029 030 031=20
[    0.000000] pcpu-alloc: [1] 080 081 082 083 084 085 086 087=20
[    0.000000] pcpu-alloc: [1] 088 089 090 091 092 093 094 095=20
[    0.000000] pcpu-alloc: [2] 032 033 034 035 036 037 038 039=20
[    0.000000] pcpu-alloc: [2] 040 041 042 043 044 045 046 047=20
[    0.000000] pcpu-alloc: [2] 096 097 098 099 100 101 102 103=20
[    0.000000] pcpu-alloc: [2] 104 105 106 107 108 109 110 111=20
[    0.000000] pcpu-alloc: [3] 048 049 050 051 052 053 054 055=20
[    0.000000] pcpu-alloc: [3] 056 057 058 059 060 061 062 063=20
[    0.000000] pcpu-alloc: [3] 112 113 114 115 116 117 118 119=20
[    0.000000] pcpu-alloc: [3] 120 121 122 123 124 125 126 127=20
[    0.000000] Built 4 zonelists in Node order, mobility grouping on.  Tota=
l pages: 127951040
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=3D/vmlinuz-4.11.0+ root=3D/d=
ev/mapper/rhel_sgi--uv300--03-root ro add_efi_memmap earlyprintk=3DttyS0,11=
5200n8 intel_idle.max_cstate=3D1 loglevel=3D9 nmi_watchdog=3D0 nobau proces=
sor.max_cstate=3D1 crashkernel=3Dauto rd.lvm.lv=3Drhel_sgi-uv300-03/root rd=
=2Elvm.lv=3Drhel_sgi-uv300-03/swap console=3DttyS0,115200n8 LANG=3Den_US.UT=
F-8 efi=3Dold_map efi=3Ddebug
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Memory: 10008884K/519994708K available (7546K kernel code, 1=
506K rwdata, 3336K rodata, 2160K init, 2920K bss, 8593352K reserved, 0K cma=
-reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D128,=
 Nodes=3D4
[    0.000000] ftrace: allocating 31399 entries in 123 pages
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	Build-time adjustment of leaf fanout to 64.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=3D8192 to nr_cpu_ids=3D12=
8.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D64, nr_cpu_ids=
=3D128
[    0.000000] NR_IRQS:524544 nr_irqs:1856 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [ttyS0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] mempolicy: Enabling automatic NUMA balancing. Configure with=
 numa_balancing=3D or the kernel.numa_balancing sysctl
[    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, =
max_idle_ns: 133484882848 ns
[    0.000000] hpet clockevent registered
[    0.001000] tsc: Fast TSC calibration using PIT
[    0.002000] tsc: Detected 2099.972 MHz processor
[    0.003000] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 4199.94 BogoMIPS (lpj=3D2099972)
[    0.004003] pid_max: default: 131072 minimum: 1024
[    0.005129] ACPI: Core revision 20170119
[    0.018125] ACPI: 2 ACPI AML tables successfully acquired and loaded
[    0.019151] efi: EFI runtime memory map:
[    0.020008] efi: mem00: [Boot Data          |   |  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x0000000060200000-0x000000006027ffff] (0MB)
[    0.021003] efi: mem01: [Boot Data          |   |  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x0000000062765000-0x0000000072829fff] (256MB)
[    0.022004] efi: mem02: [Runtime Data       |RUN|  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x000000007282a000-0x000000007282afff] (0MB)
[    0.023003] efi: mem03: [Boot Data          |   |  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x000000007282b000-0x0000000072837fff] (0MB)
[    0.024003] efi: mem04: [Runtime Data       |RUN|  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x0000000072838000-0x0000000072a77fff] (2MB)
[    0.025003] efi: mem05: [Boot Data          |   |  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x0000000072a78000-0x00000000739fafff] (15MB)
[    0.026003] efi: mem06: [Boot Code          |   |  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x00000000739fb000-0x00000000739fbfff] (0MB)
[    0.027003] efi: mem07: [Boot Code          |   |  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x0000000074a73000-0x00000000751fefff] (7MB)
[    0.028003] efi: mem08: [Runtime Data       |RUN|  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x00000000751ff000-0x00000000755fefff] (4MB)
[    0.029003] efi: mem09: [Runtime Code       |RUN|  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x00000000755ff000-0x0000000075dfefff] (8MB)
[    0.030003] efi: mem10: [Boot Data          |   |  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x000000007d303000-0x000000007d303fff] (0MB)
[    0.031003] efi: mem11: [Boot Data          |   |  |  |  |  |  |  |   |W=
B|WT|WC|UC] range=3D[0x000000007d325000-0x000000007effffff] (28MB)
[    0.032003] efi: mem12: [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   | =
 |  |  |  ] range=3D[0x0000000080000000-0x000000008fffffff] (256MB)
[    0.033003] efi: mem13: [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   | =
 |  |  |UC] range=3D[0x00000000f8000000-0x00000000fbffffff] (64MB)
[    0.034003] efi: mem14: [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   | =
 |  |  |UC] range=3D[0x00000ff800000000-0x00000ff803dfffff] (62MB)
[    0.035003] efi: mem15: [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   | =
 |  |  |UC] range=3D[0x00000ff803f00000-0x00000ff803ffffff] (1MB)
[    0.036003] efi: mem16: [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   | =
 |  |  |UC] range=3D[0x00000ff807f00000-0x00000ff807ffffff] (1MB)
[    0.037003] efi: mem17: [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   | =
 |  |  |UC] range=3D[0x00000ff80bf00000-0x00000ff80bffffff] (1MB)
[    0.038003] efi: mem18: [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   | =
 |  |  |UC] range=3D[0x00000ff80ff00000-0x00000ff80fffffff] (1MB)
[    0.039003] efi: mem19: [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   | =
 |  |  |UC] range=3D[0x00000ffa00000000-0x00000ffa02ffffff] (48MB)
[    0.040003] efi: mem20: [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   | =
 |  |  |UC] range=3D[0x00000ffa04000000-0x00000ffa06ffffff] (48MB)
[    0.041003] efi: mem21: [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   | =
 |  |  |UC] range=3D[0x00000ffa08000000-0x00000ffa0affffff] (48MB)
[    0.042003] efi: mem22: [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   | =
 |  |  |UC] range=3D[0x00000ffa0c000000-0x00000ffa0effffff] (48MB)
[    0.043139] efi: efi_call_phys_prolog: PAGE_OFFSET: 0xffff9469c0000000
[    0.044003] efi: efi_call_phys_prolog: pgd: 0x0: va: 0xffff9469c0000000,=
 0x0 -> 0x93e1488067
[    0.045002] efi: efi_call_phys_prolog: pgd: 0x1: va: 0xffff94e9c0000000,=
 0x0 -> 0xdefefff067
[    0.046010] BUG: unable to handle kernel paging request at 0000000075dc4=
850
[    0.047000] IP: 0x75dc4850
[    0.047000] PGD 93e1488067=20
[    0.047000] P4D 93e1488067=20
[    0.047000] PUD 0=20
[    0.047000]=20
[    0.047000] Oops: 0010 [#1] SMP
[    0.047000] Modules linked in:
[    0.047000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.11.0+ #8
[    0.047000] Hardware name: SGI UV300/UV300, BIOS SGI UV 300 series BIOS =
05/25/2016
[    0.047000] task: ffffffff9a0104c0 task.stack: ffffffff9a000000
[    0.047000] RIP: 0010:0x75dc4850
[    0.047000] RSP: 0000:ffffffff9a003d98 EFLAGS: 00010086
[    0.047000] RAX: ffff9548befcc000 RBX: 000000c07fc22000 RCX: 00000000000=
00450
[    0.047000] RDX: 0000000000000030 RSI: 0000000000000450 RDI: 0000000075d=
c4850
[    0.047000] RBP: ffffffff9a003e40 R08: 0000000000000001 R09: 000000c07fc=
22000
[    0.047000] R10: 65647830203e2d20 R11: 3736306666666566 R12: 00000000000=
00030
[    0.047000] R13: 0000000000000246 R14: ffff946b3fcb0ce0 R15: 00000000000=
00450
[    0.047000] FS:  0000000000000000(0000) GS:ffff9489c3600000(0000) knlGS:=
0000000000000000
[    0.047000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.047000] CR2: 0000000075dc4850 CR3: 00000093e0e09000 CR4: 00000000000=
406b0
[    0.047000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[    0.047000] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[    0.047000] Call Trace:
[    0.047000]  ? efi_call+0x58/0x90
[    0.047000]  ? vprintk_func+0x20/0x50
[    0.047000]  ? printk+0x58/0x6f
[    0.047000]  efi_enter_virtual_mode+0x3ca/0x512
[    0.047000]  start_kernel+0x424/0x4c8
[    0.047000]  ? set_init_arg+0x5a/0x5a
[    0.047000]  ? early_idt_handler_array+0x120/0x120
[    0.047000]  x86_64_start_reservations+0x29/0x2b
[    0.047000]  x86_64_start_kernel+0x151/0x174
[    0.047000]  secondary_startup_64+0x9f/0x9f
[    0.047000] Code:  Bad RIP value.
[    0.047000] RIP: 0x75dc4850 RSP: ffffffff9a003d98
[    0.047000] CR2: 0000000075dc4850
[    0.047000] ---[ end trace 5f12edd1f8c1b98e ]---
[    0.047000] Kernel panic - not syncing: Fatal exception
[    0.047000] ---[ end Kernel panic - not syncing: Fatal exception

--9jxsPFA5p3P2qPhR--
