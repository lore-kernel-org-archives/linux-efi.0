From: Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
	info to runtime code
Date: Thu, 30 May 2013 21:54:38 -0500
Message-ID: <20130531025438.GB24287@sgi.com>
References: <20130524074331.GL14575@console-pimps.org> <20130529210115.GC28027@sgi.com> <alpine.LRH.2.00.1305300018180.1111@twin.jikos.cz> <20130529224645.GA16582@sgi.com> <alpine.LNX.2.00.1305300048520.30576@pobox.suse.cz> <1369880172.17397.11.camel@linux-s257.site> <20130530221737.GA11105@sgi.com> <1369952512.11620.14.camel@x230> <20130530222836.GB11105@sgi.com> <1369953129.11620.15.camel@x230>
Reply-To: Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1369953129.11620.15.camel@x230>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: joeyli <jlee-IBi9RG/b67k@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, May 30, 2013 at 10:32:09PM +0000, Matthew Garrett wrote:
> On Thu, 2013-05-30 at 17:28 -0500, Russ Anderson wrote:
> > On Thu, May 30, 2013 at 10:21:53PM +0000, Matthew Garrett wrote:
> > > On Thu, 2013-05-30 at 17:17 -0500, Russ Anderson wrote:
> > > 
> > > > That's a great idea.  This patch moves the QueryVariableInfo()
> > > > call from bootime to runtime, in efi_late_init().  The attached
> > > > patch is consistent with the UEFI spec and avoids the problem.
> > > 
> > > No, that defeats the entire point of the original patch.
> > 
> > How so?  It is still calling QueryVariableInfo()
> > before the data is used.
> 
> We want to know how much space is used by variables that aren't visible
> at runtime.

We want to boot.  We could boot up through 3.9-rc7.

Knowing how much space is used by variables that aren't
visible at runtime it moot if you can't boot.


And again, maybe this is a bios bug - we have bios people
looking into it - and maybe that call _should_ work, but
the fact is the kernel booted without that change[1] and does
not boot with it.  


[1] commit cc5a080c5d40c36089bb08a8a16fa3fc7047fe0f

Thanks,
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja-sJ/iWh9BUns@public.gmane.org
