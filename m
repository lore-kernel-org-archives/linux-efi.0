From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [GIT PULL] EFI urgent fix
Date: Fri, 19 Sep 2014 12:50:01 +0200
Message-ID: <20140919105001.GA11883@gmail.com>
References: <20140919103305.GE18635@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140919103305.GE18635@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Dave Young <dyoung@redhat.com>
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt@console-pimps.org> wrote:

> Hi guys,
> 
> Please consider pulling the following urgent fix from Dave. It fixes an
> earlyprintk=efi regression introduced in v3.16. Due to changes in the
> early ACPI code we run out of early_ioremap slots when earlyprintk=efi
> is specified on the command line, resulting in a hang during kernel
> boot.
> 
> This patch is clearly a core x86 change, but since it is a fix for an
> EFI code issue I picked it up in my urgent queue. Let me know if you'd
> like to route this some other way.
> 
> The following changes since commit 0ceac9e094b065fe3fec19669740f338d3480498:
> 
>   efi/arm64: Fix fdt-related memory reservation (2014-09-09 07:51:09 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent
> 
> for you to fetch changes up to 3eddc69ffeba092d288c386646bfa5ec0fce25fd:
> 
>   x86 early_ioremap: Increase FIX_BTMAPS_SLOTS to 8 (2014-09-14 15:24:31 +0100)
> 
> ----------------------------------------------------------------
>  * Increase the number of early_ioremap slots to fix a regression with
>    earlyprintk=efi after recent changes to the ACPI code - Dave Young
> 
> ----------------------------------------------------------------
> Dave Young (1):
>       x86 early_ioremap: Increase FIX_BTMAPS_SLOTS to 8
> 
>  arch/x86/include/asm/fixmap.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Pulled, thanks a lot Matt!

	Ingo
