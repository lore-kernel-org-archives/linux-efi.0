Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD8F4F473F
	for <linux-efi@vger.kernel.org>; Wed, 30 Sep 2026 13:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790774514; cv=none; b=r0Jfc+qgfk9eyK6u13ULFtIBH8GG/hf+XrczHysqjvqe5EuA+XfbeHLDF3viw0pG0vra9IpomRcNHUgpnvtl1BsFIHb9vo0dYzOd5nLr8mFFRV3xtO4ipEZVEasSuelTIXuyifx78UWDyFI1BGXlfaowqZwuuLBs4wwWYBmEXuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790774514; c=relaxed/simple;
	bh=jUbHTPzR79ozvPBZts3LQD8cqTQRunDgBnDkixWi1gw=;
	h=Date:From:To:Cc:Subject:Message-ID; b=juSDi9kvxISZ6ZjwiMmXPeIXmkWSE4oVrM8pVjnT2YneJl53l2E7bbg1oQh9/Kn3mba/XNnZcLWeTfhumbaV+2ff/uJ4OuTLImDMjwFV4V2n/t7X64ZCdwrWPosuxk8Gkfg0kyI7pDQw0ZFGg4chXmr6Ss0wNTgZzAKiBQ1dzLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=epS5ZIKX; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="epS5ZIKX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790774507; x=1822310507;
  h=date:from:to:cc:subject:message-id;
  bh=jUbHTPzR79ozvPBZts3LQD8cqTQRunDgBnDkixWi1gw=;
  b=epS5ZIKXvgP7lQa4OFmLZ/jyR5G4EUnJu6JXe+J5F13eT8ljLhnm3juL
   KyKNgTKPgvGA7+m9wdDrU8jc0SX3PD3g+PM4/W8H6N0RI5lhm+MvmyjZN
   2XHQsHe2YvLZOHzblv1Lz/xstCnHjalu6QNmRQSsSqDXJL3iTGnABPfFH
   rf4rtgLbDLtiWm69PHCRzKfqIaVd+hxlt6EfLy0gJO8lxrjM9r7yAenDb
   8XXsVEV3XAWY4aJhfaLG5EF/cbdxzpGOYSTXAP8iFMoXFvHmoXQEuQvzw
   sq+xsPRKuDeoha1bcMkKznFs30qJCdP05tM8GlsM6GapM7j+oZIBBwLWx
   Q==;
X-CSE-ConnectionGUID: KWj8+vWvQ0W3qa/34GQU8A==
X-CSE-MsgGUID: 1Y0NNViQSqW6oOBulY93Ww==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="95321002"
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="95321002"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 06:21:44 -0700
X-CSE-ConnectionGUID: t9cGdB67SDSVBJMHmHR2iw==
X-CSE-MsgGUID: iGqkNZB9RlKCWwEtXkAqgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="280440146"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 30 Sep 2026 06:21:42 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xBuFf-00000000QfN-3lWq;
	Wed, 30 Sep 2026 13:21:39 +0000
Date: Wed, 30 Sep 2026 21:21:25 +0800
From: kernel test robot <lkp@intel.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org
Subject: [efi:next] BUILD SUCCESS
 7eef16311a234b5d77c1493e19c6538a3aa1a203
Message-ID: <202609302121.t1XClUPp-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git next
branch HEAD: 7eef16311a234b5d77c1493e19c6538a3aa1a203  Merge remote-tracking branch 'linux-efi/bootloader-info' into next

elapsed time: 945m

