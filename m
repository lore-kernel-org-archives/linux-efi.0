Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.23
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794582645;
	b=VzqnuAtSZSjamhRvnhzkxLU1IxoY0pWgEBsQRR9g0FoJ8dKBqFze8mN5w6SFxOfwCK2Z
	 oTkStFowRS5irdZ4OhkQvUpYq/Px+P65Jr5/1ymnupHmAVFz6kk+wZVM0mDoVWCsEvXHK
	 pVhKrH6NKtUYVw0P3rJnNOTWiXJSdw2SYRCYy0JTkm5rCZw1NNNiOKXRXHDM2auCQbVlA
	 VdAM5AVsly6O4TVoAKcHZhIeuZtdfodtxaKuWgP7mqESqkfDtW63I6rd6Hb8jGy7VqQlh
	 rbVDQGbzF95xRuSxR8NnDS7icvUQy/gGHfpaaJhC1j69kyuqnx+oKHJwv74tSPlLXyg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794582645;
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
	bh=i7wqdx9pzwz6oHAF+h2yNUT7iDQImH+hS3J5Hh7V5U0=;
	b=FkiQUItwAaZMOZwFu50FDAqfdPielsEgqvHtzDFprpcfpOqlHX8S6MJlqIuLzHPVxEab
	 pRyH7C7PxKh19RWwgaepLIoNUaFC7xsA9ilGbifOpSfuXVKWyBtfVW3XVwKG77PYhEC2k
	 ZIExaMwa9Bvmpl1ziarZuPkno6KCwooVv4Y7JWApFDzZTlMzx4LC1qoWb3vTWQFOB2K/m
	 PbqOjFSRDyZOc2PTIeSIwVZVRLdcpAv/sCyXekANFQuDhsjQ3BTtHKQGEvo4wfKYFjaV6
	 AvmL6QBWH0BAujbvOl5Byu+DYbK51BkVgOwvE6mW1ktuywdlQi1Hy7kIO+HlUVVZDBQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ZaZvfRiS;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.23
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011023.outbound.protection.outlook.com [52.101.52.23])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF75C606A332
	for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 15:10:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF75C606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ZaZvfRiS
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kreUisB6A66WOTQYj+lF2vIZk40XljEUs3RDB/dwCljvLFzA0Gr7DsgBYcyAv4GEad+7Y4S4flc8XVTKlyAdxZmF2IDvjxoX1cUbdvuOlr+8ePP5AhNe8f07b628s9hlnj+7bw68soFXPHCRG3+kKZz4TmUIEHHEE6tm5gqNvQGOzhm8OrM3eO2qh8wG9TPj44QwZeodkzfSENu2LupH1NVgvQbTiGDcBl0AfZKlmym1KMCzKjygrHMpP39uXM0sxV1UqslaZjd930071ZTY8GOPFK9P9pCAiS6h2NenoNj4IOn3thhHbXlrNGb+MzoFXE5nKVfV/EuTCFxozQr0Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i7wqdx9pzwz6oHAF+h2yNUT7iDQImH+hS3J5Hh7V5U0=;
 b=LDTn55U3YqsQXdukpm11Yh+FqBK1tq+jg8hfqNEau6JoRGKg6OPXCtpINenrvCWPpkHeJy/oyCKYUTEvPFgsa8iga9Z2K3hoRsKPVEpgJaQzYeLzuCyNnnNy8jy+IbfCqWNhy5/40ArKWmkhvU4uA3g2eFDAx+po09Wx5iT3vegFltFZRPcTm+IzwAcTMaJ/cplKI9yMtEFb9/4zUxopV3wOjJyZl+g58E76MmK4XIGgptE37LXxvkL8JEnKGoo3IqsIKji9/gGuh0edIk7wqIdgGXv2bh2QOfZlvXRBg8hnxbdXd8uMUE11YjlOBnbhQOLievkm/Y6aL2iIJZQIpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i7wqdx9pzwz6oHAF+h2yNUT7iDQImH+hS3J5Hh7V5U0=;
 b=ZaZvfRiSFHO+wtl0cyf6lBeAEMqBDYHjQij12w7rObAwk3wFkwq24OVdVCClUWmDTTPtT0oDQoggMSXgPWtvpo2i/xoLuG0yjHxN3SyxN4wa0X7ERgZs17DNW/R5qmRoifTZZ3W/pGrlxl6a3YIAavNR/4/2QAkgS9XyzfcBOeg40X//bfo0Ttle/2fnedFmPJjkVMLgCKg4yAZh7atkIbPo2Kju20VflL0TLMfm6e00FBIpEa2k7lEHKFXwGMBPk1Nc7dRNd3Gdo7hvBnwe1VFx8SoucjZHBpPRb4xS29Vyxhwz7UraDc2NoLJE7qTC+XGWgqlERHu5ZN6w1lNpJg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by LV3PR12MB9332.namprd12.prod.outlook.com
 (2603:10b6:408:20f::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Fri, 13 Nov
 2026 15:10:35 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.009; Fri, 13 Nov 2026
 15:10:35 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 04/10] efi/libstub: Capture loaded image information
 in struct efi_image_info
