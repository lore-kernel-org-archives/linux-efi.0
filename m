From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 3/4] x86, efi: Add an efi= kernel command line parameter
Date: Thu, 6 Jun 2013 14:36:09 +0100
Message-ID: <20130606133609.GK30420@console-pimps.org>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
 <1370177770-26661-4-git-send-email-bp@alien8.de>
 <20130606104224.GH30420@console-pimps.org>
 <20130606132603.GD20972@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130606132603.GD20972-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, X86-ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 06 Jun, at 03:26:03PM, Borislav Petkov wrote:
> On Thu, Jun 06, 2013 at 11:42:24AM +0100, Matt Fleming wrote:
> > On Sun, 02 Jun, at 02:56:09PM, Borislav Petkov wrote:
> > > +
> > > +static int __init parse_efi_cmdline(char *str)
> > > +{
> > > +	if (*str == '=')
> > > +		str++;
> > > +	if (!strncmp(str, "1:1_map", 7))
> > > +		efi_config |= EFI_CFG_MAP11;
> > > +
> > > +	return 0;
> > > +}
> > > +early_param("efi", parse_efi_cmdline);
> > 
> > This is fine for testing, but I genuinely think that this should be on
> > by default once these patches are final.
> 
> This would break the Macs, remember?
> 
> We could make it be the default though and flip the logic so that users
> can fall back to the current ioremap functionality, i.e. boot with
> "efi=no_1:1_map".

Yeah, or white/blacklist them. We've already had enough of "Oh, your
machine used to work but now it's bust? Yeah, turn on this cmdline
parameter to get things working again".

But the point is that the funnies that have been seen on the Macs should
be treated as the unusual case. The number of machines I've seen that
require this 1:1 map is staggering, especially once you start poking at
some of the other runtime services, like UpdateCapsule().

-- 
Matt Fleming, Intel Open Source Technology Center