configs tested: 362
configs skipped: 5

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r2302-20260929    gcc-12.5.0 sparse
alpha                randconfig-r2303-20260929    gcc-12.5.0 sparse
alpha                randconfig-r2307-20260929    gcc-14.3.0 sparse
alpha                randconfig-r2309-20260929    gcc-13.4.0 sparse
arc                               allmodconfig    clang-24
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    clang-24
arc                                  defconfig    gcc-16.1.0
arc                         nsim_700_defconfig    gcc-16.1.0
arc                   randconfig-1000-20260930    gcc-11.5.0
arc                   randconfig-1001-20260930    gcc-11.5.0
arc                  randconfig-r2100-20260929    clang-24   cocci
arc                  randconfig-r2101-20260930    gcc-16.1.0 cocci
arc                  randconfig-r2102-20260929    gcc-9.5.0  cocci
arc                  randconfig-r2105-20260929    gcc-13.4.0 cocci
arc                  randconfig-r2301-20260929    clang-21   sparse
arc                  randconfig-r2301-20260930    clang-24   sparse
arc                  randconfig-r2302-20260929    gcc-8.5.0  sparse
arc                  randconfig-r2307-20260929    gcc-13.4.0 sparse
arm                                allnoconfig    gcc-16.1.0
arm                               allyesconfig    clang-24
arm                                  defconfig    gcc-16.1.0
arm                             dove_defconfig    gcc-16.1.0
arm                             mmp2_defconfig    gcc-16.1.0
arm                         mvebu_v5_defconfig    gcc-16.1.0
arm                   randconfig-1000-20260930    gcc-11.5.0
arm                   randconfig-1001-20260930    gcc-11.5.0
arm                   randconfig-1002-20260930    gcc-11.5.0
arm                   randconfig-1003-20260930    gcc-11.5.0
arm                  randconfig-r2103-20260929    gcc-15.2.0 cocci
arm                  randconfig-r2106-20260929    gcc-10.5.0 cocci
arm                  randconfig-r2106-20260930    clang-21   cocci
arm                  randconfig-r2202-20260929    clang-17   smatch
arm                  randconfig-r2305-20260929    gcc-12.5.0 sparse
arm                  randconfig-r2305-20260929    gcc-8.5.0  sparse
arm                  randconfig-r2306-20260930    clang-24   sparse
arm                  randconfig-r2308-20260929    gcc-13.4.0 sparse
arm                  randconfig-r2308-20260929    gcc-9.5.0  sparse
arm                            sama5_defconfig    gcc-16.1.0
arm                         spear6xx_defconfig    gcc-16.1.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20260930    gcc-16.1.0
arm64                 randconfig-1001-20260930    gcc-16.1.0
arm64                 randconfig-1002-20260930    gcc-16.1.0
arm64                 randconfig-1003-20260930    gcc-16.1.0
arm64                randconfig-r2102-20260929    clang-24   cocci
arm64                randconfig-r2301-20260929    gcc-12.5.0 sparse
arm64                randconfig-r2305-20260929    clang-21   sparse
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20260930    gcc-16.1.0
csky                  randconfig-1001-20260930    gcc-16.1.0
csky                 randconfig-r2105-20260929    gcc-16.1.0 cocci
csky                 randconfig-r2107-20260929    gcc-16.1.0 cocci
csky                 randconfig-r2200-20260929    gcc-14.3.0 smatch
csky                 randconfig-r2300-20260929    gcc-12.5.0 sparse
csky                 randconfig-r2307-20260929    clang-22   sparse
csky                 randconfig-r2309-20260929    clang-22   sparse
hexagon                           allmodconfig    gcc-16.1.0
hexagon                            allnoconfig    gcc-16.1.0
hexagon                              defconfig    gcc-16.1.0
hexagon               randconfig-1000-20260930    clang-24
hexagon               randconfig-1001-20260930    clang-24
hexagon              randconfig-r2103-20260930    gcc-16.1.0 cocci
hexagon              randconfig-r2106-20260929    clang-24   cocci
hexagon              randconfig-r2201-20260929    clang-19   smatch
hexagon              randconfig-r2202-20260929    clang-17   smatch
hexagon              randconfig-r2306-20260929    gcc-9.5.0  sparse
i386                              alldefconfig    gcc-16.1.0
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-16.1.0
i386        buildonly-randconfig-1000-20260930    gcc-14
i386        buildonly-randconfig-1001-20260930    gcc-14
i386        buildonly-randconfig-1002-20260930    gcc-14
i386        buildonly-randconfig-1003-20260930    gcc-14
i386        buildonly-randconfig-1004-20260930    gcc-14
i386        buildonly-randconfig-1005-20260930    gcc-14
i386                                 defconfig    gcc-16.1.0
i386                  randconfig-1000-20260930    gcc-14
i386                  randconfig-1001-20260930    gcc-14
i386                  randconfig-1002-20260930    gcc-14
i386                  randconfig-1003-20260930    gcc-14
i386                  randconfig-1004-20260930    gcc-14
i386                  randconfig-1005-20260930    gcc-14
i386                  randconfig-1006-20260930    gcc-14
i386                  randconfig-1007-20260930    clang-22
i386                  randconfig-1008-20260930    clang-22
i386                  randconfig-1009-20260930    clang-22
i386                  randconfig-1010-20260930    clang-22
i386                  randconfig-1011-20260930    clang-22
i386                  randconfig-1012-20260930    clang-22
i386                  randconfig-1013-20260930    clang-22
i386                  randconfig-2100-20260929    clang-22   cocci
i386                  randconfig-2100-20260930    clang-22   cocci
i386                  randconfig-2101-20260929    clang-22   cocci
i386                  randconfig-2101-20260930    clang-22   cocci
i386                  randconfig-2102-20260929    clang-22   cocci
i386                  randconfig-2102-20260930    clang-22   cocci
i386                  randconfig-2103-20260929    clang-22   cocci
i386                  randconfig-2103-20260930    clang-22   cocci
i386                  randconfig-2200-20260929    gcc-14     smatch
i386                  randconfig-2200-20260930    gcc-14     smatch
i386                  randconfig-2300-20260929    gcc-14     sparse
i386                  randconfig-2300-20260930    gcc-13     sparse
i386                  randconfig-2301-20260929    gcc-14     sparse
i386                  randconfig-2301-20260930    gcc-13     sparse
i386                  randconfig-2302-20260929    gcc-14     sparse
i386                  randconfig-2302-20260930    gcc-13     sparse
i386                 randconfig-r2102-20260929    gcc-16.1.0 cocci
i386                 randconfig-r2102-20260930    gcc-16.1.0 cocci
i386                 randconfig-r2104-20260929    gcc-10.5.0 cocci
i386                 randconfig-r2106-20260929    gcc-16.1.0 cocci
i386                 randconfig-r2202-20260930    gcc-13     smatch
i386                 randconfig-r2306-20260929    gcc-14.3.0 sparse
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.1.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20260930    clang-24
loongarch             randconfig-1001-20260930    clang-24
loongarch            randconfig-r2200-20260929    clang-24   smatch
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    clang-24
m68k                           atari_defconfig    gcc-16.1.0
m68k                        bvme6000_defconfig    gcc-16.1.0
m68k                                 defconfig    clang-24
m68k                           hp300_defconfig    gcc-16.1.0
m68k                        m5475evb_defconfig    gcc-16.1.0
m68k                 randconfig-r2101-20260929    clang-24   cocci
m68k                 randconfig-r2300-20260930    clang-24   sparse
m68k                 randconfig-r2304-20260929    gcc-8.5.0  sparse
m68k                 randconfig-r2305-20260929    gcc-12.5.0 sparse
m68k                 randconfig-r2306-20260929    clang-22   sparse
m68k                            virt_defconfig    gcc-16.1.0
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    clang-24
microblaze           randconfig-r2200-20260930    gcc-11.5.0 smatch
microblaze           randconfig-r2201-20260929    gcc-13.4.0 smatch
microblaze           randconfig-r2300-20260929    gcc-8.5.0  sparse
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                         bcm63xx_defconfig    gcc-16.1.0
mips                          bigsur_defconfig    gcc-16.1.0
mips                   cavium_octeon_defconfig    gcc-16.1.0
mips                      loongson2k_defconfig    gcc-16.1.0
mips                       maltasmvp_defconfig    gcc-16.1.0
mips                         qi_lb60_defconfig    gcc-16.1.0
mips                 randconfig-r2103-20260929    clang-24   cocci
mips                 randconfig-r2104-20260929    gcc-13.4.0 cocci
mips                 randconfig-r2306-20260929    gcc-13.4.0 sparse
mips                 randconfig-r2308-20260930    clang-24   sparse
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20260930    clang-24
nios2                 randconfig-1001-20260930    clang-24
nios2                randconfig-r2202-20260929    gcc-10.5.0 smatch
nios2                randconfig-r2309-20260929    gcc-9.5.0  sparse
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc                             defconfig    gcc-16.1.0
openrisc             randconfig-r2100-20260929    gcc-9.5.0  cocci
openrisc             randconfig-r2100-20260930    gcc-16.1.0 cocci
openrisc             randconfig-r2103-20260929    gcc-16.1.0 cocci
openrisc             randconfig-r2104-20260929    clang-24   cocci
openrisc             randconfig-r2107-20260929    gcc-10.5.0 cocci
openrisc             randconfig-r2303-20260929    clang-21   sparse
openrisc             randconfig-r2304-20260929    gcc-12.5.0 sparse
openrisc             randconfig-r2309-20260930    clang-24   sparse
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20260930    gcc-8.5.0
parisc                randconfig-1001-20260930    gcc-8.5.0
parisc               randconfig-r2100-20260929    gcc-15.2.0 cocci
parisc               randconfig-r2101-20260929    gcc-9.5.0  cocci
parisc               randconfig-r2200-20260929    gcc-14.3.0 smatch
parisc               randconfig-r2301-20260929    gcc-12.5.0 sparse
parisc               randconfig-r2303-20260929    gcc-12.5.0 sparse
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    clang-24
powerpc                  canyonlands_defconfig    gcc-16.1.0
powerpc                         fsp2_defconfig    gcc-16.1.0
powerpc                       ppc64e_defconfig    gcc-16.1.0
powerpc               randconfig-1000-20260930    gcc-8.5.0
powerpc               randconfig-1001-20260930    gcc-8.5.0
powerpc              randconfig-r2102-20260929    gcc-15.2.0 cocci
powerpc              randconfig-r2103-20260929    gcc-9.5.0  cocci
powerpc              randconfig-r2104-20260929    gcc-16.1.0 cocci
powerpc              randconfig-r2105-20260930    clang-21   cocci
powerpc              randconfig-r2201-20260929    gcc-10.5.0 smatch
powerpc              randconfig-r2201-20260930    gcc-14.3.0 smatch
powerpc              randconfig-r2302-20260930    clang-24   sparse
powerpc                      sequoia_defconfig    gcc-16.1.0
powerpc                      tqm8548_defconfig    gcc-16.1.0
powerpc64             randconfig-1000-20260930    gcc-8.5.0
powerpc64             randconfig-1001-20260930    gcc-8.5.0
powerpc64            randconfig-r2100-20260929    gcc-16.1.0 cocci
powerpc64            randconfig-r2107-20260930    clang-21   cocci
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.1.0
riscv                     nommu_k210_defconfig    gcc-16.1.0
riscv                 randconfig-1000-20260930    gcc-16.1.0
riscv                 randconfig-1001-20260930    gcc-16.1.0
riscv                 randconfig-2000-20260929    gcc-11.5.0
riscv                 randconfig-2000-20260930    gcc-14.3.0
riscv                 randconfig-2001-20260929    gcc-11.5.0
riscv                 randconfig-2001-20260930    gcc-14.3.0
riscv                randconfig-r2101-20260929    gcc-15.2.0 cocci
riscv                randconfig-r2202-20260929    clang-24   smatch
riscv                randconfig-r2304-20260929    clang-21   sparse
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    gcc-16.1.0
s390                  randconfig-1000-20260930    gcc-16.1.0
s390                  randconfig-1001-20260930    gcc-16.1.0
s390                  randconfig-2000-20260929    gcc-11.5.0
s390                  randconfig-2000-20260930    gcc-14.3.0
s390                  randconfig-2001-20260929    gcc-11.5.0
s390                  randconfig-2001-20260930    gcc-14.3.0
s390                 randconfig-r2101-20260929    gcc-16.1.0 cocci
s390                 randconfig-r2105-20260929    clang-24   cocci
s390                 randconfig-r2105-20260929    gcc-10.5.0 cocci
s390                 randconfig-r2304-20260930    clang-24   sparse
s390                 randconfig-r2307-20260930    clang-24   sparse
s390                 randconfig-r2309-20260929    gcc-14.3.0 sparse
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                                   defconfig    gcc-14
sh                              espt_defconfig    gcc-16.1.0
sh                             hp6xx_defconfig    gcc-16.1.0
sh                           r7780mp_defconfig    gcc-16.1.0
sh                    randconfig-1000-20260930    gcc-16.1.0
sh                    randconfig-1001-20260930    gcc-16.1.0
sh                    randconfig-2000-20260929    gcc-11.5.0
sh                    randconfig-2000-20260930    gcc-14.3.0
sh                    randconfig-2001-20260929    gcc-11.5.0
sh                    randconfig-2001-20260930    gcc-14.3.0
sh                            se7619_defconfig    gcc-16.1.0
sh                           urquell_defconfig    gcc-16.1.0
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20260930    clang-22
sparc                 randconfig-1001-20260930    clang-22
sparc                 randconfig-2000-20260929    gcc-12.5.0
sparc                 randconfig-2000-20260930    gcc-10.5.0
sparc                 randconfig-2001-20260929    gcc-12.5.0
sparc                 randconfig-2001-20260930    gcc-10.5.0
sparc                randconfig-r2200-20260929    gcc-8.5.0  smatch
sparc                randconfig-r2301-20260929    gcc-8.5.0  sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20260930    clang-22
sparc64               randconfig-1001-20260930    clang-22
sparc64               randconfig-2000-20260929    gcc-12.5.0
sparc64               randconfig-2000-20260930    gcc-10.5.0
sparc64               randconfig-2001-20260929    gcc-12.5.0
sparc64               randconfig-2001-20260930    gcc-10.5.0
sparc64              randconfig-r2104-20260930    clang-21   cocci
sparc64              randconfig-r2300-20260929    gcc-12.5.0 sparse
sparc64              randconfig-r2303-20260929    gcc-8.5.0  sparse
sparc64              randconfig-r2303-20260930    clang-24   sparse
sparc64              randconfig-r2305-20260930    clang-24   sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.1.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20260930    clang-22
um                    randconfig-1001-20260930    clang-22
um                    randconfig-2000-20260929    gcc-12.5.0
um                    randconfig-2000-20260930    gcc-10.5.0
um                    randconfig-2001-20260929    gcc-12.5.0
um                    randconfig-2001-20260930    gcc-10.5.0
um                   randconfig-r2107-20260929    clang-24   cocci
um                   randconfig-r2302-20260929    clang-21   sparse
um                            x86_64_defconfig    gcc-14
um                            x86_64_defconfig    gcc-16.1.0
x86_64                             allnoconfig    clang-22   checkkconfigsymbols
x86_64                             allnoconfig    clang-24
x86_64      buildonly-randconfig-1000-20260930    clang-22
x86_64      buildonly-randconfig-1001-20260930    clang-22
x86_64      buildonly-randconfig-1002-20260930    clang-22
x86_64      buildonly-randconfig-1003-20260930    clang-22
x86_64      buildonly-randconfig-1004-20260930    clang-22
x86_64      buildonly-randconfig-1005-20260930    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20260930    gcc-14
x86_64                randconfig-1001-20260930    gcc-14
x86_64                randconfig-1002-20260930    gcc-14
x86_64                randconfig-1003-20260930    gcc-14
x86_64                randconfig-1004-20260930    gcc-14
x86_64                randconfig-1005-20260930    gcc-14
x86_64                randconfig-1006-20260930    gcc-14
x86_64                randconfig-1007-20260930    gcc-14
x86_64                randconfig-1008-20260930    gcc-14
x86_64                randconfig-1009-20260930    gcc-14
x86_64                randconfig-1010-20260930    gcc-14
x86_64                randconfig-1011-20260930    gcc-14
x86_64                randconfig-1012-20260930    clang-22
x86_64                randconfig-1013-20260930    clang-22
x86_64                randconfig-1014-20260930    clang-22
x86_64                randconfig-1015-20260930    clang-22
x86_64                randconfig-1016-20260930    clang-22
x86_64                randconfig-1017-20260930    clang-22
x86_64                randconfig-2100-20260929    clang-22   cocci
x86_64                randconfig-2100-20260930    clang-22   cocci
x86_64                randconfig-2101-20260929    clang-22   cocci
x86_64                randconfig-2101-20260930    clang-22   cocci
x86_64                randconfig-2102-20260929    clang-22   cocci
x86_64                randconfig-2102-20260930    clang-22   cocci
x86_64                randconfig-2103-20260929    clang-22   cocci
x86_64                randconfig-2103-20260930    clang-22   cocci
x86_64                randconfig-2200-20260929    clang-22   smatch
x86_64                randconfig-2200-20260930    gcc-14     smatch
x86_64                randconfig-2300-20260929    gcc-14     sparse
x86_64                randconfig-2300-20260930    gcc-13     sparse
x86_64                randconfig-2301-20260929    gcc-14     sparse
x86_64                randconfig-2301-20260930    gcc-13     sparse
x86_64                randconfig-2302-20260929    gcc-14     sparse
x86_64                randconfig-2302-20260930    gcc-13     sparse
x86_64               randconfig-r2107-20260929    gcc-13.4.0 cocci
x86_64               randconfig-r2300-20260929    clang-21   sparse
x86_64               randconfig-r2308-20260929    clang-22   sparse
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
xtensa                randconfig-1000-20260930    clang-22
xtensa                randconfig-1001-20260930    clang-22
xtensa                randconfig-2000-20260929    gcc-12.5.0
xtensa                randconfig-2000-20260930    gcc-10.5.0
xtensa                randconfig-2001-20260929    gcc-12.5.0
xtensa                randconfig-2001-20260930    gcc-10.5.0
xtensa               randconfig-r2106-20260929    gcc-13.4.0 cocci
xtensa               randconfig-r2201-20260929    gcc-10.5.0 smatch
xtensa               randconfig-r2307-20260929    gcc-9.5.0  sparse
xtensa               randconfig-r2308-20260929    gcc-14.3.0 sparse

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
