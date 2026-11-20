Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795195780;
	b=KHsefLHM8WlnpW1/izwvMKq96ysFMD5lWmDIv7fbn5y/STq1GOv47V7EHE6VKP0qDv/T
	 mASxiuvAfuXkToCLpAZ6liPl4m+2SEwRSRn5sA+c2czNwuXQa3mzOAMM/GUeughtUbaxv
	 KmHY8P6uJ66m2T+GQQTHG/C8ItWc7Dse/T7HwrBYn2DYFpeV1Kjl2onR2lewsGo3Z9Qgd
	 a59EWWVuAZdQ+ETmJAlja2n7hRLIAFQOMbeKxMtsQdNArStXk54kCrZdgfqsQPRgqQ/C3
	 3jUY4hqNrT3CTl7TQAOYZXDqDdXAlC1Stm44iPWiyJtcdE5DednKgcNqvs463HYrKJA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795195780;
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
	bh=vmr4Km6Sn8P4smDEuajE3PnpFZl2gruxdJL3XVtv7Xs=;
	b=0igSMk1ngr3iLIM+x3rEwaIKrDdXRPprxd+vcT4pD8tyHKcq61P9fTOKVr2Qe02R951t
	 zKcqpPs4Y1QsoGbkwqXBpNHmsfaemn2awHhn9vUoKqj8NxSWQO7TJjO1zdj8e2K/B3r6n
	 NigGAgXDbkFHZlovyh93ZyYe3ks1J2hiFmOnikwr2mxcBB3A2lPPljb6D99Zm0ViLe/GK
	 9cIZ+qeAaWraiiz9j8XAmOSD2CJD0GD3DmWceg4yh8bbP7ILNQZsrAW5Z4NmS/35cGUUa
	 gHuNZcSl6STYDtWKSlsFRP9T+vfYDqN9TY4h4bdOcZnTphmiiGQmIl1s4L4nKm8ZoEA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=QSAgxdVJ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.48
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013048.outbound.protection.outlook.com [40.93.196.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071C7606A336
	for <linux-efi@vger.kernel.org>; Fri, 20 Nov 2026 17:29:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 071C7606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=QSAgxdVJ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pglra0ID2exEMgV2YEoEKU9j3RwjJSsP+Hd5tsy4DYUKaFdtqOQsTqa7rPmTKRb1IiIrsRnFAigm+AKh1J6aX1242MydhfI/XgIaqFa0cfRnBLOV+gbUZRUvuApHlyV2VcIdeRKxTZAUHvagnFUYj9KfVnMSLa7K6bt+g75plYybyeOMW6i4qGAt/TUyfiQbBOD+NnErXqd/M81XOfoVjXKJzxRUYbdRMe2x9id/DcoDjfVBkjQmx3zTMjS767OpUvgvivVMmjxXVGVbBGDMIhRVToO+1mK6lR/WGUtcklWCjKtg/r6qx5zSMz/BdyXmaAbYLMa5dn+naFBJX1ueEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vmr4Km6Sn8P4smDEuajE3PnpFZl2gruxdJL3XVtv7Xs=;
 b=SoPkdM6ZoicWBaKGAV7mGyzgCk0cThUGW8DlXFH8YpLqG1ns5jiCtjbCX1Wbg9p072V0NoSLD+mhALqChR9YLodQYbsByCZCbrSOLN+P0lwDZqT2iCOoa1c0iEj+NLPnku0GFBY2MfDHbwQwTCF9huscWKD1Zbp0wbhUPWUXitwwqFdlMYgvOpCtLlPdLalHT6TdYOuOnw9YYLZqk5eOeT9a2jOdA4gqAT4BsENA8rizn7LZBs/anXxDK0jSIHSDHdfkJ9JXZCHTfkwhcVe8CPSldndz9raiPLXB303i3Rl+ZORg0LAtBmbklmAqfO6eUKmlGosl1mZfu5cJFmxF9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vmr4Km6Sn8P4smDEuajE3PnpFZl2gruxdJL3XVtv7Xs=;
 b=QSAgxdVJAU3R/uicIX+UngTjwT726RTjjBaWtnv1SgXwCFxl4d1FtSWVgo50HhrJHU39VEQkefYPTbuGaeUZcZXF4AGaGMKX/ui2fzVD4EY4bcZJCd/u6eK/+ievAPh7uSdyTR6Rt5dNqk+Hqm0IBBDe/6DZ4cSh9CvvYkdn5EvXke2aV0LKKd4w4tcWXApdHS8iuRQpp7hPPwGurSIcNspFeiveZ1ntADLlW59TycDnCvEChfZtpsZuy1NplBEYig+SkwDoJ4w+smVM7WtMQbNlqx6MmXEzynWJDi7z2vXQ3YVaChyXTn+ro9bmJQUdS+WPcBZ3a/S1gVIcr5Bumw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by SJ1PR12MB6099.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Fri, 20 Nov
 2026 17:29:29 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0639.010; Fri, 20 Nov 2026
 17:29:29 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 07/19] efi/libstub: Avoid reserve_addr/_size in
 efi_kaslr_relocate_kernel()
