Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.10
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795783241;
	b=YRaVkpi8f+gDt0o4pN8O7Uo0kHRYMCUHGx/tgxp9csIehKvWXbLwaYEtOajYsXjyR/lM
	 dVd5jydREc84ZSLN0X4cc2kyKlBMXxkQjxN6QilCuT3UtcUIg/arDD4T0M5QJEOkf65/K
	 YH5Ws84OXet3jrnJWlKa3Ccgh77Js9vu4pNEYJDIxwtQgPusevZYI4KUcy1WehoGBAPPo
	 MuqeDq3OMSDzcfzcyKF+/M7s7XJ3P8CCWGTqA4cwSCoD7bvtaQ+ZXK87pxnbjiM8Rt9Ha
	 xmECdaZCpxl7VDqECJx+5PpgCOOcmoe6tmFrw2DlCHcn9Pl9hWA7H355o+nQcTzK1WA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795783241;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=INk/Y8FUhZ8GnaG0t0rNRijtaMv8u637PsZJYNGnmcc=;
	b=Xqm5Taz4NkPnATcCJlG5Ehwkjs7fDPt29Y9ofhr7Wt0V7rUCYHCIgAy1RhiImrYPqBVG
	 E6NUA7Wzvif8DJpj5PnIYbpuEldi8k4w2KVl6LVHe/N8hp5VM0GObriOaRh2Oi8/0Qxpg
	 n/rXmCG/uaSdbvVtha+4uYfVjdYIagFWMDNinXBEiQRQ1fiwbsQYXWSurgt48g/tGVvh/
	 YGmj57lZXdoM55QBO36uRJ9m25FVL6R7WtqY/ywIYycR6AnkHUO5k0wZ8RGoWSafuBl5j
	 IyeQIolTCqMqWLvzsaBby8Yb0rPQAdLGqCJc1Rars40bOpk//A+wQtYarK1cShh/6bQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=JbYpboky;
	arc=none smtp.remote-ip=192.198.163.10
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB8A606A31E
	for <linux-efi@vger.kernel.org>; Fri, 27 Nov 2026 12:40:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CBB8A606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=JbYpboky
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795783241; x=1827319241;
  h=date:from:to:cc:subject:message-id;
  bh=9+1/q0WT79e07g5lCLmIZg4MeKeaSvH2csDHWrnP0co=;
  b=JbYpbokyL0lw82ZogAdbqB9o0Inoco2grNa72X+L3ucBM74dBlHp9z+Y
   e3TJhGc3gyAsf39bI0crjORvMETtQnwEjt2yizHh0rWa9Deb3X+sZ4N6T
   j6/UZL+pCQraPThmFcTXr93CPgC+twZAHcHagd1yWbIvCboAqrYhW++Xm
   XGbQINHH1yhL5OshquUMJAqxiapuOi5byi0gmOj2cmCJ+amu/TJfGG9C9
   AvbjljgkN5tGAsTOM1kO+yuS+WhN/oD+MJlWR/7kxc6Qbdu7rb9Nb4WUa
   q9zZemQenJ/2IqDCfUJCeGByIQ2G3pkgvXon0qQ2K9tU09A7X+XyMBVX2
   w==;
X-CSE-ConnectionGUID: NvvHzHNrS++C6x7Vla/+3w==
X-CSE-MsgGUID: 9nYWAI3PTsqQ53Qrg6gFLw==
X-IronPort-AV: E=McAfee;i="6800,10657,11979"; a="4584727"
X-IronPort-AV: E=Sophos;i="6.27,236,1787036400"; 
   d="scan'208";a="4584727"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2026 04:40:40 -0800
X-CSE-ConnectionGUID: X78vI6CtQfKioEA9U3Rx+Q==
X-CSE-MsgGUID: pQlxaY1LRdGeCm8MbjYVxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,236,1787036400"; 
   d="scan'208";a="12273653"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 27 Nov 2026 04:40:39 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xWvFk-00000001W58-2LlG;
	Fri, 27 Nov 2026 12:40:36 +0000
