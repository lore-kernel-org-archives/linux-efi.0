From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH 2/2] efi: Add embedded peripheral firmware support
Date: Thu, 5 Apr 2018 15:54:50 +0200
Message-ID: <018c86d5-3bce-4352-34a7-7d4c63707644@redhat.com>
References: <20180331121944.8618-1-hdegoede@redhat.com>
 <20180331121944.8618-2-hdegoede@redhat.com>
 <20180402232333.GU30543@wotan.suse.de>
 <17fb3c28-78ff-2e1f-2ada-d33320567761@redhat.com>
 <20180403184732.GC30543@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180403184732.GC30543@wotan.suse.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@kernel.org>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org, Peter Jones <pjones@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Dave Olsthoorn <dave@bewaar.me>, x86@kernel.org, linux-efi@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, dmitry.torokhov@gmail.com, mfuzzey@parkeon.com, keescook@chromium.org, Kalle Valo <kvalo@codeaurora.org>, Arend Van Spriel <arend.vanspriel@broadcom.com>, nbroeking@me.com, bjorn.andersson@linaro.org, Torsten Duwe <duwe@suse.de>
List-Id: linux-efi@vger.kernel.org

Hi,

On 03-04-18 20:47, Luis R. Rodriguez wrote:
> In your next patches please Cc the folks I added for future review as well.
> We don't have a mailing list for the firmware API so I just tend to Cc
> who I think should help review when needed.

Hmm, quite a long Cc list, but ok.

> On Tue, Apr 03, 2018 at 10:33:25AM +0200, Hans de Goede wrote:

<snip>

>> This is not part of the standard. There has been a long(ish) standing issue
>> with us not being able to get re-distribute permission for the firmware for
>> some touchscreen controllers found on cheap x86 devices. Which means that
>> we cannot put it in Linux firmware.
> 
> BTW do these cheap x86 devices have hw signing support?

Not sure what you mean with hw signing support here, they support UEFI
secure-boot and have a fTPM.

> Just curious thinking
> long term here. Because of it is not-standard then perhaps wen can partner
> later up with a vendor to this properly and actually support hw firmware
> singing.
> 
>> Dave Olsthoorn (in the Cc) noticed that the touchscreen did work in the
>> refind bootload UI, so the EFI code must have a copy of the firmware.
> 
> :)
> 
>> I asked Peter Jones for suggestions how to extract this during boot and
>> he suggested seeing if there was a copy of the firmware in the
>> EFI_BOOT_SERVICES_CODE memory segment, which it turns out there is.
> 
> Sneaky Pete, nice. So essentially we're reverse engineering support for this.

Yes.

> Anyway please mention that this is not part of standard in the documentation,
> and we've just found out in practice some vendors are doing this. That would
> avoid having people ask later.

Ok, I will add some docs for v2 of the patch.

>> My patch to add support for this contains a table of device-model (dmi
>> strings), firmware header (first 64 bits), length and crc32 and then if
>> we boot on a device-model which is in the table the code scans the
>> EFI_BOOT_SERVICES_CODE for the prefix, if found checks the crc and
>> caches the firmware for later use by request-firmware.
> 
> Neat, best to add proper docs for this.

Ok.

>> So I just do a brute-force search for the firmware, this really is hack,
>> nothing standard about it I'm afraid. But it works on 4 different x86
>> tablets I have and makes the touchscreen work OOTB on them, so I believe
>> it is a worthwhile hack to have.
> 
> Absolutely, just not to shove an entire fallback firmware path to all users.

Ok.

<snip>

>>> What mechanism would have in place to ensure that a driver which expects
>>> firmware to be on EFI data to be already available prior to its driver's
>>> call to initialize?
>>
>> See above, this still runs before start_kernel() calls rest_init() which is
>> where any normal init calls (and driver probing) happens so still early
>> enough for any users I can think of.
> 
> The firmware API is even used to load microcode, but that relies on built-in
> firmware support. That code needs to be refactored to be a proper citizen of the
> firmware API, right now its just a hack. Reason for asking all these details
> was to ensure we document the restrictions correctly so that expecations are
> set correctly for callers prior to rest_init(). Please be sure to document the
> limitations.

Ok.

<snip>

