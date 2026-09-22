Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC34383994;
	Tue, 22 Sep 2026 09:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790070668; cv=none; b=b0i1y0VdYm2+eGZnxMPgqAs/fSSKvArS8v2BbSI8gE+zSNQJTBMfAQQOhapCkZ28eQ6w0yfjhbea3BAL2m1WhdooR2Jm1Z8IqXV1Qq2oI6LNGYP95OVvHY+sI4cvIVEMerg4666iwn79Ch+xXlSRFdmWb9qbqcg/MU0sLLJQaQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790070668; c=relaxed/simple;
	bh=fAfhEkc1Ul2E70S7Rky+RKkm5xxP+ys1Tc+3E1/oyaw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HXaw/tTjB+qJK70wDjQWAgMIchQADjYbY3pcU8dVbTxktqtNuV6DzsNSZZ0s0Jervkgyl0CbHxnS2GUyEHJ/3e6UV+uh3L+Xq1ufJkCiZv5eXJOhmDLgnOYvsesHkxZlXANhUYf5GZY2RHZu9s0FYr0AjgSE6yNt8QD8b7BGjYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D3fHZaw7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D3fHZaw7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C61D1F000FF;
	Tue, 22 Sep 2026 09:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790070667;
	bh=bluJB05dMB2jV3Y6fJ6wm8ws1q2ZyISwGm5FF9gkYIU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=D3fHZaw7Nl8F58LiaT1FS4IcwtpHChTuSO0a7tIJqVvw8hqUBj1tygbfSikWcBzwm
	 dnv4LcQJt5S26njBaX6+xsZsJJ4bL67N/7NAWoGkM+FNwibvIeHWXNub6khFdheAx0
	 8doSkK+QfUddRYgxZ1+j8howiCXMpNN3P09QScNRy3gOE1/cLLXYD3n32bLj8U4BOn
	 V6pJM9DIjH2QJHA6gV+AbCsOwvd6HZbsfyRkbQHA+IcKRnj83Ofn/J9cEMsjsYewo9
	 bvSv1sCyUDORess5rRIjQAs7VUGR7mJzg0Rn2ny+MyTSaXnOl0fBDR8OMjW9ZVwWl0
	 TIfXjHGGp1dHg==
Date: Tue, 22 Sep 2026 10:50:57 +0100
From: Sudeep Holla <sudeep.holla@kernel.org>
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Hanjun Guo <guohanjun@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	linux-efi@vger.kernel.org, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	"Derek J. Clark" <derekjohn.clark@gmail.com>,
	Hans de Goede <hansg@kernel.org>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	platform-driver-x86@vger.kernel.org,
	David Rhodes <david.rhodes@cirrus.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
	linux-sound@vger.kernel.org, Shenghao Ding <shenghao-ding@ti.com>,
	Kevin Lu <kevin-lu@ti.com>, Baojun Xu <baojun.xu@ti.com>,
	Sen Wang <sen@ti.com>, Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Venkata Prasad Potturu <venkataprasad.potturu@amd.com>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Andreas Noever <andreas.noever@gmail.com>,
	Mika Westerberg <westeri@kernel.org>,
	Yehezkel Bernat <YehezkelShB@gmail.com>
Subject: Re: [PATCH v1 01/17] ACPI: bus: Use acpi/acpi_bus.h without
 CONFIG_ACPI
Message-ID: <20260922-quiet-heavy-lyrebird-b245ad@sudeepholla>
References: <7995179.EvYhyI6sBW@rafael.j.wysocki>
 <3717753.iIbC2pHGDl@rafael.j.wysocki>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3717753.iIbC2pHGDl@rafael.j.wysocki>

On Mon, Sep 21, 2026 at 09:45:59PM +0200, Rafael J. Wysocki wrote:
> From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
> 
> Corrently acpi/acpi_bus.h is included in linux/acpi.h only if
> CONFIG_ACPI is set, but it contains declarations that are useful
> otherwise too.
> 
> For consistency, modify linux/acpi.h to always include acpi/acpi_bus.h
> and update the latter to avoid exposing too much when CONFIG_ACPI is
> not set.
> 
> Since acpi_has_method() is called from some code build when
> CONFIG_ACPI is unset, add a stub for it to the !CONFIG_ACPI
> block in acpi/acpi_bus.h.
> 

Reviewed-by: Sudeep Holla <sudeep.holla@kernel.org>

I was planning to just pull acpi_device_hid() out so that I can get rid
of CONFIG_ACPI in [1]. This looks much more elegant. Thanks for doing it.

-- 
Regards,
Sudeep


[1] https://lore.kernel.org/all/20260915-acpi_scmi_pcc-v5-4-298579e9f359@kernel.org
