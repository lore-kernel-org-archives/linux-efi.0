Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.66
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794582650;
	b=Q7qaezgYmL70FwgXgJEzlwD08ekvOvbJRhKerpiymzH1cH28QAdy86kfWJeuCGMY/jNy
	 XmGnG9eA5tupPz42Cc9QkXoXMmPU0WOgJNaF4+JR8gbiI2w8JzkXiBmW8Sm1IVQgBB9+n
	 Zpf4BUqebJ40YVL3OCwPbAjabGhnHnvwPdrDJdGwsTNESbgQnEybWDtrxb/iInoqdgH0U
	 55Vozg0xxmH2XzNn5aIYKV6lkAGhnFwMB80rX+rsGrtlEotwxwOqEe+jcKvxGjtH9v1AZ
	 5tjKLRYMIDMnmAxoVrIAISn+dSHu6zJIEvMBxGVC8PQj8jzM38KoGPUznTFYM2KeAIA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794582650;
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
	bh=8Dmo56UKPbRhtZRCQ8PtWg/kqZiqGsYqM7L/b9JeJx0=;
	b=R8EE+tDXmHHZKr4dERK8Hlvy+XLOispaD13ufAuwMKtOSevm1XkBqTpUFV6Yy7aukSKR
	 kFqubalvNh0M53PScxiZw60J84+VN5YLUKHQTyYVOoGpzbMD+LkXE6mrJH2BSpnJfNndU
	 +d/u8Nt0W7AbgyHSCuisYKg36kOH03xX+/uJOGRzUxH+d3LcZjeH3rIU506BLlwDnY17j
	 9dVqfl/poI088WbMDAuKrxUzg9anaelvZI2VlCdPy6Rh5Yrsjjit4IPSV2ZDyrXgj5Z8h
	 GVlMi6GsBhakNRl441UW9GDvs+G8gHdynU1a/37xOmqAF5Kp6SHLTMgSjSmg2726p2Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="aYZeb2v/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.66
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011066.outbound.protection.outlook.com [52.101.57.66])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7AD8606A337
	for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 15:10:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A7AD8606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=aYZeb2v/
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DKaNyzrthk84y6mnfAfqXkE7qUmlQ5CD+dYn9mIDl6KX/VSf4TZUVTF6VtyeM6iza/Cnvy6idjhlZQP8VEp/aKZMdqE76vt+e7rOFGzJQzUra9KFIKnqOnUji3owwBMEOUxIn6BxAH9nEKCkTD20k/G/T/h4YYe38YBqovIKl/D4Ygk7WPxGmJiFgt8S+5L+MU85z+leXWBx4a2t9t1GpTCib8yT4wt37VcEefH1Ln4qhbY3VMy0oi8oBRFYmzPpK5n+ZNxsLb4A3FbzjWCfv3id2TNjBkyw5Yfyp26OsNjcQI4SiNANA7HEqQHHHLd40jUhzTCUKD6mudwaEYcBRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Dmo56UKPbRhtZRCQ8PtWg/kqZiqGsYqM7L/b9JeJx0=;
 b=pWpy94/GJEMFn0LaVgHbIyotUYnhkXfsoheBf3VgNZWJrFbw0n30VGig7H1aO+HpxBinlBsOJOj8h4jqIteRfzEE1dC4xWb7z2KLP20M1bC65hIFhd1/RtXb4DKqHPjLNjXhsl6HZ4YhZ1Dh8Xz7X83nQFEQ8IHMXoZCnzUpDQ86GAnvzH/JmXPdM07cRz/XrB54BSg1C3kkjKsizOx/R2AmzQbF+8AwiRCaCHcwnznZ5k4++XCVAR2kK8XJeJZm2IzCInoMaLLbEIei09RfvTbtTLRkctnZY9kKkbD7QJUEVVexfCDNgNoi4oSZWwu5QovjtJo/nkXBTrc+Ys1Tjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Dmo56UKPbRhtZRCQ8PtWg/kqZiqGsYqM7L/b9JeJx0=;
 b=aYZeb2v/sDeHiDo01vAW5SCUcUn5NzJgEifUS4GX/mnHeUUlc0H6JYSbyvyvtD/EHPF+yHkV4Q0Rt/QzFYe63IGXPRKcVsLPTN4+5KCsb9jB56bb1XlghApFnRytDPxGK3kuG2Ij90gy/RswGVRotm4FC1G/4POjhsPgWw7bv6cVD4uwlWA6ElYfDihQNfXkTWorD2yAvaLqfjhTk2DzjqVMj95DXvrhGiWX3xzv6gmLFxYWD/B7nuSKmyi6vY3KVcrkgiKAe5b7sX1+HGOLbtnTj210NYv55xBg9o1srVJ6usKV2NoKfEc4ljriK8wuJCded4XZNJebu2N8wC6EzA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by LV2PR12MB733495.namprd12.prod.outlook.com
 (2603:10b6:408:423::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Fri, 13 Nov
 2026 15:10:41 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.009; Fri, 13 Nov 2026
 15:10:41 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 10/10] efi/libstub: arm64: Drop zboot code_size hack