>>>> This means we rely on the EFI_BOOT_SERVICES_CODE not being free-ed until
>>>> efi_free_boot_services() is called, which means that this will only work
>>>> on x86, if we ever want this on ARM we should make ARM delay the freeing
>>>> of the EFI_BOOT_SERVICES_* memory-segments too.
>>>
>>> Why not do that as well with your patch?
>>
>> That requires making significant changes to the early bringup code on
>> ARM, x86 keeps EFI_BOOT_SERVICES_* memory-segments around until near
>> the end of start_kernel() because freeing them earlier triggers bugs
>> in some x86 EFI implementations, ARM EFI implementations do not have
>> these bugs, so they free them almost directly at boot.
>>
>> Changing this really falls outside the scope of this patch.
> 
> Sure but did you poke ARM folks about it? Maybe they can do it?
> And if this becomes a common practice, perhaps they can do it with
> actual firmware signing instead of a CRC.
> 
> Not sure how hard it is to exploit EFI_BOOT_SERVICES_CODE... but it
> may help UEFI folks with a nice warm fuzzy to start doing this right
> later instead of propagating what seems to be a cheap hack.

If things are compromised before the kernel boots no amount of
checks are going to help us, an attacker can then just boot an entirely
different kernel, rather then attacking the system through a backdoored
firmware, so a CRC should be fine. Either way I'm happy to switch to a
crypto hash, but the crypto subsystem is not initialized yet at this
point AFAICT, so using a CRC is easier.

>>>> Note this commit also modifies efi_mem_desc_lookup() to not skip
>>>> EFI_BOOT_SERVICES_CODE memory-segments, so that efi_mem_reserve() works
>>>> on such segments.
>>>>
>>>> Reported-by: Dave Olsthoorn <dave@bewaar.me>
>>>> Suggested-by: Peter Jones <pjones@redhat.com>
>>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>>> ---
>>>>    drivers/base/firmware_class.c            |  29 +++
>>>>    drivers/firmware/efi/Makefile            |   1 +
>>>>    drivers/firmware/efi/efi.c               |   1 +
>>>>    drivers/firmware/efi/embedded-firmware.c | 232 +++++++++++++++++++++++
>>>>    include/linux/efi.h                      |   2 +
>>>>    init/main.c                              |   1 +
>>>>    6 files changed, 266 insertions(+)
>>>>    create mode 100644 drivers/firmware/efi/embedded-firmware.c
>>>>
>>>> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
>>>> index 7dd36ace6152..b1e7b3de1975 100644

<snip>

>>>> @@ -1296,6 +1323,8 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
>>>>    		goto out;
>>>>    	ret = fw_get_filesystem_firmware(device, fw->priv);
>>>> +	if (ret)
>>>> +		ret = fw_get_efi_embedded_fw(device, fw->priv, ret);
>>>
>>> This EFI firmware lookup is being used as a fallback mechanism, for *all*
>>> requests. That's pretty aggressive and I'd like a bit more justification
>>> for that approach.
>>
>> The fw_get_efi_embedded_fw() call is not that expensive, it walks the
>> list of found firmwares, does a strcmp on the name and that is all it does,
>> so I did not really see this as a problem, but if you want me to change this
>> that is certainly possible.
> 
> The fallback mechanism / code has been a maintainer irritation for a long time now,
> to verify its functionality, document it, and ensure folks understand how things
> work. Best to be clear and simple about this functionality, adding more extensions
> without any need just makes things more complex.
> 
> Another big reason is the amount of code implicated to support this which brings
> me to the next request: please use a new kconfig to wrap this code into its own
> kconfig entry.

Ok.

> The fallback mechanism code with CONFIG_FW_LOADER_USER_HELPER eats up
> 13436 bytes for instance and Josh has told me that even if Android
> does enable it, there are still embedded devices out there that do not
> want it and do want to reduce the size of their kernels by these
> 13436 bytes when possible.
> 
> How much code does enabling your code have to the kernel? Please add
> that to the kconfig entry.
> 
> Oping in for a new mechanism via a kconfig is clearer to understand and
> maintain, less code for folks, and specially since only a coupe of drivers
> would be using this, its otherwise insane to enable by default.

