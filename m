Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.30
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794855208;
	b=xhyV3xo/M45VRiM2AX1meUmI2QEDLqrdPulEo9T3Iv9q58GP16tffL0lAt5RmLFfKO7t
	 1TZUCfx6nDInpLCHDZuO1QcBYZ2P2dswpWbqbkC6smv6s8X6e7eHQQEVkXdCviCQ42w20
	 aRHIHbuV1rnqhyoUB2RytNT6JbJYD8c1Mt4sLtBGMHL8Eq7PzECLPOYZvUwhTDgnsEVz+
	 j+mDJJKNFnLml+h0RT/XrjtrfBltUFsT/o17yBw76kHG/1aDDqyDS4OiIhCyk2s6HpM3S
	 RGV9gv7c+JtlTb/sbb/2eH9zQMBq0PELCf/H4WRI9bUdOUgbWBsjOu5eDKS4TYny9DA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794855208;
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
	bh=YHVtlraUPQQ/HvMidNSsNfaagp1kVbbuWFsoMLlFz3M=;
	b=wD8/lVu/LrrUF+1oxuP9ZuNMNhqNsTrVqINYc86+je250gC0lxmyeP0UD1kv9uhJbobV
	 qzyh69GpJBau0kYi0R6lK6Tf40TyvfzYDZB7S2sgqRu5v4CIllzT37mY0690Nox6OlPE8
	 RRUyXTufLNkqG5P7/0x8fuvYRmY3uTsUmuHduiOu4/zam5NPQuO6HVh/VldZLYAOOxPe+
	 xLUnBNTKvG7zeTnr+fBWJyBnL/xOd7s1cuN6LlJ3K3Tibnuc4Fx7SPz9uP6zuCiTRshmt
	 1MhT9fNo1hUUhaIhkjgkVr8sbCEYw/ICkk2VMV8C6zrd5LbkEIjv44ij99Cqt7rK/Qw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=JulS4qQW;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.30
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011030.outbound.protection.outlook.com [40.93.194.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71268606A31C
	for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 18:53:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 71268606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=JulS4qQW
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XTSlVOZ6ssEvUEqLDhNw82C/KEw63zlJBUb7tMXbvEenmttOSmMtIrXPEVa77cqAQbwJ+jqExrxKZjzJMgU98OTC6LNplTll1ZFsLT0y0EAy+Tt8sErZ1AjgpgV70W2BDnr0DfbdK3ofYT+9vjvPpcL080o+X2HT6P0VtC1kDXUcX77d5lv5/YB0SKhldaG9haKyY9llKYLKLvQlp6TNndCIZ8Nwl2Z61L3LwlXLS2g+1Fwim4Nn+n4vCG/pxc6U9HpfjidRCI4eOeJ6GbCH6uQaMzTKNq6D/RBwL7lB+vJImzt0TL2s+cUvyVCQKPauxb+6f33yqLX2iVfyr1h4Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YHVtlraUPQQ/HvMidNSsNfaagp1kVbbuWFsoMLlFz3M=;
 b=ZIXd0aMNVcbJf8Zhbtm0cgbHqLSL4sFUZAwzfrlWaKjPeNVlui+chmYADUfKIENUZAxFIhau8chZ608qnnqV+c1uEv7nuAnBgebUrxdJt4dDs3qZi4n+CNR8ijBVeHhWMOZQu7tIXyfCJe0UuxDnXTWWRvYgBAAS4Y5FQLoeioQR9jE6+wT7O1MpdrPuxzTdHqhozOi1/efZ8Pyv5FCnEbmOfPHg4X1gGoW3dAjKTJ8gFXacFcijsqJD2UKPPL8PymAzKAsL1ib4f5AmjA7XmbV02tB1Jtlvr+Dw6Y675eGFf8L0XO7b1r9nAutR6DRldXNG1Eq9+UCGrX7gt/HBqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YHVtlraUPQQ/HvMidNSsNfaagp1kVbbuWFsoMLlFz3M=;
 b=JulS4qQWzcBQXcMF3uV7DR/M433m+Vt8kI4seMCn6jEWHxZafEIkngRyTZOFn+B0FyYhbZVygms42KWFwe0P6l0mMB7UHjh9nEmbVwttzmOM8tMS3rdms8AtyI/0+UG9eotCalhBuPD9JEYYuUBsumvnumZCfXfQbVXcjdWaTWBfc04EcYUFTqSH+5xPsy++vG+yr+JWfWMF4uxqgr2UQmbRizZhHgl64X9x1XZporaBL5Apl7ri2F2Eq+D8fXP8cEaHjJKMIeS0CR2SOrosGfzq2DlW1jf/zugfZmpF74CRqfWes/AQf7vX2pseNFjGsq0oggU0hOxsEu59J1cI+Q==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by LV8PR12MB9641.namprd12.prod.outlook.com
 (2603:10b6:408:295::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 16 Nov
 2026 18:52:20 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.013; Mon, 16 Nov 2026
 18:52:20 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 02/15] riscv: Use _stext not _text to denote the
 start of kernel code
From: Jason Gunthorpe <jgg@nvidia.com>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 Ard Biesheuvel <ardb@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, 
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
In-Reply-To: <20261116142618.1687025-19-ardb+git@google.com>
References: <20261116142618.1687025-17-ardb+git@google.com>
 <20261116142618.1687025-19-ardb+git@google.com>
Date: Mon, 16 Nov 2026 14:52:15 -0400
Message-Id: <179485513557.2274641.15719456959562825612.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: MN0PR04CA0028.namprd04.prod.outlook.com
 (2603:10b6:208:52d::27) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 54321fa3-528c-435a-b0df-08df4412be31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|10067099003|11063799006|4143699003|56012099006|261022075727099003|261021121427099003|261022115727099003|261102123227099003|18002099003|22082099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	tzeoBo4NZK3sm0TfSuGXMq53lbwMPMzrcTDuMU+/FOI+0ZBeL67ltnEAxuly9ZlOOVqd01JdqPJWgDkHWE2VGGbzMn23O4dehvjXsVFSrY/mUCZa7cx/MAOAiyibtMTmu4BbAmODAamTatyvjmxLZ9iZtsaxT8H4U3+xYaEk064012hBGTx97j/LNX1lqPiOEwJmscY2ln1DQCBJuXuzP7CH9PRoi2iCdo3FH1fa+1gMfYSwoWz3DS+iMRftcYBDrRMXu4MGpYoiL1XSkJTGkn9uNIzc+9tgoUln88ck03uy8tO2ddyTmy7YI8tooB825G9ZElZ3yCtomxuceCpA0lFrCBDdbwxSaI/9uBhMWw+LP3On6fH4y5kmNxNBWuhSxB+GkBaEGacq1rUkaomqZyJ8EyMGhBsKB4meTX3z8XzqozCEb1ihl5sndJ75KuOxMHKNbKil66XUjXQ+QubwAarkq5jBb4E4zssqVuXOmlAL7zoQxAgwahqHTT9PxObhIQnCdrh4E9pIo7xW4R//77Ns/33meqflfLz3XwBCFAKcTtdp8i/vhgPCITj97hHLzRgytY0O54/mfWiW3z4w0IpaCs4RBBL6cGE388iHK4P6gQcGg4LxcQ7QpJTZpkJ2HUtIz4b46KG/gdP6mxCuyIsBRY2JkkqFOgo1/buGSlI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(10067099003)(11063799006)(4143699003)(56012099006)(261022075727099003)(261021121427099003)(261022115727099003)(261102123227099003)(18002099003)(22082099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cjd1OURvOE9OSTQxTU5WM1ByczFkVys1Yi9mSGVMdmZaMHBIek5LaGkyakln?=
 =?utf-8?B?RGdVazIxS3pkK2lMUXQvMzhDeit0NjRRU2cvb1BMQ0lnd0xjQkJXb05pejJz?=
 =?utf-8?B?cHFpMDh5ckZ4ZW5wS2Q1ckQrdGFXUWVKN012c2Z0aXIxcHpYOVNJd01ha2lx?=
 =?utf-8?B?N2kzbEVDUEVwV29sUHI1SjRDM3NTK2FHL2YvbUw0WmRnS09QalNUTDlNdkJ5?=
 =?utf-8?B?UHZSTDNBUGJYcHZWTm1wR05pYkJiT3RrS0FSQ2lyNTByWE9iQkhmUHZhenZC?=
 =?utf-8?B?M1ZFTmdEYzJCaGpoWGttak1tOWFwYnhEZ2k5Sm5UbFlwT0NsTko0N245VmJk?=
 =?utf-8?B?c1hFbVJqd3FrUkwwQ0pDdUFaSDNRc3NhYWlMNVhVZFpNb0pobXVNZzhITVdQ?=
 =?utf-8?B?QS9wQ2dLU211RDZkVjhwWXhQakg0ZkdiKzdTOTZRL0VHK05CNkVLWFJLYWpS?=
 =?utf-8?B?OWExaXc3WGtHek1TektzMTZpaEdlNjR1NUgyVE94S3dERlQzNlE3ZUpNSlNB?=
 =?utf-8?B?MVZxZ3RmVzNuRUQzdmpDVW5oN0loSEdIQUVscXpxK3dHMS9LUHpkdEJKbWoy?=
 =?utf-8?B?c3pVV2tTZVJqSVBlZzJtYVc4S0RPOWhOZk9KbDV0bm93MlRTZ1laK0ZlcUFH?=
 =?utf-8?B?Z0lCZnY5M2FVVk9DVTl6QjFIa2ZvUE1GV29Ndk1QdkNKR0V3R0FTNmtBM1Fv?=
 =?utf-8?B?amdGN0FBT0dBckdZY0grR29FbFN6NExyeHlFeWJ3M1hOdlFoOWNEc1ZXZHZD?=
 =?utf-8?B?enVWQU1EL3VZSTBIaEJmbVpFNmtySDFScndNNkRvektod1VCQ1BMNHE4Ky9o?=
 =?utf-8?B?NGNSMHRoOTNwREt4WTlPTXFzMHBHSlBUblIxRUhOYlpyM1BaY2xhbll1SUNq?=
 =?utf-8?B?TTJjZ2p6RVBZNXN4cSs0WkFTMmNtT3NET2hHOGpTU1MwRGhUSzdZVHg4clFF?=
 =?utf-8?B?Ly90WHBZWWh5NXh1eFFBaE5XMVhCaWV4Y0x5ZXpZNWF2V0dJdE1PblZCWGZr?=
 =?utf-8?B?TGdhRVVBV1R5bFVOb3J5UkgvYmxKTVRzU3pHcmZKT1pWN2czelZ4YzhZaFRU?=
 =?utf-8?B?TlB6V1M3TEl2Tm04NTlYUXRMSEh5b0FzbG9aN1lvd3RYVFkxT2FEL0dBU2R2?=
 =?utf-8?B?TjBHL2pGbEx2ZDlNbWxWZTBDWGVLT1JWOVlzR3FBMjhJTjVZWGl1ekI3VWlC?=
 =?utf-8?B?L2dxVTRMYXVqWHBUTGxhN0tXeUtDNWp4clAraFJwRXVxUUlDYk5ESWdwdHFR?=
 =?utf-8?B?T2d0cDBjL1lXaFB5VldPb2duc2xGb2d5K3B6bzFaWmdZRW9XTVlaOEF6ZXY3?=
 =?utf-8?B?OWxxZ0tGQjgwZTJDeVI3THpNcmlDdGlwVzhxYmwyUkxmQlZqWDdOQWJtYWRR?=
 =?utf-8?B?aHBzd1ZVR09FV3ZNcDNydE9pNzdPdUxxRDVya0hZS1VldjU2VkRFSVVCTHly?=
 =?utf-8?B?T0t3dXIzSG45OG4zL3FGSTNuSVNheUpNTFZ6bEh6K2ZSVnhVSmhNZStVbHRU?=
 =?utf-8?B?RmxXalRHeEJCRVhleVpvM2VwNCtESS83dlh5UlVTbk1ycHphcWxtK0Z1WFdJ?=
 =?utf-8?B?NWkzVG5aRkI1aHFNajRMZWxMemk4R0FIdzdncWdIN2REK3RrNFJUNmJ5VnhH?=
 =?utf-8?B?OTdCaUhadjhRWWJEYUhhTWQrbUllaUpKZlBXR0xxRTRnTXY4bHBKVHcrREtV?=
 =?utf-8?B?SXlOR1cwcWp1TUx3SnhOOXpDTFlEMkRYUktkUWFZeHp2UHdFZW5xRWNCT0xW?=
 =?utf-8?B?QThUTVkyL3c4VkxjK3JoaVU5SGE0d3NZbFN3MWdZbzZ5OVNadUErT0tHMHZD?=
 =?utf-8?B?TXJ3R0VpU2JDQS9NOEthK0FlWWtSWmtEbW9CNzRmWDdwZHhlNU5MWVFYTHFZ?=
 =?utf-8?B?ZVJZajgybVg5R3RrZWZKcWs4TlRydEJNcXNWZXF2TjBFU3l5dVVrNFNrSllK?=
 =?utf-8?B?S0JSdmkxNS9Eb1Q4SE9VMERlUi9pMXpVdzVxL3hQTWZ4L0FLdEJmT0g1aXNz?=
 =?utf-8?B?RUg3ZDFHYjhtNWpPQXM4NEUxUmU4bkwrYUI4VTM4akcxbS92LzVsaHI5SlNB?=
 =?utf-8?B?VzNydHVuU3hxKzBqTDFLZ3h6RDMrb2IyNzhjNzB5TExxdStvd3E1R25pdnVY?=
 =?utf-8?B?YUliNUpIRmF2bzRORmh4MEFScXFOME1zb2svbmUxbm1RUEc5QktCL3J3V1lt?=
 =?utf-8?B?YmlMWGh3dXdaRHc3QWo1eVRiMFJjRzZDLy9zUDhVSWV5K3hGMzA1YWZFVlJT?=
 =?utf-8?B?V2RqQW9yUDFKV2QvU09hckdsd0xjOFp5cVNHQ2RXdW5saHJ1MzFYMVR6TW1t?=
 =?utf-8?Q?gkNCN2coGzzR3b73ut?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54321fa3-528c-435a-b0df-08df4412be31
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 18:52:20.2166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SU062MXMmLPuN7raDUdZWa9U9CSYzg/vLywWE5vlUrZXxWOq2HmuW9czBpSCrErr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9641

On Mon, 16 Nov 2026 15:26:21 +0100, Ard Biesheuvel <ardb+git@google.com> wrote:
> On RISC-V, _text and _stext currently refer to the same location, i.e.,
> the start of the .text output section, which follows the image header
> (.head.text) emitted by HEAD_TEXT_SECTION. _start is the symbol that
> refers to the actual start of the image.
> 
> On other architectures such as arm64, _text refers to the start of the
> image, and _stext to the start of the kernel code, and generic code
> (such as the EFI stub) may start relying on this distinction.
> 
> [...]

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

-- 
Jason
