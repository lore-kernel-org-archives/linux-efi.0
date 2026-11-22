Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.10
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795347567;
	b=Chwyaa9QRvJEnPq3o+q3B493EbPAnnGrEpN56f9x5Gz5fsQD72KXpg7T/I3fmmQv35E6
	 h1/PkNodo7ZzhoLw0kHf20AN2nzGmxNtxWkqAKUoJ9kqmJLA9TOFMH6pYKK2IOm38wnab
	 jYO5pW9KC8kRLzVl0EkTpqzxjpBusXQSKKRs16X+2i2Ipuqmw6vhod32VqJ8eg1jhxmyz
	 Zom+WkGukMLk2LqSELfIFeFK3F3NJKKkskh+bG94ZPMEnRPMDo2d3V+UY4oMurz5Qso9Q
	 dMDYn4TFoheTTGuD+TwoGzSKyeA7YN/bJUWr5gu/noAIIwTu/yntutAjty9CbWArq5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795347567;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=H2Z0QkNRgxYuccnl/7d2s7/l39ZZiPF8k54FN9ZMVH8=;
	b=qQuANxmEBnppoJ+p+93heJXVcNGE5dCTZ+Qs7LFSwUHXxETPP1MSLKl8K2SZIqTohtgg
	 rAlFXcPBAxpU3ekSsiHh4FOOlVzaTPsG9uloNaWKVt7WbVVTXuohabAKDEMGvUwyJ9l33
	 QIKznqUTZtrkjmFfZIF1HemIUFv7+YRH6B8kihp5obWQ5jRvKlrrm12kDRf3jawIwihV0
	 Cr0JgZ+o3ualtt95bqXN1536HBgUcLPIqRFZmN8hkTHTu5hpM3fdOtYZVIGfyCTshmWBe
	 wp5edDfgxrWg9wlomnVIifM/VSG04TCtScQ/QI4qEfj8GA78eSFAnBt3kDIfH6cDgWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=RlrkrXjd;
	arc=none smtp.remote-ip=192.198.163.10
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC7A606A320
	for <linux-efi@vger.kernel.org>; Sun, 22 Nov 2026 11:39:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1DC7A606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=RlrkrXjd
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795347567; x=1826883567;
  h=date:from:to:cc:subject:message-id;
  bh=BN3H6KHeNfY14HDfh5pAmJBho7q52Bgw8WtRYhKYn5Q=;
  b=RlrkrXjdKckgksLjldGemtII4TEuDMtTod+BWgO0mql6uES0Eh37qSkn
   wrliAzyU5xw50MDAH3PHxjznCH4KRvV9xJw5Iwla4W4saaXZfiqqw8+y3
   iyDafEC4wuXFan8RZoO2zyteqvKf/03zQdCH/TJzxKfKjwXeIQOJkqciG
   fSfgOiRG2NRzFyYKE8q9ORnNecHmxfrPwGGXyQHzun9vCBKh4gggf+n9q
   96d0+85eHuDgmaE8fgHKn4Ygmc1wLpMSzA50GxhqeCsWoTlwbM+Jb2Koe
   oTh0qq4iumwKVhPb3yjx5wFVgKIOFi1IHoyh4PvAJ7/KJ1/LzVW1JO2wX
   w==;
X-CSE-ConnectionGUID: I1GZ+7SsQTSaSC2YddKc2g==
X-CSE-MsgGUID: +2X1GroEQtGjrLXPVAj1Cw==
X-IronPort-AV: E=McAfee;i="6800,10657,11973"; a="4048060"
X-IronPort-AV: E=Sophos;i="6.27,226,1787036400"; 
   d="scan'208";a="4048060"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2026 03:39:26 -0800
X-CSE-ConnectionGUID: LQfK38/UThap9Kkhdh1CgQ==
X-CSE-MsgGUID: Li16vOjDRTitiW3EyX7Ftg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,226,1787036400"; 
   d="scan'208";a="13066880"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa013.fm.intel.com with ESMTP; 22 Nov 2026 03:39:25 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xV5uk-00000001LRk-2FDM;
	Sun, 22 Nov 2026 11:39:22 +0000
Date: Sun, 22 Nov 2026 19:38:38 +0800
From: kernel test robot <lkp@intel.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org
Subject: [efi:urgent] BUILD SUCCESS
 7d49d6e0898680925ea410cbb9d1a6a0e6441462
Message-ID: <20261122193838.3LdM7EaO-lkp@intel.com>
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
branch HEAD: 7d49d6e0898680925ea410cbb9d1a6a0e6441462  riscv: efi: Map runtime MMIO with device attributes

elapsed time: 877m