Right, I agree that using a new Kconfig entry for this is a good idea,
thinking more about that we can even make it a hidden option and
have the drivers which need this do a "select EFI_EMBEDDED_FIRMWARE",
if we're going to require a special flag during loading of the firmware,
then I think having the drivers also control the Kconfig option make
sense.

> In fact I'm now thinking this new fallback mechanism may be an
> alternative to CONFIG_FW_LOADER_USER_HELPER but it very likely
> can only work well for small firmware. How big are the currently
> known firmwares BTW?

They are all around 40k, so quite small.

> [0] https://lkml.kernel.org/r/20180301021956.GA12202@localhost
> 
>>> For instance, if its just a few drivers that really can use this, can't we just
>>> add anew API call, say firmware_request_efi(), then add an internal flag for
>>> this type of lookup and then this fallback mechanism would *only* be used for
>>> those drivers.
>>
>> Yes that is certainly possible, currently there are 2 touchscreen drivers which
>> can use this drivers/input/touchscreen/silead.c and
>> drivers/input/touchscreen/chipone_icn8505.c, with the latter being a driver I just
>> finished this weekend and which I will submit upstream soon.
> 
> OK, so only *one* upstream driver... Yeah with even more reason to never
> consider this seriously by default upstream. It should be an opt-in
> mechanism by drivers explicitly. In fact, it makes then wonder if we want
> to even allow for the default fallback mechanism on the new call. I'm inclined
> to suggest to *not* use it, given the intent and goal is clear by the
> driver: first look for the file, if not found look for the firmware stashed
> on on the EFI EFI_BOOT_SERVICES_CODE.

As the maintainer of that 1 upstream driver (soon to be 2 I submitted
the other driver a couple of days ago) which uses this, I'm fine with the
EFI fallback replacing the userspace-helper fallback path.

<snip>

>>>> diff --git a/drivers/firmware/efi/embedded-firmware.c b/drivers/firmware/efi/embedded-firmware.c
>>>> new file mode 100644
>>>> index 000000000000..80848f332b22
>>>> --- /dev/null
>>>> +++ b/drivers/firmware/efi/embedded-firmware.c
>>>> @@ -0,0 +1,232 @@
>>>> +// SPDX-License-Identifier: GPL-2.0
>>>> +/*
>>>> + * Support for extracting embedded firmware for peripherals from EFI code,
>>>> + *
>>>> + * Copyright (c) 2018 Hans de Goede <hdegoede@redhat.com>
>>>> + */
>>>> +
>>>> +#include <linux/crc32.h>
>>>> +#include <linux/dmi.h>
>>>> +#include <linux/efi.h>
>>>> +#include <linux/types.h>
>>>> +
>>>> +/* Sofar there are no machines with more then 1 interesting embedded firmware */
>>>> +#define MAX_EMBEDDED_FIRMWARES	1
>>>> +
>>>> +struct embedded_fw_desc {
>>>> +	const char *name;
>>>> +	u8 prefix[8];
>>>> +	u32 length;
>>>> +	u32 crc;
>>>> +};
>>>> +
>>>> +struct embedded_fw {
>>>> +	const char *name;
>>>> +	void *data;
>>>> +	size_t length;
>>>> +};
>>>> +
>>>> +static struct embedded_fw found_fw[MAX_EMBEDDED_FIRMWARES];
>>>
>>> This is just saving a few bytes, and is still pretty inflexible.
>>> If were going to support this, this is a rather inflexible way to
>>> support this. I'd prefer we link list this. This way if we support,
>>> its an empty list and grows depending on what we find.
>>>
>>> I don't see the benefit of a static array here in any way.
>>
>> It is not like we are ever going to have more then 2-3 embedded
>> firmwares in the foreseeable future and having a static array
>> saves the need to kmalloc the struct embedded_fw and the additional
>> error handling for when this fails, so the array leads to simpler
>> code.
> 
> Yes but you are not maintaining this code, I am and I have no faith a drive-by
> patch author will come back and extend this later when needed.  As such, yes
> please use a linked list to enable us to easily grow this now.

Ok, I will use a linked-list for v2.

