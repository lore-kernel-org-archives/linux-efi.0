Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D52738B7A0
	for <linux-efi@vger.kernel.org>; Tue, 10 Mar 2026 17:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773163127; cv=none; b=VSo1GoNvMWplqMAOeNhkiOHIFcw/pBpZqUWEmrWfzRRHGPZVO3ks/MEVl69ZSiPQb3qEznYnuGHccvimrihmpflyB2UEMRNXux/fwLB8nrm8K2n2qf1117EUGz2V6RtsIsemOK7ITSXilxjgGFbYSB323v16YZnDttVWBM1iQZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773163127; c=relaxed/simple;
	bh=m+dNIcjPKWZXv1T/B4sTPMVRbasHkz3lwAR4Ul0sWqY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=Lg3Nmmn2vLVQ9Snu3NJ/MWsEcrapomL7PZmdc5PqnhN9Z8ooamJm5f+IBWOWtAzrHei0F3ziCFT0guDIbJg0bLAgGMwwXZZySohPwVjKwnGxGJbGriIhemRZrrLsJufh5E4xWlpDm9mQTG5n3Pe64Ko66Yhz9Z7TgBmzJjVVSB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QcX3RReE; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QcX3RReE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773163125; x=1804699125;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=m+dNIcjPKWZXv1T/B4sTPMVRbasHkz3lwAR4Ul0sWqY=;
  b=QcX3RReE2mGn3xP6OiC5ItFRsM6UOQjqIyMu4nzZwUIuKektNhiHQNbO
   7ojyt/GP3M9nwnY2ZaTNQSp808XSF/ROsa2/v72qYfHQ748HwhP8oPtb/
   wQgsY7PvdKmT6cunywOZEr0P5CzMIrQ3rjNycEGd1Qo9oBzXnYauqp6uZ
   VXHdRAulo5KCx2Ya9lPdsVOW5MP7CyxkC6iQw0kX+Nrw1Co7muGg8L8HR
   qa7DYWbEpfGg+yJrJd8XtrkIl2ehx8PYsmtvak8GmBF1AYEiFkjX/W/Cp
   NOd5KRMGzT9eoJjcTzozJbo8Orh/mDjrl0+Tx62pFnpwkM7FOC+DJCYl7
   g==;
X-CSE-ConnectionGUID: 1c+QOTgzQfuJbCGGHn/6Ww==
X-CSE-MsgGUID: baow4buxTaWWorbeiny2sQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11725"; a="78102241"
X-IronPort-AV: E=Sophos;i="6.23,112,1770624000"; 
   d="scan'208";a="78102241"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2026 10:18:44 -0700
X-CSE-ConnectionGUID: WZsGopL3TnOEdDGfRjrmWw==
X-CSE-MsgGUID: c9l0Kzp/SQKkIZLAU6KSBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,112,1770624000"; 
   d="scan'208";a="224646723"
Received: from igk-lkp-server01.igk.intel.com (HELO 9958d990ccf2) ([10.211.93.152])
  by orviesa004.jf.intel.com with ESMTP; 10 Mar 2026 10:18:43 -0700
Received: from kbuild by 9958d990ccf2 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w00jA-0000000037B-2vDE;
	Tue, 10 Mar 2026 17:18:40 +0000
Date: Tue, 10 Mar 2026 18:17:44 +0100
From: kernel test robot <lkp@intel.com>
To: "Marek =?utf-8?Q?Marczykowski-G=C3=B3recki"?= <marmarek@invisiblethingslab.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-efi@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>
Subject: [efi:next 1/4] drivers/firmware/efi/efi.c:1009:44: warning:
 passing argument 2 of 'efi_mem_desc_lookup' discards 'const' qualifier from
 pointer target type
Message-ID: <202603101851.bAhG7uGN-lkp@intel.com>
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
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20260310/202603101851.bAhG7uGN-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260310/202603101851.bAhG7uGN-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603101851.bAhG7uGN-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/firmware/efi/efi.c: In function 'efi_mem_type':
>> drivers/firmware/efi/efi.c:1009:44: warning: passing argument 2 of 'efi_mem_desc_lookup' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
    1009 |         if (efi_mem_desc_lookup(phys_addr, &md))
         |                                            ^~~
   In file included from drivers/firmware/efi/efi.c:22:
   include/linux/efi.h:757:66: note: expected 'efi_memory_desc_t *' but argument is of type 'const efi_memory_desc_t *'
     757 | extern int efi_mem_desc_lookup(u64 phys_addr, efi_memory_desc_t *out_md);
         |                                               ~~~~~~~~~~~~~~~~~~~^~~~~~


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
