Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24D338F639
	for <linux-efi@vger.kernel.org>; Fri, 13 Mar 2026 10:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773396514; cv=fail; b=S/YVh6HELVNNOx3IeQg1k0JYuoMyxI+2sQ1qi9nW6d09g/acCmK3bV/mtk51Ju+FUDSKbZ/jAImw7QrYn+OD13nsHM4HL5L79Ve/2vpDOvvNPoSQNwcckC95XWTxfLbFv9IchqBvaN0FQSFSJG/AfSMXUNhW2yRo2hhSMAKIS90=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773396514; c=relaxed/simple;
	bh=rm1vXo7QDCwY7wkRPfUDzbxIDmSczDG/+J1rM0IVu8U=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=TsB5zOMTEEPG/UWCcwv5W0hTtUmp1sRiYQzeHrgiSwVMrCOVNWA2SncdrEGiKf8PlUCG35iLPMEdQclX+GsrdPED/p5YLz8wSh6YJxikrpmA0vJE6RsIJpk+BTebqfil8HBTXMMMox5GPLUCBhnx7GsZ6+cnGAM6lyF0iCG6GrQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mk5O7wLV; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mk5O7wLV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773396511; x=1804932511;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=rm1vXo7QDCwY7wkRPfUDzbxIDmSczDG/+J1rM0IVu8U=;
  b=mk5O7wLVGoB9+sSw7qOKxhAMEI14o7gOvUxxxuBGTnRttiTi2xeQ/8iI
   AtNHIS8rNmeTVpWfkwzYJRMjL4OnzR+d/9rJZY/Cv9yynA6G2agTmGDNp
   OSb5zIWBIuUmpOdA/t8wSQC5IneJQBMKB6azq1ncrw48HdwYmwv2+7hFu
   9ZWWLuk7wRz+zskjT2VWnyQfTzH0VX84yg8MA6LMtTj7JSbrw3rctj1wA
   J7xaqhonZd04oMXk8/JD8FlK3u2aB866t45JHD1RA5PIrpSsCTmh+Pjok
   6nrO8HAEJn3rPug2aDT7LHPl5PaqoywMScLoEwKjhsff3+Pg+l5XPbh24
   g==;
X-CSE-ConnectionGUID: EnBHg1TNRsGsO0jvdBKEjw==
X-CSE-MsgGUID: ycGPRXwmSmy8DOAov6vqKg==
X-IronPort-AV: E=McAfee;i="6800,10657,11727"; a="77109229"
X-IronPort-AV: E=Sophos;i="6.23,118,1770624000"; 
   d="scan'208";a="77109229"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2026 03:08:30 -0700
X-CSE-ConnectionGUID: S/hzqKwvTKGaA9jq82LWqA==
X-CSE-MsgGUID: +Q5ezAv4QKWJbnGFnTVIvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,118,1770624000"; 
   d="scan'208";a="217140705"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2026 03:08:30 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 13 Mar 2026 03:08:29 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 13 Mar 2026 03:08:29 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.46) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 13 Mar 2026 03:08:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AEdd4xjet/DTwK4WXMOwwwLIDaNdIaSHjba1EsafpH4s0SfIdyTRXsXsYp0wQwy4hGY5pESs5vkcRslyOF+cESKd3f1j8xc4vKGxwxz0lc/eLvmJGgwN6Nchzxj83uvvArhh9R3b0LZaf1ORRqg5qbiQ6m/Rx5F2FShh1tGxZ+cZNRDhWQDwqDZGTQnMOdBgVp9W/a+q6a/2dl6/Op17wD8fcc+CeHMAoigcft+dnQyxFUv0r0AU4ai8sAuHnNLR9Yxx5bqQ0CE71OIVKZv+UEt7m6SMKlYKrAv3bxCU26q5+4QpyqjcQL5wyjLEZGsQH5X0kZW9REHX67ImtPdv/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KpN0vMvWER5qSTzJrr6LjPXLqExYyuVKeAqd4KX0ui4=;
 b=HqB7jZASEsi0g3GsQ0FuYJmKfCvThwtXbS0STagXJlj/hQ0Ou6khD5PMHFgWg++F5m2Q84XIoOPax85OREqr8lTZXEQxv5+2vB30s+XEctLhmO09jVPF2ubz6cSliqhuLhRAbvY14j622SWMypYA8++gfAgXShI73mLXjJoYEywLNLaOzBgOHApXc6X3L+n8/lLKiXgJzl7ZT0gV1ffMyhOI9BqrTtZSCrMQ/lLd4kWY3HcvZmINqT6jZD5nDOP1eY7o2vlmE4/h7iajO0CUAiWkFyBi0SUw85X+GK+qpHvFtQ8+/+96UkJpLxcjZeL+nwwrffTBrjpGOTgkejnyWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by SJ2PR11MB8345.namprd11.prod.outlook.com (2603:10b6:a03:53c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.6; Fri, 13 Mar
 2026 10:08:25 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%3]) with mapi id 15.20.9723.004; Fri, 13 Mar 2026
 10:08:25 +0000
