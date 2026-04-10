Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CFBE3E3C75
	for <linux-efi@vger.kernel.org>; Fri, 10 Apr 2026 18:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775844074; cv=none; b=R6bR9gMX3rWASIVBg2LqbWBRCKWmeMH0gec2vUBBZ5hqx8rQe71NJsR2bPMZPjn5LAduYhP4yyKL7GPTb2URjMxSilSH+jcJ39SscAYPwNmF4N/fOmp8Sqae0/sd6DaPfOXbTdsw8x4IIB4ozXMwM73aCdbArt4eMBBvZA/6dJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775844074; c=relaxed/simple;
	bh=/ex+MQaAkhaAD0elWeLfa2J94zN7x7V9G0QDqIVFkfg=;
	h=Date:From:To:Cc:Subject:Message-ID; b=KHv/UCCIzO/gLGdtkqlNvg1XyZpPcR1SKobJjiWx/N5y4oWBfExojp/2wrUC1LQb/UGwzfO2x9LBr7ZRCtf7Q4tj4o/aC41U2pQv4kI783fu/g8S85PzMzZG8ipj1+YTkMZSiEdgycFBDTipRWmEU2AycGTSSuqJJkooGa30tyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hrSZRR3g; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hrSZRR3g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775844073; x=1807380073;
  h=date:from:to:cc:subject:message-id;
  bh=/ex+MQaAkhaAD0elWeLfa2J94zN7x7V9G0QDqIVFkfg=;
  b=hrSZRR3gnEzld4c+gpWx3xfqQ2Mg73TS5NBqXZcEFA1IVjb+nUBaeyPn
   vZg8Sp+aVFpNpDYm4yW++nHgAoL1dUrBQUnyQirrg525NqfSHhzi0mNRW
   aQwbkXGLTOEPnOdR74p2OiRGl6uRzOcwWxSpKviQupgEq+sQlHFI5oEAa
   KvIC9U3sZCt7kw8PR5q69E7z7HG4s6TvdcZpyLl8ok0hhMzwaBPVQV2Db
   yie3wGVmNb8BCtdiVyVxAjspINLJALStwzmYitN3m1kyG5FnqDqcDQ4zs
   XUa0Qo5TF+RDo6MIdwQbvzCNXvzmbP91um8bK7/6QB06LqOlM7bbfvURG
   g==;
X-CSE-ConnectionGUID: zN8uijv2RyOEbGOffSIKLQ==
X-CSE-MsgGUID: CklW+Jl+TNSgRuSqnW478A==
X-IronPort-AV: E=McAfee;i="6800,10657,11755"; a="76942138"
X-IronPort-AV: E=Sophos;i="6.23,171,1770624000"; 
   d="scan'208";a="76942138"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 11:01:10 -0700
X-CSE-ConnectionGUID: tjvTt5bSS2GCc9iHdIo/vw==
X-CSE-MsgGUID: ZjAx1IvdSsm+Z/BcHD9wiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,171,1770624000"; 
   d="scan'208";a="226421107"
Received: from lkp-server01.sh.intel.com (HELO 6449335cace3) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 10 Apr 2026 11:01:09 -0700
Received: from kbuild by 6449335cace3 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wBGAE-0000000048D-2RRV;
	Fri, 10 Apr 2026 18:01:06 +0000
Date: Sat, 11 Apr 2026 02:00:09 +0800
From: kernel test robot <lkp@intel.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org
Subject: [efi:urgent] BUILD SUCCESS
 5241c2ca33bb181bf7abb7cb4bba1cc67d1b6278
Message-ID: <202604110202.UwMfKrgx-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git urgent
branch HEAD: 5241c2ca33bb181bf7abb7cb4bba1cc67d1b6278  firmware: efi: Never declare sysfb_primary_display on x86

elapsed time: 723m

