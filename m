Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7523CFF4B;
	Thu, 21 May 2026 12:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779366583; cv=none; b=Z4CJN7R670vFTUzXj5Y0ErNuwimmYh7VBUeBgI2DSPs23w0iXBO7XX3oL+5kaLgiwnG/sI4TlXsgdCKBlDgN7toq+zHyoclNjqYOa3SQIfviMf6ccEnmF4nijryQuO6Ej1ePr306lEO15KHT8INTYpDn7zeTPWHLwJjzVJWe5LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779366583; c=relaxed/simple;
	bh=PGjsFChqy22qffJlGbdyT5W5e4RCTVpyLJCpce8Zb8E=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=aXwvUpSDmIbyaCiXmr0fpabvpAEGP4W9gB4n4N+LO5ap6XI0C5kKnmePrTXo03OfFEvMSLIqFJXWG8rt6X29duMeidPp/WPBzowgbf1fmKlBkZhe/9yyWWDnBfSaonPwO3CusplXiyxiYg5/k37KO9ITPOyjtL/tHDoVgPrWzq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FXFOgTaw; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FXFOgTaw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779366581; x=1810902581;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=PGjsFChqy22qffJlGbdyT5W5e4RCTVpyLJCpce8Zb8E=;
  b=FXFOgTawHDJvlsdymL7PBfQtmXGXuN0HQgO8Uh5R87l7X5A6DTftciTH
   VcydxlVqIzewpfJXrCB1mjWGF0OWRdXSWaGHrsgAs6traCR6kvuN3XB5n
   3HFTLjrkiFD0pk88bIApbLnmrnNdYZo2ximOOngAxoMEy2ht1qr3UpAMP
   mxpyu4xBfOTqEcizeTwLSJXHzjvmECEBmRUIjN08JrtAyY9hXDeLbotsC
   NVDm+8SPiWfMFtSmBAwoe3Ld8Mp0woXIFR9UV2ETemBMC1tbXkc1rktTH
   kTz10pr2yJAVxIUkqZgiVSYhOrIpw4PWCuTlIsyyBfAReKNLYUQEf5PFn
   A==;
X-CSE-ConnectionGUID: EbLMueY6RHq8X8ZyR/F02Q==
X-CSE-MsgGUID: HUMlb2nvS56HS/Jzya25Nw==
X-IronPort-AV: E=McAfee;i="6800,10657,11792"; a="83902523"
X-IronPort-AV: E=Sophos;i="6.23,246,1770624000"; 
   d="scan'208";a="83902523"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2026 05:29:40 -0700
X-CSE-ConnectionGUID: BKJ8qQIAQziIjkowZjLitA==
X-CSE-MsgGUID: Xu877NXgRCu/nQpmN3HrgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,246,1770624000"; 
   d="scan'208";a="240541602"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.244.98])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2026 05:29:38 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Thu, 21 May 2026 15:29:34 +0300 (EEST)
To: Atharva Tiwari <atharvatiwarilinuxdev@gmail.com>
cc: Lukas Wunner <lukas@wunner.de>, Ard Biesheuvel <ardb@kernel.org>, 
    Hans de Goede <hansg@kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
    linux-efi@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH v4 1/2] efi: Save Brightness using EFI on Macs
In-Reply-To: <20260316153407.1781-2-atharvatiwarilinuxdev@gmail.com>
Message-ID: <a527feee-441c-aaf8-9aff-f5bee8b97b6d@linux.intel.com>
References: <20260316153407.1781-1-atharvatiwarilinuxdev@gmail.com> <20260316153407.1781-2-atharvatiwarilinuxdev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Mon, 16 Mar 2026, Atharva Tiwari wrote:

> Currently when a Mac reboots, the brightness is not the same
> as the previous boot instead its the same as the last time the

When a Mac reboots, it does not preserve the brightness from the previous 
boot, instead ...

It might be worth to expand that to mention what brightness you're 
talking about here and in the Kconfig description.

> Mac booted macOS.
> 
> We can fix this issue by saving the brightness level to the efivar

Please use imperative tone. Do not use "I" (nor "We" nor "This patch").

> backlight-level.
> 
> (tested on iMac20,1)
> 
> Suggested-by: Lukas Wunner <lukas@wunner.de>
> Signed-off-by: Atharva Tiwari <atharvatiwarilinuxdev@gmail.com>
> ---
>  drivers/firmware/efi/Kconfig                  | 10 +++
>  drivers/firmware/efi/Makefile                 |  1 +
>  drivers/firmware/efi/apple-brightness.c       | 67 +++++++++++++++++++
>  .../linux/platform_data/apple-brightness.h    | 20 ++++++
>  4 files changed, 98 insertions(+)
>  create mode 100644 drivers/firmware/efi/apple-brightness.c
>  create mode 100644 include/linux/platform_data/apple-brightness.h
> 
> diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
> index 29e0729299f5..243499a5d7b7 100644
> --- a/drivers/firmware/efi/Kconfig
> +++ b/drivers/firmware/efi/Kconfig
> @@ -167,6 +167,16 @@ config APPLE_PROPERTIES
>  
>  	  If unsure, say Y if you have a Mac.  Otherwise N.
>  
> +config APPLE_BRIGHTNESS
> +	bool "Apple Backlight control for EFI"
> +	depends on X86

Doesn't the build fail if CONFIG_EFI is not set?

> +	help
> +	  This will save the brightness level to EFI, so brightness
> +	  level is preserved across reboots and shutdowns. allowing

English sounds broken because of that period.

