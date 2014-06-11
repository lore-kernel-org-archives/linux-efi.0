From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [RFC] Best place/method to determine BIOS version?
Date: Wed, 11 Jun 2014 09:55:48 +0100
Message-ID: <20140611085548.GB26290@console-pimps.org>
References: <20140609200017.GD2700@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140609200017.GD2700-sJ/iWh9BUns@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Cc: Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 09 Jun, at 03:00:17PM, Alex Thorlton wrote:
> 
> I think the problem is that I really need to be doing this at a point
> where I can directly use physical addressing (the function pointer that
> we have stored in efi.uv_systab contains the physical address of our
> function) - at least that's the idea I get from our BIOS guys, but I
> really don't know what I'm talking about here :)

Can't you use either early_ioremap() or ioremap() (depending on when you
want to access the physical address), perhaps coupled with
efi_call_phys()?

-- 
Matt Fleming, Intel Open Source Technology Center
