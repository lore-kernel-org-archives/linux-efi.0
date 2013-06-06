From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH 3/4] x86, efi: Add an efi= kernel command line parameter
Date: Thu, 6 Jun 2013 15:26:03 +0200
Message-ID: <20130606132603.GD20972@pd.tnic>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
 <1370177770-26661-4-git-send-email-bp@alien8.de>
 <20130606104224.GH30420@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130606104224.GH30420-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, X86-ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Jun 06, 2013 at 11:42:24AM +0100, Matt Fleming wrote:
> On Sun, 02 Jun, at 02:56:09PM, Borislav Petkov wrote:
> > +
> > +static int __init parse_efi_cmdline(char *str)
> > +{
> > +	if (*str == '=')
> > +		str++;
> > +	if (!strncmp(str, "1:1_map", 7))
> > +		efi_config |= EFI_CFG_MAP11;
> > +
> > +	return 0;
> > +}
> > +early_param("efi", parse_efi_cmdline);
> 
> This is fine for testing, but I genuinely think that this should be on
> by default once these patches are final.

This would break the Macs, remember?

We could make it be the default though and flip the logic so that users
can fall back to the current ioremap functionality, i.e. boot with
"efi=no_1:1_map".

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
