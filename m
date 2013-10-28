From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [GIT PULL] EFI changes
Date: Mon, 28 Oct 2013 14:44:13 +0100
Message-ID: <20131028134413.GA10163@gmail.com>
References: <20131028123528.GM1982@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131028123528.GM1982-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:

> This is a respin of the EFI earlyprintk support with the fix for the
> allmodconfig build breakage that Ingo reported.
> 
> The following changes since commit c158c3bf59951bbb44bd7ccca9e6665dfd1617c5:
> 
>   boot, efi: Remove redundant memset() (2013-10-04 20:07:47 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next
> 
> for you to fetch changes up to 265434a91cf3377d65dc2b6d80065271514b5696:
> 
>   x86/efi: Add EFI framebuffer earlyprintk support (2013-10-28 11:57:58 +0000)
> 
> ----------------------------------------------------------------
>  * Add support for earlyprintk=efi which uses the EFI framebuffer. Very
>    useful for debugging boot issues.
> 
> ----------------------------------------------------------------
> Matt Fleming (2):
>       efi: Add asm-generic/efi.h for non-x86
>       x86/efi: Add EFI framebuffer earlyprintk support
> 
>  Documentation/kernel-parameters.txt  |   8 +-
>  arch/ia64/include/asm/efi.h          |   6 ++
>  arch/x86/Kconfig.debug               |  10 ++
>  arch/x86/boot/compressed/eboot.c     |   1 -
>  arch/x86/include/asm/efi.h           |  12 +++
>  arch/x86/kernel/early_printk.c       |   6 ++
>  arch/x86/kernel/setup.c              |   1 -
>  arch/x86/platform/efi/Makefile       |   1 +
>  arch/x86/platform/efi/early_printk.c | 191 +++++++++++++++++++++++++++++++++++
>  arch/x86/platform/efi/efi.c          |   1 -
>  arch/x86/platform/efi/efi_32.c       |   1 -
>  arch/x86/platform/efi/efi_64.c       |   1 -
>  arch/x86/platform/uv/bios_uv.c       |   1 -
>  include/asm-generic/efi.h            |  17 ++++
>  include/linux/efi.h                  |  31 +-----
>  15 files changed, 250 insertions(+), 38 deletions(-)
>  create mode 100644 arch/ia64/include/asm/efi.h
>  create mode 100644 arch/x86/platform/efi/early_printk.c
>  create mode 100644 include/asm-generic/efi.h

and this breaks the ARM build:

In file included from /home/mingo/tip/init/main.c:44:
/home/mingo/tip/include/linux/efi.h:842:21: error: asm/efi.h: No such file or directory
/home/mingo/tip/init/main.c: In function 'start_kernel':
/home/mingo/tip/init/main.c:638: error: implicit declaration of function 'efi_enabled'
/home/mingo/tip/init/main.c:639: error: implicit declaration of function 'efi_late_init'
/home/mingo/tip/init/main.c:640: error: implicit declaration of function 'efi_free_boot_services'

Thanks,

	Ingo
