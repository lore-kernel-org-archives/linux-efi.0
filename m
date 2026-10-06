Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD05846A
	for <linux-efi@vger.kernel.org>; Tue,  6 Oct 2026 05:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791265078; cv=none; b=Ks05zlV2n7iDccU1DMJD579NjQZMvdi014+A80Ot7edwu4+7CLNou1JDkLzrAhKHNz5tyu2IsQr357AXD54wL6Xb9Te6d4refhEXTUQBiWixWmdIkmL2SB68B47wIwrKEOhNt6+gjhUJWoDHbCni8X4IBbTN9WTfUJlisqhBiG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791265078; c=relaxed/simple;
	bh=ylFvHyf8eoItpQCo3QPue04zs8DI/Za6swFEJWw6Xqk=;
	h=Date:From:To:Cc:Subject:Message-ID; b=PJHw2htyf5Po0XhGCQgvIC032r7RspHJKWSRfxPn2jROo3AFWdMJI6M+IyQx0w1tCUnH3uHs1BL7F1QUelWqMp0ciW1HyybxZLAoasFx1a2gNIvbme9WZZxbnw83Rlbp58JwRYt5ASOfNap3Agp/i7gOX+KzegrH5G88wOywznI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EoKiSBUb; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EoKiSBUb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791265076; x=1822801076;
  h=date:from:to:cc:subject:message-id;
  bh=ylFvHyf8eoItpQCo3QPue04zs8DI/Za6swFEJWw6Xqk=;
  b=EoKiSBUbhVCOW80I2/LjHdXK8U7na+mrtJo0J/bZMlvzPCE/GXjhWRhn
   aWNDCIQUpi1g3b8meI1QukQLqpLsTD9IEZgeBNhsM6h8FQ+dvx9T5k1qI
   K4xSNnwK62FavJc928TBuq0aa6JUmjpCUMToEbeHtfRUrAhFoie63ifjX
   vBkRcknylDY/PLAlzwj0W3PCTzVsCIvN0Sk8GbJzaNQ40Ja6/z2wg1F3E
   0Q3s8f7Czl2VE57Bi1BAa8UE0NJvlF2d0G+ZNdIQf33O7FlAvsH1NK4fK
   dvTA7yTwJa/oJ0VcWyE16JeaRtwQ//aCRa8zorwmiSWWfwr0hqF3bcujY
   g==;
X-CSE-ConnectionGUID: NsExgzweRpiYxzjuKOCZSA==
X-CSE-MsgGUID: KaiKhi1ARBy04xXVOaI+5w==
X-IronPort-AV: E=McAfee;i="6800,10657,11926"; a="117462976"
X-IronPort-AV: E=Sophos;i="6.27,143,1787036400"; 
   d="scan'208";a="117462976"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2026 22:37:55 -0700
X-CSE-ConnectionGUID: TTkjVRw0SJG9syz6bm811Q==
X-CSE-MsgGUID: 0nzQTFBwSM2lzVj8vnXgsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,143,1787036400"; 
   d="scan'208";a="1087198"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa013.fm.intel.com with ESMTP; 05 Oct 2026 22:37:54 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xDxs6-000000001Cm-3RzK;
	Tue, 06 Oct 2026 05:37:50 +0000
Date: Tue, 06 Oct 2026 13:36:52 +0800
From: kernel test robot <lkp@intel.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org
Subject: [efi:bootloader-info] BUILD SUCCESS
 0f7d63d9a725e60d509d8dc363a8fd5cbeae51b6
Message-ID: <202610061348.yzQXy3ox-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git bootloader-info
branch HEAD: 0f7d63d9a725e60d509d8dc363a8fd5cbeae51b6  efi/libstub: add initial Boot Loader Interface support

elapsed time: 1294m

