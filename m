Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.2
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793115046;
	b=rI2oQPe5f7El00bGdaj0VSYTQZSJhPsDGOaiF3WqKOe1bNEPIECr4ojaXxqn2i65Z7D6
	 nxNnPW2ceD6ty09btGj38EiIgxRomALc6qiKor5kuC3nwcdxB8JohE/Jtiut+BwYu4MI/
	 gJUXNnzOPPWU4Zv5Iekn3yU9LP72FzG4a2Rw/jFDFY5NBUsrDwYIo1FJJ8jpraqSM7yWH
	 DBdks1/zOJBtoDlDabZ/pCB1x7WDyJDzi+GcBHeDY7wnU8C/vxv+02I4w/p+3z51nCn4K
	 Nk2GkMFM0Ea0A98JCur1zsB1isVBXvDX6hiCP2f8EqcGQ+b5gJm+P52fSMt/btDYo+Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793115046;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=OcSPMK/d3lwL1yYK1MgmP4+eAAztV2IDX3jibeABN9Q=;
	b=1ym0iWH9o+xNBS5P28AQhdVJbPAS9sl7L+9RiyE1Ac7EU2csA6SELnYzd7+jxfy+s0fK
	 A2vqEx6340WUNdZ4jSCoGchJJNFR839U+ijJgVLSXjoOuGwGI3sCWIyDO7oCC45jNuLyV
	 kMkrPel/9S4RIIpOKHPtUlVMPWvVUzJEfZv9E3K705vFO9CTHde5QsOn+3C53LBoMlbUB
	 //+BJDRS4kXqA2SHCQJuyim/jYEAuLsclsQuEuXmKvPwkaMVPYJVeT+e1XV2r2NvY3qb1
	 BqOQoBNvN0Ay+PO7A5pVNPW/vMmK5d9S96IaRBEEvuPN9RVb8QUrhhPupUW1yMsKcDg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=iknT9Aej;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.2
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012002.outbound.protection.outlook.com [52.101.53.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A82606A31D;
	Tue, 27 Oct 2026 15:30:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A0A82606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=iknT9Aej
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eVvyHU2rP1xsyB2BJ8adoaMxc10oEGOnLjwjgX57a99yFUSobcguslA8XJqFpIq0JJLMyTGZRbmAGZ7hVLw3pQrXQKwNMMgmxgrgxxqb+xi0RHwTrdv9hcYdv6SHhYNvEcyvT1k3zbz/cgo9fQQB5WqIBSj2hKhQ0AaAnpfVFr537fEh9sIxa9cf9ildcEAO77u4Km27yTWQHATVYUMAietsQDKFLIqJ+BMcooBkTBIj+E/G7E5WXxUiDS+L/vLAzZknZhYHNW+AXeuvC2UggDjbc4umafPhGP/T4M3vDsLo/3mjzgKV2uTL5K955hGb3TUT2SknBSu0h9FJMP2i3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OcSPMK/d3lwL1yYK1MgmP4+eAAztV2IDX3jibeABN9Q=;
 b=EyTPzL0+DJii2jOqKzYy1IqsP2z6fM30gpy5KbpdHxsLFjgvXc2lS5UJ2ujbVKl4UvNCLQDS7BiVMbyVpcG3GqZk49YCQMznCvmCRjUtHGBH6mgRvYWWaSn1E4OtinRRrbaVYle6nqERWu8j37f6+UVmmRLQ1M6suJ+wwSevlfXRFJQ030+ALQx1pJSziT16vqboM1zGtUBK9j7ancg8LzIialFFWewAMi/qaWpAhHQHf/EoM4TTkj/1Pbxxc6TewJDEA1bdhtwGDUjYFoQm3Bka2SnBqkWz8QIHjAaxs8LGCIWr++0HTf3Gm4WnS9IZdEL/ae7BsbUAVbNHF6Yagg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OcSPMK/d3lwL1yYK1MgmP4+eAAztV2IDX3jibeABN9Q=;
 b=iknT9AejWzBLQgXf0GQTBrTclB6pIyGxsf0CS4j9VmkZFjxcx31uNEpdOwffLdTlUcz1XJvrfDupyNCvkO5cLUlsaT54iammk8BTLZ2KnXIHTCja9amtvQFVMjWpKUlDXBeZWfeO3GFJUoREDaLTFz0vDXJvyqJmQSCP+Kscg7yf85o2klznu4AZeOZqX9d2CA35cB6qNN4FYs2wW2UTKe+pCdjLaD6GXWSvJWJPyVFlPyRcvz16azp2KUiqq6IgPB7L8ozd4o4cYuQl2j0vDJMmWb0hNYwOiyIYLwYs9PGzSBd6oJtAvTWcLxlfGImxCxFOeLMfRLlaZe6WWIKO8A==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by CY8PR12MB8337.namprd12.prod.outlook.com
 (2603:10b6:930:7d::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.21; Tue, 27 Oct
 2026 15:30:38 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 15:30:37 +0000
Date: Tue, 27 Oct 2026 12:30:36 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>,
	Ard Biesheuvel <ardb@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, David Sterba <dsterba@suse.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-efi@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Simon Glass <sjg@chromium.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Nick Terrell <terrelln@fb.com>, Will Deacon <will@kernel.org>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	linux-integrity@vger.kernel.org,
	Palmer Dabbelt <palmer@rivosinc.com>, patches@lists.linux.dev,
	Piotr =?utf-8?B?S3LDs2w=?= <piotr.krol@3mdeb.com>,
	Ross Philipson <ross.philipson@gmail.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Song Shuai <songshuaishuai@tinylab.org>
Subject: Re: [PATCH v2 11/15] arm64: drtm: Add macro definitions for DEN0113
Message-ID: <20261027153036.GB2418472@nvidia.com>
References: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
 <11-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
 <20261021104336.00000437@oss.qualcomm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261021104336.00000437@oss.qualcomm.com>
X-ClientProxiedBy: YT4PR01CA0332.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10a::6) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|CY8PR12MB8337:EE_
X-MS-Office365-Filtering-Correlation-Id: 7efbbb0a-a892-4c71-38d2-08df343f401e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|1800799024|23010399003|376014|11063799006|4143699003|5023799004|56012099006|261026121527099003|261022075727099003|261021121427099003|261009223027099003|10067099003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	ebeIMlqZys+Xr65+mllFE2FxMNHQt8f1b8KeOtv3FKo/m8FhMPkQDAlAYSB0zYMS19N/Hg2XnD7h0pvZZUQ+dgY86t3Ppy5GAVhvK0eYNVlHWzvS3mTy9mMShLxMOrF8qdu2Z7cHzgtpfZXuC3SY0MTjYiJcZ7c2Il4hXaNXllKU1h3UTmdlxifqg0BCvK736gDGyl1jQJlS0pIh40NglrY2jFeWxJCke9hoP35qOs8vvjdKVfmOazPEg+jZ5f6awn5XcC7X8WJrnQWwfr3QSWC+HKYFk5mVeblVQa55i2Qr5OgSpHQHDBKuMcmbK9jEQWs0+V3KIB9UofVxcBbVZu2LC2Z4W1/uq2N+jU3OGe5BT9W5YcD6c5/9tZhTViQRgN/wVSJcEQq6gfqQFXA8JZlrTA8N8pAy+JveQeEVmbKL4LqDGZxdS2IRK69UGkg1o5mz0X3vZgnU7d4Phsdw31ryqBbnCSSAC3As43FV1sOEoDsy27zN8h6RTwZx/LneqoCkvXILbgpmhfM6hlBSzR6h3zFgGrL8a8YGtONr6BbwrWcRdnuv7R/1Ew8Zyoyg/R4GbW6v4ho9God/2ZlmXIwV+A+T5Q6itIt+374RpTcIkVXll8seM+ogtNwxMMtwxCcqYS+m6KPWqpdQ4+5Bj0KYsxIpMoXae0U2l+eDL6c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(23010399003)(376014)(11063799006)(4143699003)(5023799004)(56012099006)(261026121527099003)(261022075727099003)(261021121427099003)(261009223027099003)(10067099003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Rm+jz0ttbIicqz7v1EcwRCkaBLigv3He+OL0a3yUv31iEpneYSYrqs8+xeIo?=
 =?us-ascii?Q?DBgc3Lwy7T6nUt/pGsGpDn5wB3rQvJBQmowxB9MWU4NK9MPfWbB9Gg0yRbWY?=
 =?us-ascii?Q?YltDuLPgzV2rvG3Qc3hjCSUqGceOk4EXERrfgCI4ZKg0wRXTIGQLXzDaM0o3?=
 =?us-ascii?Q?TvgMdCi1dSkuU60l/h8t8OgTHVn8z13UC3NBwCM8E2naHRCezibhjLfcFJP4?=
 =?us-ascii?Q?FDNgJMqQeo2l72aZ9btCuNliPTZxa+izYaEiaB+j7lfFtUIK/OBx4hIkAuWW?=
 =?us-ascii?Q?TzrKxNJ6x0tYLFe1lNLVZ6eHCDbPTbjvAkWYrU9B6bj0zHZYKM9snSu55jOu?=
 =?us-ascii?Q?VDjsExOIocuL14Ym57boZcohGy6gJ0Pc3b/4hhlinIYDadjuaKZP7qPuEQ/d?=
 =?us-ascii?Q?mZkGneXMyBCeeMBE3Pie+/FF1fBIjazbG37Kdb+tddwE7DH5kZbJBBkd6Lf4?=
 =?us-ascii?Q?cmRM19CiYzzmlWHuXIEutO7fwWx7iw5x398vSxHK6TGUeoczLhZj1kVVfFoM?=
 =?us-ascii?Q?eOl4Zh6/ziZm52Ex8zLiqplBAJ+Vs5OGo97VYI6WtsyUw72VIIt2309bPpVJ?=
 =?us-ascii?Q?2Ajqzd/7fTW4RkT9vX5oH4C8/hghd+SXKbetlM9co9M+z/05pJEaAUoP8z2B?=
 =?us-ascii?Q?d4kzCPhmGe+SJU8tAiPpj+bTIXXQ9yNZ8zA8uPXIYoRrCsUg6RqEc71t+8mM?=
 =?us-ascii?Q?HtlndBI4tHJWUzPKsZbWS+xtxKuUHpDl5Mou+7PPf1L20wZ53G6etRTRsn9b?=
 =?us-ascii?Q?c2P/4OPdFlQCol2oaEpMEx6V/z4vpgQT/TQkhAuHb5f0PzISyjGA8R87zQHK?=
 =?us-ascii?Q?BeQ2LqJPetoAX6881eUy4z7LjnqRmE1QTDlrF+7LrSGlvyonkC3HFqfbRj69?=
 =?us-ascii?Q?kuxUVsTNZvt5JBfqjaUmUg7u8mQ8dmdvgv29blYRmLIHzmCymEvAIu3+TS03?=
 =?us-ascii?Q?r/ZH+v/IsFOx33so27LHEnMxRo+6jh0idlS7j9hZfQS9ha94iYdiNQQyaiPE?=
 =?us-ascii?Q?zqeheENzcSE7XT1ti/WSMKbg+AdhGpq7+cbWlJ4wn79whvVidBwhMLS8z/0O?=
 =?us-ascii?Q?/AwsJGQMsMY49+/kZCKY2Mf0MVk6AN0XcW+JblBmTi98fQNRveqKaaZEfCef?=
 =?us-ascii?Q?jXaiQ2MeC8Atv/bv9Rqp0+cHNK1yQetPxbK72sOFZ+TrgtUqovQSOnB9HBQD?=
 =?us-ascii?Q?RGgZTXS/lavCzHeOlimjlCXjTI5LCTIKOARb4AfHYAxb0MafyMGmCbRU7Rq9?=
 =?us-ascii?Q?cFvg1hlLLkGjC1+zjRONi+Iz9LnKERrjf4pUt+jDiRBPtflyiExJACDQ05R1?=
 =?us-ascii?Q?QBH6cC7Rhi0Q9vgSsJlAkp04P76e7eIInwBJkbuRYcFVLKqLRde6443KIu1/?=
 =?us-ascii?Q?amr4ZAdqUcxP6U6UiREf4P5KJ23eZ/5UgSTpinpT3IAcgynOFWTsuLQU59G7?=
 =?us-ascii?Q?nq1cA0w2uE4Fx+jcr+NxnZy7L+uaerZ4TsJPuWLwqkeKNd4PyiuzHHUjjEFW?=
 =?us-ascii?Q?zE+1RfnuseVHKminDhXrPx6DXIEPmTOjH2CzeGCLEoc1amclJa/NdxfnVPLC?=
 =?us-ascii?Q?FOaYhYt8s7A9SL1J7jeUb5rP3CcGPHtDfPmOptSVzrNWd3k6fbdxApJqpaLu?=
 =?us-ascii?Q?ESPLZd5Lg+mjDOELxUN0kJWBD6JYB651J0iAFtglGx4u9/hXkENoP/dlaw2q?=
 =?us-ascii?Q?cWw1/l0/LUezPrFkNvZ9pZUG4cAbuaUvv76S/nPMZfVw9Lax?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7efbbb0a-a892-4c71-38d2-08df343f401e
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 15:30:37.4083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tJeQB/9dG0+bKsb/vwKjwfE0fAKntxzeIbT/nA2hb/XTvg6Qbd1Ef/azKH/5LydM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8337

On Wed, Oct 21, 2026 at 10:43:36AM -0700, Jonathan Cameron wrote:
> > +/*
> > + * The spec uses 4KB pages for sizes and alignment throughout, see v1.4B
> > + * sections 3.3, 3.13, 3.14 and 3.15.
> > + */
> > +#define ARM_DRTM_PAGE_SIZE			4096
> 
> Maybe use SZ_4K from linux/sizes.h

Done

> > +/* v1.4B section 3.3 "DRTM_FEATURES" */
> > +#define ARM_DRTM_SMC_FEATURES			(ARM_DRTM_SMC_FN_BASE + 0x01)
> > +/* X1 input parameter */
> > +#define ARM_DRTM_FEATURE_SELECTOR		BIT_U64(63)
> 
> Maybe define the alternate masking for function ID - for completeness if nothing else.

#define ARM_DRTM_FEATURE_FUNCID_MASK		GENMAKS_U64(31, 0)

> > +/* v1.4B Table 6 "DMA protection features" */
> > +#define ARM_DRTM_FEATURE_DMA_PROTECTION		0x03
> > +#define ARM_DRTM_DMA_PROTECTION_MASK		GENMASK_U64(7, 0)
> > +/* Only valid if ARM_DRTM_DMA_PROTECTION_REGION is supported */
> > +#define ARM_DRTM_MAX_REGIONS_MASK		GENMASK_U64(23, 8)
> > +
> > +/*
> > + * DMA protection types. ARM_DRTM_DMA_PROTECTION_MASK is a bitmap indexed by
> > + * these, and the Launch Features ARM_DRTM_LAUNCH_DMA_PROTECTION_MASK field
> > + * holds one.
> > + */
> > +#define ARM_DRTM_DMA_PROTECTION_COMPLETE	0
> > +#define ARM_DRTM_DMA_PROTECTION_REGION		1
> 
> The dual use of these for bitmap indexes in one place and
> values in another seems fragile.  Maybe it is better to have
> different naming for the two even though the values match?

My interpretation is this is the intent of the spec. One place is a
bitmap of options and the other place is the bitmap index of a valid
option that was selected. So they should have the numbering always.

I actually preferred it like this after you suggested it

> 
> > +/* v1.4B section 3.4 "DRTM_DYNAMIC_LAUNCH" */
> > +#define ARM_DRTM_SMC_DYNAMIC_LAUNCH		(ARM_DRTM_SMC_FN_BASE + 0x04)
> > +
> > +/* v1.4B section 3.5 "DRTM_UNPROTECT_MEMORY" */
> > +#define ARM_DRTM_SMC_UNPROTECT_MEMORY		(ARM_DRTM_SMC_FN_BASE + 0x03)
> > +
> > +/* v1.4B section 3.6 "DRTM_CLOSE_LOCALITY" */
> > +#define ARM_DRTM_SMC_CLOSE_LOCALITY		(ARM_DRTM_SMC_FN_BASE + 0x05)
> > +
> > +/* v1.4B section 3.7 "DRTM_GET_ERROR" */
> > +#define ARM_DRTM_SMC_GET_ERROR			(ARM_DRTM_SMC_FN_BASE + 0x06)
> > +
> > +/* v1.4B section 3.8 "DRTM_SET_ERROR" */
> 
> I know I'm the one who asks for references, but maybe the SMC numbers are obvious
> enough without given the name matches the spec section?  The table references
> etc below are excellent!  The do no harm beyond a bit of bloat though so I don't
> mind if you want to keep them.

Let's keep them, the comment visually sets the sections apart..

> > +/* v1.4B Table 8 "Definition for error IDs (Bits[10:3])" */
> > +#define ARM_DRTM_ERROR_ID_NONE			0x0
> > +#define ARM_DRTM_ERROR_ID_PARAMETERS		0x2
> > +#define ARM_DRTM_ERROR_ID_SECURE_EXCEPTION	0x3
> > +#define ARM_DRTM_ERROR_ID_TCB_HASH_UNLOCKED	0x4
> 
> I'd use NOT_LOCKED to align with spec.  Maybe it makes a subtle
> difference somewhere? UNLOCKED might imply a transition to that
> state, where as NOT_LOCKED doesn't.  Meh, doesn't really matter
> as I'm probably over thinking this.

Sure, easy

Thanks,
Jason
