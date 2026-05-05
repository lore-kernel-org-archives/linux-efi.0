Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6FC3D9025
	for <linux-efi@vger.kernel.org>; Tue,  5 May 2026 19:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778010274; cv=none; b=ariUsxHSnUX09pj1bpgpqsQZXejgzDes6UtGdRe4QPHD6xYJ8GyOj56LGiCivX4o7WiguWwM/0WNUTpJeaP2CZQaEX3MpPjtLsrX+Ft5n1jqB+JIBUvGAms8ptyv9tGrJ0bftPnpKrnKctqDLFnFGzE/KbuNmLNX+tgyA/ARXvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778010274; c=relaxed/simple;
	bh=PvFW5LrLdUgrs2lZ1EuJigNtQY5N/qb1K16FiJx6/bw=;
	h=Date:From:To:Cc:Subject:Message-ID; b=cagF6nFWAn0HxChuZy0tV62hqskU97b2oVT3enWi3YhOleXJst/KhQvUjSHyvMpNjilm91Wtnl9bW+Q0jYCTGfAydHHO0dCNKCNo/AQXQXk9ggrIIKcoqQIaZKqItbj2ZnuARISYg2/eMTNScTxXaAz/CEs36mdjlh7weUKqFOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CbkFjQv6; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CbkFjQv6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778010272; x=1809546272;
  h=date:from:to:cc:subject:message-id;
  bh=PvFW5LrLdUgrs2lZ1EuJigNtQY5N/qb1K16FiJx6/bw=;
  b=CbkFjQv6uxN1c8rqW7HQKiaVx/qtTVxFMyjOISpDlhD9VwQ61cVB8r9P
   g6tmr5D6r82xBC2/vDem/b1C3Run9VJWHuSS3C3l3p4Bhfkk/pGvgZQSC
   Z9rlFJcgoJDBYsHGes6Zo0laWlwL/hWsiB2K8jClqTCGuzy/TO+0LBpkF
   uAhT/2/YsaBa8hwIz5r7CMGkoQNVpojt6nH+Aw3KxWsVqc+1SIE37Hpwj
   u44mmkQedkDWAxbJgq/gRK7sUm3sUZwdwyj7qbpaUHJY6EbumdXInefY1
   9jS+7PbCAQY6PvkDX+F0toTs+pHjjNn0be6zZV+tJ9QZ+MXQU1/P7zU2N
   Q==;
X-CSE-ConnectionGUID: D/VNEQK0RceFPWRXhZJiVw==
X-CSE-MsgGUID: p24SRcxgSuSsBuTHAhhr8g==
X-IronPort-AV: E=McAfee;i="6800,10657,11777"; a="104347882"
X-IronPort-AV: E=Sophos;i="6.23,218,1770624000"; 
   d="scan'208";a="104347882"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2026 12:44:30 -0700
X-CSE-ConnectionGUID: RFiAWyAHTj6WdPLfJ8L+jQ==
X-CSE-MsgGUID: acOpJoowRkmfbqPgsLlJ1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,218,1770624000"; 
   d="scan'208";a="229421089"
Received: from lkp-server01.sh.intel.com (HELO 9ec114424ce8) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 05 May 2026 12:44:29 -0700
Received: from kbuild by 9ec114424ce8 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wKLgx-000000000Pt-0k1N;
	Tue, 05 May 2026 19:44:27 +0000
Date: Wed, 06 May 2026 03:43:38 +0800
From: kernel test robot <lkp@intel.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org
Subject: [efi:urgent] BUILD SUCCESS
 2c340aab5485ebe9e33c01437dd4815ef33c8df5
Message-ID: <202605060329.iQZneOAd-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git urgent
branch HEAD: 2c340aab5485ebe9e33c01437dd4815ef33c8df5  x86/efi: Restore IRQ state in EFI page fault handler

elapsed time: 728m

