From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 0/3] efi: MMC proxy support for the UEFI varstore
Date: Thu, 22 Sep 2016 14:37:00 +0100
Message-ID: <CAKv+Gu-H=JkXFSm2bO4tFcUEVPs2ueT3za2X+aUjrnGZZSdUvQ@mail.gmail.com>
References: <1474543806-19210-1-git-send-email-ard.biesheuvel@linaro.org> <20160922125854.GC26596@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160922125854.GC26596@leverpostej>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Charles Garcia-Tobin <Charles.Garcia-Tobin-5wv7dgnIgG8@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Grant Likely <glikely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>, Haojian Zhuang <haojian.zhuang-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, andrew-h+KGxgPPiopAfugRpC6u6w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

(adding Charles whom I failed to cc)

On 22 September 2016 at 13:58, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
> Hi Ard,
>
> On Thu, Sep 22, 2016 at 12:30:03PM +0100, Ard Biesheuvel wrote:
>> ================================================================================
>> NOTE: this is a work in progress, and not fully functional yet. In particular,
>> the actual MMC host protocol methods are stubbed out at the moment, and need to
>> be wired up to the Linux device drivers.
>> ================================================================================
>>
>> On mobile and embedded systems, there is usually only a single MMC device for
>> non-volatile storage, which sits behind a controller that is owned by the OS at
>> runtime. This makes it difficult to host the UEFI variable store on MMC as well,
>> since the UEFI runtime services routines expect ownership of the underlying
>> device as well.
>>
>> This series proposes an approach to work around this. It implements the UEFI
>> MMC host protocol in the kernel, in a way that makes it possible to expose it
>> to the firmware. At the same time, the firmware needs be set up for this, i.e.,
>> it needs to expose its MMC host protocol pointer via a UEFI configuration table,
>> so that the kernel can override it if it decides to expose this functionality
>> to the firmware.
>
> At a high level, and assuming a number of details from previous
> discussions, I think the general approach of having the kernel mediate
> access to the MMC makes sense.
>

OK.

> However, I don't think that this series has enough detail for critical
> review, even at the interface level. e.g. there is no mention of how
> this caters for replay attacks and so on (which the current spec
> sidesteps). I'm under the impression that there are mechanisms which
> have been discussed for this, and I hope this is simply an oversight.
>

This series does not take UEFI Secure Boot into account at all, and so
replay protection is not currently being addressed explicitly.
However, the reason for exposing an MMC host protocol rather than some
more abstract protocol (i.e., block I/O) is to allow firmware that
uses RPMB over MMC (e.g, with an authentication component residing in
the secure world) to reuse the same interface while maintaining the
same level of security it would have if it owned the MMC fully.

> I also think that this needs to go via the USWG (and to the UEFI spec),
> before we can consider using it. I say this because:
>
> * This is critical to correct operation of variable storage as required
>   for the standard boot flow. This is a major change to the way variable
>   storage works today, with a number of (security) implications.
>

The primary issue there is that the variable protocols are
architectural DXE protocols defined in the PI spec, not the UEFI spec
(and the MMC host protocol I am using here is not in any spec afaik),
and so implementing this in a UEFI compliant way is not currently
possible. Exposing a UEFI protocol like block I/O is not sufficient,
since the variable protocols are depended upon earlier in the boot
sequence (in UEFI implementations based on PI).

So yes, this needs to be discussed (and it will be, but not out in the
open, unfortunately.) However, it is unclear whether it is feasible to
address this at the UEFI level, or whether we will need to go beyond
and define something based on the PI spec directly. (/me looks at
Charles)

> * There are others in this space trying to use the same class of
>   hardware, e.g. FreeBSD. We don't want a Linux-specific interface, nor
>   do we want a proliferation of interfaces for this purpose.
>

No, we don't.

> I have a few other general concerns:
>
> * Identification of the relevant MMC device(s).
>
>   Patch 3 suggests a devicetree property. I don't think that the
>   'linux,' prefix makes sense, and it's not clear what we would do with
>   ACPI.
>
>   Does the MMC device not have some identifier we can query, so that we
>   can match this up without requiring additional info in ACPI/DT?
>

Good question. IIRC (but I'm a little rusty here), that is the case
for SD but not for MMC? (but it probably depends on the version) In
any case, there are other concerns here, regarding how the OS knows
which slice of the MMC is in use by the firmware. So the firmware
should expose sufficient information to the OS for it to figure out
which MMC volume it should expose to the firmware. UEFI generally uses
device paths for this, but I'm not sure if that is appropriate here.

> * Lifetime guarantees
>
>   When is it valid for EFI to call the MMC proxy? Can other services
>   (e.g. ACPI) call this?
>
>   How do we handle kexec/kdump? e.g. how do we teardown the interface
>   before branching to a new kernel, how do we safely tear down a crashed
>   kernel's interface, what can we call before doing so?
>
>   How do we handle suspend/resume? e.g. is it necessary to re-register
>   upon resume?
>

All good questions, and exactly the kind of feedback I am seeking.

Tearing down the interface could be as simple as clearing the pointer,
but some synchronization is probably in order to make sure that no
calls are in progress.

But to clarify the purpose of this series: are there any concerns
regarding exposing callbacks to the firmware in general, and for MMC
access in particular, from the Linux side? This code seems to work as
expected, but I may have missed something important (and I still need
help to actually wire it up to the MMC code)

-- 
Ard.
