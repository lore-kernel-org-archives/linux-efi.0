Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9524D2EE0;
	Tue, 22 Sep 2026 09:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790070731; cv=none; b=sApib2lcI2gPwK6t8B00V2EzX5lgC2HqFQZSWIq5EJxDpQx48/ejC+ErjkThrzUT+hl4CWvm5OFBV61dJVWg69VflALnGsysWrj6m14d7eg/Ef6OrDcn2bt6gvBLU5Fys9AOSupQOBnUu95Do/SHMuuJW4HqYQ1kT9LuNxYjEcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790070731; c=relaxed/simple;
	bh=zor2ROdLd0rMo1FQEhXOx9r0zbUpL74fNqfExstZnjw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OQUnzwuXPjmlt4JVnWja0gTjMHAO5d+d3exg/008UHSZJ+iUR8nsL/XNs3VoLo17AObfWfEqaS70q2oOh6P2o5TDUC9LMBnfolKLZyjJml87PvJyisoLGzJdTyYKbYLln5nbXo1p2lPx1NnU4ycbcc0gaft8Iv5hAn/NLzUOa6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LMT8gm1A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LMT8gm1A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C923A1F00893;
	Tue, 22 Sep 2026 09:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790070721;
	bh=XsLswjZySdqIFqF2ilbCxdY4qgyZ6CXrVVKDQsk1y4g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LMT8gm1AoEFT7gGBv+UHvLcfX07spj9zLtsGDHX0ve90f6yq0SZFLZPQpvEq8/N4m
	 MI6iTv11VPAo1J4kauwU+6zLxtDIwXUC964L4C7g1YLJq8FrypYsPFmf/vUt/mVbiP
	 MnY6xODa9WZzv2IDSSTqS+KAbdW0T+BfhD8qMxdeGpLgGm79CWChCpiZXc+Kje8zYk
	 A0xGKSz8y/wbQdh3N8uwV8KtmAdX/bn+y57m6j7PtFH0CVrZsXlsUCIv38/XsRX0ff
	 mge0QwP7f3UNAjRSJaRSYzeyHBU9CEx6vTG2iVg+TMffw61IvtKlPc89c/3inA5WLE
	 9GcGsuZ/Emhhg==
Date: Tue, 22 Sep 2026 10:51:52 +0100
From: Sudeep Holla <sudeep.holla@kernel.org>
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
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
Subject: Re: [PATCH v1 02/17] ACPI: amba: Switch to use
 acpi_bus_get_primary_device()
Message-ID: <20260922-tiny-pompous-stork-30beeb@sudeepholla>
References: <7995179.EvYhyI6sBW@rafael.j.wysocki>
 <3362405.5fSG56mABF@rafael.j.wysocki>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3362405.5fSG56mABF@rafael.j.wysocki>

On Mon, Sep 21, 2026 at 09:46:37PM +0200, Rafael J. Wysocki wrote:
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

Reviewed-by: Sudeep Holla <sudeep.holla@kernel.org>

-- 
Regards,
Sudeep
