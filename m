From: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH] arm64/efi: remove spurious WARN_ON for !4K kernels
Date: Wed, 25 May 2016 16:31:33 +0100
Message-ID: <20160525153133.GI5996@e104818-lin.cambridge.arm.com>
References: <1464189116-30898-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1464189116-30898-1-git-send-email-mark.rutland-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, May 25, 2016 at 04:11:56PM +0100, Mark Rutland wrote:
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
> 	If a 64KiB physical page contains any 4KiB page with any of the
> 	following types listed below, then all 4KiB pages in the 64KiB
> 	page must use identical ARM Memory Page Attributes (as described
> 	in Table 8):
> 	=E2=80=94 EfiRuntimeServicesCode
> 	=E2=80=94 EfiRuntimeServicesData
> 	=E2=80=94 EfiReserved
> 	=E2=80=94 EfiACPIMemoryNVS
> 	Mixed attribute mappings within a larger page are not allowed.
>=20
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

Acked-by: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>

Not sure how this will go in (Matt or Will?).
