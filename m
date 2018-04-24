From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH v3 2/5] efi: Add embedded peripheral firmware support
Date: Tue, 24 Apr 2018 20:33:54 +0200
Message-ID: <f410a445-d02b-44d4-6e82-f94724e0031d@redhat.com>
References: <20180408174014.21908-1-hdegoede@redhat.com>
 <20180408174014.21908-3-hdegoede@redhat.com>
 <20180423211143.GZ14440@wotan.suse.de>
 <71e6a45a-398d-b7a4-dab0-8b9936683226@redhat.com>
 <1524586021.3364.20.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1524586021.3364.20.camel@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mimi Zohar <zohar@linux.vnet.ibm.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>
Cc: Darren Hart <dvhart@infradead.org>, Andy Shevchenko <andy@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Jones <pjones@redhat.com>, Dave Olsthoorn <dave@bewaar.me>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, David Howells <dhowells@redhat.com>, Josh Triplett <josh@joshtriplett.org>, dmitry.torokhov@gmail.com, mfuzzey@parkeon.com, Kalle Valo <kvalo@codeaurora.org>, Arend Van Spriel <arend.vanspriel@broadcom.com>, Linus Torvalds <torvalds@lin>
List-Id: linux-efi@vger.kernel.org

Hi,

On 24-04-18 18:07, Mimi Zohar wrote:
> On Tue, 2018-04-24 at 17:09 +0200, Hans de Goede wrote:
>> Hi,
>>
>> On 23-04-18 23:11, Luis R. Rodriguez wrote:
>>> Hans, please see use of READING_FIRMWARE_PREALLOC_BUFFER, we'll need a new ID
>>> and security for this type of request so IMA can reject it if the policy is
>>> configured for it.
>>
>> Hmm, interesting, actually it seems like the whole existence
>> of READING_FIRMWARE_PREALLOC_BUFFER is a mistake, the IMA
>> framework really does not care if we are loading the firmware
>> into memory allocated by the firmware-loader code, or into
>> memory allocated by the device-driver requesting the firmware.
>>
>> As such the current IMA code (from v4.17-rc2) actually does
>> not handle READING_FIRMWARE_PREALLOC_BUFFER at all,
> 
> Right, it doesn't yet address READING_FIRMWARE_PREALLOC_BUFFER, but
> should.
> 
> Depending on whether the device requesting the firmware has access to
> the DMA memory, before the signature verification, will determine how
> IMA-appraisal addresses READING_FIRMWARE_PREALLOC_BUFFER.

Ah I see. So this probably means that the IMA integration for
my EFI embedded firmware code should also pass READING_FIRMWARE or
READING_FIRMWARE_PREALLOC_BUFFER depending on if a pre-allocated
buffer is used.

Hmm, the security_kernel_post_read_file() call in
drivers/base/firmware_loader/fallback.c

Unconditionally passes READING_FIRMWARE, it should probably check
fw_priv->is_paged_buf and base the id to pass on that.

And yes it is possible AFAICT for the firmware_request_into_buf()
method to fallback to the userspace helper, this can happen if the
fw_fallback_config.force_sysfs_fallback flag is set.

Regards,

Hans
