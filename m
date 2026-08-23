Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7301E1024
	for <linux-efi@vger.kernel.org>; Sun, 23 Aug 2026 13:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787490785; cv=fail; b=DdtiD5+tm0flT27jy8LrwDBVLW+lybS7d3RG4hVd1LueQC0leMEuG+voVKdoQlEIBndl2eTrJn3e1mm6HtwQ7TG4vF1xeMUrytIjyl6jFOjRQXye0v9iknW1YUsumqRf+vdlmmhfM3Qoz7Y3f8DxYHvC2eGeP/ED69xlHsl6nu4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787490785; c=relaxed/simple;
	bh=6foD5CmZee4/FHsdDRDSvfDsJnrKlXAPPnNUgePtM5I=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=YrQn4vO5S/lHwQtLIeRJQvCQUmKRIhZRBpIimuP+7m2MEt8QEo7H6Ps6CScFsHhKzWDDjv8tzds42c8PAkH+oiWcbddWgDlQ+uf3W1EsAebnY2EMMC+Y8/FKtiqnvBO74LjdLmlCePKDfClaacSoCxGF+mfO9Qua8Lm8Un8aj3M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l/js2aOZ; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l/js2aOZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787490783; x=1819026783;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=6foD5CmZee4/FHsdDRDSvfDsJnrKlXAPPnNUgePtM5I=;
  b=l/js2aOZgBWoUWVyuAciFtynRnsN/rCc6SGeGUVOj+m61VqxLkhTupe1
   xYbMcXFMgbLfefP1j/2EcxaRYuL9alGQkegeXCrINpncOl+xZEyF0+oJi
   vhPlspUGia0Cksj0QwVqAq/IMX0FXdQ7LfraN5ivkLbXRtp46euvXoZGQ
   4YGk/m6hOOILyXBE4ZQxCSVLBvE4ZoJjJ2wCCSa96tYUdigtggYZCN7OL
   finRkvmd3xHw7Cb7o8cURKB8tFGJ7w33RGPvn/Jt228WSR6FKZEo8dTjw
   qiKBH8azLgU4eVr5Sq9MT8QrScVxOeyWdrfmDDR9IkGnnYIB++LN4PB/M
   g==;
X-CSE-ConnectionGUID: JoqY25nOSWW7JLWsBxQ5TQ==
X-CSE-MsgGUID: UKeYLBdcRrqeXsKpsTj0Zw==
X-IronPort-AV: E=McAfee;i="6800,10657,11883"; a="98297367"
X-IronPort-AV: E=Sophos;i="6.25,238,1779174000"; 
   d="scan'208";a="98297367"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2026 06:13:02 -0700
