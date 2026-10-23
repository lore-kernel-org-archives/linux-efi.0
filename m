Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792763446;
	b=Rj3MffFTvdeL/nNjbvXUbQvWcA04VY4iORarJ3exaMF5bCmRSb8LCjDga/UKUrdfwXrC
	 tdS/9vjejZi+QJG5T/azcPJnxRamcyjdsV8EQQnKAKIqoWa8bXyp2rZd/Nzy4kFlliG0r
	 BK0jZkhy3J6zTqjCWXm6VjvbWUot0LOPicATXLrjFFeMjwZHQb9kJvuHWLNpt+lXKwnUl
	 9rorLXd1Kpjo1hN7Fnun6B9n9Ao636yIJM5ivZb/5FdTpXTV/FcKmDdjLAJdUDdy3qSdC
	 /KYaWkVTJGMHD90MjZJXXko7CTp3ULMpW33+jTdnp3qHhs+Hz6bTeU5IPXkUGv1ANJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792763446;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=0NpFjYpN/xVT3jWXOdDU/lcmxUKc7WzERCWOTIAk/BA=;
	b=oDC5htRIuYW9qwNBFVtRtpU2VdCQ3OvVIKGihDg784WxhDaJtw+ZIvUmoDoEiRq1IKwv
	 hhKZWNKepm6HPu3EN7YsAi/X4rkCGjGVw+jseK2fObGwNChjHDlLPTLjsnJBi/ok53QjG
	 PpdKASqXt2jtufMA/N+A+u4XVSTNEYyV+cuUC3Ocb37L9BsnW+uAFq5giBOOFoU4UV7ut
	 8TtMBG+Q0jHoaf9fXIH1mBH9fQDAzUetY8W/S2Vgp7CcmF5bAzgsEVuQ3qz604LAZIAUD
	 p9ztcFN6JVOcwFf1GVk+tbgfgnCTUBq5iHkKmdklG0hpnPw3cbKfKz/o3yQpi3Sd9Bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m4WNgV7q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5C2606A31A;
	Fri, 23 Oct 2026 13:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m4WNgV7q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A08791F01829;
	Fri, 23 Oct 2026 13:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792763445;
	bh=0NpFjYpN/xVT3jWXOdDU/lcmxUKc7WzERCWOTIAk/BA=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=m4WNgV7qkShvIuLYcncCN4xhqx3ZNQpJ2GMT4U5yuUSmekRCOJqKeMmsDmPwoZI+Z
	 w7/yIIRPRz+eg8KItehoA3Ajw+vsGhY+1hU7xPyzLBthe9EgVVzoDVgGshpnO8UsZP
	 X51JA6bhQ150/F7WQIwhxrv7R58dxZfDJLfeg8HfzzG1az/HBJgV6iL0B8lpHwFwAQ
	 leDlrFmx0P69kFyohTXr819gcl42xG1Rhwqr5eW+kq2jXRXeMpM0BoBWrXw4X9Zhhw
	 jsQEShmhWl4e8w63R6XOdmZKOK0ilq5Ox/dnvBy9yq6qnDabpjk6tt9jyU3iKVcWt0
	 jrVbYmc8CgJ7A==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id AD19D198004A;
	Fri, 23 Oct 2026 09:50:42 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Fri, 23 Oct 2026 09:50:42 -0400
X-ME-Sender: <xms:MGbbaut5vaoDJHA7zwnFebOCSgX7S9lXLEl46oTxw8s7PZujXycv3A>
    <xme:MGbbauTeaPg7OnvlyahsZMAbE6Ze0peBqYTX-caV3o0kQV1IeabVpj7L1mvqbF-9v
    yH_osMY1reaBgmliM59UlcuNVIXMKpokNraa14FTO8RaT3qw8dT_3E>
X-ME-Proxy-Cause: dmFkZTFPs/AbnesQXAXP/Y/IJU1YVQ7SyPlceIVGJMvTVh2LMFMISXrZef+MNZUVNNUhPz
    0biWenYD5u/jG0ybMCuxdUioR4Xl36fdrs5SLBot56/hBGtP2d1CCav8+9ZXsvBjivCYBy
    Nu4OkC1rxUnUWGmP/t7YmIkEbt44b3n6cA/hpsniZFato9jVS+Q2xavemcsC3W+nXk2UhM
    gd7o5HZS9WKJXmRtTfcOaBG6/oCWYh0/tGWYj0PkaaoLSz/4RI0pXwRagNxll08q8g+UN0
    5+zmGBrDDBFpmXQnHQ1oJWf4XqNepTOzg1Ov5B6Ey8lw5sf6tUa8QJEEM+ASZRFDBMO0ix
    EsfOMm821Lsk1AFbxbMdIbv9ZPF1RyYRddN/DH+7HKwNPf6M0wPHAcaSIZEULh5p1EDXu9
    13Y6IKCxbiHLsiQCifEPZZog+M1HmqwiVsWalfAGuBjhnhCrRtrDztmnzkAf76XVPU+/0V
    +LJuhXri4XquN65qLLZ+bIXzcmFBxcdYO7Xh0QN5vPm7jEyYj+S/+XjaQBeEn2kKmAS8mN
    uUY0UdS/9jDlUu4AGju+qFIoXmkWuj+6WXfxU+Hb4DYN2pILz4osAyETzGkxyadqsH/Yeh
    B7cCjQgUdaiv5rHzC5nEQM5Ou/+ilWQhMGo3d227/TqAFTgzlYOHUbmfte/A
