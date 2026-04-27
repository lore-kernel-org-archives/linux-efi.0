Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774E2371CF4;
	Mon, 27 Apr 2026 08:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777278240; cv=none; b=tdVFDmOPNjUBdcPWWmjjAalQz78XvGfy80VfWUwwgulyrYmBj2SSZtvJvvfqEegoaPx9c51IN0pFnJRWGhpGJvHIz+1zEZSfGXDDpnE4CQ/4Y71I6uE12PAWnlwIcFbIIji9+KhEodvA7t32f39lugwNTBT15rk7EEnz0lqXqRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777278240; c=relaxed/simple;
	bh=HaP7CTCCtZ1ZOWjXU2hqUefh4vpr8nlvgt8UGZh9RVc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=utK+d/d6066YVx66hZGbj1LF2H0sgFJjdmJ2SjyOyfd4Q7B18Qi7vpF8Qtoppoa754krRcg3YwGNojVKQrN5eqnrM19Ur/CVVSKpvnp2LRmQAchmEnegXLtdKiEqyDA/GsqgDFCi3D0wWwlrfcNwAxDnxCW/TKaX07fzjAPPlsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dPUecitI; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dPUecitI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777278239; x=1808814239;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HaP7CTCCtZ1ZOWjXU2hqUefh4vpr8nlvgt8UGZh9RVc=;
  b=dPUecitIVboCNBUHc+mF7tDBGHki+nXHOSFSZ1j5Evpe+8f0+K7cnnEe
   tXI5HiF+vOUixME1hKAVdquR7/f5Q/ViHKpGQx4zqojNdqMUb4mmk1MqO
   f6NmAy4RFtAfLLpXv+XaPvPHaeLzlQjoU/1GKsD2d7oght11jCaNKhvZu
   ani8j1gy3R44GVeMqTWT8gphesqsUTYdecFsYaySiIo+z1WsqvUaAO+Ik
   xSP1No8LhWf2i9MqbTZlgH634e9HATY4/y6e1NXA6AS1yefKBKodKLySZ
   GC8XDbM8dh57KcgXWs8fRC+AqT06TdpRNzU9wLcoQbefqx6ZQD1Eq22ab
   w==;
X-CSE-ConnectionGUID: bdkAI6dVTkC8NxqzGfpdkA==
X-CSE-MsgGUID: 2+YsUyiOR+WEDDwORgZb5A==
X-IronPort-AV: E=McAfee;i="6800,10657,11768"; a="78144779"
X-IronPort-AV: E=Sophos;i="6.23,201,1770624000"; 
   d="scan'208";a="78144779"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2026 01:23:59 -0700
X-CSE-ConnectionGUID: X0ntodF3RxaIzpG7fO82WA==
X-CSE-MsgGUID: B/NAJDAMSiWeQwXb163gxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,201,1770624000"; 
   d="scan'208";a="256881417"
Received: from fpallare-mobl4.ger.corp.intel.com (HELO localhost) ([10.245.244.2])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2026 01:23:56 -0700
Date: Mon, 27 Apr 2026 11:23:54 +0300
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
Message-ID: <ae8dGrM77NuCe4S0@ashevche-desk.local>
References: <20260425185151.477442-1-dmantipov@yandex.ru>
 <20260425143631.e20246946f59925c5eb8dc22@linux-foundation.org>
 <df673a44d292bb3df498b78a8b637f880e28931f.camel@yandex.ru>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df673a44d292bb3df498b78a8b637f880e28931f.camel@yandex.ru>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Mon, Apr 27, 2026 at 11:13:20AM +0300, Dmitry Antipov wrote:
> On Sat, 2026-04-25 at 14:36 -0700, Andrew Morton wrote:
> 
> > I didn't upstream "lib and lib/cmdline enhancements v9" this cycle.
> 
> You don't have to upstream v9. Because v9 is v8 + initial RISC-V build
> fix, which is a part of another series (this one) now. The proper sequence
> is v8 + this series.
> 
> > So can we please sort through these things (and the AI review) before
> > adding more?
> 
> Not sure about AI but hopefully human should realize that I'm not an
> expert in m68k/sparc32/xtensa/csky/[your favorite arch here]. Enabling
> and running the test on _all_ architectures where it is expected to 
> work requires obtaining (or even building by myself) a cross-compiler,
> setting up the kernel and QEMU, etc. I've spent a reasonable time with
> RISC-V and ARM and hopefully set up a good starting point for 
> m68k/sparc32/xtensa/csky/[your favorite arch here] maintainers, who are
> free to incorporate the test into their target architecture.
> 
> I'm going to fix everything I consider reasonable, submit v7 and give up -
> because without even a single reply from core RISC-V maintainers, this
> just turns into an endless brain masturbation.

I believe it's better to issue v10 of that series + v7 of this in one go.

-- 
With Best Regards,
Andy Shevchenko


