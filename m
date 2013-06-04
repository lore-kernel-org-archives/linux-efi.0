From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH 0/4] EFI 1:1 mapping
Date: Tue, 4 Jun 2013 10:15:44 +0200
Message-ID: <20130604081544.GA23640@pd.tnic>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
 <20130602225620.GA5496@srcf.ucam.org>
 <20130603081148.GB13607@nazgul.tnic>
 <20130603143252.GB20252@srcf.ucam.org>
 <20130603145412.GJ2004@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130603145412.GJ2004-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, X86-ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Jun 03, 2013 at 03:54:12PM +0100, Matt Fleming wrote:
> On Mon, 03 Jun, at 03:32:52PM, Matthew Garrett wrote:
> > We can only pass one set of addresses to SetVirtualAddressMap(), but it 
> > doesn't seem like there's any intrinsic reason we can't the runtime 
> > regions mapped to multiple virtual addresses.
> 
> Indeed. That's the approach I took with my 1:1 series from last year. If
> Windows is mapping things at higher addresses like you said, then
> they're probably doing the same.

Right, the way I've done it now is to do the virtual mapping
unconditionally, then do the 1:1 mapping and call SetVirtualAddressMap
(f*cking camelcase is so nasty to type - that's why they need whole IDEs
to program :-)) with that map, if "efi=1:1_map" has been passed on the
cmd line.

After the call, we use *only* the 1:1 map but the virtual mapping is
still there.

The initial approach to addressing the b0rked Macs would then be to
never use the 1:1 map on them.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
