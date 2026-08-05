Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E757446BE3
	for <linux-efi@vger.kernel.org>; Wed,  5 Aug 2026 11:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785930965; cv=none; b=PRi9c1lCBEVMG72mR8G0s3sEqnmIU22lRPV1smyKhbDyw9XNKalfG5AxqAg8FGyzpsuBRTrdIOpegk9YWWnouOmhj0x+DfJHMv+DHUDwzb/ZG1GPIvrD7doeTFyNsJhWxEe4j2uuzmQSAFR901SCF+RpE9xSgEy0G4um255PWJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785930965; c=relaxed/simple;
	bh=VsGUQgRXam5gRsSXsqF77pXM4GB2eujnKGZLYPqH1uo=;
	h=Date:From:To:Cc:Subject:Message-ID; b=pMi3sQYHnA4G6NdIL0CuJTaE7tCX2ve4JzvLQnDDJZLbmYHszq1/rWKzTxhKfvT/myfQ4pI5Q4ZHPyCE8Rr66AnjLjJUNLhw3bu9qvT4v2J8c4zVEhr+L6HS4U0Mq9cvzSFXKF8a4FYVCH2UX95v6Sw7S3KPC2ey7pHalMhxmd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mwnUjP9r; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mwnUjP9r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785930964; x=1817466964;
  h=date:from:to:cc:subject:message-id;
  bh=VsGUQgRXam5gRsSXsqF77pXM4GB2eujnKGZLYPqH1uo=;
  b=mwnUjP9rovEOUM89p9PAavXbue6NJjDYKf1zPoivE5RKir/B/NLTDvez
   LHjfVgp289VEfcyksSlZvOszxd+uy53SdnqdXRKKrLZJ0P+jQ+mPJE58p
   BbBpDev02l3lOCTTbWspi9XlGacLU6UC32WiHX4Q7TkXcApaTlE4iyl8U
   D4F22hdV4uhO/2BF7jevlDRtwMJRoC8I0c+POxwZTRcShlYC/+K/6tCpl
   nqHLkxqg8vRgHNO7QY7Ni11chCfhUuYu4sXmbcpwhznIUNHw4KRYuZygu
   +Dz8oLun/6EprAZeXMM+AzVFEVNRwWjagf56A0IYoXsrnWTO+Dt9KxdWR
   A==;
X-CSE-ConnectionGUID: FCmQj7HeST6LndKMp7PMyg==
X-CSE-MsgGUID: ldUiTliFQ/68gMW3axx/9w==
X-IronPort-AV: E=McAfee;i="6800,10657,11865"; a="90176916"
X-IronPort-AV: E=Sophos;i="6.25,206,1779174000"; 
   d="scan'208";a="90176916"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 04:56:02 -0700
X-CSE-ConnectionGUID: jqiIKc3qQ5erwR36muKZmg==
X-CSE-MsgGUID: qIhuXGlRS0O4PLWjWvJXzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,206,1779174000"; 
   d="scan'208";a="257928480"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 05 Aug 2026 04:55:59 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wraE1-00000000CJu-1c6I;
	Wed, 05 Aug 2026 11:55:57 +0000
Date: Wed, 05 Aug 2026 19:55:15 +0800
From: kernel test robot <lkp@intel.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org
Subject: [efi:next] BUILD SUCCESS
 eaa4abe54eb5de1ee002aa2e4f88fc49156f2fdb
Message-ID: <202608051902.NrgxZ1fy-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git next
branch HEAD: eaa4abe54eb5de1ee002aa2e4f88fc49156f2fdb  efivarfs: Cache occupied and available space

elapsed time: 1526m

