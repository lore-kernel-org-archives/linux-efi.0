Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.66
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794582649;
	b=rAQ/HeQaa+wmJp1Fm+Dk2FfmyR9KMvQ1R/ghVHc2syDAMEh5lQFYbfebnUP27r7yw71x
	 jSmJGdluOBqPm4Eq+61HvnqKkLukq8axxfMBHzfvpHpmFlGwZt4SePLu6kfcvyDaTzTJ1
	 wzv9yQCi9Ci3tDU57EWnSKbo1x32j1VPP271e610ZI/pT3WnAUWKC7Cd4HVGU4Ni4n3GC
	 yAAP8I8YEmxKLXR0zWSR5ULBUZiZFqeZHako2wMeZQi+H093P/Ovz8//AqEtO+knNe8YV
	 rtH1z7KtXRLSYC9U0qLaKpsg62Bpq0VTKQOtD45LUqIFZmi98IscdU9q9vuuLc1vDSw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794582649;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Content-Type:
	 Content-Transfer-Encoding:Subject:From:To:Cc:In-Reply-To:References:
	 Date:Message-Id:X-Mailer:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=Vj4qIiYgX9wtOQIdam9xMriqxCoAeJEyWf/8b6RRZeo=;
	b=4sHMfvQVxCJJuCMJ6/z2lftEiq8FNr0eJO/XerfKNCfXHKJ5McEvCYLzZKLW32jltB7c
	 MIzOcPY0Ggx+TbOlHaEeJkkqmkhPcWnT+wdXHQwRqYGeLqxb5E8DDzVeq3c89G8/SpsLt
	 uDRxtciEGRFXXwWj7qoeZXr+v3GA5AyyhtTvVJlc8ufdnePLBh2y4Rosnux4oTzY9esL/
	 4oLmfJi1otiA3DiQ2woPQROVqkojbtDHCYZmjYRRmMXbQRmh29lAEmhdAuyyRXS/kqr0T
	 00Jqv9NKHtcJI5vFwS2+6xEJM3f5LpAIaZ00NCSB+N95Pm2ovxxCQo5PQiGM5jt9SXQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=o6HnoPGA;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.66
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011066.outbound.protection.outlook.com [52.101.57.66])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF56606A333
	for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 15:10:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0EF56606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=o6HnoPGA
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=od3c8FeO5AGBNvyAOB9X55lXSHC/03X5N55zAWcMsOaMtya8dbej/bn4ooIyNaJgc5e1QXBko/+heIqQb5pMkuA7dEfkOgvK9wIcKcs5vyer82QZt4PRkNZp5UwZRU1YH7GK8s6h5m+NLdz1VJUwyG7RO6DO4H9djBX/JZ9I4rcAeG9W02jhkt85fgE3EWQDEeALZ3TwPASSqN6+CI2brYKcbU3gSQ0Ts+jTItwga92HXysm3JS3RnYl+zM+5Zyv4kfYLthoD/P+64H/Nk7EttKGeQOFbEPygGoW7X8nIHaVDYVb+LYPnhvsKcdUh4vv6GySigsk1stYLRRgDElXHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vj4qIiYgX9wtOQIdam9xMriqxCoAeJEyWf/8b6RRZeo=;
 b=s23A2p8oFcpkzg1gQvhKEApmxw2F/eB4BiJgscT4N4ti95p0PZzM0DPBZ/A7tIW7phd9+cUYBItxiLcKJpA8NE+JBl6u5tqgKjJn8u671PjnbPoQX65D9J14F0Ac2BWyd0bJZf05qY23f8hGQ/fUsXQgcRxfo7PvQ6ZOju81NCpGBtjVUEr22c+83zd8QJKNcq6HQZQSJb+EOzW19krvPwJRj495UjYZXZ5ab1MMxOSTgKm3hLgIMons+mtotTGi388ZaHR6cXY/tdF0FGtSIRxQ9PopLkbhS/aNaJvFvCRkJIT+GxJhOXj6TI3A5kxyNKj2iGqlocihz6u8OGa7tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vj4qIiYgX9wtOQIdam9xMriqxCoAeJEyWf/8b6RRZeo=;
 b=o6HnoPGABOmEdNSZuLJv//z9waKDAAxmErjnlJ8xCEeOfXXfumfJgoAMXpgJDFWAeyqcpO1FYiGSk7seLexNdt9IjqxMwilWrY0UiHW9AkHiYoqyFSows2MFU1ejjxirIN9r4pYt0uSrRAkds/tjXEBh6/V+YaGNN2f/sX5fOInNNTriUqtzMyfYOzaP/StSEq/aigN9LQY5lxnTNUoHQW/4p6xRAw/3Op1nh1cddKijVOyQsvuA3xtIK9CdR/mFh5U6eZysDcp2lOoCjRIahrERVQpc+2HyKVlr3TI0HJ80L92muhENPgACtIdRnOVXW1mWLgUyACgsIDP+IiIJ1A==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by LV2PR12MB733495.namprd12.prod.outlook.com
 (2603:10b6:408:423::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Fri, 13 Nov
 2026 15:10:40 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.009; Fri, 13 Nov 2026
 15:10:40 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 00/10] efi: Expose loaded image properties via info
 struct