From: Jason Gunthorpe <jgg@nvidia.com>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 Ard Biesheuvel <ardb@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, 
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
In-Reply-To: <20261110121731.2728824-16-ardb+git@google.com>
References: <20261110121731.2728824-12-ardb+git@google.com>
 <20261110121731.2728824-16-ardb+git@google.com>
Date: Fri, 13 Nov 2026 11:10:21 -0400
Message-Id: <179458262195.3625095.6692761412463057203.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: YT1PR01CA0068.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2d::7) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: dc455785-594b-4843-f3de-08df41983f5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|1800799024|366016|5023799004|11063799006|4143699003|261102123227099003|261022115727099003|261022105027099003|261021121427099003|261028144727099003|261021135927099003|261026140227099003|56012099006|261009223027099003|261022075727099003|261026121527099003|18002099003|22082099003|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	DYdTg/bGal9FlWzXdSO+WB8nXz/v2ZDB/18HyUOqFn5RWvYbgqM9OkhWcL9kscMNJ7VL5mgv+ZA0NlY2tR8oVwu5DvL+GZCnmckTcDeZ+UK7v3Se8GnXNGjkqbRy4efH8wF1D7dluPOHTaLFDjxqqhBtaMNmNlw8sxyCFHfH/btag/sUyRDa0b8k0HOlyelI4fTO7BmItAqtNOUU9/31BihOFO+Rz6Os6KjvNbWr98eaQi3qRVWzlnsYKExNqjQWIgjA1y1rQOTsgoLRxt2W6KYkf6brh1iR22dk9GFoSZNTEQqrfsrJII+/ehsPSm8NIde4D1ng9ZtLau3XjOzpqiI9gQRSd8GjN1Z2xyLegQqFBZZtVefqQp7lodvwG+Na8tGnCIX4pkVCwttoMjmANgAO7pt7L4P/gylKAk/s34pK3+5omIs+6CB3BrfFYVAWPLMBDDptk0ca13GlgUhhWHtRW+uws5uUWhICSzD4rKDbbTFr+voVb7ACWTQUMfMLAeG+CpT7IohwG3WmQvuDVIezMKzbU62vnINgeBNdivLAjKL/+5g7zQk/GzKngF271XEvdS78x2jUX5/+tzKYveV7icSJkWbZxKtjUSSZll5Chk1uy+H9a0HwJO1apIdTAVzljFbvRCH2XqiCxGoxX6Z3niJ5LRSw0ROmNIay2K4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(1800799024)(366016)(5023799004)(11063799006)(4143699003)(261102123227099003)(261022115727099003)(261022105027099003)(261021121427099003)(261028144727099003)(261021135927099003)(261026140227099003)(56012099006)(261009223027099003)(261022075727099003)(261026121527099003)(18002099003)(22082099003)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dWtGeXJ0eDdaK0FFQkM4NlZFd0w2alVFV2U5QVpzWW9XbUNDcVpBNDZlTFRn?=
 =?utf-8?B?Z01UUytkUklLS2NndGdLbk9FZDFnZFB5MU9NYVk0UkxoWTNub1RQZStRd201?=
 =?utf-8?B?T0MrQ1c1Zm5EVjloL0Q2YWwvaVRQWVQrYWd2QWF4QUhrcVVzUmZzell3V1My?=
 =?utf-8?B?d2gxcXFFd3lFVnhIMDN4VWtxRHdsMGNrSnZvMnBjenZLN2VqbEZEbmczZmVH?=
 =?utf-8?B?M3ZtaEs4Qi8wRTlNbnEzZlZLMUFSQjFhNFpxanF1enVFTUxZRkIydUNrUnBu?=
 =?utf-8?B?b1dOaEtNNSs2VFRDVTJJenRPajlJN215M2dFN0g1djBic0RhWXhSeWxvU25D?=
 =?utf-8?B?eG1aaUFTRGErSCt4RllZZ3oya21JS1dyQ1pDOFAvR25SeEpRZWppQXFXUDdJ?=
 =?utf-8?B?WGZtRWt1U2xJenJxdUdXL0gxNzRSckkvZUFoMFdqSHVEVjNNcFJhWG54WHpw?=
 =?utf-8?B?eW84MG9NamxsQzNCeGpoMTFrS050YmFMMXJFNkhpRVpQSXFLaVpVZFdFYzho?=
 =?utf-8?B?Tmlhemk4ZHNRN3gzRnc2eEVMdTFUVzdMeGFFRkJIUHFUNHI1cHVQK0ZTV0ox?=
 =?utf-8?B?UGEyNzdPME5aR2RHaUNXNHIrRzlDT1B2RzlMeG51QXJMbkR5cWhrcnRWeHFm?=
 =?utf-8?B?ekt6a3Uzc09QWDUwMnpUQW5UUnhDYmt2dG5ldE1NZ2txTW9ZRGphWTRFa2wv?=
 =?utf-8?B?YTZTeU9jSWV1VVltYU8ydVRKTTY5cXNrd3hPcXM4Vml0RjI5YVZ0YUFJdm8y?=
 =?utf-8?B?akZsdS95eHNxRzNrNWU5ZzFCSWtWZ2Vxc2I2c0xWcFF5QzBGK2Mvck5HVWRE?=
 =?utf-8?B?SllrZERVNk90UnM4Q2lCQzRqcC9ZRnJsenVRWExOSXFiMmVFbkJyU1lOdTVR?=
 =?utf-8?B?d2dBTk9QbWJ6OEp2T0R0cjNQTkxNZGVUN3I1ZlpqeThOaFhkVWtMVHNZaUp6?=
 =?utf-8?B?Ri82SEVUS0RMcmUvdC9GbTVqY3NmZDI4RktIdWNGZGJxZlFRemRueFBDUk1N?=
 =?utf-8?B?YzFkNkkvQVZkT1crV2VIWFJISzhuYVdENDQ5aVFaYm1QWnhaME5HaWQxT2VJ?=
 =?utf-8?B?c1hhVXREdy9MUkZGRE1Dam9NcUlXZUdLd0NVSjZTNHJXUVRDVjhxKzYyOVhF?=
 =?utf-8?B?TnE3dUFUNWI4RlVmbFZGeFdHa0dyU3FnbGozZkl6NEw0VkNSOHR3L05FZ1pp?=
 =?utf-8?B?R0VPNStiQjh1ZFptVVB2Uk1SWFFiNkJuOWU0UEFTbGlCeklpWTlFOStjM3Ns?=
 =?utf-8?B?U1FUVWIwWjhTZUQ3U1l5cXF6aFNUeWJMRmlRQlh6bmtvV04wamNkRFJJaFBo?=
 =?utf-8?B?MDJYZzJ5TTc1WVhOL3dzQUU5dHhIZGVvNW1PWFpPSms4R21kZ0xKaHh0Vk5O?=
 =?utf-8?B?bTlXd0pWczJ0K3NzUXFRa05rWDFnZU9ZbXZkc1ZBWGhEbnY1Y0g1RmFPNlBC?=
 =?utf-8?B?NDhTR00wVWorZmlYYUNSOUgrZEtEZUZLbDRKYnhNbllEOVRwZVFWNUE1Nmdw?=
 =?utf-8?B?SFZpQldsYVZSV0Zsck1KWm5udnVFVVNIRk8xa1JQeEhCTUxvREFGa3FLREJt?=
 =?utf-8?B?d0Z5R2tOZmZrcFZIREM0d1RYd2ZRZDJuL1N3Rk5nd2VVV1N4WUpJZFA5dmh5?=
 =?utf-8?B?MGsxWXFrM2VmRjdqVG8yNW9JdmI1cHBtOXc5aTNQbHZWTk40djA0dlJjR1p3?=
 =?utf-8?B?ZHBOcnFRdW5zYU1FWWRVcDhndldiZkxVK0tRZ2tTNGc3ZUF6TTFvcVJrdGFR?=
 =?utf-8?B?Qi9uc3l1TDNuZlFBdTJ1bXZWdjNBNkR5RkozVWRrYXVHeTd3SU02Tm5HZU1q?=
 =?utf-8?B?NEN4ai8zbHlTSUtkbjhYeTlYNnZ6alZBTjlnTmwvLytMWENNS0RHOE9WbGxz?=
 =?utf-8?B?dEJzdHJNWWlJVHVPWnBDaEpUZDJ2a04wVHpOMzZsenhwV01abDRYT3hlOUxl?=
 =?utf-8?B?M28rK0Nld0RnWTBYaG92WjFuckNFU0FQMmZRbkJKRzZRNldXZlM2OG41eVJn?=
 =?utf-8?B?N0wrM3NnMFI0a3MrVE9Ld2REc2IvMW1YdEJrOVhHVjRlUEQ0dEZWM0Z5ZGJP?=
 =?utf-8?B?alBKTmRUSWw1TmNqYVZiSXpKSjJYZDJsL2VCV3JLY21KMzJjSFZOOE9xdVFR?=
 =?utf-8?B?dnVtd3ArZDBpaU03QXdUYnRDT2ZLK3NzSXZvblljb0h3cjByQ2Z4QnBwcyta?=
 =?utf-8?B?QU1zS2dFSmRCTlgwWGhoNUNwcFhIWG1xb290eEhXdEU5S0swWGZoMWlXVFR1?=
 =?utf-8?B?SWRiTkI2QzJiUGR0SGpEOUtEYnlaSCtjVVNINFlZVkVab21yajVBTGdkUnBK?=
 =?utf-8?Q?EihKOumXdoPsi6jMaP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc455785-594b-4843-f3de-08df41983f5c
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 15:10:26.4593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fnJ9RLYzm9tcX5DtFFln3UJyeZBQl41vAojXQVX5L/igVa6HrIpOTg52P2H/CtQd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9332

