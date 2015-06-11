From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [GIT PULL] EFI urgent fix
Date: Thu, 11 Jun 2015 16:43:58 +0200
Message-ID: <20150611144358.GA12476@gmail.com>
References: <20150611124758.GA19243@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150611124758.GA19243-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:

> Folks, please pull the following build fix from Peter Jones. Guenter
> reported that the ESRT driver doesn't build properly on ia64. The
> problem was discovered in linux-next.
> 
> The following changes since commit c208358c2cc832eeb5b341a465eee30be19cd5a0:
> 
>   efi: Add 'systab' information to Documentation/ABI (2015-05-27 15:40:20 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next
> 
> for you to fetch changes up to 3846c15820a1841225d0245afda4875af23dfbbe:
> 
>   efi: Work around ia64 build problem with ESRT driver (2015-06-08 10:51:31 +0100)
> 
> ----------------------------------------------------------------
>  * Fix ESRT build breakage on ia64 reported by Guenter Roeck - Peter Jones
> 
> ----------------------------------------------------------------
> Peter Jones (1):
>       efi: Work around ia64 build problem with ESRT driver
> 
>  drivers/firmware/efi/Kconfig  | 5 +++++
>  drivers/firmware/efi/Makefile | 3 ++-
>  include/linux/efi.h           | 4 ++++
>  3 files changed, 11 insertions(+), 1 deletion(-)

So I pulled this into tip:x86/efi, not into tip:x86/urgent, because the commit 
that broke the ia64 build is not upstream yet.

Thanks,

	Ingo
