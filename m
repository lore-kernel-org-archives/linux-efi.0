Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0E738D6BC;
	Mon, 16 Mar 2026 10:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773656211; cv=none; b=r3CSrr2uQJ6MrwIQBFfHScEBXN1r6LqkIRAHHeclcHHtk/2qnZse/DiGDRyPW83Ysxzku2aU63NYEi7PEuFC9m+24uHr7ysF+kfXWqx6BFZ+08rLMNbOQiY6Pxtzf7zXDNmnjAyaUjFf+sjxvGgai9uEr5idNA45adQJXz8YTNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773656211; c=relaxed/simple;
	bh=fLFv03guTdqoxn8S5olGvdGgfX5YsKowSFIRL2L2AMI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VJHn7lFVPMZA5cRG3u4BSNvL1UOnEZ8dEnQ14nvKOhxvc8lAqL6js4/0kZgJUgESUmaJeXMiVrW8/K4pAMEleIaOIq33mWZ+5rz59g2fLbOoT0vQjAawP+0SNNlE935LYhW9dqMi6PuMWM7p6uo/bWOl1Vv7oPfOtDyyoffKwO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iqpzDpd0; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iqpzDpd0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773656211; x=1805192211;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fLFv03guTdqoxn8S5olGvdGgfX5YsKowSFIRL2L2AMI=;
  b=iqpzDpd0P7B16ktC8MJLy51q4F5U1lO8Y9egiKMR4jDu6YsOPcAL4gdL
   p/QOC1ElRLmn+vgToQ4jzyiSlwlkOAeAgOohK/k3iejZL/10dysMLMg2a
   ruABDMaroBNIcXXZFmeVt3neqGVbYMCHulPFmxLmae/Oy4vp0dYRRTCtl
   9x5KN7NPewqTJjtNJznGXbkJhJ98LlfgH9299/8CNcn+q1SNb0JbKzD5f
   HPR5cn+pPAMHMFZLNCf5qSPeTol2Pqt5EIR4AX5Cr5Y33GYx1Cu2zEVkj
   CPHK1VoUPLbK2DoEeNo0ZbVxzWJhYEgUKosBNrMCqnaX5clncfj7s8x7H
   g==;
X-CSE-ConnectionGUID: FI49hGwaQze3+rwq9mPZFw==
X-CSE-MsgGUID: zdLZyZx2RtmO9Ss/dWFccw==
X-IronPort-AV: E=McAfee;i="6800,10657,11730"; a="74584647"
X-IronPort-AV: E=Sophos;i="6.23,123,1770624000"; 
   d="scan'208";a="74584647"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2026 03:16:46 -0700
X-CSE-ConnectionGUID: Z7mT+CIJS/2m4XGlZID7Kg==
X-CSE-MsgGUID: tN6qWwrPQ2av/M0yiJS7SQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,123,1770624000"; 
   d="scan'208";a="226334765"
Received: from igk-lkp-server01.igk.intel.com (HELO 9958d990ccf2) ([10.211.93.152])
  by orviesa004.jf.intel.com with ESMTP; 16 Mar 2026 03:16:44 -0700
Received: from kbuild by 9958d990ccf2 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w2505-000000004Cf-21ua;
	Mon, 16 Mar 2026 10:16:41 +0000
Date: Mon, 16 Mar 2026 11:16:11 +0100
From: kernel test robot <lkp@intel.com>
To: Atharva Tiwari <atharvatiwarilinuxdev@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Atharva Tiwari <atharvatiwarilinuxdev@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>, Hans de Goede <hansg@kernel.org>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	linux-kernel@vger.kernel.org,
	"(open list:EXTENSIBLE FIRMWARE INTERFACE \\(EFI\\))" <linux-efi@vger.kernel.org>,
	platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH v3 2/2] platform/apple-gmux: use apple_brightness to save
 brightness to EFI
Message-ID: <202603161105.ILZkpASC-lkp@intel.com>
References: <20260315222020.24341-3-atharvatiwarilinuxdev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260315222020.24341-3-atharvatiwarilinuxdev@gmail.com>

Hi Atharva,

kernel test robot noticed the following build errors:

[auto build test ERROR on efi/next]
[also build test ERROR on linus/master v7.0-rc4 next-20260313]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Atharva-Tiwari/efi-Save-Brightness-using-EFI-on-Macs/20260316-084441
base:   https://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git next
patch link:    https://lore.kernel.org/r/20260315222020.24341-3-atharvatiwarilinuxdev%40gmail.com
patch subject: [PATCH v3 2/2] platform/apple-gmux: use apple_brightness to save brightness to EFI
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20260316/202603161105.ILZkpASC-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260316/202603161105.ILZkpASC-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603161105.ILZkpASC-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "apple_brightness_shutdown" [drivers/platform/x86/apple-gmux.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
