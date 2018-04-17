From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH v3 2/5] efi: Add embedded peripheral firmware support
Date: Tue, 17 Apr 2018 11:19:14 +0200
Message-ID: <00800dc5-f6de-ab26-4d3e-eb2a47e10709@redhat.com>
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
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
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

So thinking some more about this, I can put the device_property check
inside the fw_get_efi_embedded_fw() call, as well as modify opt_flags
there to or in FW_OPT_NOCACHE on success, then together with the discussed
changed to drop the #ifdef, the code would look like this:

         ret = fw_get_filesystem_firmware(device, fw->priv);
	if (ret)
		fw_get_efi_embedded_fw(device, fw->priv, &opt_flags, ret);
	if (ret)
                 if (!(opt_flags & FW_OPT_NO_WARN))
                         dev_warn(device,
	...

With just these 2 lines being new:

	if (ret)
		fw_get_efi_embedded_fw(device, fw->priv, &opt_flags, ret);

So the main.c changes will be nice and clean then.

Regards,

Hans