configs tested: 163
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    clang-16
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    clang-23
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260410    gcc-8.5.0
arc                   randconfig-002-20260410    gcc-8.5.0
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    clang-16
arm                                 defconfig    gcc-15.2.0
arm                   randconfig-001-20260410    gcc-8.5.0
arm                   randconfig-002-20260410    gcc-8.5.0
arm                   randconfig-003-20260410    gcc-8.5.0
arm                   randconfig-004-20260410    gcc-8.5.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260410    gcc-10.5.0
arm64                 randconfig-002-20260410    gcc-10.5.0
arm64                 randconfig-003-20260410    gcc-10.5.0
arm64                 randconfig-004-20260410    gcc-10.5.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260410    gcc-10.5.0
csky                  randconfig-002-20260410    gcc-10.5.0
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    gcc-15.2.0
hexagon               randconfig-001-20260410    gcc-15.2.0
hexagon               randconfig-002-20260410    gcc-15.2.0
i386                             allmodconfig    clang-20
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    clang-20
i386        buildonly-randconfig-001-20260410    clang-20
i386        buildonly-randconfig-002-20260410    clang-20
i386        buildonly-randconfig-003-20260410    clang-20
i386        buildonly-randconfig-004-20260410    clang-20
i386        buildonly-randconfig-005-20260410    clang-20
i386        buildonly-randconfig-006-20260410    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260410    gcc-14
i386                  randconfig-002-20260410    gcc-14
i386                  randconfig-003-20260410    gcc-14
i386                  randconfig-004-20260410    gcc-14
i386                  randconfig-005-20260410    gcc-14
i386                  randconfig-006-20260410    gcc-14
i386                  randconfig-007-20260410    gcc-14
i386                  randconfig-011-20260410    clang-20
i386                  randconfig-012-20260410    clang-20
i386                  randconfig-013-20260410    clang-20
i386                  randconfig-014-20260410    clang-20
i386                  randconfig-015-20260410    clang-20
i386                  randconfig-016-20260410    clang-20
i386                  randconfig-017-20260410    clang-20
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260410    gcc-15.2.0
loongarch             randconfig-002-20260410    gcc-15.2.0
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    clang-16
m68k                                defconfig    clang-19
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    clang-19
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
mips                        vocore2_defconfig    clang-23
nios2                            allmodconfig    clang-23
nios2                             allnoconfig    clang-23
nios2                               defconfig    clang-19
nios2                 randconfig-001-20260410    gcc-15.2.0
nios2                 randconfig-002-20260410    gcc-15.2.0
openrisc                         allmodconfig    clang-23
openrisc                          allnoconfig    clang-23
openrisc                            defconfig    gcc-15.2.0
openrisc                 simple_smp_defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    clang-23
parisc                           allyesconfig    clang-19
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260410    gcc-14.3.0
parisc                randconfig-002-20260410    gcc-14.3.0
parisc64                            defconfig    clang-19
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-23
powerpc               randconfig-001-20260410    gcc-14.3.0
powerpc               randconfig-002-20260410    gcc-14.3.0
powerpc64             randconfig-001-20260410    gcc-14.3.0
powerpc64             randconfig-002-20260410    gcc-14.3.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                            allyesconfig    clang-16
riscv                               defconfig    gcc-15.2.0
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    gcc-15.2.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-23
sh                               allyesconfig    clang-19
sh                                  defconfig    gcc-14
sparc                             allnoconfig    clang-23
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260410    clang-23
sparc                 randconfig-002-20260410    clang-23
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260410    clang-23
sparc64               randconfig-002-20260410    clang-23
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260410    clang-23
um                    randconfig-002-20260410    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260410    clang-20
x86_64      buildonly-randconfig-002-20260410    clang-20
x86_64      buildonly-randconfig-003-20260410    clang-20
x86_64      buildonly-randconfig-004-20260410    clang-20
x86_64      buildonly-randconfig-005-20260410    clang-20
x86_64      buildonly-randconfig-006-20260410    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260410    clang-20
x86_64                randconfig-002-20260410    clang-20
x86_64                randconfig-003-20260410    clang-20
x86_64                randconfig-004-20260410    clang-20
x86_64                randconfig-005-20260410    clang-20
x86_64                randconfig-006-20260410    clang-20
x86_64                randconfig-011-20260410    gcc-14
x86_64                randconfig-012-20260410    gcc-14
x86_64                randconfig-013-20260410    gcc-14
x86_64                randconfig-014-20260410    gcc-14
x86_64                randconfig-015-20260410    gcc-14
x86_64                randconfig-016-20260410    gcc-14
x86_64                randconfig-071-20260410    clang-20
x86_64                randconfig-072-20260410    clang-20
x86_64                randconfig-073-20260410    clang-20
x86_64                randconfig-074-20260410    clang-20
x86_64                randconfig-075-20260410    clang-20
x86_64                randconfig-076-20260410    clang-20
x86_64                               rhel-9.4    clang-20
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    clang-23
xtensa                           allyesconfig    clang-23
xtensa                randconfig-001-20260410    clang-23
xtensa                randconfig-002-20260410    clang-23

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
