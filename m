From: Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
	info to runtime code
Date: Thu, 30 May 2013 21:17:49 -0500
Message-ID: <20130531021749.GA24287@sgi.com>
References: <20130524074331.GL14575@console-pimps.org> <20130529210115.GC28027@sgi.com> <alpine.LRH.2.00.1305300018180.1111@twin.jikos.cz> <20130529224645.GA16582@sgi.com> <alpine.LNX.2.00.1305300048520.30576@pobox.suse.cz> <1369880172.17397.11.camel@linux-s257.site> <20130530221737.GA11105@sgi.com> <1369952512.11620.14.camel@x230> <20130530222836.GB11105@sgi.com> <alpine.LNX.2.00.1305310029560.30576@pobox.suse.cz>
Reply-To: Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1305310029560.30576-ztGlSCb7Y1iN3ZZ/Hiejyg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, May 31, 2013 at 12:30:43AM +0200, Jiri Kosina wrote:
> On Thu, 30 May 2013, Russ Anderson wrote:
> 
> > > > That's a great idea.  This patch moves the QueryVariableInfo()
> > > > call from bootime to runtime, in efi_late_init().  The attached
> > > > patch is consistent with the UEFI spec and avoids the problem.
> > > 
> > > No, that defeats the entire point of the original patch.
> > 
> > How so?  It is still calling QueryVariableInfo()
> > before the data is used.
> 
> You lose information provided by QueryVariableInfo() about boot-only 
> variables once the transition boot -> runtime has happened.

Is that information really more important than the ability
to boot?

Correct me if I'm wrong, but linux was able to boot without
the boottime QueryVariableInfo() call up until 3.9-rc7,
and it still does on systems that do not use EFI stubs (ie
grub and elilo).  It is only when linux uses EFI stubs (ie
grub2) that linux makes the boottime QueryVariableInfo()
call.  So why is that call, or whatever is dependent on it,
more important than booting?



Thanks,
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja-sJ/iWh9BUns@public.gmane.org
