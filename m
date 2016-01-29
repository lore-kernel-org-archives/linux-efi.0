From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Subject: RE: [PATCH v10 1/1] efi: a misc char interface for user to update
 efi firmware
Date: Fri, 29 Jan 2016 01:22:30 +0000
Message-ID: <F54AEECA5E2B9541821D670476DAE19C4A8AC8E1@PGSMSX102.gar.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Ong, Boon Leong" <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Sam Protsenko <semen.protsenko@linaro.org>, Peter Jones <pjones@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Roy Franz <roy.franz@linaro.org>, Borislav Petkov <bp@alien8.de>, James Bottomley <James.Bottomley@hansenpartnership.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "Anvin, H Peter" <h.peter.anvin@intel.com>
List-Id: linux-efi@vger.kernel.org

> -----Original Message-----
> From: Matt Fleming [mailto:matt@codeblueprint.co.uk]
> Sent: Thursday, January 28, 2016 8:16 PM
> 
> On Tue, 26 Jan, at 03:10:03AM, Kweh Hock Leong wrote:
> > >
> > > This mutex is not needed. It doesn't protect anything in your code.
> >
> > This is to synchronize/serializes one of the instant is calling
> efi_capsule_supported()
> > and the other one is calling efi_capsule_update() which they are exported
> symbol
> > from capsule.c.
> 
> You don't need to synchronise them.
> 
> Looking at my original capsule patches I can see why you might be
> doing this locking, but it's unnecessary. You don't need to serialise
> access to efi_capsule_supported() and efi_capsule_update().
> 
> Internally to the core EFI capsule code we need to ensure that we
> don't allow capsules with conflicting reset types to be sent to the
> firmware (how would we know the type of reset to perform?), but that
> should be entirely transparent to your driver.
> 
> I'm planning on re-sending my capsule patches, so all this should
> become clearer.
> 

Ok. Noted. Will remove it and submit for v11.

> > > This function would be much more simple if you handled the above
> > > condition differently.
> > >
> > > Instead of having code in efi_capsule_setup_info() to allocate the
> > > initial ->pages memory, why not just allocate it in efi_capsule_open()
> > > at the same time as you allocate the private_data? You can then
> > > free it in efi_capsule_release() (you're leaking it at the moment).
> > >
> > > You are always going to need at least one element in ->pages for
> > > successful operation, so you might as well allocate it up front.
> >
> > Just want to double check I understand you correctly. Do you mean
> > I should free ->pages during close(2) but not free the ->pages[X] if
> > there is any successfully submitted?
> 
> Yes, that's correct.

Ok. Noted.

Thanks & Regards,
Wilson
