From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Date: Sat, 1 Jun 2013 20:01:59 +0900 (PWT)
Message-ID: <alpine.LFD.2.03.1306011956350.9068@pixel.linux-foundation.org>
References: <alpine.LRH.2.00.1305300018180.1111@twin.jikos.cz> <20130529224645.GA16582@sgi.com> <alpine.LNX.2.00.1305300048520.30576@pobox.suse.cz> <1369880172.17397.11.camel@linux-s257.site> <20130530221737.GA11105@sgi.com> <alpine.LNX.2.00.1305310023020.30576@pobox.suse.cz>
 <20130531101250.GD30394@gmail.com> <alpine.LNX.2.00.1305311259520.30576@pobox.suse.cz> <20130531123015.GC17843@nazgul.tnic> <20130531124356.GA8212@gmail.com> <20130531143425.GA5850@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130531143425.GA5850-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-efi@vger.kernel.org



On Fri, 31 May 2013, Matthew Garrett wrote:
> 
> I agree that a revert is probably the right thing to do here, but the 
> original patch was there to permit a more accurate calculation of the 
> amount of nvram in use, not to provide additional debug information. 
> Reverting it is going to differently break a different set of systems

So "differently break" doesn't matter, if it's old breakage, and people 
thus don't really expect it to work. We need to fix bugs without *new* 
breakage, and quite frankly, I have been distressed by hearing the EFI 
"specifications" mentioned so many times in this thread.

Firmware specs are pure and utter garbage. They are irrelevant. Firmware 
is buggy, and will always be buggy. The "spec" doesn't matter. We should 
use firmware for loading the kernel, and as little else as humanly 
possible.

I'm very disappointed in how the EFI code doesn't seem to understand that. 
There's tons of these stupid EFI variable crap that simply shouldn't 
matter. Quite frankly, we'd be better off ignoring as much of it by 
default as at all possible. Exactly because the more of an EFI interface 
we have, the more we open us up to th einevitable firmware bugs.

Anyway, I'm traveling with absolutely horrendous internet access, so can 
somebody please send a description of the revert with the relevant 
information, because I literally have a hard time extracting it all from 
this thread because my email access is so slow and flaky... Make it easy 
for me to do the revert with a good explanation message, please,

               Linus
