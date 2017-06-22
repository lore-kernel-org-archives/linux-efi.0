From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: efi/reboot: Fall back to original power-off method if
 EFI_RESET_SHUTDOWN returns
Date: Thu, 22 Jun 2017 12:04:30 +0200
Message-ID: <099b3f68-46b1-201c-065f-cf5c4bdcc528@redhat.com>
References: <20170423123655.13015-1-hdegoede@redhat.com>
 <430d6ff2-264a-80f8-24e0-0d9af4377844@redhat.com>
 <20170622095517.GA3238@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20170622095517.GA3238@codeblueprint.co.uk>
Content-Language: en-US
Sender: linux-acpi-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Len Brown <lenb@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, linux-acpi@vger.kernel.org, Peter Jones <pjones@redhat.com>, linux-efi@vger.kernel.org, Mark Salter <msalter@redhat.com>
List-Id: linux-efi@vger.kernel.org

Hi,

On 22-06-17 11:55, Matt Fleming wrote:
> On Wed, 21 Jun, at 03:15:09PM, Hans de Goede wrote:
>> HI,
>>
>> On 23-04-17 14:36, Hans de Goede wrote:
>>> Commit 44be28e9dd98 ("x86/reboot: Add EFI reboot quirk for ACPI Hardware
>>> Reduced flag") sets pm_power_off to efi_power_off() when the
>>> acpi_gbl_reduced_hardware flag is set.
>>>
>>> According to its commit message this is necessary because: "BayTrail-T
>>> class of hardware requires EFI in order to powerdown and reboot and no
>>> other reliable method exists"
>>>
>>> But I have a Bay Trail CR tablet where the EFI_RESET_SHUTDOWN call does
>>> not work, it simply returns without doing anything (AFAICT).
>>>
>>> So it seems that some Bay Trail devices must use EFI for power-off, while
>>> for others only ACPI works.
>>>
>>> Note that efi_power_off() only gets used if the platform code defines
>>> efi_poweroff_required() and that returns true, this currently only ever
>>> happens on x86.
>>>
>>> Since on the devices which need ACPI for power-off the EFI_RESET_SHUTDOWN
>>> call simply returns, this patch makes the efi-reboot code remember the
>>> old pm_power_off handler and if EFI_RESET_SHUTDOWN returns it falls back
>>> to calling that.
>>>
>>> This seems preferable to dmi-quirking our way out of this, since there
>>> are likely quite a few devices suffering from this.
>>>
>>> Cc: Mark Salter <msalter@redhat.com>
>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>
>> What is the status of this patch ? It has had 2 somewhat favorable
>> reviews and then things went silent ?
> 
> Sorry about the delay. I've picked this up for the efi-next branch
> since we're at -rc6 and it doesn't look like an -rc6-urgent bug.

Ack, putting this in -next is the right thing to do, you never know
what weird firmware quirks this patch may trigger. E.g. EFI_RESET_SHUTDOWN
could return on some models with the PMIC turned off leaving the device
running for XX ms on its power-supply capacitors, and then calling into
the ACPI method may cause weirdness.

Regards,

Hans
