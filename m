From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v4 2/2] efi: an sysfs interface for user to update efi
 firmware
Date: Mon, 20 Apr 2015 10:59:08 -0700
Message-ID: <1429552748.2222.49.camel@HansenPartnership.com>
References: <1429004697-28320-1-git-send-email-hock.leong.kweh@intel.com>
	 <1429004697-28320-3-git-send-email-hock.leong.kweh@intel.com>
	 <20150414140914.GE5989@kroah.com>
	 <F54AEECA5E2B9541821D670476DAE19C2B8D2AEA@PGSMSX102.gar.corp.intel.com>
	 <20150415131906.GC21491@kroah.com>
	 <F54AEECA5E2B9541821D670476DAE19C2B8D2E74@PGSMSX102.gar.corp.intel.com>
	 <20150417134924.GB19794@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150417134924.GB19794@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>, Ming Lei <ming.lei@canonical.com>, Matt Fleming <matt@console-pimps.org>, "Ong, Boon Leong" <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Sam Protsenko <semen.protsenko@linaro.org>, Peter Jones <pjones@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Roy Franz <roy.franz@linaro.org>, Borislav Petkov <bp@alien8.de>
List-Id: linux-efi@vger.kernel.org

On Fri, 2015-04-17 at 15:49 +0200, Greg Kroah-Hartman wrote:
> On Thu, Apr 16, 2015 at 09:42:31AM +0000, Kweh, Hock Leong wrote:
> > > -----Original Message-----
> > > From: Greg Kroah-Hartman [mailto:gregkh@linuxfoundation.org]
> > > Sent: Wednesday, April 15, 2015 9:19 PM
> > > 
> > > On Wed, Apr 15, 2015 at 11:32:29AM +0000, Kweh, Hock Leong wrote:
> > > > > -----Original Message-----
> > > > > From: Greg Kroah-Hartman [mailto:gregkh@linuxfoundation.org]
> > > > > Sent: Tuesday, April 14, 2015 10:09 PM
> > > > >
> > > > > On Tue, Apr 14, 2015 at 05:44:56PM +0800, Kweh, Hock Leong wrote:
> > > > > > From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
> > > > > >
> > > > > > Introducing a kernel module to expose capsule loader interface
> > > > > > for user to upload capsule binaries. This module leverage the
> > > > > > request_firmware_direct_full_path() to obtain the binary at a
> > > > > > specific path input by user.
> > > > > >
> > > > > > Example method to load the capsule binary:
> > > > > > echo -n "/path/to/capsule/binary" >
> > > > > /sys/devices/platform/efi_capsule_loader/capsule_loader
> > > > >
> > > > > Ick, why not just have the firmware file location present, and copy it
> > > > > to the sysfs file directly from userspace, instead of this two-step
> > > > > process?
> > > >
> > > > Err .... I may not catch your meaning correctly. Are you trying to say
> > > > that you would prefer the user to perform:
> > > >
> > > > cat file.bin > /sys/.../capsule_loader
> > > >
> > > > instead of
> > > >
> > > > echo -n "/path/to/binary" > /sys/..../capsule_laoder
> > > 
> > > Yes.  What's the namespace of your /path/to/binary/ and how do you know
> > > the kernel has the same one when it does the firmware load call?  By
> > > just copying the data with 'cat', you don't have to worry about
> > > namespace issues at all.
> > 
> > Hi Greg,
> > 
> > Let me double confirm that I understand your concern correctly. You are
> > trying to tell that some others module may use a 'same' namespace to
> > request the firmware but never release it. Then when our module trying
> > to request the firmware by passing in the 'same' namespace, I will get the
> > previous data instead of the current binary data from the path I want.
> 
> Yes.
> 
> > Hmm .... I believe this concern also apply to all the current request_firmware
> > APIs right? And I believe the coincidence to have 'same' file name namespace
> > would be higher than full path namespace.
> 
> Not really, the kernel namespace is what matters at that point in time.
> 
> And maybe it does matter, I haven't thought through all of the issues.
> But passing a path from userspace, to the kernel, to have the kernel
> turn around again and use that path is full of nasty consequences at
> times due to namespaces, let's avoid all of that please.

So just to clarify this, namespaces are designed not to cause a problem
here, provided the operation is handled correctly (this is key; it is
easy do design operations which will screw up no end if done wrongly).

The file name to object translation is handled by the mount name space,
which is the operative one of the process doing the echo.  For a
longstanding object (i.e. one which will exist beyond the call to the
system of the current process) you need either to convert to the actual
underlying object (usually a file descriptor) which has an existence
independent of the namespace (and perform all the necessary security
validations before returning control back to userspace, so they occur
within all the namespace constraints of the calling process), or store
sufficient information to redo whatever operation you need to within the
namespace (the former is by far preferred for long lived operations).

James