X-ME-Proxy: <xmx:MmbbaqMAzwxRPNgHRLEjgjUVMBhnYz8PczHeqRmDpH75-ODZ6jCjUg>
    <xmx:MmbbasC4bo89lWLiPbW95RiXc0InMSsWfsi6aAOqUCee9HmroghEQQ>
    <xmx:Mmbbar4BP7kgRpH4Tq1PHC9RogPJHUfm-bA8VgW87nGb_mJB5YRCEA>
    <xmx:Mmbbam7pjrNc8oAfuoq58idq8UdEb3wvXyXo9ebO3zQCkKPgBtJGlQ>
    <xmx:MmbbatSgugJyYorhgFaWTnj44ZMCg4mwV-Sdu2x8DUzCpGQpj0fij_rM>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 826B6F80098; Fri, 23 Oct 2026 09:50:40 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Fri, 23 Oct 2026 15:50:20 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Hamza Mahfooz" <hamzamahfooz@linux.microsoft.com>,
 "Linux ACPI" <linux-acpi@vger.kernel.org>, linux-efi@vger.kernel.org
Cc: "Rafael J . Wysocki" <rafael@kernel.org>, "Len Brown" <lenb@kernel.org>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "Maciej Wieczor-Retman" <maciej.wieczor-retman@intel.com>,
 "Pawel Chmielewski" <pawel.chmielewski@intel.com>,
 acpica-devel@lists.linux.dev
Message-Id: <70ca0757-f72d-4e9b-bcdf-c5a4a0ee7124@app.fastmail.com>
In-Reply-To: <20261022211304.2285792-1-hamzamahfooz@linux.microsoft.com>
References: <20261022211304.2285792-1-hamzamahfooz@linux.microsoft.com>
Subject: Re: [PATCH 1/2] ACPI: TAD: introduce acpi_tad_rtc_available()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hello Hamza,

