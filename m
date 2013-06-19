From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: [PATCH -v2 0/4] EFI 1:1 mapping
Date: Wed, 19 Jun 2013 17:21:15 +0100
Message-ID: <20130619162115.GA28119@srcf.ucam.org>
References: <1371491416-11037-1-git-send-email-bp@alien8.de>
 <20130619125243.GD11209@gmail.com>
 <20130619130225.GA28311@pd.tnic>
 <20130619130434.GB24957@gmail.com>
 <20130619160804.GB27832@srcf.ucam.org>
 <20130619161827.GF28300@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130619161827.GF28300-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Jun 19, 2013 at 06:18:27PM +0200, Borislav Petkov wrote:
> On Wed, Jun 19, 2013 at 05:08:04PM +0100, Matthew Garrett wrote:
> > But, as always, the only reliable thing to do here is to behave as
> > much like Windows as possible. Which means performing the 1:1 mapping
> > but maintaining the high mapping, and passing the high values via
> > SetVirtualAddressMap.
> 
> We can't pass the high values via SetVirtualAddressMap and have EFI
> runtime in the kexec-ed kernel, as you and I established last week. And
> since not all would want EFI runtime in the kexec-ed kernel, I'm leaning
> more towards a boot-time option which enables the 1:1 mapping.

Yes, kexec needs a different solution.

> Btw, why would you even want the 1:1 mappings if we pass the high values
> via SetVirtualAddressMap?

Because firmware images don't always update all of the pointers, and so 
will crash if the 1:1 mappings aren't present.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
