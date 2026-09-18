Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B4B396591;
	Fri, 18 Sep 2026 05:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789709372; cv=fail; b=XYw4nxGW56fmJBgH95dNeVUJJjCMMWkknsKSL/HvWDZqtemJV0FSVwIfo1RKz1KaFzhQCpPIJLvWbT8gDxRugqeS9/aJnDUjYJeMo4nWQ/Kin0a7gJycTlN+ehLvwmGWkzsVcq1sQTMNPDIRB9kvYGgzRiRb03tQWuwBYid8BeA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789709372; c=relaxed/simple;
	bh=IkcWIWM2/cv6YGCtAk3yLIHfLaADY5dzgrKzrdoKu7I=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HCyIY5rDU7DzGL9p7Sx+gQGiLpj8sgUSNLrvbMKDbsIE4b5IeMjL2KRd594t53olRTgfR3sQqL1953yDled6aaXGsvVUD659LcHUX3i7Gs6AMkeMPXnXrYvJogO9ozyANZmkZdV/qXkwr5Yf4nx7Rgjp1VWt2jolSzzNh1iLtD4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l7xoQ9ez; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l7xoQ9ez"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789709371; x=1821245371;
  h=date:from:to:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=IkcWIWM2/cv6YGCtAk3yLIHfLaADY5dzgrKzrdoKu7I=;
  b=l7xoQ9ez1pxSySpTB7xT+5Ydx2/0JcZq1/ut3RjmKmEgC9c81rDo042E
   HSFiqO2NHuUOB0GRV8WvOgeIHhN4A3kHA8N2UaCGMeUnt9HsJgk2WZbvr
   jLUQvVHT0x4pFlsImiI3CWjlFiUxFIkiuTQdiVgYlVTh1YSq8txQp0qJD
   VOKT+Co2V5Oa1dEVvyRSFeu3FX0vIp2qa8NWu0+19Bcx8F4kZVtY3UlAO
   DoXBkKinfHsDwabTjPZSIdmf1kMu4M70rlpsK0DTQaXRRIT7vTrgpwQ7z
   oEq2befTJjrZg4ubid4jR5xAyDDG1b98Qkfw6Mtb7bmKK4dd9r/Smm1r3
   A==;
X-CSE-ConnectionGUID: EgxiUWhLTBeqiW36xGzMew==
X-CSE-MsgGUID: OmXlxsmGR1eD7xmXU43D7w==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="100853569"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="100853569"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2026 22:29:30 -0700
X-CSE-ConnectionGUID: wa6BEW91SVeonK/5Fl4Ykg==
X-CSE-MsgGUID: vkzCo7IKTam4yMerMsT4LA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="297675642"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2026 22:29:30 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 17 Sep 2026 22:29:29 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 17 Sep 2026 22:29:29 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.31) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 17 Sep 2026 22:29:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zFt+cCPQjCtLEynD/uRoEvKHtPZ+5M+SrLSDG3izs9rCAKmpEz7INmK+wzae7qaezvSsTXWSwgAvIcK6qq5EJN3getl4nbOpuynmu6h9AlGxNmE1/3Ldmhceb5Sfn9lbS8LZv67o57DTTNs8n0wgUCUGHbQw+etfmcvegC1IrMc8x3JQUhQ/P3KYN++XokMWMvkf3QvhGRw68SqsM9+mqEJW6baStDW3HJwC5VpICZy8A6rCyk5rOszZofYcUokgGLevoD4KmCm4jUarO8tVPpDlR3LDrSaHHoaAeOG31vp6yRJ3NU5Ww7V9vDhiG6Imc7GtCoPT36bjpSfr9Ob/BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GisDTDZN4njbs4gYMsUjnh95QmXPJuE2eRGOjGhjOF4=;
 b=Fl0Z2i9DO4APGYWra/O9kvcs3kKK7hk9XfWmAiIe67gzZ8EveJ46n8kqXKvghHI98a8Xh6s8srX/g2wNXLEsl2Qn8RhauCt2HhUfhMAzgDiJJMMNdYPm72naG2FGMZWwb79TTkFERjOKOowksPG62G2MvnynXi0a7q+jx13YdWe4N0NZra/qm7x7El1Q6F12yZ9zQazTZsfPmS2ugmSyX1Zn7ZcgaMJubEwFBPcR5Dk5xGfiYf9arqGdw3MFSowcikUiPIAisenN54hXHrrYW9rs8FKJy6NIwkpDNz5V1FVxMUitXpy//1NJB1loT2j/FUoMO0vwisd9cwdSPdXD9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DSVPR11MB9579.namprd11.prod.outlook.com (2603:10b6:8:383::17)
 by LVUPR11MB9860.namprd11.prod.outlook.com (2603:10b6:408:38b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Fri, 18 Sep
 2026 05:29:27 +0000
Received: from DSVPR11MB9579.namprd11.prod.outlook.com
 ([fe80::ab5f:5d0f:fb90:9d]) by DSVPR11MB9579.namprd11.prod.outlook.com
 ([fe80::ab5f:5d0f:fb90:9d%3]) with mapi id 15.21.0428.011; Fri, 18 Sep 2026
 05:29:26 +0000
Date: Fri, 18 Sep 2026 13:28:56 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kas@kernel.org"
	<kas@kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
	"ardb@kernel.org" <ardb@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH 0/3] Move memory acceptance x86 arch code into EFI stub
