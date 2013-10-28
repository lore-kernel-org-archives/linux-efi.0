From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [GIT PULL] EFI changes
Date: Mon, 28 Oct 2013 12:17:41 +0100
Message-ID: <20131028111741.GA7830@gmail.com>
References: <20131027214815.GH1982@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131027214815.GH1982-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:

> Guys, do you think we could get the EFI earlyprintk support into the
> 'x86/efi' branch for the upcoming merge window? I know it's quite late
> in the game but since it's a new feature it shouldn't introduce any kind
> of regression and is a much needed feature.
> 
> The following changes since commit c158c3bf59951bbb44bd7ccca9e6665dfd1617c5:
> 
>   boot, efi: Remove redundant memset() (2013-10-04 20:07:47 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next
> 
> for you to fetch changes up to 32c9e70fc3912c3b9c7d53ce016960ce99ff93d4:
> 
>   x86/efi: Add EFI framebuffer earlyprintk support (2013-10-27 21:18:48 +0000)

This breaks on x86-64 allmodconfig with:

arch/x86/built-in.o: In function `early_efi_setup':
early_printk.c:(.init.text+0x27e9f): undefined reference to `get_default_font'

Thanks,

	Ingo