From: Jason Gunthorpe <jgg@nvidia.com>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 Ard Biesheuvel <ardb@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, 
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
In-Reply-To: <20261118182105.1633603-28-ardb+git@google.com>
References: <20261118182105.1633603-21-ardb+git@google.com>
 <20261118182105.1633603-28-ardb+git@google.com>
Date: Fri, 20 Nov 2026 13:29:22 -0400
Message-Id: <179519576288.392094.15568086387045096767.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: MN0PR05CA0004.namprd05.prod.outlook.com
 (2603:10b6:208:52c::10) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: b30ab621-2146-4fd3-d437-08df472bd48e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|18002099003|22082099003|3023799007|4143699003|261022105027099003|11063799006|5023799004|261021135927099003|261102123227099003|261026140227099003|261028144727099003|261022075727099003|261021121427099003|261022115727099003|261009223027099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	ZxWEEFH6/ka+09/+2mX4nyreW9XkeC1K6IZ0/uVv8W0PwiscQ+vp9WR+s79B0Ts8bsaNwcj29nOx5K6UCD/bB0tSoDNvHN67DwM2v9/sh9t9vwRT/54CG1SOCcrteTuept9UCBDPZhWBfE0UXiOqDQzcszV2X/4TdvJXCG9dzldYVK/c9meniD5CPMArN3YKKR+eKM+aAh7xyl0AuHXcBePPJjwbjr6E2GVPXTd5p6AtLu3rfAuNkb7F8aBAS48UMwBai0dmXU+KVlp6YDs7mIonngBUnHhjKzYHULXEeqsJz+XYyHBGxVG0RAnHS6IUNblp4QHRFTqB7NsyJqeAi8IaSs/pQnQILNuMSljfSbpe0eq6tJX/htQrRYV9rbKZCC4RTXjrb6MkmL0b+k1EWg3vGUxa9mc03kGDs3KFseAaCXLqQ30RRVlE3XuPmfb0v0nVFf3C7UISNDKVxXuhChToRwqAEQU89ZmUQB3mh+RGNfQwy4mzWOS63jA9EVS9VFEx8Y2IeCK3CLvWmn/hXWfbdKmUY6uJ3rwyQeugCM4rKRbPmqXXDX8wTrQ8+GjYU/zEYKnGy1gjUTtc7UF/mfLMKgqx30K2DBM8F7GE8fAbQhB7CuRirTv2QsxnCXs4128ve5lHhe80+FhovDH80vC4t7CzyN6cu/voAqxRfM4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(18002099003)(22082099003)(3023799007)(4143699003)(261022105027099003)(11063799006)(5023799004)(261021135927099003)(261102123227099003)(261026140227099003)(261028144727099003)(261022075727099003)(261021121427099003)(261022115727099003)(261009223027099003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WjdYa1M1TW50UXhERlNqQk5mMXlRaXI1TE5ldXV6Q0QxSGxSVXBoQlNDS1RJ?=
 =?utf-8?B?RDRUZFgzK1hhVUNzUHBHNk13cjZuLzY1bEx4cThFekNkNTlDbDFCekFCdGt0?=
 =?utf-8?B?QjluQWRmN0QyUFhQNmhCTzYvMlFRWFBkcVVuMUJLcU9kTGZMMjFDU0I1ZWxH?=
 =?utf-8?B?Tm5MUVlDYW5iQjVYUUZJcFM5R2xpckw1QitJYkM5UWk2V2orTm1XN2NsaUdO?=
 =?utf-8?B?b3JUeVEraGRVY0wrT0Fvb3RiU2crVDNkWTA2N2c1dTRYSTlyWVg3SDBwWHFW?=
 =?utf-8?B?ZklYRW40eUdZWWxnKyt1d1k3V2ZiN05rZllHaGVIaDVhekJVWU1tOVZBMjJ1?=
 =?utf-8?B?emVpeUxLV1pPd1JHeTVlRWxJRUQ4RHh3SE5sOVVLeVJveWRUV2NFRG9MQ1Rz?=
 =?utf-8?B?eUNXeHNleUJmWDJsSGpIUkcwWDB2MDdEUmU4Y3hYTE5FUkc2TTJVYUVOcC93?=
 =?utf-8?B?cHZZTnQ1R0RJTUdXMzVjNnV3QmllQW1qekhKUmUvdVNBb05xRmdjWk5GL2tm?=
 =?utf-8?B?TW5Ma09sZzlVYVpWV3FuSENzeGNpUUsveU9ZT0VUdzhvdFR4RlU1WmJORS9h?=
 =?utf-8?B?QkZGbmlPVHJ1eWo3VHIzTmsyTWtSd1hpOHArTUwvNzNTN29odWp4YVRYUzV1?=
 =?utf-8?B?b3FnVXI1U3g0djVyd0JBUGxtU1ZadG5oK1VLM1JmRWluWEdCdjNkVnNOTU11?=
 =?utf-8?B?T0RtbWhwUVVzSVlUY01IWVVsSTA5S3VZOG9FNnI2NDA0ZlJaMHBqQ0R5Z3py?=
 =?utf-8?B?MEJHejZLV0ZsT3czcXFreEZMRDRldFplNmJZcXh2aHZkN2tUZ25mZTBLYkor?=
 =?utf-8?B?bjBJOWtuSDMwYUR0TzJpWUxidGNxWjdlb1dXcFN0aFNqb1NTamhDaFZMbk5D?=
 =?utf-8?B?aGFrM3RENHRHbFVyejdieWlGYm1OWUMrQXZjcG8vWmR0cTZkSlJJRE5JeXhk?=
 =?utf-8?B?ZnhVMXJCTjN2SS96Vk5WTW5kbE52b2V4bHVYNEhNZFhRcitrVUhGZ0NHWVpV?=
 =?utf-8?B?aUJ4cFlYVy9lT3JZV3ZtaTVtajJzdlFRbjU3L0NhaTJtZzYrQmVkallCckV3?=
 =?utf-8?B?Q1BOemY4bmxHVkM4UllHNW5NTWorN3lrV29reXB3RWZWS0NWRk1sejFFZmtX?=
 =?utf-8?B?dGR0UTNmdVpNQzhVLzNHbmM5NmlBN3JZKzNwOXd3RXhUZzQ1WHFIVU5zSVJN?=
 =?utf-8?B?bzVVY1pSSGg1VCtLVlJablEveGRMM0hJYVBGTzE2dkV2eGYremxLYzBxRG9J?=
 =?utf-8?B?N1J2QVN3blZyVlUydGk4SnFybnFJS1JRVDhHd3R4d1k2TDF2OC9iN1J1cVV1?=
 =?utf-8?B?WU5tTmRsTmJLV1FxV1lXNlV5L3hjN3pRdXpkWVpDWkNFSmZ6NDBVd3N3UjBJ?=
 =?utf-8?B?bmkxcm5Ua3JoWUduM3FiQ0ZnRkd1cDRPR1dUazFOb2FvdHczMGZCSDUwSzEr?=
 =?utf-8?B?ZGVTVzJOZndXNHN5RlJMaTVoQXpMZGNTcVhOaTFaaHZvM1BjSlFxVkJlZ25u?=
 =?utf-8?B?TmlTbnp1akM4N1lBNUoxdVo0d2Y3SDBRM0JDUHRTcWpPMTA0elJjQjVCVlpU?=
 =?utf-8?B?S2tlb2VRdFJoRDVtR1l1dzNYQi9RZ0psZ2lHdUpPRnc3UkNLSHNJTHkwYWR6?=
 =?utf-8?B?OWF5Ym85cEJiTVFScXBhOFpoK3JGU1RJZGo0MG4yaWtKVzEyTHpYM213Z3hW?=
 =?utf-8?B?ZkNFcktaUm9IaVV3bUlNN3JMSm0vL29sK2JkUUMvSk0yclpTZ2k2TFhSZFAx?=
 =?utf-8?B?alZQSW54Y2V0MGo0Z2RBZXN0S09IeHRyMXhTWkRUUjhQVldLWnJXY0VzbUNW?=
 =?utf-8?B?V2FQVlorMnFJU3RjN3dxY3hvZ1F0VXcrYTdIWVRsckpmbzV5VU9ORWZmUVdj?=
 =?utf-8?B?YXBta2IyQk9hWHF1YnF6K0l5d2lDMS9tQWZJeTlVLzlFRHFhcGkxY1pqby9k?=
 =?utf-8?B?R2ZhZFBNTno2M2pxYXZLRlBRTWUyOWNOSHdTRUk3SExNQVN3dThVcEErUk9t?=
 =?utf-8?B?UXYvUzNXL0wzajF1bzlwb0UrUytEaXRBZ25LTHdkYm5uL2MrVCtNMko1Q3Vn?=
 =?utf-8?B?LzNKcU5NTlJqYU9MQjVDa3NHRW5JK3Y3UWF6ZGxJb3pjaHJLU0gzNFJpTkM0?=
 =?utf-8?B?SC9scGxjdE84aGtuRHp0QjJPaWtZTUR4cDlCWlZwQVZGVFljM3g0QVRJazY0?=
 =?utf-8?B?S0x1T3FhcTU0UTFVTzdOak1LQ3Q3TjdJdkFmd3JnUUFXL0pkMldxY095QnFJ?=
 =?utf-8?B?UWNzc3piMC83dkpJUXFaVndFdW9QY2dxUUFOa3N0b0hRVDMwRXlIa2ZsTWQy?=
 =?utf-8?Q?qagnZxluQYIScRQOo2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b30ab621-2146-4fd3-d437-08df472bd48e
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 17:29:28.6497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ObbapAUMAyBf3A0/y3vMn5TlD03Tt8yfqHROObMkOh8sPUXyg4BjayD1xr03q1L3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6099

> Avoid reserve_addr and reserve_size to carry the information about the
> allocated space for the relocated kernel, and instead, use a single
> alloc_size output parameter that is wired to image_size.

I was a bit worried about this patch since the DRTM series uses
reserved for the in place trailing allocation

But after all the changes I made a patch that just renames the
variables in the entire caller chain:

efi_status_t efi_kaslr_relocate_kernel(unsigned long *free_addr,
				       unsigned long *free_size,

And nothing looks at free_addr/size except to free it. It is all now
described by image_info. The DRTM case uses it to free the trailing
allocation..

So this turned into a nice cleanup

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

-- 
Jason
