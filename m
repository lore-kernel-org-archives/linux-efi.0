From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [GIT PULL v2] EFI changes for v4.1
Date: Wed, 1 Apr 2015 15:11:53 +0200
Message-ID: <20150401131153.GA13492@gmail.com>
References: <20150401130210.GA7931@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150401130210.GA7931-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:

> Folks,
> 
> This is the second version of the EFI v4.1 pull request without
> Yinghai Lu's patch.
> 
> It's based on v4.0-rc3, if that's not OK let me know and I'll respin it
> against something else.
> 
> The following changes since commit 9eccca0843205f87c00404b663188b88eb248051:
> 
>   Linux 4.0-rc3 (2015-03-08 16:09:09 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next
> 
> for you to fetch changes up to a643375f4b175569bc3c03c7a3e758f845c1ccd9:
> 
>   efi/libstub: Retrieve FDT size when loaded from UEFI config table (2015-04-01 12:46:23 +0100)
> 
> ----------------------------------------------------------------
> Ard Biesheuvel (1):
>       efi/libstub: Retrieve FDT size when loaded from UEFI config table
> 
> Borislav Petkov (1):
>       x86/efi: Add a "debug" option to the efi= cmdline
> 
> Ingo Molnar (2):
>       efi: Disable interrupts around EFI calls, not in the epilog/prolog calls
>       efi: Clean up the efi_call_phys_[prolog|epilog]() save/restore interaction
> 
> Ivan Khoronzhuk (2):
>       firmware: dmi_scan: Use full dmi version for SMBIOS3
>       firmware: dmi_scan: Use direct access to static vars
> 
>  Documentation/kernel-parameters.txt     |  3 ++-
>  arch/x86/include/asm/efi.h              |  6 ++++--
>  arch/x86/platform/efi/efi.c             | 17 ++++++++++++---
>  arch/x86/platform/efi/efi_32.c          | 22 ++++++++++----------
>  arch/x86/platform/efi/efi_64.c          | 29 ++++++++++++++------------
>  drivers/firmware/dmi_scan.c             | 37 +++++++++++++++++++--------------
>  drivers/firmware/efi/libstub/arm-stub.c |  7 +++----
>  drivers/firmware/efi/libstub/efistub.h  |  2 +-
>  drivers/firmware/efi/libstub/fdt.c      |  7 ++++++-
>  include/linux/efi.h                     |  1 +
>  10 files changed, 79 insertions(+), 52 deletions(-)

Pulled into tip:core/efi, thanks a lot Matt!

	Ingo
