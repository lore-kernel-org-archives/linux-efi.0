Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A524A3F1C
	for <linux-efi@vger.kernel.org>; Tue, 22 Sep 2026 19:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790105187; cv=none; b=ovo2LDYF8jdKfbwJ7pSUS9KuRGdD3maTjRfKMTUqXtsWNdsYJAuljNh+6+klL6j49R5YtCsIXjWU9LbrqXBWuj6m0phF+FQCcm+kCH+lo55i+UnTs9bgSoROlupGlCuXXGyyztIVCoAgl6uoaSpu5gCAdJbQRhRSa5fJfW5B+Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790105187; c=relaxed/simple;
	bh=BfmowparXrZTRCH10iYZaJ4rnxI8TYaR5NXZnnSFwUc=;
	h=Date:From:To:Cc:Subject:Message-ID; b=ofeyzN426r47pl6GIJdg9O+rkzKed3XLGf34eWaoGVvPtZkUUXUAKtq9hWCrAXzxfpFZpd2N6oe8I2fZQwE+BOevL/SKqIEaZRy4s0GLEsf3dy0WHiHi/5ucg5zyE5jwlw72chL1LrLFYPYsloX8URjZdYPzumoYobY9bJymvIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LgDPzj5s; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LgDPzj5s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790105185; x=1821641185;
  h=date:from:to:cc:subject:message-id;
  bh=BfmowparXrZTRCH10iYZaJ4rnxI8TYaR5NXZnnSFwUc=;
  b=LgDPzj5sVt98/C21OKMhHU/q6O6qtz74SSQGWuwW7C5T+/ORhobUJntj
   8l/ui6TnuzwkCQOxhqkhoQiRtiLVeePTkNR9bg4o6AKaSAlIchKlfhAmg
   FmIMibLtHCZC0vBhO4IAWjbtUk9XMt+0YoUrgXZtSt2IFR3R+tzlciLeA
   BdR+ZysSd47EapB9UCsNIsYlOfXyRzWs4Gbm77bIk9JNSwSWvwjSkbimu
   pBOeSt2hRs40KysWzinsk+0sCkvEJMultMbGk6GepBGaxtrDqlOl1yR1D
   XiXqRpiz2TYZkTaFiQC6yO2HyLFKnm1TzS+szLiKV7+zNlodyzZUQr6jr
   w==;
X-CSE-ConnectionGUID: te06E4ADSe+ppyvbLrQDMA==
X-CSE-MsgGUID: 2aoYe5rCTIqXClxsGCYJwg==
X-IronPort-AV: E=McAfee;i="6800,10657,11913"; a="90858482"
X-IronPort-AV: E=Sophos;i="6.27,117,1787036400"; 
   d="scan'208";a="90858482"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 12:26:04 -0700
X-CSE-ConnectionGUID: zI/QO2haSsiqwytlWZmgoQ==
X-CSE-MsgGUID: 8IoZc2sgTBCvVPi1vpWMtA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,117,1787036400"; 
   d="scan'208";a="4284364"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa012.fm.intel.com with ESMTP; 22 Sep 2026 12:26:01 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x967q-00000000Fz0-2gSe;
	Tue, 22 Sep 2026 19:25:58 +0000
Date: Wed, 23 Sep 2026 03:25:52 +0800
From: kernel test robot <lkp@intel.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org
Subject: [efi:bootloader-info] BUILD REGRESSION
 9925e4ce78365f6378ae7facdc987b0b4ef67d37
Message-ID: <202609230345.8BNmKJ79-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git bootloader-info
branch HEAD: 9925e4ce78365f6378ae7facdc987b0b4ef67d37  efi/libstub: add initial Boot Loader Interface support

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202609201125.Q6uy2t2V-lkp@intel.com

    error.c:(.text.unlikely+0x24): undefined reference to `vsnprintf'
    error.c:(.text.unlikely+0x52): undefined reference to `vsnprintf'

Error/Warning ids grouped by kconfigs:

recent_errors
|-- i386-randconfig-1013-20260922
|   `-- error.c:(.text.unlikely):undefined-reference-to-vsnprintf
|-- x86_64-buildonly-randconfig-1001-20260922
|   `-- error.c:(.text.unlikely):undefined-reference-to-vsnprintf
`-- x86_64-defconfig
    `-- error.c:(.text.unlikely):undefined-reference-to-vsnprintf

elapsed time: 4579m