> [ ... 131 lines skipped ... ]
> @@ -80,7 +87,8 @@ efi_status_t __efiapi efi_pe_entry(efi_handle_t handle,
>  
>  	kernel_image_offset = image_addr - (unsigned long)image->image_base;
>  
> -	status = efi_stub_common(handle, image, image_addr, cmdline_ptr);
> +	status = efi_stub_common(handle, image, image_addr, cmdline_ptr,
> +				 efistub_get_image_info());

efistub_get_image_info() always returns the pointer from the EFI stubs
location, but at this point the kernel has been relocated and now we
are passing an info pointer that is outside image to everything else
while the zboot path passes an info inside the image.

It would be better if info is always pointing inside the final
image. Then you can use info to always get a pointer inside the
ultimate kernel, which is what all the DRTM values need.

Having efistub_get_image_info() take in image_base, and then using
weak to overlay it with zboot's version would give a consistent
interface.

The adjustment can be calculated like this:

	return (const void *)(image_base - efistub_image_info._text_offset);

That would allow cleaning up the primary_entry() flow to just use
info, and remove the weak functions:

void __noreturn efi_enter_kernel(const struct efi_image_info *image_info,
				 unsigned long fdt_addr,
				 unsigned long fdt_size)
{
	void (* __noreturn enter_kernel)(u64, u64, u64, u64) =
                 efistub_kernel_ptr(image_info, entry);
	enter_kernel(fdt_addr, 0, 0, 0);
}

(see below for macro)

You could do the same by passing image_base and image_info everywhere,
but that seems less nice.

> [ ... 20 lines skipped ... ]
> +++ b/drivers/firmware/efi/libstub/efistub.h
> @@ -1148,11 +1148,53 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
>  				 efi_loaded_image_t *image,
>  				 efi_handle_t image_handle);
>  
> +struct efi_image_info {
> +	s32	_text_offset;
> +	s32	__inittext_end_offset;
> +	s32	_edata_offset;
> +	s32	_end_offset;
> +	s32	entry_offset;
> +};

