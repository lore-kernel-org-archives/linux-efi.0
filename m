Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDED43C943F
	for <linux-efi@vger.kernel.org>; Tue, 10 Mar 2026 17:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773164327; cv=none; b=gLYEXbgTzblwwWoh4A6YN99gkVY2EsaE+gMqipukekJMznUqo6mrN/cV03INg/YOMALoWTw5mvaYkvMmiYV0GDmxvrDzeYwairVB4ljYt45156In64uLIrowi1O9YpteQlbEygjdK+YAamHGql7IU6g1FQsyjaQQVKEBsJx4N0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773164327; c=relaxed/simple;
	bh=DZlX3dkt90iZeJo21NRyUd3PEqCnuE943/sQO3+loaM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=WpmOdT/U6qvBrUSxxbYHCM/Y5OyPOtuhzYBYlaonfmyaXUbKJcqLnngbA1H/62agit3k6to/lzg2RcibCoR2zmnx+XaOaMn6xXRWOBZt34kWNIbkQFINiMcihY4c2zcGtdhasnOgxgXZg3hwKd/mhQ3tVdgZV0VEPrUKiZnAVjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lI+UTZ+R; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lI+UTZ+R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773164326; x=1804700326;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=DZlX3dkt90iZeJo21NRyUd3PEqCnuE943/sQO3+loaM=;
  b=lI+UTZ+RWiLO6FJCmPVSutKCMmwwfbO3yi4w31Di44kplujt3i8a8/hg
   WtemwupX9Mit+Dik6MNZh4+I+62dqaX58qergUkxs7s1TlRhQvvNygdrX
   WXj1pf91BrnRsPGuNcs2WRI1Uwr7cGf6co8oQUcnrxBe2v1LFUFG66MrW
   PqIGw5/nPVVUXhLFjmUr44GQMTvp1vPa/9b7Uo8eIVimivQ1s5gL1/Whm
   gH9zFd0sM9qF99LValX15p5i+1k+KC43oB7cBrQ1KSx02ECfKs/VTX7f6
   mHuWHPUR1NjIM/R6txf20mJBf2begmvYQFsVWGF8pxBHDOuh9DR7war6w
   A==;
X-CSE-ConnectionGUID: QZfFAQccQ62J83T9p+yjuQ==
X-CSE-MsgGUID: 7twygRx7TO+Pxt+wq5ld4g==
X-IronPort-AV: E=McAfee;i="6800,10657,11725"; a="85575904"
X-IronPort-AV: E=Sophos;i="6.23,112,1770624000"; 
   d="scan'208";a="85575904"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2026 10:38:44 -0700
X-CSE-ConnectionGUID: Ifhgr3JDQgyCGH1fSq+F7Q==
X-CSE-MsgGUID: UWwDRkzMQnycKrSKArNrkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,112,1770624000"; 
   d="scan'208";a="217715563"
Received: from igk-lkp-server01.igk.intel.com (HELO 9958d990ccf2) ([10.211.93.152])
  by fmviesa007.fm.intel.com with ESMTP; 10 Mar 2026 10:38:42 -0700
Received: from kbuild by 9958d990ccf2 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w012W-0000000037J-3Oqb;
	Tue, 10 Mar 2026 17:38:40 +0000
Date: Tue, 10 Mar 2026 18:38:19 +0100
From: kernel test robot <lkp@intel.com>
To: "Marek =?utf-8?Q?Marczykowski-G=C3=B3recki"?= <marmarek@invisiblethingslab.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 linux-efi@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Subject: [efi:next 1/4] drivers/firmware/efi/efi.c:1009:37: error:
 passing 'const efi_memory_desc_t *' to parameter of type 'efi_memory_desc_t
 *' discards qualifiers
Message-ID: <202603101859.RnuowrOx-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git next
head:   c8da97cbb39c4c043d8456fcae25aa921c844a3f
commit: 5992265762e666564b0275d72e54c514ab20c7f3 [1/4] efi: make efi_mem_type() and efi_mem_attributes() work on Xen PV
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20260310/202603101859.RnuowrOx-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260310/202603101859.RnuowrOx-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603101859.RnuowrOx-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/firmware/efi/efi.c:1009:37: error: passing 'const efi_memory_desc_t *' to parameter of type 'efi_memory_desc_t *' discards qualifiers [-Werror,-Wincompatible-pointer-types-discards-qualifiers]
    1009 |         if (efi_mem_desc_lookup(phys_addr, &md))
         |                                            ^~~
   drivers/firmware/efi/efi.c:570:19: note: passing argument to parameter here
     570 | EXPORT_SYMBOL_GPL(efi_mem_desc_lookup);
         |                   ^
   1 error generated.


vim +1009 drivers/firmware/efi/efi.c

   993	
   994	/*
   995	 * efi_mem_type - lookup memmap type for physical address
   996	 * @phys_addr: the physical address to lookup
   997	 *
   998	 * Search in the EFI memory map for the region covering @phys_addr.
   999	 * Returns the EFI memory type if the region was found in the memory
  1000	 * map, -EINVAL otherwise.
  1001	 */
  1002	int efi_mem_type(unsigned long phys_addr)
  1003	{
  1004		const efi_memory_desc_t md;
  1005	
  1006		if (!efi_enabled(EFI_MEMMAP) && !efi_enabled(EFI_PARAVIRT))
  1007			return -ENOTSUPP;
  1008	
> 1009		if (efi_mem_desc_lookup(phys_addr, &md))
  1010			return -EINVAL;
  1011	
  1012		return md.type;
  1013	}
  1014	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
