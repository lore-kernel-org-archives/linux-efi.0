Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA92A340A6A
	for <linux-efi@vger.kernel.org>; Wed, 15 Apr 2026 09:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776246783; cv=none; b=Rtnu2Zb7DZE8QvhjiyuxA50aT6PrfnlaE9mElMMygYZBBpPXXQHYap8mauEcGdvnGYgvsCTmyl9Whprx8HtEmFjgVon3VjMy1LF970e2WHhiVPgJ3ZYYUeKTm9WUrbXeEYVaBJzhKKnhcAUes2Dtz4rR/qzAHw5d8tt6QxIQeCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776246783; c=relaxed/simple;
	bh=3fk+o8IALEh5DWjkaX/Zs/CY0Fh3YqT3vOmYEv88GKM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VRxIrpDRMpByldNGZa32Q30Yc/n96KyzIQ/nUDHVzzQZ+Zp/i0igsz65woy52/eViPBgxIn3Q9C/2UHAlPPkxJXhpvkZZfEUO61E07vijARpu4W/CkF1OyYIJ3yEY3EVrPEv5HTZGd3WqbdqG4dqVrFF8n4GvR9pP6GL5yHatR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C80BTB5B; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C80BTB5B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776246780; x=1807782780;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3fk+o8IALEh5DWjkaX/Zs/CY0Fh3YqT3vOmYEv88GKM=;
  b=C80BTB5BZX+9oj4G7EODxhKTSOHZR+5RZzIlNPuu+wXhJWVBIdsqfoRc
   LFoQhkCxJ91Q1nrZpbUuNfkUOcGf2NZbL7bvXbCEiXyJrmVkY0L/L8FNz
   qUrCQuOae+1bgJTGN/Cuczm+Yrg4V6fHWLSUoeiLYSh0lBINFnhzoLLyA
   GkB1bDMtHDL8H7Ck8/bhAAMHpLgC7r2rg0HhNRMlF37S6kfCTM7SbYieK
   6CW7ZZ8HiumoNexh6cTsetrQjrtTPNpnsoL7QzRPufl9PjTV13XNKnbyT
   z9G1nVF3DwLrM/FqrSIKd5nEGBidd/AYvmQe2GKqCHazkxQI4cBaa5c24
   A==;
X-CSE-ConnectionGUID: h8UaCT7PS7Sh8DJjFfV3CQ==
X-CSE-MsgGUID: wvZbTRWISTu5of44aCipFA==
X-IronPort-AV: E=McAfee;i="6800,10657,11759"; a="87922043"
X-IronPort-AV: E=Sophos;i="6.23,179,1770624000"; 
   d="scan'208";a="87922043"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2026 02:53:00 -0700
X-CSE-ConnectionGUID: 2sjnkIYqT9KpS+N/KAee0w==
X-CSE-MsgGUID: N5TzoYGMTWavfr27vstasA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,179,1770624000"; 
   d="scan'208";a="230295052"
Received: from rvuia-mobl.ger.corp.intel.com (HELO localhost) ([10.245.244.34])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2026 02:52:58 -0700
Date: Wed, 15 Apr 2026 12:52:55 +0300
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Charlie Jenkins <thecharlesjenkins@gmail.com>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Ard Biesheuvel <ardb@kernel.org>,
	linux-riscv@lists.infradead.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH v4 3/3] riscv: fix building compressed EFI image
Message-ID: <ad9f9543RuV17RnH@ashevche-desk.local>
References: <20260414102608.573555-1-dmantipov@yandex.ru>
 <20260414102608.573555-4-dmantipov@yandex.ru>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260414102608.573555-4-dmantipov@yandex.ru>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Tue, Apr 14, 2026 at 01:26:08PM +0300, Dmitry Antipov wrote:
> When building vmlinuz.efi with CONFIG_EFI_ZBOOT enabled,
> '__lshrdi3()' is also needed to fix yet another link error:
> 
> riscv32-linux-gnu-ld: drivers/firmware/efi/libstub/lib-cmdline.stub.o: in function `__efistub_.L49':
> __efistub_cmdline.c:(.init.text+0x202): undefined reference to `__efistub___lshrdi3'
> 
> And since riscv64 can have CONFIG_EFI_ZBOOT but doesn't need these
> library routines, introduce CONFIG_EFI_ZBOOT_USE_LIBGCC to manage
> linking of lib-ashldi3.o and lib-lshrdi3.o on riscv32 only.

Acked-by: Andy Shevchenko <andriy.shevchenko@intel.com>

I think you need a tag from Ard on this.

-- 
With Best Regards,
Andy Shevchenko


