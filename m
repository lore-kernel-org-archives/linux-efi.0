Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D4B2DC798
	for <linux-efi@vger.kernel.org>; Sun,  2 Aug 2026 03:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785641866; cv=none; b=Zs5+Z+7sPB/dIChSBlSWUz5CnFjCOxIDX9oUtAkX4NzyBWsFHFuI+gLzRkrfpQnSsMPkHJmAHp6BgldBcT9yPo3ElzVfJ49mGyv10ZmVCRhEgT2lYMi3/SnG9B6unzUzrw78OMa/z78or3wbJvvVB1b3wNOP1FhYznOdG2MKEew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785641866; c=relaxed/simple;
	bh=Cf1KNB++DfL0jcisNnaxKsGoRicJlMpb8cl86N3PXXY=;
	h=Date:From:To:Cc:Subject:Message-ID; b=kW3Nl/QJIgDZrcrgNE7Y/7LMBQ63T/OapeXsn4gayeOSbb61quT4lfKxqBW6Y01KllK5f/URhmOv13qi7FFPhc2GZ6W0OMh7MmyQPiBRpzwJIlbNPVb8KCFUf+oYz2gLkzzknzVz1JFzzmFsKm6531ytJvOSGbpq4RTHAOiI9bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mcx0xaOk; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mcx0xaOk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785641865; x=1817177865;
  h=date:from:to:cc:subject:message-id;
  bh=Cf1KNB++DfL0jcisNnaxKsGoRicJlMpb8cl86N3PXXY=;
  b=mcx0xaOkL8u9tFQc44WO0xSAWpugEkMTUhAANCRTH610H3o/LsaY6GgU
   XgIX7h17kOwMiJPO9QAVj2rgOi6cExypWZtgaSp+hejxm9B+Vn1flXaqK
   ppvebiZ40EACiaNZil5E27csKjNG+ZwxMCuj0IUZkl04tYeZB12ZBwPao
   h4KWhrkEKl/vIrpAKHv5KuRw0yYGVAJkQTAvr7XH7lg2vRrWJb1msKYlw
   zjPWflzCvhPSR/kLmWu+41rGI7VK03TrShLPkGnRp496rXc1v6o9WelLR
   djA8qI0/qEpx/yjFuqVSrWDOhfpV0vAO6ly/MSLgTlkrk9wBsw90vyhyt
   w==;
X-CSE-ConnectionGUID: dwxITkfzQhGCtDAYVhJhdg==
X-CSE-MsgGUID: cCqyughDTKK5odFOrkpwDw==
X-IronPort-AV: E=McAfee;i="6800,10657,11862"; a="73755974"
X-IronPort-AV: E=Sophos;i="6.25,199,1779174000"; 
   d="scan'208";a="73755974"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2026 20:37:43 -0700
X-CSE-ConnectionGUID: KS+f01iURjiTDi9SSF5LWw==
X-CSE-MsgGUID: tWB90GTRQqm9/Y0X7M5eQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,199,1779174000"; 
   d="scan'208";a="290848273"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 01 Aug 2026 20:37:43 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wqN1A-000000004MT-0FdF;
	Sun, 02 Aug 2026 03:37:40 +0000
Date: Sun, 02 Aug 2026 11:37:26 +0800
From: kernel test robot <lkp@intel.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org
Subject: [efi:next] BUILD SUCCESS
 44e4ec1a802d2078743f7a77f46af3e2213a3b4e
Message-ID: <202608021115.UqNjPWIL-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git next
branch HEAD: 44e4ec1a802d2078743f7a77f46af3e2213a3b4e  efi: apple-properties: validate setup data header length

elapsed time: 788m

