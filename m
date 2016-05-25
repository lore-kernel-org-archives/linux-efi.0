From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] arm64/efi: remove spurious WARN_ON for !4K kernels
Date: Wed, 25 May 2016 17:23:01 +0200
Message-ID: <BA565A9C-8CC0-42E4-9821-7941852F835A@linaro.org>
References: <1464189116-30898-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464189116-30898-1-git-send-email-mark.rutland-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org



> On 25 mei 2016, at 17:11, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
>=20
> Since commit 1fd55a9a09b0293a ("arm64/efi: Apply strict permissions t=
o
> UEFI Runtime Services regions"), booting a !4K page kernel results in=
 a
> boot-time splat on some systems, due to to a WARN_ONCE added in that
> commit which fires if the base address of an EFI memory descriptor is
> not aligned to the kernel page size (which might be 4K, 16K, or 64K).
>=20
> On page 38 of the UEFI 2.6 specification it is stated:
>=20
>    If a 64KiB physical page contains any 4KiB page with any of the
>    following types listed below, then all 4KiB pages in the 64KiB
>    page must use identical ARM Memory Page Attributes (as described
>    in Table 8):
>    =E2=80=94 EfiRuntimeServicesCode
>    =E2=80=94 EfiRuntimeServicesData
>    =E2=80=94 EfiReserved
>    =E2=80=94 EfiACPIMemoryNVS
>    Mixed attribute mappings within a larger page are not allowed.
>=20

The same section mentions that the ro/xp etc attributes are unused on a=
rm, so if we go by the letter here, we need to remove those memory prot=
ection features entirely. So a spec update is clearly in order here.

That still means the patch is correct, of course ...

> On page 158 of the UEFI 2.6 specification, in the description of a
> memory descriptor, the PhysicalStart and VirtualStart fields are
> mandated as being 4K aligned, with NumberOfPages describing the numbe=
r
> of 4K pages in the region.
>=20
> No further restriction on alignment is provided in the UEFI
> specification, neither generically nor in a rule specific to AArch64.
>=20
> So while attributes within a naturally-aligned 64K region must be
> consistent across memory descriptors, the regions described by those
> descriptors are not mandated to be 64K aligned.
>=20
> Not being able to apply strict permissions is sub-optimal, and worthy=
 of
> some notice, but it is not helpful to erroneously suggest that firmwa=
re
> is buggy, nor is it beneficial to have a noisy backtrace at boot time=
=2E
>=20
> This patch downgrades the WARN_ONCE to a pr_warn_once, and re-words t=
he
> message to also describe the implication of the insufficient alignmen=
t.
>=20
> Signed-off-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
> Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>=20
> Cc: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
> Cc: Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>
> Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
> Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
> arch/arm64/kernel/efi.c | 5 +++--
> 1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> index 78f5248..95e748e 100644
> --- a/arch/arm64/kernel/efi.c
> +++ b/arch/arm64/kernel/efi.c
> @@ -30,14 +30,15 @@ static __init pteval_t create_mapping_protection(=
efi_memory_desc_t *md)
>    if (type =3D=3D EFI_MEMORY_MAPPED_IO)
>        return PROT_DEVICE_nGnRE;
>=20
> -    if (WARN_ONCE(!PAGE_ALIGNED(md->phys_addr),
> -              "UEFI Runtime regions are not aligned to 64 KB -- bugg=
y firmware?"))
> +    if (!PAGE_ALIGNED(md->phys_addr)) {
> +        pr_warn_once("UEFI Runtime regions insufficiently aligned fo=
r strict permissions\n");
>        /*
>         * If the region is not aligned to the page size of the OS, we
>         * can not use strict permissions, since that would also affec=
t
>         * the mapping attributes of the adjacent regions.
>         */
>        return pgprot_val(PAGE_KERNEL_EXEC);
> +    }
>=20
>    /* R-- */
>    if ((attr & (EFI_MEMORY_XP | EFI_MEMORY_RO)) =3D=3D
> --=20
> 1.9.1
>=20
