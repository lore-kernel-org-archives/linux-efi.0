Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70716197A7D
	for <linux-efi@vger.kernel.org>; Tue,  6 Oct 2026 02:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791254798; cv=none; b=u6MTsFvd2dlgpVIbJ8z8M8f9/ajSMaEPhjnW8HbNL/tsA1+0EDRdSoHLUYeQ5o3fSZwZyo0DKi9S5uv2IW4aCu0Z6pVjZGyZiKJ6Sw63TR6TjcVvnDiRdNimXO2IstJaQdiEz6hXrjjT0NapUFgMic8OWMECPPiBHHkoBudDrgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791254798; c=relaxed/simple;
	bh=PpB6lyxmFCvIxcYsAZYgQYVHGM6h69ydmDOE4/icoOg=;
	h=Date:From:To:Cc:Subject:Message-ID; b=p+Y/VL5Ejl6ErSywj2OJZ9GKfWU6rKGb4l+tq5g/SeraHmAzwDprFPJlD7Tr5anwEYd3w62lxhOzxkEdmopw+l6bhjI+5F8XqWcYiy1+BTCPz5ko2zcnEB94BNE9Ljroyz2mFWJwS19AHmytm8RDtGsbulNq9uKoMK76/rc0WGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G+6s1qNx; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G+6s1qNx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791254796; x=1822790796;
  h=date:from:to:cc:subject:message-id;
  bh=PpB6lyxmFCvIxcYsAZYgQYVHGM6h69ydmDOE4/icoOg=;
  b=G+6s1qNx6i1ufalv2FBW8Riel/HSpY3Zp1oJstaGix7Cah27j+PHhWB3
   jp3FO/t6vP6VG8XokVtq9gUH91vUcxNzwrFDcaD0ryzV8eBYZhe1vxRZk
   f9lG87PnXq/tKbqMkE9pg76Gogg4X8cUBEhOA+GS/bsDDI1OjosILaZlJ
   lq5MLui/yWULMYfzsas/FilIW8Te6wPMARHFLSn653Tvt161A6xGB+Dne
   tq+vdh2xp+L1c2fZLYQIaF3ZUyd9FwM95xrGy+/TeNNBVoA2RaBGoY4Pc
   jQ9JGTJglonyXKCQauSAg6SNTX6IBYqzr4E+gSKFiRWvhCgI70POp681e
   Q==;
X-CSE-ConnectionGUID: dtMKT6u3TLGDwKif5PJtnw==
X-CSE-MsgGUID: qRe0s8NNTF2Kze+nxEzzBQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11926"; a="90997428"
X-IronPort-AV: E=Sophos;i="6.27,143,1787036400"; 
   d="scan'208";a="90997428"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2026 19:46:36 -0700
X-CSE-ConnectionGUID: TNv8PaKOQb+CNUagIEIXmA==
X-CSE-MsgGUID: 4Z/6Vv6PR+eVPsSsLO3XOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,143,1787036400"; 
   d="scan'208";a="280729515"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 05 Oct 2026 19:46:34 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xDvCK-00000000152-1xkA;
	Tue, 06 Oct 2026 02:46:32 +0000
Date: Tue, 06 Oct 2026 10:46:09 +0800
From: kernel test robot <lkp@intel.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org
Subject: [efi:next] BUILD SUCCESS
 e41ceb82523a695015ba2edd21e9656a47227009
Message-ID: <202610061005.DccQO4f7-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git next
branch HEAD: e41ceb82523a695015ba2edd21e9656a47227009  Merge branch 'bootloader-info' into next

elapsed time: 1123m

