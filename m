Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42FCA39C658;
	Mon, 27 Apr 2026 08:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777278335; cv=none; b=lq9v7HqlCvDo3y/tIWCiui5fovszQg9BSpcgB+GxuKz/RjFqdWGHOogRx8WoQkEyeJabULDqpT74N/Fw9MAvY/l80zEmt0L3tj6GeI112shLlINugJSd+lxa6By0r+QC63uHqqGhEOLOgFJqRsPZvWx0XTTMAqZTIQ5L2LTofWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777278335; c=relaxed/simple;
	bh=trwJAd2yBWHkILnEXCJ4c6+mvrmlRaN5OpdL393pF10=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mlo5zOaHvOR+6OBVm+zxr9cvoPJYDLsaGPLYXChh01Djxf+SzDGr64dmPJdXc9xHQNLGSOK+pUJb2HfGXCx4w3k0Wd/9Vp5UWAAbXX4zj0wqWRgMAa9a42f1ruHtim51QMw1CAo5aVY2YXT1gpWUF45zz5jv463DryxmplC2rPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ASYGCAmG; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ASYGCAmG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777278334; x=1808814334;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=trwJAd2yBWHkILnEXCJ4c6+mvrmlRaN5OpdL393pF10=;
  b=ASYGCAmGlTy49T3Fmp0qEeJsdBShZ9+KOE+ZIJ7mJ9LQl+cVYX9dVO8U
   7Mb8DSYvCxaIUvZ2iaFWzcfifsg/jVMAN/Jpb3Jl3uWU1f8HAmVL6pDgw
   Vtr9N/SvZAyYg3Pj/vZfXyXQIbyqh3fD68tM30+mMg5801Im5aPehjUgX
   Dm4WiCjdPWLiI/YF7y5uZNu1e6CgpGU4NkPwE5bzWpcM3EwZt/6hB9vDl
   cAco0FlsZm8uqm0wHYH3Rtc7ZKsTbbnIH6DfSH6TY3owQUIl4xhfhjRAn
   Rdkajt60B7B5eW0JE40B/P5cZxtGIgODbJnTWr99/jc2xd6+hab6DKWdm
   g==;
X-CSE-ConnectionGUID: JCblTeh+TKKMGnz4v0PHUg==
X-CSE-MsgGUID: fxjLYJe2SgqRWdxq2KevIQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11768"; a="65692782"
X-IronPort-AV: E=Sophos;i="6.23,201,1770624000"; 
   d="scan'208";a="65692782"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2026 01:25:33 -0700
X-CSE-ConnectionGUID: Rt43cVzzR7CL+Yw1ftCHMA==
X-CSE-MsgGUID: z3CqV+k1RiqvXrq9MZ8tsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,201,1770624000"; 
   d="scan'208";a="237533351"
Received: from fpallare-mobl4.ger.corp.intel.com (HELO localhost) ([10.245.244.2])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2026 01:25:31 -0700
Date: Mon, 27 Apr 2026 11:25:28 +0300
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Charlie Jenkins <thecharlesjenkins@gmail.com>,
	Alexandre Ghiti <alex@ghiti.fr>, Ard Biesheuvel <ardb@kernel.org>,
	linux-riscv@lists.infradead.org, linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/3] riscv32 library enhancements and build fixes
Message-ID: <ae8deOQyKa_j0Jb8@ashevche-desk.local>
References: <20260425185151.477442-1-dmantipov@yandex.ru>
 <20260425143631.e20246946f59925c5eb8dc22@linux-foundation.org>
 <df673a44d292bb3df498b78a8b637f880e28931f.camel@yandex.ru>
 <ae8dGrM77NuCe4S0@ashevche-desk.local>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae8dGrM77NuCe4S0@ashevche-desk.local>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Mon, Apr 27, 2026 at 11:23:59AM +0300, Andy Shevchenko wrote:
> On Mon, Apr 27, 2026 at 11:13:20AM +0300, Dmitry Antipov wrote:
> > On Sat, 2026-04-25 at 14:36 -0700, Andrew Morton wrote:
> > 
> > > I didn't upstream "lib and lib/cmdline enhancements v9" this cycle.
> > 
> > You don't have to upstream v9. Because v9 is v8 + initial RISC-V build
> > fix, which is a part of another series (this one) now. The proper sequence
> > is v8 + this series.
> > 
> > > So can we please sort through these things (and the AI review) before
> > > adding more?
> > 
> > Not sure about AI but hopefully human should realize that I'm not an
> > expert in m68k/sparc32/xtensa/csky/[your favorite arch here]. Enabling
> > and running the test on _all_ architectures where it is expected to 
> > work requires obtaining (or even building by myself) a cross-compiler,
> > setting up the kernel and QEMU, etc. I've spent a reasonable time with
> > RISC-V and ARM and hopefully set up a good starting point for 
> > m68k/sparc32/xtensa/csky/[your favorite arch here] maintainers, who are
> > free to incorporate the test into their target architecture.
> > 
> > I'm going to fix everything I consider reasonable, submit v7 and give up -
> > because without even a single reply from core RISC-V maintainers, this
> > just turns into an endless brain masturbation.
> 
> I believe it's better to issue v10 of that series + v7 of this in one go.

(I meant v8 of that as you said + v7 of this one as v10 of that one, and sorry
 for any confusion I added in the previous reply.)

-- 
With Best Regards,
Andy Shevchenko


