From: Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Date: Fri, 24 May 2013 15:49:38 -0500
Message-ID: <20130524204937.GB3322@sgi.com>
References: <20130522162747.GA20816@sgi.com>
 <20130523115801.GJ14575@console-pimps.org>
 <20130523203234.GD20913@sgi.com>
 <20130524074331.GL14575@console-pimps.org>
 <20130524200539.GA3322@sgi.com>
 <1369426255.2217.9.camel@x230>
Reply-To: Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1369426255.2217.9.camel@x230>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, May 24, 2013 at 08:11:01PM +0000, Matthew Garrett wrote:
> On Fri, 2013-05-24 at 15:05 -0500, Russ Anderson wrote:
> 
> > One other data point is if the query_variable_info call is hacked to
> > remove one of the EFI flags (ie comment out EFI_VARIABLE_BOOTSERVICE_ACCESS)
> > the efi_call_phys4() call fails with EFI_INVALID_PARAMETER and
> > the system boots.  Of course it does not create /sys/firmware/efivars
> > entries and complains "[Firmware Bug]: efi: Inconsistent initial sizes".
> > But at least it boots.
> 
> EFI_VARIABLE_RUNTIME_ACCESS is only legal if
> EFI_VARIABLE_BOOTSERVICE_ACCESS is set, so it's correct to throw
> EFI_INVALID_PARAMETER there.

Yes.  The point of the experiment was to see if it returned a
valid failure status (which it did) and see if the boot still
failed (which it didn't).  So something about going deeper
into that call seems to trigger the failure.

Why does the kernel still try to create /sys/firmware/efivars/
entries in the original failure even though efi_call_phys4()
failed?  Or does it always try to create those entries
and GetNextVariable() blows up in the original failure
but not in my experiment?

Thanks,
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja-sJ/iWh9BUns@public.gmane.org
