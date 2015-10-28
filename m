From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Subject: RE: [PATCH v8 2/2] efi: a misc char interface for user to update
 efi firmware
Date: Wed, 28 Oct 2015 09:11:57 +0000
Message-ID: <F54AEECA5E2B9541821D670476DAE19C4A878F01@PGSMSX102.gar.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: 'Matt Fleming' <matt@console-pimps.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Ong, Boon Leong" <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Sam Protsenko <semen.protsenko@linaro.org>, Peter Jones <pjones@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Roy Franz <roy.franz@linaro.org>, Borislav Petkov <bp@alien8.de>, James Bottomley <James.Bottomley@hansenpartnership.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "Fleming, Matt" <matt.fleming@intel.com>, "Anvin, H Peter" <h.peter.anvin@intel.com>
List-Id: linux-efi@vger.kernel.org

> -----Original Message-----
> From: Matt Fleming [mailto:matt@console-pimps.org]
> Sent: Monday, October 12, 2015 8:11 PM
> 
> > +};
> > +
> > +static DEFINE_MUTEX(capsule_loader_lock);
> 
> What does this lock protect?

This lock is to protect when one of the instance calling efi_capsule_update()
API and the other instance calling efi_capsule_supported() API.
