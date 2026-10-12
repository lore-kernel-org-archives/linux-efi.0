Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256863E765A
	for <linux-efi@vger.kernel.org>; Mon, 12 Oct 2026 21:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791839051; cv=none; b=E4kVKvz6OC0OSr9V+uwROLQ0drFaMJ63zkEtZnw9ZiGdr6E2omzaxGkrwONzZDqUS6uYywOrnL/Wer1dSb/DsDWmQ+cwNOmP5qVyHmHyQQrCd/C1/t9UPl3gaGSSVgWVNo8hD7LEZgktYI6dhL9+6eE7YtOK2Yu9bFan9aq2Qxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791839051; c=relaxed/simple;
	bh=2Rsw1x82okZrFTV930J87rlhLt4sFLeN/oNu2QqrlTM=;
	h=Date:From:To:Cc:Subject:Message-ID; b=IMhNFvSF80rT1Pd3wFr/QuoVOy0abM/rmix9tTiwCMEBX5YoB76hfdMoVoVamtYVJeLozUNStOF7D84huRgKdgDOpxRucK/fdPw4aQ8xxc8MMA+5E1ZO/nOBo6z9sDo3x3VDaCX6R8GjLDlCw91rIEJKcFcAoz/kHRFZpIxFRIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jEjV5cM1; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jEjV5cM1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791839049; x=1823375049;
  h=date:from:to:cc:subject:message-id;
  bh=2Rsw1x82okZrFTV930J87rlhLt4sFLeN/oNu2QqrlTM=;
  b=jEjV5cM1qHIRY55PqNDzSnTtwBeJzh1T8dKcP0YIu1Ruz+s0TYtiCnvK
   96hj6AK+7CEzbfs1J0Y3pQGM8aOloJL/ryggheSPlqllPFyHMD78FH45P
   PBv7qUez2q5wirzzOoxvsFY/JUkaqi072mwCvQ5BuPbpCq7CCtRlE7mv8
   ogYoMt0h//IpMtBu3rkChsBr5bRIJF1cd+ERjtWtgIiu27n5LUshL5HyO
   CoWxiEZpA9l7xCyP3yLg7MrUTdF99ZaalNBWPLNcbwQNhurO6hZE1xjmE
   luMdIhBIjP5zNFFYWaKFW6zJcWO0LhAw2qWBOe0Z3Jnx0qJwZTY5IxHvY
   w==;
X-CSE-ConnectionGUID: quDYM13iReC2hiFsfBz5UA==
X-CSE-MsgGUID: IdHIhK7cS3CfpNpGsr2efg==
X-IronPort-AV: E=McAfee;i="6800,10657,11933"; a="453793"
X-IronPort-AV: E=Sophos;i="6.27,154,1787036400"; 
   d="scan'208";a="453793"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2026 14:04:08 -0700
X-CSE-ConnectionGUID: AZPmx59BQBa6LXiEM+u2HA==
X-CSE-MsgGUID: JFu7pf2BTwGjxwJuC275Mw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,154,1787036400"; 
   d="scan'208";a="1465245"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 12 Oct 2026 14:04:07 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xGNBk-00000000C62-3CBt;
	Mon, 12 Oct 2026 21:04:04 +0000
Date: Tue, 13 Oct 2026 05:03:26 +0800
From: kernel test robot <lkp@intel.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org
Subject: [efi:next] BUILD SUCCESS
 191c12e9a71687b61d3298ac1e0d0d7298d103f0
Message-ID: <202610130524.Ohx4Cdo6-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git next
branch HEAD: 191c12e9a71687b61d3298ac1e0d0d7298d103f0  efi/runtime-wrappers: Don't park the worker after a recovered firmware fault

elapsed time: 1465m