> +	  for improved support of Apple hardware.
> +
> +	  If unsure, say Y if you have a Mac, otherwise N.
> +
>  config RESET_ATTACK_MITIGATION
>  	bool "Reset memory attack mitigation"
>  	depends on EFI_STUB
> diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
> index 8efbcf699e4f..1f5705cc87a2 100644
> --- a/drivers/firmware/efi/Makefile
> +++ b/drivers/firmware/efi/Makefile
> @@ -26,6 +26,7 @@ obj-$(CONFIG_EFI_BOOTLOADER_CONTROL)	+= efibc.o
>  obj-$(CONFIG_EFI_TEST)			+= test/
>  obj-$(CONFIG_EFI_DEV_PATH_PARSER)	+= dev-path-parser.o
>  obj-$(CONFIG_APPLE_PROPERTIES)		+= apple-properties.o
> +obj-$(CONFIG_APPLE_BRIGHTNESS)		+= apple-brightness.o
>  obj-$(CONFIG_EFI_RCI2_TABLE)		+= rci2-table.o
>  obj-$(CONFIG_EFI_EMBEDDED_FIRMWARE)	+= embedded-firmware.o
>  obj-$(CONFIG_LOAD_UEFI_KEYS)		+= mokvar-table.o
> diff --git a/drivers/firmware/efi/apple-brightness.c b/drivers/firmware/efi/apple-brightness.c
> new file mode 100644
> index 000000000000..b060861b0795
> --- /dev/null
> +++ b/drivers/firmware/efi/apple-brightness.c
> @@ -0,0 +1,67 @@
> +// SPDX-License-Identifier: GPL-2.0-only OR MIT
> +/*
> + * apple-brightness.c - EFI brightness saver on Macs
> + * Copyright (C) 2026 Atharva Tiwari <atharvatiwarilinuxdev@gmail.com>
> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/backlight.h>
> +#include <linux/efi.h>
> +#include <linux/platform_data/apple-brightness.h>
> +
> +static u32 efi_attr;
> +static u16 last_saved_level;
> +
> +static int (*get_brightness)(struct backlight_device *bl);
> +static struct backlight_device *bl_dev;
> +
> +void apple_brightness_shutdown(void)
> +{
> +	u16 level;
> +	efi_status_t status;
> +
> +	level = (u16)get_brightness(bl_dev);
> +
> +	if (level == last_saved_level)
> +		return;
> +
> +	status = efivar_set_variable(APPLE_BRIGHTNESS_NAME, &APPLE_BRIGHTNESS_GUID,
> +				efi_attr, sizeof(level), &level);

Align to (

> +	if (status != EFI_SUCCESS)
> +		pr_debug("Unable to set brightness: 0x%lx\n", status);

Add include.

> +}
> +EXPORT_SYMBOL(apple_brightness_shutdown);

Please put exports to a namespace.

Also, these look very much _GPL exports as you're passing 
get_brightnessfn around.

> +
> +int apple_brightness_probe(struct backlight_device *bl,
> +	int (*get_brightnessfn)(struct backlight_device *bl))
> +{
> +	efi_status_t status;
> +	unsigned long size = sizeof(last_saved_level);
> +	int ret;
> +
> +	bl_dev = bl;
> +	get_brightness = get_brightnessfn;
> +
> +	if (!efi_rt_services_supported(EFI_RT_SUPPORTED_SET_VARIABLE))
> +		return -ENODEV;
> +
> +	ret = efivar_lock();
> +	if (ret)
> +		return ret;
> +
> +	status = efivar_get_variable(APPLE_BRIGHTNESS_NAME, &APPLE_BRIGHTNESS_GUID,
> +				&efi_attr, &size, &last_saved_level);

Align to (

> +
> +	efivar_unlock();
> +
> +	if (status != EFI_SUCCESS)
> +		return -ENODEV;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(apple_brightness_probe);
> +
> +MODULE_AUTHOR("Atharva Tiwari <atharvatiwarilinuxdev@gmail.com>");
> +MODULE_DESCRIPTION("EFI Brightness saver for Macs");
> +MODULE_LICENSE("Dual MIT/GPL");
> diff --git a/include/linux/platform_data/apple-brightness.h b/include/linux/platform_data/apple-brightness.h
> new file mode 100644
> index 000000000000..54e3f3f8aa1c
> --- /dev/null
> +++ b/include/linux/platform_data/apple-brightness.h
> @@ -0,0 +1,20 @@
> +/* SPDX-License-Identifier: GPL-2.0-only OR MIT */
> +/*
> + * apple-brightness.h - EFI brightness saver for Macs
> + * Copyright (C) 2026 Atharva Tiwari <atharvatiwarilinuxdev@gmail.com>
> + */
> +
> +#ifndef _APPLE_BL_H_
> +#define _APPLE_BL_H_
> +
> +#include <linux/backlight.h>

This can be replaced with just forward declaration of:

struct backlight_device;

> +#include <linux/efi.h>
> +
> +#define APPLE_BRIGHTNESS_NAME           L"backlight-level"
> +#define APPLE_BRIGHTNESS_GUID           EFI_GUID(0x7c436110, 0xab2a, 0x4bbb, 0xa8, 0x80, 0xfe, 0x41, 0x99, 0x5c, 0x9f, 0x82)
> +
> +int apple_brightness_probe(struct backlight_device *bl,
> +	int (*get_brightnessfn)(struct backlight_device *bl));

Align to (

> +
> +void apple_brightness_shutdown(void);
> +#endif /* _APPLE_BL_H */
> 

-- 
 i.

