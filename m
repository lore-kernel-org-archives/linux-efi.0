Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795195774;
	b=IPP9/lw7qON8AhWBldQWI3st0WLaH1HjV4AQotjzjfE7nCr5r0tqQP9HJ6bHC7be2sf1
	 gHx0oW7x2SuRfHAnuC0wk9GaiWqpaceA7UJmPsw8tAMza5+xuFe+zCYl+4orUq4blqNFX
	 FbxjHlZs61y/z6YIPYfTBHAFDNg1h/iUKVK2E+DzvT2vTJg7JIAlKn1U60sV4FStbWClT
	 FTUSio/Z9pM3rI7vUV19wWnxbds6qvnI9Os5qLYTqa2nC3FSOq0MhTVs/mB0IUKW1u4/k
	 ATRHc/hVU90xOpEnG698/7YvL1n8sJwy9cIIRyTWw3AvmNDVqwExPc9BEunb1UrdwSg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795195774;
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
	bh=fbsi1moS3AYFu6VpvnD9001Sbto95TscF9TXzH3pjFw=;
	b=KUeK7k+YaEoZ9pRHFfkGLgfo6/64aXhi0YeCfuTUcqb2UTJmn/nP0rm2Ul9bWSuupqy+
	 lBqTdGjl0iXorKbeUX7R9LinHOgtKYeGW53L10onZCdqgaHHDMZZD98KejqeuulJjPUcf
	 PAIeyDDzxNAGCwDqaRjxMG52Irwj8Q/X16yWUgU07PSh3q99LJp+BCR47QFYGPeRC7kO7
	 YkgqOoZQ65fHML5uiItm7k7Ujssxo8gLnhAnckVWoj2H9+xt/Xj82NHyuPt+ZQ5xy74fz
	 XFbugb3upDbh/ctMVissOW0zaOngPkPk2W2770Te3zvSWDr0UqwxVRcVaBHzrmNPgrQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="FDfoaW/Y";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.48
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013048.outbound.protection.outlook.com [40.93.196.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4914460A260C
	for <linux-efi@vger.kernel.org>; Fri, 20 Nov 2026 17:29:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4914460A260C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=FDfoaW/Y
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QEtkVPcukGKbhKBjS0hBTadjYe6TTjfYmTzxKpdfUKRFG3Hsl4IHt49L20dsCCmTxZ6A7uJ50V8ErYIypBXG+uwUolv8gwxHXd05hBBvEufStPZw+XtY2mVOXOZ8bIFWELj0mA/r44qJIe7iRs8UWaVtC2/trbJf0avBx79nKtjsjQHeStdyXSdRSsuhQZoFXwRByF9UZ6BDfy0GhXbJOToyHVoNCOn4dRlDnYxn98PSEVdpBuU551E2QfO5+lOYLPIEZ7oouG/UKno/cqS6/GmJPxKXVWr8XJ6qJBeGmPhz3kSpqg5NeYo1Q5S5AnmnaGwpE3YeLrUR280purxtGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fbsi1moS3AYFu6VpvnD9001Sbto95TscF9TXzH3pjFw=;
 b=y4In0T5YGwrZCne0AQpZuU5Evi23dz5BHMLaAGtGlPrdcden/g62KZkgNW8rW055JyUPggHjlvyWSD4/l2hI6RsxRMEfmVtYZTlUNrR/ZoN1PHF//DlZ1CUTTHFpg5YpSsCCyF04vQ36Qvgorhe61fay0AgOpv1VGvpe8oAizRxkbBjJYDWMopPjxb1IKah+xtrnCQcU8Q2fCm+tz6RjCDMrJXZGyCnM43myH1f98FpzNtpgmbIb8k88VKEbCWVHSnGPwZi706BztKKt7mGrFNUo0WwVX/LiB3+IvxHM1cSVglIAKKFBzP4kO7+3yNsLqz4CqAmmES16ijhVm9anJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fbsi1moS3AYFu6VpvnD9001Sbto95TscF9TXzH3pjFw=;
 b=FDfoaW/YB2KFjgzVWxAQVOtKpvY/O/fZ5XkSJVhlH7qgFjDjPC6w+fLdpExjBz3ZodcrjA+sl8MFbNFGeun2HfL9VTMX/aiveS56EbyRYp5oIc4zPh1Io8AJErzlYDa1L/6ShNi6ddH9YYAP38Z0Bd3zHkVkqdlDrCCYBjqOn/7CkLSeMGdXa/Q8ny8BXwpumsv4BaSK8oyjBcXH7epeYd4tH4sfGG/BaQmdEhJ6XOFRvEmxMHqfxTOOhEN7/wi747FrGnG4bJCMht0z72zqU26iBiVDQ+n6YpxsOUJhfGxHJFlo9EJ9hUMxokiLw9rQeFV2/ptGoXZ9pAG+VM3srg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by SJ1PR12MB6099.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Fri, 20 Nov
 2026 17:29:27 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0639.010; Fri, 20 Nov 2026
 17:29:27 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 10/19] efi/libstub: arm: Simplify
 handle_kernel_image()