On Thu, 22 Oct 2026, at 23:13, Hamza Mahfooz wrote:
> Code outside of the TAD driver, such as the EFI subsystem, may need to
> know whether or not the RTC can be driven via the ACPI TAD, for example
> to avoid registering a redundant RTC.
>
> For this purpose, add a new header, include/acpi/acpi_tad.h, containing
> a define for the TAD's hardware ID, the TAD capability flags moved there
> from the driver, and a helper, acpi_tad_rtc_available(), that returns
> whether or not acpi-tad will register an RTC class device for a TAD.
>
> acpi-tad does that for a TAD that implements the Get/Set Real Time
> methods, as advertised by bit 2 of its _GCP return value, but only if
> the TAD has been enumerated as a platform device, so make the helper
> check both.
>
> Signed-off-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
> ---
>  drivers/acpi/acpi_tad.c | 15 ++-------
>  include/acpi/acpi_tad.h | 67 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 70 insertions(+), 12 deletions(-)
>  create mode 100644 include/acpi/acpi_tad.h
>
> diff --git a/drivers/acpi/acpi_tad.c b/drivers/acpi/acpi_tad.c
> index 45459a4ca..5fb978523 100644
> --- a/drivers/acpi/acpi_tad.c
> +++ b/drivers/acpi/acpi_tad.c
> @@ -33,21 +33,12 @@
>  #include <linux/rtc.h>
>  #include <linux/suspend.h>
> 
> +#include <acpi/acpi_tad.h>
> +
>  MODULE_DESCRIPTION("ACPI Time and Alarm (TAD) Device Driver");
>  MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Rafael J. Wysocki");
> 
> -/* ACPI TAD capability flags (ACPI 6.6, Section 9.17.2) */
> -#define ACPI_TAD_AC_WAKE	BIT(0)
> -#define ACPI_TAD_DC_WAKE	BIT(1)
> -#define ACPI_TAD_RT		BIT(2)
> -#define ACPI_TAD_RT_IN_MS	BIT(3)
> -#define ACPI_TAD_S4_S5__GWS	BIT(4)
> -#define ACPI_TAD_AC_S4_WAKE	BIT(5)
> -#define ACPI_TAD_AC_S5_WAKE	BIT(6)
> -#define ACPI_TAD_DC_S4_WAKE	BIT(7)
> -#define ACPI_TAD_DC_S5_WAKE	BIT(8)
> -
>  /* ACPI TAD alarm timer selection */
>  #define ACPI_TAD_AC_TIMER	(u32)0
>  #define ACPI_TAD_DC_TIMER	(u32)1
> @@ -895,7 +886,7 @@ static int acpi_tad_probe(struct platform_device *pdev)
>  }
> 
>  static const struct acpi_device_id acpi_tad_ids[] = {
> -	{"ACPI000E", 0},
> +	{ACPI_TAD_HID, 0},
>  	{}
>  };
> 
> diff --git a/include/acpi/acpi_tad.h b/include/acpi/acpi_tad.h
> new file mode 100644
> index 000000000..4825e10e9
> --- /dev/null
> +++ b/include/acpi/acpi_tad.h
> @@ -0,0 +1,67 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * ACPI Time and Alarm Device (TAD) definitions (ACPI 6.6, Section 9.17)
> + */
> +#ifndef __ACPI_TAD_H
> +#define __ACPI_TAD_H
> +
> +#include <linux/acpi.h>
> +#include <linux/bits.h>
> +#include <linux/platform_device.h>
> +#include <linux/types.h>
> +
> +#define ACPI_TAD_HID		"ACPI000E"
> +
> +/* ACPI TAD capability flags (ACPI 6.6, Section 9.17.2) */
> +#define ACPI_TAD_AC_WAKE	BIT(0)
> +#define ACPI_TAD_DC_WAKE	BIT(1)
> +#define ACPI_TAD_RT		BIT(2)
> +#define ACPI_TAD_RT_IN_MS	BIT(3)
> +#define ACPI_TAD_S4_S5__GWS	BIT(4)
> +#define ACPI_TAD_AC_S4_WAKE	BIT(5)
> +#define ACPI_TAD_AC_S5_WAKE	BIT(6)
> +#define ACPI_TAD_DC_S4_WAKE	BIT(7)
> +#define ACPI_TAD_DC_S5_WAKE	BIT(8)
> +
> +#if IS_ENABLED(CONFIG_ACPI_TAD) && IS_ENABLED(CONFIG_RTC_CLASS)
> +/**
> + * acpi_tad_rtc_available - Check if the RTC can be driven via the ACPI TAD
> + *
> + * Check if there is a TAD that the acpi-tad driver will register an RTC class
> + * device for.
> + *
> + * Context: Process context, after the ACPI namespace has been scanned.
> + *
> + * Return: %true if acpi-tad will provide an RTC, %false otherwise.
> + */
> +static inline bool acpi_tad_rtc_available(void)
> +{
> +	struct acpi_device *adev;
> +	unsigned long long caps;
> +	struct device *dev;
> +	acpi_status status;
> +

This needs a acpi_disabled check I think

> +	adev = acpi_dev_get_first_match_dev(ACPI_TAD_HID, NULL, -1);
> +	if (!adev)
> +		return false;
> +
> +	dev = bus_find_device_by_acpi_dev(&platform_bus_type, adev);
> +	if (!dev) {
> +		acpi_dev_put(adev);
> +		return false;
> +	}
> +	put_device(dev);
> +
> +	status = acpi_evaluate_integer(adev->handle, "_GCP", NULL, &caps);
> +	acpi_dev_put(adev);
> +
> +	return ACPI_SUCCESS(status) && (caps & ACPI_TAD_RT);
> +}
> +#else
> +static inline bool acpi_tad_rtc_available(void)
> +{
> +	return false;
> +}
> +#endif /* CONFIG_ACPI_TAD && CONFIG_RTC_CLASS */
> +
> +#endif /* __ACPI_TAD_H */

I get that the mutual exclusion is a bit tricky to model here, but
I'm not crazy about the general shape of this patch.

Can we make this look more like 'acpi_has_watchdog()' today, i.e.,
move this into the acpi-tad driver and export it, and call it from
the rtc-efi driver? That will make rtc-efi.ko depend on acpi-tad.ko
when both are built as modules, which is what we actually want to
happen in this case because we might get stuck without an RTC
otherwise if the module is denylisted etc.

E.g., add this to linux/acpi.h

#if IS_REACHABLE(CONFIG_ACPI_TAD)
bool acpi_has_rtc(void);
#else
static inline bool acpi_has_rtc(void) { return false; }
#endif

and decline the rtc-efi driver probe if it returns true.

We'll need to add a rule to RTC_EFI to ensure that both
drivers are available, i.e.,

depends on !ACPI || ACPI_TAD

Even nicer would be if we could unbind acpi-tad from ACPI000E:00
and bind rtc-efi instead at runtime, but that would require acpi_has_rtc()
to take into account whether anything is bound to the driver, so I'm
not sure if that is feasible.