From: Jason Gunthorpe <jgg@nvidia.com>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 Ard Biesheuvel <ardb@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, 
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
In-Reply-To: <20261110121731.2728824-22-ardb+git@google.com>
References: <20261110121731.2728824-12-ardb+git@google.com>
 <20261110121731.2728824-22-ardb+git@google.com>
Date: Fri, 13 Nov 2026 11:10:21 -0400
Message-Id: <179458262199.3625095.169191783993151958.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: YT4PR01CA0292.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10e::16) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|LV2PR12MB733495:EE_
X-MS-Office365-Filtering-Correlation-Id: 961189c0-7cdd-4bbc-ccf4-08df41984009
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|10067099003|4143699003|11063799006|56012099006|261022115727099003|261022105027099003|261026140227099003|261028144727099003|261021121427099003|261022075727099003|261102123227099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	V1tBVtx0v8KZYxHq9pKd/h3JtIf1WJOqzy7O3SQKR7QQQSChgF0W0DkAcXeVyUvKjm9i5s9MccLxW46eFq8Ma2ZpCY1BYNf99XeQfYbQ2+eTMtXd1zCQux6rz7atcJA/HsoIdHzSWdMfu2V6iMDQloFOFyO8gby8UNVRkmwys9bRyLZjeghRP9hCSodpF66Gl9ZdUjNpoNksjz5NKrqne5FFdt/RMzl5jgSZsyliYUITaqkSnzzOMChs5nWz+faIEaNXTseE1fKils2xSWi8AeBu5dRDo1gshzNr4KkwoOSQrtncI7RLopBAc3R3FMjhsD0VBSPcmSosXRcbp93Ilcrc4jnOVRowkQVUqjYvCg4pVXBUtZG4nqj227GDX6ctQPY+gBDhJaTYz6ctzD4KVFVJY3a+vly+r3LcYpbmVef4c0RjGMHWvFBQKgY29bly2piQrufeHTF9Qm8bcP2JkOmvPoV7QcRi4nMvhYNcPi1mkcuXlQ/Fsy/tOPdLWr9sfX3/3+MsZebxBR58H0Oih03MOdCI1mfxn+3QyFICPVSixCidERg9pjpZcJrIBW28t9KiKszaxBTuxIKdvXipszdhO61VTMvQdQ3JGGOGJfIVCSANimu97xplhaZjspiMfncZLgTSaFlVWDT2ZWBDSklMmOKseFaNHguFIkgRP8I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(10067099003)(4143699003)(11063799006)(56012099006)(261022115727099003)(261022105027099003)(261026140227099003)(261028144727099003)(261021121427099003)(261022075727099003)(261102123227099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dHdaMkxCTzhMZ0hzRm80UkNxUXdoaHF5SDZUcVAzejZQNEhUMXVTOUNsOFJ0?=
 =?utf-8?B?T0lOcWZYTnVWQ1NrMEhIQ25DUDFnTTZtbmNOeVZlaGViZEhRVDlJeC9rNFlM?=
 =?utf-8?B?S05oOS9NUWVjdkd2UVQzUTBJSVNJWXBUdWlRcWIwSmg5Y3g1KysxRkJUc0xl?=
 =?utf-8?B?b3ZkNnltbjVpVWJ2d3RiTWkrbUQ0Rk5MZ3dycnY4SkhZR25hUUI0MHZGWXoy?=
 =?utf-8?B?cmVZNTBoSkpvZFlwL1JVSXM5cDRtTGJtWUVnSXlxRFFxV3lkYjJFZERvTWNS?=
 =?utf-8?B?WG90UFdwTll0bkF2VTA0MHZlNUZKUmo1anZCcFZMRVExbkYxNStHZk9LbUdL?=
 =?utf-8?B?bmF1NGhtdDlWRHhkWEptaGRrdFVVWDZ4UzA2ajB2Q213QU82L2VCeEVFb3JD?=
 =?utf-8?B?Y2tCQTlqckhCc3pVWmFWbklXQ0NMcVNiUXNyTnd0RjhqLzd5aXdIS2pXMFor?=
 =?utf-8?B?YTBWS3V2ejlQb3k2dUc2SGJvSEpiTWZFREl6NEV1V1JsS1BRZ3g5dTNWMU1r?=
 =?utf-8?B?UjU1SEJoV1F3czF0d3F5bC9OTlNnZHlGcS9qQkUycTE5L0FTQjd2OS85K0o3?=
 =?utf-8?B?QVR5TmVDZWhNUzI2VDdvYU1CUjdKOHdPWTBCc1hVWk50dkVXN3RGbHAzNENG?=
 =?utf-8?B?SVdrN3p1Sk12K2ttNXJ4bHRlQmhPL2d1Wnp2b2pYMHh6enVvOVNKekZMWnAr?=
 =?utf-8?B?ckpkejBYMWt1KzlCRVdId3NzTU9sdGJrTHV0RVA0aFdKTkNuWDcxRjdtd2Vl?=
 =?utf-8?B?ZXJ3SGRDa25vNTQ5SmZtZjRiSFpaNWVNSFlCNGVsV1Q1MWhGOWNURC9XR1pX?=
 =?utf-8?B?L2s3bDl2YXRmTnpVaFcwWkp1WEhVZHZyZDM0VFdaU20zK3lCRnJ6TTQ4UGFC?=
 =?utf-8?B?Q1dDakZuZ3dtbyt3U0lEeHFNK29RaytmVnRWeTY0SnhCTno1VERpUlk5enZx?=
 =?utf-8?B?M2g5NGdGZmx0OGdtS2VZbXR3YVR0eC9EOFp2TUgwdXJFcHNEQU5Gd1duQ2RK?=
 =?utf-8?B?UTNqTmFCaFIyWjlQUWh1czFZRHZ5bTM0Sm8yYWJzQk9Dd3NBWW9tMHdNNlNm?=
 =?utf-8?B?eTcybXZzaGhsY1RrV0ZRVzJjd3d4S29ja3RTcnpMcjQ4Ykw5L1c0ZXM4azFp?=
 =?utf-8?B?VHlhYzI3WWR3bm1qUEJxWmVGeGdrMHFpZ1Vva041eVM1TDk4empCSThiOU85?=
 =?utf-8?B?bnZTQ2dibkRJR2RMcXJZNEdXVk1WNk9EQnM5TW1yRE0xL1lBcXZVRlZVR0JR?=
 =?utf-8?B?NmRKN0hDc3FSR0x2NGl4cVNQMzhqVVg4djRETGRJYWhBK0tRTzByVmgrK1I3?=
 =?utf-8?B?VVdJWUljZDQvS3lNY0FqamhTYzI1ekE4ajd2am1zUEp2ME9UMFdlSXZTblkw?=
 =?utf-8?B?ZUJ4OC90SGpEdVd6Zm5EN3lUQ3hteU9haXJnbnFmL0EwQkNnbDljc1I3eS9N?=
 =?utf-8?B?Y1hSdGpHZU1PNlpIaGxuTE1PSEdlQUlhUFBTUitCNEh6K1dzZWFScWZwSUZz?=
 =?utf-8?B?RXNYQ2ljUkJpNjF0V0grRVBQSEVvbmg0aGdZSkZXc3l5Q0RDeFhZako3dUww?=
 =?utf-8?B?dlVEVVFIVGJTZW4rNDNmMTg4ai96SG0zbXlQY0MreGl5Mm8rYmNtRm01RmJL?=
 =?utf-8?B?V3lnNkltd29TaTR5UlVtMGI3Z0tSWEJGQjlTR0lpOCtJS21ydVR6WjRiL1VX?=
 =?utf-8?B?R2pTT0pldldCVmZ6WmorS1ZnV0h2aEt1a2hEZWFhYUVTNEdVK0ZjeDZKZmc2?=
 =?utf-8?B?YzNmUlRhNjgyMlZWK0lWWkNSNUZseUVCRElxMnluK3d6S21UQTUyeEdTVUZ0?=
 =?utf-8?B?ZGpzdm5QREdwZUlxQUgrOXlHdks1Zld3Q2s1Y29oUVBVQUtyemh5dUdMVXRa?=
 =?utf-8?B?cytFMUc3cXBUWVg1VnhHcmxWMlltUHNlTy9zR1FWbnBrTlM2MGFRNy9nOHZx?=
 =?utf-8?B?Ykl6Z2l4L0hpK2JGSU1zcUN1SzNvOFJMMStmNmxDaFNZYnVJYWtNVjhNVWZG?=
 =?utf-8?B?S1FsQk1DdXJqS2tHNmlLMFU2LzJ1NkdJUWpMeVdwb2gwOHFvRk9IVDNmdW9T?=
 =?utf-8?B?VU1OeXRDdDBVaDBFVU5jS25NSkJTaFc4TDZWeXBqMXh1VU1aY2o3dVo2Rno1?=
 =?utf-8?B?MjIwTkVOTnhQbVgweDhQZWUvMERKOGtySHlhOVhmUkZ6S056TGdnemZTa3VN?=
 =?utf-8?B?ai83WWplSmZMaHBGUUV6SWdJclJrK2NDaVYyQjhPWVRpK204TlFyZ2tTaEdh?=
 =?utf-8?B?Zk1wSlZvRU9aSTA4ZXJkRjI0MWNvTnNiODBGdlNGZ0VnTERNcTl5WTZrcmdy?=
 =?utf-8?Q?iIqRvoSQHtWPW0uHI9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 961189c0-7cdd-4bbc-ccf4-08df41984009
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 15:10:27.6106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rEq+ljbzwaSZi4H6qsNKQ/3aA568eGNoWKG9RpqGVYELl2bLACdVKPLqXQQ53sPl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB733495

On Tue, 10 Nov 2026 13:17:42 +0100, Ard Biesheuvel <ardb+git@google.com> wrote:
> Now that the code size can be obtained via the generic image_info
> struct, there is no longer a need to inject it explicitly during the
> build.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

-- 
Jason
