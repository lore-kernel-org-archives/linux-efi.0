Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F133AD501;
	Fri, 18 Sep 2026 02:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789697574; cv=fail; b=GO4jqyj8/JuL86eFVWG/FDOPLp/Et1YhsNblgdJEzI3d22Ovuv/1RzgqQCbUfD8RAns+4Vy6Sm0g34fgv4WgQGaO+iOzxKhckPvhQwbqwpVYCpJSUUdkW91bevkuoxmWzvcYmMnwXUDjDerPIl4EXJ2oLrDJCbnMMPYiAPi6dhc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789697574; c=relaxed/simple;
	bh=a9dSXRSdWextCygxyURcu0kZmov4hz8ko4HHRL/73k0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=luPYxRgzXCFyBEw3L5KjZ+vTYP7ICHfAZ9mmYqEiCRDXXbGdjF3SrdKymp0BQ16oMZuN36IYK0/IcnXhN7nqbF7TYG/EI66NmPF++v6B/1+aY5VoY/6/uIbEpJWSDB/57EK48ykFf1Pr4yUrKlqdlcfqS323txo4+R6h1pD2DmA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aUv8brKD; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aUv8brKD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789697573; x=1821233573;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=a9dSXRSdWextCygxyURcu0kZmov4hz8ko4HHRL/73k0=;
  b=aUv8brKDd1q0t20TLOfSCSfwrR3zdjLBeBWfWjrfCoSDTs8KFWCyR9bd
   BrxsJPSPcjZBzgzKLi3ZjDGEx8B2F+lMKzE85lTTwBU8p+WtwhKFkbzzx
   LrvU6Kw1Prn387H3SIVyqCDaHVyoQUdaRLiOSYOIgIuBsqiY2hJROctcu
   +K/Nt5J6zo0LOr9GLLDD9sbDSrtQX43u4J01z0ixsyghqdlRWz4nSQgxd
   MXJMPd9h2vExoHU8v2L1ovr1ABrlfeGZCyxoRZvVSXmFmgfFERsFLuqWX
   B0thtvkwmAO9d8ebNUHH9wE5OwUnDgFCZt0frSB5/vO21SUZ9Zne/mTuE
   A==;
X-CSE-ConnectionGUID: DtRsFmgUSIyFnKuyTkFQkw==
X-CSE-MsgGUID: GXKfyTh8TL62i35COs0dow==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="77741294"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="77741294"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2026 19:12:52 -0700
X-CSE-ConnectionGUID: 2R4DMddtQD+1blizWmVY7g==
X-CSE-MsgGUID: auwWQbTqQZiacpm7zRyNYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="269850946"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2026 19:12:52 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 17 Sep 2026 19:12:51 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 17 Sep 2026 19:12:51 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.6) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 17 Sep 2026 19:12:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=djMC+vvDmOLEHF3RU/M+L8yDK2PDEASgiTwDGiZZ/l1fZ37iextOs/D4Uy4EIzqiHdpi6Ibhij8ayCeW6EkB7Gcs70cu42BEF45KshlYH5qzzNhu7El5UNlcEAbMzCE/D2LjewyRIXCPRthaHopiB9LkGSu5rfNg/Er/aWaTppduZPU7YwP8WR5Duv0scvqd1hvHHlfeHdp9TeJWebCn6c0XDnId4GTIdEMI9sEihjjzmrhx8sz08oBvR7GTgo18gQEw9Z4pNMu41dS+VWWtYr3OMQ6NeZ+Obh8+kZae4mQ/U5pvTMOzeunqYTqJFNRaDveI7CjyOpKhF6aB1kIC1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FMejUc15OMxTSV38LGXJ9P8zG3uXAjcWulG2HHeR9jE=;
 b=h7kK6JqL0SQTTrRjH+ua9NKFv9s+EVAqXdlILroPWmXt6H/3+fkq10iVrmojWjnNQCpT/ut75tnCEz7cmaUnJcgnE4FPkT2OBmfmTvW8vwj31nHJ+4O0lJXmxxLRXA4MNNalBG6Nj1ZO4L5vFIQUtCKpJFnqWxeZh8g47a/0DOhwb9QgNdv8wiAch4wH5MMiQ2YjKEp6XXwUc1gP2uMzOczxHstEuWUBNnWJsO4HN9gXNxCKeivsASLeJv1PXiq3OhegEHgHsC97fks9VrbbiEemj3u7cFxGGdCiSV7bV2qheek4O1JXrajskbV/C/GX65Yren1oArKR2hYMelnYXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DSVPR11MB9579.namprd11.prod.outlook.com (2603:10b6:8:383::17)
 by PH0PR11MB4886.namprd11.prod.outlook.com (2603:10b6:510:33::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Fri, 18 Sep
 2026 02:12:42 +0000
Received: from DSVPR11MB9579.namprd11.prod.outlook.com
 ([fe80::ab5f:5d0f:fb90:9d]) by DSVPR11MB9579.namprd11.prod.outlook.com
 ([fe80::ab5f:5d0f:fb90:9d%3]) with mapi id 15.21.0428.011; Fri, 18 Sep 2026
 02:12:42 +0000
Date: Fri, 18 Sep 2026 10:12:10 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "kas@kernel.org" <kas@kernel.org>, "linux-efi@vger.kernel.org"
	<linux-efi@vger.kernel.org>, "ardb@kernel.org" <ardb@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH 0/3] Move memory acceptance x86 arch code into EFI stub
