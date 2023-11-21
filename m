Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OFz/sHcy"
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E417692;
	Tue, 21 Nov 2023 08:52:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700585579; x=1732121579;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UvNKxkGclCqDou2aLi+fEApgdcqd12LLBHk/07DDGGE=;
  b=OFz/sHcy1sKf2ZC49XcMOD8UEhrOZBneWFP9rH9Yc0uzprLNX0eU8yRn
   d7BJ3+IdwGWkLOIDsSGYF4Z7mSB3LoVLwdAnXCHZRb46/cKE5aizvMaRE
   mOsYZa4XacI7rIVlMahVcfpCwyWXeuLEDA2+bhNgOzkcc700mdmd5tj69
   BxcJ2PrWJHx16wjEsM/mB9GPs7gwgRodvOp4cNnHv6u4tAiDCTOU2gIWX
   7kVt/UG0+eLpi4VV8IBSayR6jMxjqSTiAdSfncX8ST4FbN4yvS7LE82w6
   ugdGW0ZbhABwDG67Gjt1vZ72P6J1FeXBy1prUFZXcHRKhOVkbKtfi2kgl
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10901"; a="5007226"
X-IronPort-AV: E=Sophos;i="6.04,216,1695711600"; 
   d="scan'208";a="5007226"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2023 08:52:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10901"; a="760142227"
X-IronPort-AV: E=Sophos;i="6.04,216,1695711600"; 
   d="scan'208";a="760142227"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga007.jf.intel.com with ESMTP; 21 Nov 2023 08:52:53 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
	id 10D5013A; Tue, 21 Nov 2023 18:52:52 +0200 (EET)
Date: Tue, 21 Nov 2023 18:52:51 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Raag Jadav <raag.jadav@intel.com>
Cc: andriy.shevchenko@linux.intel.com, rafael@kernel.org, lenb@kernel.org,
	robert.moore@intel.com, ardb@kernel.org, will@kernel.org,
	mark.rutland@arm.com, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	acpica-devel@lists.linuxfoundation.org, linux-efi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	mallikarjunappa.sangannavar@intel.com, bala.senthil@intel.com
Subject: Re: [PATCH v2 4/6] ACPI: LPSS: use acpi_dev_uid_match() for matching
 _UID
Message-ID: <20231121165251.GS1074920@black.fi.intel.com>
References: <20231121103829.10027-1-raag.jadav@intel.com>
 <20231121103829.10027-5-raag.jadav@intel.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231121103829.10027-5-raag.jadav@intel.com>

On Tue, Nov 21, 2023 at 04:08:27PM +0530, Raag Jadav wrote:
> Now that we have _UID matching support for integer types, we can use
> acpi_dev_uid_match() for it.
> 
> Signed-off-by: Raag Jadav <raag.jadav@intel.com>

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
