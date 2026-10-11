Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F9C3D76
	for <linux-efi@vger.kernel.org>; Sun, 11 Oct 2026 01:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791683639; cv=none; b=QPJ4HV0Etv8H+V6rjiBB4ExVZcIK1TVQjr0sjaDK3inBOTebVpPCO72jaPWn1E1mQ4aHn9DOqNoiz8xALu2xLi2Ii6PR/GWEv46og0WIwo/9wzwO89gC4NT0SKZkCUrgbfJPNxDcaWExB0BAe9RzzGxZtZ9WB9a+3WUQWhBzZms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791683639; c=relaxed/simple;
	bh=DgJxXcoPjLwsSD6KD/gHEaV80jYLNqY5QDvFzgtuzi0=;
	h=Date:From:To:Cc:Subject:Message-ID; b=A7T+gvwFzBXjqehGY29G6FqFqXdOTThgt26Sc75kfmfZAg79l+l5dfqj6Es15G9C1oZhn2wnf4hmmF2z43nlY7Ihtf/ed6jEftY8Q2ZKI+J1VQiTxZT016846i+z8WhJGUS2TvoMeIsyq0ZZW6C88zOSCj4Ury8ktGghC1OFD0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GB3zsBXq; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GB3zsBXq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791683637; x=1823219637;
  h=date:from:to:cc:subject:message-id;
  bh=DgJxXcoPjLwsSD6KD/gHEaV80jYLNqY5QDvFzgtuzi0=;
  b=GB3zsBXqbLnZi13PEIX8hEjO3IU4wpUTdqzjIo0MPXKReWK+mEvv36xg
   Z5+B9M7RiSwKrEs+ZlqHqCpo4ABxKKDJc8JnnfdvmAER8WjoZE4KHsiFE
   D6FmihcUXIhW3uF0RsN4ULk+Qqafp7kFer3fwh6LG/SotyikhexOKY5Nh
   B/ggo1K6FeMo9i2FrRfTEvXJo1fgVoDPQ8//Z1iiyBJ7zr//o0wlQXNda
   22Q8VXweU8I36Rpiuq3Zj4R7T06RFwjxXFYC2giAC1eUGKEgRSeaydZes
   DrJYi7AskrkWCqa8bf2IOqGSAEhstTCe2J1r9lHm1QgNetWo1hilF75ZV
   g==;
X-CSE-ConnectionGUID: 1UAHhUIFS3yQAqQf+ZdGnA==
X-CSE-MsgGUID: cltWO9D/QpmuX8oQuWlKpg==
X-IronPort-AV: E=McAfee;i="6800,10657,11931"; a="321778"
X-IronPort-AV: E=Sophos;i="6.27,150,1787036400"; 
   d="scan'208";a="321778"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2026 18:53:57 -0700
X-CSE-ConnectionGUID: Hz+Eo3GoQP2/bLixlOUzWA==
X-CSE-MsgGUID: PXFpauvVQyyRGAxs7r4/NA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,150,1787036400"; 
   d="scan'208";a="537714"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 10 Oct 2026 18:53:55 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xFil7-00000000AEe-17Gz;
	Sun, 11 Oct 2026 01:53:53 +0000
Date: Sun, 11 Oct 2026 09:53:14 +0800
From: kernel test robot <lkp@intel.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org
Subject: [efi:next] BUILD SUCCESS
 305c21908278e8417c16399b99f64e1729916a85
Message-ID: <202610110910.HRR6q1tn-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git next
branch HEAD: 305c21908278e8417c16399b99f64e1729916a85  efi: Use sysfs_emit() not sprintf() to generate sysfs file contents

elapsed time: 1223m

