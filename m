From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Re: [PATCH v2 3/3] efi: Capsule update with user helper interface
Date: Fri, 6 Mar 2015 16:39:12 -0500
Message-ID: <20150306213912.GA8020@fenchurch.internal.datastacks.com>
References: <F54AEECA5E2B9541821D670476DAE19C2B8AC95C@PGSMSX102.gar.corp.intel.com>
 <F54AEECA5E2B9541821D670476DAE19C2B8AC9DD@PGSMSX102.gar.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <F54AEECA5E2B9541821D670476DAE19C2B8AC9DD-j2khPEwRog0FyVwBAnZdSLfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Feb 24, 2015 at 12:49:09PM +0000, Kweh, Hock Leong wrote:
> Hi All,
> 
> After some internal discussion and re-design prototyping & testing on
> this efi capsule interface kernel module, I would like to start a discussion
> here on the new idea and wish to get input for the implementation and
> eventually upstream.

So do we actually *need* a kernel interface to UpdateCapsule?  We've
already got an implementation in progress where we use my ESRT patch to
figure out what firmwares we can update, and we schedule them and do the
update during boot up before the normal bootloader is run.  That means
never having to call UpdateCapsule() after ExitBootServices() or
SetVirtualAddressMap() have been called, and only doing it across
reboots that UEFI is performing itself.  It also means never having to
do it with multiple CPUs running.

I've posted several revisions of the ESRT patch to linux-efi , and right
now we're just waiting on the UEFI 2.5 spec to be finalized before I
send a final copy to Matt.  The command line tool and the code to apply
the firmwares during boot are at https://github.com/rhinstaller/fwupdate
and there's a GNOME-based UI in progress at
https://github.com/hughsie/fwupd (yes we apparently stink at naming
things.)

I'm not sure how making this go through the kernel will make things
better - it introduces a lot more things that can go wrong, and the only
benefit is one reboot where BootNext is set - which actually is
relatively fast even slow-POSTing machines.  After that the
UpdateCapsule+reboot to apply is *extremely* fast, because
applying capsule updates have to happen very very early in the boot-up
sequence.  (That early processing is /effectively/ a requirement,
since it has to happen before the block write locking on the SPI part is
done.)  So even on the machine that takes quite some time to POST, the
time that would be saved saved is less than 1% or so of the total update
time.

An early version of my code worked to update a machine I got from your
employer, FWIW - right now we're adding API and fixing up implementation
bits I made specifically to that one proof-of-concept scenario, and
there's some API parts that are in UEFI 2.5 draft releases that we're
not quite handling yet.  However, there's code there that's already been
checked in which has successfully applied system firmware updates
without having a kernel interface to UpdateCapsule().

So again: do we really need or want to do this?

-- 
        Peter
