From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Date: Sat, 1 Jun 2013 15:40:08 +0100
Message-ID: <20130601144008.GA23140@srcf.ucam.org>
References: <alpine.LNX.2.00.1305300048520.30576@pobox.suse.cz>
 <1369880172.17397.11.camel@linux-s257.site>
 <20130530221737.GA11105@sgi.com>
 <alpine.LNX.2.00.1305310023020.30576@pobox.suse.cz>
 <20130531101250.GD30394@gmail.com>
 <alpine.LNX.2.00.1305311259520.30576@pobox.suse.cz>
 <20130531123015.GC17843@nazgul.tnic>
 <20130531124356.GA8212@gmail.com>
 <20130531143425.GA5850@srcf.ucam.org>
 <alpine.LFD.2.03.1306011956350.9068@pixel.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.03.1306011956350.9068-OR3hLWCBCApQetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, Jun 01, 2013 at 08:01:59PM +0900, Linus Torvalds wrote:
> On Fri, 31 May 2013, Matthew Garrett wrote:
> > 
> > I agree that a revert is probably the right thing to do here, but the 
> > original patch was there to permit a more accurate calculation of the 
> > amount of nvram in use, not to provide additional debug information. 
> > Reverting it is going to differently break a different set of systems
> 
> So "differently break" doesn't matter, if it's old breakage, and people 
> thus don't really expect it to work. We need to fix bugs without *new* 
> breakage, and quite frankly, I have been distressed by hearing the EFI 
> "specifications" mentioned so many times in this thread.

The old breakage has only ever been present in -rcs, not in released 
kernels. We worked around the worst of it with the patchset that's 
causing the problems. We can avoid that old breakage by reverting the 
patches that introduced it, but that gets us back to bricking some 
machines.

> Anyway, I'm traveling with absolutely horrendous internet access, so can 
> somebody please send a description of the revert with the relevant 
> information, because I literally have a hard time extracting it all from 
> this thread because my email access is so slow and flaky... Make it easy 
> for me to do the revert with a good explanation message, please,

I've finally got some information from Samsung that *should* let us fix 
this without anything else breaking in the process, but since we're 
dealing with firmware there's obviously a risk that that won't actually 
be true. I'll send that later today.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
