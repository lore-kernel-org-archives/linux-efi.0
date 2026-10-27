Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.61
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793115670;
	b=DvW7H3hRmVFl8kg/Erunu+nmMWKR/oiRDHwvtiJ6QwTz17U3nYD9MxxsDIXgA5lOZgDr
	 x4IsmMiih/GaYy2Yyq63t/YLv4HKlA9yafabHVknYOXmDBxp3QPMkoHVpapZnus0ideha
	 vo6ge2md4UdyK3QMJND9zTOC0wGcwqSpf3fXBQdKf5M/AQOwza6sG9PcXXjsAn/ZluUiq
	 LM2Q3jThh/60yoRsVkvOeg+3z32HaRIaM1aktJdRtPAFO96UdiJzDZEg994Ka2zTMsGIt
	 GdlK4dN+Eh3R971Kl1Z31Kt9XrqSserbg95WkqORscXPikKy3r+lFqg0e+9cnVjJ2AQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793115670;
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
	bh=+p6nG3kPSl+4+8AQOLFlHL/hfyMc7R+DO34PRO5plDw=;
	b=L9phbQSa16HbyWHPH+vDW8TEyInd1I9krPN2i+a65DXELMTzsdxvxFXDwwvlh6zl2AH3
	 2Yt4cmqiwID1eYIAittA/96uUygfBSnnjw5gkzbfS8IEVOOcExUuH4Ax/l7u3pvuOCm6u
	 lA+02ELZ2d1AOxTdOHePfq3DVkeDPZdIVTjePiY0rO5DjRnN/29Dlf4/jP6NN1voYcnQ2
	 AiQNimIjJBV43KvzIJLyj/BReP4Es3rN1NAZskMmtrJiPW78SH8oooP1AlX5gPK5AOvY6
	 toQdwG3yjg9BdUwhhF6Radu65udgTZjml9pCEtStetNfC1PXnowHNwqIjkzCugG/jSw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=LLeSWfiO;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.61
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011061.outbound.protection.outlook.com [52.101.57.61])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A22606A31D;
	Tue, 27 Oct 2026 15:41:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 80A22606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=LLeSWfiO
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KIOqyPRFCkjBAXqzSjoNa+17XK/+sVx6w7pC3+7g8mN6qf8xGfSxkUJSjP4nlV3xASG9hfTdF8fHpdve1uVNg1oPbPoZ4qMSEy+1+DuhJO8fMPsBvwE1bZrpwX5n/7xtSJlzNVAHRixRzCbT0/7VtSmYKQc+wTDGXnXSWXGpZT/X4psWsPkAL0emFEsdbhInpYCIhzb9QIHYPJkU3cwAh48YVkMOw3aKYEbyaUXV4SPq0ZR7Uvnl1VS+DZEfWpSvGROAKbPdJgEoKmLP2/m6L306Hl6qvKZ3HV9SH6VL29w4HGHe5dt9iLOEiT2NA59DHXStHD/NoIySdjqtGyVY7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+p6nG3kPSl+4+8AQOLFlHL/hfyMc7R+DO34PRO5plDw=;
 b=eoZYhd437ANreRdHZg5D+C4tcRcWo1pFGCUzUj3cTEOksxyYxRAgPp2LykKPv8vmcXIZt1QSNLfE99nMDvkxaQugrDn2xFuKMfYiAqbYTHXa+OF+KJ0YlkoYgyKOu9x0rS483YDCaWaNX9Zo59otUKsHm0MWab7eHo6j1rfC/Napu8eYUZ/g3RaiWYNd/kR7QQuzZBxz2qAhNduC28lLeMyLhzQMgQP0BHwKXBwkWq4ok0mKuf2gPf+0dlqaKdQmn1s4cdxr0+iqiCXR+furq6sc7rYPf6SRrRxpdyAf89cLW7oFcpXdn3hspJEqvZC7Wd0OlLYZGdU6A6wN6Gd1Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+p6nG3kPSl+4+8AQOLFlHL/hfyMc7R+DO34PRO5plDw=;
 b=LLeSWfiOz2LBiJdTEhJNpvpnhFunZNVbsoixbyFiJdRHtBPKhmbZY1iqi55qESXvABrBoq974rlCkd3F07a+wfkNR8W8mpm2A+1TwvAdLYS7IUzd7O3Y2UZiaGEWXIYpNXclDKbvHFZt3pHdS38kggOpTBQ4o6bDuw+Mdz4x02q0uU+CB4RX52TozwkZhzRyp54k2+2vtcCsgAx9jTXmJGoOaI8YnzKxGw3qNI2CW62q6/udaDlzFOeJ0MgyXVpni7GwB/xnA5M2/xw4uO5gjDj02X+CcUp+BAmaoj54z34dPAo0Ow59sVZqKuB+pboYdf6znHW9O8OEQhjawVTd0w==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by CH3PR12MB8993.namprd12.prod.outlook.com
 (2603:10b6:610:17b::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 15:40:59 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 15:40:59 +0000
Date: Tue, 27 Oct 2026 12:40:58 -0300
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
Message-ID: <20261027154058.GC2418472@nvidia.com>
References: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
 <14-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
 <20261021104726.00002640@oss.qualcomm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261021104726.00002640@oss.qualcomm.com>
X-ClientProxiedBy: DM6PR02CA0137.namprd02.prod.outlook.com
 (2603:10b6:5:1b4::39) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|CH3PR12MB8993:EE_
X-MS-Office365-Filtering-Correlation-Id: 4dc8a41d-9990-4fa0-11aa-08df3440b2e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|7416014|261009223027099003|261021121427099003|10067099003|56012099006|261026121527099003|6133799003|22082099003|18002099003|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	WYfQwgWB6bwQkl9kW9H+qaXPaHSW5TBrI7lXo3o74dC6JiK8y+2qGMHQum3a7DJH/3GUy4jRpWBsrKOEGQTmATEkrowUIDhI6I/U4QvgqhG6R1qfTlbVUbjp+9ktFnOIr+i89dkrNTpojCshn41dJySpSOgyddn5Nk3bPQUMZhVXEaoXGQJE5Y5hNdk9pt0TK9B8WyD2426SPA4OD9mR+CMYXDXswzxWsuEEbmKCrWKNPDYJ5N1Hdgt9HpuPCHHrpCj2xfGTpVuipEQe7u5rfOro6UelZ0o6EAF2WyyWEpMyMheO6rcBkuAH7RN019hgo7bZzEjbfDiD29Ksp5jUJd5Deh79G+Lcrgkz+d83PvVVW9S8DVywt317hpqWEFryNlxhOu2Rqdbu6g1+22sZExzZNWdtdUr+XLbJXvdMtZdEcls1kMr3ULUMwuORtFJGSSlZDNKFoTYz665LI233f9/Nt3PWy5ITcz5X1zNDcBvGFfd6ERiiYVCjdKOifm1T602RhNVKYUKyS4DPX9ciGr1fBpOz9tZTdbXoFuS4zZHZEyc4WnsOu3A3tB2yflGhNKylxRZ3j7snrgB6IgvnRHrmS0USZIqp1Rp39+DC0N9NYMlWYEsd6U3GwpqKrBxUcVrEXurDI92723VI2F+K90AAqSr4WLCn4tam6iPlFzs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(7416014)(261009223027099003)(261021121427099003)(10067099003)(56012099006)(261026121527099003)(6133799003)(22082099003)(18002099003)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ieIOZouIj29AK3ETQ9CRvYw4WbvTSS76ExTfs5WsJV40phZZKdOhAvPZGIGm?=
 =?us-ascii?Q?tsIKx0voDqmKcmtHwPPC4yDaOPEwKmP15mzzqWz7X0j00NomrUKxuiTvvVJd?=
 =?us-ascii?Q?uckGZCPP8OrKSX1EVF2qFznk5BGm3GjHhhgTkBgt8bILto2rl3Ad7FU570Xy?=
 =?us-ascii?Q?jiw2HGSqsyxQ1/Ks2SO8pcG0+i6oSx0WlNigtnRt03YOM8snb6YNGOmYfqaG?=
 =?us-ascii?Q?0QYpw4nZLisGpZmjRLQ9XCfPMgs9S98+sIY4Ldzw/tmUVTrS0TvB8U4jbHv0?=
 =?us-ascii?Q?I2f+BPM7Oit4ZCvqxmDFIrh+I/bIyaEU0uLu8nnOBhWPioc6LiEtvfDnl7Md?=
 =?us-ascii?Q?5NmtgYcGsnDHSsqU+NiEYDPZUXHT6rnfYzxfTQesCwdaLXBJdCY6fn4L3fYe?=
 =?us-ascii?Q?tScZSgh8UYBbhTfpYneKaH080/fxssn6y9qOaCPyZNDllxjz+Oo0AWfSRWy9?=
 =?us-ascii?Q?yclgzUBsHRUAkiq6PZGzsfvJhkyhN1bcBZS5bb7Yr3WgpTM9r4fxdTy4pZqT?=
 =?us-ascii?Q?OuOzlRwUl+j4l0iO2F2/06eJq2XXDeeLEF5NbYpopdjWQZPjSm7OrBXxWt2h?=
 =?us-ascii?Q?t4qd68rLBfZ05M6N0kJNUy5yVLj+Mo2OhNMkUFzJ69xzaMzjbZZEncA/zlXM?=
 =?us-ascii?Q?2CA58wOP+sTuPH9zh9iGXutCaTUtqlQZdwT2aANpjM/lkMWVIVfshUynGaH/?=
 =?us-ascii?Q?KeN6N/f0Bl4b0cOv3A+3QBTVp/ITevzfaoZeiUKslSIdhTugafQVs4O5EkLn?=
 =?us-ascii?Q?mkYHJ7DoS2FPpQ1jdDJrm3Dy+/nrdefWqEioXj4AS8wDfDwwZceaILFbHA7a?=
 =?us-ascii?Q?E/iD9E6vtAQyoFQEZLLjqeIHB81mmySJn8C0H5XfTVi3wftIJ1SsMYeX43C3?=
 =?us-ascii?Q?i5NX02PQWBhUuSlww+/a7vLb1DaTyfl9Umo37zKtyizJqUK8104Xsey/6pA6?=
 =?us-ascii?Q?JriwUvDdbUZN1bKU8QQXCkPDsO8Xja7uGug8ZKYiio8tbrDJw+NcTysVZbwI?=
 =?us-ascii?Q?nYX1AqmQuJ3OWIc28lNBHmyeY6nZ/c0VjxVEDg6Y+xEgzkjQIQNihsHpkfM3?=
 =?us-ascii?Q?uAX9DN6yb1I7EmWKmoq2XPWzLdffpBuVg/tIoX0cbRuYudu+pBEUvMZzsCgY?=
 =?us-ascii?Q?vy7nsppkmQP4WyouFO3vM4oSklkoR7jkrID2KJShlz+fqCffa2o0LdOoVRIK?=
 =?us-ascii?Q?+PSSGdFFkyR3p3YV94SvwBam3AMDI4o5Rd3qFYa3UEsybDffSgyBQ/XETcra?=
 =?us-ascii?Q?FeVd8Meehdh1d5LwBoh1Wk9EV751zPSGrUhtDIIDc2+AZJBChMYj2bxsxfBF?=
 =?us-ascii?Q?7nxCwwt1taDCgtjFIPnz+z+CiuDa7lwOw2HN5vxm+apVs4edK2aRNYim+/GX?=
 =?us-ascii?Q?4BlAtn6EGEm4RysFzmrQFpJZYkeSvWaX2UCyNaD0cIxSK3XEoiUlNvraxmfV?=
 =?us-ascii?Q?0qmfvK5VTdkEV+ZIsyqnhlH/iSozDSbKXaSoUX89FCGJo7naWJauGjrpPs17?=
 =?us-ascii?Q?Hz6Awi8dJwMzAsT1Rzxqtxrnr0qb3OmMdv+J8E09jISkgdmoOIkf7uo2Wzxe?=
 =?us-ascii?Q?IrAhFsKrCEslZ2ZK3VxjPyz/x6C0EMsmZCvHLBd5yktrqZt7hw8ioOlbTGB8?=
 =?us-ascii?Q?fSsHm4ii3ELSp2XX0JIEWYV92QP28rnFwp6iH37QBpb44yoS+HlJzEuVJMoP?=
 =?us-ascii?Q?MxN6ceYei+HmNtqBpElgrhrOWpQl3tTo7XDuWQnxyEKiM0OF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dc8a41d-9990-4fa0-11aa-08df3440b2e1
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 15:40:59.4300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P8uXy90GJwgZWWkj/9pI//nAJntZ4ud4twNrzvhtNFMT7UllTuVPRWEU+HNylLyf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8993

On Wed, Oct 21, 2026 at 10:47:26AM -0700, Jonathan Cameron wrote:
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

Yep

I'm also going to move this file to drivers/firmware/drtm/arm64.c

Thanks,
Jason