configs tested: 668
configs skipped: 4

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
alpha                 randconfig-2000-20261121    gcc-14.4.0
alpha                 randconfig-2000-20261122    gcc-8.5.0
alpha                 randconfig-2001-20261121    gcc-14.4.0
alpha                 randconfig-2001-20261122    gcc-8.5.0
alpha                 randconfig-2200-20261121    gcc-10.5.0 smatch
alpha                 randconfig-2200-20261122    gcc-8.5.0  smatch
alpha                randconfig-r2100-20261121    gcc-16.2.0 cocci
alpha                randconfig-r2302-20261121    gcc-8.5.0  sparse
alpha                randconfig-r2303-20261121    gcc-8.5.0  sparse
alpha                randconfig-r2304-20261122    clang-24   sparse
alpha                randconfig-r2305-20261122    clang-22   sparse
alpha                randconfig-r2308-20261122    gcc-13.5.0 sparse
alpha                randconfig-r2308-20261122    gcc-14.4.0 sparse
alpha                randconfig-r2309-20261121    gcc-11.5.0 sparse
alpha                randconfig-r2311-20261121    gcc-15.3.0 sparse
arc                               allmodconfig    clang-24
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    clang-24
arc                                  defconfig    gcc-16.2.0
arc                   randconfig-1000-20261122    clang-17
arc                   randconfig-1001-20261122    clang-17
arc                   randconfig-2000-20261121    gcc-8.5.0
arc                   randconfig-2000-20261122    gcc-9.5.0
arc                   randconfig-2001-20261121    gcc-8.5.0
arc                   randconfig-2001-20261122    gcc-9.5.0
arc                   randconfig-2002-20261121    gcc-8.5.0
arc                   randconfig-2002-20261122    gcc-9.5.0
arc                   randconfig-2003-20261121    gcc-8.5.0
arc                   randconfig-2003-20261122    gcc-9.5.0
arc                   randconfig-2004-20261121    gcc-8.5.0
arc                   randconfig-2004-20261122    gcc-9.5.0
arc                   randconfig-2005-20261121    gcc-8.5.0
arc                   randconfig-2005-20261122    gcc-9.5.0
arc                   randconfig-2200-20261121    gcc-14.4.0 smatch
arc                   randconfig-2200-20261122    gcc-9.5.0  smatch
arc                  randconfig-r2100-20261122    gcc-16.2.0 cocci
arc                  randconfig-r2111-20261121    gcc-14.4.0 cocci
arc                  randconfig-r2301-20261122    clang-21   sparse
arc                  randconfig-r2301-20261122    gcc-12.5.0 sparse
arc                  randconfig-r2306-20261121    clang-18   sparse
arm                                allnoconfig    gcc-16.2.0
arm                               allyesconfig    clang-24
arm                                  defconfig    gcc-16.2.0
arm                            h3600_defconfig    clang-17
arm                   randconfig-1000-20261122    clang-17
arm                   randconfig-1001-20261122    clang-17
arm                   randconfig-1002-20261122    clang-17
arm                   randconfig-1003-20261122    clang-17
arm                   randconfig-2000-20261121    clang-24
arm                   randconfig-2000-20261122    gcc-15.3.0
arm                   randconfig-2001-20261121    clang-24
arm                   randconfig-2001-20261122    gcc-15.3.0
arm                   randconfig-2002-20261121    clang-24
arm                   randconfig-2002-20261122    gcc-15.3.0
arm                   randconfig-2200-20261121    clang-19   smatch
arm                   randconfig-2200-20261122    clang-19   smatch
arm                  randconfig-r2104-20261122    gcc-9.5.0  cocci
arm                  randconfig-r2105-20261122    gcc-14     cocci
arm                  randconfig-r2109-20261122    clang-22   cocci
arm                  randconfig-r2109-20261122    gcc-15.3.0 cocci
arm                  randconfig-r2110-20261121    gcc-8.5.0  cocci
arm                  randconfig-r2110-20261122    gcc-16.2.0 cocci
arm                  randconfig-r2300-20261121    clang-24   sparse
arm                  randconfig-r2300-20261121    gcc-8.5.0  sparse
arm                  randconfig-r2301-20261121    gcc-8.5.0  sparse
arm                  randconfig-r2302-20261122    clang-21   sparse
arm                  randconfig-r2304-20261121    gcc-8.5.0  sparse
arm                  randconfig-r2305-20261121    gcc-8.5.0  sparse
arm                  randconfig-r2306-20261121    gcc-10.5.0 sparse
arm                  randconfig-r2308-20261122    gcc-15.3.0 sparse
arm                  randconfig-r2309-20261122    gcc-14     sparse
arm                  randconfig-r2310-20261122    gcc-15.3.0 sparse
arm                         shmobile_defconfig    clang-17
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261122    gcc-8.5.0
arm64                 randconfig-1001-20261122    gcc-8.5.0
arm64                 randconfig-1002-20261122    gcc-8.5.0
arm64                 randconfig-1003-20261122    gcc-8.5.0
arm64                 randconfig-2000-20261121    clang-24
arm64                 randconfig-2000-20261122    gcc-15.3.0
arm64                 randconfig-2001-20261121    clang-24
arm64                 randconfig-2001-20261122    gcc-15.3.0
arm64                 randconfig-2002-20261121    clang-24
arm64                 randconfig-2002-20261122    gcc-15.3.0
arm64                 randconfig-2200-20261121    clang-22   smatch
arm64                 randconfig-2200-20261122    gcc-10.5.0 smatch
arm64                randconfig-r2102-20261121    gcc-8.5.0  cocci
arm64                randconfig-r2106-20261122    gcc-15.3.0 cocci
arm64                randconfig-r2110-20261121    clang-17   cocci
arm64                randconfig-r2301-20261121    clang-24   sparse
arm64                randconfig-r2303-20261122    clang-21   sparse
arm64                randconfig-r2306-20261122    clang-24   sparse
arm64                randconfig-r2306-20261122    gcc-15.3.0 sparse
arm64                randconfig-r2310-20261121    gcc-14     sparse
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261122    gcc-8.5.0
csky                  randconfig-1001-20261122    gcc-8.5.0
csky                  randconfig-2000-20261121    gcc-16.2.0
csky                  randconfig-2000-20261122    gcc-9.5.0
csky                  randconfig-2001-20261121    gcc-16.2.0
csky                  randconfig-2001-20261122    gcc-9.5.0
csky                  randconfig-2200-20261121    gcc-16.2.0 smatch
csky                  randconfig-2200-20261122    gcc-9.5.0  smatch
csky                 randconfig-r2100-20261121    gcc-10.5.0 cocci
csky                 randconfig-r2101-20261122    gcc-14     cocci
csky                 randconfig-r2105-20261121    gcc-16.2.0 cocci
csky                 randconfig-r2105-20261122    gcc-14     cocci
csky                 randconfig-r2304-20261122    clang-24   sparse
csky                 randconfig-r2307-20261121    gcc-11.5.0 sparse
csky                 randconfig-r2308-20261122    gcc-15.3.0 sparse
csky                 randconfig-r2309-20261121    gcc-9.5.0  sparse
csky                 randconfig-r2309-20261122    gcc-13.5.0 sparse
csky                 randconfig-r2311-20261121    clang-18   sparse
hexagon                           allmodconfig    gcc-16.2.0
hexagon                            allnoconfig    gcc-16.2.0
hexagon                              defconfig    gcc-16.2.0
hexagon               randconfig-1000-20261122    gcc-8.5.0
hexagon               randconfig-1001-20261122    gcc-8.5.0
hexagon               randconfig-2000-20261121    clang-24
hexagon               randconfig-2000-20261121    gcc-16.2.0
hexagon               randconfig-2000-20261122    gcc-9.5.0
hexagon               randconfig-2001-20261121    clang-24
hexagon               randconfig-2001-20261121    gcc-16.2.0
hexagon               randconfig-2001-20261122    gcc-9.5.0
hexagon               randconfig-2200-20261121    clang-24   smatch
hexagon               randconfig-2200-20261122    clang-24   smatch
hexagon              randconfig-r2102-20261121    gcc-16.2.0 cocci
hexagon              randconfig-r2102-20261122    gcc-14     cocci
hexagon              randconfig-r2104-20261121    gcc-16.2.0 cocci
hexagon              randconfig-r2104-20261122    gcc-14.4.0 cocci
hexagon              randconfig-r2108-20261121    gcc-14.4.0 cocci
hexagon              randconfig-r2110-20261122    clang-22   cocci
hexagon              randconfig-r2111-20261122    clang-22   cocci
hexagon              randconfig-r2301-20261122    clang-24   sparse
hexagon              randconfig-r2305-20261121    clang-24   sparse
hexagon              randconfig-r2305-20261122    clang-24   sparse
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-16.2.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20261122    gcc-14
i386        buildonly-randconfig-1001-20261122    gcc-14
i386        buildonly-randconfig-1002-20261122    gcc-14
i386        buildonly-randconfig-1003-20261122    gcc-14
i386        buildonly-randconfig-1004-20261122    gcc-14
i386        buildonly-randconfig-1005-20261122    gcc-14
i386                                 defconfig    gcc-16.2.0
i386                  randconfig-1000-20261122    gcc-14
i386                  randconfig-1001-20261122    gcc-14
i386                  randconfig-1002-20261122    gcc-14
i386                  randconfig-1003-20261122    gcc-14
i386                  randconfig-1004-20261122    gcc-14
i386                  randconfig-1005-20261122    gcc-14
i386                  randconfig-1006-20261122    gcc-14
i386                  randconfig-1007-20261122    gcc-14
i386                  randconfig-1008-20261122    gcc-14
i386                  randconfig-1009-20261122    gcc-14
i386                  randconfig-1010-20261122    gcc-14
i386                  randconfig-1011-20261122    gcc-14
i386                  randconfig-1012-20261122    gcc-14
i386                  randconfig-1013-20261122    gcc-14
i386                  randconfig-2000-20261121    gcc-14
i386                  randconfig-2000-20261122    clang-22
i386                  randconfig-2001-20261121    gcc-14
i386                  randconfig-2001-20261122    clang-22
i386                  randconfig-2002-20261121    gcc-14
i386                  randconfig-2002-20261122    clang-22
i386                  randconfig-2003-20261121    clang-22
i386                  randconfig-2003-20261121    gcc-14
i386                  randconfig-2003-20261122    clang-22
i386                  randconfig-2004-20261121    gcc-14
i386                  randconfig-2004-20261122    clang-22
i386                  randconfig-2005-20261121    gcc-14
i386                  randconfig-2005-20261122    clang-22
i386                  randconfig-2100-20261121    clang-22   cocci
i386                  randconfig-2100-20261121    gcc-14     cocci
i386                  randconfig-2100-20261122    clang-22   cocci
i386                  randconfig-2101-20261121    clang-22   cocci
i386                  randconfig-2101-20261122    clang-22   cocci
i386                  randconfig-2102-20261121    clang-22   cocci
i386                  randconfig-2102-20261121    gcc-13     cocci
i386                  randconfig-2102-20261122    clang-22   cocci
i386                  randconfig-2103-20261121    clang-22   cocci
i386                  randconfig-2103-20261122    clang-22   cocci
i386                  randconfig-2104-20261121    clang-22   cocci
i386                  randconfig-2104-20261121    gcc-14     cocci
i386                  randconfig-2104-20261122    clang-22   cocci
i386                  randconfig-2105-20261121    clang-22   cocci
i386                  randconfig-2105-20261121    gcc-14     cocci
i386                  randconfig-2105-20261122    clang-22   cocci
i386                  randconfig-2200-20261121    clang-22   smatch
i386                  randconfig-2200-20261122    gcc-14     smatch
i386                  randconfig-2300-20261121    clang-22   sparse
i386                  randconfig-2300-20261121    gcc-14     sparse
i386                  randconfig-2300-20261122    clang-22   sparse
i386                  randconfig-2301-20261121    gcc-14     sparse
i386                  randconfig-2301-20261122    clang-22   sparse
i386                  randconfig-2302-20261121    gcc-13     sparse
i386                  randconfig-2302-20261121    gcc-14     sparse
i386                  randconfig-2302-20261122    clang-22   sparse
i386                 randconfig-r2102-20261122    gcc-9.5.0  cocci
i386                 randconfig-r2103-20261121    gcc-10.5.0 cocci
i386                 randconfig-r2104-20261122    gcc-14     cocci
i386                 randconfig-r2106-20261122    clang-22   cocci
i386                 randconfig-r2107-20261122    clang-22   cocci
i386                 randconfig-r2300-20261121    gcc-8.5.0  sparse
i386                 randconfig-r2300-20261122    clang-24   sparse
i386                 randconfig-r2303-20261122    clang-24   sparse
i386                 randconfig-r2304-20261122    clang-24   sparse
i386                 randconfig-r2306-20261122    gcc-13.5.0 sparse
i386                 randconfig-r2306-20261122    gcc-14     sparse
i386                 randconfig-r2311-20261122    gcc-13.5.0 sparse
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.2.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261122    gcc-8.5.0
loongarch             randconfig-1001-20261122    gcc-8.5.0
loongarch             randconfig-2000-20261121    clang-22
loongarch             randconfig-2000-20261122    clang-24
loongarch             randconfig-2001-20261121    clang-22
loongarch             randconfig-2001-20261122    clang-24
loongarch             randconfig-2200-20261121    gcc-16.2.0 smatch
loongarch             randconfig-2200-20261122    clang-24   smatch
loongarch            randconfig-r2105-20261121    gcc-8.5.0  cocci
loongarch            randconfig-r2111-20261122    gcc-8.5.0  cocci
loongarch            randconfig-r2304-20261122    clang-21   sparse
loongarch            randconfig-r2304-20261122    gcc-8.5.0  sparse
loongarch            randconfig-r2307-20261122    gcc-13.5.0 sparse
loongarch            randconfig-r2310-20261122    gcc-15.3.0 sparse
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    clang-24
m68k                                 defconfig    clang-24
m68k                        m5329evb_defconfig    clang-17
m68k                  randconfig-2000-20261121    gcc-14.4.0
m68k                  randconfig-2000-20261122    gcc-8.5.0
m68k                  randconfig-2001-20261121    gcc-14.4.0
m68k                  randconfig-2001-20261122    gcc-8.5.0
m68k                  randconfig-2200-20261121    gcc-8.5.0  smatch
m68k                  randconfig-2200-20261122    gcc-12.5.0 smatch
m68k                 randconfig-r2104-20261121    gcc-8.5.0  cocci
m68k                 randconfig-r2105-20261122    gcc-9.5.0  cocci
m68k                 randconfig-r2107-20261121    gcc-8.5.0  cocci
m68k                 randconfig-r2107-20261122    gcc-8.5.0  cocci
m68k                 randconfig-r2110-20261122    gcc-8.5.0  cocci
m68k                 randconfig-r2309-20261122    gcc-15.3.0 sparse
m68k                 randconfig-r2310-20261122    gcc-13.5.0 sparse
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    clang-24
microblaze            randconfig-2000-20261121    gcc-14.4.0
microblaze            randconfig-2000-20261122    gcc-8.5.0
microblaze            randconfig-2001-20261121    gcc-14.4.0
microblaze            randconfig-2001-20261122    gcc-8.5.0
microblaze            randconfig-2200-20261121    gcc-8.5.0  smatch
microblaze            randconfig-2200-20261122    gcc-8.5.0  smatch
microblaze           randconfig-r2101-20261121    gcc-16.2.0 cocci
microblaze           randconfig-r2101-20261121    gcc-8.5.0  cocci
microblaze           randconfig-r2102-20261121    gcc-10.5.0 cocci
microblaze           randconfig-r2103-20261122    gcc-9.5.0  cocci
microblaze           randconfig-r2105-20261121    gcc-10.5.0 cocci
microblaze           randconfig-r2105-20261122    gcc-14.4.0 cocci
microblaze           randconfig-r2107-20261121    clang-17   cocci
microblaze           randconfig-r2108-20261122    gcc-15.3.0 cocci
microblaze           randconfig-r2109-20261122    gcc-8.5.0  cocci
microblaze           randconfig-r2303-20261122    gcc-12.5.0 sparse
microblaze           randconfig-r2307-20261122    gcc-11.5.0 sparse
microblaze           randconfig-r2311-20261121    gcc-11.5.0 sparse
microblaze           randconfig-r2311-20261122    clang-24   sparse
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                            mtx1_defconfig    clang-17
mips                  randconfig-2000-20261121    clang-24
mips                  randconfig-2000-20261121    gcc-16.2.0
mips                  randconfig-2000-20261122    gcc-15.3.0
mips                  randconfig-2001-20261121    gcc-16.2.0
mips                  randconfig-2001-20261121    gcc-8.5.0
mips                  randconfig-2001-20261122    gcc-15.3.0
mips                  randconfig-2002-20261121    clang-24
mips                  randconfig-2002-20261121    gcc-16.2.0
mips                  randconfig-2002-20261122    gcc-15.3.0
mips                  randconfig-2200-20261121    clang-21   smatch
mips                  randconfig-2200-20261122    gcc-11.5.0 smatch
mips                 randconfig-r2102-20261122    gcc-14     cocci
mips                 randconfig-r2103-20261122    gcc-14.4.0 cocci
mips                 randconfig-r2107-20261122    gcc-15.3.0 cocci
mips                 randconfig-r2109-20261121    clang-17   cocci
mips                 randconfig-r2110-20261121    gcc-14.4.0 cocci
mips                 randconfig-r2110-20261122    gcc-15.3.0 cocci
mips                 randconfig-r2110-20261122    gcc-8.5.0  cocci
mips                 randconfig-r2111-20261121    gcc-8.5.0  cocci
mips                 randconfig-r2111-20261122    gcc-16.2.0 cocci
mips                 randconfig-r2305-20261122    clang-24   sparse
mips                 randconfig-r2307-20261121    gcc-15.3.0 sparse
mips                 randconfig-r2310-20261122    gcc-11.5.0 sparse
mips                 randconfig-r2310-20261122    gcc-14.4.0 sparse
mips                 randconfig-r2311-20261122    gcc-14.4.0 sparse
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261122    gcc-8.5.0
nios2                 randconfig-1001-20261122    gcc-8.5.0
nios2                 randconfig-2000-20261121    clang-22
nios2                 randconfig-2000-20261122    clang-24
nios2                 randconfig-2001-20261121    clang-22
nios2                 randconfig-2001-20261122    clang-24
nios2                 randconfig-2200-20261121    gcc-10.5.0 smatch
nios2                 randconfig-2200-20261122    gcc-11.5.0 smatch
nios2                randconfig-r2101-20261122    gcc-16.2.0 cocci
nios2                randconfig-r2104-20261121    gcc-10.5.0 cocci
nios2                randconfig-r2106-20261121    clang-17   cocci
nios2                randconfig-r2106-20261122    gcc-16.2.0 cocci
nios2                randconfig-r2111-20261121    clang-17   cocci
nios2                randconfig-r2306-20261122    gcc-11.5.0 sparse
nios2                randconfig-r2307-20261122    gcc-15.3.0 sparse
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc                             defconfig    gcc-16.2.0
openrisc              randconfig-2000-20261121    gcc-12.5.0
openrisc              randconfig-2000-20261121    gcc-16.2.0
openrisc              randconfig-2000-20261122    gcc-15.3.0
openrisc              randconfig-2001-20261121    gcc-14.4.0
openrisc              randconfig-2001-20261121    gcc-16.2.0
openrisc              randconfig-2001-20261122    gcc-15.3.0
openrisc              randconfig-2002-20261121    gcc-16.2.0
openrisc              randconfig-2002-20261122    gcc-15.3.0
openrisc              randconfig-2200-20261121    gcc-14.4.0 smatch
openrisc              randconfig-2200-20261122    gcc-16.2.0 smatch
openrisc             randconfig-r2105-20261122    gcc-16.2.0 cocci
openrisc             randconfig-r2106-20261121    gcc-8.5.0  cocci
openrisc             randconfig-r2108-20261122    gcc-16.2.0 cocci
openrisc             randconfig-r2300-20261122    gcc-8.5.0  sparse
openrisc             randconfig-r2302-20261122    clang-24   sparse
openrisc             randconfig-r2307-20261122    gcc-14     sparse
openrisc             randconfig-r2307-20261122    gcc-15.3.0 sparse
openrisc             randconfig-r2309-20261121    gcc-14     sparse
openrisc             randconfig-r2309-20261122    gcc-14.4.0 sparse
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261122    clang-24
parisc                randconfig-1001-20261122    clang-24
parisc                randconfig-2000-20261121    clang-22
parisc                randconfig-2000-20261122    clang-24
parisc                randconfig-2001-20261121    clang-22
parisc                randconfig-2001-20261122    clang-24
parisc                randconfig-2200-20261121    gcc-16.2.0 smatch
parisc                randconfig-2200-20261122    gcc-8.5.0  smatch
parisc               randconfig-r2100-20261121    gcc-8.5.0  cocci
parisc               randconfig-r2101-20261121    gcc-10.5.0 cocci
parisc               randconfig-r2103-20261122    gcc-14     cocci
parisc               randconfig-r2108-20261122    gcc-8.5.0  cocci
parisc               randconfig-r2303-20261122    clang-24   sparse
parisc               randconfig-r2304-20261121    clang-24   sparse
parisc               randconfig-r2306-20261121    gcc-11.5.0 sparse
parisc               randconfig-r2307-20261122    gcc-14.4.0 sparse
parisc               randconfig-r2311-20261121    gcc-14     sparse
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    clang-24
powerpc                   mpc866_ads_defconfig    clang-17
powerpc               randconfig-1000-20261122    clang-24
powerpc               randconfig-1001-20261122    clang-24
powerpc               randconfig-2000-20261121    clang-24
powerpc               randconfig-2000-20261122    clang-24
powerpc               randconfig-2001-20261121    clang-24
powerpc               randconfig-2001-20261122    clang-24
powerpc               randconfig-2002-20261121    clang-24
powerpc               randconfig-2002-20261122    clang-24
powerpc               randconfig-2200-20261121    gcc-11.5.0 smatch
powerpc               randconfig-2200-20261122    gcc-16.2.0 smatch
powerpc              randconfig-r2300-20261122    clang-21   sparse
powerpc              randconfig-r2301-20261122    clang-24   sparse
powerpc              randconfig-r2303-20261122    clang-24   sparse
powerpc              randconfig-r2303-20261122    gcc-8.5.0  sparse
powerpc              randconfig-r2304-20261122    clang-22   sparse
powerpc              randconfig-r2304-20261122    gcc-12.5.0 sparse
powerpc              randconfig-r2305-20261122    clang-24   sparse
powerpc              randconfig-r2305-20261122    gcc-12.5.0 sparse
powerpc              randconfig-r2309-20261121    clang-18   sparse
powerpc              randconfig-r2310-20261121    clang-18   sparse
powerpc                      sequoia_defconfig    clang-17
powerpc64             randconfig-1000-20261122    clang-24
powerpc64             randconfig-1001-20261122    clang-24
powerpc64             randconfig-2000-20261121    clang-24
powerpc64             randconfig-2000-20261122    clang-24
powerpc64             randconfig-2001-20261121    clang-24
powerpc64             randconfig-2001-20261122    clang-24
powerpc64             randconfig-2002-20261121    clang-24
powerpc64             randconfig-2002-20261122    clang-24
powerpc64             randconfig-2200-20261121    gcc-10.5.0 smatch
powerpc64             randconfig-2200-20261122    clang-24   smatch
powerpc64            randconfig-r2100-20261122    gcc-14.4.0 cocci
powerpc64            randconfig-r2107-20261122    clang-22   cocci
powerpc64            randconfig-r2108-20261122    clang-22   cocci
powerpc64            randconfig-r2109-20261121    gcc-14.4.0 cocci
powerpc64            randconfig-r2302-20261121    gcc-8.5.0  sparse
powerpc64            randconfig-r2303-20261121    gcc-8.5.0  sparse
powerpc64            randconfig-r2309-20261122    clang-24   sparse
powerpc64            randconfig-r2310-20261122    clang-24   sparse
powerpc64            randconfig-r2311-20261122    gcc-15.3.0 sparse
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.2.0
riscv                 randconfig-1000-20261122    gcc-9.5.0
riscv                 randconfig-1001-20261122    gcc-9.5.0
riscv                 randconfig-2000-20261121    gcc-9.5.0
riscv                 randconfig-2000-20261122    gcc-14.4.0
riscv                 randconfig-2001-20261121    gcc-9.5.0
riscv                 randconfig-2001-20261122    gcc-14.4.0
riscv                 randconfig-2002-20261121    gcc-9.5.0
riscv                 randconfig-2002-20261122    gcc-14.4.0
riscv                 randconfig-2003-20261121    gcc-9.5.0
riscv                 randconfig-2003-20261122    gcc-14.4.0
riscv                 randconfig-2004-20261121    gcc-9.5.0
riscv                 randconfig-2004-20261122    gcc-14.4.0
riscv                 randconfig-2005-20261121    gcc-9.5.0
riscv                 randconfig-2005-20261122    gcc-14.4.0
riscv                 randconfig-2200-20261121    clang-24   smatch
riscv                 randconfig-2200-20261122    gcc-8.5.0  smatch
riscv                randconfig-r2100-20261122    gcc-9.5.0  cocci
riscv                randconfig-r2103-20261121    gcc-8.5.0  cocci
riscv                randconfig-r2104-20261122    gcc-16.2.0 cocci
riscv                randconfig-r2106-20261122    gcc-8.5.0  cocci
riscv                randconfig-r2110-20261122    clang-22   cocci
riscv                randconfig-r2303-20261122    clang-22   sparse
riscv                randconfig-r2305-20261121    gcc-8.5.0  sparse
riscv                randconfig-r2311-20261122    gcc-15.3.0 sparse
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    gcc-16.2.0
s390                  randconfig-1000-20261122    gcc-9.5.0
s390                  randconfig-1001-20261122    gcc-9.5.0
s390                  randconfig-2000-20261121    clang-22
s390                  randconfig-2000-20261121    clang-24
s390                  randconfig-2000-20261122    clang-17
s390                  randconfig-2001-20261121    clang-22
s390                  randconfig-2001-20261121    clang-24
s390                  randconfig-2001-20261122    clang-17
s390                  randconfig-2002-20261121    clang-22
s390                  randconfig-2002-20261122    clang-17
s390                  randconfig-2003-20261121    clang-20
s390                  randconfig-2003-20261121    clang-22
s390                  randconfig-2003-20261122    clang-17
s390                  randconfig-2004-20261121    clang-22
s390                  randconfig-2004-20261121    gcc-9.5.0
s390                  randconfig-2004-20261122    clang-17
s390                  randconfig-2005-20261121    clang-22
s390                  randconfig-2005-20261121    gcc-15.3.0
s390                  randconfig-2005-20261122    clang-17
s390                  randconfig-2200-20261121    gcc-8.5.0  smatch
s390                  randconfig-2200-20261122    gcc-8.5.0  smatch
s390                 randconfig-r2106-20261121    gcc-14.4.0 cocci
s390                 randconfig-r2107-20261121    clang-24   cocci
s390                 randconfig-r2108-20261121    clang-17   cocci
s390                 randconfig-r2109-20261121    gcc-11.5.0 cocci
s390                 randconfig-r2109-20261122    clang-22   cocci
s390                 randconfig-r2300-20261122    clang-22   sparse
s390                 randconfig-r2302-20261122    clang-22   sparse
s390                 randconfig-r2307-20261121    clang-18   sparse
s390                 randconfig-r2308-20261122    gcc-11.5.0 sparse
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                                   defconfig    gcc-14
sh                    randconfig-1000-20261122    gcc-9.5.0
sh                    randconfig-1001-20261122    gcc-9.5.0
sh                    randconfig-2000-20261121    gcc-12.5.0
sh                    randconfig-2000-20261121    gcc-16.2.0
sh                    randconfig-2000-20261122    gcc-13.5.0
sh                    randconfig-2001-20261121    gcc-10.5.0
sh                    randconfig-2001-20261121    gcc-16.2.0
sh                    randconfig-2001-20261122    gcc-13.5.0
sh                    randconfig-2002-20261121    gcc-16.2.0
sh                    randconfig-2002-20261122    gcc-13.5.0
sh                    randconfig-2003-20261121    gcc-16.2.0
sh                    randconfig-2003-20261122    gcc-13.5.0
sh                    randconfig-2004-20261121    gcc-16.2.0
sh                    randconfig-2004-20261122    gcc-13.5.0
sh                    randconfig-2005-20261121    gcc-10.5.0
sh                    randconfig-2005-20261121    gcc-16.2.0
sh                    randconfig-2005-20261122    gcc-13.5.0
sh                    randconfig-2200-20261121    gcc-10.5.0 smatch
sh                    randconfig-2200-20261122    gcc-13.5.0 smatch
sh                   randconfig-r2102-20261122    gcc-16.2.0 cocci
sh                   randconfig-r2108-20261122    clang-22   cocci
sh                   randconfig-r2109-20261122    gcc-8.5.0  cocci
sh                   randconfig-r2111-20261122    clang-22   cocci
sh                   randconfig-r2111-20261122    gcc-15.3.0 cocci
sh                   randconfig-r2301-20261122    gcc-8.5.0  sparse
sh                   randconfig-r2302-20261122    clang-24   sparse
sh                   randconfig-r2306-20261121    gcc-14     sparse
sh                      sh7710voipgw_defconfig    clang-17
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261122    clang-24
sparc                 randconfig-1001-20261122    clang-24
sparc                 randconfig-2000-20261121    gcc-8.5.0
sparc                 randconfig-2000-20261122    clang-21
sparc                 randconfig-2001-20261121    gcc-8.5.0
sparc                 randconfig-2001-20261122    clang-21
sparc                 randconfig-2200-20261121    gcc-8.5.0  smatch
sparc                 randconfig-2200-20261122    gcc-16.2.0 smatch
sparc                randconfig-r2102-20261122    gcc-14.4.0 cocci
sparc                randconfig-r2104-20261122    gcc-14     cocci
sparc                randconfig-r2107-20261121    gcc-14.4.0 cocci
sparc                randconfig-r2109-20261121    gcc-8.5.0  cocci
sparc                randconfig-r2109-20261122    gcc-16.2.0 cocci
sparc                randconfig-r2305-20261122    gcc-8.5.0  sparse
sparc                randconfig-r2308-20261121    clang-18   sparse
sparc                randconfig-r2310-20261121    gcc-11.5.0 sparse
sparc                randconfig-r2311-20261122    gcc-11.5.0 sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261122    clang-24
sparc64               randconfig-1001-20261122    clang-24
sparc64               randconfig-2000-20261121    gcc-8.5.0
sparc64               randconfig-2000-20261122    clang-21
sparc64               randconfig-2001-20261121    gcc-8.5.0
sparc64               randconfig-2001-20261122    clang-21
sparc64               randconfig-2200-20261121    clang-20   smatch
sparc64               randconfig-2200-20261122    clang-20   smatch
sparc64              randconfig-r2103-20261122    gcc-16.2.0 cocci
sparc64              randconfig-r2106-20261122    clang-22   cocci
sparc64              randconfig-r2106-20261122    gcc-8.5.0  cocci
sparc64              randconfig-r2107-20261122    gcc-16.2.0 cocci
sparc64              randconfig-r2108-20261121    gcc-8.5.0  cocci
sparc64              randconfig-r2108-20261122    gcc-8.5.0  cocci
sparc64              randconfig-r2300-20261122    clang-24   sparse
sparc64              randconfig-r2301-20261121    gcc-8.5.0  sparse
sparc64              randconfig-r2302-20261121    clang-24   sparse
sparc64              randconfig-r2302-20261122    gcc-12.5.0 sparse
sparc64              randconfig-r2302-20261122    gcc-8.5.0  sparse
sparc64              randconfig-r2308-20261122    gcc-14     sparse
sparc64              randconfig-r2309-20261122    gcc-11.5.0 sparse
sparc64              randconfig-r2310-20261122    gcc-14     sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.2.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261122    clang-24
um                    randconfig-1001-20261122    clang-24
um                    randconfig-2000-20261121    gcc-8.5.0
um                    randconfig-2000-20261122    clang-21
um                    randconfig-2001-20261121    gcc-8.5.0
um                    randconfig-2001-20261122    clang-21
um                    randconfig-2200-20261121    gcc-14     smatch
um                    randconfig-2200-20261122    gcc-14     smatch
um                   randconfig-r2301-20261122    clang-22   sparse
um                   randconfig-r2304-20261121    gcc-8.5.0  sparse
um                   randconfig-r2305-20261122    clang-21   sparse
um                   randconfig-r2306-20261122    gcc-14.4.0 sparse
um                   randconfig-r2306-20261122    gcc-15.3.0 sparse
um                   randconfig-r2307-20261121    gcc-14     sparse
um                   randconfig-r2307-20261122    clang-24   sparse
um                   randconfig-r2308-20261121    gcc-11.5.0 sparse
um                   randconfig-r2308-20261122    clang-24   sparse
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261122    gcc-14
x86_64                randconfig-1001-20261122    gcc-14
x86_64                randconfig-1002-20261122    gcc-14
x86_64                randconfig-1003-20261122    gcc-14
x86_64                randconfig-1004-20261122    gcc-14
x86_64                randconfig-1005-20261122    gcc-14
x86_64                randconfig-1006-20261122    gcc-14
x86_64                randconfig-1007-20261122    gcc-14
x86_64                randconfig-1008-20261122    gcc-14
x86_64                randconfig-1009-20261122    gcc-14
x86_64                randconfig-1010-20261122    gcc-14
x86_64                randconfig-1011-20261122    gcc-14
x86_64                randconfig-1012-20261122    clang-22
x86_64                randconfig-1013-20261122    clang-22
x86_64                randconfig-1014-20261122    clang-22
x86_64                randconfig-1015-20261122    clang-22
x86_64                randconfig-1016-20261122    clang-22
x86_64                randconfig-1017-20261122    clang-22
x86_64                randconfig-2000-20261121    clang-22
x86_64                randconfig-2000-20261121    gcc-14
x86_64                randconfig-2000-20261122    clang-22
x86_64                randconfig-2001-20261121    clang-22
x86_64                randconfig-2001-20261121    gcc-14
x86_64                randconfig-2001-20261122    clang-22
x86_64                randconfig-2002-20261121    clang-22
x86_64                randconfig-2002-20261121    gcc-14
x86_64                randconfig-2002-20261122    clang-22
x86_64                randconfig-2003-20261121    gcc-14
x86_64                randconfig-2003-20261122    clang-22
x86_64                randconfig-2004-20261121    gcc-14
x86_64                randconfig-2004-20261122    clang-22
x86_64                randconfig-2005-20261121    clang-22
x86_64                randconfig-2005-20261121    gcc-14
x86_64                randconfig-2005-20261122    clang-22
x86_64                randconfig-2100-20261121    gcc-14     cocci
x86_64                randconfig-2100-20261122    gcc-14     cocci
x86_64                randconfig-2101-20261121    gcc-14     cocci
x86_64                randconfig-2101-20261122    gcc-14     cocci
x86_64                randconfig-2102-20261121    gcc-14     cocci
x86_64                randconfig-2102-20261122    gcc-14     cocci
x86_64                randconfig-2103-20261121    gcc-14     cocci
x86_64                randconfig-2103-20261122    gcc-14     cocci
x86_64                randconfig-2104-20261121    gcc-14     cocci
x86_64                randconfig-2104-20261122    gcc-14     cocci
x86_64                randconfig-2105-20261121    gcc-14     cocci
x86_64                randconfig-2105-20261122    gcc-14     cocci
x86_64                randconfig-2200-20261121    gcc-14     smatch
x86_64                randconfig-2200-20261122    clang-22   smatch
x86_64                randconfig-2300-20261121    clang-22   sparse
x86_64                randconfig-2300-20261121    gcc-14     sparse
x86_64                randconfig-2300-20261122    clang-22   sparse
x86_64                randconfig-2301-20261121    gcc-14     sparse
x86_64                randconfig-2301-20261122    clang-22   sparse
x86_64                randconfig-2302-20261121    gcc-13     sparse
x86_64                randconfig-2302-20261121    gcc-14     sparse
x86_64                randconfig-2302-20261122    clang-22   sparse
x86_64               randconfig-r2101-20261122    gcc-14     cocci
x86_64               randconfig-r2103-20261121    gcc-16.2.0 cocci
x86_64               randconfig-r2103-20261122    gcc-14     cocci
x86_64               randconfig-r2106-20261121    clang-22   cocci
x86_64               randconfig-r2108-20261121    gcc-14     cocci
x86_64               randconfig-r2110-20261121    gcc-8.5.0  cocci
x86_64               randconfig-r2303-20261121    clang-24   sparse
x86_64               randconfig-r2308-20261121    gcc-14     sparse
x86_64               randconfig-r2311-20261122    gcc-14     sparse
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
xtensa                   nommu_kc705_defconfig    clang-17
xtensa                randconfig-1000-20261122    clang-24
xtensa                randconfig-1001-20261122    clang-24
xtensa                randconfig-2000-20261121    gcc-16.2.0
xtensa                randconfig-2000-20261121    gcc-8.5.0
xtensa                randconfig-2000-20261122    gcc-9.5.0
xtensa                randconfig-2001-20261121    gcc-12.5.0
xtensa                randconfig-2001-20261121    gcc-16.2.0
xtensa                randconfig-2001-20261122    gcc-9.5.0
xtensa                randconfig-2200-20261121    gcc-12.5.0 smatch
xtensa                randconfig-2200-20261122    gcc-11.5.0 smatch
xtensa               randconfig-r2100-20261122    gcc-14     cocci
xtensa               randconfig-r2101-20261122    gcc-14.4.0 cocci
xtensa               randconfig-r2101-20261122    gcc-9.5.0  cocci
xtensa               randconfig-r2300-20261122    gcc-12.5.0 sparse
xtensa               randconfig-r2310-20261121    gcc-8.5.0  sparse

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
