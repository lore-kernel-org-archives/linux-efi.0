From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/7] ARM: efi: PE/COFF cleanup/hardening
Date: Wed, 21 Jun 2017 14:20:13 +0200
Message-ID: <CAKv+Gu86ceMjb0oVWCSMC8V+BJ0D7nFFiRSSEk6bk4wfJKS2rQ@mail.gmail.com>
References: <20170530183647.28557-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170530183647.28557-1-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 30 May 2017 at 20:36, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> This is the ARM counterpart of the changes now in v4.12 to clean up
> the PE/COFF header that makes the kernel zImage loadable directly from
> UEFI, and to enhance it with hardening and debug features.
>
> First of all, the cleanup consists of making the header comply with the
> PE/COFF spec (#1), removing the .reloc section (#2) and replacing all
> open coded constants with #defines from linux/pe.h
>
> Patch #4 is a standalone patch that removes ksymtab/kcrctab sections that
> may get pulled in inadvertently when the decompressor is built with EFI
> support. Note that these sections are tiny and harmless by themselves, but
> the linker may dump them in unexpected places if they are not placed
> explicitly, which may interfere with the image layout. This is especially
> important when signing zImages for UEFI secure boot.
>
> Patch #5 changes the description of the decompressor in memory, so that the
> UEFI firmware can apply strict ro/nx protections, resulting in a more secure
> execution environment for the UEFI stub.
>
> Patch #6 splits the decompressor .start and .text output sections, so that
> the ELF view aligns with the PE/COFF view of the binary. This is useful for
> debugging, but has no other benefits (or downsides, for that matter)
>
> Patch #7 enhances the decompressor binary with a NB10 Codeview debug entry
> referring to the path to arch/arm/boot/compressed/vmlinux on the build host.
> This is another debug feature that allows seamless source level single step
> debugging of the UEFI stub while executing in the context of the firmware.
>
> Ard Biesheuvel (7):
>   arm: efi: remove forbidden values from the PE/COFF header
>   arm: efi: remove pointless dummy .reloc section

If nobody objects, I am going to queue these first 2 for v4.13. The
remaining ones need acks and/or need to be rebased once v4.13-rc1 is
out, but I've been sitting on these for a while now, so I'd like to
have some movement here.

-- 
Ard.


>   arm: efi: replace open coded constants with symbolic ones
>   arm: compressed: discard ksymtab/kcrctab sections
>   arm: efi: split zImage code and data into separate PE/COFF sections
>   arm: compressed: put zImage header and EFI header in dedicated section
>   arm: efi: add PE/COFF debug table to EFI header
>
>  arch/arm/boot/compressed/Makefile      |   4 +
>  arch/arm/boot/compressed/efi-header.S  | 247 ++++++++++++--------
>  arch/arm/boot/compressed/vmlinux.lds.S |  39 +++-
>  3 files changed, 180 insertions(+), 110 deletions(-)
>
> --
> 2.9.3
>
