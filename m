From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 0/4] EFI 1:1 mapping
Date: Mon, 3 Jun 2013 15:54:12 +0100
Message-ID: <20130603145412.GJ2004@console-pimps.org>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
 <20130602225620.GA5496@srcf.ucam.org>
 <20130603081148.GB13607@nazgul.tnic>
 <20130603143252.GB20252@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130603143252.GB20252-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, X86-ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 03 Jun, at 03:32:52PM, Matthew Garrett wrote:
> We can only pass one set of addresses to SetVirtualAddressMap(), but it 
> doesn't seem like there's any intrinsic reason we can't the runtime 
> regions mapped to multiple virtual addresses.

Indeed. That's the approach I took with my 1:1 series from last year. If
Windows is mapping things at higher addresses like you said, then
they're probably doing the same.

-- 
Matt Fleming, Intel Open Source Technology Center
