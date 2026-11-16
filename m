Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.7
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794855150;
	b=NMtrqT7N6CE5YNx/03eqZQ629GSBauF78/MDIBikc8+SaIzttN4LPPaXn+kfgVJhVAvj
	 /QvHe1SxahcY0/VQjZWh+pQBjXvMPvTKFWgn3LcJ9bSROi0KHeMpl7YnFCrDjDjGFjE+i
	 Um7Aum1MHhHiseyozMv95rny3qqtiaHUgPFmVcswYbas/qq1AzxKksjCU8TQhVmWRdAl0
	 sW40ugV2XdQHU60YKPL4jj3LoeV9HmWkx/N86BdkpVrhUHApxUVumrn23Z4G2DL3R2XNX
	 f9KMF89QZ0RKBOhMZxLrHhZTD5fCk4YHgfb6SxMpmtCo91pSoBCFNjlPkdR4c/fOYEg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794855150;
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
	bh=R+kuTamxvB7eHj+7mCN3ypj8YiZ2ShB9649Ng1bDfH8=;
	b=UcBK89njPeV1KdxeZqoICrs7iaZAT9i+qEA3OK+hLsz0uWXOYcpm6TItodQ4PmvsFO72
	 jwbeZtQnrpQW1MCybcJgucSBP0XJ3glToIcfYPeV89hh8nf6IIy6KZOKqBGjK2hQdI7ea
	 GW/TLJiUuX6felQvW1AKLZ3Brf27V78T3dnDEgjT8cOPCF8KPZJV0agFwFWkOB0JGtKx+
	 QkuVS6S2717iFYoiFzYg0D1/65cKOzzTZjCXRIJF6ornFiSDznhH/2sUSJ1zfA4OXymRP
	 TL80NQilzP+1Ir0ITBZ368+/L/pzkXICYEMIMwbR1FV+JCJBFdUVhfhBlFcV7vrf2kg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="a/a3ZvET";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.7
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013007.outbound.protection.outlook.com [40.107.201.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5995E606A323
	for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 18:52:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5995E606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=a/a3ZvET
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Df/1bnFFRlkIlx+ye1zmZslmxVdDqXJ2klghSasjAkTycKZW80Ig3sglNnLYcmyIhEJo8KPg6LzTqtR1pjt6XthIUuYviLuUSb4uT3IT9MCkq/m6HSKgGuy+tRZmpfey/kGH+gVTN8W69F+6XiobyAr2t2sw0Gy3i4is99Xt8EAlDbzyHnU/rsNh991p7HTloy3BrmgxUheulLEJShp8MXYxywNUHYgo/pihdtkiH9obLIYhbvfnH8O9uzBt+CLfRWI+AqIbZ2WxkfmiC/RA4fcCAOVr0lhIVpvroTNIcgBZchXqxw5DZSeaI8CXLs555l9jbNIrUyxhi/IPdh0p+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R+kuTamxvB7eHj+7mCN3ypj8YiZ2ShB9649Ng1bDfH8=;
 b=uWR/IIC5rPztf1iK7wWk0FmalXkRN6zow6pdFcFB8634x3BrH7cTKPX/Gk1xIGLbjAXWT5o2VueNN0T/VxNFgO7qj6EwyyXkT4DdbEEEs66Vy5fSRGDxJOamY0KAuQ4TOdk9D8Vm6L1Ef/SneVkRC6u9l8HyTzDlTydMaIv1nYoAsYrVDBMy7XXMOCfPAr9H7swj31fU/4wk4cHNytm5JzLkFmrcKKgxqxCZB0B37zOCbk169dQ1G//nArv3vJ2IV5DWxFAZ8Z7vdBHHxMqBxf9ML2tnEEEMNv5KszsDEIHbnIj2VjLV3yaANK8cia0Xo7uzxZDOm1Srit7IBas7jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R+kuTamxvB7eHj+7mCN3ypj8YiZ2ShB9649Ng1bDfH8=;
 b=a/a3ZvETYjCv7ojCWkNE16s6pWN9o1FSwGSUTr2eY0vkBJMI5DqWknNBAhd9eole3Roe7OHPOWD/mBUSFB47uSJKdlLc4IoS8IuBl2k/V+dx2KuxMg+iqU4mERpx1bgY6R0c/9jXvgguZOqQeAPmYbFO2lqQiol9tcdCxTeU0+B4+wi1oY9IZJIo4bwqSsGVFrp82KYgTzl2qGsvFWOQEhcl/cavgWT9nDzUZc9uNZDnZKLFRWy220YhEnei4tJdAYM0qX9Fuk6nXBi6ROi5i0tiN93Yk4N4c4DT0eufFWJJPjokfmMwtzRDM0NPaF1j9c9F0QVEZnALFK1bNJOtIw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by IA1PR12MB9062.namprd12.prod.outlook.com
 (2603:10b6:208:3aa::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 16 Nov
 2026 18:52:24 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.013; Mon, 16 Nov 2026
 18:52:24 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 14/15] efi: Make config table based primary display
 handover ARM-only again
From: Jason Gunthorpe <jgg@nvidia.com>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 Ard Biesheuvel <ardb@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, 
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
In-Reply-To: <20261116142618.1687025-31-ardb+git@google.com>
References: <20261116142618.1687025-17-ardb+git@google.com>
 <20261116142618.1687025-31-ardb+git@google.com>
Date: Mon, 16 Nov 2026 14:52:15 -0400
Message-Id: <179485513574.2274641.6693029247262617833.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: MN0PR04CA0024.namprd04.prod.outlook.com
 (2603:10b6:208:52d::14) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 5e30eef4-4279-4b88-f1e9-08df4412bef8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|22082099003|18002099003|6133799003|11063799006|4143699003|56012099006|261102123227099003|261022115727099003|261022075727099003|261021121427099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	wxFBXYVwabTuz/4zMALSyX0GnqAiKjtAAPSbQVRiXr4Lw4YhqwHEk7QPt7qJk4BcbLzX2JFE8YPJz5VgE+SsQWxlhfDRLZe8+eFykyhtnpEBjlMgyoyM2wWNc6GbFBIDfZwJO3wo9BkFsMl0zVB/+TjAqxZAxNhj3DRt6/6eoPw/nN4UcXEAy7a44XIC7Ezm63bR5g76k0IemmgH7z3nwpI3HAmzDdgb5pcHakjEKXGg/WYvVyb+YpUPisu0fufTqBzWaDz1xRqJ0zZXiygXVzFaePIqKqCLV6Wxw68En5x4zZy60ZkLD8iADRHcX4XNKs2et4wK1J1VlZSmQnqpwhoMDxIavORQ7XWHYn6f1ccEY/lEQABbSjsTXEmjJ9zLoDN5Ioghifbqx/uBIYsd+4xLCTCDp5n4wBqFbGcIhYFnLR2qbZ9Flsx4B40ki+jMmeecwq0NHah7Fs+ldiHQghaBPZhDIjiM/4iuNretUDYv30pERG6vlz4Ack3aXFljHxdkKZ6P7QZm7OYywuJAEOIu6kOHoqxrixLphACAENj/JakfUKTyTqYEeMJlzbE50ZwF4d0WByymf5Ydk83JRYPpyVQAaF/D0IlHR0n5jECa5BjUeKOPC+6AG2hq0HTRzyGPmY9hAg4W6wAqgawE7aNcRlXUbJlFeDohaKXTb3A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(22082099003)(18002099003)(6133799003)(11063799006)(4143699003)(56012099006)(261102123227099003)(261022115727099003)(261022075727099003)(261021121427099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RVQwWllUc2hTOGRhc2FoZXhCOEduZE5McDJMU1ZZODhWV1pybHhySFQzUzBn?=
 =?utf-8?B?Vk9JSWpMak80d0xWcTA1cDJWT2k0N0VFWURsV0NQRWx6Wm9lbFRiK29GYXY4?=
 =?utf-8?B?QWtHK2hQU2g5VG9vdHU4d2xFR29KRTNGM0t3bUQ2OXJ3eXZJTE5vODltTkRV?=
 =?utf-8?B?dDgwWVdxMU5oQ205Y05mcHJubTBQanBzdDdMVzlhV0NZTElnbEZIbkdocHk4?=
 =?utf-8?B?eDBoQ3RjMnRBM3d6dE5pcUN3aDEwWS9uNkFpdGQvRi9UMHhMYUZ0eXFRaHBw?=
 =?utf-8?B?T1UvNkloWTZ3Rlc2ZUEwdmFxcFUvYUJFYkxwRUxTekJxalB5dWsxM1ZOQUpV?=
 =?utf-8?B?MmFFTlorYjdPK0dIMXBSeUFnNmhhcTFzaTRCNGx5eE1VR1lyNDloQzBZTGpM?=
 =?utf-8?B?cFFXYWhPdGpUQWR3cjZTdkFQK25BRmhoLzZpdmRERkZ3L3N3N2x6ZWhKY2ND?=
 =?utf-8?B?b1FFN1hzcVlBWWVhN0o3anBpWkhEbnMza1FhNVdzVXV3QitLakxSdU5TTW5L?=
 =?utf-8?B?djBQd2o0WERFeTIrZEdGN2ljL1hTY28zakhuWG1HNlBZbG5yUXJaVElISkRl?=
 =?utf-8?B?V205S3FyWTl3V0tMOTJqT1o5aDRVR2RaZWNMZUVvVXY5UE9WMWVZNnFNR0Jk?=
 =?utf-8?B?TEZaeXp0YktvVUpZYnZObHQ4U1hQd0YxU3lOeWdrMlFVb2dBRFdmSTd3THF6?=
 =?utf-8?B?WC83R0V2V29PZ3Q1cXQ5NWg0VDZTVDY4NWVzVnpOamFKMHR1TVZyS0V5TE5Z?=
 =?utf-8?B?TmJOL0M3L3lNYUFIUFA0ZWFMb3g1THFqVkpORkYyck8rb2haVUFGM0hPV0dL?=
 =?utf-8?B?UUoxaWthblhramtQSGQybldzbEg4Zm5WZFZUV3B4d0s1VEZ3YmlsczNwZExm?=
 =?utf-8?B?RTJCYjhQOVBaQTJ4ZDhLN2ZuRkxqakdBZkpLYUlqOTJKTEJBc09BRDZYZHJJ?=
 =?utf-8?B?TFpZT2RKRHUvcVM1Rk9sMktzcUtwei9PQmZTYm92WVFnUHVTNEV2TEVXaGRW?=
 =?utf-8?B?T2liK1Z2dWZFTG5FZ0RERlhTZHlFNU9adXNJc3ozNXAwRHFFL0JVa0VnMVhj?=
 =?utf-8?B?amNXWmVTbi91bWtlZXV6cEgxVWpyT3kzSEFETi9DNTN2Qld5WTA1N1hEbnJE?=
 =?utf-8?B?UWVXUDM2S1ZaNTFVcnFzREtCT3NFMlF6WFFHUk9SeEVnV0FBVTJ4cWJTSnVR?=
 =?utf-8?B?Nmc1M0F1UzFEMEZ1T2o4ajJCVjlhZ05TaE0raWdrZU5zQ2YxQ3dLOThJU2cr?=
 =?utf-8?B?YmZYdVNlUEJ4QVRmUm40NXlpeFpxVmN2emgzOFphZVlFdWJkc2g3Z3Zuckcv?=
 =?utf-8?B?TWJOMWViRW9xQnJRR3FPR2d6VmJoSGVEb0VtbndGSDNWNVpiZDNQY0hmeEZ0?=
 =?utf-8?B?b0tySTZmSndEQ0dPRXU4MG9xRENkdG82QldyRmVIcVpUL095cnlYOVg3Y0tw?=
 =?utf-8?B?TnZ0M2ZpSHNGTDZ6b0FEMnFJRnU1OHBEKzFVcWRzblg0YXVDdlMvZHk3b2hu?=
 =?utf-8?B?L3RSOGlYUlJPZlp1TWZtdXpLdjNEYllYWGFOQzlXczdsYnJ2SGlrK2s0UjFm?=
 =?utf-8?B?eW9DbFNQSjc5cDAzT0xuZXl1WVlqcjVNWVNUeEpvS2U1OUp1NEpocHhIVzEv?=
 =?utf-8?B?YWtDVjdWYmVHaE5iZ0pQMGpnSUFxZEl1emZRd0U4R3VncGFDL1haZGlXb2xh?=
 =?utf-8?B?ZlcxVkpEYWpwZWQrTER2R2JQZGtFMncxRUFWUjJlaUZieTlCTzAwTVdjRTNC?=
 =?utf-8?B?SHBqMnVGZnEveWlHa1BVc09idTcxaURIeTRjSEZuamVWLzlGS1Vmdmh0YVhS?=
 =?utf-8?B?UTVxY2FTdjJTR1hVcjNzV0Vhb0tSMkI2YzVzY2RKSXVCNTdzRWZvbmhJMXJR?=
 =?utf-8?B?TlFFU0F5a2N4U3NiYjUweGZxSG1jTDhxKzZOV0ZKN25mK2ZsWWt5aXUrU0Jo?=
 =?utf-8?B?T2lncU9zell3citXTkJaSHRFcUdqTjRqc2xxVzc3UVgwcEJ4c3E0em4xTGsz?=
 =?utf-8?B?Z3pIMzhsdnRYWDF4YnJROFFkVGhReHRNTWlZV0JyVUtjRytKRFl5bFZ4QUg1?=
 =?utf-8?B?Yys1cHZiUnhOeVQ3alZKdWNPUjlFY3d0eUVpODd6WldGYVhQU3N2U2FrRDdF?=
 =?utf-8?B?UmNScTFKRkVtNEp1ejdXUDNEMTRwTTlrNjUzajJwNFdSMzJDL3R1SlhJaVJv?=
 =?utf-8?B?am1NOXh2Vy93RnRuRW1EckJmMlZwclJPMWw2TkF4SCtEM3VyZzNmYjFkUmlH?=
 =?utf-8?B?Nldpb3duUXQySXJ4Q3ZvUCtJRHR3d0lGUll2bXpRU3B1WDdMTENxd3RyRVEx?=
 =?utf-8?Q?x/f5+yqMF66ASNe5Pt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e30eef4-4279-4b88-f1e9-08df4412bef8
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 18:52:21.5082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OpUto+pufPKb4Z/4JJkTlQgfSnHr2o8QmZOGqFhnM22LhSVqW4ugk92/T+0DI76x
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9062

On Mon, 16 Nov 2026 15:26:33 +0100, Ard Biesheuvel <ardb+git@google.com> wrote:
> This reverts the effect of commit 732ea9db9d8a ("efi: libstub: Move
> screen_info handling to common code"), taking into account the changes
> that were made to the code since.
> 
> That commit moved all architectures to the ARM approach of passing the
> primary display information (formerly struct screen_info) from the EFI
> stub to the core kernel via an EFI configuration table, so that the zboot
> decompressor, which is not linked into the core kernel image, could pass
> this information as well.
> 
> [...]

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

-- 
Jason
