Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.7
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794855149;
	b=E1/WYj+uqFAjpjTIFaM/YRkySBRco14DbaGp0FXyjf+HTEmxOxRd7tP5y9yH7wAQvo+U
	 eXcaHLtHxjFXHcTDvWMhzsqRwhAwNWEft4XQfKs827aA1nXhtmdRqiDVlP27glP746sfV
	 btLzGnULeml5yclzmsexLJVoB3alcYAdb6pJ17JjmcRUN34WoRE9dutMuY/zcnLlo90DL
	 21xhvP3PChB2RRknpsT5va17ZOaQbgi8j/fSWiYssdStiDUiZ85JvgRpsLv2uzQhal8se
	 gbc8TFWT9FOiivxjnht+XhDJy1iUm7qVbHPuuykFdix0cng62WBp3GAauGU3A/feMfA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794855149;
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
	bh=Pd7kHXoQYAvkSL6Fe8sfiwyKG2v9pdYYUbCMSKoe+4Q=;
	b=fifnsGM7V462t4j9vstiXx+cvwy9kmq2RqmqtBzIjoCzR5GxBGnKuajml2FwAW+c6nvp
	 mNe1t6tTY/I3x1rKjG6GnQl/xYpoASzjLb7xe/771FKakWeSXm4E6H87DxzKDZDmYuEI7
	 1cPSyhtGYS/jTEk7FmNuRdyi/XK94My7U2wXRAVZbdm8PpZahGNu4bAZ8JU1wr6vj6ZsS
	 PcfJh1FS6gz2hu2TrkiD04revntVH+h9bvtum7OHHYNn3zuKm8D22oaU1NqJRMZk83+iJ
	 xkHbTjetGQ4xLIg8cJ8bLR8QGeenLD7IZsRJ511QIsQOFXmEcY3uYXMy1/d0N1foE6g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ZzFxqVUN;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.7
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013007.outbound.protection.outlook.com [40.107.201.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F33606A330
	for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 18:52:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 05F33606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ZzFxqVUN
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aYxI7uQ6GyRqMHRJbkdEMiOze/wUXgTKMLbCxx2dlRZCE3Qr44x2hrjDqVB1AFAnRyggysbLgGR6XEu14j5hILF+q2q8U0cgszlfQHsIxqPTB9lbxGrAf+AqgcFNXPN8K/DZsx/1QyxcyZ1oo8yHvu1MIKqkuGUjQk28RhOGcjltvP6sUsIg+YWCOgX8eKPb/j/YFdFhIcQ930g1n4HauamgotEcuP8kEmpG+FCtsDJ4/z9anggqV93lBFp/FDJKbvncg8ZK2yX7LDJOYbewUMTZ/Y5IFB9gMUQiMyxj9/+YHBiT37lMs23qQIHNX+zq0c4OC+/qdgtrzQNZZXTpRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pd7kHXoQYAvkSL6Fe8sfiwyKG2v9pdYYUbCMSKoe+4Q=;
 b=qPT4aPLS5c6oOqhNo9ErolSNhlk5Mx7R+PZa6Ju/IJZRuOuSwLaXZ7Qdw0EBWkK0DZV01GjCgyyG0BS68c2f27rrz7wdVMGRpP2H++n6/lIS5h1IpRb2UQtMkxecywXtAnjtOky/wqlgaaxa9/FspD4h78YNJbawa9zEEckU3bonF7rniFq1on0ZGvFu5NTH8xZoQNLvGILtcPvfKL0OFucrcd1M+iKnJSL4VLmY5670CKu2EULoMrs/4eEH1TvQ2sUeaz2wKuTDJ+ZSh/AKeboaK0Jqeo6PwoMg7WZcBwqLqrP6c8lzTLZhfciLxCXIWR8+8XTFjAV53d0YOU+c3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pd7kHXoQYAvkSL6Fe8sfiwyKG2v9pdYYUbCMSKoe+4Q=;
 b=ZzFxqVUNcMjzNexOtj3PdR+JJklZLE8QVM8Gs3L2YvhYGCgY/tSBA15Soa9CSKkvMR4mGqYDroizHCTr3a4n6Y/zF3N11VvEN1x00FUSIU0p1RuToVMhthNJHb/kEKilKs8Q2OzLYGFL3wzoKVBtyv63WZV3VQ9hnGsftj6ZgrOwqDCH369iJBvmkyE3jAwOMMAUPGaIXAdvohE0+FvTLb0zM4Lgi9POx5xjhK14Gdc1dFnsI7xzi2dD0wd4NurHdMeS//UzIFFusO/1tBMweLuYBHtIKYyimlJa1Ewld+Afejzz+4p8OcXkzaZBozpNJgEtMfcPgXL5/6qP7uwb+Q==
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
 18:52:23 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 08/15] efi/libstub: arm64: Use struct efi_image_info
 to access image properties