configs tested: 243
configs skipped: 7

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
arc                               allmodconfig    gcc-16.1.0
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    gcc-16.1.0
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20260922    gcc-8.5.0
arc                   randconfig-1001-20260922    gcc-16.1.0
arm                                allnoconfig    clang-17
arm                                allnoconfig    gcc-16.1.0
arm                               allyesconfig    gcc-16.1.0
arm                                  defconfig    clang-24
arm                    milbeaut_m10v_defconfig    clang-17
arm                         multi_v7_defconfig    clang-20
arm                          nhk8815_defconfig    clang-24
arm                   randconfig-1000-20260922    gcc-16.1.0
arm                   randconfig-1001-20260922    gcc-10.5.0
arm                   randconfig-1002-20260922    clang-24
arm                   randconfig-1003-20260922    gcc-8.5.0
arm                  randconfig-r1305-20260922    clang-24   sparse
arm                  randconfig-r1309-20260922    clang-24   sparse
arm                         spear3xx_defconfig    clang-20
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20260922    clang-24
arm64                 randconfig-1001-20260922    gcc-11.5.0
arm64                 randconfig-1002-20260922    gcc-9.5.0
arm64                 randconfig-1003-20260922    gcc-11.5.0
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20260922    gcc-16.1.0
csky                  randconfig-1001-20260922    gcc-12.5.0
csky                 randconfig-r2107-20260917    gcc-9.5.0  cocci
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                            allnoconfig    gcc-16.1.0
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20260922    clang-17
hexagon               randconfig-1001-20260922    clang-17
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386                               allnoconfig    gcc-16.1.0
i386        buildonly-randconfig-1000-20260922    clang-22
i386        buildonly-randconfig-1001-20260922    clang-22
i386        buildonly-randconfig-1002-20260922    gcc-14
i386        buildonly-randconfig-1003-20260922    gcc-14
i386        buildonly-randconfig-1004-20260922    gcc-14
i386        buildonly-randconfig-1005-20260922    gcc-12
i386                                 defconfig    clang-22
i386                  randconfig-1000-20260922    clang-22
i386                  randconfig-1001-20260922    clang-22
i386                  randconfig-1002-20260922    clang-22
i386                  randconfig-1003-20260922    gcc-14
i386                  randconfig-1004-20260922    gcc-14
i386                  randconfig-1005-20260922    gcc-14
i386                  randconfig-1006-20260922    gcc-14
i386                  randconfig-1007-20260922    clang-22
i386                  randconfig-1008-20260922    gcc-14
i386                  randconfig-1009-20260922    gcc-14
i386                  randconfig-1010-20260922    clang-22
i386                  randconfig-1011-20260922    gcc-14
i386                  randconfig-1012-20260922    gcc-13
i386                  randconfig-1013-20260922    gcc-14
i386                  randconfig-1300-20260922    clang-22   sparse
i386                  randconfig-1301-20260922    clang-22   sparse
i386                  randconfig-1302-20260922    gcc-14     sparse
i386                  randconfig-2200-20260917    clang-22   smatch
i386                 randconfig-r2105-20260917    gcc-14     cocci
i386                 randconfig-r2200-20260917    clang-22   smatch
loongarch                         allmodconfig    clang-19
loongarch                          allnoconfig    clang-20
loongarch                          allnoconfig    gcc-16.1.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20260922    gcc-16.1.0
loongarch             randconfig-1001-20260922    clang-18
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    gcc-16.1.0
m68k                                 defconfig    clang-24
m68k                                 defconfig    gcc-16.1.0
m68k                       m54418evb_defconfig    gcc-16.1.0
m68k                        m5475evb_defconfig    clang-20
m68k                 randconfig-r1306-20260922    gcc-16.1.0 sparse
m68k                 randconfig-r2102-20260917    gcc-14.3.0 cocci
m68k                 randconfig-r2202-20260917    gcc-8.5.0  smatch
microblaze                        alldefconfig    clang-24
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    clang-24
microblaze                           defconfig    gcc-16.1.0
microblaze           randconfig-r1301-20260922    gcc-8.5.0  sparse
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                         bcm47xx_defconfig    clang-24
mips                            ip27_defconfig    gcc-16.1.0
mips                         qi_lb60_defconfig    clang-24
mips                 randconfig-r1300-20260922    gcc-15.2.0 sparse
mips                    sb1250_swarm_defconfig    clang-24
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    clang-24
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    clang-24
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20260922    gcc-10.5.0
nios2                 randconfig-1001-20260922    gcc-11.5.0
openrisc                          allmodconfig    gcc-16.1.0
openrisc                           allnoconfig    clang-24
openrisc                           allnoconfig    gcc-16.1.0
openrisc                             defconfig    gcc-16.1.0
openrisc             randconfig-r1302-20260922    gcc-11.5.0 sparse
openrisc             randconfig-r1303-20260922    gcc-13.4.0 sparse
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    clang-24
parisc                             allnoconfig    gcc-16.1.0
parisc                            allyesconfig    gcc-16.1.0
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20260922    gcc-12.5.0
parisc                randconfig-1000-20260923    clang-22
parisc                randconfig-1001-20260922    gcc-10.5.0
parisc                randconfig-1001-20260923    clang-22
parisc64                             defconfig    clang-24
parisc64                             defconfig    gcc-16.1.0
powerpc                            allnoconfig    clang-24
powerpc                            allnoconfig    gcc-16.1.0
powerpc                    bluestone_defconfig    clang-24
powerpc                      mpc83xx_defconfig    clang-24
powerpc                       pmac32_defconfig    clang-24
powerpc                       ppc44x_defconfig    clang-17
powerpc               randconfig-1000-20260922    gcc-11.5.0
powerpc               randconfig-1000-20260923    clang-22
powerpc               randconfig-1001-20260922    gcc-8.5.0
powerpc               randconfig-1001-20260923    clang-22
powerpc                     socrates_defconfig    clang-24
powerpc                   storcenter_defconfig    clang-20
powerpc                      tqm8555_defconfig    gcc-16.1.0
powerpc                       tqm8xx_defconfig    clang-20
powerpc64             randconfig-1000-20260922    gcc-8.5.0
powerpc64             randconfig-1000-20260923    clang-22
powerpc64             randconfig-1001-20260922    gcc-11.5.0
powerpc64             randconfig-1001-20260923    clang-22
powerpc64            randconfig-r1308-20260922    gcc-10.5.0 sparse
powerpc64            randconfig-r2104-20260917    gcc-8.5.0  cocci
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                              allnoconfig    gcc-16.1.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                 randconfig-1000-20260922    gcc-8.5.0
riscv                 randconfig-1001-20260922    gcc-13.4.0
riscv                 randconfig-2000-20260917    clang-24
riscv                 randconfig-2001-20260917    clang-17
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                                 defconfig    clang-18
s390                  randconfig-1000-20260922    clang-19
s390                  randconfig-1001-20260922    clang-21
s390                  randconfig-2000-20260917    clang-17
s390                  randconfig-2001-20260917    clang-24
s390                 randconfig-r2101-20260917    clang-24   cocci
s390                 randconfig-r2106-20260917    gcc-15.2.0 cocci
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    clang-24
sh                                 allnoconfig    gcc-16.1.0
sh                                allyesconfig    gcc-16.1.0
sh                                   defconfig    gcc-16.1.0
sh                          ecovec24_defconfig    clang-24
sh                           lboxre2_defconfig    gcc-16.1.0
sh                           r7785rp_defconfig    clang-20
sh                    randconfig-1000-20260922    gcc-10.5.0
sh                    randconfig-1001-20260922    gcc-16.1.0
sh                    randconfig-2000-20260917    gcc-14.3.0
sh                    randconfig-2001-20260917    gcc-16.1.0
sh                   randconfig-r2201-20260917    gcc-13.4.0 smatch
sh                            se7343_defconfig    clang-20
sparc                             alldefconfig    clang-20
sparc                              allnoconfig    clang-24
sparc                              allnoconfig    gcc-16.1.0
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20260922    gcc-14.3.0
sparc                 randconfig-1001-20260922    gcc-8.5.0
sparc                randconfig-r1304-20260922    gcc-8.5.0  sparse
sparc                randconfig-r1307-20260922    gcc-16.1.0 sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20260922    gcc-15.2.0
sparc64               randconfig-1001-20260922    clang-20
sparc64              randconfig-r2100-20260917    clang-24   cocci
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20260922    gcc-14
um                    randconfig-1001-20260922    clang-17
um                            x86_64_defconfig    clang-24
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20260922    gcc-14
x86_64      buildonly-randconfig-1001-20260922    gcc-14
x86_64      buildonly-randconfig-1002-20260922    gcc-14
x86_64      buildonly-randconfig-1003-20260922    clang-22
x86_64      buildonly-randconfig-1004-20260922    clang-22
x86_64      buildonly-randconfig-1005-20260922    gcc-14
x86_64                               defconfig    gcc-14
x86_64                randconfig-1000-20260922    gcc-12
x86_64                randconfig-1001-20260922    clang-22
x86_64                randconfig-1002-20260922    clang-22
x86_64                randconfig-1003-20260922    clang-22
x86_64                randconfig-1004-20260922    clang-22
x86_64                randconfig-1005-20260922    gcc-14
x86_64                randconfig-1006-20260922    clang-22
x86_64                randconfig-1007-20260922    gcc-14
x86_64                randconfig-1008-20260922    clang-22
x86_64                randconfig-1009-20260922    clang-22
x86_64                randconfig-1010-20260922    gcc-14
x86_64                randconfig-1011-20260922    clang-22
x86_64                randconfig-1012-20260922    clang-22
x86_64                randconfig-1013-20260922    gcc-14
x86_64                randconfig-1014-20260922    clang-22
x86_64                randconfig-1015-20260922    clang-22
x86_64                randconfig-1016-20260922    gcc-14
x86_64                randconfig-1017-20260922    clang-22
x86_64                randconfig-1300-20260922    gcc-13     sparse
x86_64                randconfig-1301-20260922    gcc-13     sparse
x86_64                randconfig-1302-20260922    clang-22   sparse
x86_64                randconfig-2100-20260917    clang-22   cocci
x86_64                randconfig-2101-20260917    gcc-14     cocci
x86_64                randconfig-2102-20260917    gcc-14     cocci
x86_64                randconfig-2103-20260917    gcc-13     cocci
x86_64                randconfig-2200-20260917    gcc-14     smatch
x86_64               randconfig-r2103-20260917    clang-22   cocci
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                             allnoconfig    gcc-16.1.0
xtensa                            allyesconfig    gcc-16.1.0
xtensa                randconfig-1000-20260922    gcc-12.5.0
xtensa                randconfig-1001-20260922    gcc-10.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
