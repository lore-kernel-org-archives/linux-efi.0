Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523E755D88C;
	Tue, 22 Sep 2026 15:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790091093; cv=none; b=SXQbW2xkRPf2JDpoDKL5N0MJu/VPU7Vn4b0iM5/93AsSBcKBAY7NLV/glhbK/laZmW5c2ya6flD0yShgE+oAjScoNo36/DuLB0EMNTkxVILA4aHeh+U/i3icHpl+p9+NbgfxrEVgozYqcmVGBK+Lvk1WQ+sGfvFJhlz9Rt2FdSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790091093; c=relaxed/simple;
	bh=RHuceneBZvdn9Z0FAJtWFVd90GzxTOjGrRzHxF/dovA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=saVcg/Uq4gRP0Dkmsj0m+hOzon/k3y9iG389W0WStiuYZULwR6MWSCJklaI1qFualO3oS2S5WOuk4ihnNXaWkjfbZWfAG8kyKvLxdHJeHNa/nTxZ6vvpdKu0lTuqmhzBL2k8VSqPvmgO9CNUl+7pMMcOtlJ3K++l7yjenvsSPng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XV6eXBJ9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XV6eXBJ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D291F000FF;
	Tue, 22 Sep 2026 15:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790091092;
	bh=RnUbX0O3XIbl3s6CjnpHoRa+mFzwtuOYYOW3lsScYJo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XV6eXBJ9wZazvZIQBB2YkJk4/WbhDvnLSmhZsy7zJMOblJ24O1UZ6mP+I47TDv/P2
	 fG3E7NpVbcjNfQQJy8ON02b5puSY9D74uS/zQUp74mzobyRuL8Qz3tKcX7vORs7hgQ
	 /qrZsgpoyZD3xP2qf63pkxyCb3iyt2TT36q4NQuyyxr2BI2x5FTslegufvih8hLLpz
	 JkSfZ1DK3ViOJFlQwmDdwUQMl+RlyTiMhSEWz7SbOUqYgbCbdfD/aLc4OT/GF9uTCP
	 SaY7idbMIv1eqZOrTIJCO4LS8mwvyUqbK05982Yvj0PXeVzhQvo4/a5y7M5Abummoa
	 UP7KYbXUlSqmA==
Message-ID: <2a882f5d-fb85-45a8-9405-f9a506b7c509@kernel.org>
Date: Tue, 22 Sep 2026 17:31:22 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 05/17] platform/x86: yogabook: Switch to use
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
 <1973238.CQOukoFCf9@rafael.j.wysocki>
From: Hans de Goede <hansg@kernel.org>
Content-Language: en-US, nl
In-Reply-To: <1973238.CQOukoFCf9@rafael.j.wysocki>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 21-Sep-26 21:48, Rafael J. Wysocki wrote:
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
>  drivers/platform/x86/lenovo/yogabook.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/platform/x86/lenovo/yogabook.c b/drivers/platform/x86/lenovo/yogabook.c
> index 1a4b2ab1f35d..8a91d440724b 100644
> --- a/drivers/platform/x86/lenovo/yogabook.c
> +++ b/drivers/platform/x86/lenovo/yogabook.c
> @@ -353,13 +353,13 @@ static int yogabook_wmi_probe(struct wmi_device *wdev, const void *context)
>  		goto error_put_devs;
>  	}
>  
> -	data->kbd_dev = get_device(acpi_get_first_physical_node(data->kbd_adev));
> +	data->kbd_dev = acpi_bus_get_primary_device(data->kbd_adev);
>  	if (!data->kbd_dev || !data->kbd_dev->driver) {
>  		r = -EPROBE_DEFER;
>  		goto error_put_devs;
>  	}
>  
> -	data->dig_dev = get_device(acpi_get_first_physical_node(data->dig_adev));
> +	data->dig_dev = acpi_bus_get_primary_device(data->dig_adev);
>  	if (!data->dig_dev || !data->dig_dev->driver) {
>  		r = -EPROBE_DEFER;
>  		goto error_put_devs;

