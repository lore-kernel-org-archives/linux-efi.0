From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Date: Thu, 23 May 2013 12:58:01 +0100
Message-ID: <20130523115801.GJ14575@console-pimps.org>
References: <20130522162747.GA20816@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130522162747.GA20816-sJ/iWh9BUns@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>
Cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 22 May, at 11:27:47AM, Russ Anderson wrote:
> [    6.062157] EFI Variables Facility v0.08 2004-May-17
> [    6.067731] BUG: unable to handle kernel paging request at 000000007ca95b10
> [    6.075519] IP: [<ffff88007dbf2140>] 0xffff88007dbf213f

This is a bit of a head scratcher. Could you paste the EFI memmap
entries in your dmesg for the regions that cover 0x7ca95b10 and
0x7dbf2140?  My guess would be that they're EFI runtime code regions,
which would at least explain why we seem to be executing code in the
direct mapping region (0xffff8800xxxxxxxx).

Are you booting via the EFI boot stub?

-- 
Matt Fleming, Intel Open Source Technology Center