Date: Fri, 13 Mar 2026 18:08:18 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Ard Biesheuvel <ardb@kernel.org>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-efi@vger.kernel.org>,
	<oliver.sang@intel.com>
Subject: [ardb:x86-efi-memmap-cleanup-v2] [x86/efi]  28d319c685:
 RIP:__early_ioremap
Message-ID: <202603131715.3afc4841-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: SI2PR06CA0008.apcprd06.prod.outlook.com
 (2603:1096:4:186::23) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|SJ2PR11MB8345:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d1766d0-9573-4294-dad9-08de80e87724
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info: qe4iSFW+JWxMaDPqjEbkcsN5mww3+gq7g4c/PGIlq7WQlRTByR1V/VzvRjEJrvVdIRGIPpYBz2TdwcVIx9JQ/FWWphMhbJImmspVV6062mTuf2n6/plVlgzFiVzihRL7azVRFo59iPPqKqZF0eduaXAhV8XyOcMVmpWOICK95iAx76AMQB7CBipmQ7pKivwmoaENzJEn21Lv7EaO22jgbBMCJbkqfr8/ZTKztDzC0AuaZKSPCd2Ji2B1W0eBASrjiDckctfkkT0VHiRNfgHwBeuqzSil/dCJm5ZRbGRCApPgWgZgpadfskRNCgKGg4f1B15tztJwhvhS/GFqCHQQ8jk1EQ2nISJJhPil9Cm8WWDN9xZ7v9h3WD+TgpCEQHJnjrawgsVsy8aocZUIjhZuA16JW8iSzT1oFISUUTdLR4H8fV6JKP/4W2JcLs/YCj5xM0KYiR5Ydd/gbuSbYsjs9SLfkkWYwt4WGSpMCcyvt0p6fv37AggPAiJONvHsPA5zQort01fOfM4M+I6BhQQoWHli/UqeahfhACB4KCm0qummKe/+YTnwyajOdbl22DzS6qPgE9/1xDEkdcyobQCM+tVqXFnRfM9Dtt0K8Pkmd3zndTCG0Li87v4vQ1WWnNr2ue/TM82CbmIA+L/HhaFqNNDVa5QPPN5LAljwgPZR2xuFjGR+ZtihlIHvG/2+7xJ+gj8qsqEbneAy06n1BYiuww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?U48MtcXF+3YRri7XiOmcUnMRsCSLf4rVLzM5CvJlRUmAvBAzlthjzqx0QsRV?=
 =?us-ascii?Q?4fPrg2g5L1mJz3NcIBBFkYvv+m5V22zN467P41TMyKLIYD9w17HjS43BJTV0?=
 =?us-ascii?Q?vPi5dCaroFr37mz5SkIesJ04xtwJzhlouscqN2O4crUvIgQIub8K94Ufn6ew?=
 =?us-ascii?Q?GZGwTMKvhWmOY3+IZDcupvNAqi9fo+IwP/wgFI3leDq1GwODwUNfg0Ff8ZCU?=
 =?us-ascii?Q?0b2CQ2vBifbUyRNyiydpsou+i8sHMIrypIqqqYiiKm7NDHsmRCenKxWSuj4A?=
 =?us-ascii?Q?3mODRLoYoCZmBcJCoRGL+R4K8KczNiMkmHlD9ynmEyDgpmMC91od8aCK4s9Y?=
 =?us-ascii?Q?KAj0lnpfK/+DcM29NaM2vMwD0po08OvIDnxaeKTdFGBWBcf24Bk3moUCFGdF?=
 =?us-ascii?Q?JMnb3vjkTo2y8JHV+8cn5QLt6JVsM1qQ2tTQHU8tIJQ9jnjVkdz41CTMoDzc?=
 =?us-ascii?Q?R5NeS6/ydTIaC6JpR7Kl/j9E9BvP+jC+eGu7HRPXGoq1gyGkFUiL43W7p2aT?=
 =?us-ascii?Q?Hnbn7z5xxMpNp3jzBNKSYzqERVHCvpM/R4+EaVs3KraUI8ssHX0kTt2wSD9q?=
 =?us-ascii?Q?+e2QugeRFpqh0XIPMWCWRD5oMP9Qxhs3hGVs20hHGHEvm0TfsHXJCmeuSxC2?=
 =?us-ascii?Q?h+wDtOk8SkUISwBK9JlisQo7mgc/73MGNGURQEH+s0R5YPZQe6JK+WH8Le+r?=
 =?us-ascii?Q?gU2A478oJNwz3XgYyBv5jBf97cNzkiXcIBdmKP8TSMDa792oEZGgTQ2aDqNB?=
 =?us-ascii?Q?hPDxXLayAIAVbeBBfQhSUFo5dk6RRZOhEJx5QNxFy76br14ep9WAQS/yfZm3?=
 =?us-ascii?Q?XjwNyUQWY4clnhkuHSMCL0Ps8v1B5KbDDJb2W6xiefYx1HEcxBtH41LIL0P/?=
 =?us-ascii?Q?3KCjG7h9jiHCQ7pPrLnyVrP9R+hVjRiqbd8IA/1R+aMkfLqIrx0wl5ue+fX2?=
 =?us-ascii?Q?74mqXfZ/ds/E4oGjZ7Pl1tNvfdYpoa46hkdtdYjkLLOmlhR+0eal5iJqFpFt?=
 =?us-ascii?Q?o4/z0010Z/UsxgEKTHQxz6NFYoMxwWthGc0LX7ZANLdhaccS6VztQ81HI2u2?=
 =?us-ascii?Q?glxwQYBWNnhdtjAlYbStSuHhQb46DI5lgcgEZ6UuMOLoaZspPRbc6ggGm8qX?=
 =?us-ascii?Q?usZfx+Q8+YHDihfQUd/CdINoXersxaCoVcAHVr7ybqsGdovUTDEm4pcPugky?=
 =?us-ascii?Q?sWlKxBBWK9S3ifNdJd6+vMcg1RtDBnCwYM/ClPhw2I5ZJU66mquXlw5bHFvR?=
 =?us-ascii?Q?aqmHyPQsBlkPcvKIMB5Le50bzG5BpRdXeP1tmAmlGFSW7v6udXWMNnL43ChD?=
 =?us-ascii?Q?PMnEdqcyptx0ULH79D09d0hh3xk02mTl8av/cWC5yfjMCREOS/Y/NIpyRIXV?=
 =?us-ascii?Q?LeiD155gZ+3dmltDA0XXITE8OKD49PV/UXghN64/W+xA2lius1vtxw7LCROL?=
 =?us-ascii?Q?6HtCQ00NB3C8olbAue8BGcpltu6pCyML9THPsZ0lQcMDvgbpPjyrMAR5WM3C?=
 =?us-ascii?Q?d1p+lj3JdIgd+nvwYuUPbzg8g7597mj+juNMn69KCKAyf8acKordXo3DPwwT?=
 =?us-ascii?Q?7hT2HD6lHpcSv7h+y194ptCwBHb3gs2kR7BI0d8zuH9cpa7jIoEgUw9bt8GM?=
 =?us-ascii?Q?hF/y5VhmO+SptHveplXdm9IhIIXV1f3FK4mUu5Sb/QqWGeq1qh57FKSUhlYs?=
 =?us-ascii?Q?nvlok980py7JZOWC5sT+n4wLZnkmqLKR6E/5rfJLz/azIh8m8qWPX+Kxqw1k?=
 =?us-ascii?Q?qztU+yitQA=3D=3D?=
