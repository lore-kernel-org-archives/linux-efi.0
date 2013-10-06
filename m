From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [GIT PULL] EFI changes
Date: Sun, 6 Oct 2013 11:27:32 +0200
Message-ID: <20131006092732.GA4535@gmail.com>
References: <20131004195550.GA21783@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131004195550.GA21783-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:

> These changes fix a couple of sparse warnings introduced in the last
> pull.
> 
> The following changes since commit 0ce6cda2c75d64175394341ef60e6e1d27dd9c10:
> 
>   x86 efi: bugfix interrupt disabling sequence (2013-09-30 10:23:11 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next
> 
> for you to fetch changes up to c158c3bf59951bbb44bd7ccca9e6665dfd1617c5:
> 
>   boot, efi: Remove redundant memset() (2013-10-04 20:07:47 +0100)
> 
> ----------------------------------------------------------------
>  * Fix a recently introduced sparse warning caused by using 0 instead of
>    NULL - Leif Lindholm
> 
>  * Remove a useless memset from the common EFI stub code - Roy Franz
> 
> ----------------------------------------------------------------
> Leif Lindholm (1):
>       x86/efi: Fix config_table_type array termination
> 
> Roy Franz (1):
>       boot, efi: Remove redundant memset()
> 
>  arch/x86/platform/efi/efi.c            | 2 +-
>  drivers/firmware/efi/efi-stub-helper.c | 2 --
>  2 files changed, 1 insertion(+), 3 deletions(-)

Pulled into tip:x86/efi, thanks Matt!

	Ingo
