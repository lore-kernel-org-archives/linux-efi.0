From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [GIT PULL] EFI urgent fixes
Date: Fri, 26 Sep 2014 13:35:10 +0200
Message-ID: <20140926113510.GA14625@gmail.com>
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
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org


* Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org> wrote:

> On Thu, 2014-09-25 at 16:41 +0200, Ingo Molnar wrote:
> > * Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> > 
> > > Folks,
> > > 
> > > Please consider pulling the following fixes.
> > > 
> > > The first two are releated to the bug report I got from Linus and Josh
> > > Boyer, whereby Fedora20 + grub2 systems were no longer booting. Linus
> > > reverted the offending commit that broke grub2 boot, but that left us in
> > > a state where Macbooks still didn't boot with EFI. This is fixed with
> > > the below revert and I'm dropping a noisey boot time efi_printk() based
> > > on Josh's request and Linus' OK.
> > > 
> > > The third patch fixes a 32-bit EFI boot stub bug where garbled text is
> > > displayed on the screen if any of the efi_printk() statements run.
> > > 
> > > The following changes since commit 3eddc69ffeba092d288c386646bfa5ec0fce25fd:
> > > 
> > >   x86 early_ioremap: Increase FIX_BTMAPS_SLOTS to 8 (2014-09-14 15:24:31 +0100)
> > > 
> > > are available in the git repository at:
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent
> > > 
> > > for you to fetch changes up to 115c6628a59044958c205f8468a1b3ba3d539e61:
> > > 
> > >   x86/efi: Truncate 64-bit values when calling 32-bit OutputString() (2014-09-24 21:56:46 +0100)
> > > 
> > > ----------------------------------------------------------------
> > >  * Revert the static library changes from the merge window since they're
> > >    causing issues for Macbooks and Fedora + Grub2 - Matt Fleming
> > > 
> > >  * Delete the misleading "setup_efi_pci() failed!" message which some
> > >    people are seeing when booting EFI - Matt Fleming
> > > 
> > >  * Fix printing strings from the 32-bit EFI boot stub by only passing
> > >    32-bit addresses to the firmware - Matt Fleming
> > > 
> > > ----------------------------------------------------------------
> > > Matt Fleming (3):
> > >       Revert "efi/x86: efistub: Move shared dependencies to <asm/efi.h>"
> > >       x86/efi: Delete misleading efi_printk() error message
> > >       x86/efi: Truncate 64-bit values when calling 32-bit OutputString()
> > > 
> > >  arch/x86/boot/compressed/Makefile |  3 +--
> > >  arch/x86/boot/compressed/eboot.c  | 44 +++++++++++++++++++++++----------------
> > >  arch/x86/boot/compressed/eboot.h  | 16 ++++++++++++++
> > >  arch/x86/include/asm/efi.h        | 24 ---------------------
> > >  drivers/firmware/efi/Makefile     |  2 +-
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

A delta fix would be nice at this point, I've got the x86 side 
tested and besides this build bug it's ready to go to Linus.

Thanks,

	Ingo
