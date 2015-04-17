From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v4 2/2] efi: an sysfs interface for user to update efi
 firmware
Date: Fri, 17 Apr 2015 15:49:24 +0200
Message-ID: <20150417134924.GB19794@kroah.com>
References: <1429004697-28320-1-git-send-email-hock.leong.kweh@intel.com>
 <1429004697-28320-3-git-send-email-hock.leong.kweh@intel.com>
 <20150414140914.GE5989@kroah.com>
 <F54AEECA5E2B9541821D670476DAE19C2B8D2AEA@PGSMSX102.gar.corp.intel.com>
 <20150415131906.GC21491@kroah.com>
 <F54AEECA5E2B9541821D670476DAE19C2B8D2E74@PGSMSX102.gar.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <F54AEECA5E2B9541821D670476DAE19C2B8D2E74-j2khPEwRog0FyVwBAnZdSLfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Apr 16, 2015 at 09:42:31AM +0000, Kweh, Hock Leong wrote:
> > -----Original Message-----
> > From: Greg Kroah-Hartman [mailto:gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org]
> > Sent: Wednesday, April 15, 2015 9:19 PM
> > 
> > On Wed, Apr 15, 2015 at 11:32:29AM +0000, Kweh, Hock Leong wrote:
> > > > -----Original Message-----
> > > > From: Greg Kroah-Hartman [mailto:gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org]
> > > > Sent: Tuesday, April 14, 2015 10:09 PM
> > > >
> > > > On Tue, Apr 14, 2015 at 05:44:56PM +0800, Kweh, Hock Leong wrote:
> > > > > From: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > >
> > > > > Introducing a kernel module to expose capsule loader interface
> > > > > for user to upload capsule binaries. This module leverage the
> > > > > request_firmware_direct_full_path() to obtain the binary at a
> > > > > specific path input by user.
> > > > >
> > > > > Example method to load the capsule binary:
> > > > > echo -n "/path/to/capsule/binary" >
> > > > /sys/devices/platform/efi_capsule_loader/capsule_loader
> > > >
> > > > Ick, why not just have the firmware file location present, and copy it
> > > > to the sysfs file directly from userspace, instead of this two-step
> > > > process?
> > >
> > > Err .... I may not catch your meaning correctly. Are you trying to say
> > > that you would prefer the user to perform:
> > >
> > > cat file.bin > /sys/.../capsule_loader
> > >
> > > instead of
> > >
> > > echo -n "/path/to/binary" > /sys/..../capsule_laoder
> > 
> > Yes.  What's the namespace of your /path/to/binary/ and how do you know
> > the kernel has the same one when it does the firmware load call?  By
> > just copying the data with 'cat', you don't have to worry about
> > namespace issues at all.
> 
> Hi Greg,
> 
> Let me double confirm that I understand your concern correctly. You are
> trying to tell that some others module may use a 'same' namespace to
> request the firmware but never release it. Then when our module trying
> to request the firmware by passing in the 'same' namespace, I will get the
> previous data instead of the current binary data from the path I want.

Yes.

> Hmm .... I believe this concern also apply to all the current request_firmware
> APIs right? And I believe the coincidence to have 'same' file name namespace
> would be higher than full path namespace.

Not really, the kernel namespace is what matters at that point in time.

And maybe it does matter, I haven't thought through all of the issues.
But passing a path from userspace, to the kernel, to have the kernel
turn around again and use that path is full of nasty consequences at
times due to namespaces, let's avoid all of that please.

thanks,

greg k-h
