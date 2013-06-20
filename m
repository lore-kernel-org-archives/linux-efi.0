From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -v2 0/4] EFI 1:1 mapping
Date: Thu, 20 Jun 2013 11:13:21 +0200
Message-ID: <20130620091321.GB6811@gmail.com>
References: <1371491416-11037-1-git-send-email-bp@alien8.de>
 <20130619125243.GD11209@gmail.com>
 <20130619130225.GA28311@pd.tnic>
 <20130619130434.GB24957@gmail.com>
 <20130619160804.GB27832@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130619160804.GB27832-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


* Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org> wrote:

> On Wed, Jun 19, 2013 at 03:04:34PM +0200, Ingo Molnar wrote:
> > * Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org> wrote:
> > > And yet there are the Macs which reportedly cannot stomach this.
> > 
> > Do we know why?
> 
> I got lost in a maze of pointer arithmetic. There seems to be an 
> assumption that nvram writes should be forbidden if in runtime mode but 
> with pointers still below the phys/virt split, which obviously makes no 
> sense but hey.
> 
> But, as always, the only reliable thing to do here is to behave as much 
> like Windows as possible. [...]

Amen ...

> [...] Which means performing the 1:1 mapping but maintaining the high 
> mapping, and passing the high values via SetVirtualAddressMap.

Cool - and supposedly this will work in a Mac environment as well? Would 
be very nice to avoid fundamentally fragile system specific quirks for 
something as fundamental as the EFI runtime memory mapping model ...

Thanks,

	Ingo