>> But if you really want me to change this over to a linked
>> list I can change it.
> 
> If a linked list is *really* an issue, I'd like to know how. For instance, if
> its a lot of bytes of code its worth considering then, specially if this is for
> embedded. The inability to easily support growth is just concerning here.
> 
>>>> +static int found_fw_count;
>>>> +
>>>> +static struct embedded_fw_desc chuwi_vi8_plus_fw[] __initdata = {
>>>> +	{
>>>> +		.name	= "chipone/icn8318-HAMP0002.fw",
>>>> +		.prefix = { 0xb0, 0x07, 0x00, 0x00, 0xe4, 0x07, 0x00, 0x00 },
>>>> +		.length	= 35012,
>>>> +		.crc	= 0x74dfd3fc,
>>>> +	},
>>>> +	{}
>>>> +};
>>>> +
>>>> +static struct embedded_fw_desc chuwi_hi8_pro_fw[] __initdata = {
>>>> +	{
>>>> +		.name	= "silead/gsl3680-chuwi-hi8-pro.fw",
>>>> +		.prefix = { 0xf0, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00 },
>>>> +		.length	= 39864,
>>>> +		.crc	= 0xfe2bedba,
>>>> +	},
>>>> +	{}
>>>> +};
>>>> +
>>>> +static struct embedded_fw_desc cube_iwork8_air_fw[] __initdata = {
>>>> +	{
>>>> +		.name	= "silead/gsl3670-cube-iwork8-air.fw",
>>>> +		.prefix = { 0xf0, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00 },
>>>> +		.length	= 38808,
>>>> +		.crc	= 0xfecde51f,
>>>> +	},
>>>> +	{}
>>>> +};
>>>> +
>>>> +static struct embedded_fw_desc pipo_w2s_fw[] __initdata = {
>>>> +	{
>>>> +		.name	= "silead/gsl1680-pipo-w2s.fw",
>>>> +		.prefix = { 0xf0, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00 },
>>>> +		.length	= 39072,
>>>> +		.crc	= 0x28d5dc6c,
>>>> +	},
>>>> +	{}
>>>> +};
>>>> +
>>>> +static struct dmi_system_id embedded_fw_table[] __initdata = {
>>>> +	{
>>>> +		/* Chuwi Vi8 Plus (CWI506) */
>>>> +		.driver_data = (void *)chuwi_vi8_plus_fw,
>>>> +		.matches = {
>>>> +			DMI_MATCH(DMI_SYS_VENDOR, "Hampoo"),
>>>> +			DMI_MATCH(DMI_PRODUCT_NAME, "D2D3_Vi8A1"),
>>>> +			DMI_MATCH(DMI_BOARD_NAME, "Cherry Trail CR"),
>>>> +		},
>>>> +	},
>>>> +	{
>>>> +		/* Chuwi Hi8 Pro (CWI513) */
>>>> +		.driver_data = (void *)chuwi_hi8_pro_fw,
>>>> +		.matches = {
>>>> +			DMI_MATCH(DMI_SYS_VENDOR, "Hampoo"),
>>>> +			DMI_MATCH(DMI_PRODUCT_NAME, "X1D3_C806N"),
>>>> +		},
>>>> +	},
>>>> +	{
>>>> +		/* Cube iWork8 Air */
>>>> +		.driver_data = (void *)cube_iwork8_air_fw,
>>>> +		.matches = {
>>>> +			DMI_MATCH(DMI_SYS_VENDOR, "cube"),
>>>> +			DMI_MATCH(DMI_PRODUCT_NAME, "i1-TF"),
>>>> +			DMI_MATCH(DMI_BOARD_NAME, "Cherry Trail CR"),
>>>> +		},
>>>> +	},
>>>> +	{
>>>> +		/* Pipo W2s */
>>>> +		.driver_data = (void *)pipo_w2s_fw,
>>>> +		.matches = {
>>>> +			DMI_MATCH(DMI_SYS_VENDOR, "PIPO"),
>>>> +			DMI_MATCH(DMI_PRODUCT_NAME, "W2S"),
>>>> +		},
>>>> +	},
>>>> +	{}
>>>> +};
>>>
>>> Maintaining these on a separate file might be easier to maintain.
>>
>> Sure, I can move these to say:
>>
>> drivers/firmware/efi/embedded-firmware-table.c ?
> 
> Sure. So to be clear without the above mapping we won't be able to find
> the firmware. Also, the above should imply we have a respective upstream
> driver per entry ? If so can you annotate some how which driver?
> 
> Or better yet... maintaining the above seems rather painful. Why not just let
> the driver list this on its own with a macro, this way we don't have such a
> list? I think there are parsers for example of MODULE_FIRMWARE() and if a
> driver lists it, and the driver requires the firmware on boot I think some
> tools include the driver's firmware on initramfs. Could something similar be
> done to construct such a table automatically given the drivers enabled only
> with their respective macro issued?

