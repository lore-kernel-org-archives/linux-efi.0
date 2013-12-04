From: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 1/3] Documentation: arm: add UEFI support
 documentation
Date: Wed, 04 Dec 2013 17:31:23 -0500
Message-ID: <1386196283.1861.115.camel@deneb.redhat.com>
References: <1385656883-4420-1-git-send-email-leif.lindholm@linaro.org>
	 <1385656883-4420-2-git-send-email-leif.lindholm@linaro.org>
	 <CAHCPf3t5dEzVWbYZ6DWcFCENNO2dbrx-YeZvKRk0MkEsJMTE3A@mail.gmail.com>
	 <20131202210719.GQ24997@rocoto.smurfnet.nu>
	 <CAHCPf3tsWdV+dJGm6mX6N4Ou5EQoGukdLyRvsRX6VQFjtKgxtg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHCPf3tsWdV+dJGm6mX6N4Ou5EQoGukdLyRvsRX6VQFjtKgxtg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Sealey <neko-HhXTZounMxbZATc7fWT8Dg@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Patch Tracking <patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linaro-uefi-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Rob Landley <rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 2013-12-04 at 15:06 -0600, Matt Sealey wrote:
> On Mon, Dec 2, 2013 at 3:07 PM, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> > On Mon, Dec 02, 2013 at 01:51:22PM -0600, Matt Sealey wrote:
> >> Here's where I think this whole thing falls down as being the weirdest
> >> possible implementation of this. It defies logic to put this
> >> information in the device tree /chosen node while also attempting to
> >> boot the kernel using an EFI stub; the stub is going to have this
> >> information because it is going to have the pointer to the system
> >> System Table (since it was called by StartImage()). Why not stash the
> >> System Table pointer somewhere safe in the stub?
> >
> > We do. In the DT.
> 
> Hang on... see way below about "reinventing the wheel"
> 
> >> The information in the device tree is all accessible from Boot
> >> Services and as long as the System Table isn't being thrown away (my
> >> suggestion would be.. stuff it in r2, and set r1 = "EFI\0" then work
> >> with arch/arm/kernel/head{-common,}.S code to do the right thing)
> >
> > You left out the bit of redefining the kernel boot protocol to permit
> > calling it with caches, MMU and interrupts enabled - also known as
> > before ExitBootServices().
> 
> And that's a horrible idea because of what?

Talk about reinventing the wheel.

I look at it like this. UEFI applications have a specific boot protocol.
The kernel has a different boot protocol. The purpose of the stub is to
go from the UEFI protocol to the kernel protocol. The kernel protocol
doesn't currently include an explicit way to pass UEFI info (system table
and memory map). It does have a way to pass a DT. Much like x86 and ia64
pass the UEFI info in an already existing boot_params block, arm and arm64
pass that info in the device tree. Not changing the kernel boot protocol
seems like the simplest and best way to get the job done. Maybe x86 and
now arm are going about the wrong way and should be doing it differently,
but so far, I'm not convinced that is the case.

--Mark
