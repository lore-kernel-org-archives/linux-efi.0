Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B8247C106;
	Tue, 22 Sep 2026 06:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790057242; cv=none; b=Exlfud+67tp0f3wg4w1x84+fwF20pbPNoUDiG0OelEPectw1t0zHoOBwrqRMst9H98hnOPPa2WGhLuthAJK3jf4PCQ9JX5CNst9r+44XIG15xkKN5g1ysY9+lizau2KDIvlqA3ghq9zqVGuKStrU3IVci9h2zXhQhmnTcAJsHKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790057242; c=relaxed/simple;
	bh=a2HIyQTUPGerAKK4KAQO5LxPEq1Q8QzWIgJhmWSrADc=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=oCxk4qtTuZOgko2dAbmhUHJ362vRQd3BVCJrKfgnsyPRsf1lu6uFEvtb+DctVTZTJF6qx3jTbSO82B/HzRTasA43xSoRNCdbPxr/BKugHY0asMh57C6KOdTUPv6fRD6AOUOvi0cBqzqo8NzpU1UZPANTXt5QpmA/iTZuR9QONcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=Ee/wrjoq; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="Ee/wrjoq"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=aInSbDS30ifoUmnc/fUpkyf8/+8QUMzPPs2qqKBSlX8=;
	b=Ee/wrjoqSFYP8zBYhNu5w3jqjS6jExtcX3HaT7hT0uCzGwRpFupGftWHBERtLfm9OtJy/fygn
	E5/Ye4VELn6Uuw6hEUgrQ21+ZLAi6Qm/UdYR5LgSVpF2qgmQ3nnmpfl0DSKvvV1Wunacm8ENvz2
	Xo0fKsc+HiFcEG7ju9V5WpU=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hpq8p1t10z1prN4;
	Tue, 22 Sep 2026 13:56:10 +0800 (CST)
Received: from whupemk200014.china.huawei.com (unknown [7.152.185.79])
	by mail.maildlp.com (Postfix) with ESMTPS id CA75140537;
	Tue, 22 Sep 2026 14:07:13 +0800 (CST)
Received: from [10.174.179.24] (10.174.179.24) by
 whupemk200014.china.huawei.com (7.152.185.79) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 22 Sep 2026 14:07:10 +0800
Subject: Re: [PATCH v1 02/17] ACPI: amba: Switch to use
 acpi_bus_get_primary_device()
To: "Rafael J. Wysocki" <rafael@kernel.org>, Linux ACPI
	<linux-acpi@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Andy Shevchenko
	<andriy.shevchenko@linux.intel.com>, Mika Westerberg
	<mika.westerberg@linux.intel.com>, Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, <linux-efi@vger.kernel.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, "Joerg
 Roedel (AMD)" <joro@8bytes.org>, Mark Pearson <mpearson-lenovo@squebb.ca>,
	"Derek J. Clark" <derekjohn.clark@gmail.com>, Hans de Goede
	<hansg@kernel.org>, =?UTF-8?Q?Ilpo_J=c3=a4rvinen?=
	<ilpo.jarvinen@linux.intel.com>, <platform-driver-x86@vger.kernel.org>, David
 Rhodes <david.rhodes@cirrus.com>, Richard Fitzgerald
	<rf@opensource.cirrus.com>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai
	<tiwai@suse.com>, <linux-sound@vger.kernel.org>, Shenghao Ding
	<shenghao-ding@ti.com>, Kevin Lu <kevin-lu@ti.com>, Baojun Xu
	<baojun.xu@ti.com>, Sen Wang <sen@ti.com>, Vijendar Mukunda
	<Vijendar.Mukunda@amd.com>, Venkata Prasad Potturu
	<venkataprasad.potturu@amd.com>, Liam Girdwood <lgirdwood@gmail.com>, Mark
 Brown <broonie@kernel.org>, Cezary Rojewski <cezary.rojewski@intel.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>, Bard Liao
	<yung-chuan.liao@linux.intel.com>, Kai Vehmanen
	<kai.vehmanen@linux.intel.com>, Pierre-Louis Bossart
	<pierre-louis.bossart@linux.dev>, Binbin Zhou <zhoubinbin@loongson.cn>,
	Andreas Noever <andreas.noever@gmail.com>, Mika Westerberg
	<westeri@kernel.org>, Yehezkel Bernat <YehezkelShB@gmail.com>
References: <7995179.EvYhyI6sBW@rafael.j.wysocki>
 <3362405.5fSG56mABF@rafael.j.wysocki>
From: Hanjun Guo <guohanjun@huawei.com>
Message-ID: <7eeeb332-ece6-4396-5871-91ece6d6f18e@huawei.com>
Date: Tue, 22 Sep 2026 14:07:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <3362405.5fSG56mABF@rafael.j.wysocki>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 whupemk200014.china.huawei.com (7.152.185.79)

On 2026/9/22 3:46, Rafael J. Wysocki wrote:
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
> ---
>   drivers/acpi/arm64/amba.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 

Acked-by: Hanjun Guo <guohanjun@huawei.com>

Thanks
Hanjun
