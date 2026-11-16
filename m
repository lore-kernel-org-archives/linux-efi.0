Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.7
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794855148;
	b=i/ocnS/FqJW2enEUKQ09NxWsq5NxGazbK2YrfdXN2p2t72drSfiasBscsOJB/Py46noR
	 CFKBGKziJrtK7FpKFzIlcUcciqiKyAee98ZADyy/AKn5NE+DpdB8YLhCcmiQ9jHS/RZ0V
	 VTZN0pKn/HgWPe4cde3nOnI6oFSHuYkg5q43WdFY+FjsIdC3QlXZCyw0BgnQi5rGguNKZ
	 +3+7rwWtEObHVjijhUjZthnmxqh713lfMSNRvQ2Z//I6BkGjXQsRrA0S84cZVPHRxLhug
	 +VTx4tnxljpF+adpasIPpkDfx5uIeh93ozcqsJpfv9c7k419XmOkCXtUgJAUFzXcPrQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794855148;
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
	bh=8RUgWaH9VyszlBCINI+cxqtImqNXVVj6TPRSkGYlSkA=;
	b=uvpahhJjCUc23AoGjoBV8NgRFMY4VohzQf0TVxIFzh4PBaLInqctJeoqCoyZYHAMSBJV
	 rhXGd6klUgnnuVjELBs6vd9yRk96afcA4gKhvzf9d10nuwjfJLy32OYoiLlErd0kM8jR5
	 epxpyz/wBt/fxkypHCPDgPDnTLWN0tSJB0lY74SuR+QladhEs8Wc13m+P0vCzPOG9FKqy
	 l7kfF/b+Xr9HnEmFtlr9B7P3hi6LxjaclXyush58iVGNVnO6jMdh2qhQJGU9qvC557msx
	 i31xfYMCFYiAM7+P4tBokU20WnqeIdwAwUiapoGg2dqR4PpPHznN6tRD7Rjh4gjIFAw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=lgPykTyb;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.7
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013007.outbound.protection.outlook.com [40.107.201.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8A6606A329
	for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 18:52:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5A8A6606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=lgPykTyb
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r0BXksBixUKH4zqBLzltYluwmEPb7vIlmZqJ1kcWjT1m12IXtbvk1EDQJl1Ch9Afc1jo1U6R2fi2WmlUjbzPF6dIN6VCYW5p91ichkL+brHiW1Gm+HcYsomJVj6gMJAGqlcItVx1nqtEkBarQ+e0asGW1HWdf7ouN0SqgtMw0gwgc1OrwXPu88f/QUsheXC+Lm4pnItjvf6YyKZRcoBgX7JJZWYBg1Br2SihK2eIU0+nYYmNE6O4V3LxqfcL2Ttnlrn9FMCl8wMZatE0IoaPv2ICt4OYOY7z2WM+XvRo0RXcWSvyAJnOYlkyYUFe2+lyKPVzq2DYPQ34zwRGsuRruw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8RUgWaH9VyszlBCINI+cxqtImqNXVVj6TPRSkGYlSkA=;
 b=AJC7Gq6a6zfM09Ir9P7dsLU1UgwKVP/5cFpm7+POoLhEAaddex3XF7Bzodr89yBkkZE9rPbOwlHVOxljsz65Te5CUtzQank3IklU4pFfIK/wONICcFvmIOUjkumiun3ngyO3mQ6pYeTbjJ4a44XJHywZ+St1OoRX+Xps3nETGkYBC7uL3dYBF8EpPw7QY8fEc4Z3gysbZ9XWG/8iDdCYUNYNzLNajFH2RtC6OsC4yDku5zDTTe4rPgr1MoPqHlpobA3+TZ4vWImsSXW9kG2C6tRgWOyXNIsYHG+e2/RCAWn0HyT4hFxjixy9Zdz0LLSYBGgVs5M9TXpPGfzNMpOOlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8RUgWaH9VyszlBCINI+cxqtImqNXVVj6TPRSkGYlSkA=;
 b=lgPykTyb6XfFGVPH3bpCDyXvrHxJR6u/I2hI5pUXJBEF2sPucieb2YgabKJylfEtgUNx7Sh05ZGrP/QF6A8CP+0HPITod+Y0C8GTJjX15MQGBxzFp+t1kTxMUxTHVmHOpJ82qTllKoXxXeRVT/t0jNGEvZHtyIwcf5+Hvr25UVMDlQpT23KgVlgNigEYU59KGGonEnkJi9Nbr/4J7+xCTV1MOv34iMOKNyM1ErVXD9t2REFO+291aeYcx8SqmmN2D+bAt+1LpRwQumT22dS1MP/0pym+I3/wFOGxv6wUDj9cSJZurNOfZkqZH3y50VYDyNPAJNBQ6waEZVQ+WuTrRg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by IA1PR12MB9062.namprd12.prod.outlook.com
 (2603:10b6:208:3aa::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 16 Nov
 2026 18:52:23 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.013; Mon, 16 Nov 2026
 18:52:22 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 06/15] efi/libstub: Capture loaded image information
 in struct efi_image_info
From: Jason Gunthorpe <jgg@nvidia.com>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 Ard Biesheuvel <ardb@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, 
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
In-Reply-To: <20261116142618.1687025-23-ardb+git@google.com>
References: <20261116142618.1687025-17-ardb+git@google.com>
 <20261116142618.1687025-23-ardb+git@google.com>
Date: Mon, 16 Nov 2026 14:52:15 -0400
Message-Id: <179485513560.2274641.10982738313174176436.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: BLAPR05CA0032.namprd05.prod.outlook.com
 (2603:10b6:208:335::13) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|IA1PR12MB9062:EE_
X-MS-Office365-Filtering-Correlation-Id: 07bb6b7e-13c1-4f00-7eb8-08df4412be71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|22082099003|18002099003|261009223027099003|11063799006|4143699003|56012099006|261102123227099003|261026121527099003|261022115727099003|261022075727099003|261021135927099003|261021121427099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	+rV+4Zo22HTaCoYtqwjGWT5neCCUgZXQ7LLk4iptsceoaJV37LMXfaumxXhAAkgRO3klk8qhhEMrEYR5sgnqXavIDeaXrmVec55wj5loGXvSEaUFEqkBtZmHRsRAzBU5aNpEdAjhpKivzx8DAb93TnMyM+U7XDmJydtYy425VdcCxkLjZpJMUggaytAjiCrgEC3rvMwGxW6qIp5UumBAbOuxcvaq9Amry5hCZEQvCZMA9lvKwX4eXd4L9+/8DTXlvnkrH2paKHJ8XqzzUvWcpEVu2J3eA9nSA2ZeK2zcRjQPDn+liyChlQnruSrf/tiadQf8YPZZ+Z4WIyvHMU/ihU7YV65PS6s3gbu5bm/VohqIWYr3y1J8M34s2THw/DVCLXOXnuTbsBNDZz9Hylgx2j3wfjOnl1tfDsgb5tsQ6jAQlHofzFHVqSzI/s7fr+63KSx+VHml77V38m2o1OB8TXHCoJlKi8+ZrVSIXj6y18Fcdxa0vvr+Eigp7DNdSTeQJftU6BNcP0+naO/I3fbYyfdEPOAPVfrif/dXjz5NUXNTbkvcMz4rj7Du+1qTIDZ+pz3koDr9mJxfRkJl7s04+I6Uv08IFkcMxMu0dmiPTASD76BqY5dPMmJBa/KRL248M6NKhb6aa92rduC/yJ6rBm/k5qgfiDH5SvtCu2zYFAc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(22082099003)(18002099003)(261009223027099003)(11063799006)(4143699003)(56012099006)(261102123227099003)(261026121527099003)(261022115727099003)(261022075727099003)(261021135927099003)(261021121427099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ekFrUWZ6dVhDckl4L2pFVCtGNzFQR2xxTUZyamJTSVBNajI0T2R4a0l4Ykh6?=
 =?utf-8?B?SXFKeXMyQ3A0Tm9pVmU2aXpONWsvbGJpU2hnV05OanNPWlpOUld1bWZGUC9h?=
 =?utf-8?B?aDh6Z2wza0d2REw3dEErc29ReXFxMkhEVG95N1U5dTBnYUhJRVhZaEtUYWFm?=
 =?utf-8?B?Y0FyNG56YkxaT3d4UGpSc3dXdnNwdHdOdktuY0VhWDRkSTVHUHQrR0gyenNG?=
 =?utf-8?B?RkUrQ2lzMHRDNzZWN21nYXVKT0hLbWlWNDB3eHhGTnNSTDdzYjZDajlCcFg2?=
 =?utf-8?B?a3VOeU1iZ0drd1VwbWFFZmllMTZ0L05zc1lMbjl3ZlZWbnRacWZTVFJXTjFB?=
 =?utf-8?B?ekZicG9odEdzd1BSTEthaUNzVG9nTFlvSUF6RmkrOGd3Q2xLRU1FMDRzZEZY?=
 =?utf-8?B?MWltdEhuZG9hNm9ySFJRNzQ2R3hnTFdJc2dRUDJmT3VUMjhZaVN2cTkwTUFM?=
 =?utf-8?B?YVBPS3RPckI3czllbGdZM3NQREQwa2dGZlZBcEwxZU4xTC9WRk5NSGxXNkJt?=
 =?utf-8?B?VURnck14OE1RdDVxV3NSUU50djFDamFsNWIvSzB0ZW9VaFhKdE9QYVdZSWhD?=
 =?utf-8?B?YjFvRXE2YzlpUys4VWw2Nnk3NXNHUHJpWGlxZUh3MlVtR2k3ZWlhTG9keENK?=
 =?utf-8?B?N09FaHV1ektGSXR5Z3A5WENXTmdpajdUenpqdlFEeXBOcXZpR3hvZVR5b2Jr?=
 =?utf-8?B?WW83TE4wSzVRQ3BwRHIwa3UyYUl5MDRLZStLdS9tVC9hWjZDaGkvL2pHdDRv?=
 =?utf-8?B?T2dKUlh1NmFIT1N6MHoyUUNzakc3bzdhTWRhYVFXOVl0N3hzUnE4M1lFbjdS?=
 =?utf-8?B?NVhCSkFQR2p4bFhhK3B4N2RDdUs4dUlSQ2JraVZ3dndQMmlMRVNWMDdFOGUx?=
 =?utf-8?B?KzRqbTljR0Nkd2lMcnBuVnY1eDRpeEFSK1ZpcVZiL0VnWVVLdEdYV1JtbXZs?=
 =?utf-8?B?ZUlVeUF2U09zcUduVE81K1Q5a1hrV0Q3bWNjS1QrNDlyc1cxVXQ2VnRML3NK?=
 =?utf-8?B?Ly9qVFlROTJTR2d5Tms0VzhlUXdPamI4K01NRnhkYjlRekhkUC9mcnNwQlNG?=
 =?utf-8?B?OGVaYnlKM1NLRlZ0bm8wWVYrMTNxeVNSU1RZMml0Z1RjOERNSm5sd1RoMXBr?=
 =?utf-8?B?Q0k3L2ZIUmQyVXBoNFdpR2FMYW5uRGk5VDBzQlVTTUF4K1h2Lzd6VFBaSlJu?=
 =?utf-8?B?dWJYZGJzREhDcDZqZUd1QUNNZzhjQnVrZW1FbTNYNWZhQ1I5c2Vmb1kxYUVW?=
 =?utf-8?B?ekRScUtUc1o5NytqejhCZ2ppSTh5azBnQmo5bFQ4c3UvclIrNENNNWlZeEg4?=
 =?utf-8?B?OHdWeHRjb0N0c2RySDRYZ1BPeUpXZENHMVZQMmZVOURuV1pFdkJBeXdZWDht?=
 =?utf-8?B?MWpYZExMTmc0U1N3WWNEL0RqU2hraTJvaG5jZDBDaFZMQ01QOHNEdll3U2ZU?=
 =?utf-8?B?QUlxRlZ6OVR0K1AyWVprY0ZBM3QwQnhZOFBhNm1nd3Y1UXZQdElNK21kc1Zn?=
 =?utf-8?B?WkdPK1pJUmFVeDJHWWhGQTVwOEJGSlZ1V3pvTFAzeEFJWVRucjc4em5QTEo5?=
 =?utf-8?B?MWloVW9laEh0VXorSk80WXBLZWk1WkQ2OVA0VkcxNlp0N1FiZXRqRlMzUStu?=
 =?utf-8?B?b0M0UURtM1l4MDN5N1N5TXZXOXlpVFJWQzJoL1ZOMHJiVjVzYkVaK2ZGdUJi?=
 =?utf-8?B?UHBqK2hVVmNlNFZNZmFOcXB1Zkppbm5iQmNBMU5RdTBraGhPLzNTcDhmc1I0?=
 =?utf-8?B?L1JUR1l6eDFIUDRpWW1FTTNtMk1nQmtJaVcwUURpVlJTS1B0a2l0dnY4cTR4?=
 =?utf-8?B?UnJiOW1wTDhKWjIvanVQTEl0bzF3cjhEL2NzOTNzRTB1R3FNemRvZWowRmJs?=
 =?utf-8?B?bi9yaVlwNUhVRXltT2FLck9MRG5UNTF1Yng2dE5VZ29DeFNtU3FRMEFFRjY3?=
 =?utf-8?B?V1J2RlNYZDlIUkQrMWovTlZMRk41aXY5elN5TDNBcW1zWGJNbjhNTEFNWE4w?=
 =?utf-8?B?a0R5enErdHV6ZnV3Z3c3RXo5WHBvK2p3OXJ5MUppOU9uNzM1SXltL3lIeFBq?=
 =?utf-8?B?dGRId2dGNDZsajZDSFI2WFFRdkQzSnpSaUNpUlFIM3VpeVJhV1pwaGZPV085?=
 =?utf-8?B?YWdRU3JlNkQ5QjY5OURYODNRb2V1SFlPZnVlMGlDa1FnK1RWWFNMeDA5c0I5?=
 =?utf-8?B?R1VqWTlieEhzb1JkTjVORGhMUHJIVzRhb1grVHk5a2RPWndtd091UkZrMlcx?=
 =?utf-8?B?eFk2dHI5cEIreHArOVdleGZ1c0FPczloZ04rMW1iUk1UUTR5anpzTERFU1Jl?=
 =?utf-8?Q?OJUJkSFUVnxhW5T9cV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07bb6b7e-13c1-4f00-7eb8-08df4412be71
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 18:52:20.6292
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A7IymVuGHsccx2hAGMVAufS7clRFjKmi81umn5zLk5CS/vWUA/nJnJU8zGLlRblT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9062

> [ ... 115 lines skipped ... ]
> --- a/drivers/firmware/efi/libstub/arm32-stub.c
> +++ b/drivers/firmware/efi/libstub/arm32-stub.c
> @@ -76,12 +76,15 @@ void efi_handle_post_ebs_state(void)
>  		      &efi_entry_state->sctlr_after_ebs);
>  }
>  
> +struct efi_image_info efistub_image_info = {};
> +
>  efi_status_t handle_kernel_image(unsigned long *image_addr,
>  				 unsigned long *image_size,
>  				 unsigned long *reserve_addr,
>  				 unsigned long *reserve_size,
>  				 efi_loaded_image_t *image,
> -				 efi_handle_t image_handle)
> +				 efi_handle_t image_handle,
> +				 const struct efi_image_info **image_info)
>  {
>  	const int slack = TEXT_OFFSET - 5 * PAGE_SIZE;
>  	int alloc_size = MAX_UNCOMP_KERNEL_SIZE + EFI_PHYS_ALIGN;

The hunk from "efi/libstub: Pass kernel entrypoint down to
efi_enter_kernel()" should probably go here, and Sashiko is right it
needs a little fix:

 *image_addr = kernel_base + TEXT_OFFSET;
 efistub_image_info._text_offset =
	kernel_base - (unsigned long)&efistub_image_info._text_offset;


> [ ... 3 lines skipped ... ]
> +++ b/drivers/firmware/efi/libstub/arm64-stub.c
> @@ -19,9 +19,11 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
>  				 unsigned long *reserve_addr,
>  				 unsigned long *reserve_size,
>  				 efi_loaded_image_t *image,
> -				 efi_handle_t image_handle)
> +				 efi_handle_t image_handle,
> +				 const struct efi_image_info **image_info)
>  {
>  	unsigned long kernel_size, kernel_codesize, kernel_memsize;
> +	efi_status_t status;
>  
>  	if (image->image_base != _text) {
>  		efi_err("FIRMWARE BUG: efi_loaded_image_t::image_base has bogus value\n");
> @@ -38,9 +40,16 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
>  	*reserve_size = kernel_memsize;
>  	*image_addr = (unsigned long)_text;
>  
> -	return efi_kaslr_relocate_kernel(image_addr, reserve_addr, reserve_size,
> -					 kernel_size, kernel_codesize, kernel_memsize,
> -					 efi_kaslr_get_phys_seed(image_handle));
> +	status = efi_kaslr_relocate_kernel(image_addr, reserve_addr,
> +					   reserve_size, kernel_size,
> +					   kernel_codesize, kernel_memsize,
> +					   efi_kaslr_get_phys_seed(image_handle));
> +
> +	if (status != EFI_SUCCESS)
> +		return status;
> +
> +	*(unsigned long *)image_info += *image_addr - (unsigned long)_text;

A little helper inline to do this adjustment would be a nice touch.

Since it used to be done with

-	kernel_image_offset = image_addr - (unsigned long)image->image_base;

Every arch can use this?
 +	*(unsigned long *)image_info += *image_addr - (unsigned long)image->image_base;


Minor things, but this all looks fine to me and works easily for the
DRTM series.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

-- 
Jason
