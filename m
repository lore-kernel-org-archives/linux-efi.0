From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH -v2 0/4] EFI 1:1 mapping
Date: Thu, 20 Jun 2013 09:46:15 -0700
Message-ID: <1371746775.2372.11.camel@dabdike>
References: <20130619125243.GD11209@gmail.com>
	 <20130619130225.GA28311@pd.tnic> <20130619130434.GB24957@gmail.com>
	 <20130619160804.GB27832@srcf.ucam.org> <20130620091321.GB6811@gmail.com>
	 <20130620091537.GA17159@srcf.ucam.org> <20130620092237.GA6943@gmail.com>
	 <20130620093337.GI32694@pd.tnic> <20130620094446.GA17882@srcf.ucam.org>
	 <1371740019.2372.3.camel@dabdike> <20130620162916.GA25727@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130620162916.GA25727-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 2013-06-20 at 17:29 +0100, Matthew Garrett wrote:
> On Thu, Jun 20, 2013 at 07:53:39AM -0700, James Bottomley wrote:
> 
> > Can't we detect Macs from some of the UEFI strings at boot time and do
> > the right thing with the boot switch (which can be overriden from the
> > kernel command line if we get it wrong)?
> 
> Yes, and then our behaviour differs from Windows and so we'll have 
> inevitably broken some other system.

Unless you can think of the way out of this, we seem to have the stark
choice of behave like windows or allow kexec.  For the server market,
kexec wins, so either we find a way not to have to make the choice or we
do something automatic to make it fairly painless.

James
