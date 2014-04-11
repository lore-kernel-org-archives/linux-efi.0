From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [GIT PULL] EFI urgent fixes
Date: Fri, 11 Apr 2014 10:27:16 +0200
Message-ID: <20140411082716.GC15418@gmail.com>
References: <20140411071622.GB17021@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140411071622.GB17021-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:

> Guys, please pull the following. One of the fixes is for a regression
> introduced during the merge window. The other two are bugs that have
> existed in the EFI boot stub for a while, but which have only just been
> reported.
> 
> I'm going to take care of submitting the later two to stable separately
> because they won't apply cleanly as-is.
> 
> The following changes since commit 204b0a1a4b92612c957a042df1a3be0e9cc79391:
> 
>   x86, efi: Abstract x86 efi_early calls (2014-03-26 11:30:03 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent
> 
> for you to fetch changes up to 47514c996fac5e6f13ef3a4c5e23f1c5cffabb7b:
> 
>   efi: Pass correct file handle to efi_file_{read,close} (2014-04-10 21:20:03 +0100)
> 
> ----------------------------------------------------------------
>  * Fix EFI boot regression introduced during the merge window where the
>    firmware was reading random values from the stack because we were
>    passing a pointer to the wrong object type.
> 
>  * Kernel corruption has been reported when booting with the EFI boot
>    stub which was tracked down to setting a bogus value for
>    bp->hdr.code32_start, resulting in corruption during relocation.
> 
>  * Olivier Martin reported that the wrong file handles were being passed
>    to efi_file_(read|close), which works for x86 by luck due to the way
>    that the FAT driver is implemented, but doesn't work on ARM.
> 
> ----------------------------------------------------------------
> Matt Fleming (3):
>       x86/efi: Fix boot failure with EFI stub
>       x86/efi: Correct EFI boot stub use of code32_start
>       efi: Pass correct file handle to efi_file_{read,close}
> 
>  arch/x86/boot/compressed/eboot.c       | 19 ++++++++++---------
>  arch/x86/boot/compressed/head_32.S     |  8 ++------
>  arch/x86/boot/compressed/head_64.S     |  9 +++------
>  drivers/firmware/efi/efi-stub-helper.c |  6 +++---
>  4 files changed, 18 insertions(+), 24 deletions(-)

Pulled, thanks a lot Matt!

	Ingo