This ends up in a cross-arch header.. It seems OK, the x86 voffset.h
parts can fit cross-arch like this too.

For DRTM I will do it like this:

#ifdef CONFIG_EFI_STUB_DRTM
	s32	__drtm_measured_start_offset;
	s32	__drtm_measured_end_offset;
	s32	drtm_entry_offset;
	s32	drtm_handoff_offset;
#endif

Which should be fine, every DRTM will need those four things at least.

> +
> +const struct efi_image_info *efistub_get_image_info(void);
> +const struct efi_image_info *zboot_get_image_info(unsigned long image_base);
> +
> +static inline
> +unsigned long efistub_kernel_base(const struct efi_image_info *image_info)
> +{
> +	return (unsigned long)offset_to_ptr(&image_info->_text_offset);
> +}
> +
> +static inline
> +unsigned long efistub_kernel_size(const struct efi_image_info *image_info)
> +{
> +	return image_info->_edata_offset - image_info->_text_offset;
> +}
> +
> +static inline
> +unsigned long efistub_kernel_memsize(const struct efi_image_info *image_info)
> +{
> +	return image_info->_end_offset - image_info->_text_offset;
> +}
> +
> +static inline
> +unsigned long efistub_kernel_codesize(const struct efi_image_info *image_info)
> +{
> +	return image_info->__inittext_end_offset - image_info->_text_offset;
> +}
> +
> +static inline
> +unsigned long efistub_kernel_entry_offset(const struct efi_image_info *image_info)
> +{
> +	return image_info->entry_offset - image_info->_text_offset;
> +}

