Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.34
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794582638;
	b=4+keOnP2lPVfcXRJ1PU5hTvAYgJaJ1XmFQqdxgYL9t2IhulHVPLbyYv0eAx0136/g0Uy
	 ziGPz8/H+szVvHI+JjKEOeBK0e/l92/XspdjskodEzO22XqLMr2CroDKh3tYn3VAWvxnH
	 7/ktyDsXck5uc0hHnEuvoHMwRyZzSYGoX6svwUszbaQVt6yV+VbdES6BcWJX93VUQXxvL
	 wB2IJPU2dXXqGVcRpZ08NEY4HJpx1bEcEioRCRIPEo34l/yaxLD6RphkLzhktuzxosydL
	 AMDqi3YVOI298fEP2sWjZPTS1HXX96m38SZwzNbuM0lWtWInEbzo89/RA+wyI34xGLA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794582638;
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
	bh=X7HBWkDKeLtJPveFqtHPnJOjDe/1YPf7zdpjxOy8T64=;
	b=cAVaC6eu9/ibfwGn30rRXy6FlFIyBq1VuSM7EA58wim2fc1n6VzbYPCtgikowN6h4VWX
	 T5pZKs3Y6R60C3/JdzCe0fbJeLrIVKDIf8dLX+uyvfQBemEKjPqWALSi9N9V6k3w2pEUj
	 Av9IzuThGD64znEZVCT2EefoUOis4cbvT2n+kzaZfn/snuPhHPP9sgQxPFh3pjaxdWafe
	 Bq6CsO8ZJD9t0jqg1yHFiFNeZRd26Psnt5G+BzbRyLrFJbvh+NsYPMPtcN2N+dk57kAF8
	 xjveoR2D3Y5qjQeb4AP8isrIFc3LSecMRFUd8a/YxzSmkXfF/zQTKrKGshc++V4BPTw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=PMyGAsdf;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.34
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010034.outbound.protection.outlook.com [52.101.56.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8547606A33F
	for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 15:10:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C8547606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=PMyGAsdf
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xE5iYvDXnfaVXjK//GxfFOyBrywQEz6Kfiyy63r96OvpR1wPv4v05tFoiviujcJZq44ENbLtlZH6We86jRjzuUSyEH7PcMeCEtYgxmMhDoKDek/hI5rPj4Lq04fE7qqf804KzN/y/c6swPqbyFpVxjPbaZikV6CoEJzplwK+KTr2BUDxUSgYAV3CQznaqxtGX7m9UU/6GBelNQ6wOy0rFTBMIp0auEhJTMutw5E47lKHlunQKwowAL88KuWdCJvb1CSfHLX9M8GXk785/QSiOus9wlziLhUUaszYgMo2lYcF7Yrxj6dQPdlBhV3vxpRbNlpAfgkFExT3w618Rmzlow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X7HBWkDKeLtJPveFqtHPnJOjDe/1YPf7zdpjxOy8T64=;
 b=C+lOjuxsmI3Xfsx8OnHCRYtvw1kR6KWDTvld4ms3YE02V87R3KvT1744+1G0YUeCNAasWwLsc6sNoiJExmsgfSUWXpPqW1ACfdUvU57DSzO00Nt09jHbiAngbXDXxYmuUE4vom22mrUQgutmvtYC7X+wHQLe+Z7Sg2f4hWPSns0wvnNQONoqJjs6ou9mphKvd+cNca3YiKiTLJ47bGjYc/EQ6wOBKaSxnVeZv+lrhKIgLcITNejukwd27YTejgcRBilhxUqHvw6+Y0RRPZNGRZqA7Arty/fwAtvj5l23bFS/dNu+f8yFRglfIAA38lkjh0C6/v0doRi8dkOMZvcFtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X7HBWkDKeLtJPveFqtHPnJOjDe/1YPf7zdpjxOy8T64=;
 b=PMyGAsdf9waIY5s5gezDZ15Hsc5Ic4ya03LFQ52iyCWJjTBXtACKHbUGNXfQ2UGDuzX7p7Zj8uSn1NgSBXuUJpPZzFrgFifwi7ifbqUxDx9X7FeNNJx5Ve0l6Op8Xo1Ga/ldBUzI28qX+2IGJlG4fDSPr+KrF852DgBDVpYKhi7WWdY5aJpjtnq0a1MiaPF7e/16E2mcU2UsDSLJUayCLOufdHhmlOom2uUBHQ1yZKKoUQiYEQVySpb9sRvMhVjBhYU9Ho5SS5xIVGYwTE+cdm2ETrdzZ/j0Dz8w+wkD3outY4MZIknEBhLySzxofYMkhVT2SyVJDLUMsf3/f8TqAg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by LV3PR12MB9332.namprd12.prod.outlook.com
 (2603:10b6:408:20f::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Fri, 13 Nov
 2026 15:10:31 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.009; Fri, 13 Nov 2026
 15:10:31 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 08/10] efi/libstub: Make efi_remap_image() return
 efi_status_t
From: Jason Gunthorpe <jgg@nvidia.com>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 Ard Biesheuvel <ardb@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, 
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
In-Reply-To: <20261110121731.2728824-20-ardb+git@google.com>
References: <20261110121731.2728824-12-ardb+git@google.com>
 <20261110121731.2728824-20-ardb+git@google.com>
Date: Fri, 13 Nov 2026 11:10:21 -0400
Message-Id: <179458262197.3625095.9864111551590308665.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: YT4PR01CA0320.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10a::13) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|LV3PR12MB9332:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a41b124-e762-4a4c-c2b4-08df41983ef2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|1800799024|366016|11063799006|4143699003|261102123227099003|261022115727099003|261022105027099003|261021121427099003|261028144727099003|261026140227099003|56012099006|261022075727099003|261026121527099003|18002099003|22082099003|6133799003|10067099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	UKiYIdk+fUazdQPu3fnpj4Nj5ONZr2QfezE3YDycFPayq0SGmtpO4yKbWlwfxcgv5/z35ALkPxpxES3/nL+GjXy/2nvbzkTVZcnQC6uu6dwPq7DdU9b48SB3esIKa/hyMtYsq4toNjaU61I4p+368TCuMTuganKduMEc6kvUMnYNtc2c/E70813a3P3LF5ju5gAzYyT5tTXRHbBxxEuF+LrcjlTrxLx84Z1vARcUNcHr6NFvGNUS6etbOw4cemJ6sZl2+qCMw09xV/LnhwpbCRrDtzW9wxm2whzXvfHTNSGGZJ7KgaeVVOt9a5heAfr3h+NkXsxzbLyBOYO0ZftWqGRQZVUU9uX9mojVxeZcHcKjIj1oS6ouqSi3wefSSBomEFDjdEtxMlUTDPoFBDd1O0vCbdp+l2HCZJjyl6G9r2rHwdG7meb6B7UF5/ZMZ8aA+cAqf+tsOHWrOJNtiNhQvux3r0lKIt3E0z4RN9IVllqvKetVZzV8EKjdQmyKcde3rLPxS7IufbTNBuDfAyf9M3M/+hH9L8vMrsro3Py+03qTG4KYNR3qe0xVkL591+576OHH7vlMkYrp3JcD5QSZE2gu/I/figzADO+lrHuQTfUqEeAherQk4wyFiquqHxZn4i1cW1B0T6/fPiaTGd1Q7rzvF8G0APmrA7KhB1uuJI4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(1800799024)(366016)(11063799006)(4143699003)(261102123227099003)(261022115727099003)(261022105027099003)(261021121427099003)(261028144727099003)(261026140227099003)(56012099006)(261022075727099003)(261026121527099003)(18002099003)(22082099003)(6133799003)(10067099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WThVRElPYVdRbXBFLzlUQXZqR2M3a2RCaGlQb0FMVGZaWFo5YVZoZkZTK3Iv?=
 =?utf-8?B?OG9OZ051YTM0S1A1Y2lHQlJqeklRaHRHbHhMU29NYi9QRjZFMnoycmI0WW5t?=
 =?utf-8?B?WlR0SUZsem5FdG5DZ09hbW81MHpNN0dYQnRBZ3ZKR2lvd1VJenRXMFh4dlBm?=
 =?utf-8?B?Rmg4Vzc4elZ6TTBPMkp3WXJTUlpQL0o1WHd6dlJxY3owazltNFNaZyt0Si80?=
 =?utf-8?B?aWxNVklFU0d4N05sdU01NVk1WTFvUmNPdmtHS2xMaDdTdGoyeFVLS090cWFH?=
 =?utf-8?B?MnRGR0phWmVwcGdTMko2cnNoL0d6aE5QS0RSS0tUYjhaWGxoZnhIdzdmbW1h?=
 =?utf-8?B?RjlET1I2Zi9FV0xQRDhoSCs1N3NWOXE5TzVBRUJEUjlpUHVtVXNqTlFJYTZh?=
 =?utf-8?B?Visxa1c1MmJMNkV1ZjE5Zm13cFFmVFh6cDFWSmgyRXdmcFl1OWgzUDBmc1BP?=
 =?utf-8?B?cUFEbnB4NUVlTC9GNjdHRENrN0Yyc3RZY29WZmlLbUtGRlZ1UjFPVnVhclFj?=
 =?utf-8?B?dXBmZXF6Qit6NFpzcWJheTQwRjVsQ2dMeGR1QU1ZeVhrb1hXMDJYWHh5TGFU?=
 =?utf-8?B?T0hiQkZrRTRpVU1RQkVjSC8zL3YweThKZ01qUnlkQnpEYUtieXVCOThiTjA3?=
 =?utf-8?B?YmRKL1QxdFV2Zitid3NWK1pySG1TelBESmNQSEFZdlJLSEFxbGJoeW5xKzhv?=
 =?utf-8?B?YXo5ME81bnRuY25xNWl6VGRzcFdmOHhZYW1ZMTI2cm5uRmtPRFBMN2VXbVE3?=
 =?utf-8?B?WkRidkJyWHlDTC96V1FRdlgzWklKRFFQOStmZEpZVmRnU2Yrc0N6Z296TnBN?=
 =?utf-8?B?VlU4ZENrUkxyaFVNUGFWWVRnMm9zYTMwWVVORzU1QXBzQy9UMGV2V2tONzZ1?=
 =?utf-8?B?d3RwYjV5OXc5OEJQQ0EvdGhqdDN6TGtuZXVVZTB5UGVrWXhFY1I4dU41MjhW?=
 =?utf-8?B?SGZ1UjhJZzVYbDdPMGpjTGJTWGZEc24vWHVlaVcvdnpDaTlYUTVwR0RjblJE?=
 =?utf-8?B?KytNSFNHQWM5NnVEbUo0U21rTlg5b3BpM2hicm5lZ3JISWJhamNpRFBtMWUr?=
 =?utf-8?B?ZUNaVWVyNXBDN00wek5Pclg5dkMwdkxEay9WalpDMituM3NuUWNmU0ZKRWFP?=
 =?utf-8?B?aTV2STFWOGZwRnJZVkVSbGFOQUR3aFM2VE5jK1NJcERyTmlUVStJSmRPd1Q5?=
 =?utf-8?B?VzRQTkZLejBFVGt6YjJWZ3VzWHI4M282ckxLMUJ0bmpqdkYxOUtSdkVBSCsx?=
 =?utf-8?B?U0xobFZqM1lWZ3RDZlNUeFBoeFN2L0kvWEZpbzM1N1p1cW0rK2ZYam5RSFZi?=
 =?utf-8?B?QWJ6cStvZWVuWjcwVTBhbWozMVFUcXRZbGlRaHBrUXNHeHppZ1hhNkEvOFUr?=
 =?utf-8?B?QmFEMVkzYm1Hd2o1WTFpUmNudTAvUUEycGYwNkZQaTNBWTE0SWVtYkE4K25E?=
 =?utf-8?B?OWZKYXpwQzlTbWZqcXpYbDEzZW5aUHlLdHNzY0hJLzBEUWZnSVhPcmFxUnVj?=
 =?utf-8?B?VW9RZ0YxcWlNcjV4M0drdHdOcTNyL1ppc2hRUEU5TE40aVhPZzdkUm9Mcytq?=
 =?utf-8?B?NWMyMzZLdG9lTGcvQjB0OFduc0M4aUVsNG4yV2FTUjR0OVpSbTN0aURhVW5y?=
 =?utf-8?B?VEJMSDZvNEVVejJTQ0g2Y0IzKytnMFRXUUZtRzZsMGY4UXl6MkdWd2xBM1Fm?=
 =?utf-8?B?TXNCTE9sdHJaQ0NoNSt1V2s0Zm13cHRBRjNwSm9lSUxuNjB3Z0NyQjhkNU1j?=
 =?utf-8?B?SGtHaUpmekd6RUZpdTJpZG9kK3JHTHZkUFlRNU9wMGEzN3h5bks3K1c5RlJC?=
 =?utf-8?B?ZzIyNmNESW1IODJleGRKVk1oS1pndzFpN1djak51aklMT2hwV0hwUmlyUUx6?=
 =?utf-8?B?UzFjNVZiOEZuRCtCRFBjMVIvNGorbXIwM2U1V3FTd0R5T3NaM0ppbGZuZUN2?=
 =?utf-8?B?T1VhWDBVWkNOeGwxcCtXWEZOdzZrNXFCTlFnTTlZcW9QS2xLcGR1SVNCZ202?=
 =?utf-8?B?QmxnemVReTFsZllkeTEwbjZDdmMwS0JSTlZIejVVV1Z2VDJHTnFtVmpxbjNx?=
 =?utf-8?B?cEhEL3pLRUZSQ3NFNzFqVVpLNUE2RGNDbmI1OU1icDJGWXd5c1N1LzQxSFlC?=
 =?utf-8?B?MEVtTHcycTljR21KdTk5OUNlNmZIWlVZVlB2R1ljeStoZVFzOUNEZE1oUW9r?=
 =?utf-8?B?dDE3cG9oQkp4bGhJSDlWT3JWY3BiMExxTmZUQmE2M01RaGZBcUZhbjUrd014?=
 =?utf-8?B?dk1HSURiOGFEckR3N0tmNGo0ei9xU2QrU1NiUlBUK0RVNlppVnhNVDhPN2xY?=
 =?utf-8?Q?XImQW0VNSidbM0PvL0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a41b124-e762-4a4c-c2b4-08df41983ef2
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 15:10:25.7630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b/nLRrBrVlpCnG4tJix/l3xSiwwnMopWn9eoTOLbzx1NLfuzBHFkGEyf+htuY/W2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9332

On Tue, 10 Nov 2026 13:17:40 +0100, Ard Biesheuvel <ardb+git@google.com> wrote:
> efi_remap_image() uses the EFI Memory Attributes Protocol to remap code
> and data regions with the appropriate permissions. This could fail for a
> variety of regions, all of which are currently ignored.
> 
> So relay the failure status code if any occur when invoking the
> protocol. Locating the protocol itself is allowed to fail, as remapping
> the image is likely unnecessary in the first place if the protocol does
> not exist.
> 
> [...]

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

-- 
Jason
