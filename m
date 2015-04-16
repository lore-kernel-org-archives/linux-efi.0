From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Subject: RE: [PATCH v4 2/2] efi: an sysfs interface for user to update efi
 firmware
Date: Thu, 16 Apr 2015 09:42:31 +0000
Message-ID: <F54AEECA5E2B9541821D670476DAE19C2B8D2E74@PGSMSX102.gar.corp.intel.com>
References: <1429004697-28320-1-git-send-email-hock.leong.kweh@intel.com>
 <1429004697-28320-3-git-send-email-hock.leong.kweh@intel.com>
 <20150414140914.GE5989@kroah.com>
 <F54AEECA5E2B9541821D670476DAE19C2B8D2AEA@PGSMSX102.gar.corp.intel.com>
 <20150415131906.GC21491@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150415131906.GC21491@kroah.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ming Lei <ming.lei@canonical.com>, Matt Fleming <matt@console-pimps.org>, "Ong, Boon Leong" <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Sam Protsenko <semen.protsenko@linaro.org>, Peter Jones <pjones@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Roy Franz <roy.franz@linaro.org>, Borislav Petkov <bp@alien8.de>
List-Id: linux-efi@vger.kernel.org

> -----Original Message-----
> From: Greg Kroah-Hartman [mailto:gregkh@linuxfoundation.org]
> Sent: Wednesday, April 15, 2015 9:19 PM
> 
> On Wed, Apr 15, 2015 at 11:32:29AM +0000, Kweh, Hock Leong wrote:
> > > -----Original Message-----
> > > From: Greg Kroah-Hartman [mailto:gregkh@linuxfoundation.org]
> > > Sent: Tuesday, April 14, 2015 10:09 PM
> > >
> > > On Tue, Apr 14, 2015 at 05:44:56PM +0800, Kweh, Hock Leong wrote:
> > > > From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
> > > >
> > > > Introducing a kernel module to expose capsule loader interface
> > > > for user to upload capsule binaries. This module leverage the
> > > > request_firmware_direct_full_path() to obtain the binary at a
> > > > specific path input by user.
> > > >
> > > > Example method to load the capsule binary:
> > > > echo -n "/path/to/capsule/binary" >
> > > /sys/devices/platform/efi_capsule_loader/capsule_loader
> > >
> > > Ick, why not just have the firmware file location present, and copy it
> > > to the sysfs file directly from userspace, instead of this two-step
> > > process?
> >
> > Err .... I may not catch your meaning correctly. Are you trying to say
> > that you would prefer the user to perform:
> >
> > cat file.bin > /sys/.../capsule_loader
> >
> > instead of
> >
> > echo -n "/path/to/binary" > /sys/..../capsule_laoder
> 
> Yes.  What's the namespace of your /path/to/binary/ and how do you know
> the kernel has the same one when it does the firmware load call?  By
> just copying the data with 'cat', you don't have to worry about
> namespace issues at all.

Hi Greg,

Let me double confirm that I understand your concern correctly. You are
trying to tell that some others module may use a 'same' namespace to
request the firmware but never release it. Then when our module trying
to request the firmware by passing in the 'same' namespace, I will get the
previous data instead of the current binary data from the path I want.

Hmm .... I believe this concern also apply to all the current request_firmware
APIs right? And I believe the coincidence to have 'same' file name namespace
would be higher than full path namespace.

I may not able to control other module developers on the namespace naming.
But I could ensure each firmware request will be released before the next
request firmware happen in this module. This module will return error if it
does not receive a real efi capsule binary.

Hmm ......

> 
> > The reason we stick with the firmware_class is because we don't
> > want to replicate a code which already mature and has open API
> > for developer to use.
> 
> That's fine, but adding a new api to the firmware interface seems odd to
> me, just because you don't like using /lib/ or any of the other
> "standard" locations for firmware blobs.  And note, that path is
> configurable.

If I am not mistaken, I believe you are referring the module param path.
Yes, I do aware of it. If I need a more flexibility method to alter the custom
path, the current design would require system reboot or module re-insmod.
So, leveraging the request_firmware_direct_full_path() could make things
a little bit easier from this point of view.

Besides, this new API actually helps to overcome the confusedness of having
2 or more same file name binaries at the firmware search paths (fw_path_para;
/lib/firmware/update/; /lib/firmware/). Due to user have the possibility to
configure kernel command param / module param for this fw_path_para,
it may have chances to point to a path that have same file name the /lib/firmware/
also have. With this API, it can make it specific to the path that developer wants. 

> 
> > > > + */
> > > > +static void __exit efi_capsule_loader_exit(void)
> > > > +{
> > > > +	platform_device_unregister(efi_capsule_pdev);
> > >
> > > This is not a platform device, don't abuse that interface please.
> > >
> > > greg k-h
> >
> > Okay, so you would recommend to use device_register() for this case?
> > Or you would think that this is more suitable to use class_register()?
> 
> A class isn't needed, you just want a device right?  So just use a
> device, but not a platform device, as that isn't what you have here.
> 
> thanks,
> 
> greg k-h

Okay, will do this. Thanks.


Regards,
Wilson