As above a little helper to get a void * would be useful:

  static inline void *
  __efistub_kernel_entry_ptr(const struct efi_image_info *image_info, s32 offset)
  {
	  return (void *)((offset - image_info->_text_offset) +
			  efistub_kernel_base(image_info));
  }
  #define efistub_kernel_ptr(image_info, ptr) \
	  __efistub_kernel_entry_ptr(image_info, (image_info)->ptr##_offset)

If the rework above is done this would replace
efistub_kernel_entry_offset()

> [ ... 15 lines skipped ... ]
> +++ b/drivers/firmware/efi/libstub/image_info.S
> @@ -0,0 +1,12 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#define REL_REF(sym)	.long	sym - 0b

The code could consistently use the offset_to_ptr() macro if the label was
included in the macro?
 
  #define REL_REF(sym)	0: .long	sym - 0b

It would make the efistub_kernel_ptr() simpler, and the three size
calculations would look like:

	return efistub_kernel_ptr(image_info, __inittext_end) - 
	       efistub_kernel_ptr(image_info, _text);

> +
> +	.globl		__efistub_efistub_image_info
> +	.p2align	3
> +__efistub_efistub_image_info:
> +0:	REL_REF(_text)
> +	REL_REF(__inittext_end)
> +	REL_REF(_edata)
> +	REL_REF(_end)
> +	REL_REF(efi_primary_entry)

Can you put a

+	.section	".init.rodata", "a"

Here?

The DRTM patch points this to various things in .init. sections and
modpost will complain. I think nothing outside the efi stub should
touch this stuct and it should be freed as init data right?

> [ ... 18 lines skipped ... ]
> @@ -93,9 +100,15 @@ efi_zboot_entry(efi_handle_t handle, efi_system_table_t *systab)
>  	}
>  
>  	// Decompress the payload into the newly allocated buffer
> -	status = efi_zboot_decompress((void *)image_base, alloc_size) ?:
> -	         efi_stub_common(handle, image, image_base, cmdline_ptr);
> +	status = efi_zboot_decompress((void *)image_base, alloc_size);
> +	if (status != EFI_SUCCESS)
> +		goto error;
>  
> +	auto image_info = zboot_get_image_info(image_base);

auto is allowed in the kernel now?

-- 
Jason
