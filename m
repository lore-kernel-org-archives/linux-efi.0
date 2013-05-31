From: "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Date: Fri, 31 May 2013 07:45:10 -0700
Message-ID: <51A8B776.8040701@linux.intel.com>
References: <alpine.LRH.2.00.1305300018180.1111@twin.jikos.cz>  <20130529224645.GA16582@sgi.com>  <alpine.LNX.2.00.1305300048520.30576@pobox.suse.cz>  <1369880172.17397.11.camel@linux-s257.site>  <20130530221737.GA11105@sgi.com>  <alpine.LNX.2.00.1305310023020.30576@pobox.suse.cz>  <20130531101250.GD30394@gmail.com>  <alpine.LNX.2.00.1305311259520.30576@pobox.suse.cz>  <20130531123015.GC17843@nazgul.tnic> <20130531124356.GA8212@gmail.com>  <20130531143425.GA5850@srcf.ucam.org> <1370011357.1913.15.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1370011357.1913.15.camel-sFMDBYUN5F8GjUHQrlYNx2Wm91YjaHnnhRte9Li2A+AAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 05/31/2013 07:42 AM, James Bottomley wrote:
> 
> The only ones that are broken are the Samsung ones.  Samsung claims to
> have fixed their UEFI firmware, so we could refer any problems to them.
> 
> The signature of the Samsung failure, which this is guarding against is
> that the laptop gets bricked, so it really is a nasty choice of poisons
> we have to pick...
> 

Are we sure it is only Samsung?  I was under the impression there were
other systems with similar failures?

	-hpa
