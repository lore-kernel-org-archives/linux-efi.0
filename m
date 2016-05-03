From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [BUG] x86/efi: MMRs no longer properly mapped after switch to
 isolated page table
Date: Tue, 3 May 2016 11:48:20 +0200
Message-ID: <20160503094820.GA27503@pd.tnic>
References: <20160427154132.GB113599@stormcage.americas.sgi.com>
 <20160427225122.GG21282@pd.tnic>
 <20160428014128.GF113599@stormcage.americas.sgi.com>
 <20160428125711.GB9164@pd.tnic>
 <20160429154119.GI113599@stormcage.americas.sgi.com>
 <20160502100222.GB25669@pd.tnic>
 <20160502222719.GW113599@stormcage.americas.sgi.com>
 <20160503001036.GX113599@stormcage.americas.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160503001036.GX113599-7ppMa7wkY9tKToyKb8PD+Zs2JHu2awxn0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, mike travis <travis-sJ/iWh9BUns@public.gmane.org>, Nathan Zimmer <nzimmer-sJ/iWh9BUns@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, May 02, 2016 at 07:10:36PM -0500, Alex Thorlton wrote:
> +#define uv_call_virt(f, args...) \
> +({                                                                  =
   \
> +       efi_status_t __s;                                            =
   \
> +       kernel_fpu_begin();                                          =
   \
> +       __s =3D ((efi_##f##_t __attribute__((regparm(0)))*)          =
     \
> +               f)(args);                                            =
   \
> +       kernel_fpu_end();                                            =
   \
> +       __s;                                                         =
   \
> +})

Right, can you use the EFI-ones in
drivers/firmware/efi/runtime-wrappers.c directly?

 (So they're going to land there, I'm staring at latest -tip and those =
calls
  have become all fancy now:

#define efi_call_virt(f, args...)                                      =
 \
({                                                                     =
 \
        efi_status_t __s;                                              =
 \
        unsigned long flags;                                           =
 \
        arch_efi_call_virt_setup();                                    =
 \
        local_save_flags(flags);                                       =
 \
        __s =3D arch_efi_call_virt(f, args);                           =
   \
        efi_call_virt_check_flags(flags, __stringify(f));              =
 \
        arch_efi_call_virt_teardown();                                 =
 \
        __s;                                                           =
 \
})

with efi_call_virt_check_flags() checking for IRQ flags corruption... A=
nd so
on, but that's beside the point... )

> +
>  /* Use this macro if your virtual call does not return any value */
>  #define __efi_call_virt(f, args...) \
>  ({                                                                  =
   \
> @@ -104,6 +114,32 @@ struct efi_scratch {
>         __s;                                                         =
   \
>  })
> =20
> +#define uv_call_virt(f, ...)                                        =
   \
> +({                                                                  =
   \
> +       efi_status_t __s;                                            =
   \
> +                                                                    =
   \
> +       efi_sync_low_kernel_mappings();                              =
   \
> +       preempt_disable();                                           =
   \
> +       __kernel_fpu_begin();                                        =
   \
> +                                                                    =
   \
> +       if (efi_scratch.use_pgd) {                                   =
   \
> +               efi_scratch.prev_cr3 =3D read_cr3();                 =
     \
> +               write_cr3((unsigned long)efi_scratch.efi_pgt);       =
   \
> +               __flush_tlb_all();                                   =
   \
> +       }                                                            =
   \
> +                                                                    =
   \
> +       __s =3D efi_call((void *)f, __VA_ARGS__); \
> +                                                                    =
   \
> +       if (efi_scratch.use_pgd) {                                   =
   \
> +               write_cr3(efi_scratch.prev_cr3);                     =
   \
> +               __flush_tlb_all();                                   =
   \
> +       }                                                            =
   \
> +                                                                    =
   \
> +       __kernel_fpu_end();                                          =
   \
> +       preempt_enable();                                            =
   \
> +       __s;                                                         =
   \
> +})
> +
>  /*
>   * All X86_64 virt calls return non-void values. Thus, use non-void =
call for
>   * virt calls that would be void on X86_32.
>=20
> diff --git a/arch/x86/platform/uv/bios_uv.c b/arch/x86/platform/uv/bi=
os_uv.c
> index 1584cbe..6e99f81 100644
> --- a/arch/x86/platform/uv/bios_uv.c
> +++ b/arch/x86/platform/uv/bios_uv.c
> @@ -39,8 +39,8 @@ s64 uv_bios_call(enum uv_bios_cmd which, u64 a1, u6=
4 a2, u64 a3, u64 a4, u64 a5)
>                  */
>                 return BIOS_STATUS_UNIMPLEMENTED;
> =20
> -       ret =3D efi_call((void *)__va(tab->function), (u64)which,
> -                       a1, a2, a3, a4, a5);
> +       ret =3D uv_call_virt(tab->function, (u64)which, a1, a2, a3, a=
4, a5);
> +

That could be simply

		efi_call_virt(tab->function, ...)

methinks.

>         return ret;
>  }
>  EXPORT_SYMBOL_GPL(uv_bios_call);
> --->8
>=20
> Note that the only change I made to efi_call_virt was to change
> efi.systab->runtime->f to simply f in the efi_call line.  This works =
up
> until we try to do callbacks from a loaded module.  When we try that =
we
> hit this:
>=20
> [   56.232086] BUG: unable to handle kernel paging request at fffffff=
f8106148f
> [   56.239880] IP: [<fffffffedbb408ce>] 0xfffffffedbb408ce
> [   56.245721] PGD 8698e0067 PUD 1a08063 PMD 10001e1=20

PMD looks ok to me.

Have you tried CONFIG_EFI_PGT_DUMP ? It will dump to dmesg so you might
be able to spot stuff.

Also, you could dump them from debugfs *right* before loading the modul=
e
and then look at stuff.

Also 2, booting with efi=3Ddebug should give you how the EFI regions ge=
t
mapped.

=2E..

> The bad paging request here appears to be on the:
>=20
> if (efi_scratch.use_pgd)
>=20
> Line of uv_call_virt.  It looks like it's having trouble accessing th=
e
> efi_scratch struct using the EFI page table.  I'm not sure why this
> is an issue with callbacks from modules and not with the ones in
> uv_system_init and friends.

Just this one module or all modules doing EFI calls?

> I'll keep investigating the module issue.  Looks like we're getting
> closer to sorting this out!
>=20
> Let me know if you have thoughts about the way I'm getting stuff
> working.  I'm thinking there's probably a better way to do this than =
by
> copying the whole efi_call_virt macro - this was a quick and dirty
> solution.

Yeah, try using the generic facilities. We should be able to accomodate
all users...

HTH.

--=20
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Nort=
on, HRB 21284 (AG N=C3=BCrnberg)
--=20