configs tested: 197
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                           randconfig-001    gcc-12.5.0
arc                  randconfig-001-20260804    gcc-8.5.0
arc                  randconfig-001-20260805    gcc-12.5.0
arc                  randconfig-002-20260804    gcc-8.5.0
arc                  randconfig-002-20260805    gcc-12.5.0
arm                       multi_v7_defconfig    gcc-16.1.0
arm                  randconfig-001-20260804    gcc-8.5.0
arm                  randconfig-001-20260805    gcc-12.5.0
arm                  randconfig-002-20260804    gcc-8.5.0
arm                  randconfig-002-20260805    gcc-12.5.0
arm                  randconfig-003-20260804    gcc-8.5.0
arm                  randconfig-003-20260805    gcc-12.5.0
arm                  randconfig-004-20260804    gcc-8.5.0
arm                  randconfig-004-20260805    gcc-12.5.0
arm64                         randconfig-001    gcc-10.5.0
arm64                         randconfig-001    gcc-11.5.0
arm64                randconfig-001-20260804    gcc-11.5.0
arm64                randconfig-001-20260805    gcc-10.5.0
arm64                randconfig-002-20260804    gcc-11.5.0
arm64                randconfig-002-20260805    gcc-10.5.0
arm64                randconfig-003-20260804    gcc-11.5.0
arm64                randconfig-003-20260805    gcc-10.5.0
arm64                randconfig-004-20260804    gcc-11.5.0
arm64                randconfig-004-20260805    gcc-10.5.0
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260804    gcc-11.5.0
csky                 randconfig-001-20260805    gcc-10.5.0
csky                 randconfig-002-20260804    gcc-11.5.0
csky                 randconfig-002-20260805    gcc-10.5.0
hexagon                       randconfig-001    clang-18
hexagon              randconfig-001-20260804    gcc-16.1.0
hexagon              randconfig-001-20260805    clang-18
hexagon              randconfig-002-20260804    gcc-16.1.0
hexagon              randconfig-002-20260805    clang-18
i386                            allmodconfig    gcc-14
i386       buildonly-randconfig-001-20260804    gcc-14
i386       buildonly-randconfig-001-20260805    clang-22
i386       buildonly-randconfig-002-20260804    gcc-14
i386       buildonly-randconfig-002-20260805    clang-22
i386       buildonly-randconfig-003-20260804    gcc-14
i386       buildonly-randconfig-003-20260805    clang-22
i386       buildonly-randconfig-004-20260804    gcc-14
i386       buildonly-randconfig-004-20260805    clang-22
i386       buildonly-randconfig-005-20260804    gcc-14
i386       buildonly-randconfig-005-20260805    clang-22
i386       buildonly-randconfig-006-20260804    gcc-14
i386       buildonly-randconfig-006-20260805    clang-22
i386                 randconfig-001-20260804    clang-22
i386                 randconfig-001-20260805    gcc-13
i386                 randconfig-002-20260804    clang-22
i386                 randconfig-002-20260805    gcc-13
i386                 randconfig-003-20260804    clang-22
i386                 randconfig-003-20260805    gcc-13
i386                 randconfig-004-20260804    clang-22
i386                 randconfig-004-20260805    gcc-13
i386                 randconfig-005-20260804    clang-22
i386                 randconfig-005-20260805    gcc-13
i386                 randconfig-006-20260804    clang-22
i386                 randconfig-006-20260805    gcc-13
i386                 randconfig-007-20260804    clang-22
i386                 randconfig-007-20260805    gcc-13
i386                          randconfig-011    gcc-13
i386                          randconfig-011    gcc-14
i386                 randconfig-011-20260804    gcc-13
i386                 randconfig-011-20260805    gcc-14
i386                 randconfig-012-20260804    gcc-13
i386                 randconfig-012-20260805    gcc-14
i386                 randconfig-013-20260804    gcc-13
i386                 randconfig-013-20260805    gcc-14
i386                 randconfig-014-20260804    gcc-13
i386                 randconfig-014-20260805    gcc-14
i386                 randconfig-015-20260804    gcc-13
i386                 randconfig-015-20260805    gcc-14
i386                 randconfig-016-20260804    gcc-13
i386                 randconfig-016-20260805    gcc-14
i386                 randconfig-017-20260804    gcc-13
i386                 randconfig-017-20260805    gcc-14
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260804    gcc-16.1.0
loongarch            randconfig-001-20260805    clang-18
loongarch            randconfig-002-20260804    gcc-16.1.0
loongarch            randconfig-002-20260805    clang-18
mips                         ath79_defconfig    gcc-16.1.0
mips                          jazz_defconfig    clang-24
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260804    gcc-16.1.0
nios2                randconfig-001-20260805    clang-18
nios2                randconfig-002-20260804    gcc-16.1.0
nios2                randconfig-002-20260805    clang-18
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc                        randconfig-001    gcc-8.5.0
parisc                        randconfig-001    gcc-9.5.0
parisc               randconfig-001-20260804    gcc-8.5.0
parisc               randconfig-001-20260805    gcc-9.5.0
parisc               randconfig-002-20260804    gcc-8.5.0
parisc               randconfig-002-20260805    gcc-9.5.0
powerpc                    ppa8548_defconfig    gcc-16.1.0
powerpc              randconfig-001-20260804    gcc-8.5.0
powerpc              randconfig-001-20260805    gcc-9.5.0
powerpc              randconfig-002-20260804    gcc-8.5.0
powerpc              randconfig-002-20260805    gcc-9.5.0
powerpc64            randconfig-001-20260804    gcc-8.5.0
powerpc64            randconfig-001-20260805    gcc-9.5.0
powerpc64            randconfig-002-20260804    gcc-8.5.0
powerpc64            randconfig-002-20260805    gcc-9.5.0
riscv                         randconfig-001    gcc-8.5.0
riscv                randconfig-001-20260805    gcc-8.5.0
riscv                randconfig-002-20260804    clang-21
riscv                randconfig-002-20260805    gcc-8.5.0
s390                 randconfig-001-20260804    clang-21
s390                 randconfig-001-20260805    gcc-8.5.0
s390                 randconfig-002-20260804    clang-21
s390                 randconfig-002-20260805    gcc-8.5.0
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260804    clang-21
sh                   randconfig-001-20260805    gcc-8.5.0
sh                   randconfig-002-20260804    clang-21
sh                   randconfig-002-20260805    gcc-8.5.0
sh                          se7705_defconfig    gcc-16.1.0
sh                            shx3_defconfig    gcc-16.1.0
sparc                randconfig-001-20260804    gcc-16.1.0
sparc                randconfig-001-20260805    gcc-11.5.0
sparc                randconfig-002-20260804    gcc-16.1.0
sparc                randconfig-002-20260805    gcc-11.5.0
sparc64              randconfig-001-20260804    gcc-16.1.0
sparc64              randconfig-001-20260805    gcc-11.5.0
sparc64              randconfig-002-20260804    gcc-16.1.0
sparc64              randconfig-002-20260805    gcc-11.5.0
um                   randconfig-001-20260804    gcc-16.1.0
um                   randconfig-001-20260805    gcc-11.5.0
um                   randconfig-002-20260804    gcc-16.1.0
um                   randconfig-002-20260805    gcc-11.5.0
x86_64              buildonly-randconfig-001    gcc-14
x86_64     buildonly-randconfig-001-20260804    gcc-14
x86_64     buildonly-randconfig-001-20260805    gcc-14
x86_64     buildonly-randconfig-002-20260804    gcc-14
x86_64     buildonly-randconfig-002-20260805    gcc-14
x86_64     buildonly-randconfig-003-20260804    gcc-14
x86_64     buildonly-randconfig-003-20260805    gcc-14
x86_64     buildonly-randconfig-004-20260804    gcc-14
x86_64     buildonly-randconfig-004-20260805    gcc-14
x86_64     buildonly-randconfig-005-20260804    gcc-14
x86_64     buildonly-randconfig-005-20260805    gcc-14
x86_64     buildonly-randconfig-006-20260804    gcc-14
x86_64     buildonly-randconfig-006-20260805    gcc-14
x86_64                                 kexec    clang-22
x86_64                        randconfig-001    gcc-14
x86_64               randconfig-001-20260804    gcc-14
x86_64               randconfig-001-20260805    gcc-14
x86_64               randconfig-002-20260804    gcc-14
x86_64               randconfig-002-20260805    gcc-14
x86_64               randconfig-003-20260804    gcc-14
x86_64               randconfig-003-20260805    gcc-14
x86_64               randconfig-004-20260804    gcc-14
x86_64               randconfig-004-20260805    gcc-14
x86_64               randconfig-005-20260804    gcc-14
x86_64               randconfig-005-20260805    gcc-14
x86_64               randconfig-006-20260804    gcc-14
x86_64               randconfig-006-20260805    gcc-14
x86_64               randconfig-011-20260804    clang-22
x86_64               randconfig-011-20260805    gcc-14
x86_64               randconfig-012-20260804    clang-22
x86_64               randconfig-012-20260805    gcc-14
x86_64               randconfig-013-20260804    clang-22
x86_64               randconfig-013-20260805    gcc-14
x86_64               randconfig-014-20260804    clang-22
x86_64               randconfig-014-20260805    gcc-14
x86_64               randconfig-015-20260804    clang-22
x86_64               randconfig-015-20260805    gcc-14
x86_64               randconfig-016-20260804    clang-22
x86_64               randconfig-016-20260805    gcc-14
x86_64                        randconfig-071    clang-22
x86_64               randconfig-071-20260804    clang-22
x86_64               randconfig-071-20260805    clang-22
x86_64               randconfig-072-20260804    clang-22
x86_64               randconfig-072-20260805    clang-22
x86_64               randconfig-073-20260804    clang-22
x86_64               randconfig-073-20260805    clang-22
x86_64               randconfig-074-20260804    clang-22
x86_64               randconfig-074-20260805    clang-22
x86_64               randconfig-075-20260804    clang-22
x86_64               randconfig-075-20260805    clang-22
x86_64               randconfig-076-20260804    clang-22
x86_64               randconfig-076-20260805    clang-22
x86_64                          rhel-9.4-bpf    gcc-14
xtensa               randconfig-001-20260804    gcc-16.1.0
xtensa               randconfig-001-20260805    gcc-11.5.0
xtensa               randconfig-002-20260804    gcc-16.1.0
xtensa               randconfig-002-20260805    gcc-11.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