From: Jason Gunthorpe <jgg@nvidia.com>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 Ard Biesheuvel <ardb@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, 
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
In-Reply-To: <20261118182105.1633603-31-ardb+git@google.com>
References: <20261118182105.1633603-21-ardb+git@google.com>
 <20261118182105.1633603-31-ardb+git@google.com>
Date: Fri, 20 Nov 2026 13:29:22 -0400
Message-Id: <179519576290.392094.16129574021379744569.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: MN2PR07CA0020.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::30) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|SJ1PR12MB6099:EE_
X-MS-Office365-Filtering-Correlation-Id: 1839ebba-2178-4b0c-136e-08df472bd3cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|18002099003|22082099003|3023799007|4143699003|261022105027099003|11063799006|261102123227099003|261026140227099003|261028144727099003|261022075727099003|261021121427099003|261022115727099003|261009223027099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	hbdy+MhTOWRVurZEau6eBXD/K9ZlBdi8geofoO6kgJWKFUq0KyFKHzIoNF0ysTi1Mp3+TM/+78zy0vwMSw5svoNChEkxaR16BpihKZbCc55oBsgw8GzBLnKQmwBNG7N6iN2q0JDlBNfDm4H/gI28v3BuEQln8t7LZfUkVmVCf4TeOgjTupTqNDRfl+hcXXaCncDO5ydvPfYbiXUDoW4Bmptgcz2Ytzz5zPc0gbYtpvpJ1iIIZ1MvyuXze+DsKEnW3ReonIJjMqQHWOiI53LpMGVwSDiX/twfbOPi1W+qLzqbysEoB3YtHFmIa/1E1vT3o63k2cDIbLKB4QWPkjohdQ7uuVb6+gIY28i9SpwmEUM4sdy9MXrURh+pySR4LXEdjlPB+XQ2f9fF1kjwWZX3p9NDI1qAlCFpV0rA95QFobpkv+uWt9RC6Hbf1Nu24ZWdnVu/gsS51XsEjdtRkhWVbzQvOkC2XEVgpNYBVrGiKL11shYKALvuropg1LzAjgAkxCkJ0trxtafhQ+7ec/NOP17FsigX9DwdSbl0uxyUX/wsV6ZYnVFkjruxr4b5uGitWrxi0J+e6I0qGjJghAa0I4sYAzSszdOJdRTQ2DVw3o79Ma+bUG9sEF9hv0FsSmUo5GeLRdztzHGIHrJ+p7SRLJaRVFw6b61f3SAtLYEmKUY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(18002099003)(22082099003)(3023799007)(4143699003)(261022105027099003)(11063799006)(261102123227099003)(261026140227099003)(261028144727099003)(261022075727099003)(261021121427099003)(261022115727099003)(261009223027099003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q2NaYVVPNjM5UXY0dnVaSE1OUHNXWG5jOEN1bi9mVTFEUDBzY0YrYlFGY01Y?=
 =?utf-8?B?SEdQa3RTZ1ZrYlRZY2IvWVFJZDlobVpoMTJsSThtQmN5RjFLR0RybTJvMndY?=
 =?utf-8?B?c1d2RXFhSzAvazArZmhRUFM1dHVoRDUrZUxFQlZHNE1kQlQzWE5HTFhKMkhZ?=
 =?utf-8?B?bEM3aDkxdXV3TUg5V3RGRmtsajNISFlzOTByTzBQOUlwdmg1eEtxOVhveXEr?=
 =?utf-8?B?RXBBQkNMZ1EyZ1hycWF4VDgzbVZNMTd2ZlU4VkErUDQxQWpJMS9oWUtDVVZa?=
 =?utf-8?B?ZUplVjZFT21vYVJscDROQWJ1VDJTV2VnOVBJOGlCelgwK1MrVjh4cGZuTnNa?=
 =?utf-8?B?a04zSlNqT0dGV0w0eTZpZjVoTTJ1RTYwU3lTR1l1WGwyalBSMjJZN2RGZzhR?=
 =?utf-8?B?WWc0OXJpZk1tQ2ViRmZXMnc4QWlpY3RidWNXbHJFRU5Dc2s5V0ZWUXh0ZmdR?=
 =?utf-8?B?TVZaWmpEcWdwaXJJZVR6U3A1azYwdElBaUtFeDdsSERKTFMyRkUzek1uTmNM?=
 =?utf-8?B?WjliRnZYZUFHT1BGMU1zOTdPamFueWU3RHYwTkxhZHJNV01keGpvMEZ5ZEI0?=
 =?utf-8?B?Y0FKQjVLclNBOVZTdDYwRUIydGpTc3dhV0NGNnVrQVFiZi9LV3p5a1ZxWUpx?=
 =?utf-8?B?QWpRZU1kZXo1SW53U0phaUpkWGFOU2tuVHFKRkVVQnJ3L2IzRm1WZmlGbFUx?=
 =?utf-8?B?OTNYSloyMTdWbE1kaEdNNFIzbU5vWXZCZVMyVHhWUEN4K3MrejFydVUySTM1?=
 =?utf-8?B?N2N4ajk4MkZ2bXJMUzNLK1pOOEpPb2prNjh5MVM5T3AxWGNxVUdTT3pqLzFR?=
 =?utf-8?B?TlFLeTlMNURpMHRCVzNlcGcrUlBmOVh5cG1lalVTWVFhZWpOTDcrKzNEb0ZR?=
 =?utf-8?B?K3ZubmZJdWNFVThZWDlYa3Bja2trNlFzczA2MFdMdk9keVNSSjVTd2lBVFFL?=
 =?utf-8?B?T2V5MGhSNkJqenZVcmhZajlsUDYrWUYwK2twNUtkUloyMnNSVDJtWmc5WnA2?=
 =?utf-8?B?dEUrVWxXbVpIa1I5WGdXeDV5V0Yramx2cFNuVTJwWFY1eC9iSnQ3ajV4YzdM?=
 =?utf-8?B?NWc2VmN1QzFDV05CZGdvb2krRWZIZFpXblM2NndURnF3WkpLVVk0TmRJZk9J?=
 =?utf-8?B?OU12ck01NDFwcHU2L0FoNWt2ekR4V2YzVnllYmRickpnNUY1ZjRxVFpyVVdk?=
 =?utf-8?B?QTkzRnUydDZRZXZqT0RFWE94QjNhL1o5NHRDaWtoSVo2aDdPMmdBZFMyb0JE?=
 =?utf-8?B?VDdqM3NNZ1FaK0FkT0xqcm5McmpXeUhQOEZyZ25CdkxodjMvS0p6cDVscGRm?=
 =?utf-8?B?RjJUelc4MVhMb1FyV0F6c2tRN1RaMzZjTFZ3WXg1U2FhRmdaWjROcHBtbXBM?=
 =?utf-8?B?YUlrd2Q3c0tyWEpjTkM1VmZjdVo1N21IaWE2VFExTjhoM3ZjUHRtZm0vT0Jy?=
 =?utf-8?B?dXlNU1lwc1VKSzZ4NS9CNFR1REkrZnYreUpCOHN6eDhHKzNTMERzZGxjMDZx?=
 =?utf-8?B?N3dBN2VJbmhhZCt3dEpaY2FPM3RZMi94MkVoQWFKV3RoVTdKY0d5d3BjczRI?=
 =?utf-8?B?UW1sV0J5Ykg2TEkybVlNY3UwS3RFaEhDZzhndTNBSU5IU2x4c25xOWlkSUxM?=
 =?utf-8?B?STM4VmhoYXBNcW1SQk1qYmV4a3l6N21NcDBqUDZUL0RMQzY0RnJIVjVPdlRZ?=
 =?utf-8?B?cmg0VE5JN012K3YxVWJLd2VDMVdDbFRXaE5OVDZkK2FFYjI0Yy9xcHoyQk9x?=
 =?utf-8?B?UFUvT2VSTk9ZMWFPN2loL1ZNNFF6WVFMQWMxQlFpRVhuUFdQZDdGbmo0amNx?=
 =?utf-8?B?OWhpSjZiWDdNQ2Jkd2hPZks2QUdta1BMUG1CSVFLMXRpZDVnZjAvVUtFNExp?=
 =?utf-8?B?YnJ6QkNxNmVhQmdBQVpKMGhDZ2t2ZGFPcFpkL2NLc1VnWisyWHBkNW9VaVJ3?=
 =?utf-8?B?TVdQN0RVNHIvb0JaWnhEYTNUTWtYbkxDaWFSVEJwbk15ZWF4Z3AwY0tJcDBN?=
 =?utf-8?B?eVlsT2VueStuV2FZY1RlSEhPU09NUTJYZ3dDSUJObnQwRXBUSVl6ZzRTRFRy?=
 =?utf-8?B?QXdwM0JhN2E1VStRZXZIWjQzSVdyTk03QTFqZE1hWjJrNjhiTm9iYUNobzd1?=
 =?utf-8?B?WmVhU2xpNGxyRHpxak1LaTJGczlIdmFkdlo1Vm9ldGF4Qk9jc0RTVmFNQmxt?=
 =?utf-8?B?QTBTeFo3STVwMTgxM3RlcWZaYm5yMzFkNm1DQ3NYaXNNY1FaK0UzUksxSlFE?=
 =?utf-8?B?YWV6cXY5dU5teXhnclkza3dkby9CRDI0Njl4RFM2Ry9jYXRMM21TcHdVSHBq?=
 =?utf-8?Q?pkyHj2RVGaN4Tdirkd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1839ebba-2178-4b0c-136e-08df472bd3cf
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 17:29:27.3752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V6Kfb7EtQONr31M61P5niNWW1EaA1PHccliqrp6zhLKJsQsLUU6UIgszAW0uTHRs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6099

On Wed, 18 Nov 2026 19:21:16 +0100, Ard Biesheuvel <ardb+git@google.com> wrote:
> Now that ARM moved to efi_image_info for obtaining the base of the
> decompressed kernel image in efi_enter_kernel(), it no longer needs to
> distinguish between the image address (which might point into an
> unrelated allocation below the decompressed image) and the reservation
> address (which is what can be freed upon an error).
> 
> So use image_addr/image_size rather than reserve_addr/reserve_size in
> handle_kernel_image() to return the base and size of the allocated
> region to the caller. This will allow those parameters to be dropped
> entirely from the prototype in a subsequent patch.
> 
> [...]

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

-- 
Jason
