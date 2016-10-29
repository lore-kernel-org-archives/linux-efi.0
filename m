From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 2/2] MAINTAINERS: add ARM and arm64 EFI specific files to
 EFI subsystem
Date: Sat, 29 Oct 2016 11:09:55 +0100
Message-ID: <CAKv+Gu9B7X3CDVZrxZQFVsn3U2CT0A2Z3Owj7BQuFXPjk5Ln4Q@mail.gmail.com>
References: <1474472114-12973-1-git-send-email-ard.biesheuvel@linaro.org> <1474472114-12973-2-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1474472114-12973-2-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Russell King <rmk+kernel@armlinux.org.uk>
List-Id: linux-efi@vger.kernel.org

On 21 September 2016 at 16:35, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> Since I will be co-maintaining the EFI subsystem, it makes sense to
> mention the ARM and arm64 EFI bits in the EFI section in MAINTAINERS
> so that Matt, the list and I get cc'ed on proposed changes.
>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Russell King <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  MAINTAINERS | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>

Russell,

do you have an objections to this change?

Thanks,
Ard.


> diff --git a/MAINTAINERS b/MAINTAINERS
> index 224518556a84..cc8b36699f94 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4562,12 +4562,14 @@ L:      linux-efi@vger.kernel.org
>  T:     git git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git
>  S:     Maintained
>  F:     Documentation/efi-stub.txt
> -F:     arch/ia64/kernel/efi.c
> +F:     arch/*/kernel/efi.c
>  F:     arch/x86/boot/compressed/eboot.[ch]
> -F:     arch/x86/include/asm/efi.h
> +F:     arch/*/include/asm/efi.h
>  F:     arch/x86/platform/efi/
>  F:     drivers/firmware/efi/
>  F:     include/linux/efi*.h
> +F:     arch/arm/boot/compressed/efi-header.S
> +F:     arch/arm64/kernel/efi-entry.S
>
>  EFI VARIABLE FILESYSTEM
>  M:     Matthew Garrett <matthew.garrett@nebula.com>
> --
> 2.7.4
>
