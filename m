Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33AD01A6808;
	Fri,  4 Sep 2026 22:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788559599; cv=none; b=DEA0ChDT1uvQgnBdzKYgb3X2ckjp98nmqGUby33cA24mwZEZFSNDc9FGnWqNExpB9S+7fz5K6sZuUTOOWltoDpo6TPzL4GAxvtxicevwuLAWJ4A6VyBc/UTYD4TLNlDyoRDsg3UTWudwC+XfJbatQ8Gu3hplitnhgRFXWnat6Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788559599; c=relaxed/simple;
	bh=lrx21Dx+t4JizRxwpdFek9IR7kwqiB15X8JY8g4O8dk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ovUosP2PjPpdFZYyk+LhuYAUdUUZV3KpBKM27pYkyKEX9kFHrmMmZ+xUrvOKdYhvJmnnOD6QzkQ3YPQVGSbtYPBWGcRLsA/N8eLDKdu/u/XufgbkG8xAfCTL2CESRbeL3hImkx4AhOawP3QPlNSi3kmANhvs1rWW8lHN16Lvo3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TLUz5Tcd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TLUz5Tcd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C272E1F00A3D;
	Fri,  4 Sep 2026 22:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788559597;
	bh=ZUMuaDKriKW3xTpI/0IaIkVhIiUoEGZRp+o7tOl7O/4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=TLUz5Tcdn3gEo3i+8I/54CV+aOkgeFFNUlQwnwKit9OLrWZK54fwumQkTYrX+XzUH
	 yHQEQYGnvARRJPe+ME9AedsVIF8MvVJNPvV1Sc3U6oDKRSUfTJ+/E5MOtogPiFOl2f
	 M9mcQdKbGtc+g5InohTQFMKLYscHrMmQfTFImMz3mutUOMf7x6Mnj9/PDD/1JMi2bA
	 IAgAq0R21aKVnAYqgD/UxO9cQNbU52XIH/eSXluFRG43aCzlZaSxpuS74Z+EeZyJIv
	 EJ8YURqfRufbPdHPmavU+2/yMilkSQU/jqpJXtGNYvFUxHfSNN8qRbBoyAgioW26mm
	 sEevh1mEk0BNw==
Message-ID: <d6b7cdae-8b99-49a2-9d9d-03eb77deb1dd@kernel.org>
Date: Sat, 5 Sep 2026 00:06:34 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] efi/libstub: populate LoaderDevicePartUUID
To: Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
References: <20260903-efi_stub_bli-v2-1-dbf7ba915117@kernel.org>
 <b3982808-5ae5-48b8-a677-9f284a764685@app.fastmail.com>
From: Vincent Mailhol <mailhol@kernel.org>
Content-Language: en-US
Autocrypt: addr=mailhol@kernel.org; keydata=
 xjMEZluomRYJKwYBBAHaRw8BAQdAf+/PnQvy9LCWNSJLbhc+AOUsR2cNVonvxhDk/KcW7FvN
 JFZpbmNlbnQgTWFpbGhvbCA8bWFpbGhvbEBrZXJuZWwub3JnPsKZBBMWCgBBFiEE7Y9wBXTm
 fyDldOjiq1/riG27mcIFAmdfB/kCGwMFCQp/CJcFCwkIBwICIgIGFQoJCAsCBBYCAwECHgcC
 F4AACgkQq1/riG27mcKBHgEAygbvORJOfMHGlq5lQhZkDnaUXbpZhxirxkAHwTypHr4A/joI
 2wLjgTCm5I2Z3zB8hqJu+OeFPXZFWGTuk0e2wT4JzjgEZx4y8xIKKwYBBAGXVQEFAQEHQJrb
 YZzu0JG5w8gxE6EtQe6LmxKMqP6EyR33sA+BR9pLAwEIB8J+BBgWCgAmFiEE7Y9wBXTmfyDl
 dOjiq1/riG27mcIFAmceMvMCGwwFCQPCZwAACgkQq1/riG27mcJU7QEA+LmpFhfQ1aij/L8V
 zsZwr/S44HCzcz5+jkxnVVQ5LZ4BANOCpYEY+CYrld5XZvM8h2EntNnzxHHuhjfDOQ3MAkEK
In-Reply-To: <b3982808-5ae5-48b8-a677-9f284a764685@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 04/09/2026 at 18:12, Ard Biesheuvel wrote:
> Hello Vincent,
> 
> On Thu, 3 Sep 2026, at 23:19, Vincent Mailhol wrote:
>> The Boot Loader Interface [1] defines LoaderDevicePartUUID. That EFI
>> variable records the GPT partition UUID of the partition containing the
>> boot loader.
>>
>> This is used, for example, by systemd-gpt-auto-generator [2] to identify
>> the disk the boot loader was launched from and automatically detect and
>> mount partitions on it.
>>
>> GRUB [3] and systemd-boot [4] populate it, but when the kernel is
>> started directly by EFI firmware, there is no conventional external boot
>> loader to provide the variable. In that case, because the EFI stub
>> performs the boot loader role, it should provide the variable itself.
>>
> 
> Fair enough.
> 
> But shouldn't it set LoaderInfo as well then?

