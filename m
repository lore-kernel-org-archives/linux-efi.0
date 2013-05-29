From: Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
	info to runtime code
Date: Wed, 29 May 2013 15:16:17 -0500
Message-ID: <20130529201616.GB28027@sgi.com>
References: <20130522162747.GA20816@sgi.com> <20130523115801.GJ14575@console-pimps.org> <20130523222321.GB31880@sgi.com> <20130524074544.GM14575@console-pimps.org>
Reply-To: Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130524074544.GM14575-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, May 24, 2013 at 08:45:44AM +0100, Matt Fleming wrote:
> On Thu, 23 May, at 05:23:21PM, Russ Anderson wrote:
> > Interesting data point.  The failure is on a rhel7/grub2 root.
> > The identical kernel on a rhel6/grub root boots.  So maybe
> > grub2 brings out the failure?  I suspect Fedora19/grub2 on
> > EFI should hit the problem (for someone looking to reproduce
> > it).
> > 
> > In both cases the kernel boot line options are the same.
> 
> I'll bet that rhel7 is using the EFI handover protocol which uses the
> internal mechanisms of the EFI boot stub.

To be more specific (now that I've dug through the code), grub2 (used
by rhel7) uses EFI boot stubs.  grub and elilo apparently do not use
EFI boot stubs, so they don't hit the problem (at least on my test
systems).



-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja-sJ/iWh9BUns@public.gmane.org
