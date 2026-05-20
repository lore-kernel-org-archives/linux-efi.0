Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8D736C9EC
	for <linux-efi@vger.kernel.org>; Wed, 20 May 2026 03:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779248256; cv=none; b=X5CnuqplZ5BBim9428H6b/I/JS+0MJNUdV3EUu9XcQUcK0Y/OdmUIjcCLTWPamm8Bcvn1DjIb6F9gkT0eqCjYU4pGvTqNENs+6MbyOND41KV6wTmvpL/tcFmGgPf6L6DZWyCGLGk6ceY/qQXPUx3kv7STYFToQ1X45xV5aB0NTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779248256; c=relaxed/simple;
	bh=BMwcpubTyCsfy9cfJJYGZqgzeLdQdjVmlI4aJ+n+/uM=;
	h=Date:From:To:Cc:Subject:Message-ID; b=GDiLgvl+a2PQ3jdfDJ6RgD4Mt2yQCHam4oah0p29QBElbI2mQDnH9/3wUxo80+mKzJDzL1MirdoNyIpFCInxJ2rqw2D0X+wehVxB50cbOBiZ2c3BEazV2jVSZj0A5bsvW190Ax2HDb0tDnJbNriW6+hC3hd0HGnHarraQ93DdEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DtEp9Unv; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DtEp9Unv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779248249; x=1810784249;
  h=date:from:to:cc:subject:message-id;
  bh=BMwcpubTyCsfy9cfJJYGZqgzeLdQdjVmlI4aJ+n+/uM=;
  b=DtEp9UnvF9UjxuHCexXyy1cBk7cGZnhCNON5WoACy1PN0AyjLOp/42nC
   4vVRJv+Gk6bA0UgAoUbvicbAhHbClgOb/QOxKa4FqTz3G49ixy7GdZmnn
   F7LD1FYzetcige0rLAc/y7kzr5KQI0c/u5b8gaRu+/4LQIh7s6N3SVWUI
   vJGxuKdu9d9Iaf4F9tAvJSwkgdGoLwUn/tZSUc0Rqi2u87jkFnUBJaoG7
   JhOHDfL848RAN/QWLkaFn5AOPBn5XsrRA3IfAp8IUVrXsvMN8ML0P1h06
   7dg5V+2ksAfdGZc/g0jLOeyiM6m5Jooqop2WQHcnpmeldiV3FLrgujkTq
   w==;
X-CSE-ConnectionGUID: bwg8nWDPSs++amRpTO5kIw==
X-CSE-MsgGUID: P211kNdXSpC5vhIBCWJgCA==
X-IronPort-AV: E=McAfee;i="6800,10657,11791"; a="83756639"
X-IronPort-AV: E=Sophos;i="6.23,243,1770624000"; 
   d="scan'208";a="83756639"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2026 20:37:24 -0700
X-CSE-ConnectionGUID: x0HgGm1vRLWyz9vvAeyrFQ==
X-CSE-MsgGUID: AsDBDi1jR1miYtqrGgkI4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,243,1770624000"; 
   d="scan'208";a="237381467"
Received: from lkp-server02.sh.intel.com (HELO 30e86e9c1927) ([10.239.97.151])
  by fmviesa008.fm.intel.com with ESMTP; 19 May 2026 20:37:23 -0700
Received: from kbuild by 30e86e9c1927 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wPXjV-000000002O5-1iUK;
	Wed, 20 May 2026 03:36:48 +0000
Date: Wed, 20 May 2026 11:36:20 +0800
From: kernel test robot <lkp@intel.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org
Subject: [efi:urgent] BUILD SUCCESS
 d8809f6931065cbbf3554647a50a65a471ab5983
Message-ID: <202605201111.o4sktueO-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git urgent
branch HEAD: d8809f6931065cbbf3554647a50a65a471ab5983  efi: sysfb_efi: Extend quirk to cover IdeaPad Duet 3 10IGL5-LTE

elapsed time: 725m

