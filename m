From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 3/3] efi: Capsule update with user helper interface
Date: Tue, 4 Nov 2014 14:18:08 +0000
Message-ID: <1415110688.26277.36.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1414984030-13859-1-git-send-email-hock.leong.kweh@intel.com>
	 <1414984030-13859-4-git-send-email-hock.leong.kweh@intel.com>
	 <20141104043247.GA23418@kroah.com>
	 <CALCETrXjJju+cMWJfB6W5kSD=Ox5y+Hj_AfmbbbOTOh8CV8eaQ@mail.gmail.com>
	 <F54AEECA5E2B9541821D670476DAE19C2B80EAE4@PGSMSX102.gar.corp.intel.com>
	 <CALCETrU2wk_FdcD6E+oMcp-tF97zN7f+w7q5rfPWBaNKrrmxVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrU2wk_FdcD6E+oMcp-tF97zN7f+w7q5rfPWBaNKrrmxVg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 2014-11-03 at 22:32 -0800, Andy Lutomirski wrote:
> 
> It seems like a large fraction of the code in this module exists just
> to work around the fact that request_firmware doesn't do what you want
> it to do.  You have code to:
> 
>  - Prevent the /lib/firmware mechanism from working.
>  - Avoid a deadlock by doing strange things in the unload code.
>  - Allow more than one capsule per module load.  (Isn't this hard to
> use?  User code will have to wait for the next firmware request before
> sending a second capsule.)
> 
> All of this is for dubious gain.  You have to do three separate opens
> in sysfs to upload a capsule, and there's no way to report back to
> userspace whether the EFI call worked and whether a reboot is needed.

Whether or not a reboot is required is indicated in the capsule image
itself, i.e. the capsule tells the firmware whether an immediate reboot
is required not the other way around.

The firmware does tell the kernel what *kind* of a reboot is required,
but that doesn't need reporting to userspace.

> What's the benefit of using the firmware interface here?

I originally implemented something to send capsules to the firmware via
sysfs files back in 2013 and I basically ended up duplicating 25% of the
code that's already in drivers/base/firmware_class.c.

If you're objecting to the lack of modularity in firmware_class.c, then
we could probably carve up the functionality we require a little more
neatly (like not having to do the /lib/firmware avoidance hacks), but
firmware_class.c should definitely be used as the foundation.
