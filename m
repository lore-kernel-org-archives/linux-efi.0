Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.30
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794855209;
	b=ktR0beShAU3MPbdvh1aaC7bcdBuuiPcTJAO9edBsNWPLShuX4Kg45Fm2Ux+p8T0eQR0o
	 9X1jchlMmYzcJrOk4EHMM52aKHlYcT2NsUt+dGHxkoA0a+s6xCUtl3U0xiChmUpvCqSX4
	 gzoGMONKmCMbOp6t3kggfbhTvW2A1+ufKoguHY8Rqqra14LeBnPuOSMiF9FyNSL1T9i4Z
	 NyEU0K6460jjfx02K4jxhtSD7tBHXOb8n+5xGmUBmEmbkLVhjTn4+gkhXoMrOdcs+sp6F
	 ADRb/SZRP5lqp4qyUKWNT3KnOtL/FFjpM3M4n+IArhxv8lvAnpAlssG6pAPZ4CKJsgQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794855209;
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
	bh=3FrOUvvctxAtF7N8YCfCQuo8p+o2txYxTOaPJmVsOsE=;
	b=3Kr2VpfgNvg+VzwWzq6/qFVmmcC2fZhAi4a84VTTEKk1U0pVhexvokgsSz675emZd5Ig
	 S16veOLIKn20vmOxEkQCL+W6OtVYYjy7emmOEke0dR1lSCP0jCcB+Y660zJ2mhqHjgtro
	 ydtepexnMYmETAX0gXR7990SJlQtXk5t2ZEHhYTAS2pec1pa15ftuWWa9bqJ9MTg99kn2
	 //OQwP/3z00jBh+aoM2TSVP2nLYSc2wow3EJE+7ptWI1349kJg4gbKioPBnhMg8tc7tL3
	 VPqrjvyUSXJnzFwoei+TIRALxloaQ2IDHl6bCqMeajyzDUqa1vldqmQFOzSeWGuHd6g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=lmU8v84g;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.30
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011030.outbound.protection.outlook.com [40.93.194.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2023E606A329
	for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 18:53:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2023E606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=lmU8v84g
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XQhKge8gLTf2U4F/RyGOIqFa0jvYay1YPBeHYJg4DbU+Q45w30evk3Fb1aBZyFmiqqDa7TmLRgeY2nmtuo0ITEweYd1thcpwNPHQAfajyb5l95vX7dVjBZu8B97UXVupzEW+ZJ17PK+r+gnusM7lnhbeI8X7OCGI7cJx8tuCd2yiEcT03+BbWu8feAyrbSC8QPTwJPTb0JPUyvGHuXrN6bfi1Yn8dbhQwRfujwRx7ghrvHNbZZ1XBTDn0XTb428eCZwi/tuXo4fcoJcjKiLUQVHvDt5feba8YLd60b4vsWBTeT9Aw5xQh/oJzfwN/bXMZ8GN4l29XrO1HqLdYMo7Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3FrOUvvctxAtF7N8YCfCQuo8p+o2txYxTOaPJmVsOsE=;
 b=hXL2BAPZr7r/AyAJsgxDzPGG05R5J/uDrSiCQisbl7xQ66wy91r0eYNrIUd7szO4bi+c3gInmxh2EHZx8M96w6y/i15SOsggoU7hm57j133qjPzPDL0MfgWaz2Io2T5OoOzrF6XPNetAn+S8BRW4qimxoXjjeWXbV2YZ2Si0bzoIIILl4IJ8YqF4mNadKn5pEiCnDwueDoDMyfb/RS2Ae3ZX42aNJdBN1N5DnwQRKEA89zA0KsclQqDwt598GvOomVIgjrHm0hiF9dOhNjelT/LQGAV78jbP4pxJCLjXPusIZBBrV+v1cEYC1MhEB1g8UdAxWiiUQV7BCUC5snurEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3FrOUvvctxAtF7N8YCfCQuo8p+o2txYxTOaPJmVsOsE=;
 b=lmU8v84gA3XrvVsrHl+hBrqDFy8ngQj7fW/v8pZQs7qEjdWN0U1E8fMDoNs9nLQNSbAzKb74n1h+RQPxUCcTHKcM0VhCZR7RLAwbJyBjEAgRCjyrpAnahZgfF3RyKjrRxBzd5fbolQym4dgj4nmQTDovw2wKN4tkbpBF58Y0XZLXSNuSaU4hmxqCCtd8O1LrVtHc8zJ6ZLNOvARthVZYcPu/DQihhIQSui5rJQAEy2N/SR9K2htGNEEXzDI83SzBWkFfpZCSRfgx8Njpe16JDNRJHxPzLvi1ad0eqLnS+xmadugcxfIDjkIcf3jHHq/62i5yOG15ukFnx8xOWRg2UA==
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
 18:52:21 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 07/15] efi/libstub: Pass kernel entrypoint down to
 efi_enter_kernel()
