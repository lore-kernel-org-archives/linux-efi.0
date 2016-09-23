From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [RFC PATCH 0/3] efi: MMC proxy support for the UEFI varstore
Date: Fri, 23 Sep 2016 10:19:08 +0100
Message-ID: <20160923091907.GA10042@leverpostej>
References: <1474543806-19210-1-git-send-email-ard.biesheuvel@linaro.org>
 <20160922125854.GC26596@leverpostej>
 <CAKv+Gu-H=JkXFSm2bO4tFcUEVPs2ueT3za2X+aUjrnGZZSdUvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-H=JkXFSm2bO4tFcUEVPs2ueT3za2X+aUjrnGZZSdUvQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Charles Garcia-Tobin <Charles.Garcia-Tobin-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Grant Likely <glikely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>, Haojian Zhuang <haojian.zhuang-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, andrew-h+KGxgPPiopAfugRpC6u6w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Sep 22, 2016 at 02:37:00PM +0100, Ard Biesheuvel wrote:
> On 22 September 2016 at 13:58, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
> > On Thu, Sep 22, 2016 at 12:30:03PM +0100, Ard Biesheuvel wrote:

> > I also think that this needs to go via the USWG (and to the UEFI spec),
> > before we can consider using it.

> The primary issue there is that the variable protocols are
> architectural DXE protocols defined in the PI spec, not the UEFI spec
> (and the MMC host protocol I am using here is not in any spec afaik),
> and so implementing this in a UEFI compliant way is not currently
> possible. Exposing a UEFI protocol like block I/O is not sufficient,
> since the variable protocols are depended upon earlier in the boot
> sequence (in UEFI implementations based on PI).
> 
> So yes, this needs to be discussed (and it will be, but not out in the
> open, unfortunately.) However, it is unclear whether it is feasible to
> address this at the UEFI level, or whether we will need to go beyond
> and define something based on the PI spec directly. (/me looks at
> Charles)

That is... less than optimal. :(

> > I have a few other general concerns:

> > * Lifetime guarantees
> >
> >   When is it valid for EFI to call the MMC proxy? Can other services
> >   (e.g. ACPI) call this?
> >
> >   How do we handle kexec/kdump? e.g. how do we teardown the interface
> >   before branching to a new kernel, how do we safely tear down a crashed
> >   kernel's interface, what can we call before doing so?
> >
> >   How do we handle suspend/resume? e.g. is it necessary to re-register
> >   upon resume?
> 
> All good questions, and exactly the kind of feedback I am seeking.
> 
> Tearing down the interface could be as simple as clearing the pointer,
> but some synchronization is probably in order to make sure that no
> calls are in progress.
> 
> But to clarify the purpose of this series: are there any concerns
> regarding exposing callbacks to the firmware in general, and for MMC
> access in particular, from the Linux side?

I have a general uneasiness about having UEFI call kernel function
pointers, inverting the usual relationship, but I'll need to think about
that a little further -- the lifetime stuff was the most obvious problem
in that area, but I'm sure there are more. ;)

It would really help to know *when* UEFI is expected/allowed to call
this. For synchronous calls, the FW could return a new
requires-os-support error code, and the OS could then call some API,
figure out what to do, and later send any acknowledgement required back
to UEFI. That might not cover all cases, though.

Thanks,
Mark.