From: Jason Gunthorpe <jgg@nvidia.com>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 Ard Biesheuvel <ardb@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, 
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
In-Reply-To: <20261116142618.1687025-25-ardb+git@google.com>
References: <20261116142618.1687025-17-ardb+git@google.com>
 <20261116142618.1687025-25-ardb+git@google.com>
Date: Mon, 16 Nov 2026 14:52:15 -0400
Message-Id: <179485513572.2274641.13924640952978903053.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: BN9PR03CA0704.namprd03.prod.outlook.com
 (2603:10b6:408:ef::19) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 83f0ef7b-d88e-483d-d70b-08df4412be79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|22082099003|18002099003|6133799003|261009223027099003|3023799007|11063799006|4143699003|56012099006|261102123227099003|261022115727099003|261022075727099003|261021121427099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	B83xSZCwD+IVANwzHGOGYesSCH8x6qsmslaXAqPM16zk47uQD5a6Un5B1tsN7/gaLlZ8RMTHo3BlNG+LnDqTlCIRkmhCxRRnsXziJ5r1d/kh+9ApIuNf/m8Zb5r9ND7c9pTxVIfjl09ek8IBq03Ui94B617O6Hh+OTVEpr6MPxuY4TXPG3gv3iiESsnEq1oM59uYATWNTEUMqySjKSk4hXgvalblscFiz5zJDsTjzBoGWSF3JJAKquWeZRfB/BVnwlCWPNsfa1kF6Q0na7/EFaKuLrpOKxlEyjWo5/1DsvYeXPmxgW8EHO41XYPyQQsbAoX1xslhJKPxb1/E0f14jhdmEC3Nlev3nqTZ4KJTEG+ra3KR4TB8QDbBNuFOs1aZWscfZeBROK9S3wwswycMiPM1NhGZmf3LqXXoIJhnVQmbKVvmFjrXlxcC06DlD+O9V5/gZZcaQK3G8xKdvdtQO80xGFBzTrApG3CbDfeVtlGyDhdv0tq/cNgRtn54NPxStn3FCBhYi1pB2+7FM2DtnHu7KgzK4YirRblqx+mk73rrdrqVHd2bU7FGAFBOv1CCaYef6yXT3DiFpaj3zv1eDp43KVxAqwkojLspS/2O34TNAA9cJqO+gNZCCacCkc4K9RolayxrupyMHOoFpAr0K60gQkVT+yXVrCRXE49N6mQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(22082099003)(18002099003)(6133799003)(261009223027099003)(3023799007)(11063799006)(4143699003)(56012099006)(261102123227099003)(261022115727099003)(261022075727099003)(261021121427099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bEh0MTQ4OUFla3pvM1VPMERpa0NWRXB0M1dqbUcraDNoWlVvOUVkblozMDll?=
 =?utf-8?B?NCtiNGYzVUg2ZWhsenB2S2IxTHZ1czU1THZBcmRFTk9nZjJFWC9XSEl5alZV?=
 =?utf-8?B?Mk9GSFUrci9vWXMrK2xkKy9FTEFtSjZhSUhGVFdoTU9LNjZMSDlQbXd4VVV6?=
 =?utf-8?B?cEtBUk9Ndm5LTTl5eVJKRWN5eENUSjdpWnNtbUFTTE5CTlhpc3NrRVVvZGNK?=
 =?utf-8?B?ZXBBUVJrTFVBWk9UOWJxNHl5bzVhN1hRNHpabW4ycU1rSG9BbkJkVEVRWDFH?=
 =?utf-8?B?VjYzVTloVk9MNGQ5c0R3ZDFTUlhoVi9wOFEyY3V2dDRrTU4xdnNQazM1WWJ4?=
 =?utf-8?B?Q1VYR1hpYkpOcW9ISWsvM3NFWkEzcnB1OWRFdEdlU3c4eGdzckpYcEc4U25V?=
 =?utf-8?B?V29GczdVa2IyK3FsUityY2xZbjZGQU1yOEN0N1dma0JlcGo3bDZia1c3RVAy?=
 =?utf-8?B?RkNBaTZhWTdoU0Z1RG5HaTdDcHZMMk0wSi8vdTB0MGI0ZjA0ZDZwT0d6WUJw?=
 =?utf-8?B?ZzB4NHhGZ0tvV3UzYURFKzVsaW9vUk53MnZJRngrUThRKzB5RTRjRXN2VWZ1?=
 =?utf-8?B?UkZKbHJBSDk1NXY0V0NQdjdsdStMUXVNem1jdTVDS090TEt2aDF3bHB4QVh5?=
 =?utf-8?B?NExBNHlFT015N1NnQ0gwWHdRR04wUEYzdmlMVEpzUEFiMkpON1lKRy9EdnI2?=
 =?utf-8?B?MmEvY1NKc1piekpHcnR2dUZ0UFVBNXpBZW9wcThNeGZlK280S05JbWNPeXlU?=
 =?utf-8?B?ajdxODVLK3dZdzhwMlg4aHcxck5ZSW9XMHRWcTZkb3hGbHpKbmk4RVJ3NHdl?=
 =?utf-8?B?TWRmOXZnMGhHNlMzVXFDRlA2amgvOWlzeVhXQ1k4NkVKdHdYbGVmbE9PMFJa?=
 =?utf-8?B?dHBEbTRaNTZKanEvWU9KSzA0YmtqRThGdUJsTVJTNXlwYmdrTHJ3VGZPTGd0?=
 =?utf-8?B?dWhqSXV1Z3N4aWI2azA2c0xobHRWNVJ2YmVheTRiRDNIUy9sQjZOTXdYSEtm?=
 =?utf-8?B?OC9Od3RCNkEyY3R2eDhyL3U2bHN5QUt3dVBtRThlL01iYmpFZk1sV01PSVdF?=
 =?utf-8?B?b3JvV081WEJrWDNEZVdXTTc4THdRcEh1Z0pabThKUXZ4M0xoOWl6S0s3NWIr?=
 =?utf-8?B?MUNIT3BRL0wyOGxSS1dGL3liME1Mb3R3aVRsaWZkeGhTcEVuL3Z1S1ExcWtP?=
 =?utf-8?B?Vmo5dis3bC9mQlVHMXdIK3NPNjRmb2N4aHF5Y2ZmMHpPZzVEcHZnWU42VHNJ?=
 =?utf-8?B?N1Z3ZngvRThzZVB6SkJMZkxLaUpTcHJ0ZHk0UU5PM2laY1VQZUZOaitocFQx?=
 =?utf-8?B?LzRwMXJFOGZTME9OUXluckw0bnRQcGY0S1lJV3hFWFhGSHBJRHNPK25IWFpy?=
 =?utf-8?B?ZVhpU2g5YzY3SzdLU2daNkhERnBONzk0cE5wZ3EyYmxGbXRSMXBwVFJ5Mk1Q?=
 =?utf-8?B?eTRpblh4TG43bForSHduNUFDNzBsa0NsVGlvcXBvQ2hzaTA5ZnE1WHJGNllT?=
 =?utf-8?B?M3ZuT0wrcHlQL0JkMVJvNWFYMVhtbmo4K2s1akNzR1dLSXJrZnNjVXEzZm1B?=
 =?utf-8?B?R3l3WkpEQUR0SjlENFFsS2lkejZOblJHUVVOdzB2VXJIaVR4UHZaVURQcDla?=
 =?utf-8?B?UHJ3N01DSE81ODVDNzk3ejB4bHp0TDEwUkFJR05jc3piMFZsVUovc29mNDJU?=
 =?utf-8?B?S21mZ3VvTVNFVHNLWWxJOTluOG5FSGltNmVwYWJrYnpOdE44UEluT01MMEwx?=
 =?utf-8?B?Mjg1ZFlzOTVTUlFXUnlFa09CY1hWSExLeGZuTFFleVIvdWkxSHo4VTJHUUp1?=
 =?utf-8?B?WXVxK3MrS2lVNTUzTmphdGM5bnFSYU5aczVid2NjMDF3bUFZYW96Z1NtSmRH?=
 =?utf-8?B?TG9DK2wxei90TUZ5TklvK2tJZTFJNVBBZXlZdDNRS3BvWGp6UDRicXlaL0Iz?=
 =?utf-8?B?NjFkcnR5UUh5YkFONkEyMEpTY3p4TnVFTHoyYnAvc1lsd3VwMTJhMVhqRzVi?=
 =?utf-8?B?eUdVd2tIODZ1d1V6UCtoN3RQL044WUZYRUlyY2d2M3g0dGkxb2p5bGhtWFFQ?=
 =?utf-8?B?cFl4eVVUQUlqRUlwQk1YZ1NnOGFpekZhRE1STmo2SEFNS1ZIcWF4TVhocHdR?=
 =?utf-8?B?UFR5VW1HVGRyTDdPUUw1d0lrWTF1QzdRam5RVEJqNm1UdzZSeEdpeUpQKzhM?=
 =?utf-8?B?bWJkTUdTcFRROUV0MFAxUzNLbFJtWXdXQVRmZ09GR3kvRkV6UGpKMkZaS1lH?=
 =?utf-8?B?ZkltRGdjMFkwQnhQbHdGcTVCc2MvbTY1SVl2TFJBSUVMRjU2eWluSnZla3ZU?=
 =?utf-8?Q?PDjxxIxDDRCvbigmVj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83f0ef7b-d88e-483d-d70b-08df4412be79
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 18:52:20.6849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zqjxYpiHDLArQneMMqt0lHZajaDsdbRf3e4JWrOflJ9PHUCuxuxSF384bj+GYh7G
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9062

> [ ... 53 lines skipped ... ]
> @@ -22,23 +21,23 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
>  				 efi_handle_t image_handle,
>  				 const struct efi_image_info **image_info)
>  {
> -	unsigned long kernel_size, kernel_codesize, kernel_memsize;
> +	unsigned long kernel_base	= efistub_kernel_base(*image_info);
> +	unsigned long kernel_size	= efistub_kernel_size(*image_info);
> +	unsigned long kernel_codesize	= efistub_kernel_codesize(*image_info);
> +	unsigned long kernel_memsize	= efistub_kernel_memsize(*image_info);
>  	efi_status_t status;
>  
> -	if (image->image_base != _text) {
> +	if (image->image_base != (void *)kernel_base) {
>  		efi_err("FIRMWARE BUG: efi_loaded_image_t::image_base has bogus value\n");
> -		image->image_base = _text;
> +		image->image_base = (void *)kernel_base;
>  	}
>  
> -	if (!IS_ALIGNED((u64)_text, SEGMENT_ALIGN))
> +	if (!IS_ALIGNED(kernel_base, SEGMENT_ALIGN))
>  		efi_err("FIRMWARE BUG: kernel image not aligned on %dk boundary\n",
>  			SEGMENT_ALIGN >> 10);
>  
> -	kernel_size = _edata - _text;
> -	kernel_codesize = __inittext_end - _text;
> -	kernel_memsize = kernel_size + (_end - _edata);
>  	*reserve_size = kernel_memsize;
> -	*image_addr = (unsigned long)_text;
> +	*image_addr = kernel_base;
>  
>  	status = efi_kaslr_relocate_kernel(image_addr, reserve_addr,
>  					   reserve_size, kernel_size,

There is a further consolidation here, the two places that call
efi_kaslr_relocate_kernel() get the args from image_info, so we could
just pass image_info directly and remove the duplicated extraction and
extra parameters.

It could then handle the image_info adjustment too instead of open
coding it twice.

I wonder if riscv should have the segment_align and image_base checks
too? Maybe the whole function is just a call to
efi_kaslr_relocate_kernel() ?

> [ ... 9 lines skipped ... ]
> -asmlinkage void primary_entry(void);
> -
> -unsigned long primary_entry_offset(void)
> -{
> -	/*
> -	 * When built as part of the kernel, the EFI stub cannot branch to the
> -	 * kernel proper via the image header, as the PE/COFF header is
> -	 * strictly not part of the in-memory presentation of the image, only
> -	 * of the file representation. So instead, we need to jump to the
> -	 * actual entrypoint in the .text region of the image.
> -	 */
> -	return (char *)primary_entry - _text;
> -}

I think this hunk belongs to the previous patch which removed the
caller?

Anyhow, the logic looks fine to me

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

-- 
Jason