Message-ID: <aqyd+rhamNei92Nz@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260914183745.37538-5-ardb@kernel.org>
 <af17c380c43912ce34c228e328b3937343ce2019.camel@intel.com>
 <aqvrUeIfpE4D-Ol0@thinkstation>
 <27b267cdaed0c46146de4af2db8362b61e0b08a3.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <27b267cdaed0c46146de4af2db8362b61e0b08a3.camel@intel.com>
X-ClientProxiedBy: TPYP295CA0057.TWNP295.PROD.OUTLOOK.COM (2603:1096:7d0:8::8)
 To DSVPR11MB9579.namprd11.prod.outlook.com (2603:10b6:8:383::17)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DSVPR11MB9579:EE_|PH0PR11MB4886:EE_
X-MS-Office365-Filtering-Correlation-Id: e5bffd34-0068-42d8-7b2c-08df152a51e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|22082099003|18002099003|5023799004|56012099006|11063799006|6133799003|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info: c5lLPMt65owlYquZkEAtdJSObzeeMyaE1JDnJ5GqIII3X/4Ppy5XinydOrqJeytdzIsaC+cCdTNSRXY+UapRLXxW3pDn9nQ9ORgbTlcuG33jizBkGdQFobdKkrhE5MveINwnvZoOgo4jgoETys4XiQfLBQ3OO0Z5yvI9HS1SQtf9KreaLRJZl9ybkKSlP5IA9tWKAzEf4r74ytNlLZPQ1xDwA48PF8ZFYQt10mSOfppqFovjbsExGj7a822ZXeJoKRvWdB/MUg4fpuw22dLp9V7q7jxqozn4Z5KvM7Fe/E3QgFQxzU7ibjh7qVUZz6/on7v69QN0haFwulm+biNU7aYwPnzZ5BnrIa6Eu5bN5hC6Ohyuy+G+ZEgiuUVIwICZuKdp9faebUOIPgOn/Ihtl9iViPWpl8GCKZlZW4xCjsrds4jK4NzkaI5Me6CqPNTOnlq4btB8JH8Otvux/akp6iy/JXm6cgeN1IbXbz5wBYuQm5D05tZlHTDlEg7A1c85Ouq7BbFUOiLR7xJmlOnvD1jxalWyZdhO2MwY+eLTg4bfVOcFjcNU1QHkiIhIJ/46J2/3x5AL3l9BMbNaQXc0wsOSlR+mIvGB6RvsBpOGJKdPGbQ/ZEP4lYz06FoahCTx4WJXx0dlDIzv6GPR6wlUKnQkqNnBaPP9yD7UW6hYHBU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DSVPR11MB9579.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(22082099003)(18002099003)(5023799004)(56012099006)(11063799006)(6133799003)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?go5A/2zJKWScc3PvHE5tnguew/Xrp/vfxLtT8DAk70LJtxFGgKP0zVdbzc46?=
 =?us-ascii?Q?QzQQALBqmkx3hSXfC26BMgqISryeUzxz1/mQlbYyfgNqSXk1KpMU4imm8Pk0?=
 =?us-ascii?Q?JEE2BL2snZwuQjQyPz9TVse2jgva/NhpdLNcCJG9NXudcM4RLlCB/VnYHrMh?=
 =?us-ascii?Q?G6UgRiUg3hZqZ4NAD8gJuNSj+gRDRSxOKFOJK5DHK5k0sp6oRMNfgIlAl5dU?=
 =?us-ascii?Q?1aMH3vU/achQz9/1EXCKaAw8UsBIWyfWZV4DzOl1WmlW8wWiIHKWn9swMQFD?=
 =?us-ascii?Q?porD5sCMeyihfk6c3x15VqzSkrFK1FxWY/xiBzcO1UDHiZRV8llsm6bazeQO?=
 =?us-ascii?Q?xnxjqJdhNo8ckzLGQ8onX9trd3l5DyvwOEe76wK6b9Vocb4/K7mTfBPOV+wc?=
 =?us-ascii?Q?3LtPTVrmepushthe/i/YeswZUdruqyjZKjeS1ckP7z8BspS+BSy5pZi2TSVn?=
 =?us-ascii?Q?YJ7Apz210PfWkiOB4eTKFd71WOzL7Gciq1lIiuLtEkkKv+BobnXD/DazNuAQ?=
 =?us-ascii?Q?8iSnytWczyz9v1to1yoi7hgedsC7xHVAXqIUmKtFaEYI/+ar1QSQ9d5LyExS?=
 =?us-ascii?Q?ic8Ljzvi8CFsP5OuV8935dnmkntRs9D2Zd6dOxMw9Ha+ECK1Yebrpsx6851V?=
 =?us-ascii?Q?rS6FWTD2y8npaI4T9Cepz7ikgnrj9xUEmWgY+UBJOT918ROaRGci/ePrn8x/?=
 =?us-ascii?Q?IilAoNlB15QL/s3mHGlZvLeiOvw0cuYpmIynRaXBDo16a4rXwC/pGak1QS8W?=
 =?us-ascii?Q?Ye4wVzZX0QKZnnAc4j4A2Xlvhp0+rvYwVdzTWYjbJ72+jkgDodmOYrzzMr7s?=
 =?us-ascii?Q?Rv/wfGlOzD12RUl+/5sz2LFIvvIPJpnIeXc3+Man+ZrCg5c1U2D2Mo8dtQ3Y?=
 =?us-ascii?Q?wX4bcGq1Zoy4H0D4cgQkBWCkXEjk3NaCrjhbYZ8KKxVv/IxMbnJH/WJOdjDk?=
 =?us-ascii?Q?UZyTpvIE2F5vV+SiN/IxH4QP5YVMDqRj/Z3kMrV52rHw/gWBCPObvYJkVRMK?=
 =?us-ascii?Q?AI3u93fic2RTEuIOlvBEP8qKAvCkziKFdNoU21ANWLDQDGew3//k7koWrzt7?=
 =?us-ascii?Q?JRgjUasRyfSrQMvAfOBYtX08CsW+xqoJVCpaWxoCHPxDM3jH5kQNZH45L6T0?=
 =?us-ascii?Q?86M1WDaGFkt65XapdngfOTJwI8MfUTictzh16FLxQdaHUV2sf57JcEtEZ1BV?=
 =?us-ascii?Q?RTQssylpF27X9HJILiMdSKlVzcHqsXMAjjtb/MdRgSJg/KOIdn/OWCXqE+0n?=
 =?us-ascii?Q?gAnYAabm7gEVOLYwL/MWBENV7lj+py8E44F7D48ClbLGLxciTeqUpziQRHhm?=
 =?us-ascii?Q?1LhtjMyzKz139l8XJBV7JFKJcEsiAfxR68tgnjCdTb1eG9pU1Fe4/Yfa5ijf?=
 =?us-ascii?Q?4/HGYZV/Z30V0t0PUKoivIfTDLYAObC+Kav3UYN1KM/FyNmyo/CphVGKNYF8?=
 =?us-ascii?Q?GWycgkfg1oNXg3cHK62Wgg6mfLArEX7PXBUP8h+FkxtgZFuD530DQgGfZFxC?=
 =?us-ascii?Q?xaxzjjMnoUmwfEmyMiNdCI0qHZW/LXE3kanbKEUa1ATpvLVTpf+Lgub2wmQA?=
 =?us-ascii?Q?ihYb8XFv6YTdSRiZ95D1Q4qpj6RSnIbTtgsJJQKl3VftOY/dlbdmtaplZn3N?=
 =?us-ascii?Q?PwehfMwouQODM6aFxnfVY4vlNf28sCffxb5dppsfKc5z4KywgkT6SNjxEbPD?=
 =?us-ascii?Q?7vYm4ieXHU6OquAleHf1CitqMuMxrzn9W/5UDoMadST4y0uHhcHXtLQt29q1?=
 =?us-ascii?Q?GL/tiy90sA=3D=3D?=
