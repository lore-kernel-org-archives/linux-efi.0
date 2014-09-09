From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [GIT PULL] EFI urgent fixes
Date: Tue, 9 Sep 2014 07:07:49 +0200
Message-ID: <20140909050749.GB6770@gmail.com>
References: <20140908215535.GD18582@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140908215535.GD18582-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:

> Folks,
> 
> Please queue up the following fixes, mainly for regressions introduced
> in the merge window or -rc2.

So the rule for post-rc1 merges is to fix regressions 'only', not 
'mainly'!

> ----------------------------------------------------------------
> Mark Rustad (1):
>       efi: Resolve some shadow warnings

That's not a critical regression.

> 
> Mark Salter (1):
>       efi/arm64: Fix fdt-related memory reservation

That's a regression fix.

> Mathias Krause (4):
>       x86/efi: Remove unused efi_call* macros
>       x86/efi: Unexport add_efi_memmap variable
>       x86/efi: Update comment regarding required phys mapped EFI services
>       x86/efi: Mark initialization code as such

Neither of these 4 changes is a critical regression!

> Matt Fleming (1):
>       x86/efi: Fixup GOT in all boot code paths

That's a regression fix.

> Yinghai Lu (1):
>       x86/efi: Only load initrd above 4g on second try

This revert is a regression fix too.

So please only put the 3 regression fixes into efi-urgent, the 
rest can go into the v3.18 pile.

Thanks,

	Ingo