X-CSE-ConnectionGUID: iXwyksklSC686fszRyRLrQ==
X-CSE-MsgGUID: mBNheLzWQ/qow+Z2G/FvhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,238,1779174000"; 
   d="scan'208";a="265468311"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2026 06:13:03 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sun, 23 Aug 2026 06:13:02 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Sun, 23 Aug 2026 06:13:02 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.25) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sun, 23 Aug 2026 06:13:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y+St7gc1Qw6x/JPHkih12pMxUI/lD9UPo70/3TrdONbVG9KzW1F6Y+Md/K/NDG+GdqlJ5HFnGRcbCfbc0xYrm773IqigvlnC7VPL+YU42a95rUSmjRzL2ljtflMVnfrp9nQmHMQW556sS+4115brMt2oh4j2voeZOX7oyTtcQv7qpCQxbMNLiYG1vmAKSYX4HIRZCTYCiFyzahemPcmTv4vaFIDVn25zLrVzW6DIOO+uTPsvfPs95CKOqlOhz5IcsCa6ltK9v/aCJeeV/IFi1tUINGGOeXjA0B4r+obv1k9Dd1IPFrmy280UCIpPcDu/fgeJTEFLna+Cc56IiNWjGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A9H12mWYfaqFnrv9ylDv2gggvx4UWinM7/ZV5XLT5AI=;
 b=rAhQh6ONyEub/ET1d/4qAuCBIgJuIxJHfYq493axqDikcLSBtbqs3xRUOYjrRwwm7Z7joW8pCJqKiUefRuQ8aofZK01p6YS4MvFeRMUPyaweFvv8hMFR/bezhjewMooglGXjY+kUeyBHN2xwSMCvCADN6j/OsV0l0UWVLI/Lnd35w1IadHBJlJUrud9uJqAv9eaZApZ7BRiYYcPDO+hpuH1frUKbbPDXaZ1V0uwYve9iJlPwnzZHajE/bBdi407UtrqJax0hZX/UAewz3VLORLt1eSXXF4lS56SXBEsY3oHHl6Sd+PVPgBzDU1o7M2pJa/o9xfwFkId8hC/QkQqujQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ0PR11MB5214.namprd11.prod.outlook.com (2603:10b6:a03:2df::22)
 by MN6PR11MB8148.namprd11.prod.outlook.com (2603:10b6:208:472::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Sun, 23 Aug
 2026 13:12:53 +0000
Received: from SJ0PR11MB5214.namprd11.prod.outlook.com
 ([fe80::5926:3836:4212:8640]) by SJ0PR11MB5214.namprd11.prod.outlook.com
 ([fe80::5926:3836:4212:8640%4]) with mapi id 15.21.0339.012; Sun, 23 Aug 2026
 13:12:53 +0000
Date: Sun, 23 Aug 2026 21:12:43 +0800
From: kernel test robot <lkp@intel.com>
To: Ard Biesheuvel <ardb@kernel.org>
CC: <linux-efi@vger.kernel.org>
Subject: [efi:next] BUILD SUCCESS b2326338dc683e8c1067c0cbf7a47986c4190902
Message-ID: <202608221738.iZqPW2iS-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SI2PR02CA0033.apcprd02.prod.outlook.com
 (2603:1096:4:195::20) To SJ0PR11MB5214.namprd11.prod.outlook.com
 (2603:10b6:a03:2df::22)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR11MB5214:EE_|MN6PR11MB8148:EE_
X-MS-Office365-Filtering-Correlation-Id: 31e8c202-fe5d-4db3-bfff-08df01183d30
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|11063799006|10067099003|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info: Yo+EO9ltOO097a8ExdjefkR//1yWMerK0mjGz7s4+r8gAo0pPNJ/qmH7sHHNkf47KYqPjPHt72o2zQLheLTa0GOuPm1tLgN20eyyQQsWaqUg8DQZShc4KZtkOFuVbk8TaT6hbuM/wX9XLUupic4jkZWgGhAWK4/2E12UQi7/i9FiDTmnxw/7Mqk5BAf+MaZBRccTu1trTlp1++OCV88JwPEAEFQhg8Tcmytsfig2b8OEGr/V5wRdIUEmzve26OKGde4xzbTfQgyWuHEkFjtlnoWODX+Wr8RR7kghTgIG5yYCbq5UoSQBaLD7WoPiPJdQRjYX2VHYJzQx5nxICIeddndTFZNDx4WP3mA8b87dnBvpuNKrDGbOFAUYs3Lt0K7e17/aLIXWx5Eswcen6tcmm9UX5DsIbmSRbVFTxr30H4hjfGEx/mzwCuVpYfUJ2e20qwDgfu2Gktqdd2xs0TRIFlTQKw6JbcTq9D4Xc6N02A0o/0byW8rPMiKX36uXfkqWGZGpiVIKZJln0Jm+QiGlHKX9sTjs52UnCTzbrtwLpH6gBSWa8GK5DSQc9LYgOzp73N8XGFSLsFxV9q8pttoeR4JMfAjOFjBuqEVmk8FHu2SpNntzpuQMfLGtqZKDS6QU9SGCFTLA+/Via+VRjYuxhCXkACr3bdNRCWzo1ypYfGE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5214.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(11063799006)(10067099003)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9mruqjit9c1UMiWVRWUYWUyLdB4HhQSn93M89gBesq0fcWZ+4QWevCEh0awm?=
 =?us-ascii?Q?iwvSTYrocA3SRA7FNwD1NmZNT0OlIBrkq1qvTiobgI6JFz2iOxdL/H2BswSW?=
 =?us-ascii?Q?oukZvQtP8ZoV6ws0SfY/367QWeCScy9R05ZKWCaBLhmYu5Ca5Azfu+bv7CB5?=
 =?us-ascii?Q?jw/61r00ICKCWy5izbiR2ncfGBlN2G30XykwBHxMthgQAxhQVyulc+fq38AM?=
 =?us-ascii?Q?cAxShByInFfHF4IxziCZ+mUWOfAISFd2JWTxzT2ZAVHRXbzglRlOWbJs2Hzc?=
 =?us-ascii?Q?4BPnNf1VrCIw9rDA4JCS09QPW+AzjzTrPLxRt1lZAPRKJ1EqbBAzsSeBtZEZ?=
 =?us-ascii?Q?r0RR9RWIAzxxY1q9dP+YIdov0I2vrKMe4GiNORfa2X5M2aOatcXIZpq0QY3b?=
 =?us-ascii?Q?zc3VMbVZ0ds3nsC18S/lFlB2mwH365kLTRHIxtPVdx16DP3lEruje4hU4cZ0?=
 =?us-ascii?Q?BdkfId2zXAChyphBiWhQ+yRM8YhcmgwZ2J1ycFaIKMw4eZEXGWCjat5mV+m0?=
 =?us-ascii?Q?eyDC85eHC2+4Ydt1mT/tmJdI/qg1G5bJMiFjW67T+yFkgKekxQaydDl6Ic7m?=
 =?us-ascii?Q?Yc0lq/GDNHgEKnD0TkHPxuxnjbqy3I1c0Lo+iR6pCS0RJPtJRL4VL3IEBzSm?=
 =?us-ascii?Q?WF4yqPRB8BLZbVfXA75VRxmW6l7UiRf3JP2Bmg9AKAgBdacQAG4Hp0erqSJe?=
 =?us-ascii?Q?t3zsNUJ2anARR9zfzaVk9bSJCNNiTSlL0ewgHZ9PYXXAgl+/hicUcyyp1dGJ?=
 =?us-ascii?Q?Cdx4sKGIW7XitY73UpiMBxU8Ao1wAWs5vfTPpm1xjIxDxpu8JMmEXJG08myy?=
 =?us-ascii?Q?3TWLLfYb2RimIASlHycggYydLcP8bPAPUOwfuaJdXuhe+KVa+/ShC1iX7cFS?=
 =?us-ascii?Q?JK2Kp85lud0lDs5SP7twwhboE98anH9STO1YYFuWGsQK5IbqAZ02rGzvA03j?=
 =?us-ascii?Q?u82gO/iHhFfyZNXQpQr+ceugVzWUnU24R53sQnapSu2iugUgtnxjEb1qK5Ri?=
 =?us-ascii?Q?HbWVwEIp/HsSDAs5RvNuhGrDxBsrko5tbDNgW3TYaZxhoGL7Y+Nqi+8i4z6Y?=
 =?us-ascii?Q?P0UmsYVxA6VXbhgJiNirzeOPxMaPcik6eBxL+3ny5mWeL2aPvXcXVb3lhUjG?=
 =?us-ascii?Q?/5ez5YO/lmDSMcvxz5gLmmHp0vfgZCjBEvf5vzBrO3pwakydU5/u8RM2F2Tr?=
 =?us-ascii?Q?wgDQxY/xA3gEmo8Nci5m5szoBCDxnnJDmqkzOb5WyIVZs2I+/+xPPPmSmysF?=
 =?us-ascii?Q?N/EIsgkWXlR/0AtDHskufmGPRUpiWA82MfGZA+R6s6s2ZgEU6p266bkqtA+d?=
 =?us-ascii?Q?m/xYqrgBYIr6AWtpjmtF3XLUS1+iFcpV1Ti0C+zXH+T8JX+gXpD4hLD+b9Hn?=
 =?us-ascii?Q?vnjwriN604VFwk36+VAF8thJQeyKXC5+5WfROPJXFZw1hPJJzLW7k6GtikU1?=
 =?us-ascii?Q?obq7vBR+ww6k0jFm5Os8+cZP9qkqRj0Ob4+KPCd2yDDKM5d604DNxl7zZ9j7?=
 =?us-ascii?Q?nrCe4PfFUYkFs4zEuatQrdpC0fbCwa0oeKvPJLg/nnK12YHE0S+hsoKM3uux?=
 =?us-ascii?Q?kVT6W80zJtWwbaRsUNcLevDHAVIwYGVumLIr8hcAdZQlqQbrppRa18InnOf6?=
 =?us-ascii?Q?ir0F6iVwHKQ5k6srAOYaxGa89aOzue+2Le8/uaDO0+sU/oYISlHRvzJiyeEj?=
 =?us-ascii?Q?5uYsR7+VETHQZj0F1qwVfUtQJQwy6XSS4YqbWuBy8AdNCAJXd9uB9n9rTJ6g?=
 =?us-ascii?Q?nOpUyd+CUA=3D=3D?=
X-Exchange-RoutingPolicyChecked: 4Ws4VYAXp5PnSj7FO6IWMPhVl1vWGiTBl9pAegEhlwUyx+ltsRm1MN6MSXLHBP6f0QyanmcibVpLDquIAM+OMY3q7Y4h07hbx7UXGp7Ep39SEbv6QW3BbWWxfqdcpCj0W2QzhWnimVUw8yaCZagueyd285k/7Jmo8+DbF869vujyyfuxZCYVIJz+aevAw3kLOgSRKXT5XQCwsksqqy5zxCdZ1wU8zW1vMVL39P8jZHamajkEq3E0HTaJRhoxsMmEXAaYdNkgbqiIJ4e0rPBXSG5O0LKeT9wUAvVidKaRIwAx6PQRcuzUK9c9gfhIMAhM/oMp2k33Xhcg+Z33NuvvBw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 31e8c202-fe5d-4db3-bfff-08df01183d30
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5214.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2026 13:12:52.9554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Is7GiFkYvL7NDdKG4HSRuNj/FofbQnLyy6d7RjrxnVgUk7GHJjJQyivEukmnIyredIq2uq6LCcZ1MY9JNqkgyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8148
X-OriginatorOrg: intel.com

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git next
branch HEAD: b2326338dc683e8c1067c0cbf7a47986c4190902  efivarfs: Rate limit statfs() handler

elapsed time: 1461m

configs tested: 135
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                  randconfig-001-20260822    gcc-10.5.0
arc                  randconfig-002-20260822    gcc-10.5.0
arm                  randconfig-001-20260822    gcc-10.5.0
arm                  randconfig-002-20260822    gcc-10.5.0
arm                  randconfig-003-20260822    gcc-10.5.0
arm                  randconfig-004-20260822    gcc-10.5.0
arm                        vf610m4_defconfig    gcc-16.1.0
arm64                         randconfig-001    gcc-14.3.0
arm64                randconfig-001-20260822    clang-24
arm64                randconfig-001-20260822    gcc-14.3.0
arm64                randconfig-002-20260822    clang-24
arm64                randconfig-002-20260822    gcc-14.3.0
arm64                randconfig-003-20260822    clang-24
arm64                randconfig-003-20260822    gcc-14.3.0
arm64                randconfig-004-20260822    clang-24
arm64                randconfig-004-20260822    gcc-14.3.0
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260822    clang-24
csky                 randconfig-001-20260822    gcc-14.3.0
csky                 randconfig-002-20260822    clang-24
csky                 randconfig-002-20260822    gcc-14.3.0
hexagon                       randconfig-001    gcc-16.1.0
hexagon              randconfig-001-20260821    clang-24
hexagon              randconfig-001-20260822    gcc-16.1.0
hexagon              randconfig-002-20260821    clang-17
hexagon              randconfig-002-20260822    gcc-16.1.0
i386                            allmodconfig    gcc-14
i386                buildonly-randconfig-001    clang-22
i386       buildonly-randconfig-001-20260822    clang-22
i386       buildonly-randconfig-002-20260822    clang-22
i386       buildonly-randconfig-003-20260822    clang-22
i386       buildonly-randconfig-004-20260822    clang-22
i386       buildonly-randconfig-005-20260822    clang-22
i386       buildonly-randconfig-006-20260822    clang-22
i386                 randconfig-001-20260822    clang-22
i386                 randconfig-002-20260822    clang-22
i386                 randconfig-003-20260822    clang-22
i386                 randconfig-004-20260822    clang-22
i386                 randconfig-005-20260822    clang-22
i386                 randconfig-006-20260822    clang-22
i386                 randconfig-007-20260822    clang-22
i386                 randconfig-011-20260822    gcc-14
i386                 randconfig-012-20260822    gcc-14
i386                 randconfig-013-20260822    gcc-14
i386                 randconfig-014-20260822    gcc-14
i386                 randconfig-015-20260822    gcc-14
i386                 randconfig-016-20260822    gcc-14
i386                 randconfig-017-20260822    gcc-14
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260821    gcc-16.1.0
loongarch            randconfig-001-20260822    gcc-16.1.0
loongarch            randconfig-002-20260821    clang-24
loongarch            randconfig-002-20260822    gcc-16.1.0
mips                     bmips_stb_defconfig    clang-17
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260821    gcc-8.5.0
nios2                randconfig-001-20260822    gcc-16.1.0
nios2                randconfig-002-20260821    gcc-11.5.0
nios2                randconfig-002-20260822    gcc-16.1.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc               randconfig-001-20260822    gcc-15.2.0
parisc               randconfig-002-20260822    gcc-15.2.0
powerpc                mpc832x_rdb_defconfig    gcc-16.1.0
powerpc                    ppa8548_defconfig    gcc-16.1.0
powerpc              randconfig-001-20260822    gcc-15.2.0
powerpc              randconfig-002-20260822    gcc-15.2.0
powerpc64            randconfig-001-20260822    gcc-15.2.0
powerpc64            randconfig-002-20260822    gcc-15.2.0
riscv                         randconfig-001    clang-17
riscv                randconfig-001-20260822    clang-17
riscv                randconfig-002-20260822    clang-17
s390                 randconfig-001-20260822    clang-17
s390                 randconfig-002-20260822    clang-17
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260822    clang-17
sh                   randconfig-002-20260822    clang-17
sh                          se7206_defconfig    gcc-16.1.0
sparc                         randconfig-001    gcc-8.5.0
sparc                randconfig-001-20260822    gcc-8.5.0
sparc                randconfig-002-20260822    gcc-8.5.0
sparc64              randconfig-001-20260822    gcc-8.5.0
sparc64              randconfig-002-20260822    gcc-8.5.0
um                   randconfig-001-20260822    gcc-8.5.0
um                   randconfig-002-20260822    gcc-8.5.0
x86_64              buildonly-randconfig-001    clang-22
x86_64     buildonly-randconfig-001-20260822    clang-22
x86_64     buildonly-randconfig-002-20260822    clang-22
x86_64     buildonly-randconfig-003-20260822    clang-22
x86_64     buildonly-randconfig-004-20260822    clang-22
x86_64     buildonly-randconfig-005-20260822    clang-22
x86_64     buildonly-randconfig-006-20260822    clang-22
x86_64                                 kexec    clang-22
x86_64               randconfig-001-20260822    gcc-12
x86_64               randconfig-002-20260822    gcc-12
x86_64               randconfig-003-20260822    gcc-12
x86_64               randconfig-004-20260822    gcc-12
x86_64               randconfig-005-20260822    gcc-12
x86_64               randconfig-006-20260822    gcc-12
x86_64                        randconfig-011    gcc-14
x86_64               randconfig-011-20260821    gcc-14
x86_64               randconfig-011-20260822    clang-22
x86_64               randconfig-012-20260821    gcc-14
x86_64               randconfig-012-20260822    clang-22
x86_64               randconfig-013-20260821    gcc-14
x86_64               randconfig-013-20260822    clang-22
x86_64               randconfig-014-20260821    gcc-14
x86_64               randconfig-014-20260822    clang-22
x86_64               randconfig-015-20260821    gcc-14
x86_64               randconfig-015-20260822    clang-22
x86_64               randconfig-016-20260821    gcc-14
x86_64               randconfig-016-20260822    clang-22
x86_64                        randconfig-071    gcc-14
x86_64               randconfig-071-20260822    clang-22
x86_64               randconfig-071-20260822    gcc-14
x86_64               randconfig-072-20260822    clang-22
x86_64               randconfig-072-20260822    gcc-14
x86_64               randconfig-073-20260822    clang-22
x86_64               randconfig-073-20260822    gcc-14
x86_64               randconfig-074-20260822    clang-22
x86_64               randconfig-074-20260822    gcc-14
x86_64               randconfig-075-20260822    clang-22
x86_64               randconfig-075-20260822    gcc-14
x86_64               randconfig-076-20260822    clang-22
x86_64               randconfig-076-20260822    gcc-14
x86_64                          rhel-9.4-bpf    gcc-14
xtensa               randconfig-001-20260822    gcc-8.5.0
xtensa               randconfig-002-20260822    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
