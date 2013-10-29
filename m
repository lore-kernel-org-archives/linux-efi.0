From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [GIT PULL] EFI changes
Date: Tue, 29 Oct 2013 09:11:56 +0100
Message-ID: <20131029081156.GB16557@gmail.com>
References: <20131028123528.GM1982@console-pimps.org>
 <20131028134413.GA10163@gmail.com>
 <20131028155215.GN1982@console-pimps.org>
 <20131028155525.GA13987@gmail.com>
 <20131028203052.GO1982@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131028203052.GO1982-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:

> On Mon, 28 Oct, at 04:55:25PM, Ingo Molnar wrote:
> > 
> > * Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> > 
> > > On Mon, 28 Oct, at 02:44:13PM, Ingo Molnar wrote:
> > > > and this breaks the ARM build:
> > > > 
> > > > In file included from /home/mingo/tip/init/main.c:44:
> > > > /home/mingo/tip/include/linux/efi.h:842:21: error: asm/efi.h: No such file or directory
> > > > /home/mingo/tip/init/main.c: In function 'start_kernel':
> > > > /home/mingo/tip/init/main.c:638: error: implicit declaration of function 'efi_enabled'
> > > > /home/mingo/tip/init/main.c:639: error: implicit declaration of function 'efi_late_init'
> > > > /home/mingo/tip/init/main.c:640: error: implicit declaration of function 'efi_free_boot_services'
> > > 
> > > Ah, that's my own fault because my 'next' branch doesn't include 
> > > the ARM EFI support. Where did you get the patches from? Are they 
> > > in linux-next?
> > 
> > It's all in tip:x86/efi.
> > 
> > > I'm inclined to drop the cleanup patch for now and do it later, 
> > > once things have settled because it's also causing conflicts for 
> > > Borislav's work.
> > 
> > Sure.
> 
> OK, I've pushed out the 'next' branch and retagged it as 'efi-next'
> (again), which hopefully should be finally free from build errors.

Please send it out as a new pull requests so that the diffstat and 
shortlog can be seen and double checked, etc.

Thanks,

	Ingo
