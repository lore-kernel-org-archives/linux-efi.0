From: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Wed, 31 Oct 2012 23:00:42 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1210312259300.22374@pobox.suse.cz>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com> <20121031171743.GA17652@srcf.ucam.org> <20121031173919.4fc63ddd@pyramind.ukuu.org.uk> <2548314.3caaFsMVg6@linux-lqwf.site> <50919EED.3020601@genband.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50919EED.3020601-b7o/lNNmKxtBDgjK7y7TUQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Friesen <chris.friesen-b7o/lNNmKxtBDgjK7y7TUQ@public.gmane.org>
Cc: Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Josh Boyer <jwboyer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 31 Oct 2012, Chris Friesen wrote:

> > That would do it on my system.
> > Maybe in theory you could solve this by the kernel invalidating images
> > it hasn't written itself and forbidding to change the resume partition from
> > the
> > kernel command line, but that would break user space hibernation.
> 
> If the resuming kernel refuses to resume from images it didn't create itself,
> why do you need to forbid changing the resume partition from the kernel
> command line?

Yeah, it can definitely be solved by pushing keys around from shim to 
kernel (and kernel discarding the private keys at right moments). It just 
needs to be implemented.

-- 
Jiri Kosina
SUSE Labs
