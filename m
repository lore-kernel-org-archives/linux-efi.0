From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [GIT PULL] EFI urgent fix
Date: Sat, 2 Apr 2016 09:32:14 +0200
Message-ID: <20160402073214.GA27202@gmail.com>
References: <1459537395-4523-1-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1459537395-4523-1-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Langsdorf <mlangsdo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:

> Folks,
> 
> Please pull the following fix for an arm64 boot crash reported by Mark
> Salter with 64KB granule kernels. It is also tagged for stable.
> 
> The following changes since commit 591b1d8d86074ac3a3163d89bcfe7b232cf83902:
> 
>   x86/mm/pkeys: Add missing Documentation (2016-03-29 11:21:17 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent
> 
> for you to fetch changes up to 7cc8cbcf82d165dd658d89a7a287140948e76413:
> 
>   efi/arm64: Don't apply MEMBLOCK_NOMAP to UEFI memory map mapping (2016-03-31 21:33:50 +0100)
> 
> ----------------------------------------------------------------
>  * Fix a boot crash on arm64 caused by a recent commit to mark the EFI
>    memory map as 'MEMBLOCK_NOMAP' which causes the regions to be
>    omitted from the kernel direct mapping - Ard Biesheuvel
> 
> ----------------------------------------------------------------
> Ard Biesheuvel (1):
>       efi/arm64: Don't apply MEMBLOCK_NOMAP to UEFI memory map mapping
> 
>  drivers/firmware/efi/arm-init.c | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)

Pulled, thanks Matt!

	Ingo