configs tested: 100
configs skipped: 1

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                  randconfig-001-20260802    gcc-15.2.0
arc                  randconfig-002-20260802    gcc-15.2.0
arm                         pxa910_defconfig    gcc-16.1.0
arm                  randconfig-001-20260802    gcc-15.2.0
arm                  randconfig-002-20260802    gcc-15.2.0
arm                  randconfig-003-20260802    gcc-15.2.0
arm                  randconfig-004-20260802    gcc-15.2.0
arm64                randconfig-001-20260802    gcc-9.5.0
arm64                randconfig-002-20260802    gcc-9.5.0
arm64                randconfig-003-20260802    gcc-9.5.0
arm64                randconfig-004-20260802    gcc-9.5.0
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260802    gcc-9.5.0
csky                 randconfig-002-20260802    gcc-9.5.0
hexagon              randconfig-001-20260802    clang-24
hexagon              randconfig-002-20260802    clang-24
i386                            allmodconfig    gcc-14
i386       buildonly-randconfig-001-20260802    gcc-14
i386       buildonly-randconfig-002-20260802    gcc-14
i386       buildonly-randconfig-003-20260802    gcc-14
i386       buildonly-randconfig-004-20260802    gcc-14
i386       buildonly-randconfig-005-20260802    gcc-14
i386       buildonly-randconfig-006-20260802    gcc-14
i386                 randconfig-001-20260802    gcc-14
i386                 randconfig-002-20260802    gcc-14
i386                 randconfig-003-20260802    gcc-14
i386                 randconfig-004-20260802    gcc-14
i386                 randconfig-005-20260802    gcc-14
i386                 randconfig-006-20260802    gcc-14
i386                 randconfig-007-20260802    gcc-14
i386                 randconfig-011-20260802    gcc-14
i386                 randconfig-012-20260802    gcc-14
i386                 randconfig-013-20260802    gcc-14
i386                 randconfig-014-20260802    gcc-14
i386                 randconfig-015-20260802    gcc-14
i386                 randconfig-016-20260802    gcc-14
i386                 randconfig-017-20260802    gcc-14
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260802    clang-24
loongarch            randconfig-002-20260802    clang-24
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260802    clang-24
nios2                randconfig-002-20260802    clang-24
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc               randconfig-001-20260802    gcc-14.3.0
parisc               randconfig-002-20260802    gcc-14.3.0
powerpc                  bluestone_defconfig    clang-24
powerpc              randconfig-001-20260802    gcc-14.3.0
powerpc              randconfig-002-20260802    gcc-14.3.0
powerpc64            randconfig-001-20260802    gcc-14.3.0
powerpc64            randconfig-002-20260802    gcc-14.3.0
riscv                randconfig-001-20260802    gcc-13.4.0
riscv                randconfig-002-20260802    gcc-13.4.0
s390                 randconfig-001-20260802    gcc-13.4.0
s390                 randconfig-002-20260802    gcc-13.4.0
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260802    gcc-13.4.0
sh                   randconfig-002-20260802    gcc-13.4.0
sparc                randconfig-001-20260802    gcc-12.5.0
sparc                randconfig-002-20260802    gcc-12.5.0
sparc64              randconfig-001-20260802    gcc-12.5.0
sparc64              randconfig-002-20260802    gcc-12.5.0
um                   randconfig-001-20260802    gcc-12.5.0
um                   randconfig-002-20260802    gcc-12.5.0
x86_64     buildonly-randconfig-001-20260802    gcc-12
x86_64     buildonly-randconfig-002-20260802    gcc-12
x86_64     buildonly-randconfig-003-20260802    gcc-12
x86_64     buildonly-randconfig-004-20260802    gcc-12
x86_64     buildonly-randconfig-005-20260802    gcc-12
x86_64     buildonly-randconfig-006-20260802    gcc-12
x86_64                                 kexec    clang-22
x86_64               randconfig-001-20260802    clang-22
x86_64               randconfig-002-20260802    clang-22
x86_64               randconfig-003-20260802    clang-22
x86_64               randconfig-004-20260802    clang-22
x86_64               randconfig-005-20260802    clang-22
x86_64               randconfig-006-20260802    clang-22
x86_64               randconfig-011-20260802    clang-22
x86_64               randconfig-012-20260802    clang-22
x86_64               randconfig-013-20260802    clang-22
x86_64               randconfig-014-20260802    clang-22
x86_64               randconfig-015-20260802    clang-22
x86_64               randconfig-016-20260802    clang-22
x86_64               randconfig-071-20260802    gcc-12
x86_64               randconfig-072-20260802    gcc-12
x86_64               randconfig-073-20260802    gcc-12
x86_64               randconfig-074-20260802    gcc-12
x86_64               randconfig-075-20260802    gcc-12
x86_64               randconfig-076-20260802    gcc-12
x86_64                          rhel-9.4-bpf    gcc-14
xtensa               randconfig-001-20260802    gcc-12.5.0
xtensa               randconfig-002-20260802    gcc-12.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