Sure. This is quite easy to do.

Any preference of what to put in that variable? I am thinking of
adding the release number like this:

	#define EFI_BLI_LOADER_INFO L"Linux EFI stub " UTS_RELEASE

This looks consistent with what the other boot loaders are doing:

	$ cat /sys/firmware/efi/efivars/LoaderInfo-4a67b082-0a4c-41cfb6c7-440b29bb8c4f 
	GRUB 2.12

Also, this gave me an idea. Maybe we can use the LoaderInfo variable
as a sentinel for all other variables:

	void efi_bli_set_variables(efi_loaded_image_t *image)
	{
		unsigned long size = 0;

		if (get_efi_var(L"LoaderInfo", &loader_entry_guid,
				NULL, &size, NULL) != EFI_NOT_FOUND)
			return;

		efi_bli_populate_loader_info();
		efi_bli_populate_loader_part_uuid(image);
	}

If it is set, we bail out, otherwise, we assume that the earlier boot
stage did not implement BLI and we blindly populate everything. No
more additional check on whether LoaderDevicePartUUID or other
variables are set!

Does this approach make sense?

>> Parse the loaded image device path, extract the GUID signature from its
>> GPT HD() node and publish it under the Linux loader entry vendor GUID as
>> the volatile LoaderDevicePartUUID EFI variable. Do not overwrite an
>> existing variable, so a value supplied by an earlier boot stage keeps
>> precedence.
>>
>> Install the efi_bli_set_variables() hook in both the generic efi-stub.c
>> path and the x86-specific x86-stub.c path.
>>
>> Add CONFIG_EFI_STUB_BLI to make this new feature configurable.
>>
> 
> I don't think this is needed tbh. Better to enable this unconditionally
> so we can rely on this being present in the longer term.

Agreed. To be honest, I did not put that in v1. I was just worried
that people might complain of the size increase for a feature some
might no want to use. But maybe my other cleanup series on the GUID
made a more convincing argument on the size!

I will happily remove this in v3.