X-Exchange-RoutingPolicyChecked: Cloh6beuG4GGCuno8cwaAi+6JkvRHGSABYSkNFMPEWM/Cau8uB34/CzFdHjNhOC2HtzXckHQgBZqmQPWPNlK6tlKAPR5yNrfaUvwtNcF/EpoZXyYvFEe5k6EcuIHXrGgafCks49GWT8DrkLJG9vX4i+DXTK8WimFCnX0CE2ol/Xtvbaqqud9Mhp61sHXAyT/mhznOTczjJe0z6goKQohoyBrxkVbj246FBMUaW1lICYR+IUJL8XjnVD8QcfOuf6JX5rM3BWGzEG5EGpxvrFIIMU4OvoT/v8wvTiCDEhqfq9fbY5GGZp0ZL10VOvsk500JD6U72xr3EK77L07vm5GjQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d1766d0-9573-4294-dad9-08de80e87724
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2026 10:08:25.3823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O+jgtEajIrRzVacbvAs1avxHW8DN1L7vKxmm3hnfHWCOVDxbJ4JQmop6KCjPqIDBYzGKxz01qDfKgwnMwnzyWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8345
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "RIP:__early_ioremap" on:

commit: 28d319c685b0da78b1823135b60a110d9882259c ("x86/efi: Defer compaction of the EFI memory map")
https://git.kernel.org/cgit/linux/kernel/git/ardb/linux.git x86-efi-memmap-cleanup-v2

