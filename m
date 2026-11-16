Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.7
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794855151;
	b=5Nd8YGnzXmPkTmW/1Kz7D4k/0j8Hd5N+xbBm5QZSAeSTPO0hnpBvQWXj4pWsXV/+jryD
	 ciPXwMj1fBEZ72Slb2KLqA/9sfuGX/fRDklceJ1BrIJjuASB9KYECc+TxpPjwMi9r10js
	 LL47rCjYm0fwtYsXbDF5dySGfBgqVOAyQ8OeFLIFVrhqTuq4QntONmx5E08+vdYJ0XHqG
	 1/5fwnUipTVCdJ2j4RJC4eFcVXeAna7aG5kN+a1bK8jwM6fVn+JqNEJt5Qchg8Wc7pvpV
	 h4lXOZ08ooJtyJx26dXPUYHRgqOi/QjDiOPIupkhekr7EpMobuccwQ+Ela7r6PiIYlg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794855151;
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
	bh=6yecPDtufTq4Mu2eP3dRypUzgJIVKs0db6NkdIPF9l8=;
	b=LGWiyb2WDiW54M3Y6Eh8hAsq8p2qN7wFuh0IVusCDowm9G4BFt8iwNu07O0VwbtZ5L0g
	 a3VGFu6375gtYR5/qHfD3769DxatFmE6MYE0MoCVhWLXBwUiR4az5Rdbif5S4tJnTZpNz
	 8EeTgB1Q+11zmdsFhlltrVkcTmqZOtP9UZlTjPLW3mZwUy9Ub5QSrkZnf07INVzCowGxe
	 xROFpZOLnEXSMH4W/SumJwywYdRbFu8/jJuatiztT4rnjVIKOVWmenM5Iqgyev/0z3vIh
	 Va5INOitfYEHLEFWKgW0YTommjxRaP3hx/xP5sldadn+SfaPD5uFLDUxVVORDFCNAqQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=FBVFZfRR;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.7
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013007.outbound.protection.outlook.com [40.107.201.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A01A606A335
	for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 18:52:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1A01A606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=FBVFZfRR
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RjogHxDV0ZGnP2pFa9EIt2U8b1AUTmimc1NoomE94Q90JL5LfD3Qg2gV91D75a3QoDHi5Sgv8XepEjLeVWkQh1JaOKJgzlqy+OHJvS+eVQPwHGqjdOy+RR3yb5YYQNT2JMrN2n/mOBRxfvYA1NwKKD/EApVMW1ChpzsdiJLLDXU+KWh47kprPJ0oswbaddzHFQIYguZLvoIe5uyohYxkLjKBNP15j0yGLahEfPdU7ZhNI6lFOfEDrft4s3+3KkmvVMfW0nniP8dY0IQb9tq8Ok+V2dhuU0podl8TlOLzqhyVDFw8Hd21ecvTT+Nf1eiPvhu+fES7nZr6zWT21qaZEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6yecPDtufTq4Mu2eP3dRypUzgJIVKs0db6NkdIPF9l8=;
 b=s2ktuwRQ69rBweXfAtlDvwPzFEhc+DsVvpC4d2eF2KpyZ8QM+ah3fcROOp8oqAPtNTP57+9X8+Q0t9T1I2oQ/Meg2wnfaxIj59fev6UadOMcMvQjIYjjJkNyHuhHQzpWsztXlDYNzTNX1dhxiRHFSQwcy/5LiGGIj1Ox8MXs2dkmNy9b6G/Wp2IxeoQYmD4/CvSgtPqEDOBmx4ma235IVtN62CpqadvafUD4txW8CweCb+NcGOAiSUgG4iDm/3TTPn9iic3rDgbUdt5uqYFq42xP+JpCVCwffsxaUv+AwZjoNGnz5vZlAH6/zBq1GKBi16o99e3RZ78lwW17dbMXMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6yecPDtufTq4Mu2eP3dRypUzgJIVKs0db6NkdIPF9l8=;
 b=FBVFZfRRFvooxONIpDl18IFlbJgUUE7I726PAOY2htBnjaHQ6eWbIUcDahwikFvn4D+RZEx/laOuzsUp1zrGoTf8Eqs2E/XxVQui9N2QuBXAGzqIeYRTUib9HhfeQOfsu7ReWkPWIbHPVpG6ltoOyF2+yfQnMiKuUrltGc1uZayDxzLQ3RyR32kiWqOIweeYvusfQRjIFWD8m+AKUViAV4AaUxZalXWFkfjK2tHS3GaiG4OWrn5Ld5p5CmwfGvF9nPrAwYsSKwop0r0RulGgbmSpHtkXrVsYwxwPQP+nBa3AQ/chXroO/dDtwgzRNxuyXdNkqaYZOncEGXi/fJFPHw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by IA1PR12MB9062.namprd12.prod.outlook.com
 (2603:10b6:208:3aa::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 16 Nov
 2026 18:52:25 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.013; Mon, 16 Nov 2026
 18:52:25 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 10/15] efi/libstub: riscv: Use struct efi_image_info
 to access image properties
From: Jason Gunthorpe <jgg@nvidia.com>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 Ard Biesheuvel <ardb@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, 
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
In-Reply-To: <20261116142618.1687025-27-ardb+git@google.com>
References: <20261116142618.1687025-17-ardb+git@google.com>
 <20261116142618.1687025-27-ardb+git@google.com>
Date: Mon, 16 Nov 2026 14:52:15 -0400
Message-Id: <179485513574.2274641.11188144066364939755.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: BN9PR03CA0597.namprd03.prod.outlook.com
 (2603:10b6:408:10d::32) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 2005bcc8-a669-4b24-6b07-08df4412bf04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|22082099003|18002099003|11063799006|4143699003|56012099006|261102123227099003|261022115727099003|261022075727099003|261021121427099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	/RspeYJ6BZnXoRsAs+A/jEsXtJ1zBwi+bu/seoatzIK1XaEwy+VdUQ2C+tRxudwzpQhxPXq9zybENOBeitozcveAOqI1/bkC0vcFtIdsS19cJ81uabfjJ1TRhKsblABnKTot+H1rWsXJzscald9M45MtmLt2eE/VoUzZqs98Q5JhpaBHLZcEAReQpnO0NeE8wXpBM7hFZM99l6SrNztoQe5zfD4U/Fo8ZF9G5p3HFZR1qo4Y8xBJCrN90x4zJwog9MIWl9kYY+PXw9Qaz4dQlsMy+Ta0VJv1ZSORXZgcScyVsDQHm8lqW6+X3XJdYMTYpXQuEHvEfwbQ2bnbSxS6XjZ+cvlNqCsYpVUUOcvsf0zgeNY8/NpY+CHeQuOFY4BRQB5ZheAYn/YcU7SqYt/NrvO6mIjDqKoojRcMRoI2sTAMIJn+mVGRLKkX3YACY1UAGUfAEB/8b+g8QJJ6Gbrywn/ygR2XpDA/811xkmJhGAoNa2YcmUEBET6dnGikLLhGSlY0qi3d2zYEt3VSiyEFVpHLt881rJsd4I4OsrltxXw8UitX1eJ1+U6J1smdn+ylWpjrCGDYlk20BWQ+rmvIW2dA8137Vv/zVyN49i40p6qxc70BiLGmjN34Y3wCs7Q/TIcKRM9OMhiY3pGeiUtgvcfD7d0FCImOmRPfUfaNIt8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(22082099003)(18002099003)(11063799006)(4143699003)(56012099006)(261102123227099003)(261022115727099003)(261022075727099003)(261021121427099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S1cvTzFUTEJ0NFhqYUNOZTJZSkZlL1pSUXkwZHhXOS9IbW16V09GMU1zUlpD?=
 =?utf-8?B?SmlvZFhtb0xUT05MNUQ0R25ZdEFNeGhZRU5MMXNQSEZmK1o2eXE2aCtvTm1K?=
 =?utf-8?B?bGQrc3dYYk12OWc0VG51VTJXNDRRcWtPVTUwQzNjaVprOTFRcVU0bE1Sakc3?=
 =?utf-8?B?Q0Q0a3pRNG16MDMweGhlNnBDRWgyRHlBSlBCZ0Jlbmg2VHpEMFRnVk5qZ3ht?=
 =?utf-8?B?dVA1OXpHTGQ3ZUh4Zk1ySXN4T1orNWRaaGVoeHRRakxkcHNseWVUMy9sNXF1?=
 =?utf-8?B?aVBrcmcvS3dJQnRzWGJPTjBwRkEyOXRrN0pKMjUwTGVidDl5YWN5d1A2NVJ1?=
 =?utf-8?B?YVhUaVhKWGZaRGtnRWdoUGxvYk1raTFEQW12Z2d1Y1d5Z295ejVWUDAwMGxY?=
 =?utf-8?B?MTNQZFUxWHdLRnpkQTJ0cSswS29pVHBRL1o4Mkxzcm1WUVl5NU15YXJMMDFh?=
 =?utf-8?B?YTRyRTBmdXR3LzRYdEdjOVNkck5mbFR2Q2grSDBuQi80L09pZ1ZZSkM2ZUsz?=
 =?utf-8?B?SXhiUk0yVzhXZllPTUo2aHIvVWZhVnpUVWNNdXgxOG9maWRBNXBYdkRQNjY4?=
 =?utf-8?B?ZEQ4Nlh4TGdQUS9zTGJGWGYrbENYRVVDTkVsSWJETzdoVW1heFRqeVRSYTFv?=
 =?utf-8?B?aU5rdzRnVjRpS1BzWDRCZ3E5Z0RXb1dJV3pRKy9oYm5Pbm0vbWtKbUUyaml1?=
 =?utf-8?B?cjlxQU5KeHJETlBIcG95UkJzWEpJcHZDRHhTMFF1VUlBbWZHdEFrUm04TVJm?=
 =?utf-8?B?ZE05N0MxQmt3ZFl1UTE1c3FEOTlrd1ErZkxGK3ptaFpiY0UrWXg4b2hma0tM?=
 =?utf-8?B?NjVheHlNUTNGTEpoTUxCVytOc2tzOFVjUlVwaEUxeGhNUFNmVjc1ZmhWMm5u?=
 =?utf-8?B?WFhVRmx6Nkl4UnF2RVhiZ2dpdVFkZzVBR3JFT2NWM1lFMHpUOTUrSHgwMXN2?=
 =?utf-8?B?YTgwNDFnYWtHQXFnbUpkZzA2QUtzTk5TQjhvd1dvc1pNbGNsOHZlL2R6ODZ2?=
 =?utf-8?B?bWpvRklQMTFIeU9YM0FxZ0YzQWY4a21HSVBsTVFSRjRkUm5jcnJ2TThqaWZq?=
 =?utf-8?B?b1B1WDBFSE5laTJlOGltRXVEWGIxczdnNUN4OTczVEhNNlE0dERMVDJVTjRw?=
 =?utf-8?B?TTZIVXA1eG9UNDY2SXJzenM3T2VNVEYwYlFzOVBaVDVwZ3pYdWVYWlY1a0VK?=
 =?utf-8?B?aVVVM3VKM0hoWVE3ZzlLVHhWR2FOb0hiQlpIT0JreFNrZ1NXVW5tUG9ZbnBW?=
 =?utf-8?B?Q3dENm92NlNQYzRlUFhkZ2dxaG1UYlpVdFZNMi9MbURHcHNQSGkvQStVNCt1?=
 =?utf-8?B?Q0dsVkR5VVhQZTFqWTl2UDZnY0t4YkdMdmg1d1NyN2tqSUZBbU1WVVI5dU5D?=
 =?utf-8?B?NjE5RnZER0dHYSs2d2RtMmVFZlRURU1DUjljdUJxSndiMmFoUW5KdUtrQSs1?=
 =?utf-8?B?NlBuQXN2VEIzOXduR3p5bDRaaXFCSFpZTjdidFErenhsSGUxSkJqZUY4Tjhh?=
 =?utf-8?B?N3FSUHhsMmV0dmIrT2lLOFdmRmRURGVyR1JoenlHMkNHaE5iNG5WU1A1RmhZ?=
 =?utf-8?B?TFgzV2xkRnYzSHRVcW9SQ0xqZG5WcTEwSHVZK2t3ZEZ6SG8vcmpRdjl4ZnRl?=
 =?utf-8?B?aDNqd2x2VUJqd0hBMmNrWWN3T21oK0NSZHlYalZSMjBPWHRvZnlJaU80VDdP?=
 =?utf-8?B?NUozT2h6Q2VmZEdtRjkzcjJYb1pZY3BPOGE1QlBWNVk1d0I3Wkh4VTVVdXdx?=
 =?utf-8?B?emdGN3E1UTJCL3h6VElRQVJVU1UrMzVVMHdZMExzYVVoVUpYNGlkMWNEMEpr?=
 =?utf-8?B?aTdZVFdLYTAySE5pR3ZRaWRheDBRZWJIUkFweTVzclRFUmgwcHo2V0tUQWhq?=
 =?utf-8?B?SjRDYWx2dE9DUnlJY3luUWRVVVgxR21yUklCclorVkRnUlRxNmFud1MwVWxk?=
 =?utf-8?B?eXg1TGVSOWNrUnk0SEFoUUhYUDE3QnNqZzQ2bUxsOEc4ekFpblM5YmlIZVJX?=
 =?utf-8?B?Z0VMYnNzM0d6aWNvUHlBZWJQWGNTN1ZvMVcxL2hqd1VCUUdqUlRMMUh5WjZt?=
 =?utf-8?B?SHpvUVRoaThFeitBWWRaRlN0alZFUnJFN3prRWErM0dvOW5kaWtDZ3RHdGlm?=
 =?utf-8?B?V2JjVVMxUXZHNEw1N3Jmd0dzaGhYQm9aZ0puZkhoUm9HTUtFLzljckhlOGRj?=
 =?utf-8?B?K1E3SEJiNzl0OExkakprdmdYdFNFaitGZmYyY2prdW8vQVMrWDRwVnkrU2R3?=
 =?utf-8?B?RnUyb3lnZ3MvbkVCUHBVQW1DelpsbDhWWkxjcW15a01naTF0UEtlakJyaXl1?=
 =?utf-8?Q?fX3kLPrCNXdyvPky21?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2005bcc8-a669-4b24-6b07-08df4412bf04
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 18:52:21.6216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gnqa/Q4h6lQCnKkYl6o5yBef+IbrVlPUT2q3PlHRPHcxV1X2O3ZU8hfPPNSHQmQX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9062

On Mon, 16 Nov 2026 15:26:29 +0100, Ard Biesheuvel <ardb+git@google.com> wrote:
> Instead of exposing individual symbols to the EFI stub explicitly via
> the linker script, use the generic struct efi_image_info, which accesses
> the original symbols via PC-relative references from the stub itself.
> 
> This improves code reuse across architectures, and makes it easier to
> add new references in a generic manner.
> 
> [...]

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

-- 
Jason
