From: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v4 2/2] efi: an sysfs interface for user to update efi
 firmware
Date: Mon, 20 Apr 2015 03:28:32 +0000
Message-ID: <F54AEECA5E2B9541821D670476DAE19C2C279176@PGSMSX101.gar.corp.intel.com>
References: <1429004697-28320-1-git-send-email-hock.leong.kweh@intel.com>
 <1429004697-28320-3-git-send-email-hock.leong.kweh@intel.com>
 <20150414140914.GE5989@kroah.com>
 <F54AEECA5E2B9541821D670476DAE19C2B8D2AEA@PGSMSX102.gar.corp.intel.com>
 <20150415131906.GC21491@kroah.com>
 <F54AEECA5E2B9541821D670476DAE19C2B8D2E74@PGSMSX102.gar.corp.intel.com>
 <20150417134924.GB19794@kroah.com>
 <20150417143640.GB3671@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150417143640.GB3671-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> -----Original Message-----
> From: Matt Fleming [mailto:matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org]
> Sent: Friday, April 17, 2015 10:37 PM
> 
> On Fri, 17 Apr, at 03:49:24PM, Greg KH wrote:
> >
> > Not really, the kernel namespace is what matters at that point in time.
> >
> > And maybe it does matter, I haven't thought through all of the issues.
> > But passing a path from userspace, to the kernel, to have the kernel
> > turn around again and use that path is full of nasty consequences at
> > times due to namespaces, let's avoid all of that please.
> 
> Oh crap. The namespace issue is a good point and not something I'd
> thought of at all.
> 
> At this point, I think we've really run out of objections to Andy's
> suggestion of implementing this as a misc device, right?
> 
> The concern I had about userspace tooling can partly be addressed by
> including the source in tools/ in the kernel tree. So provided we do
> that, I'm happy enough to see this implemented as a misc device because
> the other options we've explored just haven't panned out.
> 
> Objections?
> 
> --
> Matt Fleming, Intel Open Source Technology Center

Hi Greg, Matt & Andy,

Wait .... wait a minute. I am lost. I think I have missed something.
Let me summarize the message I got from the email threads.
=========================================================
Greg:- Recommends to use "cat file.bin > /sys/.../capsule_loader" due to
there is concern on kernel namespace with this submitted design which using
the request firmware API.

Andy:- Prefer to have an interface that could return the error code and
suggested char device where the ioctl can meet the purpose.

Matt:- Prefer to use kernel interface only as embedded world may not want
to include userland tool.
==========================================================

I think I have missed somewhere why not using "cat file.bin > /sys/.../loader"
and now change to misc device. Is it because the ioctl could return a custom
error code (for example: platform not supported, capsule header error)
where the "cat file.bin > /sys/.../loader" interface cannot do? Hmm ......

Regarding the 'reboot require' status, is it critical to have a 1 to 1 status match
with the capsule upload binary? Is it okay to have one sysfs file note to tell the
overall status (for example: 10 capsule binaries uploaded but one require
reboot, so the status shows reboot require is yes)? I am not here trying to argue
anything. I am just trying to find out what kind of info is needed but the sysfs
could not provide. 

Please imagine if your whole Linux system (kernel + rootfs) has to fit into 6MB
space and you don't even have the gcc compiler included into the package.
I believe in this environment, kernel interface + shell command is the only
interaction that user could work with.

Btw, just to make sure I get it correctly, is misc device refer to the device
that created by misc_register() from drivers/char/misc.c and not asked to
put this kernel module under drivers/misc/* location, right?

And Matt mentioned including the source into tools/* in kernel tree. I have
a question: Is this tool can be compiled during kernel compilation and
eventually auto included into the rootfs package? Sorry, I am new to OS
creation and maybe this is stupid question.


Thanks & Regards,
Wilson
