From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Date: Fri, 31 May 2013 17:28:16 +0100
Message-ID: <20130531162815.GA8082@srcf.ucam.org>
References: <20130530221737.GA11105@sgi.com>
 <alpine.LNX.2.00.1305310023020.30576@pobox.suse.cz>
 <20130531101250.GD30394@gmail.com>
 <alpine.LNX.2.00.1305311259520.30576@pobox.suse.cz>
 <20130531123015.GC17843@nazgul.tnic>
 <20130531124356.GA8212@gmail.com>
 <20130531143425.GA5850@srcf.ucam.org>
 <1370011357.1913.15.camel@dabdike.int.hansenpartnership.com>
 <20130531144826.GB5850@srcf.ucam.org>
 <20130531154348.GA17145@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130531154348.GA17145-sJ/iWh9BUns@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, May 31, 2013 at 10:43:49AM -0500, Russ Anderson wrote:

> When did writing EFI variables to nvram become necessary to boot on 
> UEFI? And if it is necessary, why is it that only linux boot loaders 
> that use EFI stubs (generally grub2) need it?  The current kernel 
> boots using EFI/grub and EFI/elilo.  It is just when EFI stubs are 
> used that the boot fails.

I think you've misunderstood the problem. If nvram becaomes full, some 
systems crash during firmware initialisation. So we can't let nvram 
become full. The obvious thing to do here is to look at the values from 
QueryVariableInfo, but many systems won't perform any garbage collection 
until they're almost out of space and so variables that have been 
deleted still show up as used space. We can work around that by adding 
up the size of the variables ourselves, but that only gives us the value 
for runtime-visible variables. We also need to know how much space is 
used by variables that are only visible during boot, hence calling 
QueryVariableInfo before ExitBootServices.

> Which means the previous patch(es) that caused the bricking should
> get pulled, too.

There are no patches that cause the bricking.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
