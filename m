From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [GIT PULL] EFI urgent fixes
Date: Fri, 31 Jul 2015 09:56:27 +0200
Message-ID: <20150731075627.GA32179@gmail.com>
References: <20150730210643.GM2725@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150730210643.GM2725-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:

> Folks, please pull the following urgent EFI fixes which prevent an oops
> if users pass an invalid "efi" kernel parameter and a boot issue seen on
> Parallels virtual machines.
> 
> The tag is based on v4.2-rc4, let me know if you want me to rebase it on
> top of something else.
> 
> The following changes since commit cbfe8fa6cd672011c755c3cd85c9ffd4e2d10a6f:
> 
>   Linux 4.2-rc4 (2015-07-26 12:26:21 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent
> 
> for you to fetch changes up to 9115c7589b11349a1c3099758b4bded579ff69e0:
> 
>   efi: Check for NULL efi kernel parameters (2015-07-30 18:07:11 +0100)
> 
> ----------------------------------------------------------------
>  * Fix an EFI boot issue preventing a Parallels virtual machine from
>    booting because the upper 32-bits of the EFI memmap pointer were
>    being discarded in setup_e820() - Dmitry Skorodumov
> 
>  * Validate that the "efi" kernel parameter gets used with an argument,
>    otherwise we will oops - Ricardo Neri
> 
> ----------------------------------------------------------------
> Dmitry Skorodumov (1):
>       x86/efi: Use all 64 bit of efi_memmap in setup_e820()
> 
> Ricardo Neri (1):
>       efi: Check for NULL efi kernel parameters
> 
>  arch/x86/boot/compressed/eboot.c | 4 ++++
>  arch/x86/platform/efi/efi.c      | 5 +++++
>  drivers/firmware/efi/efi.c       | 5 +++++
>  3 files changed, 14 insertions(+)

Pulled, thanks Matt!

	Ingo