in testcase: perf-sanity-tests
version: 
with following parameters:

	perf_compiler: clang
	group: group-01


config: x86_64-rhel-9.4-bpf
compiler: gcc-14
test machine: 16 threads 1 sockets Intel(R) Xeon(R) E-2278G CPU @ 3.40GHz (Coffee Lake-E) with 32G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202603131715.3afc4841-lkp@intel.com



[    3.399684][    T1] Simple Boot Flag at 0x47 set to 0x1
[    3.404933][    T1] ------------[ cut here ]------------
[    3.410746][    T1] WARNING: mm/early_ioremap.c:132 at __early_ioremap+0xd8/0x260, CPU#7: swapper/0/1
[    3.419788][    T1] Modules linked in:
[    3.424741][    T1] CPU: 7 UID: 0 PID: 1 Comm: swapper/0 Tainted: G S                  7.0.0-rc3-00009-g28d319c685b0 #1 PREEMPT(full)
[    3.436798][    T1] Tainted: [S]=CPU_OUT_OF_SPEC
[    3.441739][    T1] Hardware name: Intel Corporation Mehlow UP Server Platform/Moss Beach Server, BIOS CNLSE2R1.R00.X188.B13.1903250419 03/25/2019
[    3.454808][    T1] RIP: 0010:__early_ioremap (mm/early_ioremap.c:132 (discriminator 7))
[    3.460746][    T1] Code: 60 04 24 83 48 8d 54 24 30 48 89 e9 67 48 0f b9 3a 31 ed e9 3d 01 00 00 4c 8b 7c 24 30 49 8d 0c 2f 48 8d 41 ff 4c 39 f8 73 04 <0f> 0b eb e3 48 85 ed 74 f7 4c 63 e3 48 89 4c 24 08 4a 8d 04 e5 00
All code
========
   0:	60                   	(bad)
   1:	04 24                	add    $0x24,%al
   3:	83 48 8d 54          	orl    $0x54,-0x73(%rax)
   7:	24 30                	and    $0x30,%al
   9:	48 89 e9             	mov    %rbp,%rcx
   c:	67 48 0f b9 3a       	ud1    (%edx),%rdi
  11:	31 ed                	xor    %ebp,%ebp
  13:	e9 3d 01 00 00       	jmp    0x155
  18:	4c 8b 7c 24 30       	mov    0x30(%rsp),%r15
  1d:	49 8d 0c 2f          	lea    (%r15,%rbp,1),%rcx
  21:	48 8d 41 ff          	lea    -0x1(%rcx),%rax
  25:	4c 39 f8             	cmp    %r15,%rax
  28:	73 04                	jae    0x2e
  2a:*	0f 0b                	ud2		<-- trapping instruction
  2c:	eb e3                	jmp    0x11
  2e:	48 85 ed             	test   %rbp,%rbp
  31:	74 f7                	je     0x2a
  33:	4c 63 e3             	movslq %ebx,%r12
  36:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  3b:	4a                   	rex.WX
  3c:	8d                   	.byte 0x8d
  3d:	04 e5                	add    $0xe5,%al
	...

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2
   2:	eb e3                	jmp    0xffffffffffffffe7
   4:	48 85 ed             	test   %rbp,%rbp
   7:	74 f7                	je     0x0
   9:	4c 63 e3             	movslq %ebx,%r12
   c:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  11:	4a                   	rex.WX
  12:	8d                   	.byte 0x8d
  13:	04 e5                	add    $0xe5,%al
	...
