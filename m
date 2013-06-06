From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH 3/4] x86, efi: Add an efi= kernel command line parameter
Date: Thu, 6 Jun 2013 20:51:40 +0200
Message-ID: <20130606185140.GK20972@pd.tnic>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
 <1370177770-26661-4-git-send-email-bp@alien8.de>
 <20130606104224.GH30420@console-pimps.org>
 <20130606132603.GD20972@pd.tnic>
 <20130606175052.GA1285@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130606175052.GA1285-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, X86-ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Jun 06, 2013 at 06:50:52PM +0100, Matthew Garrett wrote:
> On Thu, Jun 06, 2013 at 03:26:03PM +0200, Borislav Petkov wrote:
> 
> > This would break the Macs, remember?
> 
> I think the Macs will be fine as long as we're passing the high mappings 
> into SetVirtualAddressMap().

Right, on those we'll fall back to the current mappings and simply not
have the 1:1 thing.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
