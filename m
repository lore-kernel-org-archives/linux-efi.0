Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854743B6BFA
	for <linux-efi@vger.kernel.org>; Sun, 20 Sep 2026 03:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789874938; cv=none; b=YRtIOWUoi7YyFXNKWTThvsUODQR6aXeMDPEMPzFbDDEq0M+oUgAAyDBqD8Vs8rcJGUJ02PCbGqEVS8QqUgCYAW38B7+9XDMxOWAL5l/AIdjI+qN/yD+HVaW7Ao++DnUscAU5MCj0wC3XfR4HkSrcQ45sC2iMri/bBldNmdoMgl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789874938; c=relaxed/simple;
	bh=7ZPgfkf65V4vNTun5Nq+bcMBdEq3b+a1EviW8uFArqo=;
	h=Date:From:To:Cc:Subject:Message-ID; b=u0bQL8395IH2dWEJ0QceYiAg+aBVrs13ixv1GMZjnjoZ4QPWa6HZGaAC+P7eLiV6FPfJCfOfliCqPTLo3Z7qlwBjpzAyKEducNyXo3+p3ZNH9CTg+ZHPrY+GPp00DC/9+ODR+8Wl4x3JenTSHb5YQV4z4QTXWOfkGlYUJGmyMEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BF1qrDe4; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BF1qrDe4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789874936; x=1821410936;
  h=date:from:to:cc:subject:message-id;
  bh=7ZPgfkf65V4vNTun5Nq+bcMBdEq3b+a1EviW8uFArqo=;
  b=BF1qrDe4AcKbQPJ3qNQDuEdo0qz4etDnPTv0CaNni54Uc/vwbIqWFKnj
   0TWSAJZmAdvM9687LNMezQvo634jAwNEKxeqy2SoVauGkl89Q+rfulxy2
   g+2Bd27kUBA0YLwzGPjzBjqo8FbCMeWS9mu9N3dotCM+5c70aAzgFYXCx
   wzfD2ebxaBwacGjaE68B1OipHOTJPFxVK3WZuBRY6F2mTe6gj7ele8dDF
   bJuvB88MXEuMKBTWM/SKtHkt5bUa4n91nM9oX/6twlLUqeRsamzm5DArx
   bHLi9jyTyzvIjJB3Oe+8iAQcxxfACEimBfM5pzSnldX1zMLixK38jufZF
   w==;
X-CSE-ConnectionGUID: fF41VIS5TbiyQxSGJZagTg==
X-CSE-MsgGUID: +ahqrRq+Ts6Gl+TLGLCA5A==
X-IronPort-AV: E=McAfee;i="6800,10657,11910"; a="115915688"
X-IronPort-AV: E=Sophos;i="6.27,111,1787036400"; 
   d="scan'208";a="115915688"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2026 20:28:55 -0700
X-CSE-ConnectionGUID: 1nhIypaCRC+DX18PJ0WlKQ==
X-CSE-MsgGUID: BW74mLp4TFmOVr9DOUI2ow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,111,1787036400"; 
   d="scan'208";a="271639322"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 19 Sep 2026 20:28:53 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x88ER-00000000Blf-1iP2;
	Sun, 20 Sep 2026 03:28:47 +0000
Date: Sun, 20 Sep 2026 11:27:57 +0800
From: kernel test robot <lkp@intel.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, linux-efi@vger.kernel.org,
 Vincent Mailhol <mailhol@kernel.org>
Subject: [efi:bootloader-info 6/9] error.c:undefined reference to
 `vsnprintf'
Message-ID: <202609201125.Q6uy2t2V-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git bootloader-info
head:   9925e4ce78365f6378ae7facdc987b0b4ef67d37
commit: 10bfb3ed534efe4a93c8a87e2941a77623554d55 [6/9] efi/libstub: Output UTF-16 directly from vsnprintf()
config: x86_64-defconfig (https://download.01.org/0day-ci/archive/20260920/202609201125.Q6uy2t2V-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260920/202609201125.Q6uy2t2V-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609201125.Q6uy2t2V-lkp@intel.com/

All errors (new ones prefixed by >>):

   ld: arch/x86/boot/compressed/error.o: in function `panic':
>> error.c:(.text.unlikely+0x52): undefined reference to `vsnprintf'
   ld: arch/x86/boot/compressed/vmlinux: hidden symbol `vsnprintf' isn't defined
   ld: final link failed: bad value

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
