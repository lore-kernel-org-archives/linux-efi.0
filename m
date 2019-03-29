From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [GIT PULL 0/5] EFI changes for v5.2
Date: Fri, 29 Mar 2019 07:35:56 +0100
Message-ID: <20190329063556.GA57868@gmail.com>
References: <20190328193429.21373-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190328193429.21373-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, Jean Delvare <jdelvare@suse.de>, Marcin Benka <mbenka@marvell.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Nick Desaulniers <ndesaulniers@google.com>, Peter Jones <pjones@redhat.com>, Robert Richter <rrichter@marvell.com>, Takashi Iwai <tiwai@suse.de>
List-Id: linux-efi@vger.kernel.org


* Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> The following changes since commit 8c2ffd9174779014c3fe1f96d9dc3641d9175f00:
> 
>   Linux 5.1-rc2 (2019-03-24 14:02:26 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-next
> 
> for you to fetch changes up to a72f65180feb446cc59616aab400475679b6ffce:
> 
>   efi/libstub/arm: omit unneeded stripping of ksymtab/kcrctab sections (2019-03-28 09:22:32 +0100)
> 
> ----------------------------------------------------------------
> EFI updates for v5.2:
> - Squash a spurious warning when using the EFI framebuffer on a non-EFI boot.
> - Use DMI data to annotate RAS memory errors on ARM just like we do on Intel.
> - Some followup cleanups for DMI.
> - Some libstub Makefile cleanups.
> 
> ----------------------------------------------------------------
> Ard Biesheuvel (2):
>       efifb: omit memory map check on legacy boot
>       efi/libstub/arm: omit unneeded stripping of ksymtab/kcrctab sections
> 
> Marcin Benka (1):
>       efi/arm: Show SMBIOS bank/device location in cper and ghes error logs
> 
> Masahiro Yamada (1):
>       efi/libstub: refactor cmd_stubcopy
> 
> Robert Richter (1):
>       efi: Unify dmi setup code over architectures arm/arm64, ia64 and x86
> 
>  arch/ia64/kernel/setup.c              |  4 +---
>  arch/x86/kernel/setup.c               |  6 ++----
>  drivers/firmware/dmi_scan.c           | 28 +++++++++++++++-------------
>  drivers/firmware/efi/arm-runtime.c    |  6 ++----
>  drivers/firmware/efi/libstub/Makefile | 14 +++++++-------
>  drivers/video/fbdev/efifb.c           |  3 ++-
>  include/linux/dmi.h                   |  8 ++------
>  7 files changed, 31 insertions(+), 38 deletions(-)

Applied to tip:efi/core, thanks a lot Ard!

	Ingo
