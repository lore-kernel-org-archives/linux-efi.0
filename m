From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [edk2] Corrupted EFI region
Date: Thu, 8 Aug 2013 17:02:49 +0200
Message-ID: <20130808150249.GB27974@pd.tnic>
References: <51FFC19A.1020204@redhat.com>
 <20130805161247.GF31845@pd.tnic>
 <51FFD5B0.9080000@redhat.com>
 <20130805164731.GG31845@pd.tnic>
 <52001896.1030509@redhat.com>
 <20130805220808.GC14067@pd.tnic>
 <20130806141036.GD14891@pd.tnic>
 <520116D1.2010000@redhat.com>
 <20130807151935.GJ17920@pd.tnic>
 <5202889C.2080608@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5202889C.2080608-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: edk2-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Gleb Natapov <gleb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, "Jordan Justen (Intel address)" <jordan.l.justen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Aug 07, 2013 at 07:49:16PM +0200, Laszlo Ersek wrote:

[=E2=80=A6]

> Now, lines 01 to 05 *do not happen*.
>
> More precisely, they don't happen in the kernel. They happen in the
> firmware. Specifically, "OvmfPkg/Library/LoadLinuxLib/Linux.c".
>
> You're booting the kernel from the qemu command line. The kernel you
> run is also an "[o]ld kernel[] without EFI handover protocol". So wha=
t
> happens is, OVMF downloads the kernel image from qemu over fw_cfg,
> figures it's an old kernel...

Right, I think this is easier than having to go into the EFI shell each
time and run bzImage.efi. Unless there's a faster way to do that along
with passing it kernel command line parameters...

[=E2=80=A6]

> In one sentence, efi_memblock_x86_reserve_range() expects that
> "boot_params.efi_info->efi_memmap" has been allocated as "loader data=
"
> (by whomever), but SetupLinuxMemmap() violates this by allocating the
> storage as "boot services data".
>
> This leads to double reservation attempts between
> efi_memblock_x86_reserve_range(), and efi_reserve_boot_services().

Ok, this makes sense.

> The attached edk2 patch should fix it. Please confirm.
>=20
> Thanks,
> Laszlo
>=20

> From 4a9e1f10fa2d06496f1983c25c47c6a1373d2f42 Mon Sep 17 00:00:00 200=
1
> From: Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Date: Wed, 7 Aug 2013 19:39:30 +0200
> Subject: [PATCH] OvmfPkg: allocate the EFI memory map for Linux as Lo=
ader Data
>=20
> In Linux, efi_memblock_x86_reserve_range() and efi_reserve_boot_servi=
ces()
> expect that whoever allocates the EFI memmap allocates it in Loader D=
ata
> type memory. Linux's own exit_boot()-->low_alloc() complies, but
> SetupLinuxMemmap() in LoadLinuxLib doesn't.
>=20
> The memory type discrepancy leads to efi_memblock_x86_reserve_range()=
 and
> efi_reserve_boot_services() both trying to reserve the range backing =
the
> memmap, resulting in memmap entry truncation in
> efi_reserve_boot_services().
>=20
> This fix also makes this allocation consistent with all other persist=
ent
> allocations in  "OvmfPkg/Library/LoadLinuxLib/Linux.c".
>=20
> Contributed-under: TianoCore Contribution Agreement 1.0
>=20
> Signed-off-by: Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Reported-and-tested-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>

Great, thanks for this.

I guess we got that out of the way too. I finally can concentrate on my
patches again :-)

--=20
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