So thinking more about this, I agree that this needs to be driver driven,
for the silead touchscreens we have:

drivers/platform/x86/silead_dmi.c

Which contains touchscreen parameters such as x and y coordinate ranges
and touchscreen orientation vs lcd-panel orientation, as well as a
per model firmware filename as the firmware is model-specific.

It makes a lot of sense to also add embedded firmware info in the
very same dmi_system_id table, this can simply be done by making the
data pointed to by the dmi_system_id.driver_data member always
start with a struct embedded_fw_desc. Then the efi embedded firmware
code can use the same table.

The chipone-icn8505 touchscreens don't need any of the mentioned
parameters, there is an ACPI method (_SUB) to get a string which
should uniquely identify the needed firmware file and the other info
can be read back from the hardware after loading the firmware, but
we can still use the same mechanism there.

So my plan for v2 is to:
-rename silead_dmi to touchscreen_dmi (and also use it for chipone info)
-have the TOUCHSCREEN_DMI Kconfig option select EFI_EMBEDDED_FIRMWARE
-inside drivers/firmware/efi/embedded-firmware.c, have:

static const struct * const dmi_system_id embedded_fw_table[] = {
#ifdef CONFIG_TOUCHSCREEN_DMI
	touchscreen_dmi_table,
#endif
	NULL
};

With the idea that in the future it may become:

static const struct * const dmi_system_id embedded_fw_table[] = {
#ifdef CONFIG_TOUCHSCREEN_DMI
	touchscreen_dmi_table,
#endif
#ifdef CONFIG_DRIVER_FOOBAR
	driver_foobar_dmi_table,
#endif
#ifdef CONFIG_DRIVER_BARFOO
	driver_foobar_dmi_table,
#endif
	NULL
};

This means one commit touching drivers/firmware/efi/embedded-firmware.c
each time a new driver starts using EFI embedded firmware, but I think
that will be quite rare and if I turn out to be wrong we can always
do something more fancy later.

> This way also if no driver is enabled that needs this, the code can just be
> disabled and we save some more bytes on the kernel.

Ack.