>> For an x86_64 build using gcc 15.3.0, bloat-o-meter reports the
>> following difference between builds without and with CONFIG_EFI_STUB_BLI:
>>
>>   add/remove: 5/0 grow/shrink: 1/0 up/down: 639/0 (639)
>>   Function                                     old     new   delta
>>   efi_bli_set_variables                          -     563    +563
>>   loader_entry_guid                              -      16     +16
>>   hex                                            -      16     +16
>>   guid_index                                     -      16     +16
>>   device_path_guid                               -      16     +16
>>   efi_stub_entry                              4180    4192     +12
>>   Total: Before=29223, After=29862, chg +2.19%
>>
>> [1] The Boot Loader Interface
>> Link: https://systemd.io/BOOT_LOADER_INTERFACE/
>>
>> [2] systemd-gpt-auto-generator
>> Link: 
>> https://www.freedesktop.org/software/systemd/man/latest/systemd-gpt-auto-generator.html
>>
>> [3] GRUB -- §16.2 bli
>> Link: 
>> https://www.gnu.org/software/grub/manual/grub/html_node/bli_005fmodule.html
>>
>> [4] systemd -- systemd-boot UEFI Boot Manager
>> Link: https://github.com/systemd/systemd/blob/main/docs/BOOT.md?plain=1#L111
>>
>> Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
>> ---
>> Changes in v2:
>>
>>   - Add CONFIG_EFI_STUB_BLI to make the BLI feature optional.
>>
>>   - Use static storage for GUID initializers. This reduces the size by
>>     about 10% compared to v1.
>>
>>   - Remove the redundant NULL check on image.
>>
>>   - Move the nibble-to-ASCII-hex conversion out of efi_bli_guid_to_str()
>>     into the new efi_bli_nibble_to_hex().
>>
>>   - Rename variables to be closer to the EFI specification.
>>
>> Link to v1: 
>> https://lore.kernel.org/r/20260725-efi_stub_bli-v1-1-966e4748077f@kernel.org
>> ---
>>  drivers/firmware/efi/Kconfig            |  15 +++++
>>  drivers/firmware/efi/libstub/Makefile   |   2 +
>>  drivers/firmware/efi/libstub/bli.c      | 114 
>> ++++++++++++++++++++++++++++++++
>>  drivers/firmware/efi/libstub/efi-stub.c |   1 +
>>  drivers/firmware/efi/libstub/efistub.h  |   6 ++
>>  drivers/firmware/efi/libstub/x86-stub.c |   1 +
>>  6 files changed, 139 insertions(+)
>>
>> diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
>> index 29e0729299f5..eff7c6164096 100644
>> --- a/drivers/firmware/efi/Kconfig
>> +++ b/drivers/firmware/efi/Kconfig
>> @@ -100,6 +100,21 @@ config EFI_ARMSTUB_DTB_LOADER
>>  	  functionality for bootloaders that do not have such support
>>  	  this option is necessary.
>>
>> +config EFI_STUB_BLI
>> +	bool "EFI stub Boot Loader Interface support"
>> +	depends on EFI_STUB
>> +	default y
>> +	help
>> +	  The Boot Loader Interface defines EFI variables that expose
>> +	  information about the boot loader to the running OS.
>> +
>> +	  Enable this option to let the EFI stub populate the volatile
>> +	  LoaderDevicePartUUID EFI variable when it is missing. This allows
>> +	  user space services such as systemd-gpt-auto-generator to discover
>> +	  partitions on the disk from which the kernel was loaded.
>> +
>> +	  If unsure, say Y.
>> +
>>  config EFI_BOOTLOADER_CONTROL
>>  	tristate "EFI Bootloader Control"
>>  	select UCS2_STRING
>> diff --git a/drivers/firmware/efi/libstub/Makefile 
>> b/drivers/firmware/efi/libstub/Makefile
>> index 77a2b2d74f3f..000a73a4bc52 100644
>> --- a/drivers/firmware/efi/libstub/Makefile
>> +++ b/drivers/firmware/efi/libstub/Makefile
>> @@ -75,6 +75,8 @@ libfdt-deps			:= fdt_rw.c fdt_ro.c fdt_wip.c fdt.c \
>>  lib-$(CONFIG_EFI_PARAMS_FROM_FDT) += fdt.o \
>>  				     $(patsubst %.c,lib-%.o,$(libfdt-deps))
>>
>> +lib-$(CONFIG_EFI_STUB_BLI)	+= bli.o
>> +
>>  $(obj)/lib-%.o: $(srctree)/lib/%.c FORCE
>>  	$(call if_changed_rule,cc_o_c)
>>
>> diff --git a/drivers/firmware/efi/libstub/bli.c 
>> b/drivers/firmware/efi/libstub/bli.c
>> new file mode 100644
>> index 000000000000..d54eb42729a7
>> --- /dev/null
>> +++ b/drivers/firmware/efi/libstub/bli.c
>> @@ -0,0 +1,114 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +
>> +#include <linux/efi.h>
>> +#include <linux/errno.h>
>> +#include <linux/unaligned.h>
>> +
>> +#include "efistub.h"
>> +
>> +struct efi_hd_dev_path {
>> +	struct efi_generic_dev_path header;
>> +	u32 partition_number;
>> +	u64 partition_start;
>> +	u64 partition_size;
>> +	efi_guid_t signature;
>> +	u8 partition_format;
>> +	u8 signature_type;
>> +} __packed;
>> +
> 
> Please add this to linux/efi.h and add it to the union
> in struct efi_dev_path as well.
> 
>> +#define EFI_HD_PARTITION_FORMAT_GPT	2
>> +#define EFI_HD_SIGNATURE_TYPE_GUID	2
>> +
> 
> These too

Ack.

>> +static efi_char16_t efi_bli_nibble_to_hex(u8 nibble)
>> +{
>> +	static const char hex[16] __nonstring = "0123456789abcdef";
>> +
>> +	return hex[nibble];
>> +}
>> +
>> +static void efi_bli_guid_to_str(const efi_guid_t *guid, efi_char16_t 
>> *out)
>> +{
>> +	static const u8 guid_index[UUID_SIZE] = {
>> +		3, 2, 1, 0, 5, 4, 7, 6, 8, 9, 10, 11, 12, 13, 14, 15,
>> +	};
>> +
>> +	for (int i = 0; i < ARRAY_SIZE(guid_index); i++) {
>> +		u8 byte = guid->b[guid_index[i]];
>> +
>> +		*out++ = efi_bli_nibble_to_hex(byte >> 4);
>> +		*out++ = efi_bli_nibble_to_hex(byte & 0xf);
>> +
>> +		switch (i) {
>> +		case 3:
>> +		case 5:
>> +		case 7:
>> +		case 9:
>> +			*out++ = L'-';
>> +		}
>> +	}
>> +
>> +	*out = L'\0';
>> +}
>> +
> 
> I'm reluctant to add this kind of code as a special one-off, so I got a
> bit carried away and took this code and put it in the stub's printf
> layer.

Thanks for the extra work!

> Could you please check whether the first two patches at [0] are
> sufficient for efi_bli_guid_to_str() to be replaced by a simple
> efi_snprintf("%pUl", ...) call here?

Ack. I already rebased and did a compile test, OK so far. The runtime
test will come later. If I find an issue, I will send you a fix. If
not, I will just send the v3 rebased on top of your
efi-libstub-native-utf16 branch.


Yours sincerely,
Vincent Mailhol
