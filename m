From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] efi: Check for null efi kernel parameters
Date: Fri, 24 Jul 2015 15:32:06 +0800
Message-ID: <20150724073206.GA19640@dhcp-128-11.nay.redhat.com>
References: <1437014163-4652-1-git-send-email-ricardo.neri-calderon@linux.intel.com>
 <20150721092217.GA7361@dhcp-129-220.nay.redhat.com>
 <1437701417.10814.12.camel@ranerica-desk01>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1437701417.10814.12.camel@ranerica-desk01>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Glenn P. Williamson" <glenn.p.williamson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


[snip]

> > > diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> > > index cfba30f..d323e3a 100644
> > > --- a/arch/x86/platform/efi/efi.c
> > > +++ b/arch/x86/platform/efi/efi.c
> > > @@ -972,6 +972,10 @@ u64 efi_mem_attributes(unsigned long phys_addr)
> > >  
> > >  static int __init arch_parse_efi_cmdline(char *str)
> > >  {
> > > +	if (!str) {
> > > +		pr_warn("need at least one option\n");

I feel pr_warn is too much for an invalid param, what if other invalid
case then? IMHO returning an error code is enough.

Thanks
Dave
