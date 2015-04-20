From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v4 2/2] efi: an sysfs interface for user to update efi
 firmware
Date: Mon, 20 Apr 2015 16:43:23 +0200
Message-ID: <20150420144323.GA7261@kroah.com>
References: <1429004697-28320-1-git-send-email-hock.leong.kweh@intel.com>
 <1429004697-28320-3-git-send-email-hock.leong.kweh@intel.com>
 <20150414140914.GE5989@kroah.com>
 <F54AEECA5E2B9541821D670476DAE19C2B8D2AEA@PGSMSX102.gar.corp.intel.com>
 <20150415131906.GC21491@kroah.com>
 <F54AEECA5E2B9541821D670476DAE19C2B8D2E74@PGSMSX102.gar.corp.intel.com>
 <20150417134924.GB19794@kroah.com>
 <20150417143640.GB3671@codeblueprint.co.uk>
 <F54AEECA5E2B9541821D670476DAE19C2C279176@PGSMSX101.gar.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <F54AEECA5E2B9541821D670476DAE19C2C279176@PGSMSX101.gar.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Andy Lutomirski <luto@amacapital.net>, Ming Lei <ming.lei@canonical.com>, "Ong, Boon Leong" <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Sam Protsenko <semen.protsenko@linaro.org>, Peter Jones <pjones@redhat.com>, Roy Franz <roy.franz@linaro.org>, Borislav Petkov <bp@alien8.de>
List-Id: linux-efi@vger.kernel.org

On Mon, Apr 20, 2015 at 03:28:32AM +0000, Kweh, Hock Leong wrote:
> Regarding the 'reboot require' status, is it critical to have a 1 to 1 status match
> with the capsule upload binary? Is it okay to have one sysfs file note to tell the
> overall status (for example: 10 capsule binaries uploaded but one require
> reboot, so the status shows reboot require is yes)? I am not here trying to argue
> anything. I am just trying to find out what kind of info is needed but the sysfs
> could not provide. 
> 
> Please imagine if your whole Linux system (kernel + rootfs) has to fit into 6MB
> space and you don't even have the gcc compiler included into the package.
> I believe in this environment, kernel interface + shell command is the only
> interaction that user could work with.

Why would you have to have gcc on such a system?  Why is that a
requirement for having an ioctl/char interface?

And if you only have 6Mb of space, you don't have UEFI, sorry, there's
no way that firmware can get that small.

> Btw, just to make sure I get it correctly, is misc device refer to the device
> that created by misc_register() from drivers/char/misc.c and not asked to
> put this kernel module under drivers/misc/* location, right?

Yes, use misc_register()

> And Matt mentioned including the source into tools/* in kernel tree. I have
> a question: Is this tool can be compiled during kernel compilation and
> eventually auto included into the rootfs package? Sorry, I am new to OS
> creation and maybe this is stupid question.

If you ask to build it as part of the configuration, yes, it can be
built.  See how the tools are build as part of the kernel tree for more
information about this.

thanks,

greg k-h
