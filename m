Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E24743C7A4
	for <linux-efi@vger.kernel.org>; Wed,  7 Oct 2026 10:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791368905; cv=none; b=erFDpk5S82GC0M3OCzdvqCdT7RLvKprKVeHG9O1kXt9LsPpSm02XFUhpA0cXTkdR+pBHITa6ryMqAvKmNEpYxq8Edx8EZUpQ058sa32cire1ETgwmzs8yMMeFEZdPo+SbOMXCf9qjgOJFFwWirpmpxkIPOEKH9rzBk7jyRM+GJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791368905; c=relaxed/simple;
	bh=mWb2PmM0KECwJy1whMEFE6R3XAlMIsZ0JASdxfEIrg0=;
	h=Date:From:To:Cc:Subject:Message-ID; b=H+UXkjO8kXSgJr/49fbN9qdlzVVjNvKCqJve2rxTZcNqWTmUg5YaZoaVfohdhij+WkdejNnDgC60NqQjYChywv6VV2gGeeDlPWWv0tkRgc2cQk4Ips9eaUJcsPkHWmVkGE2Y9/JoOxEK1PpJ64NMOilGBQGIIJNJWDSg6TAOLXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dEKrt7Ww; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dEKrt7Ww"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791368893; x=1822904893;
  h=date:from:to:cc:subject:message-id;
  bh=mWb2PmM0KECwJy1whMEFE6R3XAlMIsZ0JASdxfEIrg0=;
  b=dEKrt7Wwbm/xdB67HUUqDifMJpPtorTX1Tfe7cjjb3looWJlgLz/q21w
   DYtqe30dI7DrzJDaLBUNizbKPrnBavice5yBLy061O+aPFzd8TtjYgGqo
   sxAOHfXeu2YjlEksIW9E+E6U3dDgjg/RB7Og3VUscyfbfca14+avSgmek
   ZotlOolTBUVh8SdFOPVCoqICV9ouG7CpTk3jeBZYn+JHLed4+Kb6pSfZd
   uvkOdlCxi6fkNu5JzUWHZs17wE0t8WsOB7Z38wrGx4UnHAN8PnZ56L0F3
   64EjZ7fxNI5/Ov9NGLn+uTzQBV2/DH3ce+8/AAawVBs5B2nTQOl728XLP
   w==;
X-CSE-ConnectionGUID: NFKt2xiJTziJxSJZiSvW8A==
X-CSE-MsgGUID: rrcCO3WVSuev2GCVfaO5Xg==
X-IronPort-AV: E=McAfee;i="6800,10657,11927"; a="130168"
X-IronPort-AV: E=Sophos;i="6.27,144,1787036400"; 
   d="scan'208";a="130168"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2026 03:28:13 -0700
X-CSE-ConnectionGUID: Ux/APr70RTiClDL5mq1FVw==
X-CSE-MsgGUID: ewleCXSSQ/a9h2HeFAvzxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,144,1787036400"; 
   d="scan'208";a="282215158"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 07 Oct 2026 03:28:11 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xEOsb-000000002pC-0ce1;
	Wed, 07 Oct 2026 10:28:09 +0000
Date: Wed, 07 Oct 2026 18:27:40 +0800
From: kernel test robot <lkp@intel.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org
Subject: [efi:next] BUILD SUCCESS
 8ea857a2bb547e388e86ca42c58a97e162e09f83
Message-ID: <202610071836.ey2xyXsS-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git next
branch HEAD: 8ea857a2bb547e388e86ca42c58a97e162e09f83  efi/libstub: Free cmdline_ptr in efi_pe_entry

elapsed time: 1274m

