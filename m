From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH v3 2/5] efi: Add embedded peripheral firmware support
Date: Tue, 17 Apr 2018 00:17:38 +0000
Message-ID: <20180417001738.GN30543@wotan.suse.de>
References: <20180408174014.21908-1-hdegoede@redhat.com>
 <20180408174014.21908-3-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180408174014.21908-3-hdegoede@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: Darren Hart <dvhart@infradead.org>, Andy Shevchenko <andy@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Jones <pjones@redhat.com>, Dave Olsthoorn <dave@bewaar.me>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, dmitry.torokhov@gmail.com, mfuzzey@parkeon.com, keescook@chromium.org, Kalle
List-Id: linux-efi@vger.kernel.org

On Sun, Apr 08, 2018 at 07:40:11PM +0200, Hans de Goede wrote:
>  static void firmware_free_data(const struct firmware *fw)
>  {
> @@ -576,6 +600,15 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
>  		goto out;
>  
>  	ret = fw_get_filesystem_firmware(device, fw->priv);
> +#ifdef CONFIG_EFI_EMBEDDED_FIRMWARE
> +	if (ret && device &&
> +	    device_property_read_bool(device, "efi-embedded-firmware")) {
> +		ret = fw_get_efi_embedded_fw(device, fw->priv, ret);
> +		if (ret == 0)
> +			ret = assign_fw(fw, device, opt_flags | FW_OPT_NOCACHE);
> +		goto out;
> +	}
> +#endif

You mussed what I asked for in terms of adding a new flag, (please work on top
of Andre's patches as those likely will be merged first, and also have kdocs
for the flags) and then a new firmware API to wrap the above into a function
which would only do something if the driver *asked* for it on their firmware
API call.  Ie, please add a new firmware_request_efi_fw(). Also if you see the
work I've done to remove the ifdefs over fallback mechanism you'll see it helps
split code and make it easier to read. We should strive to not add any more
ifdefery and instead make tehis code read easily.

  Luis