Message-ID: <aqzMGEVpDRPUyPUA@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260914183745.37538-5-ardb@kernel.org>
 <af17c380c43912ce34c228e328b3937343ce2019.camel@intel.com>
 <aqvrUeIfpE4D-Ol0@thinkstation>
 <27b267cdaed0c46146de4af2db8362b61e0b08a3.camel@intel.com>
 <aqyd+rhamNei92Nz@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aqyd+rhamNei92Nz@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: TY4PR01CA0087.jpnprd01.prod.outlook.com
 (2603:1096:405:37d::15) To DSVPR11MB9579.namprd11.prod.outlook.com
 (2603:10b6:8:383::17)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DSVPR11MB9579:EE_|LVUPR11MB9860:EE_
X-MS-Office365-Filtering-Correlation-Id: 82bd96eb-87a0-4c8d-38a6-08df1545ce1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|4143699003|10067099003|5023799004|11063799006|56012099006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: 99f2nAK8qxlnw4mm3epJYu3L73ijo97yjHnZN3NdXXKn4VkKEvUgr1goPbtOxatVg+/Izn11RedAm9OsDO+nU+odsjXAK+pgGWRZm7FKCu/2rFgkCC5rTCQBNx2n07knxSkb7CzxIx5uNtjHe+5VF3SqR43mQmk/X5yf+NZiutlRcFzrNCmBdPk9TrJXMTwsIKGxzwsHlDzlpVzlNkT2s9TiCFPk0HkFsj6B5g6Cf6ocwrKUzxg/bQ99LV9rBfXJ6Q48zGq1K3lYHCtY7hccumYCS3vvD3rHTh+/D6CCByr+ZJjHNqKWzouxopOiGHnonA51QKurJFN66lvfka/RMpevDpU/xI0DzxHc6YJJe+ZYIMTGcdrIaUJsJxkDFH91vM7bZxaYR2HsVGwrahmAaesDHrsbMRHn0WcCuocY74yfAs95bphk0ewv9qtnBzws93KfUcJA+uRr8EQsctRdl0d9yqkOJcccDOCjSA/Po6VqcTz+cpDm5Fxr5gcZKCKfO/EdPXAREn9eMQ+9fFsFVl1cKuw9pGvfxryBOIv3+l6kGslCl+bt23m/X11XF4jzCDXCj2pAoUzGw8TFNTZ+/Xq+V+x+AAhCeUc8ykKsZz9YbThTfP4r7Suky54ZBVlucLTArVh86e/lJy6S8yv/ASpdoeQVwfxeSL1B56uUg38=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DSVPR11MB9579.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(4143699003)(10067099003)(5023799004)(11063799006)(56012099006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sGvsJNN7Z97jbmmimHYiOZP1PE6oNspT1iniXXQd+HCjCUNVJ3cdLQozcpK8?=
 =?us-ascii?Q?/4xaQP7n5/2L3vWhGqvUC/BMBVMbIoQ5hMuT+TaNkV5a4iAz3sCeSGSZbiTl?=
 =?us-ascii?Q?Y6OzReAywdcDViaUJEdmZULe9re1opmXRJPhXrOrkHvlGF7rG5ZXJ4DeSS4M?=
 =?us-ascii?Q?hW/Bth+6eNZavLHSP9mN6drFfrSgt4MFUR2QqY9sp4X2vb7VRp/EryJ7RvtH?=
 =?us-ascii?Q?GGZKQTDI/LtO1NZdNy4KwXtdz3HehH3CHI+eXpXrU4O/YRFMzeugVH5+DJPj?=
 =?us-ascii?Q?tvS8/UvbZNdVZFkIK7g5GzzeyN922DwXcSqk6kcaxZBEJ22Rw76prrEdr+2/?=
 =?us-ascii?Q?3WKTB0Dy6A9CbsR5MTTCHb+F5Jen+41xZ3Jlkdhts9PrnoyM+Y7O2F+ltLl0?=
 =?us-ascii?Q?yohJQX8A4I6AR/nY5nR4phw7ZevquoCsJhO8l0rOocoWnh9FwB8beBLqevTz?=
 =?us-ascii?Q?lwxc5fWoCTtmS747IbL/P+VBQ7asdFMm8zH3OwLfqHIySa6cGgssx3Sxk2e8?=
 =?us-ascii?Q?X1t8KfaeuCEGWbu5V+Vh/C57jTwYRi3arGSS4qAyPwnYV7N/1EOxY5lylfDu?=
 =?us-ascii?Q?r0wNaPiWybv88HLM580UMzjRN6ci/iKj/9opIS/hpBDjKBmCnBumPlwXrZHC?=
 =?us-ascii?Q?N+6iR7Ds10RZmdQQ2deFhm2hy+1u4sLYmqQfP1YyZc6+LvkCcW62Fwxf7XmK?=
 =?us-ascii?Q?v7SiWBWerlpKvBMZr9u/niRd8CBCxegCZ1zX502liSOdSSJVCznRQOgX9I6K?=
 =?us-ascii?Q?Yj+zzVNh2/KJJwOLt9l5VUDCC8xF0rfHPoZ59DAYve6WnMcg7lXyns3SLNMp?=
 =?us-ascii?Q?PTtKBggwgIkeQarOGIkERwSKJrCyqHqMwLFEYzhd6siO2MHJk7J7NDcmwuWY?=
 =?us-ascii?Q?pyM5Jo7VRgyCK35WHyzHW7VSoiCe48Z5XWotbH91prrKTX8JVi3NIicOo0Vl?=
 =?us-ascii?Q?+iNTHGhEJk0lzb/lxJY6A3iclqHnkZokgrywcLAQT2xITLNU1132RmeeGGjX?=
 =?us-ascii?Q?ggMZ03W001sZ+q2mt8wUo5itogYhwaCnnACAVS8/Fl4dgsCDGQ12/QcXqnVh?=
 =?us-ascii?Q?M0+hPnb5N1lorybV2XOa/axX9la6cW73loxJ4/GrqBhWD+dv41d1s8ziwEvv?=
 =?us-ascii?Q?0OB61D6sdSL5fXtam3qUk29mekhrMDP60yeacEDctDhLpmgxh5qtMvRIsa20?=
 =?us-ascii?Q?aBZ2qNTJ4HBEnonHxssP6hu7tI3E0M+BJugBM+PgbI3dXq2xsg35+iZiU0L3?=
 =?us-ascii?Q?uKVM0+dnjMM/kPn4H3MX7uJpqqF/DB+GO5NCju3Xmu5W4GE4akr9M+ZDBa10?=
 =?us-ascii?Q?IGrcdDLsqhU7ROsvTCAp7SHNr4orVgtsf8zwUp7Y/s3fFu0WEAg+70Q5mwB9?=
 =?us-ascii?Q?+opckcQwFViKnt8d36OMbFNXwFjrUt4wE9QHS6alCehf7NUxLdIZgDREqbAZ?=
 =?us-ascii?Q?RlGA1rFEMYWW5bbHK3AiiPIgPlnooa9m9PwpINX5gM1KZG2Bc3qDWH/UMPtm?=
 =?us-ascii?Q?8Jjc501ONRZMlH4A1hIi/dIPmovzqKMUWMnayxo7qNATYz/sXVnEdjG44+46?=
 =?us-ascii?Q?YT1NOOuTEh/9OgWaZqUp2ThiQLh4hfEwodjMMP1zoEXhZ7vHABka8CfeLG6b?=
 =?us-ascii?Q?yGKWaTLVbqQCUd8ZUnXcf47UlXXPejtjM6nb/BzRh0aXBXJg7OT6t/wcE7+D?=
 =?us-ascii?Q?+FoHUIDBDmnLnvoVczf1RXAfejUUIrB/2mAfhpGkRm5RD1nFv6JAu82bVZ7B?=
 =?us-ascii?Q?G5AsDBoGyA=3D=3D?=
X-Exchange-RoutingPolicyChecked: wt/GgU9OR0jS3//7foJVcd35cIBcgZWQF6uNp3C5iQRbxBRLesVpZsPqrDLSvRPXfR0mcOr68XQW45tsLN/vQXcSQQlwLT6wMGkOu3IVkugzsPWk1jGye4zaOpjRGZpkov57Q40hGBR2+qSsWTJjvVu5PMBsmR90u8nmzyGZMy0M7SAO2w7BUZXaQqXd5SUSYhCoq5ULg4gOkew36orRv//E5pQLu3Y4q8yAmZmn50Zs0y4UiYTrBf2knA6rvm0mfBRL5xpAsgvz3eFdPCXyW3WSVt1RViXGNi+IAd0CRujDmxYwJxLI5ZuH35pGTbS9f7drjeCYkL5OAoOLpxBFYQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 82bd96eb-87a0-4c8d-38a6-08df1545ce1b
X-MS-Exchange-CrossTenant-AuthSource: DSVPR11MB9579.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 05:29:26.6224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3pf0+6VxtjbEMZ7EGPLeq5kK4l/Bblnfycpbj+Hpa8zlJszUddXGwK6vXq3gBsYw4+NhvxOoqmYYE/2sDlqbEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LVUPR11MB9860
X-OriginatorOrg: intel.com

On Fri, Sep 18, 2026 at 10:12:10AM +0800, Yan Zhao wrote:
> On Fri, Sep 18, 2026 at 02:29:55AM +0800, Edgecombe, Rick P wrote:
> > +Yan 
> > 
> > On Thu, 2026-09-17 at 14:32 +0100, Kiryl Shutsemau wrote:
> > > > I guess the caller could care about TDX_PAGE_ALREADY_ACCEPTED errors. But
> > > > SNP
> > > > doesn't do anything for this case. It seems like part of the problem is that
> > > > we
> > > > are passing errors back that the caller can't feasibly handle.
> > > 
> > > Maybe. I don't understand SNP model and why they don't care about errors
> > > here.
> > > 
> > > Do you have a proposal here?
> > 
> > Yan pointed out that future TDX modules will not take an S-EPT entry lock on
> > accepting a NP S-EPT entry. However, I think this won't prevent guest caused
> > busys on re-accept attempts?
> Re-accept attempts may occur due to:
> (a) two concurrent ACCEPT TDCALLs, where the one that arrives slightly later
>     returns either TDACCEPT_ALREADY_ACCEPTED or TDX_OPERAND_BUSY.
> (b) two successive ACCEPT TDCALLs on the same GPA.
> 
> Since Linux guest always invokes ACCEPT TDCALL before a memory access, and
> accept_memory() always checks the unaccepted_table->bitmap before invoking the
> ACCEPT TDCALL, case (b) should be impossible in practice, right?
> 
> Is case (a) a valid scenario, and does it actually occur in a Linux guest?
Case (a) should be prevented by the unaccepted_memory_lock in accept_memory(),
right?
