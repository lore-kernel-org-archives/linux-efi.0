Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB831E492D
	for <linux-efi@vger.kernel.org>; Sat, 25 Jul 2026 12:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784983235; cv=none; b=iQYVcLmX9eDqMOGhYO5ieWMmRRIIHtEVoUlWVGbSMaGNONWPq/5HPHMOKmeHb2/OF5OpoWOprK9JOV/ZEltPvaL7gqji+ixzNk3tSIrP/Jbsw8hvm37YA4zqCRo+GLvrxNaqC11bo2Z4Pgpqr0RUAE7FTk6f3wf8s9tS9rZ1BRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784983235; c=relaxed/simple;
	bh=p6Z15NNze0LR8/HfdY7u02vnm/j4ItDB5EUpZcdMLLA=;
	h=Date:From:To:Cc:Subject:Message-ID; b=UvbNigTUQK6t7wl+ISiSjOiVSLEVDcPMWP1+4r/j004IokefqDmZzXnlzuTnnQa5I/SuKQJ1juil5vs0E6Nl/Gtho9xBVYDgzw3sZKaqeDCIaiw0hrwvY7lXzvePZyHkKFd87hxw3SyHyVmUb3Km5SVoUn8x66ABQcTCydlKNBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mdlI3Y8S; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mdlI3Y8S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784983233; x=1816519233;
  h=date:from:to:cc:subject:message-id;
  bh=p6Z15NNze0LR8/HfdY7u02vnm/j4ItDB5EUpZcdMLLA=;
  b=mdlI3Y8SKdMK4Of0dF6y3H+BEwx2kq05phqfAZWdSyEtATHffWVC+QGo
   rOKqxakRtyLu1Ong9hxBXg41hspqpk2JSXtfVsgjq3cDpRxPM/Fa8p4c7
   1+zlK+y+Dk/xLYB//xM/1LAuC5cV1vFAz9cJbHB2mR3Vycu4cxig1ZaES
   NHqkgoLig+OUZTkH1IPxH9VXHDSxuDXyxbBCxjESmVT5JnlEVj9701MKn
   qCTByXe7tQQTRrUqqhp9TvMiqsahVspzXqVEZDWR19u8EJnxKyHvkQjyg
   D0lue2mkF02AysySdkIXBa/HVEXq5sgOAGal5/KCXHH1dql8VEstSnsfw
   g==;
X-CSE-ConnectionGUID: JBbk88EpTcCgPufKdvhgHA==
X-CSE-MsgGUID: XjxZSuaMSuGZNwZJAAxicw==
X-IronPort-AV: E=McAfee;i="6800,10657,11855"; a="84607839"
X-IronPort-AV: E=Sophos;i="6.25,184,1779174000"; 
   d="scan'208";a="84607839"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2026 05:40:32 -0700
X-CSE-ConnectionGUID: XufAlxj8QZuklfaZGs9vCw==
X-CSE-MsgGUID: WH0DG00lSmWleChIpLIlWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,184,1779174000"; 
   d="scan'208";a="256301350"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa008.fm.intel.com with ESMTP; 25 Jul 2026 05:40:32 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wnbg5-00000000bgQ-2E47;
	Sat, 25 Jul 2026 12:40:29 +0000
Date: Sat, 25 Jul 2026 20:39:29 +0800
From: kernel test robot <lkp@intel.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org
Subject: [efi:next] BUILD SUCCESS
 b4c1bfc231521b627214bf654417bfef3721da79
Message-ID: <202607252052.Jka7jnDd-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git next
branch HEAD: b4c1bfc231521b627214bf654417bfef3721da79  efi: make efi_guid_to_str() take a const GUID pointer

elapsed time: 3147m

configs tested: 17
configs skipped: 0

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha              allnoconfig    gcc-16.1.0
alpha             allyesconfig    gcc-16.1.0
alpha                defconfig    gcc-16.1.0
arc               allmodconfig    gcc-16.1.0
arc               allyesconfig    gcc-16.1.0
csky              allmodconfig    gcc-16.1.0
i386              allmodconfig    gcc-14
loongarch            defconfig    clang-24
nios2             allmodconfig    gcc-11.5.0
nios2              allnoconfig    gcc-11.5.0
parisc            allmodconfig    gcc-16.1.0
parisc            allyesconfig    gcc-16.1.0
parisc               defconfig    gcc-16.1.0
sh                   defconfig    gcc-16.1.0
sh         edosk7760_defconfig    gcc-16.1.0
x86_64                   kexec    clang-22
x86_64            rhel-9.4-bpf    gcc-14

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
