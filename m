Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.30
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794855210;
	b=TmaX3KaC9lQGxrssMrqCVTuK8yFGHjLDC4DhgIWvflUS/VTjv6tLhsKo0XOjdUEHzaWq
	 oE61CnLjJLPifwHgyyBMpAYX1wL1vELMVXl/84l9k+Y3HLL0eRpGiygCgzJcKmyr6ZXzd
	 g7fwY3i+pm8BVteMtGtMxDtMIX/4b2mY20TyYQ8s7f5T6VDUAySxilVaPMXop+ehfe2ly
	 lNiUqIm74HqEEjTkpCj2+lUD68+cLR3erbpcD8nyh/7NEVLcNX0ZjIvBM+Oy887cY0P1j
	 LeFc+jEzwPGASmwJMrFKL8Jvxf13jFgHnfDhICUi4mjbUfmzAhZV3wXR0g7OzvW69Sw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794855210;
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
	bh=vsrd2A09Icfyecb1cAuaLtJ4zgOql8aWQWPHHdSgkZA=;
	b=0P+H8EQT7nJA6BHee4P9AWhZAOLKVNIBj4WsRM7jfuiNUN5JKfeHQ/YkiEI3nbI8osiU
	 x/xa8dhf+npYg1D2h8MHWazLzsgVp1CIIubPNlyjaKqFaMzbSZXQqQxqVvXXrOcx8bhht
	 VZqr1rNPOokWFy5pPPGcictPNDPsa0VrosKFlC/6NVcLCrc018Ns8pyZGl0oLJE8TjzcQ
	 p+m3p+ZS0/IhOZ5zDlk6L95Rvsd0UC3HiBrQ0Ki032zj28OX9bk2zSTf83K2EDHPPy+X0
	 VizToLW5BsraKq0lmF0RxDT9lTXY2xxAEOy73eMkHVMeD/vZy+2Tx/VNb/H/0jBre/A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="gNLxBNa/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.30
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011030.outbound.protection.outlook.com [40.93.194.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC183606A32C
	for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 18:53:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BC183606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=gNLxBNa/
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uNNTMK0oJtL4OFzUnXW4yxF0cU2lNJYIyEkkf4wSwZbXBXAzwzrY8Qr06QP6NJVSKEcLS+N0VSYd2Z/CDRciWBnqCDFT1smJu84RUgrkiEU7OOwV5SihITvz9mvVSJRDEtjA7BHKWmnbpOsMkl7ejEazJR4IvUJjPlak28/tMXNWsSKh8f+2Yxhok+eTT8kpEAE8q7KzeGAf7dEqGHal1+eqDMEoIuHjhYnHouwIPEa9Vx59QI0ahmeP08+vA14YyHsyDujWCad04zlLYNinUpxcbro1fbDcjNmipNcpBXxK3AHzD2Z47HWY/LkpUU7nn1X0xQ49gahw9+IioCH5MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vsrd2A09Icfyecb1cAuaLtJ4zgOql8aWQWPHHdSgkZA=;
 b=c3qE1XGKcO/uIpyUDUJYThgbn24x7V41sd0qDUk34ClKz4xBb4lSGBRVXAaSSQIRAkxbQvZ4gcqlkgIQzUhsKQgwe8+p8a3AgrDiJujD2N3bvmRSANG8TOeWO+SsDr0823f5kfC3PW5RUnDh9LPMSJvhNgYRvQvCIqQ/okLXeA7TLz5OeKNsH2vSW7pODBMDtWrUoynkpPxLNbm/brmY762MMs9V1+0Yprirl3er+VDo3/kuCKiSnmxlRHVA/TNbjjJnlvB+HGgpzjcNVqLwtjH9rTZe+0n0LJFYgC895aigo3j0YkwnQLByXCtZibi+qZtueTqXTeWk6wyW4wH0mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vsrd2A09Icfyecb1cAuaLtJ4zgOql8aWQWPHHdSgkZA=;
 b=gNLxBNa/xSTuaxj6+01J9UNcgA5nQf0RzUCLfpyTsMPnYITU0P/nbG5O4nQuxF1b1Mn15Ce8tHGnvg7ksGDPM9DdTzH0QzlPtEL4WeMYviOKRzLdly/2Bvw8V0rVzTYrLMl6jk7+cIJTzP81OjIhb8gMn3srn6nrMvsh8uVIZw+amaHUDZSAXALI4HcLNs9H8LuyQ324LQUiMHnsOFLrqrNs3DMqEj0w3yVb0Ulxc0aznMMTFbbK68UvNiyfITVqJL+Mu3pzLlwr4dbz57cIkrWnWjt8OZzTRtLtagJWuMz4ETX9N9AgdqqEarGL/BsVZ4UXW5a3iQdAMGLRzChOqw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by LV8PR12MB9641.namprd12.prod.outlook.com
 (2603:10b6:408:295::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 16 Nov
 2026 18:52:21 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.013; Mon, 16 Nov 2026
 18:52:20 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 05/15] efi/libstub: Avoid _end section marker in
 library code
From: Jason Gunthorpe <jgg@nvidia.com>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 Ard Biesheuvel <ardb@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, 
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
In-Reply-To: <20261116142618.1687025-22-ardb+git@google.com>
References: <20261116142618.1687025-17-ardb+git@google.com>
 <20261116142618.1687025-22-ardb+git@google.com>
Date: Mon, 16 Nov 2026 14:52:15 -0400
Message-Id: <179485513559.2274641.7774247172930179296.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: MN0PR04CA0015.namprd04.prod.outlook.com
 (2603:10b6:208:52d::26) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|LV8PR12MB9641:EE_
X-MS-Office365-Filtering-Correlation-Id: c185f34c-24bb-4738-ed96-08df4412be40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|10067099003|11063799006|4143699003|56012099006|261022075727099003|261021121427099003|261022115727099003|261026140227099003|261022105027099003|261102123227099003|261028144727099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	I8kzo3bMleQZYX2Lmo8KlsAlcCiDSwhmktL0UwQjm7hKUDKWIcLxUMLV1/mv1Xm0gUQqCAbohZR3psnT5H9YB/cS59rb18OvlyJrtA5hvMxYkwoEXpEnkP0tnH/rngoigPf+KWxKTEaRYoCzEe8twRaCcnGsAnCAmz9dBciz+KxWbRbWrBRuOJnOSKHiza+bqe+yAkLaorLmnu4Dgn0gqKkZsqn8x0FGPKtDRqYsk7pV1jpjAqm5Er/JrkMN8TZfBaEIkozdohvw4vPGAdV0NfKPNZcmKBk6sIppJ12lrtp9gmBpMY6uXqUuLFAvcZ7cgRFXrqHz3b4VRlkXnhvkKkAvMT9SgLKjT0Q+M/aJj0SOnWTUfJu1wa79gUXg85PdDehtuluFL/kdsG0O1aAA+d9li9VA0Zox6hdIdlP5bQsqrXp2Z+eOIX9/6XvCpzPYv75OTTvejPMhS/ZrkzzylWeMZw8zRx+MdNfMQtjS/tUtA+wWxToQGzke2dQORh7VY3dTntQZb+jZNb7Xh5ajmEUTVvW8O6XS2ckdQ0ThvCwkabV6ItVuexDz/EbwRaCzveIXK2CQb8C55PIb8MVaXFcIn33NVE6XOfo/BcoFv3D9X+4BEqjXfWVg3JoPKkdWIH3k1WyePNo57ElLbFwnUJRe3E8gHsRp8gNY/ZICK5g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(10067099003)(11063799006)(4143699003)(56012099006)(261022075727099003)(261021121427099003)(261022115727099003)(261026140227099003)(261022105027099003)(261102123227099003)(261028144727099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UkpBNDJETFBMcXVzSnRmN2RaUVpmTDFnQTVYbUFWbEdSSVFyZ3ZjYmhuTzhG?=
 =?utf-8?B?QWxKUFgvOUNXWndLNVdDQzZxVWJkQ2hVVWw1Y0tPM2U4QmlCS0h3ZWNCL2Ir?=
 =?utf-8?B?Vk5kSTVRZWR2TFJqYk9JQXY2amJoK0gwR2FrSmdROTRzNVNDbU5NWDNSQWhs?=
 =?utf-8?B?MDUxbGY2WWQxZlRaVHpwcFlMZG5ISmk4eUluaDNFNFJ2S3BKWWJuNEVwc0hE?=
 =?utf-8?B?ZjhVdVZ3aUlYSVMrNi9aZHB4Qm1CalI2eS9mVUNHZUt1S3NCSjFXRmNwK1Nl?=
 =?utf-8?B?YkQvc2NabHVEWmRLVUpaYU1YTHpETmx3aG1EbnZCK1BTYUhwWUJpam1SNk1G?=
 =?utf-8?B?RTR1RWdPWFNLVmVpS3c1K1VsVXY3bkZhZ0Qzd1dYNnFwMUdpaS9ybUkzeWlC?=
 =?utf-8?B?UEdUS2NDTVZFOGRoWXpCVXhzOExiRkMycDZZbEJtUnJXTlV6Q1VHUmlUU3Rm?=
 =?utf-8?B?emtUQndIa3J6VmJ6UFh6WjFCRXNWQStnR1g4Z01GcHFkMVJpSHo4WDJYMXpt?=
 =?utf-8?B?aFJUZ00wOHoyMnNaNlpiSHR5U000SURuUTNKc29xUSs2T2VpajNIS3V3Mko3?=
 =?utf-8?B?dSs3RjNUMFZBZ3FFYTZwMWJSL0NrS2Jub3F6amhSUmUwY1BuRTVEVDltcGZB?=
 =?utf-8?B?elpnWVpEZDlielRWUTZJVjJJeFg5ZGZpTUhwelVrcVIwUDZGNFIwUVN3ZDZH?=
 =?utf-8?B?NkR0cENvM1lBT3lxRXJkMktwcDB6K3dKNnFkeGYyMWVHa0xUWkZJZmlUYUJT?=
 =?utf-8?B?RW81OFNiaGhMRGlhMGkvb0JpWm81RUszMlZ1WVhjR1J5RkNWYklPMkYzYnZP?=
 =?utf-8?B?THVQY3h2NlMwekRXMFQxN2JadllyTzMxeUc4TkRIVGVMTVFqeG9vYW9tQXFY?=
 =?utf-8?B?dlEyRTFTMXRFdnUzTSs3S2dRTzdWVG1yNkt4dFpPemNOdTUvdGN1bzRCNlg1?=
 =?utf-8?B?dkQyMEFMT3dRd3BaRWtHdHNDWWRtWUZQNStXQ2RGdFEwRVE3cm03Y0RLM1o0?=
 =?utf-8?B?bTBUbGdMSE1ZUW4rN1c1RGJTaXd0cHZ6NlRRakpLYXpBRUJGWEVkSXp0VWJI?=
 =?utf-8?B?bGVWbXdzdUVYL25sSEpERWo1b2dhTFkzM2xDeGFUY0xUTzlwTTI1cXVucWJ5?=
 =?utf-8?B?ZUY4UVpzeXUyMTRsaUZLYzFyaVJCbE5nMldSN3J1S1N1V1RvaHVWRjZjU1lU?=
 =?utf-8?B?anNVQmtTRGg3L0ZhbFFGdVBRc0E2MEprVGY0TWE1dHY0THNvVHVSTzQ3V3l0?=
 =?utf-8?B?eTN4WW4zQzNzelNFcTZ5Vk5FUkdQNXNtS3lPaFUyV3FGa2RsaTg2RkJ4RHJq?=
 =?utf-8?B?a2MwQXZGL3dZTmVoZGE5RngrZDMwNmhiOTNjcFdxWUU3MEh5UC9CMEZibmZV?=
 =?utf-8?B?VXZBblpxMWx4cjVOSm43Z2JzS01mcXpaYWsxZFNJNTkrR244YW0yclUzaVEy?=
 =?utf-8?B?S0huV044d0krOWdXQWg0L3FhemJlWmViMGtDRFJ3OVFhNjAzMlZidy9jd2lV?=
 =?utf-8?B?UVo1dmRxckRGbnJUSjIxWUJjUVR3RTNqeUFvWUVISkpYcStTaXFtajV5K3Nm?=
 =?utf-8?B?Q3NBcWdpREJiN0tkOVZONFJaSGZZTlZxUWd4TVJNOTZPME8xUk9hUVdLdkpo?=
 =?utf-8?B?blNlTG5mZFJkL2pRcEhhOEc1RlJiTVU0VGpKa3JwTC9mdlBIdTd3TkZGc1U5?=
 =?utf-8?B?T3czZ3drVG9GT29Db1JZQy9RTDJqb0ZZVVh1OWRLWU1rNndNQjdkYm56bEEx?=
 =?utf-8?B?UGhHYllmUW9WVUJlRlV6VU5UNlJjdm1aUVRzK1dQbmpKejRxamhXdWN0elo5?=
 =?utf-8?B?WTcxQXp1cEFYQTBnMkpIMXF3VE9iejhMTXJtOWEwSURxY1VodEVqaXBjSTZM?=
 =?utf-8?B?TGtTd3ljWUJsY1dCRFJETHhmdWtUc2Y0eUVvV3ZFeHgyNHQyVDF3ejFIQW44?=
 =?utf-8?B?ejBwWU4rK2lpajdMRS9FNEQyOXRDS2Nha0d0Q2pKV2tkMGphVW0rM3gweS9U?=
 =?utf-8?B?dWY0ZXJCZlJaYi9VSmRReXorRjAxQkdrNHhBenlMZjJTeStWZ1JVdi9VRUhy?=
 =?utf-8?B?QTNpaElxRXdaVkE3RjVkTllLZ0w3aFRuUjh1ZUZNUkZYbVlNWU4wQWFsekZy?=
 =?utf-8?B?dmRQNUJhTFVEK1RyWk8yaTRJeW5ydnd0VXhMbzVmZ0dvZzR6NGwwb3V0QkFB?=
 =?utf-8?B?VlhkT3ZVU3NwdGZXMVRmUi9kUGpJalIxSUw4SXk5TloyYldQRGREY0hNcnFM?=
 =?utf-8?B?OTQramJjVFBoRkpjVURWV1lwOHB2WGNwMlNJMWo5eWxMQmFpMmJzc1hLclNX?=
 =?utf-8?Q?Tf8v7IkhcX9/Clx80z?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c185f34c-24bb-4738-ed96-08df4412be40
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 18:52:20.2977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xBS8+qM1C+TNlbAtTY746sFqUQ6GKmkEPRHylyovBnwDPIZv4AuO3aOK2XVDFhQj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9641

On Mon, 16 Nov 2026 15:26:24 +0100, Ard Biesheuvel <ardb+git@google.com> wrote:
> The _end marker could point to the end of the kernel image being loaded,
> or to the _end of the zboot decompressor image, and so it should only be
> used in code that is obviously only intended for the former case.
> 
> So instead, use kernel_memsize and the image address to obtain the same
> quantity.
> 
> [...]

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

-- 
Jason