configs tested: 409
configs skipped: 11

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r2103-20261009    gcc-10.5.0 cocci
alpha                randconfig-r2200-20261009    gcc-8.5.0  smatch
alpha                randconfig-r2202-20261010    gcc-8.5.0  smatch
alpha                randconfig-r2306-20261009    gcc-12.5.0 sparse
alpha                randconfig-r2309-20261009    gcc-16.1.0 sparse
arc                               allmodconfig    clang-24
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    gcc-16.1.0
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20261010    gcc-8.5.0
arc                   randconfig-1000-20261011    clang-24
arc                   randconfig-1001-20261010    gcc-8.5.0
arc                   randconfig-1001-20261011    clang-24
arc                  randconfig-r2101-20261008    gcc-12.5.0 cocci
arc                  randconfig-r2200-20261009    gcc-14.3.0 smatch
arc                  randconfig-r2306-20261009    gcc-8.5.0  sparse
arm                                allnoconfig    gcc-16.1.0
arm                               allyesconfig    clang-24
arm                                  defconfig    gcc-16.1.0
arm                           moxart_defconfig    clang-24
arm                          nhk8815_defconfig    clang-24
arm                   randconfig-1000-20261010    gcc-8.5.0
arm                   randconfig-1000-20261011    clang-24
arm                   randconfig-1001-20261010    gcc-8.5.0
arm                   randconfig-1001-20261011    clang-24
arm                   randconfig-1002-20261010    gcc-8.5.0
arm                   randconfig-1002-20261011    clang-24
arm                   randconfig-1003-20261010    gcc-8.5.0
arm                   randconfig-1003-20261011    clang-24
arm                  randconfig-r2102-20261009    gcc-13.4.0 cocci
arm                  randconfig-r2105-20261009    gcc-16.1.0 cocci
arm                  randconfig-r2201-20261009    clang-24   smatch
arm                  randconfig-r2202-20261008    gcc-11.5.0 smatch
arm                  randconfig-r2300-20261009    gcc-8.5.0  sparse
arm                  randconfig-r2302-20261009    gcc-8.5.0  sparse
arm                  randconfig-r2305-20261009    gcc-8.5.0  sparse
arm                  randconfig-r2306-20261010    gcc-14     sparse
arm                  randconfig-r2308-20261008    clang-22   sparse
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20261010    gcc-10.5.0
arm64                 randconfig-1001-20261010    gcc-10.5.0
arm64                 randconfig-1002-20261010    gcc-10.5.0
arm64                 randconfig-1003-20261010    gcc-10.5.0
arm64                randconfig-r2104-20261010    gcc-14     cocci
arm64                randconfig-r2302-20261008    clang-17   sparse
arm64                randconfig-r2303-20261008    clang-22   sparse
arm64                randconfig-r2303-20261009    clang-21   sparse
arm64                randconfig-r2304-20261010    gcc-16.1.0 sparse
arm64                randconfig-r2306-20261008    clang-22   sparse
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20261010    gcc-10.5.0
csky                  randconfig-1001-20261010    gcc-10.5.0
csky                 randconfig-r2103-20261010    clang-24   cocci
csky                 randconfig-r2105-20261008    clang-24   cocci
csky                 randconfig-r2106-20261009    gcc-14.3.0 cocci
csky                 randconfig-r2201-20261009    gcc-14.3.0 smatch
csky                 randconfig-r2300-20261009    clang-24   sparse
csky                 randconfig-r2300-20261010    gcc-16.1.0 sparse
csky                 randconfig-r2301-20261009    clang-21   sparse
csky                 randconfig-r2302-20261009    clang-24   sparse
csky                 randconfig-r2308-20261009    gcc-16.1.0 sparse
csky                 randconfig-r2309-20261009    gcc-12.5.0 sparse
hexagon                           allmodconfig    gcc-16.1.0
hexagon                            allnoconfig    gcc-16.1.0
hexagon                              defconfig    gcc-16.1.0
hexagon               randconfig-1000-20261010    clang-17
hexagon               randconfig-1001-20261010    clang-17
hexagon              randconfig-r2100-20261010    clang-24   cocci
hexagon              randconfig-r2301-20261008    clang-17   sparse
hexagon              randconfig-r2308-20261009    gcc-12.5.0 sparse
i386                               allnoconfig    gcc-16.1.0
i386        buildonly-randconfig-1000-20261010    gcc-14
i386        buildonly-randconfig-1001-20261010    gcc-14
i386        buildonly-randconfig-1002-20261010    gcc-14
i386        buildonly-randconfig-1003-20261010    gcc-14
i386        buildonly-randconfig-1004-20261010    gcc-14
i386        buildonly-randconfig-1005-20261010    gcc-14
i386                                 defconfig    gcc-16.1.0
i386                  randconfig-1000-20261010    clang-22
i386                  randconfig-1001-20261010    clang-22
i386                  randconfig-1002-20261010    clang-22
i386                  randconfig-1003-20261010    clang-22
i386                  randconfig-1004-20261010    clang-22
i386                  randconfig-1005-20261010    clang-22
i386                  randconfig-1006-20261010    clang-22
i386                  randconfig-1007-20261010    gcc-14
i386                  randconfig-1008-20261010    gcc-14
i386                  randconfig-1009-20261010    gcc-14
i386                  randconfig-1010-20261010    gcc-14
i386                  randconfig-1011-20261010    gcc-14
i386                  randconfig-1012-20261010    gcc-14
i386                  randconfig-1013-20261010    gcc-14
i386                  randconfig-2100-20261008    clang-22   cocci
i386                  randconfig-2100-20261009    clang-22   cocci
i386                  randconfig-2100-20261010    clang-22   cocci
i386                  randconfig-2101-20261008    clang-22   cocci
i386                  randconfig-2101-20261009    clang-22   cocci
i386                  randconfig-2101-20261010    clang-22   cocci
i386                  randconfig-2102-20261008    clang-22   cocci
i386                  randconfig-2102-20261009    clang-22   cocci
i386                  randconfig-2102-20261010    clang-22   cocci
i386                  randconfig-2103-20261008    clang-22   cocci
i386                  randconfig-2103-20261009    clang-22   cocci
i386                  randconfig-2103-20261010    clang-22   cocci
i386                  randconfig-2200-20261008    clang-22   smatch
i386                  randconfig-2200-20261009    gcc-14     smatch
i386                  randconfig-2200-20261010    gcc-12     smatch
i386                  randconfig-2300-20261008    clang-22   sparse
i386                  randconfig-2300-20261009    clang-22   sparse
i386                  randconfig-2300-20261010    gcc-14     sparse
i386                  randconfig-2301-20261008    clang-22   sparse
i386                  randconfig-2301-20261009    clang-22   sparse
i386                  randconfig-2301-20261010    gcc-14     sparse
i386                  randconfig-2302-20261008    clang-22   sparse
i386                  randconfig-2302-20261009    clang-22   sparse
i386                  randconfig-2302-20261010    gcc-14     sparse
i386                 randconfig-r2202-20261008    clang-22   smatch
i386                 randconfig-r2307-20261008    clang-22   sparse
i386                 randconfig-r2307-20261008    gcc-15.2.0 sparse
i386                 randconfig-r2309-20261008    clang-22   sparse
loongarch                          allnoconfig    gcc-16.1.0
loongarch                            defconfig    clang-24
loongarch                 loongson32_defconfig    clang-24
loongarch             randconfig-1000-20261010    clang-17
loongarch             randconfig-1001-20261010    clang-17
loongarch            randconfig-r2100-20261008    gcc-12.5.0 cocci
loongarch            randconfig-r2101-20261008    gcc-12.5.0 cocci
loongarch            randconfig-r2105-20261008    gcc-16.1.0 cocci
loongarch            randconfig-r2107-20261010    gcc-14     cocci
loongarch            randconfig-r2200-20261009    gcc-16.1.0 smatch
loongarch            randconfig-r2202-20261009    clang-18   smatch
loongarch            randconfig-r2304-20261009    clang-21   sparse
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    clang-24
m68k                                 defconfig    clang-24
m68k                         m5307c3_defconfig    clang-24
m68k                 randconfig-r2301-20261009    clang-24   sparse
m68k                 randconfig-r2305-20261009    clang-21   sparse
m68k                 randconfig-r2306-20261008    gcc-15.2.0 sparse
m68k                 randconfig-r2307-20261009    gcc-12.5.0 sparse
m68k                 randconfig-r2307-20261010    gcc-14     sparse
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    clang-24
microblaze           randconfig-r2300-20261008    clang-22   sparse
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                  decstation_r4k_defconfig    clang-24
mips                     maltaup_xpa_defconfig    clang-24
mips                 randconfig-r2102-20261009    gcc-10.5.0 cocci
mips                 randconfig-r2103-20261009    gcc-12     cocci
mips                 randconfig-r2107-20261009    gcc-14.3.0 cocci
mips                 randconfig-r2300-20261008    clang-17   sparse
mips                 randconfig-r2303-20261009    clang-24   sparse
mips                 randconfig-r2304-20261008    clang-17   sparse
mips                 randconfig-r2307-20261009    gcc-8.5.0  sparse
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261010    clang-17
nios2                 randconfig-1001-20261010    clang-17
nios2                randconfig-r2101-20261009    gcc-12     cocci
nios2                randconfig-r2308-20261009    gcc-8.5.0  sparse
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc                             defconfig    gcc-16.1.0
openrisc             randconfig-r2100-20261009    gcc-12     cocci
openrisc             randconfig-r2101-20261009    gcc-10.5.0 cocci
openrisc             randconfig-r2301-20261010    gcc-16.1.0 sparse
openrisc             randconfig-r2302-20261009    clang-21   sparse
openrisc             randconfig-r2305-20261009    clang-24   sparse
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.1.0
parisc                 generic-64bit_defconfig    clang-24
parisc                randconfig-1000-20261010    clang-24
parisc                randconfig-1001-20261010    clang-24
parisc               randconfig-r2100-20261009    gcc-13.4.0 cocci
parisc               randconfig-r2101-20261010    clang-24   cocci
parisc               randconfig-r2102-20261008    gcc-12.5.0 cocci
parisc               randconfig-r2103-20261008    gcc-12.5.0 cocci
parisc               randconfig-r2106-20261008    gcc-16.1.0 cocci
parisc               randconfig-r2301-20261009    gcc-8.5.0  sparse
parisc               randconfig-r2305-20261010    gcc-16.1.0 sparse
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    clang-24
powerpc                      mpc5200_defconfig    clang-24
powerpc               randconfig-1000-20261010    clang-24
powerpc               randconfig-1001-20261010    clang-24
powerpc              randconfig-r2106-20261008    clang-24   cocci
powerpc              randconfig-r2107-20261008    clang-24   cocci
powerpc              randconfig-r2308-20261010    gcc-14     sparse
powerpc64             randconfig-1000-20261010    clang-24
powerpc64             randconfig-1001-20261010    clang-24
powerpc64            randconfig-r2104-20261009    clang-17   cocci
powerpc64            randconfig-r2104-20261009    gcc-14.3.0 cocci
powerpc64            randconfig-r2104-20261009    gcc-16.1.0 cocci
powerpc64            randconfig-r2107-20261009    clang-17   cocci
powerpc64            randconfig-r2305-20261008    clang-22   sparse
powerpc64            randconfig-r2308-20261008    gcc-15.2.0 sparse
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.1.0
riscv                 randconfig-1000-20261010    clang-19
riscv                 randconfig-1000-20261011    clang-17
riscv                 randconfig-1001-20261010    clang-19
riscv                 randconfig-1001-20261011    clang-17
riscv                 randconfig-2000-20261008    gcc-11.5.0
riscv                 randconfig-2000-20261009    gcc-16.1.0
riscv                 randconfig-2000-20261010    gcc-16.1.0
riscv                 randconfig-2001-20261008    gcc-11.5.0
riscv                 randconfig-2001-20261009    gcc-16.1.0
riscv                 randconfig-2001-20261010    gcc-16.1.0
riscv                randconfig-r2104-20261008    clang-24   cocci
riscv                randconfig-r2105-20261009    clang-17   cocci
riscv                randconfig-r2302-20261008    clang-22   sparse
riscv                randconfig-r2304-20261008    clang-22   sparse
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    gcc-16.1.0
s390                  randconfig-1000-20261010    clang-19
s390                  randconfig-1000-20261011    clang-17
s390                  randconfig-1001-20261010    clang-19
s390                  randconfig-1001-20261011    clang-17
s390                  randconfig-2000-20261008    gcc-11.5.0
s390                  randconfig-2000-20261009    gcc-16.1.0
s390                  randconfig-2000-20261010    gcc-16.1.0
s390                  randconfig-2001-20261008    gcc-11.5.0
s390                  randconfig-2001-20261009    gcc-16.1.0
s390                  randconfig-2001-20261010    gcc-16.1.0
s390                 randconfig-r2107-20261008    gcc-16.1.0 cocci
s390                 randconfig-r2301-20261008    clang-22   sparse
s390                 randconfig-r2305-20261008    clang-17   sparse
s390                 randconfig-r2306-20261009    gcc-16.1.0 sparse
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                                   defconfig    gcc-14
sh                    randconfig-1000-20261010    clang-19
sh                    randconfig-1000-20261011    clang-17
sh                    randconfig-1001-20261010    clang-19
sh                    randconfig-1001-20261011    clang-17
sh                    randconfig-2000-20261008    gcc-11.5.0
sh                    randconfig-2000-20261009    gcc-16.1.0
sh                    randconfig-2000-20261010    gcc-16.1.0
sh                    randconfig-2001-20261008    gcc-11.5.0
sh                    randconfig-2001-20261009    gcc-16.1.0
sh                    randconfig-2001-20261010    gcc-16.1.0
sh                   randconfig-r2101-20261009    gcc-13.4.0 cocci
sh                   randconfig-r2103-20261008    gcc-12.5.0 cocci
sh                   randconfig-r2105-20261009    gcc-14.3.0 cocci
sh                   randconfig-r2106-20261009    clang-17   cocci
sh                   randconfig-r2302-20261010    gcc-16.1.0 sparse
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20261010    gcc-16.1.0
sparc                 randconfig-1001-20261010    gcc-16.1.0
sparc                 randconfig-2000-20261008    gcc-14
sparc                 randconfig-2000-20261009    clang-17
sparc                 randconfig-2000-20261010    gcc-16.1.0
sparc                 randconfig-2001-20261008    gcc-14
sparc                 randconfig-2001-20261009    clang-17
sparc                 randconfig-2001-20261010    gcc-16.1.0
sparc                randconfig-r2104-20261008    gcc-16.1.0 cocci
sparc                randconfig-r2106-20261009    gcc-16.1.0 cocci
sparc                randconfig-r2200-20261008    gcc-16.1.0 smatch
sparc                randconfig-r2201-20261009    gcc-11.5.0 smatch
sparc                randconfig-r2303-20261008    clang-17   sparse
sparc                randconfig-r2303-20261010    gcc-16.1.0 sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261010    gcc-16.1.0
sparc64               randconfig-1001-20261010    gcc-16.1.0
sparc64               randconfig-2000-20261008    gcc-14
sparc64               randconfig-2000-20261009    clang-17
sparc64               randconfig-2000-20261010    gcc-16.1.0
sparc64               randconfig-2001-20261008    gcc-14
sparc64               randconfig-2001-20261009    clang-17
sparc64               randconfig-2001-20261010    gcc-16.1.0
sparc64              randconfig-r2102-20261008    gcc-12.5.0 cocci
sparc64              randconfig-r2102-20261010    clang-24   cocci
sparc64              randconfig-r2105-20261010    gcc-14     cocci
sparc64              randconfig-r2107-20261009    gcc-16.1.0 cocci
sparc64              randconfig-r2309-20261009    gcc-8.5.0  sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.1.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261010    gcc-16.1.0
um                    randconfig-1001-20261010    gcc-16.1.0
um                    randconfig-2000-20261008    gcc-14
um                    randconfig-2000-20261009    clang-17
um                    randconfig-2000-20261010    gcc-16.1.0
um                    randconfig-2001-20261008    gcc-14
um                    randconfig-2001-20261009    clang-17
um                    randconfig-2001-20261010    gcc-16.1.0
um                   randconfig-r2100-20261009    gcc-10.5.0 cocci
um                   randconfig-r2102-20261009    gcc-12     cocci
um                   randconfig-r2201-20261010    clang-17   smatch
um                   randconfig-r2303-20261009    gcc-8.5.0  sparse
um                   randconfig-r2304-20261009    clang-24   sparse
um                   randconfig-r2304-20261009    gcc-8.5.0  sparse
um                            x86_64_defconfig    gcc-14
x86_64                             allnoconfig    clang-24
x86_64      buildonly-randconfig-1000-20261010    clang-22
x86_64      buildonly-randconfig-1000-20261011    gcc-14
x86_64      buildonly-randconfig-1001-20261010    clang-22
x86_64      buildonly-randconfig-1001-20261011    gcc-14
x86_64      buildonly-randconfig-1002-20261010    clang-22
x86_64      buildonly-randconfig-1002-20261011    gcc-14
x86_64      buildonly-randconfig-1003-20261010    clang-22
x86_64      buildonly-randconfig-1003-20261011    gcc-14
x86_64      buildonly-randconfig-1004-20261010    clang-22
x86_64      buildonly-randconfig-1004-20261011    gcc-14
x86_64      buildonly-randconfig-1005-20261010    clang-22
x86_64      buildonly-randconfig-1005-20261011    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261010    gcc-14
x86_64                randconfig-1000-20261011    gcc-14
x86_64                randconfig-1001-20261010    gcc-14
x86_64                randconfig-1001-20261011    gcc-14
x86_64                randconfig-1002-20261010    gcc-14
x86_64                randconfig-1002-20261011    gcc-14
x86_64                randconfig-1003-20261010    gcc-14
x86_64                randconfig-1003-20261011    gcc-14
x86_64                randconfig-1004-20261010    gcc-14
x86_64                randconfig-1004-20261011    gcc-14
x86_64                randconfig-1005-20261010    gcc-14
x86_64                randconfig-1005-20261011    gcc-14
x86_64                randconfig-1006-20261010    clang-22
x86_64                randconfig-1007-20261010    clang-22
x86_64                randconfig-1008-20261010    clang-22
x86_64                randconfig-1009-20261010    clang-22
x86_64                randconfig-1010-20261010    clang-22
x86_64                randconfig-1011-20261010    clang-22
x86_64                randconfig-1012-20261010    clang-22
x86_64                randconfig-1013-20261010    clang-22
x86_64                randconfig-1014-20261010    clang-22
x86_64                randconfig-1015-20261010    clang-22
x86_64                randconfig-1016-20261010    clang-22
x86_64                randconfig-1017-20261010    clang-22
x86_64                randconfig-2100-20261008    clang-22   cocci
x86_64                randconfig-2100-20261009    clang-22   cocci
x86_64                randconfig-2100-20261010    clang-22   cocci
x86_64                randconfig-2101-20261008    clang-22   cocci
x86_64                randconfig-2101-20261009    clang-22   cocci
x86_64                randconfig-2101-20261010    clang-22   cocci
x86_64                randconfig-2102-20261008    clang-22   cocci
x86_64                randconfig-2102-20261009    clang-22   cocci
x86_64                randconfig-2102-20261010    clang-22   cocci
x86_64                randconfig-2103-20261008    clang-22   cocci
x86_64                randconfig-2103-20261009    clang-22   cocci
x86_64                randconfig-2103-20261010    clang-22   cocci
x86_64                randconfig-2200-20261008    gcc-14     smatch
x86_64                randconfig-2200-20261009    gcc-14     smatch
x86_64                randconfig-2300-20261008    clang-22   sparse
x86_64                randconfig-2300-20261009    clang-22   sparse
x86_64                randconfig-2300-20261010    gcc-14     sparse
x86_64                randconfig-2301-20261008    clang-22   sparse
x86_64                randconfig-2301-20261009    clang-22   sparse
x86_64                randconfig-2301-20261010    gcc-14     sparse
x86_64                randconfig-2302-20261008    clang-22   sparse
x86_64                randconfig-2302-20261009    clang-22   sparse
x86_64                randconfig-2302-20261010    gcc-14     sparse
x86_64               randconfig-r2100-20261008    gcc-12.5.0 cocci
x86_64               randconfig-r2103-20261009    gcc-13.4.0 cocci
x86_64               randconfig-r2106-20261010    gcc-14     cocci
x86_64               randconfig-r2200-20261008    gcc-12     smatch
x86_64               randconfig-r2202-20261009    clang-22   smatch
x86_64               randconfig-r2300-20261009    clang-21   sparse
x86_64               randconfig-r2307-20261009    gcc-16.1.0 sparse
x86_64               randconfig-r2309-20261010    gcc-14     sparse
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
xtensa                randconfig-1000-20261010    gcc-16.1.0
xtensa                randconfig-1001-20261010    gcc-16.1.0
xtensa                randconfig-2000-20261008    gcc-14
xtensa                randconfig-2000-20261009    clang-17
xtensa                randconfig-2000-20261010    gcc-16.1.0
xtensa                randconfig-2001-20261008    gcc-14
xtensa                randconfig-2001-20261009    clang-17
xtensa                randconfig-2001-20261010    gcc-16.1.0
xtensa               randconfig-r2200-20261010    gcc-8.5.0  smatch
xtensa               randconfig-r2201-20261008    gcc-13.4.0 smatch
xtensa               randconfig-r2309-20261008    gcc-15.2.0 sparse

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
