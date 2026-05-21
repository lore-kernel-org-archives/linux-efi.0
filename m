Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1787367283;
	Thu, 21 May 2026 12:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779367409; cv=none; b=EeRMBB37yYJkn10840/Ep21TuAuOnrgYECk0hd+FJ4rlC9FER2PKg7KJzvXI/HlKJX6Pn+ir3jSFdai7Sdri9Qa1cmhHyEaOkZku6agBghE7Xk2o77WWyWBXG8aA+LtFkY4ytClx5rR6KkPSULRGN3Sck9sF4JBJzZK45Xrqmmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779367409; c=relaxed/simple;
	bh=6qGXnuBUztq2mFzcY8Yv6RaizNCIjxJo4qLhwBShajE=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=fgMudER189JWFCZr8XFqEa7Pp+mbewNuKvmA2PSvqebNqpGMXoQF10XdBqCqsXzxPDIrEo+W6IRI94q4FUueUnBuqk3Rg+iro6Z0vCM/x167omh9hVXuyXjrzYbomVo+QmSdSBMQ/XCSHo9TSlotcViqvZ+DfZKLBlReA76M4V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Okr7lM7p; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Okr7lM7p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779367408; x=1810903408;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=6qGXnuBUztq2mFzcY8Yv6RaizNCIjxJo4qLhwBShajE=;
  b=Okr7lM7pl9blWFJIL6NorN2rv/p2QgBEqSMZE7Gkew8liYSMTkADEKVO
   UB5vXK9BXUj72R7TAh8A4LqCAxb+Y+9ebj+B5w/dKJjfdoNHH/ph4ueAL
   53BUk8jVumC0ATcrg+mrEQX0LGLv7FfoqtKlSCeRSImkWopVP92LQyUjF
   O37p0Kq4CNDO3PEpRFEfR7CwzS5jabUQWRC3s4pjE0VYD5M4fcXj7OaFf
   ulUXHXEN+WsapR6pEBLGQwIgGAlpNIYBQh5c553OubzqrGH1Ik7msjCyb
   9nIKbfB83KJO6rdGMWMFccrDtt7rFDoYPin/fnZp/S/rHUxlYSqhW0pCH
   Q==;
X-CSE-ConnectionGUID: 6/WScsa9SqOK9ToU4ThqQw==
X-CSE-MsgGUID: p9AGGgSZRBq1U+4lrDyCJQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11792"; a="83903512"
X-IronPort-AV: E=Sophos;i="6.23,246,1770624000"; 
   d="scan'208";a="83903512"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2026 05:43:28 -0700
X-CSE-ConnectionGUID: O31rDEfJTZ+Q7ICIfpLrAg==
X-CSE-MsgGUID: AYJuUjMbTAaLPORQgzm5FA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,246,1770624000"; 
   d="scan'208";a="240543043"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.244.98])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2026 05:43:25 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Thu, 21 May 2026 15:43:21 +0300 (EEST)
To: Atharva Tiwari <atharvatiwarilinuxdev@gmail.com>
cc: Ard Biesheuvel <ardb@kernel.org>, Hans de Goede <hansg@kernel.org>, 
    LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org, 
    platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH v4 2/2] platform/apple-gmux: use apple_brightness to save
 brightness to EFI
In-Reply-To: <20260316153407.1781-3-atharvatiwarilinuxdev@gmail.com>
Message-ID: <f5cb54b3-b30d-2e20-874a-824aab1c3eea@linux.intel.com>
References: <20260316153407.1781-1-atharvatiwarilinuxdev@gmail.com> <20260316153407.1781-3-atharvatiwarilinuxdev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Mon, 16 Mar 2026, Atharva Tiwari wrote:

> use apple_brightness to save brightness to EFI.

Please capitalize changelog text properly.

> 
> (tested on iMac20,1)
> 
> Signed-off-by: Atharva Tiwari <atharvatiwarilinuxdev@gmail.com>
> ---
>  drivers/platform/x86/apple-gmux.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/drivers/platform/x86/apple-gmux.c b/drivers/platform/x86/apple-gmux.c
> index 1417e230edbd..cab3122c1a86 100644
> --- a/drivers/platform/x86/apple-gmux.c
> +++ b/drivers/platform/x86/apple-gmux.c
> @@ -22,6 +22,7 @@
>  #include <linux/pci.h>
>  #include <linux/vga_switcheroo.h>
>  #include <linux/debugfs.h>
> +#include <linux/platform_data/apple-brightness.h>
>  #include <acpi/video.h>
>  #include <asm/io.h>
>  
> @@ -78,6 +79,8 @@ struct apple_gmux_data {
>  	/* debugfs data */
>  	u8 selected_port;
>  	struct dentry *debug_dentry;
> +
> +	bool save_efi;
>  };
>  
>  static struct apple_gmux_data *apple_gmux_data;
> @@ -960,6 +963,13 @@ static int gmux_probe(struct pnp_dev *pnp, const struct pnp_device_id *id)
>  	}
>  
>  	gmux_init_debugfs(gmux_data);
> +	if (IS_ENABLED(CONFIG_APPLE_BRIGHTNESS)) {
> +		ret = apple_brightness_probe(gmux_data->bdev, &gmux_get_brightness);
> +		if (ret)
> +			pr_warn("Unable to Enable EFI brightness save: %d\n", ret);

Include for pr_warn() is missing from this file.

> +		else
> +			gmux_data->save_efi = true;
> +	}
>  	return 0;
>  
>  err_register_handler:
> @@ -1012,6 +1022,16 @@ static void gmux_remove(struct pnp_dev *pnp)
>  	kfree(gmux_data);
>  }
>  
> +static void gmux_shutdown(struct pnp_dev *pnp)
> +{
> +	struct apple_gmux_data *gmux_data = pnp_get_drvdata(pnp);
> +
> +	if (IS_ENABLED(CONFIG_APPLE_BRIGHTNESS) && gmux_data->save_efi)
> +		apple_brightness_shutdown();
> +
> +	gmux_remove(pnp);
> +}
> +
>  static const struct pnp_device_id gmux_device_ids[] = {
>  	{GMUX_ACPI_HID, 0},
>  	{"", 0}
> @@ -1026,6 +1046,7 @@ static struct pnp_driver gmux_pnp_driver = {
>  	.name		= "apple-gmux",
>  	.probe		= gmux_probe,
>  	.remove		= gmux_remove,
> +	.shutdown	= gmux_shutdown,
>  	.id_table	= gmux_device_ids,
>  	.driver		= {
>  			.pm = &gmux_dev_pm_ops,
> 

-- 
 i.

