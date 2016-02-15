From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v11 1/1] efi: a misc char interface for user to update
 efi firmware
Date: Mon, 15 Feb 2016 08:41:06 -0800
Message-ID: <20160215164106.GB24956@kroah.com>
References: <1454042394-21507-1-git-send-email-hock.leong.kweh@intel.com>
 <1454042394-21507-2-git-send-email-hock.leong.kweh@intel.com>
 <20160208054331.GA16756@kroah.com>
 <20160208095003.GA2413@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160208095003.GA2413-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ong Boon Leong <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Anvin H Peter <h.peter.anvin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Feb 08, 2016 at 09:50:03AM +0000, Matt Fleming wrote:
> On Sun, 07 Feb, at 09:43:31PM, Greg KH wrote:
> > On Fri, Jan 29, 2016 at 12:39:54PM +0800, Kweh, Hock Leong wrote:
> > > From: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > 
> > > Introducing a kernel module to expose capsule loader interface
> > > (misc char device file note) for users to upload capsule binaries.
> > > 
> > > Example:
> > > cat firmware.bin > /dev/efi_capsule_loader
> > > 
> > > This patch also export efi_capsule_supported() function symbol for
> > > verifying the submitted capsule header in this kernel module.
> > > 
> > > Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> > > Signed-off-by: Kweh, Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > ---
> > >  drivers/firmware/efi/Kconfig          |    9 +
> > >  drivers/firmware/efi/Makefile         |    1 +
> > >  drivers/firmware/efi/capsule-loader.c |  334 +++++++++++++++++++++++++++++++++
> > >  drivers/firmware/efi/capsule.c        |    1 +
> > >  4 files changed, 345 insertions(+)
> > >  create mode 100644 drivers/firmware/efi/capsule-loader.c
> > 
> > I need an ack from the efi maintainer, or at least someone else
> > reviewing / testing this, before I can accept it.
> 
> Thanks Greg, but this should probably go through the EFI tree since
> there are prerequisite core EFI capsule patches for this driver.
> 
> If you're happy with the code though, an ACK would be much
> appreciated.

Acked-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
