From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH v11 1/1] efi: a misc char interface for user to update
 efi firmware
Date: Mon, 8 Feb 2016 09:50:03 +0000
Message-ID: <20160208095003.GA2413@codeblueprint.co.uk>
References: <1454042394-21507-1-git-send-email-hock.leong.kweh@intel.com>
 <1454042394-21507-2-git-send-email-hock.leong.kweh@intel.com>
 <20160208054331.GA16756@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160208054331.GA16756@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>, Ong Boon Leong <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org, Sam Protsenko <semen.protsenko@linaro.org>, Peter Jones <pjones@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Roy Franz <roy.franz@linaro.org>, Borislav Petkov <bp@alien8.de>, James Bottomley <James.Bottomley@hansenpartnership.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Anvin H Peter <h.peter.anvin@intel.com>
List-Id: linux-efi@vger.kernel.org

On Sun, 07 Feb, at 09:43:31PM, Greg KH wrote:
> On Fri, Jan 29, 2016 at 12:39:54PM +0800, Kweh, Hock Leong wrote:
> > From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
> > 
> > Introducing a kernel module to expose capsule loader interface
> > (misc char device file note) for users to upload capsule binaries.
> > 
> > Example:
> > cat firmware.bin > /dev/efi_capsule_loader
> > 
> > This patch also export efi_capsule_supported() function symbol for
> > verifying the submitted capsule header in this kernel module.
> > 
> > Cc: Matt Fleming <matt@codeblueprint.co.uk>
> > Signed-off-by: Kweh, Hock Leong <hock.leong.kweh@intel.com>
> > ---
> >  drivers/firmware/efi/Kconfig          |    9 +
> >  drivers/firmware/efi/Makefile         |    1 +
> >  drivers/firmware/efi/capsule-loader.c |  334 +++++++++++++++++++++++++++++++++
> >  drivers/firmware/efi/capsule.c        |    1 +
> >  4 files changed, 345 insertions(+)
> >  create mode 100644 drivers/firmware/efi/capsule-loader.c
> 
> I need an ack from the efi maintainer, or at least someone else
> reviewing / testing this, before I can accept it.

Thanks Greg, but this should probably go through the EFI tree since
there are prerequisite core EFI capsule patches for this driver.

If you're happy with the code though, an ACK would be much
appreciated.
