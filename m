Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62DE36B076
	for <linux-efi@vger.kernel.org>; Tue, 10 Mar 2026 20:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773176125; cv=none; b=pwcOJ5zwNVZGlvpAhp1hKelauX/5LRO9R9OODlnhQ3mndzxQVnm2ECQLUDAmKZgQZhD3Hq6AEHRkAGrErEj5TcJIoz2ttwTgAz8vBzejkwQugFTP16wrp5WTra52xPMNOde3tRgQHM52+TtnPnosGeDc+4eSJqsMgMHaQn7kgZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773176125; c=relaxed/simple;
	bh=T988jY1bBaZ1hcHb0+bOyCPAIu9H136aFLXICw6nrw4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=MnaJwwkikoGD8gpXtYQYKcltxDoPM9COgfRCvYKKfSTJGjmKa+P7Cd7tcM2vAvW/dPCjzkvil+vgVL/IRWHC9EtGRFp3g0x+rhoXT1vJwDaT6YmneXRDmMHj6bNBlbVi1SHuR/RPgL9GcaEH4xlHsyzFxCXBhzsPYATFWifv5x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=izyz8Uee; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="izyz8Uee"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773176124; x=1804712124;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=T988jY1bBaZ1hcHb0+bOyCPAIu9H136aFLXICw6nrw4=;
  b=izyz8UeeK3FX+XKiqwKptH7Asl7apNyIOkCL/Xl7rCpzwvMlgAdW/82E
   xFeACDcIiyB3Eq7dDroNVFeEAh0P72iiYrL//cSyZVPxL0BNxK0YruXDt
   0c4bL8KwIEIUoBK/lqHWcgzoMU72oMmo+X0PAIycpyzbaeWU0wPEEdUYl
   InAXz61Se+/GrqcXnfS0qd1hqreKiM9zo0EOVnt+UVib2O98pbTmYJGi2
   kHBa4IqdsU2XC5aWa1766M1AY3rcJxN0HiachZaqjwoMPIOGazKed94Xg
   oGXs3vOF93fJlIfF3L5/oSg6CdJgmBzhct9tajea2iOKrzGao3/wJfHCw
   Q==;
X-CSE-ConnectionGUID: KPGwdvPARoyh3v/H7IvLIA==
X-CSE-MsgGUID: I5dP+Sc1QHOVnXxUqt8JXQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11725"; a="77840148"
X-IronPort-AV: E=Sophos;i="6.23,112,1770624000"; 
   d="scan'208";a="77840148"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2026 13:55:24 -0700
X-CSE-ConnectionGUID: EbRl4CHuT02y/QQU9ZqxVw==
X-CSE-MsgGUID: Pva65qtSRGS6xFbAYycZKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,112,1770624000"; 
   d="scan'208";a="218165666"
Received: from lkp-server01.sh.intel.com (HELO 418530b1a366) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 10 Mar 2026 13:55:21 -0700
Received: from kbuild by 418530b1a366 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w046p-000000000Ha-1Mnx;
	Tue, 10 Mar 2026 20:55:19 +0000
Date: Wed, 11 Mar 2026 04:54:24 +0800
From: kernel test robot <lkp@intel.com>
To: "Marek =?utf-8?Q?Marczykowski-G=C3=B3recki"?= <marmarek@invisiblethingslab.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 linux-efi@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Subject: [efi:next 1/4] drivers/firmware/efi/efi.c:1009:37: error:
 passing 'const efi_memory_desc_t *' to parameter of type 'efi_memory_desc_t
 *' discards qualifiers
Message-ID: <202603110434.qe4wAhhY-lkp@intel.com>
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
config: loongarch-allnoconfig (https://download.01.org/0day-ci/archive/20260311/202603110434.qe4wAhhY-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 122f0b13a237b5024747b4ee99002590cc9a220a)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260311/202603110434.qe4wAhhY-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603110434.qe4wAhhY-lkp@intel.com/

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