[    3.480858][    T1] RSP: 0000:ffff888100c7fa80 EFLAGS: 00010246
[    3.486746][    T1] RAX: ffffffffffffffff RBX: 0000000000000000 RCX: 0000000000000000
[    3.494781][    T1] RDX: dffffc0000000000 RSI: ffffffff863e4366 RDI: ffffffff86581f80
[    3.503469][    T1] RBP: 0000000000000000 R08: 0000000000000000 R09: fffffbfff0b546ca
[    3.511781][    T1] R10: ffffffff85aa3657 R11: 00000000846ccb1e R12: ffffffff86581f80
[    3.519796][    T1] R13: 1ffff1102018ff52 R14: 8000000000000163 R15: 0000000000000000
[    3.529469][    T1] FS:  0000000000000000(0000) GS:ffff8887ffebe000(0000) knlGS:0000000000000000
[    3.538784][    T1] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    3.545468][    T1] CR2: 0000000000000000 CR3: 0000000878672001 CR4: 00000000003706f0
[    3.553780][    T1] Call Trace:
[    3.556733][    T1]  <TASK>
[    3.559737][    T1]  ? __pfx___early_ioremap (mm/early_ioremap.c:109)
[    3.565749][    T1]  __efi_memmap_init (drivers/firmware/efi/memmap.c:43)
[    3.570743][    T1]  ? __pfx___efi_memmap_init (drivers/firmware/efi/memmap.c:34)
[    3.576469][    T1]  ? rcu_is_watching (arch/x86/include/asm/atomic.h:23 include/linux/atomic/atomic-arch-fallback.h:457 include/linux/context_tracking.h:128 kernel/rcu/tree.c:752)
[    3.580738][    T1]  ? trace_preempt_on (include/trace/events/preemptirq.h:53 (discriminator 2) kernel/trace/trace_preemptirq.c:120 (discriminator 2))
[    3.585750][    T1]  ? __pfx_efi_free_boot_services (arch/x86/platform/efi/quirks.c:433)
[    3.592469][    T1]  efi_free_boot_services (arch/x86/platform/efi/quirks.c:479 (discriminator 1))
[    3.597744][    T1]  ? __pfx_add_device_randomness (drivers/char/random.c:933)
[    3.603746][    T1]  ? __pfx_efi_free_boot_services (arch/x86/platform/efi/quirks.c:433)
[    3.609748][    T1]  do_one_initcall (init/main.c:1382)
[    3.614741][    T1]  ? __pfx_do_one_initcall (init/main.c:1373)
[    3.619742][    T1]  ? parse_one (kernel/params.c:139 (discriminator 10))
[    3.624740][    T1]  ? kasan_save_track (mm/kasan/common.c:70 (discriminator 1) mm/kasan/common.c:79 (discriminator 1))
[    3.629741][    T1]  ? rcu_is_watching (arch/x86/include/asm/atomic.h:23 include/linux/atomic/atomic-arch-fallback.h:457 include/linux/context_tracking.h:128 kernel/rcu/tree.c:752)
[    3.634743][    T1]  ? __kmalloc_noprof (include/trace/events/kmem.h:57 (discriminator 2) mm/slub.c:5264 (discriminator 2) mm/slub.c:5275 (discriminator 2))
[    3.639741][    T1]  ? do_initcalls (init/main.c:1454)
[    3.644742][    T1]  ? rcu_is_watching (arch/x86/include/asm/atomic.h:23 include/linux/atomic/atomic-arch-fallback.h:457 include/linux/context_tracking.h:128 kernel/rcu/tree.c:752)
[    3.649755][    T1]  do_initcalls (init/main.c:1443 (discriminator 3) init/main.c:1460 (discriminator 3))
[    3.653740][    T1]  kernel_init_freeable (init/main.c:1696)
[    3.659742][    T1]  ? __pfx_kernel_init_freeable (init/main.c:1664)
[    3.665746][    T1]  ? _raw_spin_unlock_irq (include/linux/spinlock_api_smp.h:188 (discriminator 3) kernel/locking/spinlock.c:202 (discriminator 3))
[    3.670748][    T1]  ? ret_from_fork (arch/x86/kernel/process.c:157 (discriminator 1))
[    3.675741][    T1]  ? rcu_is_watching (arch/x86/include/asm/atomic.h:23 include/linux/atomic/atomic-arch-fallback.h:457 include/linux/context_tracking.h:128 kernel/rcu/tree.c:752)
[    3.680741][    T1]  ? trace_preempt_on (include/trace/events/preemptirq.h:53 (discriminator 2) kernel/trace/trace_preemptirq.c:120 (discriminator 2))
[    3.685744][    T1]  ? __pfx_kernel_init (init/main.c:1574)
[    3.690743][    T1]  kernel_init (init/main.c:1584)
[    3.695738][    T1]  ? __pfx_kernel_init (init/main.c:1574)
[    3.700742][    T1]  ret_from_fork (arch/x86/kernel/process.c:164)
[    3.705469][    T1]  ? __pfx_ret_from_fork (arch/x86/kernel/process.c:153)
[    3.710747][    T1]  ? __switch_to (include/linux/thread_info.h:142 (discriminator 2) arch/x86/kernel/process.h:17 (discriminator 2) arch/x86/kernel/process_64.c:676 (discriminator 2))
[    3.715754][    T1]  ? __pfx_kernel_init (init/main.c:1574)
[    3.720744][    T1]  ret_from_fork_asm (arch/x86/entry/entry_64.S:255)
[    3.725750][    T1]  </TASK>
[    3.728732][    T1] irq event stamp: 21465
[    3.732739][    T1] hardirqs last  enabled at (21477): __up_console_sem (arch/x86/include/asm/irqflags.h:42 arch/x86/include/asm/irqflags.h:119 arch/x86/include/asm/irqflags.h:159 kernel/printk/printk.c:347)
[    3.742785][    T1] hardirqs last disabled at (21488): __up_console_sem (kernel/printk/printk.c:345 (discriminator 3))
[    3.752468][    T1] softirqs last  enabled at (21424): handle_softirqs (kernel/softirq.c:469 (discriminator 2) kernel/softirq.c:650 (discriminator 2))
[    3.761787][    T1] softirqs last disabled at (21419): __irq_exit_rcu (kernel/softirq.c:657 kernel/softirq.c:496 kernel/softirq.c:723)
[    3.771784][    T1] ---[ end trace 0000000000000000 ]---


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260313/202603131715.3afc4841-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

