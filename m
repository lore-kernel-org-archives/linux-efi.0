From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [GIT PULL] EFI urgent fixes
Date: Fri, 26 Sep 2014 12:44:54 +0100
Message-ID: <20140926114454.GV18635@console-pimps.org>
References: <20140925073133.GQ18635@console-pimps.org>
 <20140925144127.GA3828@gmail.com>
 <1411730854.7866.10.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1411730854.7866.10.camel@x220>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 26 Sep, at 01:27:34PM, Paul Bolle wrote:
> 
> This Makefile was changed in the first patch. That became 84be880560fb
> ("Revert "efi/x86: efistub: Move shared dependencies to <asm/efi.h>""),
> which just landed in next-20140926.
> 
> It appears to have introduced a typo, because:
>     CONFIG_EFI_ARM_STUB
> 
> should probably have been:
>     CONFIG_EFI_ARMSTUB

Crap. Thanks for catching that Paul. I'm wondering how this slipped
through because that commit has an explicit Tested-by from Leif.

Hell, even I built an arm64 EFI kernel before sending that commit.

Ohh.. I see why no one caught this. From arch/arm64/Makefile,

  libs-$(CONFIG_EFI_STUB) += drivers/firmware/efi/libstub/

so libstub will be built for arm64 regardless of the broken logic in
drivers/firmware/efi/Makefile.

Paul, how did you notice the typo? Did you hit an explicit build
failure? It's definitely wrong and I'm trying to figure out whether I
need to add some more testing to my build infrastructure to catch this
kind of problem in the future.

The next question is: should we fix this up at this point in the merge
cycle? It's basically just dead code.

-- 
Matt Fleming, Intel Open Source Technology Center