X-Exchange-RoutingPolicyChecked: 3Y2xlVrgM04FwDACmO29LLDMRh0feKHwTc8EOmS1ADo8ZUTeJj3/rPxBQxJ7oqy8WjTbzt6byPmGHTtFovpAwZJgU9pSrcvb2Rdk2uMbplHmA+qQz/eg8jUdJP+U163V6uweCQOddTPCeZcW2zPm2rc5XUrpJ9am96bCvgRMThdSZqAwTuh6fi6GdDgiwL4ejMNVE0sw6xH1D1YJgeTVTX3qePinQr3SVNit2sz/cIfL1ro5ZbB2BHrfxCjn4hjv8LDWd15aA/n9Yle+lEZnuQ2FLlhFs2urNvvhRHVLHMeSbJPvvuAT50HfxzeDdc+XCr0gd0QshJTtXr4vizW+sg==
X-MS-Exchange-CrossTenant-Network-Message-Id: e5bffd34-0068-42d8-7b2c-08df152a51e5
X-MS-Exchange-CrossTenant-AuthSource: DSVPR11MB9579.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 02:12:41.9463
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZHM8bCw+NNK3l99UiATvM407tkXeq2YrmcZl43DFVbrL6oWsaWjJdBUKm3Fo666jdOh3Gjac5AynE9+FOORB3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4886
X-OriginatorOrg: intel.com

