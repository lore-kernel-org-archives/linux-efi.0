Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.30
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794855210;
	b=o8bkcsb2oJhl2ivFcPJ+OCBJb5Yp3cc7tQw1yrv1Jqli3i3dkmpQqSIeb/rMSEIdkCoR
	 iLoQnd48njomDmXYw0yHzFGjQQ3R7Lvw8pArCGuaLMx7JZcCt6/Wnn+P+Q8eSqMYamox/
	 gNNToeGnpmlBKIrMM81Hd4Ai9Na1kRt1T0d0hSzgX7rmS7UGMrYOxa90STRM6GQxd0FS6
	 VxLMr4KebukCjDk2wj3mxIRCWVwNEbEoK6/wwbLMuFj83ehKNnhnX7/nMcspwUVjcWRMs
	 U8lwHkYansTWHTmFxnXOvCk74IOHTIGxQIXuubKRZ3R1a/vIMAJClsaPvut2xVgDtvQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794855210;
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
	bh=W03D3hPmg6zHG8flEZQxMr7hJPzuO7qbkwH3K52Tg5U=;
	b=1SkwgMfKpkbvwqGyI7bBOftlinY4sApGAlGsP0sB5XaX5qj+aBJOoE+NrxbMnmrP+ld1
	 JZbtPtGDXSiJKRnKaZOULwK1zXQrEGteHcPreKIwDhDxCGW8OLIHl373Dt6A2ZDgaEiCO
	 IZ/brlbSAH9GEVQUhoHzn0lF1r0Yws6KFUgJgydCJOpwJr7csiW+TB6OTxaTHf2giEO7+
	 bRGfhjzh1uJgGy++5sJX6DVEjY+Mt8kE7Ma+SC1ImRYCPZ73nCMXoN461Jc2xEdRqoOBt
	 vksM9t25syBjQ4P2MeLreH69yq27BFxECFDHGVTaDEtp1PpJg1Eco7guW9Q0viQ6F/g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=tnazY7Ag;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.30
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011030.outbound.protection.outlook.com [40.93.194.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64FAA606A331
	for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 18:53:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64FAA606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=tnazY7Ag
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XFQIGtEpyOf4lO6FH9iApyLWxRGXegtAznUkIXYK25iOa/Le7FgzG6pv+meDltoEvI/5rAj9/xr6GeRQyQTdhZh2yXuti9tsa3tOiXsAKWeKZAb66uyldcd2/GsY6RFw9/Si1Vwgk1v9Wgf4H6v5oF0+U9aqPrQfcdQgU0mgg2vsWYF/v+2r43H81+eEKRz3sYU3cP1otJFa4Slfc5t3jdcKkRG76H5yi0G3EvC/sqhs+i4mJBbhLvskwfLNpBko+pzkzqAhFVulwmb6x9ek4dA11SdSfBo2HslWKJFxGmFPUJ6+XsYDwOT5wuFxCLgHDMtmroK24X66WH2Hss1sng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W03D3hPmg6zHG8flEZQxMr7hJPzuO7qbkwH3K52Tg5U=;
 b=ZJp0NXTlHtPGTLhS01jjLy5LpE9kVE5mttnix2vsDuKNm6gpJgI0fb2XVWFgty+me+i3kLz75GA0grR5p0zAvjbmBrUQeU3ye8Xxldwg6uS33wjGLG5gQ5HRPE9su6n/HY6kAxOGXvSqAI5Khf67QOis3UJhE0cl06id4pdTzYJBiaJzZ0SKEJJxjkxrjjrkFgfg1vQtfHOZ7pU6lF/c/mpHK5uhSq/iTeHYz3e8FpwheQ7bpSl7NqIrKbB2dgIK0uhBFh6Ce2TDo25CL0MBrVggxfsjKwtK35jHlGMaCx2TAajrXGrqIqUrboNTSYwhDxftqLwIn8W8xR7Yo47oVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W03D3hPmg6zHG8flEZQxMr7hJPzuO7qbkwH3K52Tg5U=;
 b=tnazY7AgqvQJXfpo/7mfpuldeeQRAE571vvYIdnqy1LBlovM9pSjqOCHiLcl9VJcJAMAo3yd/woh285zyVWJ7wUGdBVUBCVujZl1+G93GAeZMInx7M0gxGb9MOaksITvC/inz8vAIJExVEMRLIPCVEztE3uuZqPMYolBHNgOtWbZf1faAVV3pCTsWSKexvbI3yRORRzH5HmZldfSqt0S6JoIJTaURKXIbsT1950ZMbH052IjGpzI+XiUAT7WemxzAgJ9eiUx5brmGXctqLwWIFA2DtQ7RpepwvjGD3pPx+H4feW3JLqLIUwzq+vttkD8o/X7sQtYuo+JrRp/YsFurQ==
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
Subject: Re: [PATCH v3 09/15] efi/libstub: loongarch: Use struct
 efi_image_info to access image properties
From: Jason Gunthorpe <jgg@nvidia.com>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 Ard Biesheuvel <ardb@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, 
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
In-Reply-To: <20261116142618.1687025-26-ardb+git@google.com>
References: <20261116142618.1687025-17-ardb+git@google.com>
 <20261116142618.1687025-26-ardb+git@google.com>
Date: Mon, 16 Nov 2026 14:52:15 -0400
Message-Id: <179485513573.2274641.1768058073712535792.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: BLAPR05CA0047.namprd05.prod.outlook.com
 (2603:10b6:208:335::28) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: feb37622-e220-4c4a-0a37-08df4412be46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|10067099003|11063799006|4143699003|56012099006|261022075727099003|261021121427099003|261022115727099003|261102123227099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	SkALbsjykkLIEQftx+jKN34VT5ppu3mPPN4Zytj46i9VXA5eWyXDIGRxwL5rCmXLBZZs1xj0WLGWV52mJQM0m4UY6SfH14/3LZ7PRvVVq/Md8cbmqTLgYGlsoB34ScoKrHA5LTGnDiJRcOzdPd1XuqPWAZfgO9NmJvv8Ubhurj2RE0Jjra77vHHxr1lkd5DnbjC5GifurmJCKOdQH0t/aYabklMaE8Uic1ygLEgU8NYpisyOXkMbr/ggEhzJOQps6ssNEBNqTuh4WBd45QuXWkV8kC775L09znhyefugYPvlR3d7+ShiTy4tf86WbwQ8v8WE5ct9U8TPPl3M7Nomou0gfF1o/8B8kQE3T6OjaSnFZfpuYfXkZyCDUZgybABOyR5Pi2qiAAZiRN9smvvxnHz1RPblT65PNCMBP9GFgdz3teRWj5X6uisFv5ww8lH9KyrYl/Xb4RNJ2KAIckJ26Y0ApgQ2ZEBWonqaHyeSQLVbOfQKpGYaz8lEu308k3/syDb4uSq1NivOfa05qFdVAGMtfJY5bFBVbEf2u4eRr94tcQ/4xh5VHrDizGE5p2gmr8THAn2cJGox9Aegun3AsGy9wJMUTlNnaKOVvUon6ZPIvUzmhV+A2/IsJKpuCkpVtgrhfG+SVVfXgCzRa5Xz2WsGqhuFN93SuOaoc1bEGiY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(10067099003)(11063799006)(4143699003)(56012099006)(261022075727099003)(261021121427099003)(261022115727099003)(261102123227099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V0JaUndjV2FYV05NWk1udkpVdHNkV05wNVVBS3p3R3ppT2s2d2IrSUlOR20z?=
 =?utf-8?B?b1VvWnNneVR3OTJnT252MmhXVy9McVlSaDR6bTFXYW84NWRHcHV0a2FIZkY5?=
 =?utf-8?B?S1JhMU9mZExlYTFKVDFxSitVMktQekZXWkN1VW5qTVYrb3JBK3V5VTNqYmF3?=
 =?utf-8?B?UnZhR1N3NW9uUlBLcmtRclh3ckMzOW5FckVZMTFMVG5BQkxvVVNyZlRYRE5n?=
 =?utf-8?B?RUR6WnlTQVFnNVJobVFYbk1xTEdJVkFkOFFxcGQzRmtlSnd5OXJRMlhrZlJT?=
 =?utf-8?B?SVFSa0hWSmQxa3ZSeC9pbTQya2tRbXBKQ3pjRlFaQ1F3akEvOWo2NzRiWlVq?=
 =?utf-8?B?S3RKbDY0Z05kUjFUdHg2SFhxZU5xa1k3UmNpRjZBaUR5Q3V6eitOVVd6Rjlm?=
 =?utf-8?B?Z2kvc1JFN05ZUzJmcERZdFZkMnMxVHV0MnVjNjRqSTVNQzVUa04rZzYvcFkx?=
 =?utf-8?B?S3dnZy82ckdTM0JWbS9LbllGVXlQdG1JTEliZktCczcwZEFJUGdpOUNDSnQz?=
 =?utf-8?B?RGVmTmltS2p2cXJuSWlxVDVUQ1l4K0k2dWN4bC9McVJiZWxOSzNKUXZoenpt?=
 =?utf-8?B?UEdJK1djYjVvQk5sL2p5WVk2ZmVxbDRycG1VY0RYWmg4NHBEZkxNL0pXNjEz?=
 =?utf-8?B?TjZxSE9LTk8yR3JibExYcUIyL3hNNXU1Y1g4bzgxNVJpMlh3VVp4Q0wxS3ZR?=
 =?utf-8?B?Q2JrcjV0VjBjWFl6TEV2d3VMdzRtVU1aaElUTFNpMjc2UTNEci9KSkRsaEVZ?=
 =?utf-8?B?blNxUXdXNzJFVnBsREJTbkVpMUwrc2Y0WVVEd0xzTGkvV015R1JpUDNQZC9p?=
 =?utf-8?B?TUN3UFB0aDZ3YzZaQXNLdmQxUWJxMGJXRkxiNHRIaERGSVBacUVjUnoveXNj?=
 =?utf-8?B?Q3hiamxraFhwUG9uNWJ6ZGJQK0xYamZaMGxZMXpMYjU4R3RTd29DMWdseWVO?=
 =?utf-8?B?Q3FQMzdkM1lBK0QrT3BFRGw5bWQ5VUlXNStDb2pqZzdqUHlaTnV2dkgzWTN6?=
 =?utf-8?B?WGExV2RzclJ3M0dNVUlOR09ENStPZnFjQzNDbGVOWDA5bDRuVm4ya1ZYVkNt?=
 =?utf-8?B?UWNUOFZWYzJMRDF5RzljMzdTUStncmxRZGJPU3lKcnR1elp3dXJQOW9EUkhJ?=
 =?utf-8?B?blUzQ1Z4RUtlVS96TGNLWGZreU1mUnRoU3RRaWV0ZHNrV0VNYkd0dEhZYVV3?=
 =?utf-8?B?SGVFcU8wWGZRNll1TEg0Nmh2bERyOFBPdjZHS05YNi83eWExbGJiZmVEMXFr?=
 =?utf-8?B?RytIUDE2ZFlDd0tHcEp0eTZZK25WU1lUZnptdUtUK01pWGFVdnppU01SSjR6?=
 =?utf-8?B?UjVhTFE0ci9uOVZsMEdsejN2bnJLaVZYT2F0eERTVGlnTElPNmhua0lBUFdX?=
 =?utf-8?B?bWlPQ0lMb3NtczVQdDBNYWRVSHd2Z3ZZTDQxRWZHZnl2K1dXMHNWNHc3T0t1?=
 =?utf-8?B?dTVwRC9FcVZsSENQVzlKOVBhWU03cEs4SUhYZU9qOTl4bjV6WWI5LzNBZy9u?=
 =?utf-8?B?RTJIM3hQZDZiQ29qTGxsWDZMZ0JFZW90ZmFiUVlKRUJBanArMzFmU0kxMEVo?=
 =?utf-8?B?UEdsam5GNXo0cEVGSXUzZFVqaGplWTJpaEV0WmNnN2hFK3lNdFJ0dUhuaVZm?=
 =?utf-8?B?bVNpNTl6YjJpbFBTU05Gd0puNUZUQ1hxd2dKQjNxeEJza1pTcDBDczNWK0V6?=
 =?utf-8?B?QWdmK2lLY3pqL2kzdEUzZ0ZTOXRuaTR6dE9weDVSVXlHOFpwTjVTOFpmcGlJ?=
 =?utf-8?B?R1NJS1l5bFdUa1ZNWWFML0FIdkpsNDlZejVuZmxPZytiTzIwRDNLOVQzRWIx?=
 =?utf-8?B?L0ljTzdDTk1PTUNLNy9TZDVkZXlKeVhTVGtFZmFIZ3d3bUpPV0lTTDloWDZy?=
 =?utf-8?B?S1Z3dzNPYWc3aDJoQUhZdFhRa3p1Q3JtbE1KR2poaEhkSE9JNjc5cjVMUmRR?=
 =?utf-8?B?SWZMcm9pdHdwelA3QlV2SW9vWEg0Q3EvWWxhVyt6QTdpUnQxb3I0Y3JpNTdR?=
 =?utf-8?B?UVhPUWdqUUEvNi9ZclFROHlGK2ZDUkdONGtrUE0xTFBVZTErL0xZejhVTDNM?=
 =?utf-8?B?S1RKdGlXTGJMdzR6aGx2alhQMTJmQmthakFhQU9Lc005WUNDRkM4K2JKNWdC?=
 =?utf-8?B?Wk1nYW8zK29iZlN3RjRmSVYxZjc0a3U2V2hCZWRPbHE0SU4yNmc5U2QyTWpT?=
 =?utf-8?B?MStpWFhLUVlLRm00ampBQVhnV3FCRzJUV1JrV2d3NXkvQ2lzTFQ1OUFOUTda?=
 =?utf-8?B?cERVUXZaQ3Q3SGxOaVNpWnlFeHkxYTFyb29objlpU2thTmxxYU9TT2hKZzdo?=
 =?utf-8?Q?Xzl8OmP3Jv/30pfDwP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: feb37622-e220-4c4a-0a37-08df4412be46
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 18:52:20.3431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rcdQZrhx7nEn5SDqp5fzUoL4UWrd7fctN8uvhZaXBMRlk+nHXFhmZBfyAmz9ZXzp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9641

On Mon, 16 Nov 2026 15:26:28 +0100, Ard Biesheuvel <ardb+git@google.com> wrote:
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
