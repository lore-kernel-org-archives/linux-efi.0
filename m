From: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Date: Sat, 1 Jun 2013 01:30:39 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1306010124420.2852@pobox.suse.cz>
References: <alpine.LNX.2.00.1305310023020.30576@pobox.suse.cz> <20130531101250.GD30394@gmail.com> <alpine.LNX.2.00.1305311259520.30576@pobox.suse.cz> <20130531123015.GC17843@nazgul.tnic> <20130531124356.GA8212@gmail.com> <20130531143425.GA5850@srcf.ucam.org>
 <1370011357.1913.15.camel@dabdike.int.hansenpartnership.com> <20130531144826.GB5850@srcf.ucam.org> <20130531154348.GA17145@sgi.com> <20130531162815.GA8082@srcf.ucam.org> <20130531225730.GB14752@sgi.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130531225730.GB14752-sJ/iWh9BUns@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>
Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 31 May 2013, Russ Anderson wrote:

> OK.  I get nvram looks full due to lack of garbage collection
> on some systems.  Does QueryVariableInfo (at runtime) tell you
> it is full?  Is the problem that it says it is full when it
> is not, or does not tell you it is full when it is?

We are trying to count the size occupied by existing UEFI variables. 
QueryVariableInfo() called from runtime environment doesn't give a full 
picture, as it doesn't provide information about boot-only variables.

Hence the patch.

> > up the size of the variables ourselves, but that only gives us the value 
> > for runtime-visible variables. We also need to know how much space is 
> > used by variables that are only visible during boot,
> 
> Is it valid to assume that only the kernel writes to nvram at
> runtime?  

Well, mostly yes. But if the kernel doesn't know what the initial state 
is, it can't count the size properly.

> > > Which means the previous patch(es) that caused the bricking should
> > > get pulled, too.
> > 
> > There are no patches that cause the bricking.
> 
> I thought that was the problem you were trying to avoid.

The problem that needs to be avoided is machines turning into bricks if 
EFI storage nvram is getting full.

-- 
Jiri Kosina
SUSE Labs
