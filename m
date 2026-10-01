Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31004E4C30;
	Thu,  1 Oct 2026 18:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790878958; cv=none; b=HiqZzI477jk4G1ByLu+lC+Wx+sUyhr7E0kiL4VQyKuh6RGkHUJ6x4t31rE5BmArYruAeIpNgCcznAPudfaaLxu8ehO7FCJHNLaeHWJjy9Myp5qI9yQLyJYfmT7dqdcPddJKgqd0TTowyinDdidBMJfHwlam3/hga2Z4lqP8xOZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790878958; c=relaxed/simple;
	bh=Y94ugADCjd5S4s4n0Tg88CMgCId4+Gj9yqv40QY1BOI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TuG6/e2kn1ClrvuqVZ/fMkZXAsDSIL5TzG42Fp4CPRvXYMSfx7asWrgFKr2psChnE+akPTvpsJ0e3w+VyTTmUluJn7V09rudPDbrkKtmcVh2adgTPRh1aAg+2C39jlOE0dA9oY8LaiWOwX7zY7ffZU/5ZT3eIJtgyTKy/XEYFzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aRC3uOe/; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aRC3uOe/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790878952; x=1822414952;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Y94ugADCjd5S4s4n0Tg88CMgCId4+Gj9yqv40QY1BOI=;
  b=aRC3uOe/R8CtPtEa3mEnIy9j1FhMlbb3DsC4klRU/LDOCFa1loKp7EsO
   8hnpjC1gcQXIyjR0jqKK1arOzi2f5r9rMB7VxzJ8SzLcJk76MIiqBNap/
   GBMZn2u+vQcEweepe0mBBHE2UiAvcwmxp/zu1/CrnFyXvP6YL15DzAvzg
   NyXAg8WJr6LJTholLPq/Hvm1Ej3YFfDwR9sgwfc2rPsOv/LCEp6vYmFY6
   Y+vexe0P9f4r+ZIsp0r2DHPLPCo2Ut9CrFidMPxu0d4Fyldel5esrZOGR
   brR/8HwnzFfoMRwXO6YyT0rtLpM4Zjj7hbx/kYO0ZI5TxFewS7BZPVi0n
   g==;
X-CSE-ConnectionGUID: fWfy4Qt5RpKA/wTZt5dm/w==
X-CSE-MsgGUID: dJc8kIsdR2GNqqsRjjCRaQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11922"; a="90704757"
X-IronPort-AV: E=Sophos;i="6.27,135,1787036400"; 
   d="scan'208";a="90704757"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 11:22:20 -0700
X-CSE-ConnectionGUID: L5g60cWbRa2/8tjijxT4Ww==
X-CSE-MsgGUID: StWR2umvRNqgnHBGcd2t7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,135,1787036400"; 
   d="scan'208";a="302298846"
Received: from abityuts-desk1.ger.corp.intel.com (HELO localhost) ([10.245.244.27])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 11:22:14 -0700
Date: Thu, 1 Oct 2026 21:22:12 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	linux-efi@vger.kernel.org, Will Deacon <will@kernel.org>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
	Robin Murphy <robin.murphy@arm.com>, iommu@lists.linux.dev,
	David Rhodes <david.rhodes@cirrus.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	linux-sound@vger.kernel.org, patches@opensource.cirrus.com,
	Shenghao Ding <shenghao-ding@ti.com>, Kevin Lu <kevin-lu@ti.com>,
	Baojun Xu <baojun.xu@ti.com>, Sen Wang <sen@ti.com>
Subject: Re: [PATCH v2 0/5] ACPI: Replace acpi_get_first_physical_node() with
 acpi_bus_get_primary_device()
Message-ID: <ar6k1MMzNDTbdLvO@ashevche-desk.local>
References: <4766532.LvFx2qVVIh@rafael.j.wysocki>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4766532.LvFx2qVVIh@rafael.j.wysocki>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Wed, Sep 30, 2026 at 08:30:47PM +0200, Rafael J. Wysocki wrote:
> Hi All,
> 
> This is a partial resend of
> 
> https://lore.kernel.org/linux-acpi/7995179.EvYhyI6sBW@rafael.j.wysocki/
> 
> that only includes patches that have not been ACKed and the last one that
> depends on all of the others.  It is based on linux-next.
> 
> This series replaces acpi_get_first_physical_node(), which is inherently racy
> and therefore generally unsafe to use, with acpi_bus_get_primary_device(), that
> doesn't have this problem, everywhere in the code.
> 
> I will appreciate ACKs from maintainers of the code updated by the patches, so
> I can pick them up and get rid of the problematic interface in one go.

The whole lot is straightforward,
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

-- 
With Best Regards,
Andy Shevchenko