From: Jason Gunthorpe <jgg@nvidia.com>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 Ard Biesheuvel <ardb@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, 
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
In-Reply-To: <20261116142618.1687025-24-ardb+git@google.com>
References: <20261116142618.1687025-17-ardb+git@google.com>
 <20261116142618.1687025-24-ardb+git@google.com>
Date: Mon, 16 Nov 2026 14:52:15 -0400
Message-Id: <179485513561.2274641.9183102461241695856.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: BLAPR05CA0044.namprd05.prod.outlook.com
 (2603:10b6:208:335::27) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 7d468c57-34ac-4ffc-f7fd-08df4412be55
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|10067099003|11063799006|4143699003|56012099006|261022075727099003|261021121427099003|261026121527099003|261022115727099003|261102123227099003|261102130727099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	cX2yLdHw7lpJXUciConBSy/COK9i0yCWobF9pMuqCeXmmVQrb9SQJDGr0vBxVUvewmd0GBMIXdmjOu33eLCm9qq2np2SgR+RH3a8xHa2oSia7hN2cQKhaejf0ssvbFgFbHngM9sfy60gl5NAK628B+BbN0lSIQtIIeZvIlAC0q4bzpDnSUV7N1xA2rQ5ZJ8Miu/vSKgMFT0zMhwYZvF3YilPY1DkRJTizPyuhRf9obDoV0MDSibXSs5gAHXa+VxsiYXR7S0PUt/UchjwcwzRLEQJYZXOY9nZV2NAgblyNHVtOhpWt/yrO423k2+dleR2cWDNdp98eDB1R7qT3d0sjpORhee/iiqaKBm1arB1VzN7vj5KsX2IOds2VXddaeEwXH6pZvMe9MH18+LsFXS8Djlg7MCyNc3g06EdIqJMhXW6WL5gadcxUZbRdD9UOOZKZKd8MQms34oTt8q4qrhIYNe2u7Z4sGw7zTYz8/Uwi6VwRrCBGdZjNEV1sgglxnmTV7R96adflaMOtTG1X9NGRFEKzDYo9bfghzLiep2UJxQscJemmYG8m6nZupTmslo11WluXbVGHVCmEF5rGNSdEdSpjAlpf5hllhACtXRLbANeVEk0PbLbdPPHGqXjQhgOCUm7cLZ2P23SKgl1dxZZRAYCPL64k5E2K1BXHij7Wgs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(10067099003)(11063799006)(4143699003)(56012099006)(261022075727099003)(261021121427099003)(261026121527099003)(261022115727099003)(261102123227099003)(261102130727099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bGVYM1ZVeGFlUVdCbkhEWEl0MGxoMi9MZnFQcjFSelpTa1JyVzRsZzdIYUg5?=
 =?utf-8?B?bzEyaWcxbWYxTXlsOFBLM0JVTk9KUjFzeE92SzhsSGZsMHp2b1lQaVpSTEJ5?=
 =?utf-8?B?QUlWenZKTTQ5LzdhN3V5MWRLYyt3a3Q0dVAvdHZMTWovd05MTkluK3FTbkZZ?=
 =?utf-8?B?TnNpRmw3SGtySEtUeW1tdW1QTHVMOGxUcnhkYy8yVVBzWXlBWU1mNzFhNHlk?=
 =?utf-8?B?YVNacGZTYU5ud1dGMlB4MWhtSWR4azVmdDVqNzN4S1QvUzMxOFJyVGFodVl0?=
 =?utf-8?B?S1lneHZrSjJWVk9QTFg4bkpVbmgvdmRjZ2xWSkhEajJ2cUpXTmEvc1g4Qnk5?=
 =?utf-8?B?TWxjU0F2RXZSUmlFcHB6NVZJQjV3amNNSWVQZ1N0dlFpa2U3UTFsdjhUdElL?=
 =?utf-8?B?TWI0bTRXQTdGckJkSnlMdktwN0hzeS9pSjBWR0xhWUhDREY3MUpreHZIRVRX?=
 =?utf-8?B?aWtlSk1tYnVkb243K3RBeFJzNG02MnpaUGxyNEdINEhJbnBOVVVPN0hvZyto?=
 =?utf-8?B?RHlBaFZ0Y0lybHJTZldtYjkvbGUwZGR2T2sxRThHbDQ4TkJ6QWJDbTU2STZj?=
 =?utf-8?B?NzdhUEhqdmNHOEhlSytzZlFHZjdPd0MzcFQzUVk0L01ya2RGTFlMVWpBMGFX?=
 =?utf-8?B?eHZkTC9mdzBIRTQrU3lSSjExQnFmY2gxWWhCTkY4OWhhaFltbDVkb0xXYzdX?=
 =?utf-8?B?emU4elh1UWE3WmhIZ2IvSnZ0cm1oYnh5Mzl5RzF6bWp2eWEwUitHU2JWMWVN?=
 =?utf-8?B?K2xJMnRtSXVVSnI2bXcrVkw5cFRLQnRiQ2tKTWFWam95OEJ5ZnZQem1EQm9t?=
 =?utf-8?B?VWlWYlpEZW5BQlJ0ZlF1NmY0dVZKdkxPaVRka2dXNGVKZVJSbG95eE8zNnZa?=
 =?utf-8?B?MUxxUWpsUERqbXo5SThya3RYMUowcG5EKzA5dEt6cFVmU3AvMHVjcmFjTGZm?=
 =?utf-8?B?VjZoSWZXOFQzUlg3L3ZOT3hjdXVaZUdRWWFmNUhLTFhrcGpMdjVFZHR2eGg3?=
 =?utf-8?B?SjRsSURPb2xPNHJsSWFrQUNKRi9ncEhrZ1hjdjRQUW54QW1MQXdrdW9PTTRh?=
 =?utf-8?B?RktrYkNVa0U2ekNrR2Y4b05xVUMxRVlpRGgwSEFqWHA5OGRaNXFLRkQvZkNv?=
 =?utf-8?B?ZXQreCtyek1IWWFJaVBBemcrUlN5THhXbVVxTlpBcHVZME92K1E3Rjk4UURu?=
 =?utf-8?B?aUNuZ1hPcTFhRDhyKytBaU82K041L0NZR1JtMm5vaXZTa3dwcTBYR3RCQ20x?=
 =?utf-8?B?cTJLMWNjSmxhMEE4clQ3emlPdmQydUtMR3dPWmQzc1lVeTNqNDAyQTc5UkFx?=
 =?utf-8?B?OU50NHRnL3FWNy9RZGJ0RWxXMFJSR3Y1QlVHKzh2aFdoQ2orU0MvUlRYM3hV?=
 =?utf-8?B?TWxHdVVyVDJrbXl0SDNJeVpUakUxQ2NvOVRlLzlOZFF5ZkI0ZEJzbkI5V2hV?=
 =?utf-8?B?KzRQaUt6OTRRMGk3NTB5clBET01Sb3cvMTZpZVZmeGQyVzFONHE4d3kvNmFu?=
 =?utf-8?B?MEV2eWI2T3R2TERGeUo5RXNIMU9tWVBoSVc0c2hDY3p4eURva0hxemxjTDd6?=
 =?utf-8?B?SmVWUGkrWGYxaWViSEY3YTRSY25hdkFWSzVXK0t5czdtSlZ4MGh2bm55SEYw?=
 =?utf-8?B?dDlBOU1YWnpDTllrcThqbG02K1VjSTE2a25USDVjZVFBK0N6eFc2aUg4eWg5?=
 =?utf-8?B?enV3eDhveWNrZUdDdWErMDlzZmFVUTY1S3pEY2psTTI1aVU4TEh2ek1uRVUy?=
 =?utf-8?B?ZWxFRGozTnY5KytqbGxYNStsZEdrd3F6S3N1czJJQUc1YlNoQlJqdGZzYjFC?=
 =?utf-8?B?YTlrR1ZaYXAxSlhvamg0dnZzRkpvcTFoR0tBU1BQVEpkT2hZSEdDcldFcVEv?=
 =?utf-8?B?NHh4ZEZkcDJrbTBXWGdtTGJkbTVrQnlZMWFFZGl3TktRUXZGSWNCSXQwd0xY?=
 =?utf-8?B?S2d4L09DOGY1Z1FmNThCZk1EbVNQRmtTQkluaW9yRmpzQU8weU5NVFRPLzdZ?=
 =?utf-8?B?ejRQc2VyQXRFOUY4YXJPakhyMUhra2N4U3NRaHlIVjJWYWVGUG94bm11Q3ZL?=
 =?utf-8?B?UmF5Q2VYbHd4eURHTEJZb28zNDNOdVV2aW1YUGRzVjJpQTE3dTl0a2pXaEJv?=
 =?utf-8?B?NXFZSEI1bElMUURoTzUvYjRVWStvbDhBc29haHFTWkxoSVFHM1NkL0xGNVVS?=
 =?utf-8?B?b01XSzdWbWlHeGZRZ1YyMnlaSFlrYjQyeGtEZTNWd1VMeWdMTm0zY2toYWtJ?=
 =?utf-8?B?aXN2aUVnYndJaERjUGxWbkdkKzdnZzRGdC9HcTJoL2s0RGNaN1U5bzl5dWsv?=
 =?utf-8?Q?IgYiwcIMRoN9dLLced?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d468c57-34ac-4ffc-f7fd-08df4412be55
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 18:52:20.4413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mKiHZARiRbN56wbmt5hXJmKRtLQwRa7pyrs6RlnpK0wBelHhmXVCys1naTytS+EH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9641

> Update the EFI stub code shared by arm64 and RISC-V so that the kernel
> entry point is taken from struct efi_image_info rather than from opaque
> arithmetic performed on linker symbols.
> 
> Notably, this results in EFI zboot to enter via the actual kernel
> entrypoint rather than byte 0x0 of the loaded image on these
> architectures. Beyond that, it is mostly a cleanup that will allow
> special linker exports for global symbols to be dropped in subsequent
> patches.
> 
> ARM is a special case here, as it combines the EFI stub with its legacy
> decompressor, and so the generic image_info carrying direct references
> to vmlinux symbols cannot be used there. Instead, it provides an empty
> struct efi_image_info, which is passed directly to its implementation of
> efi_enter_kernel(). So on ARM, populate this efi_image_info with the
> base address that the callee expects.

Does this mean that the EFI stub never sees a decompressed image on
ARM and jumps into the legacy decompressor?

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

-- 
Jason
