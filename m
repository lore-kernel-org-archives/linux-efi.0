From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Date: Sat, 1 Jun 2013 05:41:00 +0100
Message-ID: <20130601044100.GA18453@srcf.ucam.org>
References: <20130531123015.GC17843@nazgul.tnic>
 <20130531124356.GA8212@gmail.com>
 <20130531143425.GA5850@srcf.ucam.org>
 <1370011357.1913.15.camel@dabdike.int.hansenpartnership.com>
 <20130531144826.GB5850@srcf.ucam.org>
 <20130531154348.GA17145@sgi.com>
 <20130531162815.GA8082@srcf.ucam.org>
 <20130531225730.GB14752@sgi.com>
 <20130601000311.GA15126@srcf.ucam.org>
 <20130601042058.GB15199@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130601042058.GB15199-sJ/iWh9BUns@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, May 31, 2013 at 11:20:59PM -0500, Russ Anderson wrote:

> And when QueryVariableInfo reports insufficient space, don't write
> and everything is fine.

And then installs fail, which is why we implemented this additional 
code.

> But when QueryVariableInfo reports insufficient space and you
> write anyway, the system can get bricked.  Is that the problem?

No.

> Some bios implementation may be "*including garbage*", but can
> you definitively say ALL do?  The spec explicitly says "the
> implementation of variable storage is not defined in this
> specification".  You can't assume any form of garbage collection.

No. We can't assume that. But nor can we rely upon the spec, because 
behaving according to the spec results in dead computers. So we're 
forced to write code that behaves according to reality rather than 
paper, which is unfortunate, but if *your* firmware behaved according to 
the specification then you wouldn't be seeing any problems with the 
current code, so I think there's a lesson for us all here.

> I don't see anything in here about the OS being free to use
> more nvram than QueryVariableInfo() reported as being available.
> What happened to following the spec?

That would be the same spec that tells you not to use physical addresses 
after SetVirtualAddressMap() has been called, right? Regardless, we 
don't use more space than QueryVariableInfo() reports as being 
available. We would expect that any attempt to do so would fail. But nor 
can we assume that we're free to use as much space as 
QueryVariableInfo() *does* report, because doing so results in dead 
computers. So instead we're forced to rely on workarounds that happen to 
break your broken firmware, so now we're going to have to find a 
different set of workarounds and hope that they don't break someone 
else's computer instead.

> > There's a limited number of situations where the firmware can write to 
> > nvram, but they're basically uninteresting. Practically speaking, it's 
> > always via the kernel once ExitBootServices() has been called.
> 
> How can you say "they're basically uninteresting"???
> Do you know what EVERY bios implementation does???

We have to assume that firmware doesn't behave in a pathological manner, 
because the alternative is to give up entirely and declare that Linux 
doesn't run on UEFI systems. I suspect that that would be problematic 
for your employers.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
