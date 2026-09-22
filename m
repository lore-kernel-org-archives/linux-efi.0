Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D64356E06A;
	Tue, 22 Sep 2026 16:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790096328; cv=none; b=Of/FfWLSC3ELRZR84z9rGy6xY5q6Z5aJBhdilzclIIIQGsIppJNKwXoAEJSOYlALTdV9iokosRmPdhdKRz3Zf6PCNC7gwSfq9Aa5JeO75Hhwy6mGbp0N2Rqi6VvnQXuABl52rxd2hX71VIir8qo7rrZSI3B3UDJZYJB3PW0V7bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790096328; c=relaxed/simple;
	bh=W0bpdJdipY3dwZrmHPZft9gTEfJzIob4+lFgQo2hkiA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k70/VwXNhg2fli9CfV6KI5Q1yyFuJERlD8HGUWmAn+ezlFKVyQNSdJFXdP93Y+1fpTYPooAfglfcrhq3nJwfT/f+G8kUv7TQfGjYPV23vvnd0QQvhru/s+EjucHOEnkaky/kcdlTYPQeC8/F8TKV3QM+HewitHWX1pCNxs/WIS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AlM6wpc4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AlM6wpc4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1042C1F000FF;
	Tue, 22 Sep 2026 16:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790096326;
	bh=n8IQx8HLgG7ebBAe/MKRbXmMwPgQ4SOKyooVL9gjoTY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=AlM6wpc4js5vFABGkGcyFnVGuW7JUSWSMcn5tX+KF3hYbnbmUzlR/hkoAP0xqVDGB
	 Fq7O+uTF1XknxSNQW/Pb0pjIFaxFgjyewcdquFs5hTAkyMMhCvLNy3UWwfDZFiGvCS
	 8CuT3tMgnLN9jafAy+9pWsSL1tOdcGXdIeffYG8qmdCMhpWvYSvibpP7bYDGfMViQr
	 TYIRO3PIvxMMRKgSa/52phLibd1XTQx+W26uSTFqG/+cpfHnPQYL2mfalk6YsAoj8Z
	 9NKOaTzjFtc1UQ5x5eJdYDcwo9yeO+uZhXztWzf8MvTef3h9E/q3YocCsyOkliB3rf
	 PRrG3GaynK8SQ==
Message-ID: <e95c2aaf-8c90-45bc-8e1b-841d180788da@kernel.org>
Date: Tue, 22 Sep 2026 18:58:37 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 07/17] platform/x86: apple-gmux: Switch to use
 acpi_bus_get_primary_device()
To: "Rafael J. Wysocki" <rafael@kernel.org>,
 Linux ACPI <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Mika Westerberg <mika.westerberg@linux.intel.com>,
 Lorenzo Pieralisi <lpieralisi@kernel.org>, Hanjun Guo
 <guohanjun@huawei.com>, Sudeep Holla <sudeep.holla@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 "Joerg Roedel (AMD)" <joro@8bytes.org>,
 Mark Pearson <mpearson-lenovo@squebb.ca>,
 "Derek J. Clark" <derekjohn.clark@gmail.com>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 platform-driver-x86@vger.kernel.org, David Rhodes <david.rhodes@cirrus.com>,
 Richard Fitzgerald <rf@opensource.cirrus.com>,
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
 linux-sound@vger.kernel.org, Shenghao Ding <shenghao-ding@ti.com>,
 Kevin Lu <kevin-lu@ti.com>, Baojun Xu <baojun.xu@ti.com>,
 Sen Wang <sen@ti.com>, Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
 Venkata Prasad Potturu <venkataprasad.potturu@amd.com>,
 Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
 Cezary Rojewski <cezary.rojewski@intel.com>,
 Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
 Bard Liao <yung-chuan.liao@linux.intel.com>,
 Kai Vehmanen <kai.vehmanen@linux.intel.com>,
 Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
 Binbin Zhou <zhoubinbin@loongson.cn>,
 Andreas Noever <andreas.noever@gmail.com>,
 Mika Westerberg <westeri@kernel.org>, Yehezkel Bernat <YehezkelShB@gmail.com>
References: <7995179.EvYhyI6sBW@rafael.j.wysocki>
 <2287208.Mh6RI2rZIc@rafael.j.wysocki>
From: Hans de Goede <hansg@kernel.org>
Content-Language: en-US, nl
In-Reply-To: <2287208.Mh6RI2rZIc@rafael.j.wysocki>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 21-Sep-26 21:49, Rafael J. Wysocki wrote:
> From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
> 
> Replace acpi_get_first_physical_node() that is slated for removal
> with acpi_bus_get_primary_device() that takes a reference to the
> device it is about to return.
> 
> This addresses a potential use-after-free that may occur if the
> device returned by acpi_get_first_physical_node() is removed right
> after dropping its ACPI companion's physical_node_lock in that
> function.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Thanks, patch looks good to me:

Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>

Regards,

Hans

> ---
>  include/linux/apple-gmux.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/apple-gmux.h b/include/linux/apple-gmux.h
> index 206d97ffda79..d7939c3a08fd 100644
> --- a/include/linux/apple-gmux.h
> +++ b/include/linux/apple-gmux.h
> @@ -109,7 +109,7 @@ static inline bool apple_gmux_detect(struct pnp_dev *pnp_dev, enum apple_gmux_ty
>  		if (!adev)
>  			return false;
>  
> -		dev = get_device(acpi_get_first_physical_node(adev));
> +		dev = acpi_bus_get_primary_device(adev);
>  		acpi_dev_put(adev);
>  		if (!dev)
>  			return false;