On Fri, Sep 18, 2026 at 02:29:55AM +0800, Edgecombe, Rick P wrote:
> +Yan 
> 
> On Thu, 2026-09-17 at 14:32 +0100, Kiryl Shutsemau wrote:
> > > I guess the caller could care about TDX_PAGE_ALREADY_ACCEPTED errors. But
> > > SNP
> > > doesn't do anything for this case. It seems like part of the problem is that
> > > we
> > > are passing errors back that the caller can't feasibly handle.
> > 
> > Maybe. I don't understand SNP model and why they don't care about errors
> > here.
> > 
> > Do you have a proposal here?
> 
> Yan pointed out that future TDX modules will not take an S-EPT entry lock on
> accepting a NP S-EPT entry. However, I think this won't prevent guest caused
> busys on re-accept attempts?
Re-accept attempts may occur due to:
(a) two concurrent ACCEPT TDCALLs, where the one that arrives slightly later
    returns either TDACCEPT_ALREADY_ACCEPTED or TDX_OPERAND_BUSY.
(b) two successive ACCEPT TDCALLs on the same GPA.

Since Linux guest always invokes ACCEPT TDCALL before a memory access, and
accept_memory() always checks the unaccepted_table->bitmap before invoking the
ACCEPT TDCALL, case (b) should be impossible in practice, right?

Is case (a) a valid scenario, and does it actually occur in a Linux guest?
