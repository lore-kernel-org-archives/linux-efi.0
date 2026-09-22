Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34748568528;
	Tue, 22 Sep 2026 16:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790096297; cv=none; b=GHhOswkjVo46EVcvklK+KSpv7MD6LKjlYtbPgEh3cClqns9hDeo0h8KicTj07xORvusbmuLA13HLPbZaJaXHuMNFWorq61Q87b2fdUC3MErvhOyshJ9CvU6aFOrJkFXYNrwP1H6u40PMET/tX1Kx5H2xR00rzwILOrRkpjn+Hls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790096297; c=relaxed/simple;
	bh=zfHn3IKTvEMOORQRqd4yx+3GyKbK68dAKWKSC0SG3Rg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bF0Bw/kRaoN9sEPVbHwXIpOEb9Lk242B/mSAuIj9+Tiw5bKi8p0nMbnO7a6BUQHBc4l90CMl0pbwl/e/3HfHz8e1zARCO1dAOqEP7ha8n8V94Fu2Wx6kalHz3YmbvjmPnyEh5Q5cg8g4JYaOzz0njqFIpmhZpekkpSFyDETdTOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ejyK/swq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ejyK/swq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 332291F000FF;
	Tue, 22 Sep 2026 16:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790096295;
	bh=rXqAA6eqv8sionh8O8cNg0OP7IaRZQLQ2PAG3DzIVPo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ejyK/swq7jv9XXaZWQ1mvyu/Zpr06HFuYW+qYPcUuysGTx6mEJkqZgljnmzo1Jfev
	 Jf1GrFLudHhzyPlRyO4eTp8ColKO8GQLlcq2qTHwpj+EXQQ924ZyYAZc88n4ryC9FI
	 lL7Nzort/dgzd9L6RElfj0cwGARCylKiRgHyOZ5or+Ii3nu/C1dq2MR7QBWRZYR0iQ
	 ZYYFeCOObOJrORWRL4d/24Vb4guQ8oHULiOJjkb4YtjfgFD2gselJXHkdiOoMKcxWo
	 ExRNUznCF9dkJvM7v6xIyniRkt0P3SqylsC/fWryuWnvVUme+IHRgz0KGf8FIgFXwo
	 73QQK+vK/XAPw==
Message-ID: <ff6ace62-1cd3-4656-a3d7-5c0c78c8a218@kernel.org>
Date: Tue, 22 Sep 2026 18:58:06 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 06/17] platform/x86: serdev_helpers: Switch to use
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
 <2720286.Lt9SDvczpP@rafael.j.wysocki>
From: Hans de Goede <hansg@kernel.org>
Content-Language: en-US, nl
In-Reply-To: <2720286.Lt9SDvczpP@rafael.j.wysocki>
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
>  drivers/platform/x86/serdev_helpers.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/platform/x86/serdev_helpers.h b/drivers/platform/x86/serdev_helpers.h
> index 57eac75805e2..20267e1941f1 100644
> --- a/drivers/platform/x86/serdev_helpers.h
> +++ b/drivers/platform/x86/serdev_helpers.h
> @@ -74,8 +74,7 @@ get_serdev_controller(const char *serial_ctrl_hid,
>  		return ERR_PTR(-ENODEV);
>  	}
>  
> -	/* get_first_physical_node() returns a weak ref */
> -	parent = get_device(acpi_get_first_physical_node(adev));
> +	parent = acpi_bus_get_primary_device(adev);
>  	acpi_dev_put(adev);
>  	if (!parent) {
>  		pr_err("error could not get %s/%s serial-ctrl physical node\n",

