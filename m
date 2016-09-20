From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [GIT PULL 0/2] EFI urgent fixes
Date: Tue, 20 Sep 2016 16:58:07 +0200
Message-ID: <20160920145807.GA22836@gmail.com>
References: <20160920144829.30873-1-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160920144829.30873-1-matt@codeblueprint.co.uk>
Sender: stable-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>, Douglas Hatch <doug.hatch@hpe.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Scott J Norton <scott.norton@hpe.com>, "stable @ vger . kernel . org Waiman Long" <waiman.long@hpe.com>, stable@vger.kernel.org
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt@codeblueprint.co.uk> wrote:

> Folks, please pull the following two fixes that address the boot hang
> issue Waiman reported here,
> 
>   https://lkml.kernel.org/r/57DF56D4.50304@hpe.com
> 
> The following changes since commit 3be7988674ab33565700a37b210f502563d932e6:
> 
>   Linux 4.8-rc7 (2016-09-18 17:27:41 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent
> 
> for you to fetch changes up to 1297667083d5442aafe3e337b9413bf02b114edb:
> 
>   x86/efi: Only map RAM into EFI page tables if in mixed-mode (2016-09-20 14:53:04 +0100)
> 
> ----------------------------------------------------------------
>  * Fix a boot hang on large memory machines (multiple terabyte) caused
>    by type conversion errors in the x86 pat code - Matt Fleming
> 
> ----------------------------------------------------------------
> Matt Fleming (2):
>       x86/mm/pat: Prevent hang during boot when mapping pages
>       x86/efi: Only map RAM into EFI page tables if in mixed-mode
> 
>  arch/x86/mm/pageattr.c         | 21 +++++++++++----------
>  arch/x86/platform/efi/efi_64.c |  2 +-
>  2 files changed, 12 insertions(+), 11 deletions(-)

Pulled, thanks a lot Matt!

	Ingo