configs tested: 321
configs skipped: 22

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    clang-16
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    clang-23
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260505    gcc-8.5.0
arc                   randconfig-001-20260506    gcc-12.5.0
arc                   randconfig-002-20260505    gcc-8.5.0
arc                   randconfig-002-20260506    gcc-12.5.0
arm                               allnoconfig    clang-23
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    clang-16
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    gcc-15.2.0
arm                          exynos_defconfig    clang-23
arm                            mmp2_defconfig    gcc-15.2.0
arm                   randconfig-001-20260505    gcc-8.5.0
arm                   randconfig-001-20260506    gcc-12.5.0
arm                   randconfig-002-20260505    gcc-8.5.0
arm                   randconfig-002-20260506    gcc-12.5.0
arm                   randconfig-003-20260505    gcc-8.5.0
arm                   randconfig-003-20260506    gcc-12.5.0
arm                   randconfig-004-20260505    gcc-8.5.0
arm                   randconfig-004-20260506    gcc-12.5.0
arm64                            allmodconfig    clang-19
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260505    gcc-14.3.0
arm64                 randconfig-001-20260506    gcc-15.2.0
arm64                 randconfig-002-20260505    gcc-14.3.0
arm64                 randconfig-002-20260506    gcc-15.2.0
arm64                 randconfig-003-20260505    gcc-14.3.0
arm64                 randconfig-003-20260506    gcc-15.2.0
arm64                 randconfig-004-20260505    gcc-14.3.0
arm64                 randconfig-004-20260506    gcc-15.2.0
csky                             alldefconfig    gcc-15.2.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260505    gcc-14.3.0
csky                  randconfig-001-20260506    gcc-15.2.0
csky                  randconfig-002-20260505    gcc-14.3.0
csky                  randconfig-002-20260506    gcc-15.2.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    gcc-15.2.0
hexagon                        randconfig-001    gcc-11.5.0
hexagon               randconfig-001-20260505    clang-23
hexagon               randconfig-001-20260506    clang-23
hexagon               randconfig-002-20260505    clang-23
hexagon               randconfig-002-20260506    clang-23
i386                             allmodconfig    clang-20
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    clang-20
i386                 buildonly-randconfig-001    gcc-14
i386        buildonly-randconfig-001-20260505    gcc-14
i386        buildonly-randconfig-001-20260506    clang-20
i386                 buildonly-randconfig-002    gcc-14
i386        buildonly-randconfig-002-20260505    gcc-14
i386        buildonly-randconfig-002-20260506    clang-20
i386                 buildonly-randconfig-003    gcc-14
i386        buildonly-randconfig-003-20260505    gcc-14
i386        buildonly-randconfig-003-20260506    clang-20
i386                 buildonly-randconfig-004    gcc-14
i386        buildonly-randconfig-004-20260505    gcc-14
i386        buildonly-randconfig-004-20260506    clang-20
i386                 buildonly-randconfig-005    gcc-14
i386        buildonly-randconfig-005-20260505    gcc-14
i386        buildonly-randconfig-005-20260506    clang-20
i386                 buildonly-randconfig-006    gcc-14
i386        buildonly-randconfig-006-20260505    gcc-14
i386        buildonly-randconfig-006-20260506    clang-20
i386                                defconfig    gcc-15.2.0
i386                           randconfig-001    clang-20
i386                  randconfig-001-20260505    clang-20
i386                  randconfig-001-20260505    gcc-14
i386                  randconfig-001-20260506    gcc-14
i386                           randconfig-002    clang-20
i386                  randconfig-002-20260505    clang-20
i386                  randconfig-002-20260505    gcc-14
i386                  randconfig-002-20260506    gcc-14
i386                           randconfig-003    clang-20
i386                  randconfig-003-20260505    clang-20
i386                  randconfig-003-20260506    gcc-14
i386                           randconfig-004    clang-20
i386                  randconfig-004-20260505    clang-20
i386                  randconfig-004-20260505    gcc-14
i386                  randconfig-004-20260506    gcc-14
i386                           randconfig-005    clang-20
i386                  randconfig-005-20260505    clang-20
i386                  randconfig-005-20260506    gcc-14
i386                           randconfig-006    clang-20
i386                  randconfig-006-20260505    clang-20
i386                  randconfig-006-20260506    gcc-14
i386                           randconfig-007    clang-20
i386                  randconfig-007-20260505    clang-20
i386                  randconfig-007-20260505    gcc-14
i386                  randconfig-007-20260506    gcc-14
i386                  randconfig-011-20260505    clang-20
i386                  randconfig-011-20260506    clang-20
i386                  randconfig-012-20260505    clang-20
i386                  randconfig-012-20260506    clang-20
i386                  randconfig-013-20260505    clang-20
i386                  randconfig-013-20260506    clang-20
i386                  randconfig-014-20260505    clang-20
i386                  randconfig-014-20260506    clang-20
i386                  randconfig-015-20260505    clang-20
i386                  randconfig-015-20260506    clang-20
i386                  randconfig-016-20260505    clang-20
i386                  randconfig-016-20260506    clang-20
i386                  randconfig-017-20260505    clang-20
i386                  randconfig-017-20260506    clang-20
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-23
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch                      randconfig-001    gcc-11.5.0
loongarch             randconfig-001-20260505    clang-23
loongarch             randconfig-001-20260505    gcc-11.5.0
loongarch             randconfig-001-20260506    clang-23
loongarch                      randconfig-002    gcc-11.5.0
loongarch             randconfig-002-20260505    clang-23
loongarch             randconfig-002-20260505    gcc-11.5.0
loongarch             randconfig-002-20260506    clang-23
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    clang-16
m68k                             allyesconfig    gcc-15.2.0
m68k                                defconfig    clang-19
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    clang-19
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
nios2                            allmodconfig    clang-23
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                          randconfig-001    gcc-11.5.0
nios2                 randconfig-001-20260505    clang-23
nios2                 randconfig-001-20260505    gcc-11.5.0
nios2                 randconfig-001-20260506    clang-23
nios2                          randconfig-002    gcc-11.5.0
nios2                 randconfig-002-20260505    clang-23
nios2                 randconfig-002-20260505    gcc-11.5.0
nios2                 randconfig-002-20260506    clang-23
openrisc                         allmodconfig    clang-23
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    clang-23
openrisc                          allnoconfig    gcc-15.2.0
openrisc         de0_nano_multicore_defconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    clang-23
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    clang-19
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                         randconfig-001    gcc-14.3.0
parisc                randconfig-001-20260505    gcc-14.3.0
parisc                randconfig-001-20260506    gcc-13.4.0
parisc                         randconfig-002    gcc-14.3.0
parisc                randconfig-002-20260505    gcc-14.3.0
parisc                randconfig-002-20260506    gcc-13.4.0
parisc64                            defconfig    clang-19
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-15.2.0
powerpc                        randconfig-001    gcc-14.3.0
powerpc               randconfig-001-20260505    gcc-14.3.0
powerpc               randconfig-001-20260506    gcc-13.4.0
powerpc                        randconfig-002    gcc-14.3.0
powerpc               randconfig-002-20260505    gcc-14.3.0
powerpc               randconfig-002-20260506    gcc-13.4.0
powerpc                     tqm8541_defconfig    clang-23
powerpc64                      randconfig-001    gcc-14.3.0
powerpc64             randconfig-001-20260505    gcc-14.3.0
powerpc64             randconfig-001-20260506    gcc-13.4.0
powerpc64                      randconfig-002    gcc-14.3.0
powerpc64             randconfig-002-20260505    gcc-14.3.0
powerpc64             randconfig-002-20260506    gcc-13.4.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    gcc-15.2.0
riscv                 randconfig-001-20260505    gcc-10.5.0
riscv                 randconfig-001-20260506    gcc-8.5.0
riscv                 randconfig-002-20260506    gcc-8.5.0
s390                             allmodconfig    clang-18
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260506    gcc-8.5.0
s390                  randconfig-002-20260505    gcc-10.5.0
s390                  randconfig-002-20260506    gcc-8.5.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    clang-19
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                    randconfig-001-20260505    gcc-10.5.0
sh                    randconfig-001-20260506    gcc-8.5.0
sh                    randconfig-002-20260505    gcc-10.5.0
sh                    randconfig-002-20260506    gcc-8.5.0
sh                          urquell_defconfig    gcc-15.2.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                          randconfig-001    gcc-15.2.0
sparc                 randconfig-001-20260505    gcc-15.2.0
sparc                          randconfig-002    gcc-15.2.0
sparc                 randconfig-002-20260505    gcc-15.2.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    gcc-14
sparc64                        randconfig-001    gcc-15.2.0
sparc64               randconfig-001-20260505    gcc-15.2.0
sparc64                        randconfig-002    gcc-15.2.0
sparc64               randconfig-002-20260505    gcc-15.2.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                             randconfig-001    gcc-15.2.0
um                    randconfig-001-20260505    gcc-15.2.0
um                             randconfig-002    gcc-15.2.0
um                    randconfig-002-20260505    gcc-15.2.0
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260505    clang-20
x86_64      buildonly-randconfig-001-20260506    clang-20
x86_64      buildonly-randconfig-002-20260505    clang-20
x86_64      buildonly-randconfig-002-20260506    clang-20
x86_64      buildonly-randconfig-003-20260505    clang-20
x86_64      buildonly-randconfig-003-20260505    gcc-14
x86_64      buildonly-randconfig-003-20260506    clang-20
x86_64      buildonly-randconfig-004-20260505    clang-20
x86_64      buildonly-randconfig-004-20260506    clang-20
x86_64      buildonly-randconfig-005-20260505    clang-20
x86_64      buildonly-randconfig-005-20260505    gcc-14
x86_64      buildonly-randconfig-005-20260506    clang-20
x86_64      buildonly-randconfig-006-20260505    clang-20
x86_64      buildonly-randconfig-006-20260505    gcc-14
x86_64      buildonly-randconfig-006-20260506    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260505    clang-20
x86_64                randconfig-001-20260506    clang-20
x86_64                randconfig-002-20260505    clang-20
x86_64                randconfig-002-20260506    clang-20
x86_64                randconfig-003-20260505    clang-20
x86_64                randconfig-003-20260506    clang-20
x86_64                randconfig-004-20260505    clang-20
x86_64                randconfig-004-20260506    clang-20
x86_64                randconfig-005-20260505    clang-20
x86_64                randconfig-005-20260506    clang-20
x86_64                randconfig-006-20260505    clang-20
x86_64                randconfig-006-20260506    clang-20
x86_64                randconfig-011-20260505    clang-20
x86_64                randconfig-011-20260506    clang-20
x86_64                randconfig-012-20260505    clang-20
x86_64                randconfig-012-20260506    clang-20
x86_64                randconfig-013-20260505    clang-20
x86_64                randconfig-013-20260506    clang-20
x86_64                randconfig-014-20260505    clang-20
x86_64                randconfig-014-20260506    clang-20
x86_64                randconfig-015-20260505    clang-20
x86_64                randconfig-015-20260506    clang-20
x86_64                randconfig-016-20260505    clang-20
x86_64                randconfig-016-20260506    clang-20
x86_64                         randconfig-071    clang-20
x86_64                randconfig-071-20260505    clang-20
x86_64                randconfig-071-20260506    clang-20
x86_64                         randconfig-072    clang-20
x86_64                randconfig-072-20260505    clang-20
x86_64                randconfig-072-20260506    clang-20
x86_64                         randconfig-073    clang-20
x86_64                randconfig-073-20260505    clang-20
x86_64                randconfig-073-20260506    clang-20
x86_64                         randconfig-074    clang-20
x86_64                randconfig-074-20260505    clang-20
x86_64                randconfig-074-20260506    clang-20
x86_64                         randconfig-075    clang-20
x86_64                randconfig-075-20260505    clang-20
x86_64                randconfig-075-20260506    clang-20
x86_64                         randconfig-076    clang-20
x86_64                randconfig-076-20260505    clang-20
x86_64                randconfig-076-20260506    clang-20
x86_64                               rhel-9.4    clang-20
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    clang-23
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    clang-23
xtensa                           allyesconfig    gcc-15.2.0
xtensa                         randconfig-001    gcc-15.2.0
xtensa                randconfig-001-20260505    gcc-15.2.0
xtensa                         randconfig-002    gcc-15.2.0
xtensa                randconfig-002-20260505    gcc-15.2.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
