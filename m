Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.7
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794855152;
	b=nkKccTajdVg01x3OVAAe+ePcnZvBu4PlG9m3mqBaTE67Bb0LwKptoS/1dX1MWFf0WWNO
	 xnobVgg5dI+zzt6av0w/EolYw/PoQ1C+5DyIhNnZ7L7zohbmLqtJFCbaSFmNgJ4DM4AC1
	 op6J1HV7XQ6qRuRWAZH8YFSrmhsa3oxp/HMwGuj5gKcRFvwcHa+b4fsMncCVJn/TaBNIJ
	 MS9IYrdb+MeOcXk0yjqmNcP+t6muari9nFgtcQ2un/Ksn7cqIUr6W0CZMTXVPpfONs2an
	 o/AbnAmT8//kr4cV4MV3cpIxlSn9Mb/miBgMp7OXWdnnLr53rxKfQu2w4AlJuA2LGsQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794855152;
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
	bh=v7FTcKV6AZQ2OTIJhr7jyIv0fdUF7Ju6Fv4urzG9ys4=;
	b=jFuFRTlx0DcLTYIKtejezxv8O/2GsApR6Z8J3VzyUFl/KExYvWxnKxCqs7K2Lw+uxdhi
	 CjtJxQ+YgbwtPu5GYvFr2js9zKXb3mDrLSIatY3IJ3tFpkJMbqremILw0TpT1EfkLWrKa
	 4IviRF+vqVC8GC9/61NLRcMYHll9740fjLNIirY/PQaw2Scy4w9dcrZVRhicswjH8uVtu
	 JUbrx/hZcgrPPnWmsPsyWbD/e9n5jxlEpZVVc/Xx8RNweyw/ZnFkPZ0A02LZVJqn/Rh9r
	 EV3TbuZAqAHPXsZvDn/m0QYfD+Jq1afGgiFsLb3F+3N+4j+vsOMh9N7LaC4HmGbowEw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=kWvlcl8A;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.7
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013007.outbound.protection.outlook.com [40.107.201.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3204606A339
	for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 18:52:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B3204606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=kWvlcl8A
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a3K/ZLiBW2V117dNcG9hqlTLtXLKSjz39l66EfxK501n4hsdHHuOj9ccHdj8Kt3cA9NWAJCKSj3Atl8bFaBES5fWtHViipO/rMlJKpuzNNMmYIHI4qk9FkGDmYiDLjgjXN/l0FQvPHptoH1vcFttiovfWy2CLCkvgccIBEwnA8f9uS40pFZUU2RAo44ctfVtgyQSPPQpGNkD53xjRpoDPYlFHK8pgtT8asPZTtTjGnE5nMiGeskD4mvsddTYX51t8kTGkujhPYoBTUXFXLJwNfleMuQ7T6dor4pdwvX4cl2vH0X9q/m46aQTDbr7tZ+JD6xkZfuMzvNoCgo4hoB2QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v7FTcKV6AZQ2OTIJhr7jyIv0fdUF7Ju6Fv4urzG9ys4=;
 b=O4ophr5nbatmgppNJJRGp6DWPLhSnRE4oSdutrlay5Cfi4TvBTnBrK5LTtMpQlS/4qLibjX1iCOiTbx0D1lI016CiarrFciCyJNsMlpgE9NYS/SarkK1kobUUQL78kLRovPw++cy6X2AOW8JvOKAS0ASt0yHqyqMDB5D72ydvf48Jx58NV9SugxJf8nqBDA16Z7Z8qH1Q66vV333AKogJpU/cbeSmtpJDBkldPvdwRbhnOcX1uWL8TTOzJKYttK5yyRmUnrnvOdCpIzs1gVhhsQQYLWdIAfxUWl3VjPEvlOclJaA7vAaCSsyPfXLGr0tLCMwGqUZayQeuVmP+TUhnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v7FTcKV6AZQ2OTIJhr7jyIv0fdUF7Ju6Fv4urzG9ys4=;
 b=kWvlcl8AmfS0/Wq0dbachmYQgp9gENMQMDL31SvmenL/zmwWQNovvsZiyefG7jy9x0UtRyvtKyV6EzFf7tBITMTvZ/r/JvSUniclvDjCKt/XbCTKfiyyfkgFBCnhxP0jXz5H59HKWAd3AWuzzHySbbX9aHsAr7dbpb3m94M5uAJfpHsHPHp+QRDH2xMWlCGQgNEXNqe4Kpt0VVeVR23FBxYmMT/qRsvNXGUeVyPavM9inatwsjVeumyzIh/hZkWrDYeM0as++a3q4rLnhUFaG4b9yHzfawT5Fu0WdDlj7MxqAw7nVt9msq3RFj7PQjA0NoUMJXIuGOTXV4NGMjl0AQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by IA1PR12MB9062.namprd12.prod.outlook.com
 (2603:10b6:208:3aa::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 16 Nov
 2026 18:52:25 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.013; Mon, 16 Nov 2026
 18:52:25 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 00/15] efi: Expose loaded image properties via info
 struct
From: Jason Gunthorpe <jgg@nvidia.com>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 Ard Biesheuvel <ardb@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, 
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
In-Reply-To: <20261116142618.1687025-17-ardb+git@google.com>
References: <20261116142618.1687025-17-ardb+git@google.com>
Date: Mon, 16 Nov 2026 14:52:15 -0400
Message-Id: <179485513555.2274641.13145658188111198678.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: BN9PR03CA0713.namprd03.prod.outlook.com
 (2603:10b6:408:ef::28) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|IA1PR12MB9062:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ec01095-1599-4ebc-eb6b-08df4412bf07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|22082099003|18002099003|6133799003|11063799006|56012099006|261028144727099003|261102123227099003|261102130727099003|261026121527099003|261022115727099003|261026140227099003|261022105027099003|261022075727099003|261021121427099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	SYJnnP54isNqkvSpuO9CKq1UjzK+qj28OuvQv4jLovJgQNzaanVVsUv4moQFntXd2WL/WP0ET/pYwWYEfnRF7oxZ+BwQceZzsupqQub4LVEqi8elCxpopJY9y6N3NwgoQrKxZb4Qw+1tyizSS6UzUyi/l4xXQKXPFechibU6BQ+0RKdoblZzB1nmiWd666lVZEs/cGTCNqG5XprEg2rJkCIZuTOpQGYCfHUsdm14J2JgTx7LUj/2ZEWk5dSjldtz1CYjcYhiKZYdljtIlyaDKMgviMZ4Vhb8M8gvqYqYq+3BXse/2flagJ8+6V/D3H2IujmL/VywaHBqFS+lFeLo8+o2yP6ZELGlKpU/UgC+6SSaigW3fVm5Y4gPeYhlemRQmechQJ/MkI0luKg6zarykLfruShDXUb+r7Mx6jT6sxbsnpbSPvdiEnHkwQi0uxjQDDN4sSWqHv1T9+wiC2wUIfBKirviJWzgzz5OC2k1vKSYA8UOgMXSvUfH4kB6JmF1zf7lzG2t+F8nJe2oMcx/mxloXQ7U7l5GxxAhqmZPmsL52OVL7IzQEB1p3vGYePUE6az3ryX4HPodnqrIS7e0jdrvYuWrYUFqEQG/CZVDH6fNzdL6W1/dfBduuxgwxfzwzUN7Vfdcmr4u2Ti9Z2ldEo2sRfVTPF/wdNfRRfvtK3A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(22082099003)(18002099003)(6133799003)(11063799006)(56012099006)(261028144727099003)(261102123227099003)(261102130727099003)(261026121527099003)(261022115727099003)(261026140227099003)(261022105027099003)(261022075727099003)(261021121427099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZzcrdTdNdzNaRHBwOGFzZExWVE91WVBUNUJMckh4MVQyZkYzdlRPejVKMEZG?=
 =?utf-8?B?Tzc5SC9TTTJwckVlRGYzVXA1S2h2RWdmeldCdzhMZkNqc2xFd1pvUkY3d2lt?=
 =?utf-8?B?OVAzNHI1MDVMSHBMeWluSk53T21nKzVZanVDbUZLdTdHSHFydEhseXgwcUdT?=
 =?utf-8?B?aFRkbmJma1padUYzN2EvT0laSTZZS05rRXlnMGR1ZFJEdmNUM2hGSVlIRFRR?=
 =?utf-8?B?aVptRDBXa20zYVFmRVQ5TkFrYlFRQVYrd2JPWWx5eVlGNWdNWCtJYUl6VWVI?=
 =?utf-8?B?QTFKNGYvL0VjbFlWbURoaWVhblVMRWZlR2pmajRmUTBuNXZETUtoa3dyMlFP?=
 =?utf-8?B?NEowdmpiWjZrTy80R21OcnVHeWoyTUR5OTlnVXlQSGN2NkdFVVR4cy9paE1Z?=
 =?utf-8?B?SktvV1Vld0V2QXNjdkV2b2dVTlZoL2xVRTI0QWFveERIUlRSTjA1QTl0NVZ2?=
 =?utf-8?B?b2ZkZEZnK00yRXBPZHMrRU5KVktrcnh0UVYxN1B6eWRUVHlFMlc2b1hhQWRW?=
 =?utf-8?B?dmovY1lYQzM4Rnh5MUFCYXBnK3JRZnAvYzdnMTQ5cTZPeHlzcGdYRVY4cCsw?=
 =?utf-8?B?bEw3a3hYcEg3YVJRUzVoVWpaWlVOb0N1dkNiQ1MyUTFmNkJMUWpwNXlJOVB5?=
 =?utf-8?B?STV4UlhwQTNBdUZOdEVoU1ZJMVlDSEwzbXhhOGZvRk1FWEwyMjBhVzJhWldX?=
 =?utf-8?B?QVRqZ0htdktHMkxPMDVpL0piVmY1dkJVQy9aS2gyb3Q0QTVYeGgzQW5MSWhF?=
 =?utf-8?B?STloaE1qdFF3Uk5zR1JLaDNBb3luZUZGK0FqdmpuSUFFanlhNlZSYzFnOE5U?=
 =?utf-8?B?UWs2M01Id1hLTHpTdlZiVG9LYnlBcngxWVQwaVZRSEFKQWtHcEdhT20xaldI?=
 =?utf-8?B?SitvVE1yNHJLS1hvbVR2blVLdTVWVGsyQ3A5RHNQZXJFS2dPdkJxdnhOMkN0?=
 =?utf-8?B?WVQ4cWR1Qk1qMlFKSjZScGt6aDNZQ3NiZkpxOGtjYWY3Rnd5SzZlb2xUSXVR?=
 =?utf-8?B?SGlMam1uaSswcWI2R2hFSDUrWDg0dDlwUFdnZW9selpoQVhOdTlENldJMEtR?=
 =?utf-8?B?SnJjK3VFc0ZtbW5pc2xQVFZhc0R2c1JGTFA5MWVaMnRROXFFZGNTSFpQWW5H?=
 =?utf-8?B?NEF5cEd0TFFmMHBqUUVmam9tL3pnVGJkMjN2YUV4aUxObFRoSmFnLzFyRW9l?=
 =?utf-8?B?bHNBUmE0R3RTeDFLU0QyUkc5UEhib3BJbnB3NHBPc3ZKa3lpc1NvZnY5V0lq?=
 =?utf-8?B?MW9icm01WUNidkY3VDdiSkttNEVlY3BIQ3k5RGRkQ3dXQU1BQU9lWklOcE0v?=
 =?utf-8?B?QjhCaVBCNGE1SmtMMDVLT1NlejdUbTlaTU9FU3lMM2ZVSk51T05LUHlxa3Nr?=
 =?utf-8?B?MmgveTR4SHVXeVNUS2tlMnJzQ2dvTDdCaVZuMk91aXZVNjQwZUw4dW1kZWZF?=
 =?utf-8?B?V29FZEQxSDJ4ai9tZHVVaGU4ekgwcWV2V0d6a0lSWmx5RFI3ZlhIb0xDWFlC?=
 =?utf-8?B?Z215V0xnZFRQOXFzY0s1L0ZuWHpVdW83QXdjYzVxT2ZsUlZqQk5FdlEwYjB1?=
 =?utf-8?B?dWFrQjUvUHJPWjYzL3M3dTdsV1ZTVXJBa21wMWR1ak05V1hoRmJ0cUZieGZX?=
 =?utf-8?B?MSs4bzVrVnhneWhjMkhoWEwzUmpialVmQ2FGclBFVE1aUEtJaXZFc1dzLzlo?=
 =?utf-8?B?b1A3UUdLWE9qVzNsNnlMTGN2QkNwTWpwUEcvY21kbmhuMThPTXp6VGJObm41?=
 =?utf-8?B?dHpDYjlLR2UzMnZYZWorUWJGcVdBR1o3aHZGbDJVMEExM0dRR2FxZHgyMGM2?=
 =?utf-8?B?KzNvR3I5OS9pcmFHd2tpKzJpeGJhZzhkYzFwQ00rZnRBYThiS2x2enVMcG16?=
 =?utf-8?B?bmJQTUNOVHlZdEhITW5zSFd2SWZyYXFIUzZOSVptREVCSkplODVNL0ZOcUl1?=
 =?utf-8?B?TnI1d0o2YjU1WlNxcUlQN3FZcXY4a05RSWdTdXhyUlJVSXFFSVpEdmZ5SHVo?=
 =?utf-8?B?WVRGM21jZXBjaXVnUnJIY0JZc0h6eUZ2K3p2TWRrWVVuZkVIVE5Yc0VuWVlL?=
 =?utf-8?B?Z2FHQUtyT0J4SWdaMTRHRmdHY1cyYTVWZlRKWEltakphcVpLNnNJVFo0YXYx?=
 =?utf-8?B?K0NBVFIzMWliRXFCWlk3QzI1VTl6RHJIQ3VESEdaRnRxL2RqWEJSTGMveGQw?=
 =?utf-8?B?amlTZ1lZSTRTK3laV1NDaFp3MzNadHduQ1JOaU9maVFMNHBFOWJkN0lGNzha?=
 =?utf-8?B?ZGZDT29vNWtQcDNITGp0a0ZVZk1NRDJncklydU9Id1VjMy9sdk5TK1p3MkhJ?=
 =?utf-8?Q?QyhGCUA6okW9qgPP5p?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ec01095-1599-4ebc-eb6b-08df4412bf07
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 18:52:21.6830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q5M4PygLkSpAAPrYA1YL3O7hHqlwlglbp4A+GZ06qWxoaFj2aUZjbnV5rsP4PXaI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9062

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
> 
> Changes since v2:

Still works with my DRTM series just fine on ARM64

Tested-by: Jason Gunthorpe <jgg@nvidia.com>

-- 
Jason
