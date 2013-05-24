From: Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Date: Fri, 24 May 2013 17:05:34 -0400
Message-ID: <20130524210534.GA15466@redhat.com>
References: <20130522162747.GA20816@sgi.com>
 <20130523115801.GJ14575@console-pimps.org>
 <20130523203234.GD20913@sgi.com>
 <20130524074331.GL14575@console-pimps.org>
 <20130524161111.GE3672@sgi.com>
 <20130524170214.GA30179@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130524170214.GA30179-sJ/iWh9BUns@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>
Cc: Robin Holt <holt-sJ/iWh9BUns@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, May 24, 2013 at 12:02:15PM -0500, Russ Anderson wrote:
 > On Fri, May 24, 2013 at 11:11:11AM -0500, Robin Holt wrote:
 > > Russ,
 > > 
 > > Can we open a bug for the BIOS folks and see if we can get this addressed?
 > 
 > I already talked with them.  It is not in an area that we
 > normally change, so if there is a bug may be in the Intel
 > reference code.  More investigation is needed to track down
 > the actual problem, and that could take help from Intel.
 > 
 > Regardless of that, it is a kernel patch that triggers the
 > problem.  This isn't the first time a kernel change does
 > the "right thing" but trips across questionable bios/EFI/bootloader
 > implementation.  That still makes it a kernel bug.
 > 
 > I'm still digging to better understand the root problem.
 
When we rebased the Fedora 18 kernel to 3.9 we had a bunch of reports
from people who can no longer boot with what looks like similar symptoms.

https://bugzilla.redhat.com/show_bug.cgi?id=964335

	Dave
