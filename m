Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.23
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794582646;
	b=RaCxVu/fs9N5kJAbnrBcGfICwUTWdOZl9F+Yj59hgI76RUzFQelBFkPQyvCaZXX56/tD
	 cSrjEuGBa1SwKOBT5ierVIxfGuiYML9oIwn4jEkN56kv8Ht3GRB4ha1vNUrASYIUhXf+R
	 ruMSb/ghiBnYuV0rYID5Uwc1veJT29f4LrnntWx85zk02Eu/62WsjfmcnRmnOOMfmXl2Q
	 r8Q2VJpiGg6b6tpqNnjPBUBLYz0HVN3s5kCHOkH8/uz+dXhsOSt1QNWb397x3rAV/5U5R
	 KYN3poE6jPOljWw24kHiOhC/YG8cQ4MBHYrRhZ1uP11AvfAk15T1bVmSU0BjfyCBr3w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794582646;
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
	bh=/eToaTj7cPSL4OGa/+JiZdC/pCsPZNHO9Mfs4UhrB5k=;
	b=HMVmAycm6bUQWs0GK1ov9yLmL+iHjJJiC52y9/8mG1NVt7dFfTOld5qMpPEOPSQoaPjW
	 lrTFq6IuXMG7f9yC2Ymg/Hu1d9PDu1MnPGdFEUYmcLBMY2xE6ObxTdeCeHfzwiP41QCA1
	 b8j3WIOW13nDOIRXerKfnczRUYWQIcDmuKJVlQW+/iz2aZkWeDbaWIJbmxtdoWWN/yo+I
	 jnbj8ckxuE0Fk0QfN73Hrx20P8VKbsHWU7SZDnxC09EUGOtr+FqzofipNjv2agk+eUOPR
	 h+1joCSvacgmMZs0rTWYIUKlX1MGgVLUdLzJyHhND0Cybmq4UqAbkw2GT6ptkcmIjyQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=B1ygWAUy;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.23
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011023.outbound.protection.outlook.com [52.101.52.23])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D77606A333
	for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 15:10:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 53D77606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=B1ygWAUy
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qsj33uAIsojB3hXp72lnO+u818boAvdNTJnYm4cYZGF/MvWwI9i5hu2Zg19/l7n3foNzng0WGd4O/h7XFJVQ47zgrlcBY2Y8WwvAKtBcZVeF11+FWTDdUlVcnvlog6shiUBwmrYJSNGDu0RoiS/zZHXKRGX6OV4X6HcJn25AWQizRlpYP+FQpLL/7N65w/Xtc8eTPxAK8efolHzTnBnmZ7RTx9QKrVGao62FjkJogFYraVjTl2Pp8iD8oSH4DKEW8HUjA8llyD0IqPT/qWEO562W6VQmInJHmrid9oNZQdR3YHHcUyRh2/w/Wzc8XIaZWJDhsRdhSfpA7bH3j7SqaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/eToaTj7cPSL4OGa/+JiZdC/pCsPZNHO9Mfs4UhrB5k=;
 b=iSUWzd0KhKZSeMbWAv7oSxtaCerxhNsFQvskugcG1ZNr/5PrBenWCU+8Af0G3tOGgqSKJso0ED0d1vmMqApcoHu+Cj2YxNrzGPssVNnwIoF8pKZTySMRyAulmy+aCMH9UO9KkSc/3iLIRoo0mZvd1dDL90s4S7IwC6A8RfLqWh4spWFKr8aIJUJqCPUrpYtPm0MeNU+Cb88Nb7uwfyG5xumKJuTbsp4c1+cZEfacQwVD7b6jOUzLS4E9yLJqYkXUbCxVGWIUJyLTgbeCYVEyrxZBgMwX5X3Uf+FF0JY6aq9iCLImp5jnpGjOerDi9grAjMf14/QTQdBVIVS46I4rMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/eToaTj7cPSL4OGa/+JiZdC/pCsPZNHO9Mfs4UhrB5k=;
 b=B1ygWAUy0KZFMF2HH7Opag77rugvzITGJiqxmhd/NXQCQKm/v+QtTMQHG45uDdaJl91DLht7un9FICAGfESNdcgPMrAUIipjDypILX1eO0OuEHwfePo8BGzkx32nJoZG7xzjq54oakTGfc5ggJnBjJBSYP4TzHyBAXYRfU83lBtBCi/lCj4MkefcrbXSC34IgK0nqpWuLZjUYwE1Tz+nSZpw8hkva2AQl9lop4U25eSTPD5FG+5GHRpdq91vSezN3Fc/22ivX3y6WPLPb2cnR2xGoniqAV5sqFHFCsE79tlFEyoUd5VWNRAMa1GdjYXFdK79O2eveU004JYBxScSUQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by LV3PR12MB9332.namprd12.prod.outlook.com
 (2603:10b6:408:20f::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Fri, 13 Nov
 2026 15:10:39 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.009; Fri, 13 Nov 2026
 15:10:39 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 06/10] efi/libstub: loongarch: Use struct
 efi_image_info to access image properties