configs tested: 365
configs skipped: 10

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r2111-20261010    clang-20   cocci
alpha                randconfig-r2202-20261010    gcc-8.5.0  smatch
alpha                randconfig-r2303-20261010    gcc-13.4.0 sparse
arc                               allmodconfig    clang-24
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    clang-24
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20261012    gcc-8.5.0
arc                   randconfig-1000-20261013    clang-24
arc                   randconfig-1001-20261012    gcc-8.5.0
arc                   randconfig-1001-20261013    clang-24
arc                   randconfig-2000-20261010    gcc-12.5.0
arc                   randconfig-2000-20261010    gcc-8.5.0
arc                   randconfig-2001-20261010    gcc-8.5.0
arc                  randconfig-r2103-20261010    gcc-8.5.0  cocci
arc                  randconfig-r2108-20261010    gcc-8.5.0  cocci
arc                  randconfig-r2306-20261010    gcc-14     sparse
arm                                allnoconfig    gcc-16.1.0
arm                               allyesconfig    clang-24
arm                                  defconfig    gcc-16.1.0
arm                          nhk8815_defconfig    clang-24
arm                   randconfig-1000-20261012    gcc-8.5.0
arm                   randconfig-1000-20261013    clang-24
arm                   randconfig-1001-20261012    gcc-8.5.0
arm                   randconfig-1001-20261013    clang-24
arm                   randconfig-1002-20261012    gcc-8.5.0
arm                   randconfig-1002-20261013    clang-24
arm                   randconfig-1003-20261012    gcc-8.5.0
arm                   randconfig-1003-20261013    clang-24
arm                   randconfig-2000-20261010    gcc-14.3.0
arm                   randconfig-2000-20261010    gcc-8.5.0
arm                   randconfig-2001-20261010    gcc-16.1.0
arm                   randconfig-2001-20261010    gcc-8.5.0
arm                  randconfig-r2105-20261010    clang-17   cocci
arm                  randconfig-r2305-20261010    gcc-15.2.0 sparse
arm                  randconfig-r2309-20261010    clang-24   sparse
arm                  randconfig-r2310-20261010    clang-24   sparse
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20261012    clang-24
arm64                 randconfig-1000-20261013    gcc-9.5.0
arm64                 randconfig-1001-20261012    clang-24
arm64                 randconfig-1001-20261013    gcc-9.5.0
arm64                 randconfig-1002-20261012    clang-24
arm64                 randconfig-1002-20261013    gcc-9.5.0
arm64                 randconfig-1003-20261012    clang-24
arm64                 randconfig-1003-20261013    gcc-9.5.0
arm64                 randconfig-2000-20261010    gcc-16.1.0
arm64                 randconfig-2000-20261010    gcc-8.5.0
arm64                 randconfig-2001-20261010    clang-17
arm64                 randconfig-2001-20261010    gcc-16.1.0
arm64                randconfig-r2105-20261010    clang-20   cocci
arm64                randconfig-r2109-20261010    gcc-8.5.0  cocci
arm64                randconfig-r2301-20261010    gcc-15.2.0 sparse
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20261012    clang-24
csky                  randconfig-1000-20261013    gcc-9.5.0
csky                  randconfig-1001-20261012    clang-24
csky                  randconfig-1001-20261013    gcc-9.5.0
csky                  randconfig-2000-20261010    gcc-12.5.0
csky                  randconfig-2000-20261010    gcc-16.1.0
csky                  randconfig-2001-20261010    gcc-16.1.0
csky                 randconfig-r2308-20261010    clang-24   sparse
csky                 randconfig-r2308-20261010    gcc-11.5.0 sparse
csky                 randconfig-r2308-20261010    gcc-14     sparse
hexagon                           allmodconfig    gcc-16.1.0
hexagon                            allnoconfig    gcc-16.1.0
hexagon                              defconfig    gcc-16.1.0
hexagon               randconfig-1000-20261012    clang-17
hexagon               randconfig-1001-20261012    clang-17
hexagon               randconfig-2000-20261010    clang-24
hexagon               randconfig-2000-20261010    gcc-16.1.0
hexagon               randconfig-2001-20261010    clang-24
hexagon               randconfig-2001-20261010    gcc-16.1.0
hexagon              randconfig-r2110-20261010    clang-20   cocci
hexagon              randconfig-r2306-20261010    gcc-11.5.0 sparse
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-16.1.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20261012    clang-22
i386        buildonly-randconfig-1001-20261012    clang-22
i386        buildonly-randconfig-1002-20261012    clang-22
i386        buildonly-randconfig-1003-20261012    clang-22
i386        buildonly-randconfig-1004-20261012    clang-22
i386        buildonly-randconfig-1005-20261012    clang-22
i386                                 defconfig    gcc-16.1.0
i386                  randconfig-1000-20261012    gcc-14
i386                  randconfig-1001-20261012    gcc-14
i386                  randconfig-1002-20261012    gcc-14
i386                  randconfig-1003-20261012    gcc-14
i386                  randconfig-1004-20261012    gcc-14
i386                  randconfig-1005-20261012    gcc-14
i386                  randconfig-1006-20261012    gcc-14
i386                  randconfig-1007-20261012    clang-22
i386                  randconfig-1008-20261012    clang-22
i386                  randconfig-1009-20261012    clang-22
i386                  randconfig-1010-20261012    clang-22
i386                  randconfig-1011-20261012    clang-22
i386                  randconfig-1012-20261012    clang-22
i386                  randconfig-1013-20261012    clang-22
i386                  randconfig-2000-20261010    gcc-14
i386                  randconfig-2000-20261010    gcc-8.5.0
i386                  randconfig-2001-20261010    clang-22
i386                  randconfig-2001-20261010    gcc-8.5.0
i386                  randconfig-2100-20261010    gcc-13     cocci
i386                  randconfig-2101-20261010    gcc-13     cocci
i386                  randconfig-2102-20261010    gcc-13     cocci
i386                  randconfig-2103-20261010    gcc-13     cocci
i386                  randconfig-2104-20261010    gcc-13     cocci
i386                  randconfig-2105-20261010    gcc-13     cocci
i386                  randconfig-2200-20261010    gcc-12     smatch
i386                  randconfig-2300-20261010    gcc-14     sparse
i386                  randconfig-2301-20261010    gcc-14     sparse
i386                  randconfig-2302-20261010    clang-22   sparse
i386                  randconfig-2302-20261010    gcc-14     sparse
i386                 randconfig-r2106-20261010    gcc-16.1.0 cocci
i386                 randconfig-r2304-20261010    gcc-15.2.0 sparse
i386                 randconfig-r2307-20261010    clang-24   sparse
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.1.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261012    clang-17
loongarch             randconfig-1001-20261012    clang-17
loongarch             randconfig-2000-20261010    gcc-16.1.0
loongarch             randconfig-2000-20261010    gcc-8.5.0
loongarch             randconfig-2001-20261010    clang-24
loongarch             randconfig-2001-20261010    gcc-8.5.0
loongarch            randconfig-r2305-20261010    gcc-16.1.0 sparse
loongarch            randconfig-r2311-20261010    clang-24   sparse
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    clang-24
m68k                                 defconfig    clang-24
m68k                        m5249evb_defconfig    clang-24
m68k                        m5275evb_defconfig    clang-24
m68k                 randconfig-r2102-20261010    gcc-12.5.0 cocci
m68k                 randconfig-r2201-20261010    gcc-8.5.0  smatch
m68k                 randconfig-r2303-20261010    gcc-8.5.0  sparse
m68k                 randconfig-r2304-20261010    gcc-8.5.0  sparse
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    clang-24
microblaze           randconfig-r2104-20261010    clang-20   cocci
microblaze           randconfig-r2200-20261010    gcc-13.4.0 smatch
microblaze           randconfig-r2309-20261010    gcc-14     sparse
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                            ip30_defconfig    clang-24
mips                 randconfig-r2104-20261010    gcc-16.1.0 cocci
mips                 randconfig-r2300-20261010    clang-17   sparse
mips                 randconfig-r2302-20261010    gcc-13.4.0 sparse
mips                           rb532_defconfig    clang-24
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261012    clang-17
nios2                 randconfig-1001-20261012    clang-17
nios2                 randconfig-2000-20261010    gcc-11.5.0
nios2                 randconfig-2000-20261010    gcc-8.5.0
nios2                 randconfig-2001-20261010    gcc-8.5.0
nios2                randconfig-r2301-20261010    gcc-8.5.0  sparse
nios2                randconfig-r2307-20261010    gcc-11.5.0 sparse
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc                             defconfig    gcc-16.1.0
openrisc             randconfig-r2107-20261010    gcc-13.4.0 cocci
openrisc             randconfig-r2111-20261010    gcc-16.1.0 cocci
openrisc             randconfig-r2201-20261010    gcc-16.1.0 smatch
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20261012    gcc-8.5.0
parisc                randconfig-1001-20261012    gcc-8.5.0
parisc                randconfig-2000-20261010    gcc-10.5.0
parisc                randconfig-2000-20261010    gcc-8.5.0
parisc                randconfig-2001-20261010    gcc-16.1.0
parisc                randconfig-2001-20261010    gcc-8.5.0
parisc               randconfig-r2101-20261010    gcc-8.5.0  cocci
parisc               randconfig-r2301-20261010    gcc-8.5.0  sparse
parisc               randconfig-r2310-20261010    gcc-11.5.0 sparse
parisc64                             defconfig    clang-24
powerpc                            allnoconfig    clang-24
powerpc                     amigaone_defconfig    gcc-16.1.0
powerpc                    bluestone_defconfig    clang-24
powerpc                       ep88xc_defconfig    clang-24
powerpc                       ep88xc_defconfig    gcc-16.1.0
powerpc               randconfig-1000-20261012    gcc-8.5.0
powerpc               randconfig-1001-20261012    gcc-8.5.0
powerpc               randconfig-2000-20261010    clang-17
powerpc               randconfig-2000-20261010    gcc-14
powerpc               randconfig-2001-20261010    clang-24
powerpc               randconfig-2001-20261010    gcc-14
powerpc              randconfig-r2100-20261010    gcc-8.5.0  cocci
powerpc              randconfig-r2104-20261010    clang-24   cocci
powerpc              randconfig-r2107-20261010    clang-20   cocci
powerpc              randconfig-r2300-20261010    gcc-8.5.0  sparse
powerpc              randconfig-r2303-20261010    clang-17   sparse
powerpc              randconfig-r2304-20261010    gcc-13.4.0 sparse
powerpc              randconfig-r2305-20261010    gcc-13.4.0 sparse
powerpc                       tqm8xx_defconfig    clang-24
powerpc64             randconfig-1000-20261012    gcc-8.5.0
powerpc64             randconfig-1001-20261012    gcc-8.5.0
powerpc64             randconfig-2000-20261010    clang-24
powerpc64             randconfig-2000-20261010    gcc-14
powerpc64             randconfig-2001-20261010    gcc-13.4.0
powerpc64             randconfig-2001-20261010    gcc-14
powerpc64            randconfig-r2102-20261010    gcc-8.5.0  cocci
powerpc64            randconfig-r2306-20261010    clang-24   sparse
powerpc64            randconfig-r2311-20261010    gcc-11.5.0 sparse
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.1.0
riscv                 randconfig-1000-20261012    clang-24
riscv                 randconfig-1000-20261013    gcc-9.5.0
riscv                 randconfig-1001-20261012    clang-24
riscv                 randconfig-1001-20261013    gcc-9.5.0
riscv                 randconfig-2000-20261010    gcc-16.1.0
riscv                 randconfig-2000-20261010    gcc-9.5.0
riscv                 randconfig-2001-20261010    clang-24
riscv                 randconfig-2001-20261010    gcc-16.1.0
riscv                randconfig-r2201-20261010    clang-21   smatch
riscv                randconfig-r2202-20261010    clang-24   smatch
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                                 defconfig    gcc-16.1.0
s390                  randconfig-1000-20261012    clang-24
s390                  randconfig-1000-20261013    gcc-9.5.0
s390                  randconfig-1001-20261012    clang-24
s390                  randconfig-1001-20261013    gcc-9.5.0
s390                  randconfig-2000-20261010    clang-17
s390                  randconfig-2000-20261010    gcc-16.1.0
s390                  randconfig-2001-20261010    gcc-15.2.0
s390                  randconfig-2001-20261010    gcc-16.1.0
s390                 randconfig-r2106-20261010    clang-20   cocci
s390                 randconfig-r2106-20261010    gcc-8.5.0  cocci
s390                 randconfig-r2300-20261010    gcc-15.2.0 sparse
s390                 randconfig-r2301-20261010    gcc-13.4.0 sparse
s390                 randconfig-r2304-20261010    clang-17   sparse
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                                   defconfig    gcc-14
sh                    randconfig-1000-20261012    clang-24
sh                    randconfig-1000-20261013    gcc-9.5.0
sh                    randconfig-1001-20261012    clang-24
sh                    randconfig-1001-20261013    gcc-9.5.0
sh                    randconfig-2000-20261010    gcc-16.1.0
sh                    randconfig-2001-20261010    gcc-16.1.0
sh                   randconfig-r2107-20261010    gcc-16.1.0 cocci
sh                   randconfig-r2201-20261010    gcc-15.2.0 smatch
sh                           rsk7201_defconfig    gcc-16.1.0
sh                           sdk7780_defconfig    gcc-16.1.0
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20261012    clang-20
sparc                 randconfig-1001-20261012    clang-20
sparc                 randconfig-2000-20261010    gcc-16.1.0
sparc                 randconfig-2000-20261010    gcc-8.5.0
sparc                 randconfig-2001-20261010    gcc-16.1.0
sparc                randconfig-r2105-20261010    gcc-16.1.0 cocci
sparc                randconfig-r2309-20261010    gcc-11.5.0 sparse
sparc                randconfig-r2310-20261010    gcc-14     sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261012    clang-20
sparc64               randconfig-1001-20261012    clang-20
sparc64               randconfig-2000-20261010    gcc-16.1.0
sparc64               randconfig-2000-20261010    gcc-8.5.0
sparc64               randconfig-2001-20261010    clang-21
sparc64               randconfig-2001-20261010    gcc-16.1.0
sparc64              randconfig-r2100-20261010    gcc-13.4.0 cocci
sparc64              randconfig-r2110-20261010    gcc-16.1.0 cocci
sparc64              randconfig-r2311-20261010    gcc-14     sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.1.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261012    clang-20
um                    randconfig-1001-20261012    clang-20
um                    randconfig-2000-20261010    clang-24
um                    randconfig-2000-20261010    gcc-16.1.0
um                    randconfig-2001-20261010    clang-24
um                    randconfig-2001-20261010    gcc-16.1.0
um                   randconfig-r2300-20261010    gcc-13.4.0 sparse
um                   randconfig-r2302-20261010    gcc-14     sparse
um                   randconfig-r2302-20261010    gcc-15.2.0 sparse
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20261012    clang-22
x86_64      buildonly-randconfig-1001-20261012    clang-22
x86_64      buildonly-randconfig-1002-20261012    clang-22
x86_64      buildonly-randconfig-1003-20261012    clang-22
x86_64      buildonly-randconfig-1004-20261012    clang-22
x86_64      buildonly-randconfig-1005-20261012    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261012    clang-22
x86_64                randconfig-1001-20261012    clang-22
x86_64                randconfig-1002-20261012    clang-22
x86_64                randconfig-1003-20261012    clang-22
x86_64                randconfig-1004-20261012    clang-22
x86_64                randconfig-1005-20261012    clang-22
x86_64                randconfig-1006-20261012    clang-22
x86_64                randconfig-1007-20261012    clang-22
x86_64                randconfig-1008-20261012    clang-22
x86_64                randconfig-1009-20261012    clang-22
x86_64                randconfig-1010-20261012    clang-22
x86_64                randconfig-1011-20261012    clang-22
x86_64                randconfig-1012-20261012    gcc-14
x86_64                randconfig-1013-20261012    gcc-14
x86_64                randconfig-1014-20261012    gcc-14
x86_64                randconfig-1015-20261012    gcc-14
x86_64                randconfig-1016-20261012    gcc-14
x86_64                randconfig-1017-20261012    gcc-14
x86_64                randconfig-2000-20261010    clang-22
x86_64                randconfig-2000-20261010    gcc-14
x86_64                randconfig-2001-20261010    gcc-14
x86_64                randconfig-2100-20261010    clang-22   cocci
x86_64                randconfig-2101-20261010    clang-22   cocci
x86_64                randconfig-2102-20261010    clang-22   cocci
x86_64                randconfig-2103-20261010    clang-22   cocci
x86_64                randconfig-2104-20261010    clang-22   cocci
x86_64                randconfig-2105-20261010    clang-22   cocci
x86_64                randconfig-2200-20261010    gcc-14     smatch
x86_64                randconfig-2300-20261010    clang-22   sparse
x86_64                randconfig-2300-20261010    gcc-14     sparse
x86_64                randconfig-2301-20261010    clang-22   sparse
x86_64                randconfig-2301-20261010    gcc-14     sparse
x86_64                randconfig-2302-20261010    clang-22   sparse
x86_64                randconfig-2302-20261010    gcc-14     sparse
x86_64               randconfig-r2103-20261010    clang-22   cocci
x86_64               randconfig-r2303-20261010    gcc-15.2.0 sparse
x86_64               randconfig-r2307-20261010    gcc-14     sparse
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
xtensa                randconfig-1000-20261012    clang-20
xtensa                randconfig-1001-20261012    clang-20
xtensa                randconfig-2000-20261010    gcc-10.5.0
xtensa                randconfig-2000-20261010    gcc-16.1.0
xtensa                randconfig-2001-20261010    gcc-16.1.0
xtensa               randconfig-r2202-20261010    gcc-8.5.0  smatch
xtensa               randconfig-r2302-20261010    gcc-8.5.0  sparse
xtensa               randconfig-r2305-20261010    gcc-8.5.0  sparse
xtensa                     xip_kc705_defconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