Date: Fri, 27 Nov 2026 20:40:27 +0800
From: kernel test robot <lkp@intel.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org
Subject: [efi:urgent] BUILD SUCCESS
 fe57062e09bc162be9133695d5f1459c1c0e46c0
Message-ID: <20261127204027.sL7GqgGD-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git urgent
branch HEAD: fe57062e09bc162be9133695d5f1459c1c0e46c0  efi/libstub: loongarch: Provide 64-bit integer shift helpers for 32-bit

elapsed time: 770m

configs tested: 192
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
arc                               allmodconfig    clang-24
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    clang-24
arc                                  defconfig    gcc-16.2.0
arc                      nsimosci_hs_defconfig    gcc-16.2.0
arc                   randconfig-1000-20261127    gcc-8.5.0
arc                   randconfig-1001-20261127    gcc-8.5.0
arc                   randconfig-2200-20261127    gcc-16.2.0 smatch
arm                                allnoconfig    gcc-16.2.0
arm                               allyesconfig    clang-24
arm                                  defconfig    gcc-16.2.0
arm                             dove_defconfig    gcc-16.2.0
arm                   randconfig-1000-20261127    gcc-8.5.0
arm                   randconfig-1001-20261127    gcc-8.5.0
arm                   randconfig-1002-20261127    gcc-8.5.0
arm                   randconfig-1003-20261127    gcc-8.5.0
arm                   randconfig-2200-20261127    gcc-10.5.0 smatch
arm                         realview_defconfig    gcc-16.2.0
arm                         vexpress_defconfig    gcc-16.2.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261127    gcc-8.5.0
arm64                 randconfig-1001-20261127    gcc-8.5.0
arm64                 randconfig-1002-20261127    gcc-8.5.0
arm64                 randconfig-1003-20261127    gcc-8.5.0
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261127    gcc-8.5.0
csky                  randconfig-1001-20261127    gcc-8.5.0
csky                 randconfig-r2108-20261127    gcc-11.5.0 cocci
csky                 randconfig-r2109-20261127    gcc-9.5.0  cocci
hexagon                           allmodconfig    gcc-16.2.0
hexagon                            allnoconfig    gcc-16.2.0
hexagon                              defconfig    gcc-16.2.0
hexagon               randconfig-1000-20261127    gcc-9.5.0
hexagon               randconfig-1001-20261127    gcc-9.5.0
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-16.2.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20261127    clang-22
i386        buildonly-randconfig-1001-20261127    clang-22
i386        buildonly-randconfig-1002-20261127    clang-22
i386        buildonly-randconfig-1003-20261127    clang-22
i386        buildonly-randconfig-1004-20261127    clang-22
i386        buildonly-randconfig-1005-20261127    clang-22
i386                                 defconfig    gcc-16.2.0
i386                  randconfig-1000-20261127    clang-22
i386                  randconfig-1001-20261127    clang-22
i386                  randconfig-1002-20261127    clang-22
i386                  randconfig-1003-20261127    clang-22
i386                  randconfig-1004-20261127    clang-22
i386                  randconfig-1005-20261127    clang-22
i386                  randconfig-1006-20261127    clang-22
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.2.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261127    gcc-9.5.0
loongarch             randconfig-1001-20261127    gcc-9.5.0
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    clang-24
m68k                                 defconfig    clang-24
m68k                         m5407c3_defconfig    gcc-16.2.0
m68k                  randconfig-2001-20261127    gcc-13.5.0
m68k                  randconfig-2200-20261127    gcc-9.5.0  smatch
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    clang-24
microblaze            randconfig-2200-20261127    gcc-16.2.0 smatch
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                        bmips_be_defconfig    gcc-16.2.0
mips                      decstation_defconfig    gcc-16.2.0
mips                 randconfig-r2110-20261127    clang-24   cocci
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261127    gcc-9.5.0
nios2                 randconfig-1001-20261127    gcc-9.5.0
nios2                randconfig-r2106-20261127    gcc-8.5.0  cocci
nios2                randconfig-r2111-20261127    gcc-8.5.0  cocci
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc                             defconfig    gcc-16.2.0
openrisc              randconfig-2200-20261127    gcc-12.5.0 smatch
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.2.0
parisc                 generic-32bit_defconfig    gcc-16.2.0
parisc                randconfig-1000-20261127    gcc-12.5.0
parisc                randconfig-1001-20261127    gcc-12.5.0
parisc               randconfig-r2107-20261127    gcc-8.5.0  cocci
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    clang-24
powerpc                    bluestone_defconfig    gcc-16.2.0
powerpc                      ksi8560_defconfig    gcc-16.2.0
powerpc                      mpc512x_defconfig    gcc-16.2.0
powerpc                          ps3_defconfig    gcc-16.2.0
powerpc               randconfig-1000-20261127    gcc-12.5.0
powerpc               randconfig-1001-20261127    gcc-12.5.0
powerpc               randconfig-2200-20261127    clang-24   smatch
powerpc                          wii_defconfig    gcc-16.2.0
powerpc64             randconfig-1000-20261127    gcc-12.5.0
powerpc64             randconfig-1001-20261127    gcc-12.5.0
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.2.0
riscv                     nommu_k210_defconfig    gcc-16.2.0
riscv                 randconfig-1000-20261127    gcc-12.5.0
riscv                 randconfig-1001-20261127    gcc-12.5.0
riscv                 randconfig-2200-20261127    gcc-13.5.0 smatch
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    gcc-16.2.0
s390                  randconfig-1000-20261127    gcc-12.5.0
s390                  randconfig-1001-20261127    gcc-12.5.0
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                                   defconfig    gcc-14
sh                         dreamcast_defconfig    gcc-16.2.0
sh                    randconfig-1000-20261127    gcc-12.5.0
sh                    randconfig-1001-20261127    gcc-12.5.0
sh                    randconfig-2000-20261127    gcc-14.4.0
sh                    randconfig-2001-20261127    gcc-16.2.0
sh                    randconfig-2002-20261127    gcc-16.2.0
sh                    randconfig-2003-20261127    gcc-12.5.0
sh                    randconfig-2004-20261127    gcc-16.2.0
sh                    randconfig-2005-20261127    gcc-12.5.0
sh                         sh7757lcr_defconfig    gcc-16.2.0
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261127    gcc-14
sparc                 randconfig-1001-20261127    gcc-14
sparc                 randconfig-2000-20261127    gcc-8.5.0
sparc                 randconfig-2001-20261127    gcc-8.5.0
sparc                 randconfig-2200-20261127    gcc-12.5.0 smatch
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261127    gcc-14
sparc64               randconfig-1001-20261127    gcc-14
sparc64               randconfig-2000-20261127    clang-24
sparc64               randconfig-2001-20261127    gcc-13.5.0
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.2.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261127    gcc-14
um                    randconfig-1001-20261127    gcc-14
um                    randconfig-2000-20261127    gcc-13
um                    randconfig-2001-20261127    clang-24
um                    randconfig-2200-20261127    clang-24   smatch
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20261127    gcc-14
x86_64      buildonly-randconfig-1001-20261127    gcc-14
x86_64      buildonly-randconfig-1002-20261127    gcc-14
x86_64      buildonly-randconfig-1003-20261127    gcc-14
x86_64      buildonly-randconfig-1004-20261127    gcc-14
x86_64      buildonly-randconfig-1005-20261127    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261127    gcc-14
x86_64                randconfig-1001-20261127    gcc-14
x86_64                randconfig-1002-20261127    gcc-14
x86_64                randconfig-1003-20261127    gcc-14
x86_64                randconfig-1004-20261127    gcc-14
x86_64                randconfig-1005-20261127    gcc-14
x86_64                                rhel-9.4    clang-22
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                            allyesconfig    clang-20
xtensa                randconfig-1000-20261127    gcc-14
xtensa                randconfig-1001-20261127    gcc-14

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
