Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 200D13E558A;
	Mon, 21 Sep 2026 20:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790020818; cv=none; b=ut+zO60xYqIXycqsXm9kwMiuN2XNFgMOgPrt0rJTshxJOkWb3lepi5IimFTJgahz8cTUHc3paODbUO3YYhuorzHQt/L03EXG9vrQjHAci+6bS4UQ7NZGe5GD1gJsj7DHam6WvOEszF7cVGoce9atfIaj8q1mOxGmRhFvewcYQkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790020818; c=relaxed/simple;
	bh=xlB/k5XyrZgrmyKAbDTAdkJqYhWeGU/L5O1J3vJ3YAc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Zhp1zAueEveAd2DckI8wjDcZlFXWi4K40gOUxuDZvEAA844gwRdNXavohCa7jgc27pgeEgapcBGZ719KImP+Btz0atwF0NbmfjLKndAYGlBCMBefbUgh7EaHAfwt8esn8SbdGuGD2ggqPjZdUuvKqAeGjzZgXPJU4TN6I/bvw8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DI+0v/TK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DI+0v/TK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4DE01F00893;
	Mon, 21 Sep 2026 20:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790020814;
	bh=hKybdObHK5GCZb1lSd/qvmfz9G3Qc2nU5yiHgWTrhLs=;
	h=From:To:Cc:Subject:Date;
	b=DI+0v/TK1t2katgmeQl+N0Q5v0Grbjw0veGw7K2Joex7Z6rdPJ/A1rlHJZsRCHtt7
	 bY9/Ie5SCBRvAYVN3tq/+sf4M4m7B2EHWRP9psxdda7JBvRxU7JrCTX7S6jId+Tq+g
	 QCLQiKNi+GGd7OOI21Wh4r61eqGyCzS66AIpLhOnyjp2yDpk5M+LJx8uf2o/8Rxlg7
	 4by3Q+O/cBWB5XeUVDxom2YOm/WKU0aHwSB7KaTF8+q0/bZDuAZzU6Djf+pOTMqhbD
	 hl/iQSf0gaSnB33bY3xxYfuMz+LytqSUXYGKWUZBMFASDLhpM1wHflH1W4id4/0p/f
	 ta/+45s4mRLQQ==
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linux ACPI <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Mika Westerberg <mika.westerberg@linux.intel.com>,
 Lorenzo Pieralisi <lpieralisi@kernel.org>, Hanjun Guo <guohanjun@huawei.com>,
 Sudeep Holla <sudeep.holla@kernel.org>, linux-arm-kernel@lists.infradead.org,
 Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 "Joerg Roedel (AMD)" <joro@8bytes.org>,
 Mark Pearson <mpearson-lenovo@squebb.ca>,
 "Derek J. Clark" <derekjohn.clark@gmail.com>,
 Hans de Goede <hansg@kernel.org>,
 Ilpo =?UTF-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>,
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
Subject:
 [PATCH v1 00/17] ACPI: Replace acpi_get_first_physical_node() with
 acpi_bus_get_primary_device()
Date: Mon, 21 Sep 2026 21:45:17 +0200
Message-ID: <7995179.EvYhyI6sBW@rafael.j.wysocki>
Organization: Linux Kernel Development - Intel
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

Hi All,

This series replaces acpi_get_first_physical_node(), which is inherently racy
and therefore generally unsafe to use, with acpi_bus_get_primary_device(), that
doesn't have this problem, everywhere in the code.

The first preparatory patch is needed because acpi_bus_get_primary_device() is
defined in acpi/acpi_bus.h and the subsequent patches depend on it.  For this
reason, I will appreciate ACKs from maintainers of the code updated by the
patches.

Thanks!



