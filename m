Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6666A17A586
	for <linux-efi@vger.kernel.org>; Tue, 14 Apr 2026 08:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776155846; cv=none; b=VJr7zuNIFp7Jx8Q0QdVXtewXwIG+G0qFI6BdFuSIfyuKI0NWKVvXuCRPAGbKBL2eQHjNvsnDyP1FI0VlxavHdoBFHE6ePo5I3GYVrX7VlZ5xpLdwx68Q4iNlsASZB+q5lyhmnhLc8I3y0ODJRtPYS4ici2e2emUOa4S9aF7Uqa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776155846; c=relaxed/simple;
	bh=26O8cdHKpRYtvo/zFt3CDmsve2vQRXicAvNUHovWsN0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kQ1Cbbqv4IMMDA2gZfWc2WHh2mBLLsr8AdisrCspcLZ6ThIkDYNoHxw8MjgmRnTjfjfq2x4WLFf6N+2PK+BSPNn3UnswOk5EjcemUOJwXJH/yCS3dY8iqzbJzQrSXPzJxkiRfr92vv9sXwg8eejHw0kjSd1UWfTMGB7xRqHIo5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HBQd7vPY; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HBQd7vPY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776155844; x=1807691844;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=26O8cdHKpRYtvo/zFt3CDmsve2vQRXicAvNUHovWsN0=;
  b=HBQd7vPYBVRS7IXoD404ThGLkPiOsuaPLuGLVHkqxmF1xXWi2UefhF0c
   6yGsL/OJKo/P6ZUGrHQ38it8/T2YkDLaYtxsitHFFyhuxjdXy2/Ra1JNK
   HuAPYnZ3tEvyuBFhu0V6tgTRMzXrK+m7SRVpipXuoQgGZqA/wEF1zC4fg
   9g0MWrCIo4oWw47hpaug332gQr8mp0fJuxBfR3fd9JbmsqVcvdpGlvuup
   hj8efSun9TggpBYW/E+mHQvuF8PAcyClUFAxP/hCJDQYyGFmK1HbXliTG
   O4LRIfIEI5925sjUJAj7Tcnc2dc+GkixEKw9DUNW3D5er4WTtTH76QdZ5
   w==;
X-CSE-ConnectionGUID: fyBDxIj+RqyCMIpGQn4KEQ==
X-CSE-MsgGUID: 7K/ZJeGSSVWcEnMKraAF/g==
X-IronPort-AV: E=McAfee;i="6800,10657,11758"; a="102562508"
X-IronPort-AV: E=Sophos;i="6.23,179,1770624000"; 
   d="scan'208";a="102562508"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2026 01:37:24 -0700
X-CSE-ConnectionGUID: GzmXz62ZRy62907bzdR8Rg==
X-CSE-MsgGUID: gFsjhr4BSEOlxHDq4WhHNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,179,1770624000"; 
   d="scan'208";a="234430368"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO localhost) ([10.245.245.106])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2026 01:37:23 -0700
Date: Tue, 14 Apr 2026 11:37:20 +0300
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Charlie Jenkins <thecharlesjenkins@gmail.com>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Ard Biesheuvel <ardb@kernel.org>,
	linux-riscv@lists.infradead.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH v3 3/3] riscv: fix building compressed EFI image
Message-ID: <ad38wBx9HIajbjv2@ashevche-desk.local>
References: <20260413092202.174394-1-dmantipov@yandex.ru>
 <20260413092202.174394-4-dmantipov@yandex.ru>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413092202.174394-4-dmantipov@yandex.ru>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Mon, Apr 13, 2026 at 12:22:02PM +0300, Dmitry Antipov wrote:
> When building vmlinuz.efi with CONFIG_EFI_ZBOOT enabled,
> '__lshrdi3()' is also needed to fix yet another link error:
> 
> riscv32-linux-gnu-ld: drivers/firmware/efi/libstub/lib-cmdline.stub.o: in function `__efistub_.L49':
> __efistub_cmdline.c:(.init.text+0x202): undefined reference to `__efistub___lshrdi3'
> 
> And since riscv64 can have CONFIG_EFI_ZBOOT but doesn't need
> these library routines, introduce CONFIG_EFI_ZBOOT_EXTRAS to
> manage linking of lib-ashldi3.o lib-lshrdi3.o on riscv32 only.

> Reviewed-and-tested-by: Charlie Jenkins <thecharlesjenkins@gmail.com>

At most we use Reported-and-tested (as they have at least some relationship),
but these two (and in general the combined tags are discouraged) must be split.

> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>

...

> +config EFI_ZBOOT_EXTRAS

Can we name them rather after libgcc?

Exempli gratia

config EFI_ZBOOT_USE_LIBGCC

?

> +	bool
> +	default y if RISCV && 32BIT

-- 
With Best Regards,
Andy Shevchenko


