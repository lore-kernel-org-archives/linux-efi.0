Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.34
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794582639;
	b=drz9ODqzyxQldE2pqpZR5ECcVbFctavG8I/0iXjqVJb10ubBkA09lj0tlIpArmIE6CjX
	 R485ieptU0rKdxe9Nj7BdLCxKXWuy6BPlkWS2roZhHFf+FiRtyRFgr+bnElhL0StbEF8l
	 yXB3wG91fMzHvnZeAu2wswOpvZVs+ZgFflcHM1v9a174q8deaQKKoQnGSgYeGpmUK48j6
	 AQreU59qct1+kMNaWz0g0JgH2t6PxdqWeS7E30fv8OP5gy3tjx0OpEtvvrMc52YwDliAU
	 6jmblTpUjHHftxrcbPtT6KsWoa5BSI4pYqEHdr7VRBWiOdU8jMnmuXtA8ptAotCevUA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794582639;
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
	bh=DJHAZZsYooggA6bVZgzp3ITZI8Cn3o/4Xyjmh4afgME=;
	b=tEc6XAsM/l7QPvQjjU5lHI0HGjRonbGXE6jm2HeJ33+FwK8bxw5nl/+hh/5IDstBZE9V
	 fDvQIJ3nzOeT5b0uvH29V5ccxHO1Yp2VDoIw3wzNVTOioQzhRYwjgjiZFmo/bm1feqyjP
	 YCDK5eihsiSezeOe780wkhqm2GeiGA0I9EuOH0opUpoyOCY9+0Ci7gvE8L4TCYD4MYjw7
	 /a12jA1fuPdVIR2kNo8afT+X0YVfe27EbhIcXxez2GAs1fBQXz3LZiy0nBzHuGXpvHrT8
	 D351EUaZAK2dG1kSjyjQ9jT0OBDRsd4WuVnhA22GJ9Qnl0BgU0r2Cq5//YnHZkAgQqw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=qEu2kmqH;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.34
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010034.outbound.protection.outlook.com [52.101.56.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170B0606A898
	for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 15:10:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 170B0606A898
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=qEu2kmqH
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tlY5/mDVK/DwI0xPCrZx4jBXqSH0JsMLGrfDCkJJ1ueXyGRtDw7QIlm6WShpN7IKBOi2nZ/R0DhJ9isH+Bx7XipFdQXpHs2BIVxpRNcUfY/OUxO82AYxxXdLsS0fGtzYopc76ncZtnW0Od9HWFuRooyz7mhTpaqDQ4PMnHJkTq+yTeN21MTfaWstoRKUXQd8806/2cSVcCEIRjFVqTvsmnJX2Z3MLnp0iakpXYX+rdfI+aVvxIAUSC2cmj2J9du7MPZIIECxVH8tN/hVhSko7uDtQ/E0EloNlOyf794sniP2hrO+AzoqFObnn6RvhYG7TUCy2yEf9CMraqRzEaD+ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DJHAZZsYooggA6bVZgzp3ITZI8Cn3o/4Xyjmh4afgME=;
 b=i5YrNbsWXgPl8wdvvDkByMa4JZZrXMOnXa9YhVQJxUYH1D0F3PYi3EqZbOy24+FggmZn8Vk8UjnsfgN2oIEDfaZbMwjuxZq79t5tqejp7WfySV4eA0fDHtcmyi5uMXi7ddl56ZuYSe7UAStyWA+OVkJMMDBIGu1Am/+aRnk8hE2Hg9zjE/7u30a1JiPKd9LWytLBtVDK0gMZXxXeLipVlrdbMKjDn3H2cFOnQjUnjClg8ozNxw5u+Z/vTXNk1uOa5Db61qZVyljy04J227OYfdi8m3DEsKDdrDveW4uho9DGi57wHrCm/oGXfO1IHblFSFiOmJIhH2/U7USS82dqsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DJHAZZsYooggA6bVZgzp3ITZI8Cn3o/4Xyjmh4afgME=;
 b=qEu2kmqHrpB0WyuHaA+bLzvfQzelVEnKYjjKnakuss+cdaBs9JgHtWfr2AGP6BUI7m/0xmixuMiNeGLGjQfRlYS5BnkyDQyd3lkSQL67bkjRxlGbXaQsmZC+PZgH3KvZJSR/21zY3mcZID0tV7Ee0VnPyhHb2vfSxutW2o7t/LIrQGBNi8O01atKlnaUfkBBS/ngtiANygsSxTK5wkwl7veGboApC1k3J/wxbXzEdXQHIWp3P3t0XGhYASykr2T0roE8cIXgrFMIqCWTimnu2PtT1MGKawhi+e6ZeFcdwB55yiIxgZNI5w2v+JwuB5e/NgVqCeGWEToAwAzZZ6mipw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by LV3PR12MB9332.namprd12.prod.outlook.com
 (2603:10b6:408:20f::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Fri, 13 Nov
 2026 15:10:34 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.009; Fri, 13 Nov 2026
 15:10:34 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 07/10] efi/libstub: riscv: Use struct efi_image_info
 to access image properties
From: Jason Gunthorpe <jgg@nvidia.com>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 Ard Biesheuvel <ardb@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, 
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
In-Reply-To: <20261110121731.2728824-19-ardb+git@google.com>
References: <20261110121731.2728824-12-ardb+git@google.com>
 <20261110121731.2728824-19-ardb+git@google.com>
Date: Fri, 13 Nov 2026 11:10:21 -0400
Message-Id: <179458262197.3625095.9965048388694949305.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: YT4PR01CA0007.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d1::14) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 85872de0-c33d-4bc4-71be-08df41983f48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|1800799024|366016|11063799006|4143699003|261102123227099003|261022115727099003|261021121427099003|56012099006|261009223027099003|261022075727099003|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	hdjwcgXqCrvDGX8ybOmd3kUyuiu6nQ0Ge5vOiNTP/CP9RkQPE9Khvyg+yd9cjoSTCnWfiQFNzS+ppQkJqmMpQF2PmUvcD8+nWRFXOw6yhdCRbtzrElyq1P6corQ+D7nmb4dsB3Khtd8yeV/reG7VnLIvWgSHcMadW7mjPwSRvxhw+v1uiqUtMxvtiViO8WCiEIRa4nib/tNjyyDuIR+UvElnWcdk6hobIGE1pLtgUGX8Axk3G3F6prMs7XCKrXeL0+/GSQsjWLiXMOWx9v4CWUbh3LCETsZV0DGRRqDpfyCCw1EZMf4m2/WdBiu+lQwHW4D7VeYG9xkP7q1qg2J00mJ5dl7+9iHssBiT0fJHjo77q8RkZDMJidGHBNfmOUmmblx8OiaYYNNkRtwbrt78lOLM6m8hN1vwtoEmfzAjx0wJTdKxrjBxeqo/gJyMIb/sd1iq6BSmgSwjMM1PUhIhyYWH+RBvkzCT7uopaX0duYEMVGwzf2cOCHyYiWlRDAg/b3xNZi7j890/DYkVGftc8xCoInz09PU91qxe6aMoDB1H2wtMbR7xLzsgSaMSy+0QbmLx88ewzrUzbou1Et6G9IwEaSNhF+1e5XKaaM1w2WIN2x2gWQJquO++p6jWnH0HaYFjy6IuomGBrWC7TrWesA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(1800799024)(366016)(11063799006)(4143699003)(261102123227099003)(261022115727099003)(261021121427099003)(56012099006)(261009223027099003)(261022075727099003)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L0lCM1JPSVNEa2JYenMwMFFkd0FqejYrQnNRYkJibHZQYXVnYnlPcDVjU2pI?=
 =?utf-8?B?VDdvcER3d0RMNnVUbkZmVWFvTmx6YXpMYnovM1hnb29BK1c4VHRvcXVTT1h6?=
 =?utf-8?B?TW9tY283ckdmOU9jT0lFdHBJNW55SlJtRE1aYlFBT1RFWmlxanhQcGdGRDBP?=
 =?utf-8?B?UHdPcEhxWStXRGhkSHhqWmxoMXNhZ1JZNi9GQjZKaXI2aTZSS2Zyakk4SFo4?=
 =?utf-8?B?SWhWV3pveEw3UVpHQ3dXQ2UzZk5XYjRmeFZwamJYWXFzS1lLZkttOGtZZDRN?=
 =?utf-8?B?WXRHWFB3em5TcnYyeU01WUEwSmxkcWFWUDkvbGJ3bjJwWS9DQTRDOEE3VEVx?=
 =?utf-8?B?bDVpVVpmQUkycTJIbnFqaW05RVgrWWtFakkzWWRxNk9EbDF4VTdDbkVMdm1E?=
 =?utf-8?B?SjZLaEdsY05VSEdhV2xPVFVQK2puSlh4dktlbmdNaXZ0c0FHSGdWMURneWdP?=
 =?utf-8?B?YlErSFdWU0c3a2hwTnNTek0wUHdxaGFmeTRJZHdGYldWWHUvZHFSOVFzbmtt?=
 =?utf-8?B?R29PWExlQVhzUnVYbVBvZUtZYVVSTXBocDBzSVhaRm1mRVZ1RHlkVXpkQWkv?=
 =?utf-8?B?V3I3alZFZkZYWjMrdFppc1hLZ1BaRnlJTCtyVDVoMHZheGVwTFpyenBXcG5v?=
 =?utf-8?B?ZGZMYlBUNHlObkY4eUxRdzEyY3d2SVhOc3ozbmtOQ21NQTdQenlWN055OXlO?=
 =?utf-8?B?SDBzbVNBVFpFYWhrYVhVSUdWVmh0VVZOOWJsMmlpRnF2NndjeHZ6SVFmQ2t4?=
 =?utf-8?B?NCs3dkoyVjcvZ3dJTzlQUUxWbVlnYW8vOExOclV1WVA1ZnpUam5IUzRlNEFW?=
 =?utf-8?B?dUdnRDNVODliNGpDTzh1ZE5nRytBMDdrYmMxZnkxV2JWRUgvdEZld0dSMnBm?=
 =?utf-8?B?RkJqTEMzVzcrNCtpb3ZmZW54My9Fc0FLWmoxeSs5RnVhdzZ6c1hNMFRkbG93?=
 =?utf-8?B?dlFUZWNFMlRtN2M0b29oYWRrRG5KM3lGcjJ2VElRc0kxdnBobVZnY25DT0sz?=
 =?utf-8?B?V1c2VUUyRjA0dXY5TXAwcTFHOFVTcThMOXVWdkZyL3dWempYaytrRWpwd05t?=
 =?utf-8?B?bXJRRFdTanF3NGM4d2VFQU80M29mRzBwWnhUcWViNXkvcXVXQ0tVU3JIbnU4?=
 =?utf-8?B?TS9ZYjhVWlFyTjF3dm5TR3hBNnBxcy9ReW42QWpNMllQanNFTmIzMzRnY0pm?=
 =?utf-8?B?NDhIUzhrNEI4cHhFM1EveDZUd2dRcDMzM2dVUWF2ZXZZNUEzZzd6MitmS0lr?=
 =?utf-8?B?a2xrU2ZGVHkzejhraE1HVWhsWGx5OG1VK2I0VE81cGpIcnIvSDgyUVpUejVD?=
 =?utf-8?B?VyszK2dEeXZ1NXM4NlYxQWdVN2VyQ2M3Zzl5cURvY1J1YXF6MUdXRVBPdlBS?=
 =?utf-8?B?dkVTS0JtY3lTaHFMV0xOUzJwdE42TXJKSGczM0RvdXFPYitpOWx3a01FTzNG?=
 =?utf-8?B?K3lNRXUzTnNudWJOdmdPKzg4MnJQUWNzWGFJWTEzc1dXUi9ocGViN0lQdlRN?=
 =?utf-8?B?ZFV3RklnUjRiV1ZobGVmMGtZamZnWHpzN05sanQySTJWcnNZQ2xQLzVpZWlD?=
 =?utf-8?B?OVdmZWNUYlBLSmxwRUVzalgzb0lPZVRqYzcxY1k0MzhBWG1xc3MydnVoUkpX?=
 =?utf-8?B?RURWOXdQQmR3bkhsV0srT3hQaVRLdnFiaE1pZ0VKRjRWQzFVMEp3QlRpMXFi?=
 =?utf-8?B?RTRMTkdDSGNBNG80VjBUTXpabHpYRXYvd1hvYTl0U1k0bDhzTDJHVUo2cnVU?=
 =?utf-8?B?OWp4cnVtYUpwQVI2Z0VleEtsVlR0alNCRjVzU2dyWndTaUs0dkdzUnVSOVla?=
 =?utf-8?B?cGRVdlE5UnRsczg2My93UUdEeTltV0xPSVZETUQwZUxHbWEyUzhtQTlVNmdN?=
 =?utf-8?B?UnU5STczV1dkcTI5NDUzc1l5VUZxc0ZhN2crWlEwSFZMMDBOcFVjMTJPZGdG?=
 =?utf-8?B?aDRSZGpyc1AxZzhvLzEyWjRTS3UvNXh1QXFQWG12RGhNYXBCS0pyOG9UM3lJ?=
 =?utf-8?B?QzFPNW10U2kzTkVuZGNhdERKUGFWRWMzUFZyN0Y0cFNRN1VCUFZCQ0VKM0My?=
 =?utf-8?B?OFFUczJ3RTdPU1pyYVFWdU9VMk1NR1pzYjJNaDdIdjMrR3VlR0Rsc3NORkpN?=
 =?utf-8?B?ZlhYZ3l4RGlrMW9XUXd2VFIxa0sySm9mR052Z1BtOUxCT2EzTFFJdHdobWVZ?=
 =?utf-8?B?NlpWb1ljbFpqNi82OEtiTnNWaWpNUE95MjVOemppdVd1NmtLNUtyUDVPVXdE?=
 =?utf-8?B?TElQY2R6YTZ5Tmo5cVdGSUVTYjl0UUVrYXZXQk5nOGZHV3E2Z3p0eWdMcDZG?=
 =?utf-8?Q?/8Zripe/U/+RxF/m6p?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85872de0-c33d-4bc4-71be-08df41983f48
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 15:10:26.3677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FsGMJTMyit5gHq+1vzKt3McVGZ1sFz+QhpjbXiVutOOEcw5D/txL4+xA84AymfQZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9332

> [ ... 41 lines skipped ... ]
> @@ -20,7 +19,7 @@ unsigned long stext_offset(void)
>  	 * of the file representation. So instead, we need to jump to the
>  	 * actual entrypoint in the .text region of the image.
>  	 */
> -	return _start_kernel - _start;
> +	return efistub_kernel_entry_offset(efistub_get_image_info());
>  }

Same primary_entry() transformation is possible here

-- 
Jason
