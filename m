From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [GIT PULL] EFI changes for v4.4
Date: Tue, 27 Oct 2015 18:41:39 +0100
Message-ID: <20151027174139.GA12877@gmail.com>
References: <1445770144-22280-1-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1445770144-22280-1-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Glenn P Williamson <glenn.p.williamson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:

> Folks, please pull the following bugfix from Sai which prevents a
> kernel panic when booting an EFI machine with CONFIG_DEBUG_VIRTUAL
> enabled.
> 
> This bug was reported last year by Dave Hansen,
> 
>   https://lkml.kernel.org/r/5462999A.7090706-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
> 
> and since nobody else has reported it, and given that it's only
> triggerable with a debug config option, I figured this should be
> targeted at v4.4.
> 
> The following changes since commit 0f96a99dab366333439e110d6ad253bc7c557c09:
> 
>   efi: Add "efi_fake_mem" boot option (2015-10-12 14:20:09 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next
> 
> for you to fetch changes up to 2c66e24d75d424919c42288b418d2e593fa818b1:
> 
>   x86/efi: Fix kernel panic when CONFIG_DEBUG_VIRTUAL is enabled (2015-10-25 10:22:25 +0000)
> 
> ----------------------------------------------------------------
>  * Fix a kernel panic by not passing EFI virtual mapping addresses to
>    __pa() in the x86 pageattr code. Since these virtual addreses are
>   not part of the direct mapping or kernel text mapping, passing them
>   to __pa() will trigger a BUG_ON() when CONFIG_DEBUG_VIRTUAL is
>   enabled - Sai Praneeth Prakhya
> 
> ----------------------------------------------------------------
> Sai Praneeth (1):
>       x86/efi: Fix kernel panic when CONFIG_DEBUG_VIRTUAL is enabled
> 
>  arch/x86/mm/pageattr.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)

Pulled, thanks Matt!

	Ingo
