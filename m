Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.23
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792605018;
	b=jasPldxk2koCOYo25Gp5UBQovuMbtYcH0Y7ksOAuWySX0JlftIYFbJyUQBCp353mvulN
	 PundwESXiDVXkZ/kc5EgYe12UuczS5XFscbMML7SHoAOQOVrmvRTsazoKB15TYM11LYyJ
	 6v13LzKMKAFw8j7acBLjB/nFpgvecdEZug+YvFUdjxfqRJZK+sqwjliYtosDiXWwtainr
	 KSYjcFJwiibGkymx9U2YmXz2Jndb+YPP5z1ib7qNyxEnOio9ZLiqqLhWRtjS0+dYzcaQv
	 T7McgFCNEAoan/AbDYGKrkT4p7ksZQdWrEb7TSbFDnf2NHliz9WdphnYKtJw6Twua+Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792605018;
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
	bh=Pev50FxeuzrbPwBZCMOmm71rhJPaYziiPfQ7h6TTO9w=;
	b=An2Oa2E43xOK0NewKr2L7w73KbzDdW1r0zl0Qhu7ESjiMi2LsO08r7X1EY30HtiBXbYH
	 Rx0NSqcWmif8bmidV3uFMH5RfmubxjLv9AlyXWGjlbbhs/B1bicchP37MuQdqLotfFE2a
	 h5U5wnR3cBQRNuFLc52FHRYmT25RE7vtpf6rYeaDeBZyeCmgk69xGvQOKwztfI1CDIHFY
	 x7A+owwZQyGkz8/6e+DX4Un8l1fadKPb7RKZaYYDBEYOnkSG+reMQ77/Mt8F6bwA1C57B
	 K0Men7UX5AWVGkWTzQm03eSVCAKSp5PJY+ZfLkm8d9ByJaJsiWZ1s++4UAQG3rLhwMg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=r1Zs6e8N;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.23
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010023.outbound.protection.outlook.com [40.93.198.23])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F52F606A319;
	Wed, 21 Oct 2026 17:50:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5F52F606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=r1Zs6e8N
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AtQ1Kkr4L/X0mft+zDcwbO5Wc4/hjNYE+xku2i4PnoFfTwQbyAnqlzeE5sGsblin3FFAuJ8M37+LeG8tlxFAB0stX5thvemaK2bW5TRxOspByG5Xb7FLFvsY698p6TddG0jXTBPhD4gi0V1GE4oXiyZ3wx4b4bKOGmGCLhq4TSj2FvRAYiKPzrKZlyfCbZMcG0txwJzjdrXZFNhdEvM4WeBDjCMi5hsB3zHHz2Mq30K22Ku2zyl0W+2cKGi1Y4iHkJm/KsCc/qUuHyUTYa5/ISvyHREq+bBvjfGDbfLEpRS6LWkk1IbC41eUO1+durwrKDXaoXhDWoh8gA27vSUISg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pev50FxeuzrbPwBZCMOmm71rhJPaYziiPfQ7h6TTO9w=;
 b=jVxA68qhxegvOyUkPQ207CI9b/x1V/G+gtczisLNDW5nR+Dxj0GqwF9+bSkbIIE7lO153ta+E656yLyQs/2bsaCQMq9Gq7z0ucCzMHUGCONuyc/jFE6UG45Jai/xkxHl8hvqh+BLQBNlq0Y5crdH0NP/KcdpBnydIUIuK32qSzXqKC7SgFnSU/EaPxIy5xv1QNjDqYMD5yeT5gFnHL8+FwLzawnEsMPNa6TGiCuz61LD09EUmjY/9TQwn/XhGAGOxx9vwbqX87rliXBdbsfnYQDtAzUKBvEKGK1Dyg+fnVEphtxWuBDRSAAVSDfYF58VclrSOk19FcmCq7DvBfWcng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pev50FxeuzrbPwBZCMOmm71rhJPaYziiPfQ7h6TTO9w=;
 b=r1Zs6e8NhO/Taocmn8HC43SxP1fh+5DnAtd8zNu36Vs2FL9cuu3T199ZqB8eZNrJlRK/VX+MYV8LkP/MeagRFhb9Am6bm3mSsgTRfMq2BaXfejkdndNqQP+cTqTZp2Un6kTa6OPmiAp3okNPPAFQxwi1PApDXreJzKYjZxkwdhnWAOjHbunyuqGv6CVd/N7Vxa8njgXs6qm7ySlhQM+RzjpkOXjkbwbXRRomrMHizUK3YoUeliMs49qtTEOHg59yV/6DX7iS3qit+s77m6mdHTialwNKzwXRqMNbGdYMmSjsO6vSAmg5bOh+GP9Qi6r/5IS13s9zMVJ9ScOA32e/kA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DSVPR12MB999308.namprd12.prod.outlook.com
 (2603:10b6:8:423::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 17:50:12 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0546.012; Wed, 21 Oct 2026
 17:50:11 +0000
Date: Wed, 21 Oct 2026 14:50:10 -0300
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
Subject: Re: [PATCH v2 14/15] arm64: drtm: Call UNPROTECT_MEMORY
Message-ID: <20261021175010.GV3008132@nvidia.com>
References: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
 <14-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
 <20261021104726.00002640@oss.qualcomm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261021104726.00002640@oss.qualcomm.com>
X-ClientProxiedBy: YT4PR01CA0010.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d1::17) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DSVPR12MB999308:EE_
X-MS-Office365-Filtering-Correlation-Id: d097b464-8578-4166-251f-08df2f9bc13d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|366016|261021121427099003|56012099006|4143699003|11063799006|5023799004|261009223027099003|18002099003|10067099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	yqg9aiWc1HHpX1PieCQxdM9weof9L0qv001XIEjla91rxZNmX/HSGJUmDbeJk7pplLDoABxlr//Sodu+rufxJ+ZY3btXaxajKc/x5el6tkHkk+v32Tb1qXBzVdcaK1dXKVBaKsecr4dr66tsmSYwRDIo7FnWIzwGEpLIWsZmKz3ftugDjgdtCHRZdsZyoVLFEYD24UaWiWDQGHZbNZMIgZBuA6b9XkWhAPwQYCZMBR9vRyybtkjEU6KoLa3DEf1bxoUujJhPQFeYCwbrBhzAW9mvejKssw2yPnLh5I+E9FGUiHw/i8f2u+poXItG8biurd1MmOyBcw7GfLMKu2fD7vecIfYOKi3ed+Bgstu0SrwGKT2oycV/AClFI+hfCTLnDxnbNA8Vd00yjaDp5f5+8USgmWJFSoxsMaI9ZH+GRQkI2l1pbf/efmZrHE029K7aogzgPhkdVZFJJUZHTf12jVwOJaxzAcZF/FLp0QMZHOOPKAagvcMK9VDu4GYu6/ulXPhezGXQ6aD5papM1v0F2pQ+WnQpxzutvjRP2ohn89RtQNzh6fAe6Cu79rOhtz0YIIexwjdU+7bXvGPpaxu4o5qenDdCkzdouWRWxIuOVqbiZYBKMYZjKpG4EHjOuwYcqQVfhFDWFpD5bgDz07Hnrq/F/6z10xJ0ftAVL+A3wpM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(366016)(261021121427099003)(56012099006)(4143699003)(11063799006)(5023799004)(261009223027099003)(18002099003)(10067099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jhdVLgwLRRqYpk4S7MweVZEDF+w1qecMutR33xxsHsqGaeqllBdKR9CZnIqJ?=
 =?us-ascii?Q?+EgARNZGU4NlHo2TmJLH/Ez7PiEZoLROsp1AU/gAbxTVjm6gTgUl6ZGK8PaF?=
 =?us-ascii?Q?cealmrmlhIH6h8Iry6K9jc9RkJ0oXYzowTCSsGwKOXjevnItylmeOJiUv9/J?=
 =?us-ascii?Q?YhgLhe3PKfXDopUHKiBmN2bAXm+TGGtx/fGBk6+RIeYdfk6KSwBxs3K9x5SQ?=
 =?us-ascii?Q?GPmklnFXbymx+MhIF1icpAwaH6+iYX5N0VNH5r7fkN/TNHUB9NFXoFAgHpy2?=
 =?us-ascii?Q?MFSpa7hOhqRmGCurPmo+52LG3cAELd3HaxRAD4VRIgadMgL2LZE1/KiYStQs?=
 =?us-ascii?Q?v+erNbSf0V7UL7SMRKyk3bO+rKAwIdas1Zlb8PjiTp3HVYt+R5tffGLdrlX4?=
 =?us-ascii?Q?Wa1+c1DAkAQjrgjPnpwq24H6fLbYpPjEA5/7CwW7VUGT5aA2n/9b+ePDQFni?=
 =?us-ascii?Q?rGWLTpKr6tx8QYnS28sfrBt9RSRNJDdT8V2+Wlbvm6qAFUVO5zUt+X4LJaYe?=
 =?us-ascii?Q?wdtNpWestGfsMajD11h3S1og0WVS9JzdETTHK1ZTCYAUFxRSujGCkey/y2TH?=
 =?us-ascii?Q?4kPR3w+wKOHIdgQsFHDp7qPDcDGguwZtbJAqu8r2bcGOaIhYUxoH6tqZZVv8?=
 =?us-ascii?Q?EaH3OD3lgy6TsZcUQtj5mLAbVxT1z2/5RD3fN3Wqubuk4CdgDH4gDE0ltjsT?=
 =?us-ascii?Q?sYU01qvP+QtFiWo2n6o3UnC0Kse+WoKm3UJOWqHwz96LlP90yDyfOnnLkj0b?=
 =?us-ascii?Q?Ck3l328wSgXhxD/JeEK5UUO8qGfigepS94m+JNmna3syz1NeTIkjgntvl7Ll?=
 =?us-ascii?Q?ThtPbOu+LRI3890RRr2UjqiraLrY4vrXvjKm1J9rRfW3tHQ7WXvUm6KpdcN6?=
 =?us-ascii?Q?ZudxprGrFDALoNc7fqHgNdQzjAonqsk2fsHxLL9hL5DXe4FtdCuGEqMDTCrL?=
 =?us-ascii?Q?9/9B0GxZ3A0D8AYhBZndOFXOS7UhMVWU5iHINHrD2AE+jernBgmpTH5KBFXi?=
 =?us-ascii?Q?jh/NYPALADCnMEhqvwLll1Zhk3DOJWNV+p9lnost31Qh/6bDmdj1UwIx3Yfl?=
 =?us-ascii?Q?aVP5KNi+gif7DtHmmAKQb5snKIrxXoq8FcMZ2pXGK2WQkXSUs8wcgOEglSXh?=
 =?us-ascii?Q?vn8vs7xeGkGmQqwLm5RTqwQdy+Z5oIBzd7bZk4HAc3qXjtAILRNGoMOXpqIG?=
 =?us-ascii?Q?kPBZDnVc6AWt8lj0Y0AzBIxplj1BtwOtukTV6zvDt8OXSPanho/KjAJydn8f?=
 =?us-ascii?Q?EEWsgEp88jOhMZL1pwO9LuWi4CCbw9fwAopO0WnylzrAVbgsSHyj0UpBBALV?=
 =?us-ascii?Q?J8uhWBPmrWLIxb6hB2f1/aqqf7cIjcuz7easlX7qjf1V2S9BDDRsrYqEZw+T?=
 =?us-ascii?Q?VdcsSf4mnvHJAIbOASRO4YRE3QRIf5koL8+8IWaSE8/DbnT1GXKRJ1N0+aoU?=
 =?us-ascii?Q?c5hhMah96P72Cu43/BcP/8BtpCVeqwn+oGUbobwm417tT+9Az9o/vn2bCBWZ?=
 =?us-ascii?Q?a2uTGwhBNd2+18AbaNJ3SDneTsMNKoqPhawPurj7UcxhcKMNFFS/zR9CgJ/y?=
 =?us-ascii?Q?mv3bJ5o9Utnu/sGuMzmhiaPL7pRwOxAXTS9dXGcpcAphP9A9q5jLahFHX2Dt?=
 =?us-ascii?Q?qAky/D3T45f3viL9PVVylTF/Bq9DxQXKJEEPac6mxbpxxe3tGLhCA6/AAWO+?=
 =?us-ascii?Q?hBl0Bi1kfs+OFjsHn4Bh3pkJGxx9xnbj5zg7XqhyDdGepjju?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d097b464-8578-4166-251f-08df2f9bc13d
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 17:50:11.9286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tZhM2lMsZdxQsmkSM/58lYS+yh1jICykgjTrNzMdPNoDAaulLB3HxiDxqNDIuWbd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR12MB999308