configs tested: 411
configs skipped: 7

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    clang-24
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r2101-20261006    gcc-9.5.0  cocci
alpha                randconfig-r2106-20261005    gcc-15.2.0 cocci
arc                               allmodconfig    clang-24
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    clang-24
arc                       axs103_smp_defconfig    gcc-16.1.0
arc                                  defconfig    gcc-16.1.0
arc                      haps_hs_smp_defconfig    clang-24
arc                      haps_hs_smp_defconfig    gcc-16.1.0
arc                   randconfig-1000-20261005    gcc-8.5.0
arc                   randconfig-1000-20261006    clang-24
arc                   randconfig-1001-20261005    gcc-8.5.0
arc                   randconfig-1001-20261006    clang-24
arc                  randconfig-r2102-20261006    gcc-9.5.0  cocci
arc                  randconfig-r2300-20261005    gcc-11.5.0 sparse
arm                                allnoconfig    gcc-16.1.0
arm                               allyesconfig    clang-24
arm                                  defconfig    gcc-16.1.0
arm                        multi_v4t_defconfig    gcc-16.1.0
arm                         multi_v7_defconfig    gcc-16.1.0
arm                         mvebu_v7_defconfig    clang-24
arm                              mxs_defconfig    gcc-16.1.0
arm                           pxa3xx_defconfig    clang-24
arm                   randconfig-1000-20261005    gcc-8.5.0
arm                   randconfig-1000-20261006    clang-24
arm                   randconfig-1001-20261005    gcc-8.5.0
arm                   randconfig-1001-20261006    clang-24
arm                   randconfig-1002-20261005    gcc-8.5.0
arm                   randconfig-1002-20261006    clang-24
arm                   randconfig-1003-20261005    gcc-8.5.0
arm                   randconfig-1003-20261006    clang-24
arm                  randconfig-r2104-20261005    gcc-11.5.0 cocci
arm                  randconfig-r2201-20261005    clang-24   smatch
arm                  randconfig-r2304-20261005    clang-21   sparse
arm                          s5pv210_defconfig    gcc-16.1.0
arm                         shmobile_defconfig    gcc-16.1.0
arm                          socfpga_defconfig    gcc-16.1.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20261005    gcc-16.1.0
arm64                 randconfig-1000-20261006    gcc-16.1.0
arm64                 randconfig-1001-20261005    gcc-16.1.0
arm64                 randconfig-1001-20261006    gcc-16.1.0
arm64                 randconfig-1002-20261005    gcc-16.1.0
arm64                 randconfig-1002-20261006    gcc-16.1.0
arm64                 randconfig-1003-20261005    gcc-16.1.0
arm64                 randconfig-1003-20261006    gcc-16.1.0
arm64                randconfig-r2103-20261006    gcc-9.5.0  cocci
arm64                randconfig-r2202-20261005    clang-24   smatch
arm64                randconfig-r2306-20261005    gcc-8.5.0  sparse
arm64                randconfig-r2308-20261005    clang-24   sparse
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20261005    gcc-16.1.0
csky                  randconfig-1000-20261006    gcc-16.1.0
csky                  randconfig-1001-20261005    gcc-16.1.0
csky                  randconfig-1001-20261006    gcc-16.1.0
csky                 randconfig-r2102-20261005    gcc-16.1.0 cocci
csky                 randconfig-r2201-20261005    gcc-10.5.0 smatch
csky                 randconfig-r2303-20261005    gcc-13.4.0 sparse
hexagon                           allmodconfig    gcc-16.1.0
hexagon                            allnoconfig    gcc-16.1.0
hexagon                              defconfig    gcc-16.1.0
hexagon               randconfig-1000-20261005    gcc-16.1.0
hexagon               randconfig-1000-20261006    gcc-13.4.0
hexagon               randconfig-1001-20261005    gcc-16.1.0
hexagon               randconfig-1001-20261006    gcc-13.4.0
hexagon              randconfig-r2100-20261005    gcc-16.1.0 cocci
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-16.1.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20261005    clang-22
i386        buildonly-randconfig-1000-20261006    gcc-14
i386        buildonly-randconfig-1001-20261005    clang-22
i386        buildonly-randconfig-1001-20261006    gcc-14
i386        buildonly-randconfig-1002-20261005    clang-22
i386        buildonly-randconfig-1002-20261006    gcc-14
i386        buildonly-randconfig-1003-20261005    clang-22
i386        buildonly-randconfig-1003-20261006    gcc-14
i386        buildonly-randconfig-1004-20261005    clang-22
i386        buildonly-randconfig-1004-20261006    gcc-14
i386        buildonly-randconfig-1005-20261005    clang-22
i386        buildonly-randconfig-1005-20261006    gcc-14
i386                                 defconfig    gcc-16.1.0
i386                  randconfig-1000-20261005    clang-22
i386                  randconfig-1000-20261006    gcc-14
i386                  randconfig-1001-20261005    clang-22
i386                  randconfig-1001-20261006    gcc-14
i386                  randconfig-1002-20261005    clang-22
i386                  randconfig-1002-20261006    gcc-14
i386                  randconfig-1003-20261005    clang-22
i386                  randconfig-1003-20261006    gcc-14
i386                  randconfig-1004-20261005    clang-22
i386                  randconfig-1004-20261006    gcc-14
i386                  randconfig-1005-20261005    clang-22
i386                  randconfig-1005-20261006    gcc-14
i386                  randconfig-1006-20261005    clang-22
i386                  randconfig-1006-20261006    gcc-14
i386                  randconfig-1007-20261006    gcc-14
i386                  randconfig-1008-20261006    gcc-14
i386                  randconfig-1009-20261006    gcc-14
i386                  randconfig-1010-20261006    gcc-14
i386                  randconfig-1011-20261006    gcc-14
i386                  randconfig-1012-20261006    gcc-14
i386                  randconfig-1013-20261006    gcc-14
i386                  randconfig-2100-20261004    clang-22   cocci
i386                  randconfig-2100-20261005    gcc-14     cocci
i386                  randconfig-2101-20261004    gcc-14     cocci
i386                  randconfig-2101-20261005    gcc-14     cocci
i386                  randconfig-2102-20261004    gcc-14     cocci
i386                  randconfig-2102-20261005    gcc-14     cocci
i386                  randconfig-2103-20261004    gcc-14     cocci
i386                  randconfig-2103-20261005    gcc-14     cocci
i386                  randconfig-2200-20261005    gcc-14     smatch
i386                  randconfig-2200-20261006    gcc-13     smatch
i386                  randconfig-2300-20261004    clang-22   sparse
i386                  randconfig-2300-20261005    clang-22   sparse
i386                  randconfig-2301-20261004    gcc-14     sparse
i386                  randconfig-2301-20261005    clang-22   sparse
i386                  randconfig-2302-20261004    gcc-14     sparse
i386                  randconfig-2302-20261005    clang-22   sparse
i386                 randconfig-r2103-20261004    clang-22   cocci
i386                 randconfig-r2103-20261005    gcc-15.2.0 cocci
i386                 randconfig-r2107-20261005    gcc-15.2.0 cocci
i386                 randconfig-r2107-20261005    gcc-8.5.0  cocci
i386                 randconfig-r2107-20261006    gcc-8.5.0  cocci
i386                 randconfig-r2200-20261005    clang-22   smatch
i386                 randconfig-r2305-20261005    clang-22   sparse
i386                 randconfig-r2308-20261005    gcc-9.5.0  sparse
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.1.0
loongarch                            defconfig    clang-24
loongarch                 loongson32_defconfig    gcc-16.1.0
loongarch             randconfig-1000-20261005    gcc-16.1.0
loongarch             randconfig-1000-20261006    gcc-13.4.0
loongarch             randconfig-1001-20261005    gcc-16.1.0
loongarch             randconfig-1001-20261006    gcc-13.4.0
loongarch            randconfig-r2100-20261004    gcc-12.5.0 cocci
loongarch            randconfig-r2106-20261005    clang-18   cocci
loongarch            randconfig-r2106-20261005    gcc-16.1.0 cocci
loongarch            randconfig-r2302-20261005    clang-21   sparse
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    clang-24
m68k                           amiga_defconfig    clang-24
m68k                        bvme6000_defconfig    gcc-16.1.0
m68k                                 defconfig    clang-24
m68k                         m5407c3_defconfig    gcc-16.1.0
m68k                          nettel_defconfig    gcc-16.1.0
m68k                 randconfig-r2105-20261005    gcc-8.5.0  cocci
m68k                 randconfig-r2106-20261005    gcc-8.5.0  cocci
m68k                 randconfig-r2301-20261005    gcc-11.5.0 sparse
m68k                 randconfig-r2303-20261005    clang-21   sparse
m68k                 randconfig-r2307-20261005    gcc-8.5.0  sparse
m68k                 randconfig-r2308-20261004    gcc-11.5.0 sparse
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    clang-24
microblaze           randconfig-r2104-20261005    gcc-16.1.0 cocci
microblaze           randconfig-r2105-20261006    gcc-8.5.0  cocci
microblaze           randconfig-r2201-20261006    gcc-16.1.0 smatch
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                       bmips_stb_defconfig    gcc-16.1.0
mips                            ip30_defconfig    gcc-16.1.0
mips                       loongson1_defconfig    gcc-16.1.0
mips                       maltasmvp_defconfig    gcc-16.1.0
mips                 randconfig-r2105-20261005    gcc-16.1.0 cocci
mips                 randconfig-r2107-20261005    clang-17   cocci
mips                 randconfig-r2300-20261005    gcc-13.4.0 sparse
mips                 randconfig-r2303-20261005    gcc-11.5.0 sparse
mips                 randconfig-r2305-20261005    clang-21   sparse
mips                 randconfig-r2306-20261004    clang-17   sparse
mips                 randconfig-r2307-20261005    clang-24   sparse
nios2                             alldefconfig    gcc-16.1.0
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261005    gcc-16.1.0
nios2                 randconfig-1000-20261006    gcc-13.4.0
nios2                 randconfig-1001-20261005    gcc-16.1.0
nios2                 randconfig-1001-20261006    gcc-13.4.0
nios2                randconfig-r2103-20261005    gcc-16.1.0 cocci
nios2                randconfig-r2104-20261005    gcc-8.5.0  cocci
nios2                randconfig-r2104-20261006    gcc-8.5.0  cocci
nios2                randconfig-r2202-20261005    gcc-11.5.0 smatch
nios2                randconfig-r2302-20261005    gcc-11.5.0 sparse
nios2                randconfig-r2303-20261005    clang-24   sparse
openrisc                          allmodconfig    gcc-11.5.0
openrisc                           allnoconfig    clang-24
openrisc          de0_nano_multicore_defconfig    gcc-16.1.0
openrisc                             defconfig    gcc-16.1.0
openrisc             randconfig-r2300-20261005    clang-21   sparse
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20261006    gcc-14.3.0
parisc                randconfig-1001-20261006    gcc-14.3.0
parisc               randconfig-r2106-20261006    gcc-8.5.0  cocci
parisc               randconfig-r2202-20261005    gcc-8.5.0  smatch
parisc64                          alldefconfig    gcc-16.1.0
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    clang-24
powerpc                  canyonlands_defconfig    gcc-16.1.0
powerpc                  mpc836x_rdk_defconfig    clang-24
powerpc               randconfig-1000-20261006    gcc-14.3.0
powerpc               randconfig-1001-20261006    gcc-14.3.0
powerpc              randconfig-r2101-20261005    gcc-16.1.0 cocci
powerpc              randconfig-r2102-20261005    gcc-15.2.0 cocci
powerpc              randconfig-r2105-20261005    gcc-15.2.0 cocci
powerpc              randconfig-r2107-20261005    gcc-16.1.0 cocci
powerpc              randconfig-r2200-20261006    gcc-9.5.0  smatch
powerpc              randconfig-r2202-20261005    clang-24   smatch
powerpc              randconfig-r2300-20261005    clang-24   sparse
powerpc              randconfig-r2301-20261005    clang-24   sparse
powerpc              randconfig-r2302-20261005    gcc-11.5.0 sparse
powerpc              randconfig-r2307-20261005    gcc-9.5.0  sparse
powerpc              randconfig-r2308-20261005    gcc-8.5.0  sparse
powerpc                      taishan_defconfig    gcc-16.1.0
powerpc                      tqm8548_defconfig    gcc-16.1.0
powerpc64             randconfig-1000-20261006    gcc-14.3.0
powerpc64             randconfig-1001-20261006    gcc-14.3.0
powerpc64            randconfig-r2101-20261004    clang-24   cocci
powerpc64            randconfig-r2102-20261004    clang-17   cocci
powerpc64            randconfig-r2105-20261005    gcc-8.5.0  cocci
powerpc64            randconfig-r2200-20261005    gcc-12.5.0 smatch
powerpc64            randconfig-r2304-20261005    gcc-15.2.0 sparse
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.1.0
riscv                     nommu_virt_defconfig    clang-24
riscv                 randconfig-1000-20261006    clang-24
riscv                 randconfig-1001-20261006    clang-24
riscv                 randconfig-2000-20261005    gcc-13.4.0
riscv                 randconfig-2000-20261005    gcc-16.1.0
riscv                 randconfig-2001-20261005    gcc-16.1.0
riscv                 randconfig-2001-20261005    gcc-8.5.0
riscv                randconfig-r2100-20261005    gcc-13.4.0 cocci
riscv                randconfig-r2101-20261005    gcc-13.4.0 cocci
riscv                randconfig-r2102-20261005    gcc-13.4.0 cocci
riscv                randconfig-r2104-20261005    gcc-15.2.0 cocci
riscv                randconfig-r2301-20261005    clang-21   sparse
riscv                randconfig-r2306-20261005    clang-24   sparse
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                           debug_defconfig    gcc-16.1.0
s390                                 defconfig    gcc-16.1.0
s390                  randconfig-1000-20261006    clang-24
s390                  randconfig-1001-20261006    clang-24
s390                  randconfig-2000-20261005    gcc-13.4.0
s390                  randconfig-2000-20261005    gcc-16.1.0
s390                  randconfig-2001-20261005    clang-24
s390                  randconfig-2001-20261005    gcc-16.1.0
s390                 randconfig-r2200-20261005    clang-24   smatch
s390                 randconfig-r2305-20261005    clang-24   sparse
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                                   defconfig    gcc-14
sh                          ecovec24_defconfig    gcc-16.1.0
sh                           r7780mp_defconfig    gcc-16.1.0
sh                    randconfig-1000-20261006    clang-24
sh                    randconfig-1001-20261006    clang-24
sh                    randconfig-2000-20261005    gcc-12.5.0
sh                    randconfig-2000-20261005    gcc-16.1.0
sh                    randconfig-2001-20261005    gcc-16.1.0
sh                   randconfig-r2309-20261005    gcc-8.5.0  sparse
sh                           rsk7264_defconfig    gcc-16.1.0
sh                      sh7710voipgw_defconfig    gcc-16.1.0
sh                             shmin_defconfig    gcc-16.1.0
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20261005    clang-24
sparc                 randconfig-1000-20261006    gcc-14
sparc                 randconfig-1001-20261005    clang-24
sparc                 randconfig-1001-20261006    gcc-14
sparc                 randconfig-2000-20261004    gcc-8.5.0
sparc                 randconfig-2000-20261005    clang-17
sparc                 randconfig-2001-20261004    gcc-15.2.0
sparc                 randconfig-2001-20261005    clang-17
sparc                randconfig-r2100-20261005    gcc-15.2.0 cocci
sparc                randconfig-r2201-20261005    gcc-15.2.0 smatch
sparc                randconfig-r2302-20261005    clang-24   sparse
sparc                randconfig-r2304-20261005    gcc-11.5.0 sparse
sparc                randconfig-r2309-20261005    clang-24   sparse
sparc                randconfig-r2309-20261005    gcc-9.5.0  sparse
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261005    clang-24
sparc64               randconfig-1000-20261006    gcc-14
sparc64               randconfig-1001-20261005    clang-24
sparc64               randconfig-1001-20261006    gcc-14
sparc64               randconfig-2000-20261004    clang-20
sparc64               randconfig-2000-20261005    clang-17
sparc64               randconfig-2001-20261004    gcc-10.5.0
sparc64               randconfig-2001-20261005    clang-17
sparc64              randconfig-r2100-20261006    gcc-9.5.0  cocci
sparc64              randconfig-r2304-20261005    clang-24   sparse
sparc64              randconfig-r2307-20261004    gcc-16.1.0 sparse
um                                alldefconfig    gcc-16.1.0
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.1.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                              i386_defconfig    gcc-16.1.0
um                    randconfig-1000-20261005    clang-24
um                    randconfig-1000-20261006    gcc-14
um                    randconfig-1001-20261005    clang-24
um                    randconfig-1001-20261006    gcc-14
um                    randconfig-2000-20261004    gcc-14
um                    randconfig-2000-20261005    clang-17
um                    randconfig-2001-20261004    clang-17
um                    randconfig-2001-20261005    clang-17
um                   randconfig-r2101-20261005    gcc-15.2.0 cocci
um                   randconfig-r2200-20261005    gcc-13     smatch
um                   randconfig-r2305-20261005    gcc-11.5.0 sparse
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20261005    gcc-13
x86_64      buildonly-randconfig-1000-20261006    gcc-14
x86_64      buildonly-randconfig-1001-20261005    gcc-13
x86_64      buildonly-randconfig-1001-20261006    gcc-14
x86_64      buildonly-randconfig-1002-20261005    gcc-13
x86_64      buildonly-randconfig-1002-20261006    gcc-14
x86_64      buildonly-randconfig-1003-20261005    gcc-13
x86_64      buildonly-randconfig-1003-20261006    gcc-14
x86_64      buildonly-randconfig-1004-20261005    gcc-13
x86_64      buildonly-randconfig-1004-20261006    gcc-14
x86_64      buildonly-randconfig-1005-20261005    gcc-13
x86_64      buildonly-randconfig-1005-20261006    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261005    gcc-14
x86_64                randconfig-1000-20261006    gcc-14
x86_64                randconfig-1001-20261005    gcc-14
x86_64                randconfig-1001-20261006    gcc-14
x86_64                randconfig-1002-20261005    gcc-14
x86_64                randconfig-1002-20261006    gcc-14
x86_64                randconfig-1003-20261005    gcc-14
x86_64                randconfig-1003-20261006    gcc-14
x86_64                randconfig-1004-20261005    gcc-14
x86_64                randconfig-1004-20261006    gcc-14
x86_64                randconfig-1005-20261005    gcc-14
x86_64                randconfig-1005-20261006    gcc-14
x86_64                randconfig-1006-20261006    gcc-14
x86_64                randconfig-1007-20261006    gcc-14
x86_64                randconfig-1008-20261006    gcc-14
x86_64                randconfig-1009-20261006    gcc-14
x86_64                randconfig-1010-20261006    gcc-14
x86_64                randconfig-1011-20261006    gcc-14
x86_64                randconfig-1012-20261006    gcc-14
x86_64                randconfig-1013-20261006    gcc-14
x86_64                randconfig-1014-20261006    gcc-14
x86_64                randconfig-1015-20261006    gcc-14
x86_64                randconfig-1016-20261006    gcc-14
x86_64                randconfig-1017-20261006    gcc-14
x86_64                randconfig-2100-20261004    gcc-14     cocci
x86_64                randconfig-2100-20261005    clang-22   cocci
x86_64                randconfig-2101-20261004    clang-22   cocci
x86_64                randconfig-2101-20261005    clang-22   cocci
x86_64                randconfig-2102-20261004    gcc-14     cocci
x86_64                randconfig-2102-20261005    clang-22   cocci
x86_64                randconfig-2103-20261004    gcc-14     cocci
x86_64                randconfig-2103-20261005    clang-22   cocci
x86_64                randconfig-2200-20261004    gcc-14     smatch
x86_64                randconfig-2200-20261005    clang-22   smatch
x86_64                randconfig-2200-20261006    clang-22   smatch
x86_64                randconfig-2300-20261004    gcc-14     sparse
x86_64                randconfig-2300-20261005    clang-22   sparse
x86_64                randconfig-2301-20261004    gcc-14     sparse
x86_64                randconfig-2301-20261005    clang-22   sparse
x86_64                randconfig-2302-20261004    clang-22   sparse
x86_64                randconfig-2302-20261005    clang-22   sparse
x86_64               randconfig-r2103-20261005    gcc-13.4.0 cocci
x86_64               randconfig-r2301-20261005    gcc-14     sparse
x86_64               randconfig-r2309-20261004    clang-22   sparse
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
xtensa                 generic_kc705_defconfig    gcc-16.1.0
xtensa                randconfig-1000-20261005    clang-24
xtensa                randconfig-1000-20261006    gcc-14
xtensa                randconfig-1001-20261005    clang-24
xtensa                randconfig-1001-20261006    gcc-14
xtensa                randconfig-2000-20261004    gcc-8.5.0
xtensa                randconfig-2000-20261005    clang-17
xtensa                randconfig-2001-20261004    gcc-9.5.0
xtensa                randconfig-2001-20261005    clang-17
xtensa               randconfig-r2306-20261005    gcc-9.5.0  sparse

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
