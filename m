Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795197147;
	b=zTNK1yvy0JB9jhxP9Gq8iuymQqo/oBN8lejWSdtR5mj1nPsY5tYWC6TftgDNBRtcg0lK
	 NF/CmHttepScMWzJTSjQKZ/ZdD41wJb70HBuWbbMpFYzUBIy58CRa+rCBkfmKjBvRMHaA
	 4FY/OGQAx70FUCIb9oRy3ZpCnUOvU2C6fhvjWQzeHPrf08+g4eZVWZBGQD+wriEKowYvA
	 sdFaWXNDH5p/EreRGhUGvfO+uWFwhRMrVlEse+Q45rCjWOC4Gq5OXWwFTNGyZvkYojmfA
	 x8dcpHGaOSw5uuVULPbg9oJoIWC92ttfewea9LfC8RrUr28Ap8kfRypbeSFrCWhOqaA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795197147;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:In-Reply-To:References:Content-Transfer-Encoding:
	 Content-Type:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=bJgceeAEU8DOiQscuYE+6z+PhVwT3hYvgvXE/iZIG2g=;
	b=4KXkMU4Y+pnmPwSRKm19u6xW7wb1W6I1ZqFyVEIIn6EovK/PJndhd4gzgRhTfEXGuJyb
	 a4PeHbuveM8iQOdiNOthSDFcVMA75bAu1TI/hM/7aIyPMfxyrDrTHyXMdXEzmOXrb2gc3
	 vVw6EbJVqftFczEF/nVdU6CGiQzsnOlhSFc8nC8OC7aAd0CCAPlcJwKhwV69+hhJ3Vgu/
	 uLsJeG/AzvG4zZZq6DJlQQE8tS9KGBYTGwSnNAv9NxiopDx5ZrVVn6MQDAltdbMbd/kUh
	 WQocT8aTe8IBIoqSyhmXXIa+CX9FUND8/oFQq3RZnINER7pAQ74xCnhZa2L8xtWtoVA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=kOBhQ2SR;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.28
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011028.outbound.protection.outlook.com [40.93.194.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FAD460A2602;
	Fri, 20 Nov 2026 17:52:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9FAD460A2602
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=kOBhQ2SR
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B2n7cS8Hb6f0oBMZkV+c3rRDP//MH1frjqIjUqAE4rRfwRUptyTjb+1gPtFpIs5R5xD0zGyl3bPGg+dgTLiABVQGLl6nlYQxgA1bFFc+s/R8snlJWnS6Vgzmkjtij1WFWpMdVAcQTYFHja3fx1/77wvWekk3nSHQFDdICMspE3w3CJOVKJ4wJBGPvN40VEiv/ixSzQ7n78nfKJEY9bYYfOedMakgUz42oyUwU0tGDbF0iA3pSJbDAeZi33RbIj/1i/LUQ1WQtPMvo53yqLQ0bLcOlz2wdfUg8EgM80HKVP/MzkrH9oZ+isXPrHLUNvYJqt7DSez3kLUZGWipyTIkfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bJgceeAEU8DOiQscuYE+6z+PhVwT3hYvgvXE/iZIG2g=;
 b=QWUe4CEEdVIpOHvJ063BO72B82qe4diHgGn51R0KawSPO+Z+k5w5B+Lw9f/3uhHm2Qb6/JMhaEEDoqYpYTgz8gL6XvNex3jXhr4jhHsVEhNdxagcAGfjjwRxiFkQNWwVJeb2FxindrJP+wYd193oJh0Okic4MyF0m69FIIwAIy801u6hT4IQ/kEx2No7eE08lWxg1/HkkX/VDxb5dm3OlA2mNjsa/TFrfkBYnMG9doKhU+K07vBRhfpUJtIMJYv+7FIkiZ/Iy4XEKFkut49pPrACNT348i1hoJ635Af2p+rNA4tOWQUfymK2I2n74HYk4G1xhdLooREP7kM+GsYXOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bJgceeAEU8DOiQscuYE+6z+PhVwT3hYvgvXE/iZIG2g=;
 b=kOBhQ2SR/xFSWCaV2FkWdy0ZjGTmEzSzCN/2frpYY8ahg6TlG1pbhHrCHIkrvy5jBg6cj6Cw0ML+v2pCz70z7x8tfq8NBwl+bAlbJu1RJTnr4Tjqueqne0+0wIs3JlOhWjtJNSxV0tRCdxW6taUNuUyCkLcgmbygPiWcxPcU1sgQIbpwbXj75XyIimy3lrflqs0if1rPGrvfTk/c3Z9H3rU382g7koPPIoJr2RpvX9z0NqeYFc5PokaiskhKqjyuuYX7lMIvdJbRaCoMY0fQzUYDbENGie0Se1GAn13yObNF/+BtHA5TlL76EbEUIlTPEL8tycOcLm+zs2ic7H6C6Q==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by IA1PR12MB6329.namprd12.prod.outlook.com
 (2603:10b6:208:3e5::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Fri, 20 Nov
 2026 17:52:14 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0639.010; Fri, 20 Nov 2026
 17:52:14 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Ard Biesheuvel <ardb@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Justin Stitt <justinstitt@google.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-efi@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	llvm@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Bill Wendling <morbo@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Will Deacon <will@kernel.org>
Cc: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	linux-integrity@vger.kernel.org,
	patches@lists.linux.dev,
	=?utf-8?q?Piotr_Kr=C3=B3l?= <piotr.krol@3mdeb.com>,
	Ross Philipson <ross.philipson@gmail.com>
Subject: [PATCH v3 11/11] efi/arm64: Implement ARM64 DRTM in the stub
Date: Fri, 20 Nov 2026 13:52:04 -0400
Message-ID: <11-v3-22d1a1eb7d2e+17de-arm64_drtm_jgg@nvidia.com>
In-Reply-To: <0-v3-22d1a1eb7d2e+17de-arm64_drtm_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR11CA0004.namprd11.prod.outlook.com
 (2603:10b6:208:23b::9) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|IA1PR12MB6329:EE_
X-MS-Office365-Filtering-Correlation-Id: b4360adc-e37c-43bc-ca40-08df472eff9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|18002099003|6133799003|22082099003|261009223027099003|3023799007|11063799006|5023799004|260925021911599003|261022115727099003|260925022911599003|260925021311599003|56012099006|921020|261102123227099003|261028144727099003|261026140227099003|261026121527099003|261022113327099003|261021121427099003|261021123027099003|261022105027099003|261022075727099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	nHST0hkd9vbmekvJprJ32HpG6AUlwdxxQSW42dL7lzbS3OkY0q+7RjHL5SG4ILfKf86TQGcSWeBSSKsj4VwnZXs3JS/jFsq5QY1xOtSRYHvaxoOTQ2yTsZeP5Q3DZfOJB6kJhGBSHNy4ebhzhMtWf3KS6wk/4jgvTNxePAf4r001b3xA1itnnQapSfP14KNfn4/yxbkYAP0844PcWy+KPIR3Qw1Ho0cMUQHhR+QFTVo6Uay7TWjTq9WKcEpgDeOeito1RFo94Qxez0GrX+b5BKRyEM0ZOrkB/ZO9qBBUMlpq7g9HMODjCxRc/5+JysZDOuLHFL/9rbQUOI4GkAlXmUYBsjwselbbzTHFvAPbCHRF9mg6anTXDzdce7uEEWx03CvbOfHHBMplDGFTYav3D/2OZlCYZQ07fsc4CcEdbvXGX799Bze9sLOi2j8Xn+86wUtdVsvqCVIOGwdEPVWelNDK1FVLJVKDZmSQcnH7V4aL6PoWQDyBZ9Q3Gdpkii20w+EjqjXoiwFjdON5vFBMSsjebZUXUrs81T5uz4R8BRyOcLUYqdSXs4LacKerw/TdGMKbMdwzi0+zPK95hS5jEuPbHVMf6ex6OX8Sy3VbIDRhfRJa+3HRqK196sNfNXKZIKFV3bTnOi0cyeoYO8spvYQPXFkK1TLdepU35TaYUaBtcEJV/BwTVj6RkpRmwM5VtNWDGvhZL7J5s0o17oXvGw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(18002099003)(6133799003)(22082099003)(261009223027099003)(3023799007)(11063799006)(5023799004)(260925021911599003)(261022115727099003)(260925022911599003)(260925021311599003)(56012099006)(921020)(261102123227099003)(261028144727099003)(261026140227099003)(261026121527099003)(261022113327099003)(261021121427099003)(261021123027099003)(261022105027099003)(261022075727099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?w+d9ZckjaaSxiHzwXh8nKzYJWBi0/I+mwff4FevrXiKFagUqJIG3/LMTWSqV?=
 =?us-ascii?Q?syE9Btp4hLa9NwRrrbKihtK1PEsKoR8knNGj2xNaknaOa6c5yBVi+mCHEGJ0?=
 =?us-ascii?Q?220BTkaivbdIKsff1FnwIClUTjVWD8MXNG+D8VrUeco1tjMzwbcZ2n8oj5Ag?=
 =?us-ascii?Q?qDSfFNVjU1wBvqh5Z5Lv/iJSgyLQGJ8c8ZDh9JPbr2t+o6azI+RY1HkMngVW?=
 =?us-ascii?Q?BTIdK2c+P8ihlUATASm4IxvbNUXUYlMZQFqCd+oltjcl+t829orB2MhUK8yV?=
 =?us-ascii?Q?lfC/rdgp1b2eUQ2uFFM3OrwkJjrGUAoJSDDDge6eHliiCMHn8gWJ0uwUoatV?=
 =?us-ascii?Q?yAnm2+puBtAXvsCZPyPE2VvTpVONZ8ZtljO/uGWqnE+jh8gsBHiBtpRBZFLK?=
 =?us-ascii?Q?FAs8VVgRLUCR6oBIIMkJOx0J4Zlj8LhYS/E0vU5YeoR0Pk4wIBWMhbezaOnf?=
 =?us-ascii?Q?nSHkbu3dPe7I6RK3/Wa1SzUco53YKw24ZN3sGikKEwUH3va1Pt3wzir05Z2j?=
 =?us-ascii?Q?eePKY7+vZUIe5WQdyHdPkIKTuaYOrBPhavkYlQPpCFpp+mYgS6t5JT20grH6?=
 =?us-ascii?Q?Sd3ZXSdf9TfN4vLzPcibvUns7569Z7cZHMgpBj5Dc/TaICeJb5puvJ+bUocw?=
 =?us-ascii?Q?daTLrr2sXhQJpyepJlsIbHjUcWgvB8jB4+O8kY7xyTnvHGXt+G8c9Q8X8NaQ?=
 =?us-ascii?Q?9oxd2yKDSGoTatCYjcNfDK+yNuH6ks3s/3wfWWbEtWryG6D+jHzeHBw2y3uR?=
 =?us-ascii?Q?MxdF1XaZGV0yo8Il6Kxa4Hcozhh8e8jYaZ/6vLlQ+xrh59n2N5F2QHtxnVpW?=
 =?us-ascii?Q?FHRR7NNXYBJwrf869uUkVfQm8DvkEAmbOeGtqmqfk6wwTMs2AuX8MykIscoz?=
 =?us-ascii?Q?ZF2fLW7riczPnIC2eMGWUwwTl2A4lEmfWxA2zY3zuMgIKCzKe1cQOiUkstZt?=
 =?us-ascii?Q?KMAlYIEeWdIhhB2APpZnFIXxjrhXwKKQ3dxFqSBRHH1ctFeQkkK7oLVopnZz?=
 =?us-ascii?Q?jse5hvosNxotAGumklNalhP4KO/ju+mjop3TYordMftHRQjKNqdcKf9SqFFW?=
 =?us-ascii?Q?iz3tyXpKcPNEgaJkzNvRaGONhWUCX54QlayfchvHnjjFpGeA9Wvfd58WJAOh?=
 =?us-ascii?Q?glGWTtvvtpO2HhDDFx+F3V1urHZeAq9MYqO0UtPE3fgjOlI5FzIYdm/6JMrz?=
 =?us-ascii?Q?K7mqj19/ASNPkY9w6/06q+1VPIr2bZbgNplTvt974tq0o3D5hWLcBxdNG8Bn?=
 =?us-ascii?Q?03B7ttdUAdgDZVgjyK4nxp1y5pFHxwKzUsTQayIRhhXzhfigPYCh/u8iR/23?=
 =?us-ascii?Q?geOJrCpJ3uv+HwoynC6KuYaEAen09LJRvgHWbtJTq0HV2Dg0iIQdPduffdUw?=
 =?us-ascii?Q?Tc9eiKV1rT7rFuHXauCurAea/Xs/WrPHjT0hBra+XPaSM14bWs5JTrjlXo03?=
 =?us-ascii?Q?jlRg2nEsTSbGGYMPamxXlacgJjx0Nq2i/PC3+2N3Q65XOknAjS/v51zA7crc?=
 =?us-ascii?Q?Yup1I7NCtlHDq4f8a7MockHUGdtFKpooYgrOXlPa0XNcH9Y+WKHw7/UuGmVZ?=
 =?us-ascii?Q?roARIdVBg076KpmGlhDEm9S3qJXkwz3Cl8r5jomvbfsV1V51hnY1z2OiDGrN?=
 =?us-ascii?Q?gghTJ37jGgZuBeIeEsiOcN14kPR06o4dfQHGnc5A0DNjfgfY3Fe8/Flroihc?=
 =?us-ascii?Q?C7dMrC6IujQOVFGGd0kyt4t7dtaOlTw0/1pu+K154mGBnv2M?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4360adc-e37c-43bc-ca40-08df472eff9b
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 17:52:09.4809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qwXSyfu6xFFQRaLexyz0Urtj2VGndZhGuYCy673lB/AxPJqTUx14tQdEyysL4CWz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6329

Provide an implementation of the CONFIG_EFI_STUB_DRTM protocol for ARM64
DEN0113 >= v1.1.

First, it queries the FW for support and collects all the
information. This is needed to compute the extra_size, which comes
from FW reporting how much memory it needs during the launch for the
DLME Data and DCE-owned data. The generic stub ensures there is
trailing memory after Image for this.

Then the DRTM_PARAMETERS launch structure is computed using the
offsets in the efi_info.

Finally, the stub does ExitBootServices and calls the actual launch.

The feature discovery process is deliberately fairly verbose to help
debug any FW weirdness in the field. Enable it with efi=debug

It looks something like:

 EFI stub: DRTM: interface version 1.4
 EFI stub: DEBUG: DRTM: TPM algorithm 0xc, TPM hashing unavailable, PCR schemas 0x1
 EFI stub: DEBUG: DRTM: minimum DLME data 73728 bytes, Normal-world DCE 0 bytes
 EFI stub: Decompressing Linux Kernel...
 EFI stub: Generating empty DTB
 EFI stub: Exiting boot services...
 EFI stub: DEBUG: DRTM: will launch, selected launch features 0x0
 [    0.000000] Booting Linux on physical CPU 0x0000000000 [0x000f0510]

Eventually the launch'd kernel is going to require built in crypto
libraries that match what the FW is using so it can validate some of the
information left behind during early boot. Refuse to launch if these are
not built in and build in the most common ones from the ARM64_DRTM
kconfig.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 arch/arm64/Kconfig                        |  16 +
 drivers/firmware/efi/libstub/Makefile     |   2 +-
 drivers/firmware/efi/libstub/arm64-drtm.c | 383 ++++++++++++++++++++++
 3 files changed, 400 insertions(+), 1 deletion(-)
 create mode 100644 drivers/firmware/efi/libstub/arm64-drtm.c

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 9b08b2457a555f..412fc29f4e1cf0 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2622,6 +2622,22 @@ config EFI
 	  allow the kernel to be booted as an EFI application. This
 	  is only useful on systems that have UEFI firmware.
 
+config ARM64_DRTM
+	bool "Arm Dynamic Root of Trust for Measurement support"
+	depends on EFI
+	select CRYPTO
+	select CRYPTO_SHA256
+	select CRYPTO_SHA512
+	select EFI_STUB_DRTM
+	help
+	  Support launching Linux as a Dynamically Launched Measured
+	  Environment (DLME) using Arm's DEN0113 DRTM specification. Requires
+	  booting through the EFI stub. The drtm= kernel command line option
+	  enables or disables the launch at boot.
+
+	  If unsure, say N. This option is EXPERIMENTAL and does not yet provide
+	  security.
+
 config COMPRESSED_INSTALL
 	bool "Install compressed image by default"
 	help
diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index 2ae86429315e0e..125159d8136f33 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -85,7 +85,7 @@ lib-$(CONFIG_EFI_GENERIC_STUB)	+= efi-stub.o string.o intrinsics.o systable.o \
 
 lib-$(CONFIG_ARM)		+= arm32-stub.o
 lib-$(CONFIG_ARM64)		+= kaslr.o arm64.o arm64-stub.o smbios.o
-lib-$(CONFIG_ARM64_DRTM)	+= arm64-smcc.o
+lib-$(CONFIG_ARM64_DRTM)	+= arm64-smcc.o arm64-drtm.o
 lib-$(CONFIG_X86)		+= x86-stub.o smbios.o
 lib-$(CONFIG_X86_64)		+= x86-5lvl.o
 lib-$(CONFIG_RISCV)		+= kaslr.o riscv.o riscv-stub.o
diff --git a/drivers/firmware/efi/libstub/arm64-drtm.c b/drivers/firmware/efi/libstub/arm64-drtm.c
new file mode 100644
index 00000000000000..73f1ce38394d51
--- /dev/null
+++ b/drivers/firmware/efi/libstub/arm64-drtm.c
@@ -0,0 +1,383 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2026, NVIDIA CORPORATION & AFFILIATES
+ *
+ * EFI Stub implementation for ARM DEN 0113 "DRTM Architecture for Arm"
+ *
+ * This code runs on the untrusted side of the boot in the EFI stub. Nothing it
+ * does should impact the integrity of the post-launch world and it does not
+ * need to take special security precautions.
+ */
+#include <linux/bitfield.h>
+#include <linux/efi.h>
+#include <linux/kconfig.h>
+#include <linux/overflow.h>
+#include <linux/tpm_command.h>
+
+#include <asm/cputype.h>
+#include <asm/drtm.h>
+
+#include "efistub.h"
+#include "arm64-stub.h"
+
+struct efi_drtm_config {
+	u32 launch_features;
+	unsigned long dlme_data_size;
+	unsigned long nw_dce_size;
+	struct arm_drtm_parameters *params_addr;
+	struct arm64_drtm_handoff *handoff;
+};
+static struct efi_drtm_config drtm_cfg;
+
+static bool efi_drtm_query_feature(u64 feature, u64 *value)
+{
+	s64 status;
+
+	status = arm_drtm_query_feature(feature, value);
+	if (status < 1) {
+		efi_err("DRTM: feature %llx query failed (x0=%lld)\n", feature,
+			status);
+		return false;
+	}
+
+	return true;
+}
+
+/*
+ * For the kernel to boot it must have the matching hash algorithm built in to
+ * be able to validate the TCB hashes. Assume the TPM hash algorithm is the one
+ * that TCB_HASH_TABLE will be using.
+ */
+static bool efi_drtm_hash_algorithm_supported(u16 algorithm)
+{
+	switch (algorithm) {
+	case TPM_ALG_SHA256:
+		return IS_BUILTIN(CONFIG_CRYPTO_SHA256);
+	case TPM_ALG_SHA384:
+	case TPM_ALG_SHA512:
+		return IS_BUILTIN(CONFIG_CRYPTO_SHA512);
+	default:
+		return false;
+	}
+}
+
+static bool efi_drtm_probe_tpm(void)
+{
+	u16 algorithm;
+	u8 schemas;
+	u64 value;
+
+	if (!efi_drtm_query_feature(ARM_DRTM_FEATURE_TPM, &value))
+		return false;
+	algorithm = FIELD_GET(ARM_DRTM_TPM_ALG_MASK, value);
+	schemas = FIELD_GET(ARM_DRTM_PCR_SCHEMA_MASK, value);
+
+	if (!efi_drtm_hash_algorithm_supported(algorithm)) {
+		efi_err("DRTM: firmware hash algorithm 0x%x is unavailable (feature 0x%llx)\n",
+			algorithm, value);
+		return false;
+	}
+
+	if (!(schemas & BIT(ARM_DRTM_PCR_SCHEMA_DEFAULT))) {
+		efi_err("DRTM: default PCR schema is unavailable (feature 0x%llx)\n",
+			value);
+		return false;
+	}
+
+	efi_debug("DRTM: TPM algorithm 0x%x, TPM hashing %s, PCR schemas 0x%x\n",
+		  algorithm,
+		  value & ARM_DRTM_TPM_HASHING ? "available" : "unavailable",
+		  schemas);
+	return true;
+}
+
+static bool efi_drtm_probe_memory(void)
+{
+	u64 value;
+
+	if (!efi_drtm_query_feature(ARM_DRTM_FEATURE_MIN_MEMORY, &value))
+		return false;
+
+	drtm_cfg.dlme_data_size =
+		FIELD_GET(ARM_DRTM_DLME_DATA_PAGES_MASK, value) *
+		ARM_DRTM_PAGE_SIZE;
+	drtm_cfg.nw_dce_size = FIELD_GET(ARM_DRTM_NW_DCE_PAGES_MASK, value) *
+			       ARM_DRTM_PAGE_SIZE;
+
+	efi_debug("DRTM: minimum DLME data %lu bytes, Normal-world DCE %lu bytes\n",
+		  drtm_cfg.dlme_data_size, drtm_cfg.nw_dce_size);
+	return true;
+}
+
+static bool efi_drtm_probe_dma(void)
+{
+	u64 value;
+
+	if (!efi_drtm_query_feature(ARM_DRTM_FEATURE_DMA_PROTECTION, &value))
+		return false;
+
+	if (!(FIELD_GET(ARM_DRTM_DMA_PROTECTION_MASK, value) &
+	      BIT(ARM_DRTM_DMA_PROTECTION_COMPLETE))) {
+		efi_err("DRTM: complete DMA protection is unavailable (feature 0x%llx)\n",
+			value);
+		return false;
+	}
+	return true;
+}
+
+/* Sanity check nothing has gone wrong */
+static bool efi_drtm_probe_boot_pe(void)
+{
+	u64 current_pe = read_cpuid_mpidr() & MPIDR_HWID_BITMASK;
+	u64 boot_pe;
+
+	if (!efi_drtm_query_feature(ARM_DRTM_FEATURE_BOOT_PE, &boot_pe))
+		return false;
+
+	if ((boot_pe & MPIDR_HWID_BITMASK) != current_pe) {
+		efi_err("DRTM: boot PE 0x%llx does not match current PE 0x%llx\n",
+			boot_pe, current_pe);
+		return false;
+	}
+
+	return true;
+}
+
+static void efi_drtm_report_previous_error(void)
+{
+	s64 error_code;
+	s64 status;
+
+	status = arm_drtm_query_function(ARM_DRTM_SMC_GET_ERROR);
+	if (status != ARM_DRTM_SUCCESS) {
+		efi_debug("DRTM: GET_ERROR is unavailable (x0=%lld)\n", status);
+		return;
+	}
+
+	status = arm_drtm_get_error(&error_code);
+	if (status != ARM_DRTM_SUCCESS) {
+		efi_warn("DRTM: failed to read previous error (x0=%lld)\n",
+			 status);
+		return;
+	}
+
+	if (error_code) {
+		efi_warn("DRTM: firmware reports previous launch error 0x%llx\n",
+			 error_code);
+		if (efi_drtm_policy != EFI_DRTM_ENFORCE)
+			efi_drtm_policy = EFI_DRTM_OFF;
+	}
+}
+
+static efi_status_t efi_drtm_failure(void)
+{
+	if (efi_drtm_policy == EFI_DRTM_AUTO) {
+		efi_warn("DRTM: preparation failed, continuing without DRTM\n");
+		efi_drtm_policy = EFI_DRTM_OFF;
+		return EFI_SUCCESS;
+	}
+
+	efi_err("DRTM: enforced preparation failed\n");
+	return EFI_UNSUPPORTED;
+}
+
+efi_status_t efi_drtm_prepare(void)
+{
+	s64 feature_status;
+	u16 major, minor;
+	s32 status;
+
+	if (efi_drtm_policy == EFI_DRTM_OFF)
+		return EFI_SUCCESS;
+
+	if (!efi_arm64_smccc_1_1())
+		return efi_drtm_failure();
+
+	/*
+	 * v1.4B section 3.2.1 "DRTM_VERSION usage" explains that a new major
+	 * ABI version may "Change behavior of existing functions". Verify the
+	 * major version before calling anything so we don't trigger unknown
+	 * behavior.
+	 */
+	status = arm_drtm_version(&major, &minor);
+	if (status != ARM_DRTM_SUCCESS) {
+		efi_err("DRTM: failed to read interface version (x0=%d)\n",
+			status);
+		return efi_drtm_failure();
+	}
+	if (major != ARM_DRTM_VERSION_MAJOR) {
+		efi_err("DRTM: unsupported interface version %u.%u\n", major,
+			minor);
+		return efi_drtm_failure();
+	}
+	efi_info("DRTM: interface version %u.%u\n", major, minor);
+
+	efi_drtm_report_previous_error();
+	if (efi_drtm_policy == EFI_DRTM_OFF)
+		return EFI_SUCCESS;
+
+	feature_status = arm_drtm_query_function(ARM_DRTM_SMC_DYNAMIC_LAUNCH);
+	if (feature_status != ARM_DRTM_SUCCESS) {
+		efi_err("DRTM: dynamic launch is unavailable (x0=%lld)\n",
+			feature_status);
+		return efi_drtm_failure();
+	}
+
+	if (!efi_drtm_probe_tpm() || !efi_drtm_probe_memory() ||
+	    !efi_drtm_probe_dma() || !efi_drtm_probe_boot_pe())
+		return efi_drtm_failure();
+
+	drtm_cfg.launch_features =
+		ARM_DRTM_LAUNCH_HASH_FIRMWARE |
+		FIELD_PREP(ARM_DRTM_LAUNCH_PCR_SCHEMA_MASK,
+			   ARM_DRTM_PCR_SCHEMA_DEFAULT) |
+		FIELD_PREP(ARM_DRTM_LAUNCH_DMA_PROTECTION_MASK,
+			   ARM_DRTM_DMA_PROTECTION_COMPLETE) |
+		ARM_DRTM_LAUNCH_NO_AUTH | ARM_DRTM_LAUNCH_KEEP_SECURE_IRQS;
+
+	return EFI_SUCCESS;
+}
+
+unsigned long efi_drtm_get_extra_size(void)
+{
+	/*
+	 * See arch/arm64/kernel/vmlinux.lds.S for the DRTM Memory layout.
+	 *
+	 * v1.4B Table 6 "Return values for DRTM features", feature 0x2 reports
+	 * both minimum sizes in 4 KiB pages.
+	 *
+	 * The linker places the DLME data at the 4 KiB-aligned end of the
+	 * static Image as required by R314030 in Table 13 "DLME region
+	 * requirements".
+	 *
+	 * The DLME region must include all of that data (R45200 in Table 30
+	 * "DCE requirements for the DLME"), and an optional Normal-world DCE
+	 * follows it at another 4 KiB-aligned address as required by R312080 in
+	 * Table 10 "DRTM_PARAMETERS requirements".
+	 *
+	 * A final page holds the 4 KiB-aligned DRTM_PARAMETERS required by
+	 * R312010 in the same table. Only the first area is part of the DLME
+	 * region.
+	 */
+	if (efi_drtm_policy == EFI_DRTM_OFF)
+		return 0;
+	return drtm_cfg.dlme_data_size + drtm_cfg.nw_dce_size +
+	       ARM_DRTM_PAGE_SIZE;
+}
+
+efi_status_t efi_drtm_prepare_launch(const struct efi_image_info *image_info,
+				     unsigned long fdt_addr)
+{
+	struct arm64_drtm_handoff *handoff =
+		efistub_drtm_handoff(image_info);
+	struct arm_drtm_parameters *params;
+	unsigned long measured_offset;
+	unsigned long measured_size;
+	unsigned long image_base;
+	unsigned long image_size;
+	unsigned long dlme_start;
+	unsigned long dlme_end;
+	unsigned long dce_end;
+	unsigned long entry;
+
+	if (efi_drtm_policy == EFI_DRTM_OFF)
+		return EFI_SUCCESS;
+
+	image_base = efistub_kernel_base(image_info);
+	image_size = efistub_kernel_memsize(image_info);
+	measured_offset = efistub_drtm_measured_offset(image_info);
+	measured_size = efistub_drtm_measured_size(image_info);
+	entry = efistub_drtm_entry_offset(image_info);
+	dlme_start = image_base + image_size;
+	dlme_end = dlme_start + drtm_cfg.dlme_data_size;
+	dce_end = dlme_end + drtm_cfg.nw_dce_size;
+
+	/* Quick checks something didn't go wrong during image construction */
+	if (entry < measured_offset ||
+	    entry - measured_offset >= measured_size ||
+	    !IS_ALIGNED(image_base, ARM_DRTM_PAGE_SIZE) ||
+	    !IS_ALIGNED(image_size, ARM_DRTM_PAGE_SIZE) ||
+	    !IS_ALIGNED(measured_offset, ARM_DRTM_PAGE_SIZE) ||
+	    !IS_ALIGNED(dlme_start, ARM_DRTM_PAGE_SIZE) ||
+	    !IS_ALIGNED(dlme_end, ARM_DRTM_PAGE_SIZE) ||
+	    !IS_ALIGNED(dce_end, ARM_DRTM_PAGE_SIZE)) {
+		efi_err("DRTM: final Image layout is invalid\n");
+		return efi_drtm_failure();
+	}
+
+	/*
+	 * For robustness zero all the trailing space at the end of the
+	 * alocation. This contains the DRTM_PARAMETERS structure too, so
+	 * must be done before filling it.
+	 */
+	memset((void *)dlme_start, 0, efi_drtm_get_extra_size());
+	params = (void *)dce_end;
+	params->revision = cpu_to_le16(1);
+	/* PCR authorities, image authentication and secure IRQ disable need v2. */
+	if (drtm_cfg.launch_features &
+	    (ARM_DRTM_LAUNCH_PCR_SCHEMA_MASK | ARM_DRTM_LAUNCH_AUTH |
+	     ARM_DRTM_LAUNCH_DISABLE_SECURE_IRQS))
+		params->revision = cpu_to_le16(2);
+	params->launch_features = cpu_to_le32(drtm_cfg.launch_features);
+	params->dlme_region_address = cpu_to_le64(image_base);
+	params->dlme_region_size = cpu_to_le64(dlme_end - image_base);
+	params->dlme_image_start = cpu_to_le64(measured_offset);
+	params->dlme_entry_point_offset = cpu_to_le64(entry - measured_offset);
+	params->dlme_image_size = cpu_to_le64(measured_size);
+	params->dlme_data_offset = cpu_to_le64(image_size);
+	if (drtm_cfg.nw_dce_size) {
+		params->nw_dce_region_address = cpu_to_le64(dlme_end);
+		params->nw_dce_region_size = cpu_to_le64(drtm_cfg.nw_dce_size);
+	}
+
+	/*
+	 * The DLME Data contains its own size in a trusted header, so the
+	 * handoff doesn't need to include extra_size. The DCE Data is only
+	 * temporary so the kernel also does not need to know about it.
+	 */
+	handoff->fdt_addr = cpu_to_le64(fdt_addr);
+	handoff->drtm_enabled = 1;
+
+	efi_debug("DRTM: will launch, selected launch features 0x%x\n",
+		  drtm_cfg.launch_features);
+
+	drtm_cfg.params_addr = params;
+	drtm_cfg.handoff = handoff;
+	return EFI_SUCCESS;
+}
+
+static void efi_drtm_fallback(void)
+{
+	drtm_cfg.handoff->drtm_enabled = 0;
+}
+
+void efi_drtm_launch(void)
+{
+	if (efi_drtm_policy == EFI_DRTM_OFF)
+		return;
+
+	/*
+	 * No cache maintenance is required before the launch. v1.4B R42130 in
+	 * Table 22 "DCE preamble requirements" requires the DRTM_PARAMETERS to
+	 * be accessible as Normal Write-Back Cacheable, Inner Shareable memory,
+	 * so the DCE reads them coherently with the writes made above.  R45220
+	 * in Table 30 "DCE requirements for the DLME" then has the DCE clean
+	 * and invalidate the whole DLME region to the Point of Coherency before
+	 * it measures the DLME image, which covers both the Image itself and
+	 * the handoff struct placed in the DLME region. Thus once we jump into
+	 * the kernel with MMU and caches off the CPU will see everything the
+	 * stub wrote.
+	 */
+	arm_drtm_dynamic_launch(drtm_cfg.params_addr);
+
+	/*
+	 * v1.4B section 3.4 "DRTM_DYNAMIC_LAUNCH" says it returns from
+	 * DYNAMIC_LAUNCH only on error. Boot services and their diagnostics are
+	 * no longer available, so hang.
+	 */
+	if (efi_drtm_policy == EFI_DRTM_ENFORCE) {
+		for (;;)
+			asm volatile("wfe");
+	}
+
+	efi_drtm_fallback();
+}
-- 
2.43.0

