From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [BUG] x86/efi: MMRs no longer properly mapped after switch to
 isolated page table
Date: Mon, 2 May 2016 12:02:22 +0200
Message-ID: <20160502100222.GB25669@pd.tnic>
References: <20160427154132.GB113599@stormcage.americas.sgi.com>
 <20160427225122.GG21282@pd.tnic>
 <20160428014128.GF113599@stormcage.americas.sgi.com>
 <20160428125711.GB9164@pd.tnic>
 <20160429154119.GI113599@stormcage.americas.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160429154119.GI113599-7ppMa7wkY9tKToyKb8PD+Zs2JHu2awxn0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, mike travis <travis-sJ/iWh9BUns@public.gmane.org>, Nathan Zimmer <nzimmer-sJ/iWh9BUns@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Apr 29, 2016 at 10:41:19AM -0500, Alex Thorlton wrote:
> I think this is partially correct, but in doing that, we find that we=
're
> still missing something.  Watch what happens when I make this small
> tweak to my kernel:
>=20
> 8<---
> diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c
> b/arch/x86/kernel/apic/x2apic_uv_x.c
> index 624db005..91ac029 100644
> --- a/arch/x86/kernel/apic/x2apic_uv_x.c
> +++ b/arch/x86/kernel/apic/x2apic_uv_x.c
> @@ -891,7 +891,7 @@ void __init uv_system_init(void)
>         pr_info("UV: Found %s hub\n", hub);
> =20
>         /* We now only need to map the MMRs on UV1 */
> -       if (is_uv1_hub())
> +       //if (is_uv1_hub())
>                 map_low_mmrs();
> =20
>         m_n_config.v =3D uv_read_local_mmr(UVH_RH_GAM_CONFIG_MMR );
> --->8
>=20
> Here's the result:
>=20
> 8<---
> [    5.353656] BUG: unable to handle kernel paging request at ffff880=
06a1ab938
> [    5.361448] IP: [<ffff88006a1ab938>] 0xffff88006a1ab938
> [    5.367290] PGD 1f81067 PUD 87ffff067 PMD 87fff8067 PTE 0
> [    5.373356] Oops: 0010 [#1] SMP=20
> [    5.376977] Modules linked in:
> [    5.380395] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.5.0-rc2-uv=
4-comm-debug-fix+ #538
> [    5.389428] Hardware name: SGI UV3000/UV3000, BIOS SGI UV 3000 ser=
ies BIOS 01/15/2015
> [    5.398169] task: ffff880867ec4040 ti: ffff880867ec8000 task.ti: f=
fff880867ec8000
> [    5.406522] RIP: 0010:[<ffff88006a1ab938>]  [<ffff88006a1ab938>] 0=
xffff88006a1ab938
> [    5.415080] RSP: 0000:ffff880867ecbc88  EFLAGS: 00010086
> [    5.421006] RAX: 0000000000000000 RBX: 0000000000000282 RCX: 00000=
00000000001
> [    5.428971] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8=
8006a1ab938
> [    5.436935] RBP: ffff880867ecbd58 R08: ffff880867ecbd68 R09: ffff8=
80867ecbd70
> [    5.444900] R10: ffffffffffffffda R11: 000000006a1ab938 R12: 00000=
00000000000
> [    5.452864] R13: ffffffff81dcf0b8 R14: ffffffff81dcf0c0 R15: fffff=
fff81dcf0a0
> [    5.460829] FS:  0000000000000000(0000) GS:ffff880878c00000(0000) =
knlGS:0000000000000000
> [    5.469861] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    5.476274] CR2: ffff88006a1ab938 CR3: 0000000001a0a000 CR4: 00000=
000001406f0
> [    5.484240] Stack:
> [    5.486483]  ffffffff8105d7f8 0000000000000000 0000000000000006 00=
00000000000006
> [    5.494777]  000000000000001e 0000000000000000 0000000000000000 ff=
ff880867ecbd38
> [    5.503074]  0000000080050033 0000000000000000 0000000000000000 00=
00000000000000
> [    5.511368] Call Trace:
> [    5.514098]  [<ffffffff8105d7f8>] ? efi_call+0x58/0x90
> [    5.519834]  [<ffffffff8106033d>] ? uv_bios_call_irqsave+0x5d/0x80
> [    5.526733]  [<ffffffff810603a0>] uv_bios_get_sn_info+0x40/0xb0
> [    5.533344]  [<ffffffff81b6f824>] uv_system_init+0x772/0x104d
> [    5.539751]  [<ffffffff810bd479>] ? vprintk_default+0x29/0x40
> [    5.546159]  [<ffffffff81161cf8>] ? printk+0x4d/0x4f
> [    5.551692]  [<ffffffff81b6ac75>] native_smp_prepare_cpus+0x299/0x=
2e4
> [    5.558884]  [<ffffffff81b5c18e>] kernel_init_freeable+0xc3/0x21b
> [    5.565680]  [<ffffffff815acd00>] ? rest_init+0x80/0x80
> [    5.571502]  [<ffffffff815acd0e>] kernel_init+0xe/0xf0
> [    5.577238]  [<ffffffff815b87cf>] ret_from_fork+0x3f/0x70
> [    5.583264]  [<ffffffff815acd00>] ? rest_init+0x80/0x80
> [    5.589093] Code:  Bad RIP value.
> [    5.592812] RIP  [<ffff88006a1ab938>] 0xffff88006a1ab938
> [    5.598748]  RSP <ffff880867ecbc88>
> [    5.602638] CR2: ffff88006a1ab938
> [    5.606339] ---[ end trace 3abaacb020c74a50 ]---
> [    5.611487] Kernel panic - not syncing: Attempted to kill init! ex=
itcode=3D0x00000009
> --->8
>=20
> You can see here that we've made it past the MMR read in uv_system_in=
it,
> but we die inside of our first EFI callback.  In this example, it loo=
ks
> like we're using the kernel page table at the time of the failure, an=
d I
> believe that the failing address is somewhere in our EFI runtime code=
:

I think I see what's going on:

[    5.367290] PGD 1f81067 PUD 87ffff067 PMD 87fff8067 PTE 0

PTE 0 because, most probably, you need to sync
efi_sync_low_kernel_mappings(). Why?

So the point of time this call is done, is, IINM, after we have
enabled virtual mode. I.e., it is being done in start_kernel() and
your callstack points at rest_init() which happens later in that same
function.

So IMO what you should be doing, instead, is doing efi_call_virt() in
uv_bios_call() which should take care of everything.

I think this naked efi_call() in uv_bios_call() should not be there
but UV should be calling the _phys or _virt helpers from the EFI core.

Preferrably someone should go and audit all those EFI calls in UV and
figure out which one to use, _phys or _virt depending on the point in
time this call is being done.

=46or example, uv_system_init() should all be _virt calls, obviously.
And from a quick scan, most of the EFI calls are coming from there so
everything should be _virt.

Btw, uv_bios_call_reentrant() looks unused, might want to remove it
while at it.

Hmmm.

--=20
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Nort=
on, HRB 21284 (AG N=C3=BCrnberg)
--=20
