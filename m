Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3222261B8D
	for <linux-efi@vger.kernel.org>; Thu, 27 Aug 2026 01:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787793318; cv=none; b=MLZVs2qvHg8y2ds32fF6Dmb5FrnvsjeOvg4UeI5DxQquRdbYrY7b9WaebBsWsJjVDmBSPoJ1TG0kXjpJIXKC2q6Asjy8dqjMXpLYkXHNA9e9PzY+EF/setYsSqLfIVFgW4GGuBJAQ1fXEpGW11gcOKuecoTtD4rUzBx2iOvPpHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787793318; c=relaxed/simple;
	bh=YpygBDzERm5er5rhJaN8G01AxohG9gaiN7EZ7yRhYYk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ii0RrdqkrvTHVZwz4waALVzYn02oUgE/M1LDsMjEjEflpfGhRS4N9YRGeTYzvkS46OYi00Jt1HFEbu/+rPgafGoe9tiUKXfriIV/nbTf+bRyB1DtgJEC3P9Hgsf/Bz82n05LDEvIKCX91xO7Q7fj/zbL9G7eUqhzn6UNVCWgnrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GBVZtYw5; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GBVZtYw5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787793317; x=1819329317;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=YpygBDzERm5er5rhJaN8G01AxohG9gaiN7EZ7yRhYYk=;
  b=GBVZtYw5bwsQqPLLO9hX6SMEeeeuVTVu4Ow6xMIgyxBCwGUZCEUyguKJ
   UBeZ+Yilg/lyPKatvNXKs1KypoBZiqW0DA0Yn/arC7I01eWiefSbENx5z
   cEG98JPEDlI5zIikKlUHU0onzqqMCuxhLVvJlDsxK8iL0cDuHggBS1zho
   0hw5rHGR1xDBeUJ+TtjmrKnD5CUr2wT/C7H6EVpDODWZ37lPSkxgg0Fbe
   SSE8q6PJOG0GBVZxGNSN0TBimxHJw9eJ26YuPPjKHtRlfB6gzT+X7xZ25
   qzM2/l1/Xg6R24TUZEVqkuQV8fjsbJ+mmfw0t38WH6imQmwjGhVX/6qKH
   Q==;
X-CSE-ConnectionGUID: +9Qdw8DERuCOcRdXVTFctA==
X-CSE-MsgGUID: ZQhcOckMQOm4l6ra+zdsOQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11887"; a="75829061"
X-IronPort-AV: E=Sophos;i="6.25,245,1779174000"; 
   d="scan'208";a="75829061"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2026 18:15:16 -0700
X-CSE-ConnectionGUID: dIvPERJIQWCDJ6cZfza5hg==
X-CSE-MsgGUID: jov9iflmTgmF9carM5clGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,245,1779174000"; 
   d="scan'208";a="261587091"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.182.64])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2026 18:15:15 -0700
Date: Thu, 27 Aug 2026 09:15:11 +0800
From: kernel test rebot <yi1.lai@intel.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com,
	Ravi Bangoria <ravi.bangoria@amd.com>, linux-efi@vger.kernel.org,
	yi1.lai@intel.com
Subject: [ardb:efi-arm-memmap-dtprop] [efivarfs]  eaa4abe54e:
 stress-ng.get.ops_per_sec 2915.8% improvement
Message-ID: <202608270836.4a9957c0-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit



Hello,

kernel test robot noticed a 2915.8% improvement of stress-ng.get.ops_per_sec on:


commit: eaa4abe54eb5de1ee002aa2e4f88fc49156f2fdb ("efivarfs: Cache occupied and available space") https://git.kernel.org/cgit/linux/kernel/git/ardb/linux.git efi-arm-memmap-dtprop

testcase: stress-ng
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 256 threads 2 sockets Intel(R) Xeon(R) 6768P  CPU @ 2.4GHz (Granite Rapids) with 64G memory
parameters:

	nr_threads: 100%
	testtime: 60s
	test: get
	cpufreq_governor: performance


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260827/202608270836.4a9957c0-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-14/performance/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-gnr-2sp4/get/stress-ng/60s

commit: 
  44e4ec1a80 ("efi: apple-properties: validate setup data header length")
  eaa4abe54e ("efivarfs: Cache occupied and available space")

44e4ec1a802d2078 eaa4abe54eb5de1ee002aa2e4f8
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
  15418287         +2912.1%  4.644e+08        stress-ng.get.ops
    256967         +2915.8%    7749645        stress-ng.get.ops_per_sec
    554.00 ±  4%  +11739.5%      65591        stress-ng.time.involuntary_context_switches
     69114 ± 17%     -52.8%      32593 ±  2%  stress-ng.time.minor_page_faults
    209.30        +12040.1%      25409        stress-ng.time.percent_of_cpu_this_job_got
    120.05        +12557.5%      15195        stress-ng.time.system_time
      6.51         +1095.1%      77.76        stress-ng.time.user_time
     97296           -41.8%      56610 ± 14%  stress-ng.time.voluntary_context_switches


Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


