Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D9B49E5CA
	for <linux-efi@vger.kernel.org>; Mon,  7 Sep 2026 19:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788807640; cv=none; b=YZ8nRhnHWEhwVnANRKjM9w8vLsd/qSVgtN9GYhFzkOlMiarbBzQ+72NK2KFlCPqmglH8gCo8V667ojqvgCyu+fYLu2wP+9lwfOJS27OtxLspF82Rqz+GGl/wai3mKMa6T3utF6W5DhrUAqQB5QQrwFLnTkKKYXyAqXskW5u2Gpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788807640; c=relaxed/simple;
	bh=vjXQBgodwpE0LSK/cFZ5FcarDiiRRp8O+E8I197gfkg=;
	h=Date:From:To:Cc:Subject:Message-ID; b=VahlI+pKtG3Wm13Q4WWdvY1iDjZNfwmtpWiOBb1mMLuEEst1agbUuXVAST7W3Faw6Z9gJvgGvyidLeGgEj5wS/P3ar+pTk5t27Blucm8YoVBsBy4OIXzfbecsiiCjq/Vx9aGKwmRXEAQPstoByrTkOkUTkLIi0UZG/9RWhB0FA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lafBlCHn; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lafBlCHn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788807622; x=1820343622;
  h=date:from:to:cc:subject:message-id;
  bh=vjXQBgodwpE0LSK/cFZ5FcarDiiRRp8O+E8I197gfkg=;
  b=lafBlCHnuAA/DNbj/tJ1lu29Ayk7liqlE0QI7Y5VFaLUTdvFp4IdwmtE
   312gLqZQnZIcbLk1pdCSWizJxncm4vIAsWGuF6ENmFjd0/Es2kEDn2Jjl
   8JJOym4qIvczwmVjF/qEA9Fr4MoQ3uweZsCPkkTWTixhnsdcpOeq44w8S
   FUaftbxp/6sOjtix7YPnJj27lxDKUHKLUrqriUSvl/P/J67/jdkNWyXO6
   j4dZUvOxhhb6GSaKvGAPe+j/xPXJ1lvyRVLvP7gINQp3TOzDA7oSc93a1
   BOma3ZzvcZqOU58NkWZUR+oM+ZAUnPbj56Pvbu7op609FmU7qJCdifas6
   w==;
X-CSE-ConnectionGUID: HyUZvR3IQ3u4/kFzvO4UTA==
X-CSE-MsgGUID: UgiTx4yQQVCtWSyZcnnQpQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11899"; a="99805004"
X-IronPort-AV: E=Sophos;i="6.25,267,1779174000"; 
   d="scan'208";a="99805004"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2026 12:00:21 -0700
X-CSE-ConnectionGUID: /AQnFS/QS62gsI5F/V67QA==
X-CSE-MsgGUID: fIKCikBzTlSZMORwErCMuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,267,1779174000"; 
   d="scan'208";a="270263841"
Received: from lkp-server01.sh.intel.com (HELO dff15f1b2031) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 07 Sep 2026 12:00:20 -0700
Received: from kbuild by dff15f1b2031 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x3eZl-000000001G7-3kDt;
	Mon, 07 Sep 2026 19:00:17 +0000
Date: Tue, 08 Sep 2026 03:00:07 +0800
From: kernel test robot <lkp@intel.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org
Subject: [efi:next] BUILD SUCCESS
 2457ac9d44f3c2a33459eef39989f26d545fcece
Message-ID: <202609080255.474AT255-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git next
branch HEAD: 2457ac9d44f3c2a33459eef39989f26d545fcece  efi/libstub: factor shared static GUID variables

elapsed time: 4377m

configs tested: 65
configs skipped: 0

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha         allnoconfig    gcc-16.1.0
alpha        allyesconfig    gcc-16.1.0
arc          allmodconfig    clang-24
arc           allnoconfig    gcc-16.1.0
arc          allyesconfig    clang-24
arm           allnoconfig    gcc-16.1.0
arm          allyesconfig    clang-24
arm64        allmodconfig    clang-24
arm64         allnoconfig    gcc-16.1.0
csky         allmodconfig    gcc-16.1.0
csky          allnoconfig    gcc-16.1.0
hexagon      allmodconfig    gcc-16.1.0
hexagon       allnoconfig    gcc-16.1.0
i386         allmodconfig    clang-22
i386          allnoconfig    gcc-16.1.0
i386         allyesconfig    clang-22
loongarch    allmodconfig    clang-24
loongarch     allnoconfig    gcc-16.1.0
m68k         allmodconfig    gcc-16.1.0
m68k          allnoconfig    gcc-16.1.0
m68k         allyesconfig    clang-24
microblaze    allnoconfig    gcc-16.1.0
microblaze   allyesconfig    gcc-16.1.0
mips         allmodconfig    gcc-16.1.0
mips          allnoconfig    gcc-16.1.0
mips         allyesconfig    gcc-16.1.0
nios2        allmodconfig    clang-20
nios2         allnoconfig    clang-24
nios2         allnoconfig    gcc-11.5.0
openrisc     allmodconfig    clang-20
openrisc      allnoconfig    clang-24
openrisc      allnoconfig    gcc-16.1.0
parisc       allmodconfig    gcc-16.1.0
parisc        allnoconfig    clang-24
parisc        allnoconfig    gcc-16.1.0
parisc       allyesconfig    clang-17
powerpc      allmodconfig    gcc-16.1.0
powerpc       allnoconfig    clang-24
powerpc       allnoconfig    gcc-16.1.0
riscv        allmodconfig    clang-24
riscv         allnoconfig    clang-24
riscv         allnoconfig    gcc-16.1.0
riscv        allyesconfig    clang-24
s390         allmodconfig    clang-17
s390          allnoconfig    clang-24
s390         allyesconfig    gcc-16.1.0
sh           allmodconfig    gcc-16.1.0
sh            allnoconfig    clang-24
sh            allnoconfig    gcc-16.1.0
sh           allyesconfig    clang-17
sparc         allnoconfig    clang-24
sparc         allnoconfig    gcc-16.1.0
sparc64      allmodconfig    clang-20
um           allmodconfig    clang-17
um            allnoconfig    clang-17
um            allnoconfig    clang-24
um           allyesconfig    gcc-16.1.0
x86_64       allmodconfig    clang-22
x86_64        allnoconfig    clang-22
x86_64        allnoconfig    clang-24
x86_64       allyesconfig    clang-22
x86_64      rhel-9.4-rust    clang-22
xtensa        allnoconfig    clang-24
xtensa        allnoconfig    gcc-16.1.0
xtensa       allyesconfig    clang-20

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
