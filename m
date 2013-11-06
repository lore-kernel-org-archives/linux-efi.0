From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] efi earlyprintk fix
Date: Wed, 6 Nov 2013 17:23:35 +0800
Message-ID: <20131106092335.GA3952@dhcp-16-126.nay.redhat.com>
References: <20131103121647.GA4770@dhcp-16-126.nay.redhat.com>
 <20131104103739.GD21688@console-pimps.org>
 <20131104125853.GB5118@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131104125853.GB5118-je1gSBvt1TcFLmT5oZ11vB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 11/04/13 at 08:58pm, Dave Young wrote:
> On 11/04/13 at 10:37am, Matt Fleming wrote:
> > On Sun, 03 Nov, at 08:16:47PM, Dave Young wrote:
> > > 
> > > there's below one line shift problem:
> > > 
> > >                      ACPI=0xdabfe000  ACPI 2.0=0xdabfe014  SMBIOS=0xdaa9e000
> > > [    0.000000] efi:  
> > > 
> > > In fact check efi_y and the lfb_height should be compared at the begin of the
> > > loop of early_efi_write
> >  
> > Hmm... this is interesting. I can't produce this on any of my machines.
> > Where did you see this? What hardware?
> 
> It's my laptop Thinkpad T420, the screen scolls very fast, I use boot_delay=500
> to verify it with my patch for moving boot_delay param an early param.
> 
> Even without boot_delay, there's always a line at bottom with only the prefix:
> "efi:"

I will do further debug if I got time on this. It's really helpful for having efi
earlyprintk, thanks for your excellent idea of printing to efi fb!
