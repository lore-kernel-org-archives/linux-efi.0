From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [GIT PULL] urgent EFI fix for v4.9
Date: Wed, 19 Oct 2016 14:51:20 +0200
Message-ID: <20161019125120.GA4593@gmail.com>
References: <1476805991-7160-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1476805991-7160-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org


* Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> Please merge the single fix below: it addresses a build issue on ARM with
> less recent toolchain versions, which surfaced now that EFI has been added
> to multi_v7_defconfig, the de facto generic defconfig for the most recent
> cores.
> 
> The following changes since commit b67be92feb486f800d80d72c67fd87b47b79b18e:
> 
>   Merge tag 'pwm/for-4.9-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/thierry.reding/linux-pwm (2016-10-12 11:11:05 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-urgent
> 
> for you to fetch changes up to 0d5b726f1009d05657ec71c716ba6529dcc98d2b:
> 
>   efi/arm: Fix absolute relocation detection for older toolchains (2016-10-14 10:57:59 +0100)
> 
> ----------------------------------------------------------------
> * Fix a build issue in the ARM version of libstub with slightly older
>   toolchains
> 
> ----------------------------------------------------------------
> Ard Biesheuvel (1):
>       efi/arm: Fix absolute relocation detection for older toolchains
> 
>  drivers/firmware/efi/libstub/Makefile | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Applied, thanks Ard!

	Ingo
