From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 0/4] x86/xen/efi: Initialize UEFI secure boot state during
 dom0 boot
Date: Thu, 11 Jan 2018 12:51:07 +0000
Message-ID: <CAKv+Gu-_SHXCkfX5d3R08nW6rc4giR1d4VhDjF8J5miaTfSDow@mail.gmail.com>
References: <1515507745-17391-1-git-send-email-daniel.kiper@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1515507745-17391-1-git-send-email-daniel.kiper@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Kiper <daniel.kiper@oracle.com>, Ingo Molnar <mingo@redhat.com>
Cc: linux-efi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, xen-devel <xen-devel@lists.xenproject.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, "H. Peter Anvin" <hpa@zytor.com>, Juergen Gross <jgross@suse.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-efi@vger.kernel.org

On 9 January 2018 at 14:22, Daniel Kiper <daniel.kiper@oracle.com> wrote:
> Hi,
>
> Initialize UEFI secure boot state during dom0 boot. Otherwise the kernel
> may not even know that it runs on secure boot enabled platform.
>

Hi Daniel,

I must say, I am not too thrilled with the approach you have chosen
here. #including .c files in other .c files, and using #defines to
override C functions or other stub functionality is rather fragile. In
particular, it means we have to start caring about not breaking
Xen/x86 code when making modifications to the EFI stub, and that code
is already difficult enough to maintain, given that it is shared
between ARM, arm64 and x86, and runs either from the decompressor or
the kernel proper (arm64) but in the context of the UEFI firmware.
None of the stub code currently runs in ordinary kernel context.

So please, could you try to find another way to do this?

Thanks,
Ard.


>
>  arch/x86/xen/Makefile                          |    4 +++-
>  arch/x86/xen/efi.c                             |   14 +++++++++++++
>  drivers/firmware/efi/libstub/secureboot-core.c |   77 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/firmware/efi/libstub/secureboot.c      |   66 +++++------------------------------------------------------
>  4 files changed, 99 insertions(+), 62 deletions(-)
>
> Daniel Kiper (4):
>       efi/stub: Extract efi_get_secureboot() to separate file
>       x86/xen/efi: Initialize boot_params.secure_boot in xen_efi_init()
>       efi: Tweak efi_get_secureboot() and its data section assignment
>       efi: Rename efi_get_secureboot() to __efi_get_secureboot() and make it static
>