From: Jason Gunthorpe <jgg@nvidia.com>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 Ard Biesheuvel <ardb@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, 
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
In-Reply-To: <20261110121731.2728824-18-ardb+git@google.com>
References: <20261110121731.2728824-12-ardb+git@google.com>
 <20261110121731.2728824-18-ardb+git@google.com>
Date: Fri, 13 Nov 2026 11:10:21 -0400
Message-Id: <179458262196.3625095.15288411840693326187.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: YT4PR01CA0203.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ad::28) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 9fd41c3d-bf44-4966-fb72-08df41983f5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|1800799024|366016|11063799006|4143699003|261102123227099003|261022115727099003|261021121427099003|56012099006|261009223027099003|261022075727099003|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	PlvlP+5EjnLJgjrXF9bjvYlodyrwl0AzB9T9LFupuy82SlCQrUiGIeMQGDgDICZonLdtQbK51GCLTOyxAn3wP24DRU81p+sWVGNKnBMwu9nwKJNyHZ/cUwx55J2zw5VSqnbvUF3PWqNA7zLKTAiATkKjywhShvHAw2ju2hPDCBb4kUVLMsNbBLK6XVSrIxUMBrr7qKpOMEJ7LEsfPs8a8Rr2DdalBGy1nCadECQnqYMTd/ZmIoIDW3modJV3dY1nVg4nQK1mXtiiQ2PtlG1lz9Oy3yHxeAVIXKf8ZJfqrh4GNlXIKt28DgwTvCIHd2gdhrd3OXCvXcwuWB8WXVmVJ1ZvCbzd5PFfRMrlrIaLTbpqL9Vv9x1fQDIDjQQnBs9KBilBmKR92KeX2zS5+uBBZFiERfweKEW8eOoYUnAML/+tOJvZXK8NUvIELS0OZqXNyyFX4vqtZkno7yCuNWAHlxW2hAygslTQiS3QWQmFSOAihlSrU2djj3CKW5SL+XSSUKCZjsf2G1sZdhADIybGznk1PROG34i+unckVrKzO5ZPCct6V4vTe8nXRK1gL/5mRp0wChw+AeE3/8OhVWl13pAtapjB6GCYEm0wlfR3vj8SYv4riNwYhQ7Lksen+h5w+Qpsc0RZskyuutTK9LGwCzMxvuiUB6ydtLO/cDe2YwA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(1800799024)(366016)(11063799006)(4143699003)(261102123227099003)(261022115727099003)(261021121427099003)(56012099006)(261009223027099003)(261022075727099003)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WjhvRDFxS2NmT0NZTFZ3WC81M2RmR0xtUFpxTVpvMGRvU3RLUHlmamZQT1BS?=
 =?utf-8?B?dEt0L01CNFA1b2ErdkNpbmpqRHhrbUQvTnFBNlRJM2c2dnNGOU1JbGp0NytD?=
 =?utf-8?B?VC90ZlJPSStHV0ZmUVBhdlJKU3VTb1Q2YmJMTWg3UnRqVkVvSkVpVVNNWGdr?=
 =?utf-8?B?ZEk5MUNhV1drSkpMN3I1R2ZyL1BZRHBmbDdkTVhxTnhyY2cyZUpFQlZzeVJP?=
 =?utf-8?B?Q3JHclZSUHlrNDNnc295ZTRRbmIvUjdXcUhhMmduMTZld01seWNReHRTem1Z?=
 =?utf-8?B?dXlUd0srK3RabGU5dU5OU2ZvZHlRM2JicVlsVk1uK1R6M0M2dW04ZmdTdFhT?=
 =?utf-8?B?cVlwalNOeDFjc2Rsb0FJS012Nnpqdkt3WjA4SjVwYWI2RHpyV0tCUXhXRzZU?=
 =?utf-8?B?VEE3V0VaRmg4bklPdkpLODVmbHV0TGNpMnU0T0k5M0JXclpMMVNXZm8xZi9s?=
 =?utf-8?B?SEVXNnpoSmtJSVM3b21NaDcxaTFFSEk5b25GOFNkZC9IUVEvcG5vTlowM1Vk?=
 =?utf-8?B?aTBVbkUrd1hnaVppOFhkdTRFVlZ5TDQ1M0kySDIyNHl5eUtSY0FYTGFiaVkx?=
 =?utf-8?B?NVF5K3dvanhFRDNYa0dqdGFlYWhYdHlEWU53RGoxMUdqaVk5d1RsK0cwSFph?=
 =?utf-8?B?a2lyVWFaVVRxRlh2aGtmTWZ1T2RZU1dEUFJKakcrRHJoTUg4Yi9XQlZ4MWRS?=
 =?utf-8?B?eThLWVZDZ2dneTAvNjYyalg2OC92Y01Da1BnSmNRZ3daUmx6T1pBQjlwQThj?=
 =?utf-8?B?NXU4TGQ4YjZYSFcyZWtTZWlteVBQTGhVQXZ1a0FNblRzNjlVY3NQWTBoVXpX?=
 =?utf-8?B?QXV1Vjh6NzlsRWs1M3JDcHlqNkV4ZG5UdzZsWTFrNlZWR3dGNDRNVGZNWENY?=
 =?utf-8?B?cFRpcUFuckl3ZmpadWpISWMrOG9BY0dYeU9vN0RzRW5adjBjVHIvY0lWc1N5?=
 =?utf-8?B?SmI5Yy9iQ1ZXcUM2SlMyV1hCMWJ4V3lMQnArQWtBb0RrZ3NocTBXazBvdEZw?=
 =?utf-8?B?MHZ5WlpFZWVCeUtES0J2dFQrUXVQV3gyUEVGOFdsbXRXUUpSTGVBUUlSNWk1?=
 =?utf-8?B?VWlXaE8yUHJ5dVpyeGk2NlZMNmZPbEUwZWEzSGhFWWJqMVVURC9YRjVSVzVK?=
 =?utf-8?B?ZzFDb2w3RkdQM0NnUlFma2tOUiszeElYNUoxZEk4NUoxV3UxYVhVU3BPT3Fi?=
 =?utf-8?B?bTlSV1pvU2hmQy9LTStnNk50Z1A3MUVDMkJ2U2V5VmlsVklLZGRxMnpnU3py?=
 =?utf-8?B?UGFmRVZHNDFiQm5MUVJCOXVDYnlFMVY5UUFqdE15aDd3SGtRaUl2OXVMK25p?=
 =?utf-8?B?ZEFlalhIRkVyYTlvNGlYQjU5cFZ1ZW1Kb3FrZmw3VExzc2UveGRXWDhGNmxV?=
 =?utf-8?B?UExzK2RJaVVKZW9idWdITTRRVi9UVzYyd1h5MjA1RUE1KzZxMGVqSEVPTEtm?=
 =?utf-8?B?TkhzcW9DVWRLQWozOUNjNDRUWUtJeTRoTVhSdEh3UDBqVGVwSkJSUzRYUVRW?=
 =?utf-8?B?OVdOQTdEYlJ0bzRKNE00TDdnajhNYmxPUzVoRlJEVWZVbTFYb1drdC9PUEVq?=
 =?utf-8?B?eVRKY0FoUTRCUE5pVnVsc3lxYVNWR1VaQUdPZ1IyU21FYUkyYXp4SzB2bVl2?=
 =?utf-8?B?dURzczV0SjU4WFZVN3VSbXh2Y3FaWVhZczhuczR6T1dEb0xRQnhiMVk0MElE?=
 =?utf-8?B?SUhvd25taXpSMVQxYTNZSlNaYm5nVnBkbHlEbGNWL2dCN0N2dktjNFowNVdW?=
 =?utf-8?B?REtQRVNtbXBBV2FPdGY5WldQSmJMNDBXRjU1RE1JT29QbVE0ai9ybk1LaDNq?=
 =?utf-8?B?aTJmc2tLY216RXNZY3NxQWhFelB2TEpheDc3OXZxZkJNUXZ6dlo2NnNLbkFC?=
 =?utf-8?B?V08yTUN2OVN4cUtjZDdJT2phdmREQWpWTVpQbVJiRXF2Z3FIa0k5V2I1WGFy?=
 =?utf-8?B?b3F2TnIwQlErSlRwNkd6b01EQklrUElDa1pNRWI1cUpJaTJKZ09vZ25OUlhv?=
 =?utf-8?B?UzJmVkptY1cwd0FCSFBTQ1MvaUZPRVN2YzE4cmt6aVR1ZURuQWVYRkZOdkZn?=
 =?utf-8?B?VE1YQ0U5VjdyWUl3S3pjV05JNGJsdEdSU2FjVFE3R1JiRUNFYVlsdk9DQ0o4?=
 =?utf-8?B?QUdJb2xjWmlreVdIc1FGanlBRnpqaGlDS2NEMUZJaHN5ci9MYkE3a3JEVW1t?=
 =?utf-8?B?aFk0Z1h6bjE5YzdKUkdvTDBWRmhmNFVPeHZ1Uk9RcDF4Mld4ajlXTXh5Vzdp?=
 =?utf-8?B?M1ZxZzltaDU2RlNNeHQ4QWoyb3E3d3B3WmZQSzhmZzR2NWE2TTE2L0JTNXUz?=
 =?utf-8?Q?CODj4bTszud+vhxlAn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fd41c3d-bf44-4966-fb72-08df41983f5e
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 15:10:26.4799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hYwpgJB0C3UCWe58M2SuUodUbX5yTxR/bS201uIQU+IR/gHbjfyidMdxd1O5oOwN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9332

> [ ... 29 lines skipped ... ]
> @@ -118,7 +118,5 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
>  unsigned long kernel_entry_address(unsigned long kernel_addr,
>  		efi_loaded_image_t *image)
>  {
> -	unsigned long base = (unsigned long)image->image_base;
> -
> -	return (unsigned long)&kernel_entry - base + kernel_addr;
> +	return kernel_addr + efistub_kernel_entry_offset(efistub_get_image_info());
>  }

This can be cleaned up the same way as primary_entry:

	real_kernel_entry = efistub_kernel_ptr(image_info, entry);
	real_kernel_entry(true, (unsigned long)cmdline_ptr,
			  (unsigned long)efi_system_table);

-- 
Jason
