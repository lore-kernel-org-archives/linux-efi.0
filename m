From: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v4 2/2] efi: an sysfs interface for user to update efi
 firmware
Date: Tue, 21 Apr 2015 03:23:55 +0000
Message-ID: <F54AEECA5E2B9541821D670476DAE19C2CC11869@PGSMSX102.gar.corp.intel.com>
References: <1429004697-28320-1-git-send-email-hock.leong.kweh@intel.com>
 <1429004697-28320-3-git-send-email-hock.leong.kweh@intel.com>
 <20150414140914.GE5989@kroah.com>
 <F54AEECA5E2B9541821D670476DAE19C2B8D2AEA@PGSMSX102.gar.corp.intel.com>
 <20150415131906.GC21491@kroah.com>
 <F54AEECA5E2B9541821D670476DAE19C2B8D2E74@PGSMSX102.gar.corp.intel.com>
 <20150417134924.GB19794@kroah.com>
 <20150417143640.GB3671@codeblueprint.co.uk>
 <F54AEECA5E2B9541821D670476DAE19C2C279176@PGSMSX101.gar.corp.intel.com>
 <20150420144323.GA7261@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150420144323.GA7261-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> -----Original Message-----
> From: Greg Kroah-Hartman [mailto:gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org]
> Sent: Monday, April 20, 2015 10:43 PM
> 
> On Mon, Apr 20, 2015 at 03:28:32AM +0000, Kweh, Hock Leong wrote:
> > Regarding the 'reboot require' status, is it critical to have a 1 to 1 status
> match
> > with the capsule upload binary? Is it okay to have one sysfs file note to tell
> the
> > overall status (for example: 10 capsule binaries uploaded but one require
> > reboot, so the status shows reboot require is yes)? I am not here trying to
> argue
> > anything. I am just trying to find out what kind of info is needed but the
> sysfs
> > could not provide.
> >
> > Please imagine if your whole Linux system (kernel + rootfs) has to fit into
> 6MB
> > space and you don't even have the gcc compiler included into the package.
> > I believe in this environment, kernel interface + shell command is the only
> > interaction that user could work with.
> 
> Why would you have to have gcc on such a system?  Why is that a
> requirement for having an ioctl/char interface?

This is my logic:
- Besides writing a C program (for example), I am not aware any shell script
  could perform an ioctl function call. This led me to if I don't have an execution
  binary then I need a compiler to compile the source to execution binary.

- For embedded product as mentioned above, not all vendors willing to carry
  the userland tool when they are struggling to fit into small memory space.
  Yet, you may say this tool would not eat up a lot of space compare to others.
  But when the source of this tool being upstream-ed to the tools/ kernel tree,
  we cannot stop people to contribute and make the tool more features support,
  eventually the embedded product may need to drop the tool.

> 
> And if you only have 6Mb of space, you don't have UEFI, sorry, there's
> no way that firmware can get that small.

Actually there is. Quark is one of the examples. The kernel + rootfs take
up 6MB and the UEFI consume only 2MB, so total size 8MB in the spi chip.
If you have an Intel Galileo board, you don't need any mass storage (SD & USB),
you are able to boot to Linux console.


Thanks & Regards,
Wilson
