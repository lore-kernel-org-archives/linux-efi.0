Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A340B3597B
	for <linux-efi@vger.kernel.org>; Fri, 10 Jul 2026 00:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783644265; cv=none; b=P/cyGn31VA14Tyj2DhQqa5/jSbKkHnBc8Mx0ejkIZJHj+1g8gUFtUPJkWeN4dyUel4rGZ3k38ORSkuHVrgtvQMGUK+e4/XiVm5j+SQZGVUEy8qInDqMOluYDTK9K6Q3xd2DyA+bgQmPhMJJArT2I2KTrJLByk413vBLNmrN5V+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783644265; c=relaxed/simple;
	bh=w7CUkjmGxatJBiJUw3LuLkhyzsYPio+AJhCNAAkyB5Y=;
	h=Date:From:To:Cc:Subject:Message-ID; b=nLG0Y1bpQ43FqjIpcoznF8gKecvspGgy8cGZuGxOJlgCCNxLdYaAq4m2ie9BuQ4ENYcvFbS9E9BIEbX5r3HtHiWxD39RV4gUv5oYKCvqFib0v78bWESNDPkhsXp3JXyiaj5EAXK+NHYPTnSC16+foR3OyCBvqOLFgI6+/vKv3QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a7nHmuSJ; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a7nHmuSJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783644263; x=1815180263;
  h=date:from:to:cc:subject:message-id;
  bh=w7CUkjmGxatJBiJUw3LuLkhyzsYPio+AJhCNAAkyB5Y=;
  b=a7nHmuSJ8IyCe28NHmSCKy75vusBxG6Hqsce1/4RvrbAMvnJDfP2T2Ds
   0tlvYGEVG3HhRBkJJ3BMJhNuMApY15erXqVF2pwR+kBOVWFEjuAHAfp0d
   jEXn2hUIrli1zgsQyxOPpH8xyzqwWIsyGcHqLaseRO6X9x3AqO54Ujeip
   aoju3ba+vQ9oJLdTik3wTCxQhll5hRxNDhJ4ZdJJLWmfXG0wg/gXhVJ+F
   zs4Hhsyc6UMduxQWQw8Ze6iQidTECaRLL60sDYr8FJCKWO8p/3qf2a01N
   q99/kk+uPVXMZKT/l8vPLwAT9hJghXC1Tunn/IinG47RAr3sfk6c70UeE
   w==;
X-CSE-ConnectionGUID: +8llNTFASgKLzJMs5aLpfA==
X-CSE-MsgGUID: ww0emFuQTXi1V07qRadqkw==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="101768631"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="101768631"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 17:44:22 -0700
X-CSE-ConnectionGUID: CjPQEVvySCec9h4nTh+Ajg==
X-CSE-MsgGUID: pRaXLPz2Q8as0JTqnQaEkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="284833663"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa002.jf.intel.com with ESMTP; 09 Jul 2026 17:44:20 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1whzLl-00000000IJf-0WMZ;
	Fri, 10 Jul 2026 00:44:17 +0000
Date: Fri, 10 Jul 2026 08:43:57 +0800
From: kernel test robot <lkp@intel.com>
To: Breno Leitao <leitao@debian.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 linux-efi@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Subject: [efi:next 2/7] vmlinux.o: warning: objtool:
 efi_crash_gracefully_on_page_fault+0xc3: efi_rts_park_worker() missing
 __noreturn in .c/.h or NORETURN() in noreturns.h
Message-ID: <202607100848.iWPxdkhX-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>

Hi Breno,

FYI, the error/warning was bisected to this commit, please ignore it if it's irrelevant.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git next
head:   cf790fdb851867532b9a0f88588dcce648dbffe9
commit: 3e5ba97c181e32ca9b810414272b57bb7600998e [2/7] efi/runtime-wrappers: factor out efi_rts_park_worker()
config: x86_64-buildonly-randconfig-006-20260710 (https://download.01.org/0day-ci/archive/20260710/202607100848.iWPxdkhX-lkp@intel.com/config)
compiler: clang version 22.1.3 (https://github.com/llvm/llvm-project e9846648fd6183ee6d8cbdb4502213fcf902a211)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260710/202607100848.iWPxdkhX-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202607100848.iWPxdkhX-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> vmlinux.o: warning: objtool: efi_crash_gracefully_on_page_fault+0xc3: efi_rts_park_worker() missing __noreturn in .c/.h or NORETURN() in noreturns.h

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