From: Jason Gunthorpe <jgg@nvidia.com>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 Ard Biesheuvel <ardb@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, 
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
In-Reply-To: <20261110121731.2728824-12-ardb+git@google.com>
References: <20261110121731.2728824-12-ardb+git@google.com>
Date: Fri, 13 Nov 2026 11:10:21 -0400
Message-Id: <179458262191.3625095.4353352783630299840.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: YT4PR01CA0199.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ad::23) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|LV2PR12MB733495:EE_
X-MS-Office365-Filtering-Correlation-Id: 35b5b574-63de-4438-4612-08df41983fdc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|10067099003|11063799006|5023799004|56012099006|261022115727099003|261026121527099003|261022105027099003|261026140227099003|261028144727099003|261021121427099003|261022075727099003|261102123227099003|261102130727099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	SWQcEYn1teonXyWR+wXCRt0+V9B3f953lP/ObsFPYyBOOX3H4IFaEnE+hX5g6IgYtf2HiSF94O9UYVLP1u8+Qy+oYv5B/YPFWXZXSRSuDXPrEG/MJKD7nvVeA5MaGJHTS+r0NsncojUprRdyohEtOGwnbwk6MAgRWvjFY6+xlqeAKWJCCySRGGFQSySxhi/yVNSTv321+mFg0okfQgRI4oOyJtmz/sMwkgmRx9ZT9LI86KccP6La0r2WycMMekIjSPIgI7Q3qhxRpkWlPAei1PAfYBQAIhdwIpAzwHz9ZrgkvspAe5F9uK5d5bLKHINCiscgeD8eccoSt7nfRaEm4EwsqP7ySs2AzAFlivBTLprIsq1bFDpKuLXLOp45LCFP8K3kCLMeXLY/515piHH2JDNi6tGmiHutpAgjocmFy9C2b0rfD7jSKD7X0eTWAGCAmw5TpIzH8pVAe+on7HKKMd7wvff2zYGg1aQOCMJfTVNkosjSUnNUOUMOCnQmkmHelOQ0oprYa0C014C338eC0pIWg+MyahjVwa2QEq+z6FgxYoyQI9U9KDiVLKT+tN7uj25JWF2lKxt/v6hlZMNIWlVYK8o1LANSLbOZ9j6+xV7k74FyDVPRf5wA++DDcBuCv+rbWEF30/Jh6IJzLR3dDMUMP8NxuZuqxnCmelicN+4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(10067099003)(11063799006)(5023799004)(56012099006)(261022115727099003)(261026121527099003)(261022105027099003)(261026140227099003)(261028144727099003)(261021121427099003)(261022075727099003)(261102123227099003)(261102130727099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eVFTd2JFZ1NQNnE0RDN6ZGxGWmVxbUhhUTdadVF4dlZSb1hLeTllaDZXR3M1?=
 =?utf-8?B?SW1PODhJS1M4d2p6SXdYY2VNYU5nL21SMXZHRDRneHU5Mzhjb3Z4ZUJtc2w3?=
 =?utf-8?B?OGJqMTUxVHFkSVk0QjdVOUJnNUlFcUl6dlo4QmtjSWdEK3Z0Y1cySEY1Z2Zr?=
 =?utf-8?B?RkFiUmRkeWRPbVFmYUZxRGJpMFRzYnBDSGtRSEphakJRNERTR3VFYVZyaGRU?=
 =?utf-8?B?K3pQRUxXK2pFSUtWWmU2N2hVK0FHeXVwOEJlTnJoQjRPSDkxU09WTnZrSkhY?=
 =?utf-8?B?TWJJSGNYeTd0NmZOYml0R1F6MTZzUCtWZU0xcXhvUzNleCt5YllnMDRJcDBL?=
 =?utf-8?B?L1V5UGlETjJuYWFCRHlROHE4Z0JtSkcrQWF4Sm5LTHRNZEgzeVQ5SUdsc2tx?=
 =?utf-8?B?dnZvNkdndk1ua0dKTzZ2K0hyY1c2ODcwa3RuV0tLSEh3YXIyR2syWVhra2s4?=
 =?utf-8?B?a1U1aTdEZ3ZlWUwwaWVzQlFOYmVSQWNLaWJBdFFlb3ZDRG1NOW5NT3RyRFRY?=
 =?utf-8?B?ZFR0aWY4ejhnTkk5aUpmK3dMUWRZb2J4V2JQaVVBdkJ2M2dyM0RuUTR0a2dE?=
 =?utf-8?B?OE5VRDhOT3JyMmY4RzdmbDVSMnF4N3MwNUhwT0w4SFJCdEVNMFl1c1NpV05r?=
 =?utf-8?B?MTFCWFE4L0NoVGxzVTlPKy9jYjdMbS9lbklseUlCVnVVTnRCNVExUC9rWEJw?=
 =?utf-8?B?czZNODR1ZFBMazZiNkRIbmpyQk1xVUdIcHRuSDZZYkhKWWZyOUpUai9JYzhx?=
 =?utf-8?B?UTVQSnplaG51SnVKbXNWd09ZRGNLL3FJZVFuUG41V0Jzc3ZiWENPV1dQNXpJ?=
 =?utf-8?B?aUtpRU1QQ0pGQ2tHdnFhMUhXYThXOU5xNXBFbHUvVWhxUkdENzFqMTVoM3dK?=
 =?utf-8?B?M25WQzlKY1V2ZjRqeDZkZ1FrTlBMT1dWSGFLTUNKRXgzck56TFYyblBNdEM4?=
 =?utf-8?B?Y2h2eFRQQXVUN3U0R0hYVTZBQWZUVjU4cVU2WllhT2FEVUJPVEFPVDFwZGdB?=
 =?utf-8?B?NG9DMHVFZGxxd0llZGYzeTVKQWpoZmRXRzRndU4zR3pJRmtWSWVKV0x6bVlY?=
 =?utf-8?B?YUN5a1k3MUIwSnN2clBxcFBtd2ZZeVZjMDdoaDNyUkQ2c2JyZllGb3JiWGFZ?=
 =?utf-8?B?azFOYStIVk5ucnVvb25KWFViS1UzVDdYSnluYVJ0dzhuL1hIbEdqMjllM0Vv?=
 =?utf-8?B?Uk01VmxvVFZnVTY2aFpabHVTaS9zQlNya3VzYXNkR1gwUEh2RHRicjB2VzFH?=
 =?utf-8?B?Z2FCMU40ZWEycVdQcGgxZGtOY1ZwaCtGT2dyOUVWb2phYmN1bXh4VzAyOFln?=
 =?utf-8?B?UXNqN3RpL3RvSlNGVU9ub283eEsrMThNQUdYZTNnYXorZDFwVmJsM0VVWVdj?=
 =?utf-8?B?Wm13akVKa3h5bjFuYi9ocGlJT2dwRWlIRVB0bmxuN0U0bkhiYm04TWpobzlt?=
 =?utf-8?B?OTc5dzd1cjZEWERKR20xY2U5a2dSR241VjNZZ3FOK09jNGlqM29FdDBuZ3FG?=
 =?utf-8?B?SmswNWNHZ1pXTzdUTUY5UFJVdzVHNEs0MVFwL2U5ZGVsWk5XWDhPbHYxMzRp?=
 =?utf-8?B?VTRVeXJlRXlYUnpONmpLVjNYYmZTUDMySFViSGdnQzV1MXc1WUhnWFA2RGlC?=
 =?utf-8?B?elJScGo5elFRaTJYNHdtL2FZeE1ZVzMwSGtJRXBrMkU3dkJsdGlPVG83S3ZZ?=
 =?utf-8?B?UWpYOVhWc3pQTkFNeTZnK1A2Y3pKeFY3OUMxeFN1OGtJUEM4aExtQ0lrZVNP?=
 =?utf-8?B?c1c3aEVDb2UvVDJuMHRvK0NsT21mVldyaFNibDJYL0lxeW5sdjc0OEJ5dk9O?=
 =?utf-8?B?RUpqYW8rRXBjc3pXZXFNRHZ0WmJ4NCtSNzZTdjVJNlN4bEVvVFhEQWp4SGsz?=
 =?utf-8?B?NGhXdlIwVGIvbjZZaHVaenJzckhsclhjUEgrM0dycnlWaUFicjNOTElramQ2?=
 =?utf-8?B?ZkdoTzRyNnRTN0VpZVJvZG1xcHJ6RHFrNE9RVHNjMUYxcDVFdk9Za0Q2eE5P?=
 =?utf-8?B?alFKVCs0dExzTVVoQWFQWU9mQjdPaktsMGNmQXA1dnFPQ3VsWFF6VDFKRkRW?=
 =?utf-8?B?ekhNazRBYkFCek9DTHNyVGo3V0xPTmFHRmRIRHhlalFZRHBPYUp5d1RlY01l?=
 =?utf-8?B?S3RPU01yaXY0VStyR3ZGNjdQREpYdTF2cUFlL0w1TjNnN0I5MVoyTVJaSDhM?=
 =?utf-8?B?UXFHc0s0RHdCcjZuUjViWUxBOXhmQUdPQ3JVTFFZdXdHb2haRnZLSE5BMjFK?=
 =?utf-8?B?dnJBdTd5eGNqZDNwK09VaFdjL25UOFAxTHczU0xOM2ZEVEUxbmViUWFPMjZw?=
 =?utf-8?Q?y4XU04a87NhUtSSBxT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35b5b574-63de-4438-4612-08df41983fdc
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 15:10:27.3012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZgxyKkYFq62yVtc8xEsZtxWmAtJxCKA4yUv7+kKAS5J4ytbc18fA4cJ3Gzr455RU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB733495

> From: Ard Biesheuvel <ardb@kernel.org>
> 
> Clean up the arm64 build script and linker hacks that zboot uses to
> obtain properties of the loaded image (which it cannot access directly
> via a relative reference like the ordinary EFI stub).
> 
> Instead, define a generic struct efi_image_info, and expose its offset
> in the loaded image in a similar manner, but without relying on explicit
> linker script exports.
> 
> Populate the struct with section markers that all architecture use for
> loading the kernel image at boot, so that all the linker exports can be
> dropped for them.

Tested-by: Jason Gunthorpe <jgg@nvidia.com>

DRTM still works after being rebased on top of this.

I left some ideas for further improvement, but other than the
.init.rodata marking nothing is critical.

Thanks for doing this

-- 
Jason
