From: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Thu, 1 Nov 2012 10:20:08 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1211011017230.6606@pobox.suse.cz>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>  <2548314.3caaFsMVg6@linux-lqwf.site> <50919EED.3020601@genband.com>  <36538307.gzWq1oO7Kg@linux-lqwf.site> <1351760905.2391.19.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351760905.2391.19.camel-sFMDBYUN5F8GjUHQrlYNx2Wm91YjaHnnhRte9Li2A+AAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, Chris Friesen <chris.friesen-b7o/lNNmKxtBDgjK7y7TUQ@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Josh Boyer <jwboyer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 1 Nov 2012, James Bottomley wrote:

> The point I'm making is that given that the majority of exploits will 
> already be able to execute arbitrary code in-kernel, there's not much 
> point trying to consider features like this as attacker prevention.  We 
> should really be focusing on discussing why we'd want to prevent a 
> legitimate local root from writing to the suspend partition in a secure 
> boot environment.

Well, this is being repeated over and over again when talking about secure 
boot, right?

My understanding is that we are not trying to protect against root 
exploiting the kernel. We are trying to protect against root tampering 
with the kernel code and data through legitimate use of kernel-provided 
facilitiies (/dev/mem, ioperm, reprogramming devices to DMA to arbitrary 
memory locations, resuming from hibernation image that has been tampered 
with, etc).

Or perhaps I just misunderstood the point you were trying to make?

Thanks,

-- 
Jiri Kosina
SUSE Labs
