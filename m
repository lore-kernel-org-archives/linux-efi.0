From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL 0/1] EFI fix for v4.19-rc
Date: Wed, 19 Sep 2018 00:13:48 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1809190013290.1468@nanos.tec.linutronix.de>
References: <20180918213652.5648-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180918213652.5648-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org, Scott Branden <scott.branden@broadcom.com>
List-Id: linux-efi@vger.kernel.org

On Tue, 18 Sep 2018, Ard Biesheuvel wrote:

> The following changes since commit 11da3a7f84f19c26da6f86af878298694ede0804:
> 
>   Linux 4.19-rc3 (2018-09-09 17:26:43 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git efi-urgent
> 
> for you to fetch changes up to d310959365942b100f79b56bcce859968fe7ca9c:
> 
>   efi/libstub/arm: default EFI_ARMSTUB_DTB_LOADER to y (2018-09-12 16:41:41 +0200)
> 
> ----------------------------------------------------------------
> Apply a fix from Scott to make the ARM stub's DTB loader opt-out rather
> than opt-in.

Pulled. Thanks Ard!

	tglx
