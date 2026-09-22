Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C924DBD8E;
	Tue, 22 Sep 2026 09:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790070795; cv=none; b=a6wNHYNIItISWxbUARPk+urPqIsm0+zzduZ/DHC1cZQzcV6Z8Z/VgTRVzzlPXBBsTA7FlmDa2676pMx2nSeIlS2NWxLueMHKrddTSkaohaoXf0tVOuRV7syojp85W7XvDC2DO4OebDcxCzcp+OT8ltqpi/1rBmG2YX2iEgNZcOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790070795; c=relaxed/simple;
	bh=+SFHyW7yArv+zaLrtrZAzBsSf3zQqMs6k2PxG/T5l3o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MCYLZ7Ae7cOWgxHUKENcpYAdQlicTXiY6sNDxZ0/tsBnGi6I8FL9PhXgIfDc4uHq9UMiaohMUV4DHDd5plFdt2eOq3MZRqHia4FBSSacEzCW5QOWwhEC20B5KUv9a5gXCdyFtXATLw/x7rHy7MHye81h2NcRJxYeGW2WdMYKHCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ioEiBwWx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ioEiBwWx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC531F00893;
	Tue, 22 Sep 2026 09:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790070794;
	bh=P59QfpE3GHnfbSvYljbknL7udhz9I4QHMk1BVsCN34E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ioEiBwWxtFOnnrc8m3NVjge5vzs2I9+zc1FxbUKPw5eNUYjDniudO7GcHVIuEsxsq
	 iP84J/MCS6vHp6wC0dRnjCto3SgkwS7KFt3pgrbYhjIXyFhrMJZm2DKeQgoqFCNR/Q
	 2QEpkHRHsd3PSwJoumlRB/mk5l1zd4YoJS7nIJMnnxhEOYIbBaQWdUfI2FyQBJy0uT
	 OOe1ikKjLGjhCrq8NCgk2NEKK29+o5gKmExnrQrWIUKYxl8vFRsR1MNqO9A2F4Eu4W
	 PP/Gqyfj63d+QdcV9LCyn0m3YnIvjkgUxjzEe9uXwAnn+IGh/n0wGwutOpPgOw3bWy
	 JANualluSkX9A==
Date: Tue, 22 Sep 2026 10:53:05 +0100
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
Subject: Re: [PATCH v1 17/17] ACPI: bus: Drop acpi_get_first_physical_node()
Message-ID: <20260922-inscrutable-mussel-of-popularity-ca2afd@sudeepholla>
References: <7995179.EvYhyI6sBW@rafael.j.wysocki>
 <9732391.rMLUfLXkoz@rafael.j.wysocki>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9732391.rMLUfLXkoz@rafael.j.wysocki>

On Mon, Sep 21, 2026 at 09:56:41PM +0200, Rafael J. Wysocki wrote:
> From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
> 
> Fold acpi_get_first_physical_node() into acpi_primary_dev_companion()
> that is its only remaining caller and drop its signature from the
> header file.
> 
> No intentional functional impact.
> 

Reviewed-by: Sudeep Holla <sudeep.holla@kernel.org>

-- 
Regards,
Sudeep
