Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD8D4ED1BC
	for <linux-efi@vger.kernel.org>; Tue, 22 Sep 2026 09:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790070779; cv=none; b=omg6IMUQgljpeUZ2Wbu8AWFzR5fNbD05ArR49wUXJuZi3RyUtYzfboLtjGVHaqMn1oAiOzdoxL7HFbRaaCVJUC4Ik014VAc17wRNOUEzwFVWgTG3/8erZ7zhrqOsNMvHChnlf6aFObFHUbSKimpgo8hnx4GUnh/59iJ9Lo4CUew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790070779; c=relaxed/simple;
	bh=XCu96evxf20Dg31cvROXcpI/yYmId/Hxgeu4N2f5f2M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=skYKMwWolMGCYqRaAnLA5sf5MqWp6Y16ogwxadhAYxWGGB0BInKB7+ub6kLKS2Sqpcybq3anY7aa0rObDXpBrPccyB30pCTDldyn785DCt0Ys4J2ri4GLV68CFqXFHR0zT8zx0L1mhq9Cqs7+MowOuZPsLF2OQU1vQk4GzNVlxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ch6DM0hA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ch6DM0hA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7903F1F008A2
	for <linux-efi@vger.kernel.org>; Tue, 22 Sep 2026 09:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790070777;
	bh=XCu96evxf20Dg31cvROXcpI/yYmId/Hxgeu4N2f5f2M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Ch6DM0hAWaNN27ZcRB5nchnPoKUpglKze6AoelpakUm1Eal73BAMd+5rGz3RdAJaf
	 J1Quz/+Kj+BGL+lGgT9gmzGzRTtwXgBO7no73bL5xE8HxQREtk44PyzqQ/jVmhbw1Q
	 qv0g1F7BmZnTMzwj1msR6U1RXPC530DEr0Mm0wyKnxz1JNbUk9XhwKxbyiP3z1SoZg
	 T0uuvUVCXFmzuu+w6TcDFMQdjcv5NaU4e7LsKqYEB/OBkzljXsTIpZJl/I9xNxACTM
	 j5JisIIzAf/Orw+g/SnQtd1vYdOgSXKwX026rogbPOibRXsaGaiByYOxPo00KdsaKG
	 JAFYs2xmPgGCg==
Received: by mail-lr2-f12.google.com with SMTP id 38308e7fff4ca-3a2ff04155bso33960691fa.1
        for <linux-efi@vger.kernel.org>; Tue, 22 Sep 2026 02:52:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwQXhzrg21Lr9sLnekr644FSt1Z7XueNu3oZILXoSfEND+1bQ07L02tZRhPCw6eCCb9eqKmnoEvWms=@vger.kernel.org
X-Gm-Message-State: AFuF++moCqFrVzV1h+JDPoPrNNkDH6wfao9d2g2pFB+p1DYgzXkM3nyl
	UfrBqKasUKIC4LWruEvvDF2bjoKAJfcvp4FkR0s5IxeVgi65HcPi9zWSSVmAp8mvaAZLD14UUz4
	rVaOmDe34jP8QIQLdTyahyrPOXblszhk=
X-Received: by 2002:a2e:bc02:0:b0:3a3:364:f797 with SMTP id
 38308e7fff4ca-3a5fbf024acmr29953651fa.8.1790070775724; Tue, 22 Sep 2026
 02:52:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <7995179.EvYhyI6sBW@rafael.j.wysocki> <3717753.iIbC2pHGDl@rafael.j.wysocki>
 <20260922-quiet-heavy-lyrebird-b245ad@sudeepholla>
In-Reply-To: <20260922-quiet-heavy-lyrebird-b245ad@sudeepholla>
From: "Rafael J. Wysocki (Intel)" <rafael@kernel.org>
Date: Tue, 22 Sep 2026 11:51:23 +0200
X-Gmail-Original-Message-ID: <CAJZ5v0gcejDUREsJF9W5yCCU1=rBbJ1HtowzB-Y-i0rsyGvRgQ@mail.gmail.com>
X-Gm-Features: AcwNN1UEF627YybvGpJxDdUgnswJyEKtbD1EyeT6OeXpLE6q86oktnId6WHtw0o
Message-ID: <CAJZ5v0gcejDUREsJF9W5yCCU1=rBbJ1HtowzB-Y-i0rsyGvRgQ@mail.gmail.com>
Subject: Re: [PATCH v1 01/17] ACPI: bus: Use acpi/acpi_bus.h without CONFIG_ACPI
To: Sudeep Holla <sudeep.holla@kernel.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
	Mika Westerberg <mika.westerberg@linux.intel.com>, Lorenzo Pieralisi <lpieralisi@kernel.org>, 
	Hanjun Guo <guohanjun@huawei.com>, linux-arm-kernel@lists.infradead.org, 
	Ard Biesheuvel <ardb@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	"Joerg Roedel (AMD)" <joro@8bytes.org>, Mark Pearson <mpearson-lenovo@squebb.ca>, 
	"Derek J. Clark" <derekjohn.clark@gmail.com>, Hans de Goede <hansg@kernel.org>, 
	=?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, 
	platform-driver-x86@vger.kernel.org, David Rhodes <david.rhodes@cirrus.com>, 
	Richard Fitzgerald <rf@opensource.cirrus.com>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	linux-sound@vger.kernel.org, Shenghao Ding <shenghao-ding@ti.com>, 
	Kevin Lu <kevin-lu@ti.com>, Baojun Xu <baojun.xu@ti.com>, Sen Wang <sen@ti.com>, 
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>, 
	Venkata Prasad Potturu <venkataprasad.potturu@amd.com>, Liam Girdwood <lgirdwood@gmail.com>, 
	Mark Brown <broonie@kernel.org>, Cezary Rojewski <cezary.rojewski@intel.com>, 
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>, 
	Bard Liao <yung-chuan.liao@linux.intel.com>, 
	Kai Vehmanen <kai.vehmanen@linux.intel.com>, 
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>, Binbin Zhou <zhoubinbin@loongson.cn>, 
	Andreas Noever <andreas.noever@gmail.com>, Mika Westerberg <westeri@kernel.org>, 
	Yehezkel Bernat <YehezkelShB@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 22, 2026 at 11:51=E2=80=AFAM Sudeep Holla <sudeep.holla@kernel.=
org> wrote:
>
> On Mon, Sep 21, 2026 at 09:45:59PM +0200, Rafael J. Wysocki wrote:
> > From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
> >
> > Corrently acpi/acpi_bus.h is included in linux/acpi.h only if
> > CONFIG_ACPI is set, but it contains declarations that are useful
> > otherwise too.
> >
> > For consistency, modify linux/acpi.h to always include acpi/acpi_bus.h
> > and update the latter to avoid exposing too much when CONFIG_ACPI is
> > not set.
> >
> > Since acpi_has_method() is called from some code build when
> > CONFIG_ACPI is unset, add a stub for it to the !CONFIG_ACPI
> > block in acpi/acpi_bus.h.
> >
>
> Reviewed-by: Sudeep Holla <sudeep.holla@kernel.org>
>
> I was planning to just pull acpi_device_hid() out so that I can get rid
> of CONFIG_ACPI in [1]. This looks much more elegant. Thanks for doing it.

Anytime, and thank you!

>
>
> [1] https://lore.kernel.org/all/20260915-acpi_scmi_pcc-v5-4-298579e9f359@=
kernel.org