> 
>>>> +
>>>> +/*
>>>> + * Note the efi_check_for_embedded_firmwares() code currently makes the
>>>> + * following 2 assumptions. This may needs to be revisited if embedded firmware
>>>> + * is found where this is not true:
>>>> + * 1) The firmware is only found in EFI_BOOT_SERVICES_CODE memory segments
>>>> + * 2) The firmware always starts at an offset which is a multiple of 8 bytes
>>>
>>> Who's defining this? Is this an agreed upon thing between a few companies, or
>>> is this written as part of a standard which we can refer to in documentation.
>>
>> Definitely not part of the standard, this is just observed behavior on
>> devices which have (interesting) peripheral firmware embedded in their EFI
>> code.
> 
> Then best document very well.

Ack.

>>>> + */
>>>> +static int __init efi_check_md_for_embedded_firmware(
>>>> +	efi_memory_desc_t *md, const struct embedded_fw_desc *desc)
>>>> +{
>>>> +	u64 i, size;
>>>> +	u32 crc;
>>>> +	u8 *mem;
>>>> +
>>>> +	size = md->num_pages << EFI_PAGE_SHIFT;
>>>> +	mem = memremap(md->phys_addr, size, MEMREMAP_WB);
>>>> +	if (!mem) {
>>>> +		pr_err("Error mapping EFI mem at %#llx\n", md->phys_addr);
>>>> +		return -ENOMEM;
>>>> +	}
>>>> +
>>>> +	size -= desc->length;
>>>> +	for (i = 0; i < size; i += 8) {
>>>> +		if (*((u64 *)(mem + i)) != *((u64 *)desc->prefix))
>>>> +			continue;
>>>> +
>>>> +		/* Seed with ~0, invert to match crc32 userspace utility */
>>>> +		crc = ~crc32(~0, mem + i, desc->length);
>>>> +		if (crc == desc->crc)
>>>> +			break;
>>>> +	}
>>>> +
>>>> +	memunmap(mem);
>>>> +
>>>> +	if (i >= size)
>>>> +		return -ENOENT;
>>>> +
>>>> +	pr_info("Found EFI embedded fw '%s' crc %08x\n", desc->name, desc->crc);
>>>> +
>>>> +	if (found_fw_count >= MAX_EMBEDDED_FIRMWARES) {
>>>> +		pr_err("Error already have %d embedded firmwares\n",
>>>> +		       MAX_EMBEDDED_FIRMWARES);
>>>> +		return -ENOSPC;
>>>> +	}
>>>> +
>>>> +	found_fw[found_fw_count].data =
>>>> +		memremap(md->phys_addr + i, desc->length, MEMREMAP_WB);
>>>
>>> I've heard of some firmware bing over hundreds of MB these days. Once
>>> the can of worms is open its just a matter of time before someone
>>> tries to abuse, so do we have any limitation size? How about spec
>>> wise? Are there any limitations implied by it?
>>>
>>> If there are rather small, do we stand to gain instead to just kzalloc()
>>> and memcpy the found firmware? If done this way, wouldn't you be able
>>> to run this earlier?
>>
>> Using kmalloc still requires memory-management to be setup, just as
>> using memremap does. The whole "needs to be run late" comment is
>> about this needing to run after mm_init(). Anyways as said I think
>> the whole when to run this discussion is a red herring based on my
>> poor choice of words in the commit message.
>>
>> But doing a kmemdup on found firmware instead would avoid
>> the need for efi_mem_reserve()...
> 
> Yay.
>>
>>>> +	if (!found_fw[found_fw_count].data) {
>>>> +		pr_err("Error mapping embedded firmware\n");
>>>> +		return -ENOMEM;
>>>> +	}
>>>> +
>>>> +	found_fw[found_fw_count].name = desc->name;
>>>> +	found_fw[found_fw_count].length = desc->length;
>>>> +	found_fw_count++;
>>>> +
>>>> +	/* Note md points to *unmapped* memory after this!!! */
>>>> +	efi_mem_reserve(md->phys_addr + i, desc->length);
>>>
>>> Do you need a for_each_efi_memory_desc_safe() perhaps?
>>
>> See below.
>>
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +void __init efi_check_for_embedded_firmwares(void)
>>>> +{
>>>> +	const struct embedded_fw_desc *fw_desc;
>>>> +	const struct dmi_system_id *dmi_id;
>>>> +	efi_memory_desc_t *md;
>>>> +	int i, r;
>>>> +
>>>> +	dmi_id = dmi_first_match(embedded_fw_table);
>>>> +	if (!dmi_id)
>>>> +		return;
>>>> +
>>>> +	fw_desc = dmi_id->driver_data;
>>>> +	for (i = 0; fw_desc[i].length; i++) {
>>>> +		for_each_efi_memory_desc(md) {
>>>> +			if (md->type != EFI_BOOT_SERVICES_CODE)
>>>> +				continue;
>>>> +
>>>> +			r = efi_check_md_for_embedded_firmware(md, &fw_desc[i]);
>>>> +			if (r == 0) {
>>>> +				/*
>>>> +				 * On success efi_mem_reserve() has been called
>>>> +				 * installing a new memmap, so our pointers
>>>> +				 * are invalid now and we MUST break the loop.
>>>> +				 */
>>>> +				break;
>>>
>>> Yeah this seems fragile. Can we do better?
>>
>> If we want to use efi_mem_reserve() no, because the memory descriptors
>> are in an array and the entire array gets re-allocated on changes.
>>
>> Note AFAICT this MUST be an array because we pass it to the EFI firmware,
>> but your suggestion to use kmemdup on the firmware would fix the need for
>> efi_mem_reserve() fixing the fragility, so that probably is a better way
>> to deal with this.
> 
> OK!

I will switch to kmemdup for v2. The memory usage will be the same as we
can then omit the efi_mem_reserve() call and the original copy will get
freed.

Ok, time for me to start working on a v2, based on the latest driver-core/next
code, adding all the discussed changes as well as adding a bunch of documentation.

Regards,

Hans
