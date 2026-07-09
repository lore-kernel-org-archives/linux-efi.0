Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78433B2FFE
	for <linux-efi@vger.kernel.org>; Thu,  9 Jul 2026 20:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783627760; cv=none; b=kVlzErDcdtUyE8Y9oWZNPWTKZtWAnoy0nkn58wjpnvuGgtZke1Kodh5M+UOvzRaKlPG0HHL3+ktPd6D5fjwymrMbnptH4cyahn2B2ww4kJPNboQ5oAKWvl6iYwzEeF2snXSHU7U7XJClaZBlkvqBZI6981qotehTyzWDwAElivM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783627760; c=relaxed/simple;
	bh=QeFHMp3bkV5lAtcz3NI4beGPnIGuxzRGr4rcXnaRHK8=;
	h=Date:From:To:Cc:Subject:Message-ID; b=KTEfEMusl1AUtNICh9FM6xXvfHHBmGvigulIfXiIdmDcpnKom/Bkku5cE8TtCPR0sMxNl5opfoCBvVuprGLxfcaN61YybRqefFt4M1brGoXqs6pEqWbu8niEP8PGZEgJpWyaueI4h8nFDUaxlwfNCq/ZjlEbAswen5cGQX4km3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CsquAWY2; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CsquAWY2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783627758; x=1815163758;
  h=date:from:to:cc:subject:message-id;
  bh=QeFHMp3bkV5lAtcz3NI4beGPnIGuxzRGr4rcXnaRHK8=;
  b=CsquAWY2cut9UWo7ICP00nXr0aUTe0xZeuy/6ApdQrHHOj+b/tekKlw8
   PfVVoaEMXEO8gQAaxGVmLQlangCS/eapeNbqrY6sNKCh3+jdnmGecm/2Q
   Hdb6x28+lGhLRdNUIfQdprFfpS7nkuGIRNNfhEIVt9CdXQyM8tdR7r4d7
   h+H87WTRUehstkCurQssOcIp5/cbkeDXX8H7MRJrLrqRANZnM44Utz0Em
   TbLdV+Kd/svDFCzINxMM13YOg4xtm4tGcTgFtfYTscZAeL/a0F+BEyCmS
   LIYp0R7X2LjmkiaP5/BnNBeRUVA/JTED5KOGdkfbD+rrZb7OVoTU+E7ls
   g==;
X-CSE-ConnectionGUID: yIp14FWKT/K1JzWCfQi5fg==
X-CSE-MsgGUID: kViXHZsaR4OsVBTzTMSr5Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="83440495"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="83440495"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 13:09:17 -0700
X-CSE-ConnectionGUID: 0tU5JENNRhmboYsRkqGXnA==
X-CSE-MsgGUID: +coSPDzGQrOMO10hdqyBIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="277921320"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa002.fm.intel.com with ESMTP; 09 Jul 2026 13:09:16 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1whv3Z-00000000I4t-2zQJ;
	Thu, 09 Jul 2026 20:09:13 +0000
Date: Fri, 10 Jul 2026 04:08:28 +0800
From: kernel test robot <lkp@intel.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org
Subject: [efi:next] BUILD SUCCESS
 cf790fdb851867532b9a0f88588dcce648dbffe9
Message-ID: <202607100418.654YWAdt-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git next
branch HEAD: cf790fdb851867532b9a0f88588dcce648dbffe9  efi/runtime-wrappers: retire the worker if a wedged call ever returns

elapsed time: 897m

