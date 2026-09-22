Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078BD5632A0;
	Tue, 22 Sep 2026 17:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790096406; cv=none; b=p9vA3EShy+V7F6FIK0xaOwt8HQUjzpILMpqZSDahwfw030yJVc+6aLVKWJt/JQlN0F8apYa7YjQZ+mROxzwRhfN9d/U+WKc76CyTo6VSAPY/gfUY+ODCl3tWDuTjmhzPxBKnTF1kvUd964ob7czc4KEkoY7U4lwC3uWEFSgWMok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790096406; c=relaxed/simple;
	bh=BQAsf3GwicofIOUhI7z5DCoHRx49TvH2Grc+f+IVVAA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kl+qVl3gPdtfufaohgshPm3KYyU4sUGZ+pXqiCxUnVytg4hU9NbnilNCvOPdP23cffP8JhJIJYmOugC+Q6pN9Yks49AzlxJwtRIBStjTbQi/t5fHdQfODV7hbQ9hwAMC2YJ+TcBrMNThpwKRc4rRZrmB0XQCsZ8a2pHorgHrr8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jGHNR++N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jGHNR++N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6BE91F000FF;
	Tue, 22 Sep 2026 16:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790096404;
	bh=e1wJMpHGmgVSXq/apVaQv39c3+7htkTrGoZWFd8MsVI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jGHNR++NPSVXNuPYrmF1QmiPjnD/wNjMRKlPDurqcKffL2GkIhAUP4ocDQVyfo8zB
	 GNlRK91S/zHEleP3JLgn18qTRbR1BJTvYlO8Aql02ef4twDUU9DHaorsU5UvJLfma1
	 qnbw0qOfKVc9phA+PRoRFN+z7RA2o8RqwnaQRVo/tjp0+WwX59SdfdtL5aq/+cmfoI
	 Qe5NRKVHXie9bnKJIDMmncQ2ZeALgipiKShVTcW62KLl4q/jatWuO42BVXUN5fzNn4
	 4nx/2q8fkO2ez/+5dkJaxy1NaPZ3SyuY0PwQ8xDdviIzhn9z0UJVbv+MaEsT+3reWx
	 X3h2vvNu4Afvg==
Message-ID: <e6d30881-c590-43db-8912-dbf03c459032@kernel.org>
Date: Tue, 22 Sep 2026 18:59:55 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 08/17] platform/x86: x86-android-tablets: Use
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
 <3912360.MHq7AAxBmi@rafael.j.wysocki>
From: Hans de Goede <hansg@kernel.org>
Content-Language: en-US, nl
In-Reply-To: <3912360.MHq7AAxBmi@rafael.j.wysocki>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 21-Sep-26 21:50, Rafael J. Wysocki wrote:
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
>  drivers/platform/x86/x86-android-tablets/core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/platform/x86/x86-android-tablets/core.c b/drivers/platform/x86/x86-android-tablets/core.c
> index cfff7f5eac5d..2c262f117235 100644
> --- a/drivers/platform/x86/x86-android-tablets/core.c
> +++ b/drivers/platform/x86/x86-android-tablets/core.c
> @@ -390,7 +390,6 @@ static int gpio_secondary_fwnode_init(struct device *parent,
>  {
>  	const struct software_node *const *swnode;
>  	struct fwnode_handle *fwnode;
> -	struct device *phys_dev;
>  	int ret;
>  
>  	if (!node_group)
> @@ -418,7 +417,8 @@ static int gpio_secondary_fwnode_init(struct device *parent,
>  		if (WARN_ON(!fwnode))
>  			return -ENOENT;
>  
> -		phys_dev = acpi_get_first_physical_node(to_acpi_device(dev));
> +		struct device *phys_dev __free(put_device) =
> +				acpi_bus_get_primary_device(to_acpi_device(dev));
>  		if (!phys_dev)
>  			return dev_err_probe(parent, -ENODEV,
>  					     "No physical device for ACPI GPIO dev: %pfwP\n",

