From: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v4 2/2] efi: an sysfs interface for user to update efi
 firmware
Date: Wed, 15 Apr 2015 11:32:29 +0000
Message-ID: <F54AEECA5E2B9541821D670476DAE19C2B8D2AEA@PGSMSX102.gar.corp.intel.com>
References: <1429004697-28320-1-git-send-email-hock.leong.kweh@intel.com>
 <1429004697-28320-3-git-send-email-hock.leong.kweh@intel.com>
 <20150414140914.GE5989@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150414140914.GE5989-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> -----Original Message-----
> From: Greg Kroah-Hartman [mailto:gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org]
> Sent: Tuesday, April 14, 2015 10:09 PM
> 
> On Tue, Apr 14, 2015 at 05:44:56PM +0800, Kweh, Hock Leong wrote:
> > From: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >
> > Introducing a kernel module to expose capsule loader interface
> > for user to upload capsule binaries. This module leverage the
> > request_firmware_direct_full_path() to obtain the binary at a
> > specific path input by user.
> >
> > Example method to load the capsule binary:
> > echo -n "/path/to/capsule/binary" >
> /sys/devices/platform/efi_capsule_loader/capsule_loader
> 
> Ick, why not just have the firmware file location present, and copy it
> to the sysfs file directly from userspace, instead of this two-step
> process?

Err .... I may not catch your meaning correctly. Are you trying to say
that you would prefer the user to perform:

cat file.bin > /sys/.../capsule_loader

instead of

echo -n "/path/to/binary" > /sys/..../capsule_laoder


The reason we stick with the firmware_class is because we don't
want to replicate a code which already mature and has open API
for developer to use.

> 
> > +/*
> > + * To remove this kernel module, just perform:
> > + * rmmod efi_capsule_loader.ko
> 
> This comment is not needed.

Okay, I will remove this.

> 
> 
> > + */
> > +static void __exit efi_capsule_loader_exit(void)
> > +{
> > +	platform_device_unregister(efi_capsule_pdev);
> 
> This is not a platform device, don't abuse that interface please.
> 
> greg k-h

Okay, so you would recommend to use device_register() for this case?
Or you would think that this is more suitable to use class_register()?


Thanks & Regards,
Wilson
