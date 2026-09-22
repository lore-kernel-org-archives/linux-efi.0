Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC348321457;
	Tue, 22 Sep 2026 14:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790087429; cv=none; b=cXuNdENwqQO/ExNpWsLcBPR5gG647FUI4LcKJKTVBzoDrztqEBLzDfmu3D6qqi1/+x7OJeAkILPZl35MdmCpCN+Fnkgywa8d3l0hhrmIqYarG7IWX8fOjeEqRy6BTy/wba99naSuC0L/SPGEHHFdebI30jllXrPDTtIRcxhJu4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790087429; c=relaxed/simple;
	bh=mXahkIv2RJHhzfh7U3pfRJZ3jKnnu9sUzp7Ckf7hw/I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TEzH0d8Kd3YKEsrYP034kIqlezgXuE2J7oBYEB91qqUvdgWUG7/0qXf82x/E4gRoSGO8oFVhQc89fQZRTsd/eXwTUVNhLnx7cwvWB0u8LEcpGZnxTtdyAh9BOLpCK0SbjNxBekJWxz02EJ1e/r10qeaWHWlUjQxOjf/hd2BDT2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mLa2OR3h; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mLa2OR3h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790087428; x=1821623428;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mXahkIv2RJHhzfh7U3pfRJZ3jKnnu9sUzp7Ckf7hw/I=;
  b=mLa2OR3hT75J0uGy7kqF52QX+ambp/+PbQpKNfKnXnRYndeVV1af0Zq/
   N7K9BhLEPpmvrVfG7S/6Rm4Yh6fUqzAuutqpl2rSU4HCzcTl3gRi9Uwa4
   OR69SLR66wQ6Ua5hnT1ppTwjVHcGsYMMyzjs1L+Xr0K/3zE1h8/ekLwRb
   UVAxmej9rhpvZiDBrLR0qj7zW+Psz2LHfq7hhxos+nnFg4Ubs5OkcYwJ2
   xgUZFugalXMWOW7KdcigGV/JC46uTdYIFbBWm3Trr1O56AzccsrCYraCi
   c57ZbENDCnLC4gNJUNAg+8UDdiTKnLKvqCTKV2FLViSwXljf9ixyUdPja
   w==;
X-CSE-ConnectionGUID: tThuKSKBRf+zRQNRoA934g==
X-CSE-MsgGUID: SVJCC6QHSre59xQ3y0DHFw==
X-IronPort-AV: E=McAfee;i="6800,10657,11913"; a="101282188"
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="101282188"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 07:30:21 -0700
X-CSE-ConnectionGUID: I/VCzjL/REmW6DwByGaEEg==
X-CSE-MsgGUID: m5yp+WLeSfWV6BjZ7FzIOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="299420640"
Received: from black.igk.intel.com ([10.91.253.5])
  by fmviesa002.fm.intel.com with ESMTP; 22 Sep 2026 07:30:14 -0700
Received: by black.igk.intel.com (Postfix, from userid 1001)
	id AAEC199; Tue, 22 Sep 2026 16:30:12 +0200 (CEST)
Date: Tue, 22 Sep 2026 16:30:12 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Hanjun Guo <guohanjun@huawei.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	linux-efi@vger.kernel.org, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	"Derek J. Clark" <derekjohn.clark@gmail.com>,
	Hans de Goede <hansg@kernel.org>,
	Ilpo =?utf-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>,
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
Subject: Re: [PATCH v1 09/17] thunderbolt: Switch to use
 acpi_bus_get_primary_device()
Message-ID: <20260922143012.GG106095@black.igk.intel.com>
References: <7995179.EvYhyI6sBW@rafael.j.wysocki>
 <1941270.atdPhlSkOF@rafael.j.wysocki>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1941270.atdPhlSkOF@rafael.j.wysocki>

On Mon, Sep 21, 2026 at 09:51:06PM +0200, Rafael J. Wysocki wrote:
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

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
