From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [GIT PULL] EFI runtime mapping work for v3.14
Date: Mon, 11 Nov 2013 12:17:54 +0100
Message-ID: <20131111111754.GB15810@gmail.com>
References: <20131108105719.GB2318@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131108105719.GB2318-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:

> Folks, could you queue up the following for the v3.14 merge window? It
> would be good to get these patches into linux-next for a full release
> cycle of testing. They pass all of my tests.
> 
> The following changes since commit 72548e836b0c4abbb652e791dee9c91203a9a4c6:
> 
>   x86/efi: Add EFI framebuffer earlyprintk support (2013-10-28 18:09:58 +0000)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next

Mind resending this in about a week or so? The merge window has just 
started and we don't want to potentially destabilize -next with v3.14 
problems.

Thanks,

	Ingo