configs tested: 299
configs skipped: 4

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
arc                              allmodconfig    clang-23
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    clang-23
arc                              allyesconfig    gcc-16.1.0
arc                                 defconfig    gcc-16.1.0
arc                   randconfig-001-20260709    gcc-8.5.0
arc                   randconfig-001-20260710    clang-23
arc                   randconfig-002-20260709    gcc-8.5.0
arc                   randconfig-002-20260710    clang-23
arm                               allnoconfig    clang-17
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-23
arm                                 defconfig    gcc-16.1.0
arm                          ep93xx_defconfig    clang-23
arm                   randconfig-001-20260709    gcc-8.5.0
arm                   randconfig-001-20260710    clang-23
arm                   randconfig-002-20260709    gcc-8.5.0
arm                   randconfig-002-20260710    clang-23
arm                   randconfig-003-20260709    gcc-8.5.0
arm                   randconfig-003-20260710    clang-23
arm                   randconfig-004-20260709    gcc-8.5.0
arm                   randconfig-004-20260710    clang-23
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260709    gcc-16.1.0
arm64                 randconfig-001-20260710    gcc-10.5.0
arm64                 randconfig-002-20260709    gcc-16.1.0
arm64                 randconfig-002-20260710    gcc-10.5.0
arm64                 randconfig-003-20260709    gcc-16.1.0
arm64                 randconfig-003-20260710    gcc-10.5.0
arm64                 randconfig-004-20260709    gcc-16.1.0
arm64                 randconfig-004-20260710    gcc-10.5.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260709    gcc-16.1.0
csky                  randconfig-001-20260710    gcc-10.5.0
csky                  randconfig-002-20260709    gcc-16.1.0
csky                  randconfig-002-20260710    gcc-10.5.0
hexagon                          allmodconfig    clang-23
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    gcc-16.1.0
hexagon                        randconfig-001    gcc-11.5.0
hexagon               randconfig-001-20260709    clang-18
hexagon               randconfig-001-20260709    gcc-11.5.0
hexagon               randconfig-001-20260710    gcc-12.5.0
hexagon                        randconfig-002    gcc-11.5.0
hexagon               randconfig-002-20260709    clang-18
hexagon               randconfig-002-20260709    gcc-11.5.0
hexagon               randconfig-002-20260710    gcc-12.5.0
i386                             allmodconfig    clang-22
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386                             allyesconfig    gcc-14
i386                 buildonly-randconfig-001    gcc-14
i386        buildonly-randconfig-001-20260709    gcc-14
i386        buildonly-randconfig-001-20260710    clang-22
i386                 buildonly-randconfig-002    gcc-14
i386        buildonly-randconfig-002-20260709    gcc-14
i386        buildonly-randconfig-002-20260710    clang-22
i386                 buildonly-randconfig-003    gcc-14
i386        buildonly-randconfig-003-20260709    gcc-14
i386        buildonly-randconfig-003-20260710    clang-22
i386                 buildonly-randconfig-004    gcc-14
i386        buildonly-randconfig-004-20260709    gcc-14
i386        buildonly-randconfig-004-20260710    clang-22
i386                 buildonly-randconfig-005    gcc-14
i386        buildonly-randconfig-005-20260709    gcc-14
i386        buildonly-randconfig-005-20260710    clang-22
i386                 buildonly-randconfig-006    gcc-14
i386        buildonly-randconfig-006-20260709    gcc-14
i386        buildonly-randconfig-006-20260710    clang-22
i386                                defconfig    gcc-16.1.0
i386                  randconfig-001-20260709    gcc-14
i386                  randconfig-001-20260710    clang-22
i386                  randconfig-002-20260709    gcc-14
i386                  randconfig-002-20260710    clang-22
i386                  randconfig-003-20260709    gcc-14
i386                  randconfig-003-20260710    clang-22
i386                  randconfig-004-20260709    gcc-14
i386                  randconfig-004-20260710    clang-22
i386                  randconfig-005-20260709    gcc-14
i386                  randconfig-005-20260710    clang-22
i386                  randconfig-006-20260709    gcc-14
i386                  randconfig-006-20260710    clang-22
i386                  randconfig-007-20260709    gcc-14
i386                  randconfig-007-20260710    clang-22
i386                           randconfig-011    gcc-14
i386                  randconfig-011-20260709    gcc-14
i386                           randconfig-012    gcc-14
i386                  randconfig-012-20260709    gcc-14
i386                           randconfig-013    gcc-14
i386                  randconfig-013-20260709    gcc-14
i386                           randconfig-014    gcc-14
i386                  randconfig-014-20260709    gcc-14
i386                           randconfig-015    gcc-14
i386                  randconfig-015-20260709    gcc-14
i386                           randconfig-016    gcc-14
i386                  randconfig-016-20260709    gcc-14
i386                           randconfig-017    gcc-14
i386                  randconfig-017-20260709    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-23
loongarch                      randconfig-001    gcc-11.5.0
loongarch             randconfig-001-20260709    clang-18
loongarch             randconfig-001-20260709    gcc-11.5.0
loongarch             randconfig-001-20260710    gcc-12.5.0
loongarch                      randconfig-002    gcc-11.5.0
loongarch             randconfig-002-20260709    clang-18
loongarch             randconfig-002-20260709    gcc-11.5.0
loongarch             randconfig-002-20260710    gcc-12.5.0
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    clang-23
m68k                                defconfig    clang-23
m68k                      m54418evb_defconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    clang-23
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
mips                      malta_kvm_defconfig    gcc-16.1.0
nios2                         10m50_defconfig    gcc-11.5.0
nios2                            allmodconfig    clang-20
nios2                             allnoconfig    clang-23
nios2                               defconfig    clang-23
nios2                          randconfig-001    gcc-11.5.0
nios2                 randconfig-001-20260709    clang-18
nios2                 randconfig-001-20260709    gcc-11.5.0
nios2                 randconfig-001-20260710    gcc-12.5.0
nios2                          randconfig-002    gcc-11.5.0
nios2                 randconfig-002-20260709    clang-18
nios2                 randconfig-002-20260709    gcc-11.5.0
nios2                 randconfig-002-20260710    gcc-12.5.0
openrisc                         allmodconfig    clang-20
openrisc                          allnoconfig    clang-23
openrisc                            defconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    clang-23
parisc                           allyesconfig    clang-17
parisc                              defconfig    gcc-16.1.0
parisc                         randconfig-001    clang-23
parisc                randconfig-001-20260709    clang-23
parisc                randconfig-001-20260710    clang-17
parisc                         randconfig-002    clang-23
parisc                randconfig-002-20260709    clang-23
parisc                randconfig-002-20260710    clang-17
parisc64                            defconfig    clang-23
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-23
powerpc                   microwatt_defconfig    gcc-16.1.0
powerpc                 mpc836x_rdk_defconfig    clang-23
powerpc                        randconfig-001    clang-23
powerpc               randconfig-001-20260709    clang-23
powerpc               randconfig-001-20260710    clang-17
powerpc                        randconfig-002    clang-23
powerpc               randconfig-002-20260709    clang-23
powerpc               randconfig-002-20260710    clang-17
powerpc64                      randconfig-001    clang-23
powerpc64             randconfig-001-20260709    clang-23
powerpc64             randconfig-001-20260710    clang-17
powerpc64                      randconfig-002    clang-23
powerpc64             randconfig-002-20260709    clang-23
powerpc64             randconfig-002-20260710    clang-17
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                            allyesconfig    clang-23
riscv                               defconfig    gcc-16.1.0
riscv                          randconfig-001    clang-22
riscv                 randconfig-001-20260709    clang-22
riscv                 randconfig-001-20260710    clang-17
riscv                          randconfig-002    clang-22
riscv                 randconfig-002-20260709    clang-22
riscv                 randconfig-002-20260710    clang-17
s390                             allmodconfig    clang-17
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    gcc-16.1.0
s390                           randconfig-001    clang-22
s390                  randconfig-001-20260709    clang-22
s390                  randconfig-001-20260710    clang-17
s390                           randconfig-002    clang-22
s390                  randconfig-002-20260709    clang-22
s390                  randconfig-002-20260710    clang-17
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-23
sh                               allyesconfig    clang-17
sh                                  defconfig    gcc-14
sh                             randconfig-001    clang-22
sh                    randconfig-001-20260709    clang-22
sh                    randconfig-001-20260710    clang-17
sh                             randconfig-002    clang-22
sh                    randconfig-002-20260709    clang-22
sh                    randconfig-002-20260710    clang-17
sparc                             allnoconfig    clang-23
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260709    gcc-8.5.0
sparc                 randconfig-002-20260709    gcc-8.5.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260709    gcc-8.5.0
sparc64               randconfig-002-20260709    gcc-8.5.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260709    gcc-8.5.0
um                    randconfig-002-20260709    gcc-8.5.0
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-22
x86_64               buildonly-randconfig-001    clang-22
x86_64      buildonly-randconfig-001-20260709    clang-22
x86_64               buildonly-randconfig-002    clang-22
x86_64      buildonly-randconfig-002-20260709    clang-22
x86_64               buildonly-randconfig-003    clang-22
x86_64      buildonly-randconfig-003-20260709    clang-22
x86_64               buildonly-randconfig-004    clang-22
x86_64      buildonly-randconfig-004-20260709    clang-22
x86_64               buildonly-randconfig-005    clang-22
x86_64      buildonly-randconfig-005-20260709    clang-22
x86_64               buildonly-randconfig-006    clang-22
x86_64      buildonly-randconfig-006-20260709    clang-22
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                         randconfig-001    clang-22
x86_64                randconfig-001-20260709    clang-22
x86_64                randconfig-001-20260709    gcc-14
x86_64                         randconfig-002    clang-22
x86_64                randconfig-002-20260709    clang-22
x86_64                randconfig-002-20260709    gcc-14
x86_64                         randconfig-003    clang-22
x86_64                randconfig-003-20260709    clang-22
x86_64                randconfig-003-20260709    gcc-14
x86_64                         randconfig-004    clang-22
x86_64                randconfig-004-20260709    clang-22
x86_64                randconfig-004-20260709    gcc-14
x86_64                         randconfig-005    clang-22
x86_64                randconfig-005-20260709    clang-22
x86_64                randconfig-005-20260709    gcc-14
x86_64                         randconfig-006    clang-22
x86_64                randconfig-006-20260709    clang-22
x86_64                randconfig-006-20260709    gcc-14
x86_64                         randconfig-011    gcc-14
x86_64                randconfig-011-20260709    gcc-14
x86_64                randconfig-011-20260710    clang-22
x86_64                         randconfig-012    gcc-14
x86_64                randconfig-012-20260709    gcc-14
x86_64                randconfig-012-20260710    clang-22
x86_64                         randconfig-013    gcc-14
x86_64                randconfig-013-20260709    gcc-14
x86_64                randconfig-013-20260710    clang-22
x86_64                         randconfig-014    gcc-14
x86_64                randconfig-014-20260709    gcc-14
x86_64                randconfig-014-20260710    clang-22
x86_64                         randconfig-015    gcc-14
x86_64                randconfig-015-20260709    gcc-14
x86_64                randconfig-015-20260710    clang-22
x86_64                         randconfig-016    gcc-14
x86_64                randconfig-016-20260709    gcc-14
x86_64                randconfig-016-20260710    clang-22
x86_64                         randconfig-071    clang-22
x86_64                randconfig-071-20260709    clang-22
x86_64                         randconfig-072    clang-22
x86_64                randconfig-072-20260709    clang-22
x86_64                         randconfig-073    clang-22
x86_64                randconfig-073-20260709    clang-22
x86_64                         randconfig-074    clang-22
x86_64                randconfig-074-20260709    clang-22
x86_64                         randconfig-075    clang-22
x86_64                randconfig-075-20260709    clang-22
x86_64                         randconfig-076    clang-22
x86_64                randconfig-076-20260709    clang-22
x86_64                               rhel-9.4    clang-22
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-22
x86_64                    rhel-9.4-kselftests    clang-22
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-22
xtensa                            allnoconfig    clang-23
xtensa                           allyesconfig    clang-20
xtensa                          iss_defconfig    gcc-16.1.0
xtensa                randconfig-001-20260709    gcc-8.5.0
xtensa                randconfig-002-20260709    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
