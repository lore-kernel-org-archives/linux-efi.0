From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [GIT PULL] EFI urgent fix
Date: Fri, 20 Sep 2013 09:53:16 +0200
Message-ID: <20130920075316.GB1126@gmail.com>
References: <20130919124159.GA4785@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130919124159.GA4785-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:

> Hi,
> 
> The following changes since commit 272b98c6455f00884f0350f775c5342358ebb73f:
> 
>   Linux 3.12-rc1 (2013-09-16 16:17:51 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent
> 
> for you to fetch changes up to 700870119f49084da004ab588ea2b799689efaf7:
> 
>   x86, efi: Don't map Boot Services on i386 (2013-09-18 14:42:33 +0100)
> 
> ----------------------------------------------------------------
>  * Fix WARNING on i386 by only enabling a workaround for x86-64 since
>    we've never encountered the bug on i386 - Josh Boyer
> 
> ----------------------------------------------------------------
> Josh Boyer (1):
>       x86, efi: Don't map Boot Services on i386
> 
>  arch/x86/platform/efi/efi.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)

Pulled into tip:x86/urgent, thanks Matt!

	Ingo
