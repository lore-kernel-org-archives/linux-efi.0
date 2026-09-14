Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C335623EAB3;
	Mon, 14 Sep 2026 02:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789353251; cv=none; b=LmNjCYth6POqhFG/xMJq+zU3yYbKIATSG1kUlQ9yIi/HW2FerMKPdXwJ3Ff8eg9a163eMrGq4nfPhY216d4FUqzxVGVpR+56PVzy/xa+ATQu9q/X7qXSnHRc8Xq/09+yO7Eyd3k1FK1bXG9WnPiM2ImCFKy1b6QVAPbREnu/h7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789353251; c=relaxed/simple;
	bh=gDPynbvaFXlIaeZuhaCZccO2AqwyBkyI5yxUQ+EN3Xc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=IpBx/uX9JIq5MIuFrIwiSI2FesEYFXfLFR38KPLkc/SqAhaRwsAFuo02jF4fMPLDy/NNY3/IYcOoMIbUQLXMe5KiUGuI8PtnNZwr/p1Upc/1Zfe5uRAHUe34q5ZGT89U67x7baATyh61GRD2dKPMGagku7+e/1qLGBYWZrLZyic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ci84Nhq7; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ci84Nhq7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789353248; x=1820889248;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=gDPynbvaFXlIaeZuhaCZccO2AqwyBkyI5yxUQ+EN3Xc=;
  b=Ci84Nhq7FBE2IXSji+36qF35Fn0EyUPUzP83d5tV+RZXw34Yi5ZA6Z/V
   gQ9uVpKaWys+I6Gq1nzlvWmI4ya4HipR2jNF8Ze7dlTSmmQ0ZLi8vnDt2
   iYMrewxiimWBef7VcuR86THuyefBxx5Oy2r53XLu6k8x4nY2xtKblnkBN
   pI6cmC8glv9rzgqPJAlayfbyKAP4H2HAnf5nRd059YtXReRicsEi7PBG+
   873lM0Mw9ZnfaFvscl9WtGELtcndSsShy8S8791J26WaoS7pQw0VIVEkG
   Lm7YESd/dPT1tNO5DsbBlNbvAyt7ANZBsg86UWLNHIJfcC+nD8OkPPdyK
   A==;
X-CSE-ConnectionGUID: lGYmXC8BSJ2eMlwgFXCHMA==
X-CSE-MsgGUID: NKfYe6mXRZy/zu7U2jamlg==
X-IronPort-AV: E=McAfee;i="6800,10657,11904"; a="89585514"
X-IronPort-AV: E=Sophos;i="6.27,102,1787036400"; 
   d="scan'208";a="89585514"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2026 19:34:07 -0700
X-CSE-ConnectionGUID: K5XA3zMQQU6WtxE+3LaaHg==
X-CSE-MsgGUID: 6w+VRTKBRHWVz/kAXWB6Vw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,102,1787036400"; 
   d="scan'208";a="922092"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.182.64])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2026 19:34:05 -0700
Date: Mon, 14 Sep 2026 10:34:02 +0800
From: kernel test robot <yi1.lai@intel.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Anisse Astier <anisse@astier.eu>, linux-efi@vger.kernel.org,
	yi1.lai@intel.com
Subject: [linus:master] [efivarfs]  b2326338dc: stress-ng.sysinfo.ops_per_sec
 19.5% improvement
Message-ID: <202609141037.779d7909-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline



Hello,

kernel test robot noticed a 19.5% improvement of stress-ng.sysinfo.ops_per_sec on:

commit: b2326338dc683e8c1067c0cbf7a47986c4190902 ("efivarfs: Rate limit statfs() handler") https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

testcase: stress-ng
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 224 threads 2 sockets Intel(R) Xeon(R) Platinum 8480CTDX (Sapphire Rapids) with 256G memory
parameters:

	nr_threads: 100%
	testtime: 60s
	test: sysinfo
	cpufreq_governor: performance


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260914/202609141037.779d7909-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-14/performance/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-spr-r02/sysinfo/stress-ng/60s

commit: 
  eb01ffabeb ("efi: apple-properties: validate setup data header length")
  b2326338dc ("efivarfs: Rate limit statfs() handler")

eb01ffabeb52251f b2326338dc683e8c1067c0cbf7a
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
      5824           +19.2%       6944        stress-ng.sysinfo.ops
     96.86           +19.5%     115.73        stress-ng.sysinfo.ops_per_sec
      3.00          +100.0%       6.00        stress-ng.time.percent_of_cpu_this_job_got


Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

