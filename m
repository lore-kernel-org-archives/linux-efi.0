From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH v5 2/5] efi: Add embedded peripheral firmware support
Date: Sun, 13 May 2018 15:10:07 +0100
Message-ID: <b058045d-d100-3503-b3b8-2e21137aa35e@redhat.com>
References: <20180429093558.5411-1-hdegoede@redhat.com>
 <20180429093558.5411-3-hdegoede@redhat.com>
 <20180503232920.GF27853@wotan.suse.de>
 <CAKv+Gu94HNK3vDa2-ro+mb9L6XfWQQgR2qneEmtpA0WqS5SqGw@mail.gmail.com>
 <20180508171206.GF27853@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180508171206.GF27853@wotan.suse.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, David Howells <dhowells@redhat.com>, Andy Lutomirski <luto@kernel.org>, Martijn Coenen <maco@android.com>, Andy Gross <andy.gross@linaro.org>, David Brown <david.brown@linaro.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, Matt Fleming <matt@codeblueprint.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Jones <pjones@redhat.com>, Dave Olsthoorn <dave@bewaar.me>, Will Deacon <will.deacon@arm.com>, andresx7@gmail.com, Mimi Zohar <zohar@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Martin Fuzzey <mfuzzey@parkeon.com>, Kalle Valo <kvalo@codeaurora.org>, Arend Van Spriel <arend.vanspriel@broadcom.com>, Linus Torvalds <torvalds@linux-foundation.org>, Nicolas Broeking <nbroeking@me.com>, Torsten Duwe <duwe@suse.de>, Kees Cook <keescook@chromium.org>, the arch/x86 maintainers <x86@kernel.org>, linux-efi@vger.kernel.org, Linux
List-Id: linux-efi@vger.kernel.org

Hi,

On 05/08/2018 06:12 PM, Luis R. Rodriguez wrote:
> On Fri, May 04, 2018 at 07:54:28AM +0200, Ard Biesheuvel wrote:
>> On 4 May 2018 at 01:29, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
>>> On Sun, Apr 29, 2018 at 11:35:55AM +0200, Hans de Goede wrote:
>> [...]
>>>> diff --git a/Documentation/driver-api/firmware/request_firmware.rst b/Documentation/driver-api/firmware/request_firmware.rst
>>>> index c8bddbdcfd10..560dfed76e38 100644
>>>> --- a/Documentation/driver-api/firmware/request_firmware.rst
>>>> +++ b/Documentation/driver-api/firmware/request_firmware.rst
>>>> @@ -73,3 +73,69 @@ If something went wrong firmware_request() returns non-zero and fw_entry
>>>>   is set to NULL. Once your driver is done with processing the firmware it
>>>>   can call call firmware_release(fw_entry) to release the firmware image
>>>>   and any related resource.
>>>> +
>>>> +EFI embedded firmware support
>>>> +=============================
>>>
>>> This is a new fallback mechanism, please see:
>>>
>>> Documentation/driver-api/firmware/fallback-mechanisms.rst
>>>
>>> Refer to the section "Types of fallback mechanisms", augument the list there
>>> and then move the section "Firmware sysfs loading facility" to a new file, and
>>> then add a new file for your own.
>>>
>>>> +
>>>> +On some devices the system's EFI code / ROM may contain an embedded copy
>>>> +of firmware for some of the system's integrated peripheral devices and
>>>> +the peripheral's Linux device-driver needs to access this firmware.
>>>
>>> You in no way indicate this is a just an invented scheme, a custom solution and
>>> nothing standard.  I realize Ard criticized that the EFI Firmware Volume Protocol
>>> is not part of the UEFI spec -- however it is a bit more widely used right?
>>> Why can't Linux support it instead?
>>>
>>
>> Most implementations of UEFI are based on PI,
> 
> That seems to be the UEFI Platform Initialization specification:
> 
> http://www.uefi.org/sites/default/files/resources/PI_Spec_1_6.pdf
> 
>> and so it is likely that
>> the protocols are available. However, the PI spec does not cover
>> firmware blobs,
> 
> Indeed, I cannot find anything about it on the PI Spec, but I *can* easily
> find a few documents referring to the Firmware Volume Protocol:
> 
> http://wiki.phoenix.com/wiki/index.php/EFI_FIRMWARE_VOLUME_PROTOCOL
> 
> But this has no references at all...
> 
> I see stupid patents over some of this and authentication mechanisms for it:
> 
> https://patents.google.com/patent/US20170098084
> 
>> and so it is undefined whether such blobs are self
>> contained (i.e., in separate files in the firmware volume), statically
>> linked into the driver or maybe even encrypted or otherwise
>> encapsulated, and the actual loadable image only lives in memory.
> 
> Got it, thanks this helps! There are two things then:
> 
>   1) The "EFI Firmware Volume Protocol" ("FV" for short in your descriptions
>      below), and whether to support it or not in the future and recommend it
>      for future use cases.
> 
>   b) Han's EFI scraper to help support 2 drivers, and whether or not to
>      recommend it for future use cases.
> 
>> Hans's case is the second one, i.e., the firmware is at an arbitrary
>> offset in the driver image. Using the FV protocol in this case would
>> result in a mix of both approaches: look up the driver file by GUID
>> [which could change btw between different versions of the system
>> firmware, although this is unlikely] and then still use the prefix/crc
>> based approach to sift through the image itself.
> 
> Got it. And to be clear its a reversed engineered solution to what
> two vendors decided to do.
> 
>> But my main objection is simply that from the UEFI forum point of
>> view, there is a clear distinction between the OS visible interfaces
>> in the UEFI spec and the internal interfaces in the PI spec (which for
>> instance are not subject to the same rules when it comes to backward
>> compatibility), and so I think we should not depend on PI at all.
> 
> Ah I see.
> 
>> This
>> is all the more important considering that we are trying to encourage
>> the creation of other implementations of UEFI that are not based on PI
>> (e.g., uboot for arm64 implements the required UEFI interfaces for
>> booting the kernel via GRUB), and adding dependencies on PI protocols
>> makes that a moving target.
> 
> Got it!
> 
>> So in my view, we either take a ad-hoc approach which works for the
>> few platforms we expect to support, in which case Hans's approach is
>> sufficient,
> 
> Modulo it needs some work for ARM as it only works for x86 right now ;)
> 
>> or we architect it properly, in which case we shouldn't
>> depend on PI because it does not belong in a properly architected
>> OS<->firmware exchange.
> 
> OK, it sounds to me like we have room to then implement our own de-facto
> standard for letting vendors stuff firmware into EFI as we in the Linux
> community see fit.
> 
> We can start out by supporting existing drivers, but also consider customizing
> this in the future for our own needs, so long as we document it and set
> expectations well.
> 
> So we need to support what Hans is implementing for two reasons then:
> 
> a) The FV Protocol cannot be used to support the two drivers he's
>     trying to provide support for -- I believe Hans tried and it didn't work,
>     Hans, correct me if I'm wrong?
> 
> b) The FV Protocol relies on *internal* interfaces of PI spec, and since:
>      1) The PI spec does not define firmware at all
>      2) The internal interfaces of PI Spec does not guarantee any backward
>         compatibility
>     Any implementation details in FV may be subject to change, and may vary
>     system to system. Supporting the FV Protocol would be difficult as it
>     purposely ambiguous.
> 
> If accurate, Hans, can you capture this in your documentation somehow?

Yes I've added some extra doc to this extend for the next version of the
patchset.

Regards,

Hans
