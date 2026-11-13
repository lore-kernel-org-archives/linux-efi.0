Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.34
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794582638;
	b=tILE88cA/9MQu2Z4/YEpG5n7nlxD3PkaQB4Nr61ddPjKKsfYswa/CxosweUDVV6CaGmM
	 afpg2z9gzAzkYZp5XwS3ouh+oKPpcMtjnWCPlkuTXXMAykgW3lR2230FIOU01oSgWVqA5
	 +ipfnTPRZ5SXX4GvvgYdAh6T0K+m6GJYm6QaCweI9EejwrTk0LqSKm/OULMZts7g0fZDN
	 mrxJuXVY9RucOqr+V0/TPTAOPvqFmfhADqyS3TGwO46qOU6/NUpomq5+39E1c+BvDa94a
	 IA6487ZiIcTRFUPmO6pMZfXyD6cKVA01snfAAhh6r7wxhUnJ+RKCDq3+RJiiCSxhTvA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794582638;
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
	bh=ayUAHA1oXAz4KjpS3kE3aE8a0OoegROjvAffLCjo/uI=;
	b=2fCHQ1bAOqAiDldC4ADr7UalPPDhQG+gFGcwySLBeayyyOGQBSa/z0cPXhiVBZtfHxa5
	 PvznjsAtifH9eqpQutQTpVcRbOmt5xPaD2dGLu41HfrsYa6T2rUCWGQ7stC8iQOJYbFym
	 mDEteHCkEsxCDIZ9OJbHzBQXqlYNoRm1YhNmJF7ihXphtpA4j6ui6RoPRjd5PWKxXnQYw
	 BwRGh812ONXWwWJT73VxL8qeLinyw8eSjL7zff9wZYGzADopE3RMni1HE9QQVtQB6tfph
	 MRQrKOKKcWVH+OWWZnrMRR84lVg4H5wayXtHXEj5YarOuJqo5l4TgXC1qKZF25CLRyw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=dNqXAw8T;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.34
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010034.outbound.protection.outlook.com [52.101.56.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B99606A890
	for <linux-efi@vger.kernel.org>; Fri, 13 Nov 2026 15:10:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 70B99606A890
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=dNqXAw8T
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AdnfOAameRNUn95AGlzh79PB2rG9vvqoQIMlO0jDQH/kHmfofe+qV+JXRfcjxGWeLJ4LgFUPdW9q1Jv3b0k8r3Jkc5ShIjjsy4/VpSkTdT/qIY2CIOwXE80pFiA+9EimeUIW1OMPrv5EOrUPXa205K3y9D0ASzgTkE4w8YUJoqq4mb3CShDlfUl6izm8IPkmGlFR+tuiH0PB5EcjT7brLiZd1AybDXwK5hK+sCrLcI+KGi0sr/KMHlQOADX5A2jEeZxF2BPz5btIMdejQ3u4LArs0r7TOhJK4X042TmHPLInQVPW1PVkSEhrHtpwSdXC2f2AMiXPXSy+mpcfHb1frA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ayUAHA1oXAz4KjpS3kE3aE8a0OoegROjvAffLCjo/uI=;
 b=XIa5AuOVPVgUZC7bsszQb99OvLfg351R37ofaPz32vLGm4JagrAwwsR2GY6ZGbCQcIUT8SAYgojSZ2kFpW3SS9+5Up4aRT9NX8AVh3ma+tvJ8OH8Wv1AflaWpAZwI/WcE8OUITyDQ3gXMJHjpHscZhfnx87Y3zopO6rniPcEEfNsWHDEdxDTGJCCF0Jx8KM5H2zN4GTqBrVJ+dAmlTH+UUHdYPXW7KtUx3kqD7qNbWkfZhVHUUaNqjudZ8ndsxoI6k0IXc+rN4ZQKEnSHZ8ipIBojwyOUzjvIWtCwqE36kXSGtiUqjhleXqL5/NsuIutEBLaSIyef4pAXMRQFKh2gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ayUAHA1oXAz4KjpS3kE3aE8a0OoegROjvAffLCjo/uI=;
 b=dNqXAw8TM92ETnrw1B+jUxNvlVoApKWJpKj/VztToTd/nZuumg4ck0nNDnYPVxyea3PxFYcZKvb1FreybheHNF78C9dazq4loIFJZrshsT7Uj+mQzS4wAbnTjmP6D0nJnzjPwLLCiNy8cLD1GIZcdarO3xlbzoFO80fXHo8KPcKzYqZxQQXgzsOMNGa8ApLdFUUvFuXJnLpOvGtJ5Gk3FwJgwIW6GIiUW/tQhpb1DRtjJ9OPWeQuuHPWPFIJz2r10RJxv2O3/YmsNIMEFQtEkT19KJ6YAZTSbDIChbrntXUvkGAYyLo4LXoCLL6csmhbeecT9TSlAwyx1oSmzK0j7A==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by LV3PR12MB9332.namprd12.prod.outlook.com
 (2603:10b6:408:20f::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Fri, 13 Nov
 2026 15:10:31 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.009; Fri, 13 Nov 2026
 15:10:31 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 03/10] efi/libstub: Avoid _end section marker in
 library code
From: Jason Gunthorpe <jgg@nvidia.com>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 Ard Biesheuvel <ardb@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, 
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
In-Reply-To: <20261110121731.2728824-15-ardb+git@google.com>
References: <20261110121731.2728824-12-ardb+git@google.com>
 <20261110121731.2728824-15-ardb+git@google.com>
Date: Fri, 13 Nov 2026 11:10:21 -0400
Message-Id: <179458262195.3625095.4302457109469048720.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: YT4PR01CA0276.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:109::13) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 9add6f37-fa75-4d20-9509-08df41983ef4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|1800799024|366016|11063799006|4143699003|261102123227099003|261022115727099003|261022105027099003|261021121427099003|261028144727099003|261026140227099003|56012099006|261022075727099003|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	nG+RyIlWoJ7qsoe+MjqR4/ai7ZW9lcflo/gxJ5hpxGPKwwbm19T/dPHMLRlfz0brgB/UU1zPimndORzLDIKMlTV3S7TqRKyBusY9B0pofAq1169H7OvA+MG2r51v4v8tu10IUmEB3xi8kHxatDHUP8eGUu1eQHPlQzt6xwtNf0oVHl1MMEcH3mBsP2HbLFB0AdRDXDBEWpFxgxOLtJ93ku9sK5xqZFXxSrA4zVij7qSDbatjm0P7FHhg/WBuVTDd/cd9zoH/ZMDQDNwbMbpdgVVPDAKBx5lSQIHZBQN1kwP2JlDukf2PN8JFhktgtc6VRJ1uvw3wHOCAcEUsitmJKzDUXLpzYYWQIuhoZsOB7PnQq/19yDSqPBic2NAjxbGAZCtbkI2IF4a0IAasuKuja50oUu6X9yxJ92ylKF+PIlEXl8lQTbrMH6qF4Sx2lNtwja7BiW/suK7xmB6r/oSlYsqIWnynNJJ7KlZA7zSIQTPGMlJ+FDhjPnazvxibiI5PEMI2iBDrCy67rhaalWX3aEjj/gAL10UNCwulvsc1HwBhnsjSI6Ym0K3GdT/2BW1IJXDWM20/C106QwlIivorxPuxC8gY0W4LHcSPkDjZdWotDnH44Sh1TD/fEsp/6RebwZ0ATx/Tvm2VMjSJO1hFotevRCWqpTqq2yrz+O4htgw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(1800799024)(366016)(11063799006)(4143699003)(261102123227099003)(261022115727099003)(261022105027099003)(261021121427099003)(261028144727099003)(261026140227099003)(56012099006)(261022075727099003)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c21LMVJySWx3ckxHVUVuZGhhVWo4c21BMzRIL0w0MXlPVVNOTFhpb2ozdWcx?=
 =?utf-8?B?bFROSTh4WTZrRDNaZ0VRczFZcWFvRUswMFIrR0luSWx3T2NVMFZrL3Arb3FY?=
 =?utf-8?B?UnFzVWJEODRWbWpEMkxUL09kYUNpSzUweG1tOE9OZDk2WWIyU01aZUZDMlRQ?=
 =?utf-8?B?Ym5jaThsK2p5SmNqZHcyS2dvcXowTzJFN0Mva05vNGx5VHkrRm00Zk9pa0hM?=
 =?utf-8?B?dWNBdmZhdVIwL2NoOUFma2J3T29ydkxQcStabGROOXdhZ3BwOHU1UXpBUkhq?=
 =?utf-8?B?bHUzMWZqclZtRUsrU0x1T04yeTNad0FHZ2tIT29JcmZJdkZrL3VPN0NDdlJy?=
 =?utf-8?B?Wm5LMGhkS3Q2d0JoRzJRc2hkQmZEdS8rUEUvMW90ZHVCcmtiTDY2MC9YM3po?=
 =?utf-8?B?ZXpQdTN5TkJVcnpkbG51ZnRETnpTYjRZRDRaV2NyaVhGait0U0ptNDZoYzhr?=
 =?utf-8?B?bW4xUC9FSnVLQ0R1dGwzWllNQnNLdVpZTXFKNmNZWHV5WE1yWWZKeDJBdzh5?=
 =?utf-8?B?N2VxWWdnVm1lSlBBRjhDbUJzRGVPZTZlWEFJejd4R3FOMVU1YXc1Qk5ZNGhQ?=
 =?utf-8?B?eUdpOGt5OWd2SjV0bUZsbSsrQlc5MzRJZW95a25Qa25yc1F5Ym1XVmxtR0Uy?=
 =?utf-8?B?RTFETlo5QWlwcTA2b3NpcHgzZVNxT2dvSVZrdVFIdWVJd2wzMkJnbndTT3Nx?=
 =?utf-8?B?VUhlMm9nU1g3SWJ1ZlNzS2ZYZ2Q3clhleHZsVVpXN245bXNjdGVTZFd6WGhh?=
 =?utf-8?B?aEJZcnFFRS93TVpua045VEMzeVgwZ09idFV6SGJvNUpCb04rQnJiekxXdFF0?=
 =?utf-8?B?N1p1WlJFSEw2MExydWMxUURsV1NUbnZTVG9vY20ySlF2S2lGb282Wnc4WlRS?=
 =?utf-8?B?VVlZcGVhQnZEVGl6amV4bVpVS3RrRU5QRE1rYjZnQUxPNWprOW8vL3VqOUNL?=
 =?utf-8?B?UWFQejQvZS93RHowa0lNMm9tbkdBY0ZrSHVLbGRnQjI3b2VIbkVsM3dLNkZw?=
 =?utf-8?B?MHdJRUFZdEh5Yk1QaFVoNUhvWk84TzI3RjBKbGhqS1E3YnAvM1p0R1l4OExj?=
 =?utf-8?B?V3IxTmF1YzU2U254YzFlcEsxSEJTcnBKb3lzSElBbFhpNXJjbG56V3R3a25U?=
 =?utf-8?B?KzA5ckJ1eU1TUTZteEZLM1VkZUpuajVFVWRKYUhnbC82MmU2aTRGaUNNaW1t?=
 =?utf-8?B?S2g2MGVJQTdPT1J2eS9yM2xnL0lkYlJZQkZ6Y25ZYnYydW9CUVppLzJtL21V?=
 =?utf-8?B?dTI3MEhIOERpazBjQThvZVJIRnZRWU5JNzFpQVVqZU9ST0tuUEcxTlhwK09C?=
 =?utf-8?B?NWcwTDRsOVM4TjIxc2pwWWNucCs1dFlma0d3b201Q242cUFIL0VINXhwZkto?=
 =?utf-8?B?R2Mvbkh0MlpRUzVhR3B3VFYyR0ZuN0pHbHVLbkZ2M2hEZnpoNFdjT1NjUDRB?=
 =?utf-8?B?NmswanpvNFFYd3RFMTFuWUlqazk4SE5EWUcyeERBVG9HU3ZxdEdCamdZYTBy?=
 =?utf-8?B?NjdWM00raXZqVkZKRVFqT2FZNEM3eFFoS0EzT2xxSlRremdNc3NDRnhZWWhW?=
 =?utf-8?B?akJGQndVM2toL0ZqY1R5ei85ZGY3eHBPdEowMWFLS2llbjZHNUtEQzJ0MGd1?=
 =?utf-8?B?RHM0cjZ4Qi9DUVZMNTlVbmhoZEd2ejVqQW5sa09lazZ5ck1pTTlNMWFQNXZS?=
 =?utf-8?B?NkpiMU5OWVVnWndPY1BBa3VNdlNnTE9FcXJzUXpJWnZkUnRrNGVRSlBwL2V3?=
 =?utf-8?B?NERpM1ltMkpBb0JxaTI2YTBvMGdWbnBZd2VHbzYwM1JMUkd1VTA5TUNPZUdj?=
 =?utf-8?B?MDRnV3FPSDR0MDNLYnNVL21FQ2hJQ2VKaXM3U1k0cTdSbW9CdlpKd1lxSjlX?=
 =?utf-8?B?ZExZNjE4VDNtdTBqd1lwVFlYUVU0QVBTYk54blJTTmdjNzlTR1VSc25DbFZa?=
 =?utf-8?B?U1VORjdMNnFVckMwMTlJSTdLOG1VeGd2T2I4cXUvVHVLT05yVk1GY25oQUUz?=
 =?utf-8?B?V0pzUzBNUUVaVW54ZHZ0a1FXeWp0NGdMN2ZMR0VYWlVHVnFiMEJDSGp6eUYw?=
 =?utf-8?B?aHFsbk0vUUpCdVhTcCtmM2xjZHNLYmExVU9VeVM4Y0Y4NFE3U2huR2VaMzFS?=
 =?utf-8?B?aFVTQ2gvVFJqWFB0eGxtY2UzWnZLRHJVM3FTWURqdit6aGFlN0NESUpnOGcz?=
 =?utf-8?B?TlB0NVB2RFB5QVFPcmprMVJNRlRjay9Jbk10ZVlocW43emdoRkVIeGtsWHZa?=
 =?utf-8?B?c2hISytaZDlSVExneDNsL3RDcEF1NVdzM1h4YWI5S2syUjNiK0sxaUowbXNJ?=
 =?utf-8?Q?TXKvzErZj45EP9I+BC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9add6f37-fa75-4d20-9509-08df41983ef4
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 15:10:25.7890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MB3SfTVoKGYxVdwGO5+hgutAdLRUJ4IcJOwFGXqVstsS9JzJnTL8cOC6In9n3rtS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9332

On Tue, 10 Nov 2026 13:17:35 +0100, Ard Biesheuvel <ardb+git@google.com> wrote:
> The _end marker could point to the end of the kernel image being loaded,
> or to the _end of the zboot decompressor image, and so it should only be
> used in code that is obviously only intended for the former case.
> 
> So instead, use kernel_memsize and the image address to obtain the same
> quantity.
> 
> [...]

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

-- 
Jason