configs tested: 202
configs skipped: 3

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
arc                   randconfig-001-20260520    gcc-8.5.0
arc                   randconfig-002-20260520    gcc-8.5.0
arm                               allnoconfig    clang-23
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    clang-16
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    gcc-15.2.0
arm                        keystone_defconfig    gcc-15.2.0
arm                           omap1_defconfig    gcc-15.2.0
arm                   randconfig-001-20260520    gcc-8.5.0
arm                   randconfig-002-20260520    gcc-8.5.0
arm                   randconfig-003-20260520    gcc-8.5.0
arm                   randconfig-004-20260520    gcc-8.5.0
arm                          sp7021_defconfig    gcc-15.2.0
arm64                            allmodconfig    clang-19
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260519    clang-18
arm64                 randconfig-001-20260520    gcc-10.5.0
arm64                 randconfig-002-20260519    gcc-11.5.0
arm64                 randconfig-002-20260520    gcc-10.5.0
arm64                 randconfig-003-20260519    gcc-8.5.0
arm64                 randconfig-003-20260520    gcc-10.5.0
arm64                 randconfig-004-20260519    gcc-9.5.0
arm64                 randconfig-004-20260520    gcc-10.5.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260519    gcc-12.5.0
csky                  randconfig-001-20260520    gcc-10.5.0
csky                  randconfig-002-20260519    gcc-11.5.0
csky                  randconfig-002-20260520    gcc-10.5.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    gcc-15.2.0
hexagon               randconfig-001-20260520    gcc-11.5.0
hexagon               randconfig-002-20260520    gcc-11.5.0
i386                             allmodconfig    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    clang-20
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260520    clang-20
i386        buildonly-randconfig-002-20260520    clang-20
i386        buildonly-randconfig-002-20260520    gcc-14
i386        buildonly-randconfig-003-20260520    clang-20
i386        buildonly-randconfig-004-20260520    clang-20
i386        buildonly-randconfig-005-20260520    clang-20
i386        buildonly-randconfig-005-20260520    gcc-13
i386        buildonly-randconfig-006-20260520    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260520    clang-20
i386                  randconfig-002-20260520    clang-20
i386                  randconfig-003-20260520    clang-20
i386                  randconfig-004-20260520    clang-20
i386                  randconfig-005-20260520    clang-20
i386                  randconfig-006-20260520    clang-20
i386                  randconfig-007-20260520    clang-20
i386                  randconfig-011-20260520    gcc-14
i386                  randconfig-012-20260520    gcc-14
i386                  randconfig-013-20260520    gcc-14
i386                  randconfig-014-20260520    gcc-14
i386                  randconfig-015-20260520    gcc-14
i386                  randconfig-016-20260520    gcc-14
i386                  randconfig-017-20260520    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-23
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260520    gcc-11.5.0
loongarch             randconfig-002-20260520    gcc-11.5.0
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    clang-16
m68k                             allyesconfig    gcc-15.2.0
m68k                                defconfig    clang-19
m68k                                defconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    clang-19
microblaze                          defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
mips                         rt305x_defconfig    clang-23
nios2                            allmodconfig    clang-23
nios2                             allnoconfig    clang-23
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260520    gcc-11.5.0
nios2                 randconfig-002-20260520    gcc-11.5.0
openrisc                         allmodconfig    clang-23
openrisc                          allnoconfig    clang-23
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    clang-23
parisc                           allyesconfig    clang-19
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260520    clang-23
parisc                randconfig-002-20260520    clang-23
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-23
powerpc               randconfig-001-20260520    clang-23
powerpc               randconfig-002-20260520    clang-23
powerpc64             randconfig-001-20260520    clang-23
powerpc64             randconfig-002-20260520    clang-23
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                            allyesconfig    clang-16
riscv                               defconfig    gcc-15.2.0
riscv             nommu_k210_sdcard_defconfig    gcc-15.2.0
s390                             allmodconfig    clang-18
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    gcc-15.2.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-23
sh                               allyesconfig    clang-19
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sparc                             allnoconfig    clang-23
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260520    gcc-8.5.0
sparc                 randconfig-002-20260520    gcc-8.5.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260520    gcc-8.5.0
sparc64               randconfig-002-20260520    gcc-8.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260520    gcc-8.5.0
um                    randconfig-002-20260520    gcc-8.5.0
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260520    gcc-14
x86_64      buildonly-randconfig-002-20260520    gcc-14
x86_64      buildonly-randconfig-003-20260520    gcc-14
x86_64      buildonly-randconfig-004-20260520    gcc-14
x86_64      buildonly-randconfig-005-20260520    gcc-14
x86_64      buildonly-randconfig-006-20260520    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260520    gcc-14
x86_64                randconfig-002-20260520    clang-20
x86_64                randconfig-002-20260520    gcc-14
x86_64                randconfig-003-20260520    gcc-14
x86_64                randconfig-004-20260520    gcc-14
x86_64                randconfig-005-20260520    gcc-12
x86_64                randconfig-005-20260520    gcc-14
x86_64                randconfig-006-20260520    clang-20
x86_64                randconfig-006-20260520    gcc-14
x86_64                randconfig-011-20260520    gcc-14
x86_64                randconfig-012-20260520    gcc-14
x86_64                randconfig-013-20260520    gcc-14
x86_64                randconfig-014-20260520    gcc-14
x86_64                randconfig-015-20260520    gcc-14
x86_64                randconfig-016-20260520    gcc-14
x86_64                randconfig-071-20260520    clang-20
x86_64                randconfig-071-20260520    gcc-14
x86_64                randconfig-072-20260520    clang-20
x86_64                randconfig-072-20260520    gcc-14
x86_64                randconfig-073-20260520    gcc-14
x86_64                randconfig-074-20260520    gcc-14
x86_64                randconfig-075-20260520    clang-20
x86_64                randconfig-075-20260520    gcc-14
x86_64                randconfig-076-20260520    gcc-13
x86_64                randconfig-076-20260520    gcc-14
x86_64                               rhel-9.4    clang-20
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    clang-23
xtensa                           allyesconfig    clang-23
xtensa                randconfig-001-20260520    gcc-8.5.0
xtensa                randconfig-002-20260520    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