configs tested: 387
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r2101-20261006    gcc-9.5.0  cocci
alpha                randconfig-r2104-20261007    gcc-10.5.0 cocci
alpha                randconfig-r2107-20261006    clang-24   cocci
alpha                randconfig-r2200-20261006    gcc-14.3.0 smatch
alpha                randconfig-r2201-20261006    gcc-8.5.0  smatch
alpha                randconfig-r2303-20261006    gcc-8.5.0  sparse
alpha                randconfig-r2304-20261006    gcc-10.5.0 sparse
alpha                randconfig-r2306-20261007    clang-24   sparse
alpha                randconfig-r2307-20261006    clang-19   sparse
alpha                randconfig-r2308-20261006    clang-19   sparse
alpha                randconfig-r2309-20261006    clang-24   sparse
arc                               allmodconfig    clang-24
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    clang-24
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20261007    clang-24
arc                   randconfig-1001-20261007    clang-24
arc                  randconfig-r2102-20261007    gcc-10.5.0 cocci
arc                  randconfig-r2105-20261006    gcc-14.3.0 cocci
arc                  randconfig-r2106-20261006    clang-24   cocci
arc                  randconfig-r2200-20261006    gcc-13.4.0 smatch
arc                  randconfig-r2201-20261006    gcc-11.5.0 smatch
arm                               alldefconfig    gcc-16.1.0
arm                                allnoconfig    gcc-16.1.0
arm                               allyesconfig    clang-24
arm                      davinci_all_defconfig    gcc-16.1.0
arm                                  defconfig    gcc-16.1.0
arm                            omap1_defconfig    gcc-16.1.0
arm                           pxa168_defconfig    gcc-16.1.0
arm                           pxa3xx_defconfig    gcc-16.1.0
arm                   randconfig-1000-20261007    clang-24
arm                   randconfig-1001-20261007    clang-24
arm                   randconfig-1002-20261007    clang-24
arm                   randconfig-1003-20261007    clang-24
arm                  randconfig-r2103-20261006    clang-24   cocci
arm                  randconfig-r2105-20261007    gcc-16.1.0 cocci
arm                  randconfig-r2305-20261006    gcc-8.5.0  sparse
arm                          wpcm450_defconfig    gcc-16.1.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20261007    gcc-13.4.0
arm64                 randconfig-1001-20261007    gcc-13.4.0
arm64                 randconfig-1002-20261007    gcc-13.4.0
arm64                 randconfig-1003-20261007    gcc-13.4.0
arm64                randconfig-r2100-20261007    gcc-10.5.0 cocci
arm64                randconfig-r2104-20261006    gcc-14.3.0 cocci
arm64                randconfig-r2105-20261006    clang-24   cocci
arm64                randconfig-r2106-20261007    gcc-16.1.0 cocci
arm64                randconfig-r2300-20261006    gcc-8.5.0  sparse
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20261007    gcc-13.4.0
csky                  randconfig-1001-20261007    gcc-13.4.0
csky                 randconfig-r2101-20261006    gcc-16.1.0 cocci
csky                 randconfig-r2102-20261007    gcc-8.5.0  cocci
csky                 randconfig-r2103-20261006    gcc-16.1.0 cocci
csky                 randconfig-r2104-20261007    gcc-16.1.0 cocci
csky                 randconfig-r2200-20261006    gcc-15.2.0 smatch
csky                 randconfig-r2201-20261007    gcc-16.1.0 smatch
csky                 randconfig-r2300-20261006    gcc-15.2.0 sparse
csky                 randconfig-r2301-20261007    gcc-8.5.0  sparse
csky                 randconfig-r2303-20261006    gcc-10.5.0 sparse
csky                 randconfig-r2304-20261006    gcc-8.5.0  sparse
hexagon                           allmodconfig    gcc-16.1.0
hexagon                            allnoconfig    gcc-16.1.0
hexagon                              defconfig    gcc-16.1.0
hexagon               randconfig-1000-20261007    gcc-12.5.0
hexagon               randconfig-1001-20261007    gcc-12.5.0
hexagon              randconfig-r2101-20261007    gcc-8.5.0  cocci
hexagon              randconfig-r2107-20261007    gcc-16.1.0 cocci
hexagon              randconfig-r2301-20261006    gcc-8.5.0  sparse
hexagon              randconfig-r2307-20261006    gcc-10.5.0 sparse
hexagon              randconfig-r2308-20261006    clang-24   sparse
hexagon              randconfig-r2309-20261007    clang-17   sparse
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-16.1.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20261007    gcc-14
i386        buildonly-randconfig-1001-20261007    gcc-14
i386        buildonly-randconfig-1002-20261007    gcc-14
i386        buildonly-randconfig-1003-20261007    gcc-14
i386        buildonly-randconfig-1004-20261007    gcc-14
i386        buildonly-randconfig-1005-20261007    gcc-14
i386                                 defconfig    gcc-16.1.0
i386                  randconfig-1000-20261007    clang-22
i386                  randconfig-1001-20261007    clang-22
i386                  randconfig-1002-20261007    clang-22
i386                  randconfig-1003-20261007    clang-22
i386                  randconfig-1004-20261007    clang-22
i386                  randconfig-1005-20261007    clang-22
i386                  randconfig-1006-20261007    clang-22
i386                  randconfig-1007-20261007    gcc-14
i386                  randconfig-1008-20261007    gcc-14
i386                  randconfig-1009-20261007    gcc-14
i386                  randconfig-1010-20261007    gcc-14
i386                  randconfig-1011-20261007    gcc-14
i386                  randconfig-1012-20261007    gcc-14
i386                  randconfig-1013-20261007    gcc-14
i386                  randconfig-2100-20261006    clang-22   cocci
i386                  randconfig-2100-20261007    clang-22   cocci
i386                  randconfig-2101-20261006    clang-22   cocci
i386                  randconfig-2101-20261007    clang-22   cocci
i386                  randconfig-2102-20261006    clang-22   cocci
i386                  randconfig-2102-20261007    clang-22   cocci
i386                  randconfig-2103-20261006    clang-22   cocci
i386                  randconfig-2103-20261007    clang-22   cocci
i386                  randconfig-2200-20261006    gcc-13     smatch
i386                  randconfig-2200-20261007    gcc-14     smatch
i386                  randconfig-2300-20261006    gcc-14     sparse
i386                  randconfig-2300-20261007    clang-22   sparse
i386                  randconfig-2301-20261006    gcc-14     sparse
i386                  randconfig-2301-20261007    clang-22   sparse
i386                  randconfig-2302-20261006    gcc-14     sparse
i386                  randconfig-2302-20261007    clang-22   sparse
i386                 randconfig-r2101-20261006    clang-24   cocci
i386                 randconfig-r2105-20261006    gcc-16.1.0 cocci
i386                 randconfig-r2202-20261006    gcc-14     smatch
i386                 randconfig-r2300-20261006    gcc-14     sparse
i386                 randconfig-r2300-20261007    gcc-8.5.0  sparse
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.1.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261007    gcc-12.5.0
loongarch             randconfig-1001-20261007    gcc-12.5.0
loongarch            randconfig-r2106-20261006    gcc-8.5.0  cocci
loongarch            randconfig-r2200-20261006    clang-18   smatch
loongarch            randconfig-r2201-20261006    gcc-13.4.0 smatch
loongarch            randconfig-r2301-20261006    gcc-10.5.0 sparse
loongarch            randconfig-r2302-20261006    gcc-10.5.0 sparse
loongarch            randconfig-r2305-20261007    gcc-8.5.0  sparse
loongarch            randconfig-r2307-20261007    clang-24   sparse
loongarch            randconfig-r2308-20261006    gcc-8.5.0  sparse
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    clang-24
m68k                                 defconfig    clang-24
m68k                 randconfig-r2101-20261006    gcc-10.5.0 cocci
m68k                 randconfig-r2103-20261006    gcc-9.5.0  cocci
m68k                 randconfig-r2106-20261007    gcc-10.5.0 cocci
m68k                 randconfig-r2302-20261006    gcc-14     sparse
m68k                 randconfig-r2303-20261007    gcc-8.5.0  sparse
m68k                 randconfig-r2304-20261006    gcc-15.2.0 sparse
m68k                 randconfig-r2305-20261006    gcc-15.2.0 sparse
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    clang-24
microblaze           randconfig-r2104-20261006    gcc-11.5.0 cocci
microblaze           randconfig-r2301-20261006    gcc-10.5.0 sparse
microblaze           randconfig-r2303-20261006    gcc-15.2.0 sparse
microblaze           randconfig-r2306-20261006    clang-24   sparse
microblaze           randconfig-r2307-20261006    gcc-8.5.0  sparse
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                           ath79_defconfig    gcc-16.1.0
mips                   maltasmvp_eva_defconfig    gcc-16.1.0
mips                 randconfig-r2202-20261006    gcc-13.4.0 smatch
mips                 randconfig-r2301-20261006    gcc-14     sparse
mips                 randconfig-r2303-20261006    gcc-8.5.0  sparse
mips                 randconfig-r2305-20261006    gcc-10.5.0 sparse
mips                 randconfig-r2306-20261007    clang-17   sparse
mips                 randconfig-r2309-20261006    clang-20   sparse
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261007    gcc-12.5.0
nios2                 randconfig-1001-20261007    gcc-12.5.0
nios2                randconfig-r2100-20261006    gcc-10.5.0 cocci
nios2                randconfig-r2102-20261006    gcc-10.5.0 cocci
nios2                randconfig-r2105-20261007    gcc-10.5.0 cocci
nios2                randconfig-r2106-20261006    gcc-14.3.0 cocci
nios2                randconfig-r2107-20261006    gcc-11.5.0 cocci
nios2                randconfig-r2202-20261006    gcc-8.5.0  smatch
nios2                randconfig-r2300-20261006    gcc-10.5.0 sparse
nios2                randconfig-r2305-20261006    gcc-8.5.0  sparse
nios2                randconfig-r2306-20261006    gcc-8.5.0  sparse
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc                             defconfig    gcc-16.1.0
openrisc             randconfig-r2101-20261007    gcc-10.5.0 cocci
openrisc             randconfig-r2103-20261006    gcc-10.5.0 cocci
openrisc             randconfig-r2104-20261006    gcc-8.5.0  cocci
openrisc             randconfig-r2200-20261007    gcc-12.5.0 smatch
openrisc             randconfig-r2309-20261006    gcc-10.5.0 sparse
openrisc                        virt_defconfig    gcc-16.1.0
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20261007    gcc-15.2.0
parisc                randconfig-1001-20261007    gcc-15.2.0
parisc               randconfig-r2100-20261007    gcc-8.5.0  cocci
parisc               randconfig-r2201-20261006    gcc-8.5.0  smatch
parisc               randconfig-r2201-20261007    gcc-8.5.0  smatch
parisc               randconfig-r2309-20261007    clang-24   sparse
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    clang-24
powerpc                     ge_imp3a_defconfig    gcc-16.1.0
powerpc                         icon_defconfig    gcc-16.1.0
powerpc               randconfig-1000-20261007    gcc-15.2.0
powerpc               randconfig-1001-20261007    gcc-15.2.0
powerpc              randconfig-r2102-20261006    gcc-16.1.0 cocci
powerpc              randconfig-r2104-20261006    gcc-16.1.0 cocci
powerpc              randconfig-r2107-20261006    gcc-16.1.0 cocci
powerpc              randconfig-r2302-20261006    gcc-15.2.0 sparse
powerpc                  xes_mpc85xx_defconfig    gcc-16.1.0
powerpc64             randconfig-1000-20261007    gcc-15.2.0
powerpc64             randconfig-1001-20261007    gcc-15.2.0
powerpc64            randconfig-r2102-20261006    clang-24   cocci
powerpc64            randconfig-r2102-20261006    gcc-9.5.0  cocci
powerpc64            randconfig-r2103-20261007    gcc-10.5.0 cocci
powerpc64            randconfig-r2104-20261006    clang-24   cocci
powerpc64            randconfig-r2202-20261007    gcc-10.5.0 smatch
powerpc64            randconfig-r2301-20261006    gcc-15.2.0 sparse
powerpc64            randconfig-r2305-20261006    gcc-10.5.0 sparse
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.1.0
riscv                 randconfig-1000-20261007    clang-24
riscv                 randconfig-1001-20261007    clang-24
riscv                 randconfig-2000-20261006    gcc-16.1.0
riscv                 randconfig-2000-20261007    gcc-12.5.0
riscv                 randconfig-2001-20261006    gcc-16.1.0
riscv                 randconfig-2001-20261007    gcc-12.5.0
riscv                randconfig-r2105-20261006    gcc-8.5.0  cocci
riscv                randconfig-r2304-20261006    gcc-10.5.0 sparse
riscv                randconfig-r2304-20261007    gcc-8.5.0  sparse
riscv                randconfig-r2308-20261007    clang-17   sparse
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    gcc-16.1.0
s390                  randconfig-1000-20261007    clang-24
s390                  randconfig-1001-20261007    clang-24
s390                  randconfig-2000-20261006    gcc-16.1.0
s390                  randconfig-2000-20261007    gcc-12.5.0
s390                  randconfig-2001-20261006    gcc-16.1.0
s390                  randconfig-2001-20261007    gcc-12.5.0
s390                 randconfig-r2302-20261007    gcc-8.5.0  sparse
s390                 randconfig-r2306-20261006    clang-19   sparse
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                                   defconfig    gcc-14
sh                         dreamcast_defconfig    gcc-16.1.0
sh                    randconfig-1000-20261007    clang-24
sh                    randconfig-1001-20261007    clang-24
sh                    randconfig-2000-20261006    gcc-16.1.0
sh                    randconfig-2000-20261007    gcc-12.5.0
sh                    randconfig-2001-20261006    gcc-16.1.0
sh                    randconfig-2001-20261007    gcc-12.5.0
sh                   randconfig-r2107-20261006    gcc-14.3.0 cocci
sh                   randconfig-r2302-20261006    gcc-8.5.0  sparse
sh                   randconfig-r2304-20261006    gcc-8.5.0  sparse
sh                   randconfig-r2308-20261006    clang-20   sparse
sh                           rsk7264_defconfig    gcc-16.1.0
sh                    secureedge5410_defconfig    gcc-16.1.0
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20261007    clang-17
sparc                 randconfig-1001-20261007    clang-17
sparc                 randconfig-2000-20261006    clang-24
sparc                 randconfig-2000-20261007    clang-24
sparc                 randconfig-2001-20261006    clang-24
sparc                 randconfig-2001-20261007    clang-24
sparc                randconfig-r2100-20261006    clang-24   cocci
sparc                randconfig-r2201-20261006    gcc-16.1.0 smatch
sparc                randconfig-r2300-20261006    gcc-8.5.0  sparse
sparc                randconfig-r2302-20261006    gcc-10.5.0 sparse
sparc                randconfig-r2303-20261006    gcc-10.5.0 sparse
sparc                randconfig-r2304-20261006    gcc-14     sparse
sparc                randconfig-r2306-20261006    clang-20   sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261007    clang-17
sparc64               randconfig-1001-20261007    clang-17
sparc64               randconfig-2000-20261006    clang-24
sparc64               randconfig-2000-20261007    clang-24
sparc64               randconfig-2001-20261006    clang-24
sparc64               randconfig-2001-20261007    clang-24
sparc64              randconfig-r2100-20261006    gcc-9.5.0  cocci
sparc64              randconfig-r2106-20261006    gcc-11.5.0 cocci
sparc64              randconfig-r2308-20261006    gcc-10.5.0 sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.1.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261007    clang-17
um                    randconfig-1001-20261007    clang-17
um                    randconfig-2000-20261006    clang-24
um                    randconfig-2000-20261007    clang-24
um                    randconfig-2001-20261006    clang-24
um                    randconfig-2001-20261007    clang-24
um                   randconfig-r2105-20261006    gcc-11.5.0 cocci
um                   randconfig-r2107-20261006    gcc-8.5.0  cocci
um                   randconfig-r2202-20261006    clang-24   smatch
um                   randconfig-r2202-20261007    clang-24   smatch
um                   randconfig-r2302-20261006    gcc-8.5.0  sparse
um                   randconfig-r2303-20261006    gcc-14     sparse
um                   randconfig-r2305-20261006    gcc-14     sparse
um                   randconfig-r2309-20261006    clang-19   sparse
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20261007    gcc-14
x86_64      buildonly-randconfig-1001-20261007    gcc-14
x86_64      buildonly-randconfig-1002-20261007    gcc-14
x86_64      buildonly-randconfig-1003-20261007    gcc-14
x86_64      buildonly-randconfig-1004-20261007    gcc-14
x86_64      buildonly-randconfig-1005-20261007    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261007    clang-22
x86_64                randconfig-1001-20261007    clang-22
x86_64                randconfig-1002-20261007    clang-22
x86_64                randconfig-1003-20261007    clang-22
x86_64                randconfig-1004-20261007    clang-22
x86_64                randconfig-1005-20261007    clang-22
x86_64                randconfig-1006-20261007    clang-22
x86_64                randconfig-1007-20261007    clang-22
x86_64                randconfig-1008-20261007    clang-22
x86_64                randconfig-1009-20261007    clang-22
x86_64                randconfig-1010-20261007    clang-22
x86_64                randconfig-1011-20261007    clang-22
x86_64                randconfig-1012-20261007    gcc-12
x86_64                randconfig-1013-20261007    gcc-12
x86_64                randconfig-1014-20261007    gcc-12
x86_64                randconfig-1015-20261007    gcc-12
x86_64                randconfig-1016-20261007    gcc-12
x86_64                randconfig-1017-20261007    gcc-12
x86_64                randconfig-2100-20261006    clang-22   cocci
x86_64                randconfig-2100-20261007    clang-22   cocci
x86_64                randconfig-2101-20261006    clang-22   cocci
x86_64                randconfig-2101-20261007    clang-22   cocci
x86_64                randconfig-2102-20261006    clang-22   cocci
x86_64                randconfig-2102-20261007    clang-22   cocci
x86_64                randconfig-2103-20261006    clang-22   cocci
x86_64                randconfig-2103-20261007    clang-22   cocci
x86_64                randconfig-2200-20261006    clang-22   smatch
x86_64                randconfig-2200-20261007    gcc-14     smatch
x86_64                randconfig-2300-20261006    gcc-14     sparse
x86_64                randconfig-2300-20261007    clang-22   sparse
x86_64                randconfig-2301-20261006    gcc-14     sparse
x86_64                randconfig-2301-20261007    clang-22   sparse
x86_64                randconfig-2302-20261006    gcc-14     sparse
x86_64                randconfig-2302-20261007    clang-22   sparse
x86_64               randconfig-r2106-20261006    gcc-16.1.0 cocci
x86_64               randconfig-r2107-20261007    gcc-10.5.0 cocci
x86_64               randconfig-r2200-20261006    clang-22   smatch
x86_64               randconfig-r2301-20261006    gcc-8.5.0  sparse
x86_64               randconfig-r2307-20261006    clang-20   sparse
x86_64               randconfig-r2308-20261007    clang-24   sparse
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
xtensa                randconfig-1000-20261007    clang-17
xtensa                randconfig-1001-20261007    clang-17
xtensa                randconfig-2000-20261006    clang-24
xtensa                randconfig-2000-20261007    clang-24
xtensa                randconfig-2001-20261006    clang-24
xtensa                randconfig-2001-20261007    clang-24
xtensa               randconfig-r2100-20261006    gcc-16.1.0 cocci
xtensa               randconfig-r2103-20261007    gcc-8.5.0  cocci
xtensa               randconfig-r2200-20261006    gcc-9.5.0  smatch
xtensa               randconfig-r2306-20261006    gcc-10.5.0 sparse
xtensa               randconfig-r2307-20261006    clang-24   sparse
xtensa               randconfig-r2307-20261007    clang-17   sparse
xtensa               randconfig-r2309-20261006    gcc-8.5.0  sparse

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
