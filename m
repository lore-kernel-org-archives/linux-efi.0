From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [GIT PULL 0/2] EFI updates for v4.15
Date: Tue, 26 Dec 2017 10:40:38 +0000
Message-ID: <CAKv+Gu9UniZugun1LAJCUc0_NsMWDP3RLn4sLxRbvbTN0ocycA@mail.gmail.com>
References: <20171025101419.26369-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171025101419.26369-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Arvind Yadav <arvind.yadav.cs@gmail.com>, Jan Kiszka <jan.kiszka@siemens.com>, Kweh Hock Leong <hock.leong.kweh@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Stephen Boyd <sboyd@codeaurora.org>
List-Id: linux-efi@vger.kernel.org

On 25 October 2017 at 11:14, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> The following changes since commit 8a5776a5f49812d29fe4b2d0a2d71675c3facf3f:
>
>   Linux 4.14-rc4 (2017-10-08 20:53:29 -0700)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git efi-next
>
> for you to fetch changes up to c19611def8fd3f524bc945f0e8f9becace8fdf06:
>
>   arm64: efi: ignore EFI_MEMORY_XP attribute if RP and/or WP are set (2017-10-16 16:21:26 +0100)
>
> ----------------------------------------------------------------
> EFI changes for v4.15:
> - ignore EFI_MEMORY_XP attributes on ARM if _RP/_WP are set as well
> - a cosmetic pr_err() format string fix
>
> ----------------------------------------------------------------
> Ard Biesheuvel (1):
>       arm64: efi: ignore EFI_MEMORY_XP attribute if RP and/or WP are set
>
> Arvind Yadav (1):
>       efi/capsule-loader: pr_err() strings should end with newlines
>
>  arch/arm64/kernel/efi.c               | 4 +++-
>  drivers/firmware/efi/capsule-loader.c | 2 +-
>  2 files changed, 4 insertions(+), 2 deletions(-)

Ingo,

It appears these patches have never made it into the TIP tree. Shall I
just resend them as part of the pull request for v4.16?

Thanks,
Ard.
