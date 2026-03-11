Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29493BB9E2
	for <linux-efi@vger.kernel.org>; Wed, 11 Mar 2026 09:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773220869; cv=none; b=GyBZF4QweHI4VIUA8EfapSkQUJ4nVxFYVepeZ5F/30AGDurNMVRMRRvaRiskbTkScWSovwHfsGwviMlYhWt9GiN+EpA4cp8Hqrbxldn21p75Mfv8s8Uf6sF1MrApOn78vASe5RQ3Jb33+TJSbzULwlAjP9wkWlZvH5rmpZwEcC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773220869; c=relaxed/simple;
	bh=PyyXzeptiNsFYKHlV0ioPovyXXX8B1pe7XwsaZ0DOAE=;
	h=Date:From:To:Cc:Subject:Message-ID; b=RsXbqHEVwpDOFCqRu3/KqAP5rajOmIm2w0bLfMSLkGKHTuqQpO2g4PztDXbAl6nlgYz1DWbONAsUTrhEn89gWKsATW/wdRzYZp7Rko04lxARivsKRE5h6GNnfiGOrgFyYLoMkP5oobwmqBeUnMv1Uy7XtNkFtAU0LG6O4NL34bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kUPvc8ws; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kUPvc8ws"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773220863; x=1804756863;
  h=date:from:to:cc:subject:message-id;
  bh=PyyXzeptiNsFYKHlV0ioPovyXXX8B1pe7XwsaZ0DOAE=;
  b=kUPvc8wsUsjUKgczAptgOBHefMc0L0dJxvUjdYIObTDuil34kztA3ITH
   nuonWoEQo3osKGv6wKDLYaWVzLEK59Daddtp1xaA/qQZs+iRr671GDntD
   i+DarnYNApAXhS2V7dzEKpaZlgyrwJDZJRFpC4R1YeLn5SH4sr7Oa6ceR
   vRbnipbdvyQQzH3qVJMN5uYrpoBvN1OaJbOaPaJfk5mdhosUiE78jDzDI
   6AM5YOcYHAbr6QJWzgWg7QTGwI3huNIyxpMDPMaEsbFmGtLhE0LEdlFBL
   8BmWaYiOlyT9lzRf6T3GXqbXVdTndvF+9N24AxWlSntc1xBktqjVKum7Q
   w==;
X-CSE-ConnectionGUID: fob5oksER2+8M4pd7phLOw==
X-CSE-MsgGUID: KfA2GL6FQwyoCdS+d5JuVw==
X-IronPort-AV: E=McAfee;i="6800,10657,11725"; a="85760533"
X-IronPort-AV: E=Sophos;i="6.23,113,1770624000"; 
   d="scan'208";a="85760533"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2026 02:21:03 -0700
X-CSE-ConnectionGUID: IGGZL6qzS9SrvX8QsIPKVg==
X-CSE-MsgGUID: S5kFmo89SYOY+3Tz+fJT6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,113,1770624000"; 
   d="scan'208";a="225102228"
Received: from lkp-server01.sh.intel.com (HELO 418530b1a366) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 11 Mar 2026 02:21:01 -0700
Received: from kbuild by 418530b1a366 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w0FkQ-000000000wv-24Gk;
	Wed, 11 Mar 2026 09:20:58 +0000
Date: Wed, 11 Mar 2026 17:20:42 +0800
From: kernel test robot <lkp@intel.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org
Subject: [efi:next] BUILD SUCCESS
 5ff90186de7118e174d8658164cbe23825e3a8bb
Message-ID: <202603111735.SAn1Zkc9-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git next
branch HEAD: 5ff90186de7118e174d8658164cbe23825e3a8bb  efi: libstub: fix type of fdt 32 and 64bit variables

elapsed time: 730m

configs tested: 119
configs skipped: 0

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
arc                              allmodconfig    clang-16
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    gcc-15.2.0
arc                   randconfig-001-20260311    gcc-8.5.0
arc                   randconfig-002-20260311    gcc-8.5.0
arm                               allnoconfig    clang-23
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    clang-16
arm                              allyesconfig    gcc-15.2.0
arm                   randconfig-001-20260311    gcc-8.5.0
arm                   randconfig-002-20260311    gcc-8.5.0
arm                   randconfig-003-20260311    gcc-8.5.0
arm                   randconfig-004-20260311    gcc-8.5.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.2.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-15.2.0
hexagon               randconfig-001-20260311    gcc-8.5.0
hexagon               randconfig-002-20260311    gcc-8.5.0
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260311    clang-20
i386        buildonly-randconfig-002-20260311    clang-20
i386        buildonly-randconfig-003-20260311    clang-20
i386        buildonly-randconfig-004-20260311    clang-20
i386        buildonly-randconfig-005-20260311    clang-20
i386        buildonly-randconfig-006-20260311    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-23
loongarch                         allnoconfig    gcc-15.2.0
loongarch             randconfig-001-20260311    gcc-8.5.0
loongarch             randconfig-002-20260311    gcc-8.5.0
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    clang-16
m68k                             allyesconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
nios2                            allmodconfig    clang-23
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                 randconfig-001-20260311    gcc-8.5.0
nios2                 randconfig-002-20260311    gcc-8.5.0
openrisc                         allmodconfig    clang-23
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    clang-23
openrisc                          allnoconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    clang-23
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-15.2.0
powerpc                         wii_defconfig    gcc-15.2.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-15.2.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    gcc-14
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-011-20260311    clang-20
x86_64                randconfig-012-20260311    clang-20
x86_64                randconfig-013-20260311    clang-20
x86_64                randconfig-014-20260311    clang-20
x86_64                randconfig-015-20260311    gcc-14
x86_64                randconfig-016-20260311    gcc-13
x86_64                randconfig-071-20260311    gcc-14
x86_64                randconfig-072-20260311    gcc-14
x86_64                randconfig-073-20260311    gcc-14
x86_64                randconfig-074-20260311    gcc-14
x86_64                randconfig-075-20260311    gcc-14
x86_64                randconfig-076-20260311    gcc-14
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

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