On Wed, Oct 21, 2026 at 10:47:26AM -0700, Jonathan Cameron wrote:
> On Fri,  2 Oct 2026 20:31:51 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > The stub always requests ARM_DRTM_LAUNCH_DMA_COMPLETE. On a system
> > with an SMMU the COMPLETE option is sanely implemented using the SMMU
> > global abort register. DMA_COMPLETE should be mostly a no-op. It
> > seems to be designed for the region protection mode that Linux does
> > not use.
> > 
> > However, the FW can still do something interesting under it and we
> > should call it. Choose late_initcall as we know the SMMU drivers are
> > loaded by then. If some platform does actually block DMA beyond the
> > SMMU, then this would result in a noisy failure of built-in driver
> > DMA, not a silent security gap.
> > 
> > The platforms I'm aware of are OK with this placement, and it is a
> > reasonable place to start.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  arch/arm64/kernel/drtm.c | 39 +++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 39 insertions(+)
> > 
> > diff --git a/arch/arm64/kernel/drtm.c b/arch/arm64/kernel/drtm.c
> > index 14493948a27f0d..6062980a5d9e53 100644
> > --- a/arch/arm64/kernel/drtm.c
> > +++ b/arch/arm64/kernel/drtm.c
> > @@ -3,8 +3,47 @@
> >   *
> >   * Support functions for ARM DEN 0113 "DRTM Architecture for Arm"
> >   */
> > +#include <linux/bug.h>
> >  #include <linux/efi.h>
> > +#include <linux/init.h>
> > +#include <linux/printk.h>
> >  
> >  #include <asm/drtm.h>
> >  
> >  struct arm64_drtm_handoff arm64_drtm_handoff __efi_data_handoff;
> > +
> > +static int __init arm64_drtm_unprotect_memory(void)
> > +{
> > +	s64 status;
> > +
> > +	if (!arm64_drtm_handoff.drtm_enabled)
> > +		return 0;
> > +
> > +	/*
> > +	 * Currently Linux can only fully support a DRTM implementation that
> > +	 * relies only the SMMU.
> 
> That sentence doesn't parse.  relies on maybe?

Yes

Jason
