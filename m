From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH v3 2/5] efi: Add embedded peripheral firmware support
Date: Tue, 17 Apr 2018 10:58:40 +0200
Message-ID: <aff2d267-e06d-f422-5623-6f6cc25af155@redhat.com>
References: <20180408174014.21908-1-hdegoede@redhat.com>
 <20180408174014.21908-3-hdegoede@redhat.com>
 <20180417001738.GN30543@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180417001738.GN30543@wotan.suse.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@kernel.org>, Andres Rodriguez <andresx7@gmail.com>
Cc: Darren Hart <dvhart@infradead.org>, Andy Shevchenko <andy@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Jones <pjones@redhat.com>, Dave Olsthoorn <dave@bewaar.me>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, dmitry.torokhov@gmail.com, mfuzzey@parkeon.com, keescook@chromium.org, Kalle Valo <kvalo@codeaurora.org>, Arend
List-Id: linux-efi@vger.kernel.org

Hi,

On 17-04-18 02:17, Luis R. Rodriguez wrote:
> On Sun, Apr 08, 2018 at 07:40:11PM +0200, Hans de Goede wrote:
>>   static void firmware_free_data(const struct firmware *fw)
>>   {
>> @@ -576,6 +600,15 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
>>   		goto out;
>>   
>>   	ret = fw_get_filesystem_firmware(device, fw->priv);
>> +#ifdef CONFIG_EFI_EMBEDDED_FIRMWARE
>> +	if (ret && device &&
>> +	    device_property_read_bool(device, "efi-embedded-firmware")) {
>> +		ret = fw_get_efi_embedded_fw(device, fw->priv, ret);
>> +		if (ret == 0)
>> +			ret = assign_fw(fw, device, opt_flags | FW_OPT_NOCACHE);
>> +		goto out;
>> +	}
>> +#endif
> 
> You mussed what I asked for in terms of adding a new flag, (please work on top
> of Andre's patches as those likely will be merged first, and also have kdocs
> for the flags)

Ok I will base my next version on top of Andres' series.

> and then a new firmware API to wrap the above into a function
> which would only do something if the driver *asked* for it on their firmware
> API call.
> Ie, please add a new firmware_request_efi_fw().

As I tried to explain in the changelog the problem with doing this, is that
this makes it a driver decision, where it really needs to be platform-code driven,
not driver driven.

Take for example the drivers/input/touchscreen/silead.c code that is used on
a lot of 32 bit ARM platforms too, which don't have EFI at all, so if that
needs to call request_firmware_efi() then should I add:

#ifdef CONFIG_X86
	fw = request_firmware_efi(...);
#else
	fw = request_firmware(...);
#endif

? But even on x86 only some devices with a silead touchscreen have EFI
embedded firmware, so then I would need something like:

#ifdef CONFIG_X86
	if (device_property_get_bool(dev, "some-prop-name"))
		fw = request_firmware_efi(...);
	else
#else
		fw = request_firmware(...);
#endif

That is assuming I still want the normal fallback path in the
case no EFI firmware is available, which I do because then
something like packagekit may see if the firmware is packaged
in one of the configured distro repositories.

We already have (x86) platform code in place to attach
properties (like a board specific firmware filename) to the
device using device-properties so that drivers like silead.c
don't get filled / polluted with board/platform specific knowledge,
which IMHO is the place where the knowledge fallback to
an EFI embedded firmware copy belongs.

As the further patches in v3 of this series shows, this actually
works quite nicely, because this also allows bundling the
EFI-embedded firmware info (prefix, length, crc, name) together
with the other board specific properties.

TL;DR: using request_firmware_efi() vs request_firmware() is
a driver decision, but whether EFI firmware fallback should be
is board/platform specific not driver specific, therefor I
believe that using a device-property to signal this is better.


If you insist on me adding a request_firmware_efi() I can give
this a shot, but I know that Dmitry (the input maintainer) will
very much dislike the silead.c changes that implies...

Still a question for lets sat we go that route, what do we
then do with request_firmware_efi() when CONFIG_EFI is not set ?
Should it be defined then or not, and if it should be defined
when CONFIG_EFI is not set what should it do then?

> Also if you see the
> work I've done to remove the ifdefs over fallback mechanism you'll see it helps
> split code and make it easier to read. We should strive to not add any more
> ifdefery and instead make tehis code read easily.

So looking at how the CONFIG_FW_LOADER_USER_HELPER stuff deals
with this, I should:

1) Move the definition of fw_get_efi_embedded_fw() to a new
drivers/base/firmware_loader/fallback_efi.c,
which only gets build if CONFIG_EFI_EMBEDDED_FIRMWARE is set

2) Put the following in fallback.h:

#ifdef CONFIG_EFI_EMBEDDED_FIRMWARE
int fw_get_efi_embedded_fw(struct device *dev, struct fw_priv *fw_priv, int ret);
#else
static inline int
fw_get_efi_embedded_fw(struct device *dev, struct fw_priv *fw_priv, int ret)
{
	return ret;
}
#endif

have I got that right?

Regards,

Hans