configs tested: 438
configs skipped: 6

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    clang-24
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r2106-20261005    gcc-15.2.0 cocci
alpha                randconfig-r2304-20261004    gcc-15.2.0 sparse
arc                               allmodconfig    clang-24
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    clang-24
arc                                  defconfig    gcc-16.1.0
arc                          haps_hs_defconfig    gcc-16.1.0
arc                      haps_hs_smp_defconfig    clang-24
arc                      haps_hs_smp_defconfig    gcc-16.1.0
arc                   randconfig-1000-20261005    gcc-8.5.0
arc                   randconfig-1000-20261006    clang-24
arc                   randconfig-1001-20261005    gcc-8.5.0
arc                   randconfig-1001-20261006    clang-24
arc                  randconfig-r2202-20261005    gcc-14.3.0 smatch
arc                  randconfig-r2300-20261005    gcc-11.5.0 sparse
arc                  randconfig-r2306-20261005    gcc-15.2.0 sparse
arm                                allnoconfig    gcc-16.1.0
arm                               allyesconfig    clang-24
arm                                  defconfig    gcc-16.1.0
arm                        multi_v4t_defconfig    gcc-16.1.0
arm                         multi_v7_defconfig    gcc-16.1.0
arm                         mvebu_v7_defconfig    clang-24
arm                              mxs_defconfig    gcc-16.1.0
arm                           pxa3xx_defconfig    clang-24
arm                           pxa3xx_defconfig    gcc-16.1.0
arm                   randconfig-1000-20261005    gcc-8.5.0
arm                   randconfig-1000-20261006    clang-24
arm                   randconfig-1001-20261005    gcc-8.5.0
arm                   randconfig-1001-20261006    clang-24
arm                   randconfig-1002-20261005    gcc-8.5.0
arm                   randconfig-1002-20261006    clang-24
arm                   randconfig-1003-20261005    gcc-8.5.0
arm                   randconfig-1003-20261006    clang-24
arm                  randconfig-r2201-20261005    clang-24   smatch
arm                  randconfig-r2304-20261005    clang-21   sparse
arm                          s5pv210_defconfig    gcc-16.1.0
arm                         shmobile_defconfig    gcc-16.1.0
arm                          socfpga_defconfig    gcc-16.1.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20261005    gcc-16.1.0
arm64                 randconfig-1000-20261006    gcc-16.1.0
arm64                 randconfig-1001-20261005    gcc-16.1.0
arm64                 randconfig-1001-20261006    gcc-16.1.0
arm64                 randconfig-1002-20261005    gcc-16.1.0
arm64                 randconfig-1002-20261006    gcc-16.1.0
arm64                 randconfig-1003-20261005    gcc-16.1.0
arm64                 randconfig-1003-20261006    gcc-16.1.0
arm64                randconfig-r2103-20261005    gcc-8.5.0  cocci
arm64                randconfig-r2202-20261005    clang-24   smatch
arm64                randconfig-r2306-20261005    gcc-8.5.0  sparse
arm64                randconfig-r2307-20261004    gcc-10.5.0 sparse
arm64                randconfig-r2308-20261005    clang-24   sparse
arm64                randconfig-r2309-20261005    gcc-15.2.0 sparse
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20261005    gcc-16.1.0
csky                  randconfig-1000-20261006    gcc-16.1.0
csky                  randconfig-1001-20261005    gcc-16.1.0
csky                  randconfig-1001-20261006    gcc-16.1.0
csky                 randconfig-r2102-20261005    gcc-16.1.0 cocci
csky                 randconfig-r2105-20261004    gcc-14.3.0 cocci
csky                 randconfig-r2201-20261005    gcc-10.5.0 smatch
hexagon                           allmodconfig    gcc-16.1.0
hexagon                            allnoconfig    gcc-16.1.0
hexagon                              defconfig    gcc-16.1.0
hexagon               randconfig-1000-20261005    gcc-16.1.0
hexagon               randconfig-1000-20261006    gcc-13.4.0
hexagon               randconfig-1001-20261005    gcc-16.1.0
hexagon               randconfig-1001-20261006    gcc-13.4.0
hexagon              randconfig-r2100-20261005    gcc-16.1.0 cocci
hexagon              randconfig-r2107-20261005    gcc-14.3.0 cocci
hexagon              randconfig-r2308-20261005    gcc-15.2.0 sparse
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-16.1.0
i386        buildonly-randconfig-1000-20261005    clang-22
i386        buildonly-randconfig-1000-20261006    gcc-14
i386        buildonly-randconfig-1001-20261005    clang-22
i386        buildonly-randconfig-1001-20261006    gcc-14
i386        buildonly-randconfig-1002-20261005    clang-22
i386        buildonly-randconfig-1002-20261006    gcc-14
i386        buildonly-randconfig-1003-20261005    clang-22
i386        buildonly-randconfig-1003-20261006    gcc-14
i386        buildonly-randconfig-1004-20261005    clang-22
i386        buildonly-randconfig-1004-20261006    gcc-14
i386        buildonly-randconfig-1005-20261005    clang-22
i386        buildonly-randconfig-1005-20261006    gcc-14
i386                                 defconfig    gcc-16.1.0
i386                  randconfig-1000-20261005    clang-22
i386                  randconfig-1000-20261006    gcc-14
i386                  randconfig-1001-20261005    clang-22
i386                  randconfig-1001-20261006    gcc-14
i386                  randconfig-1002-20261005    clang-22
i386                  randconfig-1002-20261006    gcc-14
i386                  randconfig-1003-20261005    clang-22
i386                  randconfig-1003-20261006    gcc-14
i386                  randconfig-1004-20261005    clang-22
i386                  randconfig-1004-20261006    gcc-14
i386                  randconfig-1005-20261005    clang-22
i386                  randconfig-1005-20261006    gcc-14
i386                  randconfig-1006-20261005    clang-22
i386                  randconfig-1006-20261006    gcc-14
i386                  randconfig-1007-20261006    gcc-14
i386                  randconfig-1008-20261006    gcc-14
i386                  randconfig-1009-20261006    gcc-14
i386                  randconfig-1010-20261006    gcc-14
i386                  randconfig-1011-20261006    gcc-14
i386                  randconfig-1012-20261006    gcc-14
i386                  randconfig-1013-20261006    gcc-14
i386                  randconfig-2100-20261004    clang-22   cocci
i386                  randconfig-2100-20261005    gcc-14     cocci
i386                  randconfig-2101-20261004    gcc-14     cocci
i386                  randconfig-2101-20261005    gcc-14     cocci
i386                  randconfig-2102-20261004    gcc-14     cocci
i386                  randconfig-2102-20261005    gcc-14     cocci
i386                  randconfig-2103-20261004    gcc-14     cocci
i386                  randconfig-2103-20261005    gcc-14     cocci
i386                  randconfig-2200-20261005    gcc-14     smatch
i386                  randconfig-2300-20261004    clang-22   sparse
i386                  randconfig-2300-20261005    clang-22   sparse
i386                  randconfig-2301-20261004    gcc-14     sparse
i386                  randconfig-2301-20261005    clang-22   sparse
i386                  randconfig-2302-20261004    gcc-14     sparse
i386                  randconfig-2302-20261005    clang-22   sparse
i386                 randconfig-r2103-20261005    gcc-15.2.0 cocci
i386                 randconfig-r2106-20261005    gcc-14.3.0 cocci
i386                 randconfig-r2107-20261004    clang-22   cocci
i386                 randconfig-r2107-20261005    gcc-15.2.0 cocci
i386                 randconfig-r2107-20261005    gcc-8.5.0  cocci
i386                 randconfig-r2200-20261005    clang-22   smatch
i386                 randconfig-r2300-20261005    gcc-13.4.0 sparse
i386                 randconfig-r2305-20261004    clang-22   sparse
i386                 randconfig-r2305-20261005    gcc-13.4.0 sparse
i386                 randconfig-r2308-20261005    gcc-9.5.0  sparse
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.1.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261005    gcc-16.1.0
loongarch             randconfig-1000-20261006    gcc-13.4.0
loongarch             randconfig-1001-20261005    gcc-16.1.0
loongarch             randconfig-1001-20261006    gcc-13.4.0
loongarch            randconfig-r2106-20261005    gcc-16.1.0 cocci
loongarch            randconfig-r2200-20261005    clang-24   smatch
loongarch            randconfig-r2302-20261005    clang-21   sparse
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    clang-24
m68k                           amiga_defconfig    clang-24
m68k                        bvme6000_defconfig    gcc-16.1.0
m68k                                 defconfig    clang-24
m68k                         m5407c3_defconfig    gcc-16.1.0
m68k                          nettel_defconfig    gcc-16.1.0
m68k                 randconfig-r2104-20261005    gcc-14.3.0 cocci
m68k                 randconfig-r2105-20261005    gcc-8.5.0  cocci
m68k                 randconfig-r2106-20261005    gcc-8.5.0  cocci
m68k                 randconfig-r2301-20261005    gcc-11.5.0 sparse
m68k                 randconfig-r2303-20261005    clang-21   sparse
m68k                 randconfig-r2306-20261004    gcc-15.2.0 sparse
m68k                 randconfig-r2307-20261005    gcc-8.5.0  sparse
microblaze                        alldefconfig    gcc-16.1.0
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    clang-24
microblaze           randconfig-r2104-20261005    gcc-16.1.0 cocci
microblaze           randconfig-r2200-20261005    gcc-9.5.0  smatch
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                       bmips_stb_defconfig    gcc-16.1.0
mips                           eyeq6_defconfig    gcc-16.1.0
mips                       loongson1_defconfig    gcc-16.1.0
mips                       maltasmvp_defconfig    gcc-16.1.0
mips                 randconfig-r2105-20261005    gcc-16.1.0 cocci
mips                 randconfig-r2201-20261004    gcc-13.4.0 smatch
mips                 randconfig-r2303-20261005    gcc-11.5.0 sparse
mips                 randconfig-r2305-20261005    clang-21   sparse
mips                 randconfig-r2307-20261005    clang-24   sparse
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261005    gcc-16.1.0
nios2                 randconfig-1000-20261006    gcc-13.4.0
nios2                 randconfig-1001-20261005    gcc-16.1.0
nios2                 randconfig-1001-20261006    gcc-13.4.0
nios2                randconfig-r2103-20261005    gcc-16.1.0 cocci
nios2                randconfig-r2104-20261004    gcc-8.5.0  cocci
nios2                randconfig-r2104-20261005    gcc-8.5.0  cocci
nios2                randconfig-r2201-20261005    gcc-11.5.0 smatch
nios2                randconfig-r2202-20261005    gcc-11.5.0 smatch
nios2                randconfig-r2303-20261005    clang-24   sparse
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc          de0_nano_multicore_defconfig    gcc-16.1.0
openrisc                             defconfig    gcc-16.1.0
openrisc             randconfig-r2300-20261005    clang-21   sparse
openrisc             randconfig-r2303-20261004    gcc-10.5.0 sparse
openrisc             randconfig-r2309-20261004    gcc-16.1.0 sparse
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20261005    gcc-8.5.0
parisc                randconfig-1000-20261006    gcc-14.3.0
parisc                randconfig-1001-20261005    gcc-8.5.0
parisc                randconfig-1001-20261006    gcc-14.3.0
parisc               randconfig-r2101-20261004    gcc-10.5.0 cocci
parisc               randconfig-r2102-20261004    gcc-12.5.0 cocci
parisc               randconfig-r2102-20261005    gcc-8.5.0  cocci
parisc               randconfig-r2202-20261005    gcc-8.5.0  smatch
parisc64                          alldefconfig    gcc-16.1.0
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    clang-24
powerpc                  mpc836x_rdk_defconfig    clang-24
powerpc                       ppc44x_defconfig    gcc-16.1.0
powerpc               randconfig-1000-20261005    gcc-8.5.0
powerpc               randconfig-1000-20261006    gcc-14.3.0
powerpc               randconfig-1001-20261005    gcc-8.5.0
powerpc               randconfig-1001-20261006    gcc-14.3.0
powerpc              randconfig-r2101-20261005    gcc-16.1.0 cocci
powerpc              randconfig-r2102-20261005    gcc-15.2.0 cocci
powerpc              randconfig-r2103-20261004    clang-17   cocci
powerpc              randconfig-r2105-20261005    gcc-15.2.0 cocci
powerpc              randconfig-r2107-20261005    gcc-16.1.0 cocci
powerpc              randconfig-r2300-20261004    gcc-8.5.0  sparse
powerpc              randconfig-r2300-20261005    clang-24   sparse
powerpc              randconfig-r2301-20261005    clang-24   sparse
powerpc              randconfig-r2301-20261005    gcc-13.4.0 sparse
powerpc              randconfig-r2302-20261005    gcc-11.5.0 sparse
powerpc              randconfig-r2307-20261005    gcc-9.5.0  sparse
powerpc              randconfig-r2308-20261005    gcc-8.5.0  sparse
powerpc                      tqm8548_defconfig    gcc-16.1.0
powerpc                         warp_defconfig    gcc-16.1.0
powerpc                          wii_defconfig    gcc-16.1.0
powerpc64             randconfig-1000-20261005    gcc-8.5.0
powerpc64             randconfig-1000-20261006    gcc-14.3.0
powerpc64             randconfig-1001-20261005    gcc-8.5.0
powerpc64             randconfig-1001-20261006    gcc-14.3.0
powerpc64            randconfig-r2100-20261004    clang-24   cocci
powerpc64            randconfig-r2200-20261005    gcc-12.5.0 smatch
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.1.0
riscv                     nommu_virt_defconfig    clang-24
riscv                 randconfig-1000-20261005    clang-17
riscv                 randconfig-1000-20261006    clang-24
riscv                 randconfig-1001-20261005    clang-17
riscv                 randconfig-1001-20261006    clang-24
riscv                 randconfig-2000-20261005    gcc-13.4.0
riscv                 randconfig-2000-20261005    gcc-16.1.0
riscv                 randconfig-2001-20261005    gcc-16.1.0
riscv                 randconfig-2001-20261005    gcc-8.5.0
riscv                randconfig-r2100-20261005    gcc-13.4.0 cocci
riscv                randconfig-r2101-20261005    gcc-13.4.0 cocci
riscv                randconfig-r2102-20261005    gcc-13.4.0 cocci
riscv                randconfig-r2104-20261005    gcc-15.2.0 cocci
riscv                randconfig-r2301-20261005    clang-21   sparse
riscv                randconfig-r2304-20261005    gcc-13.4.0 sparse
riscv                randconfig-r2306-20261005    clang-24   sparse
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                           debug_defconfig    gcc-16.1.0
s390                                 defconfig    gcc-16.1.0
s390                  randconfig-1000-20261005    clang-17
s390                  randconfig-1000-20261006    clang-24
s390                  randconfig-1001-20261005    clang-17
s390                  randconfig-1001-20261006    clang-24
s390                  randconfig-2000-20261005    gcc-13.4.0
s390                  randconfig-2000-20261005    gcc-16.1.0
s390                  randconfig-2001-20261005    clang-24
s390                  randconfig-2001-20261005    gcc-16.1.0
s390                 randconfig-r2200-20261005    clang-24   smatch
s390                 randconfig-r2202-20261004    gcc-9.5.0  smatch
s390                 randconfig-r2303-20261005    gcc-13.4.0 sparse
s390                 randconfig-r2305-20261005    clang-24   sparse
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                                   defconfig    gcc-14
sh                          ecovec24_defconfig    gcc-16.1.0
sh                           r7780mp_defconfig    gcc-16.1.0
sh                    randconfig-1000-20261005    clang-17
sh                    randconfig-1000-20261006    clang-24
sh                    randconfig-1001-20261005    clang-17
sh                    randconfig-1001-20261006    clang-24
sh                    randconfig-2000-20261005    gcc-12.5.0
sh                    randconfig-2000-20261005    gcc-16.1.0
sh                    randconfig-2001-20261005    gcc-16.1.0
sh                   randconfig-r2105-20261005    gcc-14.3.0 cocci
sh                   randconfig-r2106-20261004    gcc-16.1.0 cocci
sh                   randconfig-r2309-20261005    gcc-8.5.0  sparse
sh                      sh7710voipgw_defconfig    gcc-16.1.0
sh                             shmin_defconfig    gcc-16.1.0
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20261005    clang-24
sparc                 randconfig-1000-20261006    gcc-14
sparc                 randconfig-1001-20261005    clang-24
sparc                 randconfig-1001-20261006    gcc-14
sparc                 randconfig-2000-20261004    gcc-8.5.0
sparc                 randconfig-2000-20261005    clang-17
sparc                 randconfig-2001-20261004    gcc-15.2.0
sparc                 randconfig-2001-20261005    clang-17
sparc                randconfig-r2100-20261005    gcc-15.2.0 cocci
sparc                randconfig-r2101-20261005    gcc-8.5.0  cocci
sparc                randconfig-r2201-20261005    gcc-15.2.0 smatch
sparc                randconfig-r2302-20261005    clang-24   sparse
sparc                randconfig-r2304-20261005    gcc-11.5.0 sparse
sparc                randconfig-r2307-20261005    gcc-15.2.0 sparse
sparc                randconfig-r2309-20261005    clang-24   sparse
sparc                randconfig-r2309-20261005    gcc-9.5.0  sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261005    clang-24
sparc64               randconfig-1000-20261006    gcc-14
sparc64               randconfig-1001-20261005    clang-24
sparc64               randconfig-1001-20261006    gcc-14
sparc64               randconfig-2000-20261004    clang-20
sparc64               randconfig-2000-20261005    clang-17
sparc64               randconfig-2001-20261004    gcc-10.5.0
sparc64               randconfig-2001-20261005    clang-17
sparc64              randconfig-r2301-20261004    clang-20   sparse
sparc64              randconfig-r2302-20261005    gcc-13.4.0 sparse
sparc64              randconfig-r2304-20261005    clang-24   sparse
um                                alldefconfig    gcc-16.1.0
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.1.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                              i386_defconfig    gcc-16.1.0
um                    randconfig-1000-20261005    clang-24
um                    randconfig-1000-20261006    gcc-14
um                    randconfig-1001-20261005    clang-24
um                    randconfig-1001-20261006    gcc-14
um                    randconfig-2000-20261004    gcc-14
um                    randconfig-2000-20261005    clang-17
um                    randconfig-2001-20261004    clang-17
um                    randconfig-2001-20261005    clang-17
um                   randconfig-r2101-20261005    gcc-15.2.0 cocci
um                   randconfig-r2305-20261005    gcc-11.5.0 sparse
um                   randconfig-r2308-20261004    clang-24   sparse
um                            x86_64_defconfig    gcc-14
x86_64                             allnoconfig    clang-24
x86_64      buildonly-randconfig-1000-20261005    gcc-13
x86_64      buildonly-randconfig-1000-20261006    gcc-14
x86_64      buildonly-randconfig-1001-20261005    gcc-13
x86_64      buildonly-randconfig-1001-20261006    gcc-14
x86_64      buildonly-randconfig-1002-20261005    gcc-13
x86_64      buildonly-randconfig-1002-20261006    gcc-14
x86_64      buildonly-randconfig-1003-20261005    gcc-13
x86_64      buildonly-randconfig-1003-20261006    gcc-14
x86_64      buildonly-randconfig-1004-20261005    gcc-13
x86_64      buildonly-randconfig-1004-20261006    gcc-14
x86_64      buildonly-randconfig-1005-20261005    gcc-13
x86_64      buildonly-randconfig-1005-20261006    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261005    gcc-14
x86_64                randconfig-1000-20261006    gcc-14
x86_64                randconfig-1001-20261005    gcc-14
x86_64                randconfig-1001-20261006    gcc-14
x86_64                randconfig-1002-20261005    gcc-14
x86_64                randconfig-1002-20261006    gcc-14
x86_64                randconfig-1003-20261005    gcc-14
x86_64                randconfig-1003-20261006    gcc-14
x86_64                randconfig-1004-20261005    gcc-14
x86_64                randconfig-1004-20261006    gcc-14
x86_64                randconfig-1005-20261005    gcc-14
x86_64                randconfig-1005-20261006    gcc-14
x86_64                randconfig-1006-20261005    gcc-14
x86_64                randconfig-1006-20261006    gcc-14
x86_64                randconfig-1007-20261005    gcc-14
x86_64                randconfig-1007-20261006    gcc-14
x86_64                randconfig-1008-20261005    gcc-14
x86_64                randconfig-1008-20261006    gcc-14
x86_64                randconfig-1009-20261005    gcc-14
x86_64                randconfig-1009-20261006    gcc-14
x86_64                randconfig-1010-20261005    gcc-14
x86_64                randconfig-1010-20261006    gcc-14
x86_64                randconfig-1011-20261005    gcc-14
x86_64                randconfig-1011-20261006    gcc-14
x86_64                randconfig-1012-20261006    gcc-14
x86_64                randconfig-1013-20261006    gcc-14
x86_64                randconfig-1014-20261006    gcc-14
x86_64                randconfig-1015-20261006    gcc-14
x86_64                randconfig-1016-20261006    gcc-14
x86_64                randconfig-1017-20261006    gcc-14
x86_64                randconfig-2100-20261004    gcc-14     cocci
x86_64                randconfig-2100-20261005    clang-22   cocci
x86_64                randconfig-2101-20261004    clang-22   cocci
x86_64                randconfig-2101-20261005    clang-22   cocci
x86_64                randconfig-2102-20261004    gcc-14     cocci
x86_64                randconfig-2102-20261005    clang-22   cocci
x86_64                randconfig-2103-20261004    gcc-14     cocci
x86_64                randconfig-2103-20261005    clang-22   cocci
x86_64                randconfig-2200-20261004    gcc-14     smatch
x86_64                randconfig-2200-20261005    clang-22   smatch
x86_64                randconfig-2300-20261004    gcc-14     sparse
x86_64                randconfig-2300-20261005    clang-22   sparse
x86_64                randconfig-2301-20261004    gcc-14     sparse
x86_64                randconfig-2301-20261005    clang-22   sparse
x86_64                randconfig-2302-20261004    clang-22   sparse
x86_64                randconfig-2302-20261005    clang-22   sparse
x86_64               randconfig-r2103-20261005    gcc-13.4.0 cocci
x86_64               randconfig-r2302-20261004    clang-22   sparse
x86_64                                rhel-9.4    clang-22
x86_64                            rhel-9.4-bpf    clang-22
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                          rhel-9.4-kunit    clang-22
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    clang-22
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                            allyesconfig    clang-20
xtensa                 generic_kc705_defconfig    gcc-16.1.0
xtensa                randconfig-1000-20261005    clang-24
xtensa                randconfig-1000-20261006    gcc-14
xtensa                randconfig-1001-20261005    clang-24
xtensa                randconfig-1001-20261006    gcc-14
xtensa                randconfig-2000-20261004    gcc-8.5.0
xtensa                randconfig-2000-20261005    clang-17
xtensa                randconfig-2001-20261004    gcc-9.5.0
xtensa                randconfig-2001-20261005    clang-17
xtensa               randconfig-r2100-20261005    gcc-8.5.0  cocci
xtensa               randconfig-r2306-20261005    gcc-9.5.0  sparse

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
