From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v5 2/5] efi: Add embedded peripheral firmware support
Date: Fri, 4 May 2018 07:54:28 +0200
Message-ID: <CAKv+Gu94HNK3vDa2-ro+mb9L6XfWQQgR2qneEmtpA0WqS5SqGw@mail.gmail.com>
References: <20180429093558.5411-1-hdegoede@redhat.com> <20180429093558.5411-3-hdegoede@redhat.com>
 <20180503232920.GF27853@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180503232920.GF27853@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Jones <pjones@redhat.com>, Dave Olsthoorn <dave@bewaar.me>, Will Deacon <will.deacon@arm.com>, andresx7@gmail.com, Andy Lutomirski <luto@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Martin Fuzzey <mfuzzey@parkeon.com>, Kalle Valo <kvalo@codeaurora.org>, Arend Van Spriel <arend.vanspriel@broadcom.com>, Linus Torvalds <torvalds@linux-foundation.org>, Nicolas Broeking <nbroeking@me.com>
List-Id: linux-efi@vger.kernel.org

On 4 May 2018 at 01:29, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> On Sun, Apr 29, 2018 at 11:35:55AM +0200, Hans de Goede wrote:
[...]
>> diff --git a/Documentation/driver-api/firmware/request_firmware.rst b/Documentation/driver-api/firmware/request_firmware.rst
>> index c8bddbdcfd10..560dfed76e38 100644
>> --- a/Documentation/driver-api/firmware/request_firmware.rst
>> +++ b/Documentation/driver-api/firmware/request_firmware.rst
>> @@ -73,3 +73,69 @@ If something went wrong firmware_request() returns non-zero and fw_entry
>>  is set to NULL. Once your driver is done with processing the firmware it
>>  can call call firmware_release(fw_entry) to release the firmware image
>>  and any related resource.
>> +
>> +EFI embedded firmware support
>> +=============================
>
> This is a new fallback mechanism, please see:
>
> Documentation/driver-api/firmware/fallback-mechanisms.rst
>
> Refer to the section "Types of fallback mechanisms", augument the list there
> and then move the section "Firmware sysfs loading facility" to a new file, and
> then add a new file for your own.
>
>> +
>> +On some devices the system's EFI code / ROM may contain an embedded copy
>> +of firmware for some of the system's integrated peripheral devices and
>> +the peripheral's Linux device-driver needs to access this firmware.
>
> You in no way indicate this is a just an invented scheme, a custom solution and
> nothing standard.  I realize Ard criticized that the EFI Firmware Volume Protocol
> is not part of the UEFI spec -- however it is a bit more widely used right?
> Why can't Linux support it instead?
>

Most implementations of UEFI are based on PI, and so it is likely that
the protocols are available. However, the PI spec does not cover
firmware blobs, and so it is undefined whether such blobs are self
contained (i.e., in separate files in the firmware volume), statically
linked into the driver or maybe even encrypted or otherwise
encapsulated, and the actual loadable image only lives in memory.

Hans's case is the second one, i.e., the firmware is at an arbitrary
offset in the driver image. Using the FV protocol in this case would
result in a mix of both approaches: look up the driver file by GUID
[which could change btw between different versions of the system
firmware, although this is unlikely] and then still use the prefix/crc
based approach to sift through the image itself.

But my main objection is simply that from the UEFI forum point of
view, there is a clear distinction between the OS visible interfaces
in the UEFI spec and the internal interfaces in the PI spec (which for
instance are not subject to the same rules when it comes to backward
compatibility), and so I think we should not depend on PI at all. This
is all the more important considering that we are trying to encourage
the creation of other implementations of UEFI that are not based on PI
(e.g., uboot for arm64 implements the required UEFI interfaces for
booting the kernel via GRUB), and adding dependencies on PI protocols
makes that a moving target.

So in my view, we either take a ad-hoc approach which works for the
few platforms we expect to support, in which case Hans's approach is
sufficient, or we architect it properly, in which case we shouldn't
depend on PI because it does not belong in a properly architected
OS<->firmware exchange.

-- 
Ard.
