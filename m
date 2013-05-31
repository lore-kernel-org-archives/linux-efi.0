From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Date: Fri, 31 May 2013 14:43:56 +0200
Message-ID: <20130531124356.GA8212@gmail.com>
References: <20130529210115.GC28027@sgi.com>
 <alpine.LRH.2.00.1305300018180.1111@twin.jikos.cz>
 <20130529224645.GA16582@sgi.com>
 <alpine.LNX.2.00.1305300048520.30576@pobox.suse.cz>
 <1369880172.17397.11.camel@linux-s257.site>
 <20130530221737.GA11105@sgi.com>
 <alpine.LNX.2.00.1305310023020.30576@pobox.suse.cz>
 <20130531101250.GD30394@gmail.com>
 <alpine.LNX.2.00.1305311259520.30576@pobox.suse.cz>
 <20130531123015.GC17843@nazgul.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130531123015.GC17843-K5JNixvcfoxupOikMc4+xw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


* Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org> wrote:

> On Fri, May 31, 2013 at 01:06:09PM +0200, Jiri Kosina wrote:
> >
> > (*) If one would be naive enough, he'd believe that the pressure 
> > should be put on the BIOS writers instead of OS to fix the bug :)
> 
> Oh, definitely pressure on BIOS dudes. If they're in violation of the 
> spec and they still can fix it in time, they better. I'm sick and tired 
> of having to deal with BIOS idiocy in kernel code.

I'm all for some BIOS quality bashing, but the reality is:

1) It's not just about SGI/UV systems but apparently about several 
   different types of x86 laptops produce the same boot crash pattern: 
   most of which come from manufacturers that simply don't care about 
   Linux all that much.

   So by not reverting we'd screw our users, not put any recognizable 
   pressure on any BIOS writers or manufacturers.

2) Obviously Windows does not crash, and that's what most laptops test.
   So our realistic 'spec target' is not some sort of pure 'EFI spec',
   but EFI implementations _tested under Windows_. Consider it an 
   'extended EFI compatibility spec'.

3) There's a better, more robust firmware environment approach being 
   worked on (by you?) that avoids such 1:1 physical mapping assumption 
   crashes. That's something worth doing anyway, so why not delay the 
   early QueryVariableInfo() call change to when that enviroment is 
   properly implemented?

4) The revert is easy, and the functionality the original patch provided
   was a marginal increase in debug output to begin with...

So to me the right approach seems to be:

 A: revert now for v3.10
 B: implement 1:1 mappings environment for firmware, for v3.11
 C: reintroduce the early QueryVariableInfo() call again, in v3.11

Thanks,

	Ingo
