Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795197136;
	b=nxhcKAeGBiVLJS5nJgBVd3QQgjxOEOl8pkC/M0s8qZYRdI19f2xSv4wwhKYGuk4YnWsE
	 xlJFpxhZsW3FArqQeP+4hzIax/4jyG+iuY+mXynmZnF2bgAQQ1BDyQ4GM4m7Bn7HSjKqB
	 uIGEUoOPH3ZnnP5udVaBD+h95YkFtnP8FNyMB8NmalOcKieYyXp4fbeyuPS5quMTBfCLZ
	 yrxRDWF3n1qm/AzCl0jX5kLY/yiM9In6ggg5vmaMc+cAuaGeck/hwpauCntbszw/JLkGL
	 s9QDmpJ5olQvuzIFmMOGGL3HGm3tKUpFj3C7fv9I2yjvnPGjmLnYDjYkfngp7GFswpQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795197136;
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
	bh=Nn7kfqCB9pIznGEV0Zeheg4GgiwKrk5E/nEKF/NdviA=;
	b=24AprAqtEs6zJtFB0KKVT2pc/YpvDvoAI5n8iWOIz8PyPPT0OCPjk4nht7ad00EmrBBX
	 uLzLKzSFbakfiO83VBJSIUPs9zrl0cKKncnwOr+ktv5gip3LmWBV/J2Ud0yTTlQHetD8Q
	 oOAQLxdoQrUdBqawUTlmZzwBvOIr6duK9k6yhurh5YHmgDG1ukSWyug7ZGOpBYTxZCquO
	 TWXytSXYPE33uz9KowRbPuZjqnIHd7ztLi5i+yozIAGoYGw+eUPTbrHMew5gZ0+R3yafQ
	 C+DpZb+R1LxnF1XDUqTfzzTd4T3i7ALCSeLOJ7YAwpOag9NRRstRE8snBbwMJ7p17dQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=LfAKGZvJ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.28
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011028.outbound.protection.outlook.com [40.93.194.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643B3606A33E;
	Fri, 20 Nov 2026 17:52:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 643B3606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=LfAKGZvJ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RO/1L4CCmMKSmrueJBGxUIw8pB1wfSX3RbVqVPm9KlXtr9lEsJs46GxOqWT6PisFbrbscpvul3uixabG/4HinMhOhqNZnSAAvgXBb+OaM3OUFB0jakGUvtB1FlvRw8jgzLyqb2QUca+73kaOkbsowroWYPaPm//bZahs2w6Ws2V3SqmocSqN6qWdSU7YvV4Io/6dIKdfE7vK6ymfJt2bsrc8P4Fhw73BXXKiJ6kUt5O8NiKm1IOaL89dm1mRnhpMbWD5o3EPj2YRPq1CrHXtFlvV3ThONSAb9bWY1LzqmTNl6djY0/kWzg8brT5oQWSUdQIw0rAgu5TUqx35kE72mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nn7kfqCB9pIznGEV0Zeheg4GgiwKrk5E/nEKF/NdviA=;
 b=O+aG9kRgDJq3x9B7Tobm0yAFarxppYonmz47m73sQRUsylnN9p/dxqCREIojoDEVwkgAjx2h5D3KQJX0qoZufbcAEz1Rhf5097sVhUYK5e405v5kJtAyRomdlSbo5r736SdH759idsR0pDiKbxtK0LZaf6taPixg5ii67UBCkZn0cKiGsLYm5J93dwy7PQHjg6hNtRKGN7iDM5cC5L2vMvl4Wmis92cMEccbG5a8zJaXdJyUXgsn96JYK+8xmJ/YwqSP1S4bIdeHwtTk7kCp9BAJZYnkc0Txu4b91ES22WXMGyPErXka/T89GMP/eDWneY+owwuo9JF7kEgDof+CtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nn7kfqCB9pIznGEV0Zeheg4GgiwKrk5E/nEKF/NdviA=;
 b=LfAKGZvJhy4pnYSTIu5jL21lbYAaRgr2u4vahuCcIqCnoA61CkaJRmffNIiF+9cfLJWB2/qMwoC8JzyJi96FmAcVLyWd8KBlHCgqVihchh8nrWNCnyW7M9JiNuaqkBwJ6SvyxydUrYxvH3EQ+haq+FnbQPud2tCtONRfONh/8w6mjiZudyAZbH1MDdYxNUMfU4zu/lRwg73yUdd0nA/3nVzxtoczxERcH4DfRjCQ558MXVyp22saBTXLsL/mqdC3zPAyyClobft1Hz2b2quXE0Yy0Li7QbxkFQ5Tj/sYGUTDeKCrdWcCpmogCpMYoypVOHP83lkql9AFVHdGJBLn6g==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by IA1PR12MB6329.namprd12.prod.outlook.com
 (2603:10b6:208:3e5::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Fri, 20 Nov
 2026 17:52:07 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0639.010; Fri, 20 Nov 2026
 17:52:07 +0000
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
Subject: [PATCH v3 01/11] efi/libstub: Add generic arch callbacks for DRTM
Date: Fri, 20 Nov 2026 13:51:54 -0400
Message-ID: <1-v3-22d1a1eb7d2e+17de-arm64_drtm_jgg@nvidia.com>
In-Reply-To: <0-v3-22d1a1eb7d2e+17de-arm64_drtm_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: IA1P220CA0004.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:461::10) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: aca2aa29-88eb-4fba-b7b5-08df472efdd2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|18002099003|6133799003|22082099003|261009223027099003|3023799007|11063799006|261022115727099003|56012099006|921020|261102123227099003|261028144727099003|261026140227099003|261026121527099003|261021121427099003|261021123027099003|261022105027099003|261022075727099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	jJeowo0qM17S2fZAQHJBCEBQLlW9dPFBHk5PS+M5JE9lEl+3Ef3Bx1qPw6vEaIe86dUHlXw67HFpzljUXe6cLSanhawKD7n+G8obDTMnS0gkS8zBKcLUPBaqIUgTpppwCkuFWb8/TERyAaEsmXPoOM7Y0tTWSa7XGPZ4pSyQebRAqM0SoPRrmBYEnheP4C2rxEcSznUTD6D4xKLqqPje0ewff0+GRV3OlUxznwopH4jY0l++qvrLIcy1JbNO9ML/5LDM8oGxnMybAplYa02MusiYyY6odUAm4zJb98O1oXy3OVh6kCBs7GPssNTNHpFfKxd/n1p4n2RuySWuST929SODh6V3CXdMThQFxBcb/Z24Jah+URXas1Og8gr4lZuf+jN0dRbUvtlAQx4MtEDTQc1DLTEhf5rgCgOUq4MbyezWbQkbJ11H+5LpM2oPTKSyz+coug92QK78S8+wUfO/LF7ak+iw+Tg9f3agg7qQ0wNCtF3cdYdFJCMDYJ3C1D92tzLDmiwYtAruyZNrBXdPMq2Jo8d0+DUGCsfqoX0mFV7GXWeCHr+y2AAqMDPzdTT2IvMZG+GJY6HsYxeOhTQzIrhZyt5FONvEdDXm00iSux0GT9F22SYb78oi2LxM0vwTYlescdmZCrIyA5KcREEW0wD6MDT6A8Z4/3Ia6LpSL2Wfc8EEFRDcLRNd9JcZXgnvt+/HlnSkbJ+tL1I1jInr0A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(18002099003)(6133799003)(22082099003)(261009223027099003)(3023799007)(11063799006)(261022115727099003)(56012099006)(921020)(261102123227099003)(261028144727099003)(261026140227099003)(261026121527099003)(261021121427099003)(261021123027099003)(261022105027099003)(261022075727099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SUdvt9YGYuqH1jicc4ifXi3ZaPlIcuMMmFID/iY8rCewLdqrheO+KAayjRtS?=
 =?us-ascii?Q?H3Ru459GBH+RvcBzbpjI4tYuTuwXZMNUuecjRY+1ub+yTEPViFSbpcpJCN4H?=
 =?us-ascii?Q?NC++R8hP3o9FssVvPeXzjtVjJcmWOjtzy52yftDmFmWj/R/RmuAwgxKALcAN?=
 =?us-ascii?Q?/jxXz3Q+Ed3Kv1WiPN8AbiYbOO/86gj8mVPfFSfMDZ25+2ttrVl08DZ08IOS?=
 =?us-ascii?Q?LFLApNK5KgKkA/YMhoNEI5j8X++rqQwwXwdyQoNu1+jGxrcgJdjQVeCJ6Drd?=
 =?us-ascii?Q?3Sj0386GAi2D3cdJFN2eeJnEAdMnWaxwc23NchGFm+FqcvtG4iEf1quZlHsA?=
 =?us-ascii?Q?ovZ5nu0c4pcDWexSS94gLfxbfPdfVKsd5JVZs7k/2IYTDo3PWxVLxq8UNpkD?=
 =?us-ascii?Q?2TckiSPlgItJNxHQJ1rJzCmtNU2Zv/8f0NK1tJekB+64zh6E3yrjPntJbuKr?=
 =?us-ascii?Q?WuLAKOXUz/R5LyAMgRLbp6kzD4L6OQH68NZUs+0jIwwc5N0hGpREaTNctuG5?=
 =?us-ascii?Q?ZBXXp5pLK9ykYD4I50RV+cpxRwk/iRgUzC1YUp2kTCUE1L/Qh0EIC2ULUu63?=
 =?us-ascii?Q?rKzP/uLym4rKjKszB7CTK/svrV4rQP5lEEUxZxJKmo3DFjNbsdycu0MwehQj?=
 =?us-ascii?Q?jV+WV+oxeHHUQSWbXCYY9EDCzWsSigijUdQEGVy1ceI9tLhys9bpPOPQcM+6?=
 =?us-ascii?Q?SLwyBJX7ccx0kS70C3tHFBkc6zeVwWBmyckDAJwvjpuIFckacCZRrEcDoS1f?=
 =?us-ascii?Q?tNKjTjirNhPvbkKvbskp5joKf0DXDSAgBB6adXZlvrytxq2epu39fHZ/AzC7?=
 =?us-ascii?Q?tIgirSrBPq3bQ9Y3paofPAFBUO3zqyh1WwWD9lu0uD/COdJ2WQS4KAYbu40S?=
 =?us-ascii?Q?tfwmAvRrVcoE/R6+HSqB+/39NgBGawvsabi7m4BMZ4p2LlYjRuLby3u+4dAD?=
 =?us-ascii?Q?4uCamNI0SVLWcVtFLMaN/6pmXEZL1d8ZO8uDJGFE2eXSHitmeBZYZXwGacvh?=
 =?us-ascii?Q?ItNSo5t36rqd/MX7Ct9bbqxLPkjxNp0QOyrhKb/aVT94VL6fQe/LW6oJP4v+?=
 =?us-ascii?Q?iyJbaKSDu2/D5XgeIlbnGebjwboH+LRuc8sq2AHG0lJtmACP4RiTRywMiOCk?=
 =?us-ascii?Q?iZhbLbtEV1zfgXJXJfkZZBaraRkiPqcQQOx825If0W3JD/f9H4o0lmF7llmc?=
 =?us-ascii?Q?7J3iUWkKAtRJhUtCi5DAqSvMuWlzl0NuCJ0goPHIPrD/WRTavZTGQAziUyxj?=
 =?us-ascii?Q?5aupNQUtosIN649A6hk4Cw364k/Gq3CidwjU1G47UZ+uGalwIvikXVTfmshh?=
 =?us-ascii?Q?yA1IkE9Dj08xPC8a/JfD7IslhbrZyokTq0l8l+PMrRbqtaGQb/I3jlVwhZgU?=
 =?us-ascii?Q?o1GPaEClw6rtB1Dq7c+LilAApkoyNfcv1oSJRadsIYuRACj8ejgznIyP1v8B?=
 =?us-ascii?Q?kQJLrWBqC8DJqlHDEbvKgBOPu3ajcIH4FGck4m6zAL3fXtWJbuMF3eCbGJvy?=
 =?us-ascii?Q?8e8FrGQQVkNE3X6aFmKVoI0UgN1hHqehAFwz+WL2NoL4+A+AmoHku8mq8FEa?=
 =?us-ascii?Q?dI/9Kko8gEqYYdu1AGctjuhbNt8izFR3Ve4Uvsh3icjLqxERnLfsBo/hqRjw?=
 =?us-ascii?Q?cAVaoj7uimFvGrBtYuV8/LPIQTCY18HoXSkYGyRiNRezEIW+vBmRzW7EH1iW?=
 =?us-ascii?Q?0ilAxwFSAZyBI62wT0bfN/NaFtt6UakqHu7j6T2eAja+5Deo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aca2aa29-88eb-4fba-b7b5-08df472efdd2
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 17:52:06.5165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vu23uNy4VP6X88oqW06w9SnCsj+4m/2cJWXTxyCEvLL1xdQzSrDor4oOeD6551AF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6329

If the architecture supports an EFI stub launched version of DRTM, it
can select the kconfig and provide the hooks under its architecture
build.

Have the common code parse a drtm=enforce|auto|off kernel command line
parameter to set the boot behavior. Support commas in the args list since
there will be more options here down the road.

efi_drtm_prepare() is called before doing any decompression or image
relocation. It should figure out if DRTM is supported, policy-permitted,
and how much memory efi_drtm_get_extra_size() should return.

The image handling is revised to allocate extra_size at the end of
the normal image. The architecture can use this to store any
information needed for the DRTM flow. It is always contiguous with
Image, which is a requirement of ARM's specification.

efi_drtm_prepare_launch() is called while still in EFI boot services after
Image is fully prepared in its final location.

efi_drtm_launch() is called after exiting boot services and must
jump into the kernel through the DRTM flow. If it returns, then the
normal launch is tried (auto mode).

The extra_size is allocated directly after the Image. Handle the
trivial zboot flow now, and vmlinux in the following patch.

Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../admin-guide/kernel-parameters.txt         | 12 ++++++
 drivers/firmware/efi/Kconfig                  | 30 ++++++++++++++
 drivers/firmware/efi/libstub/efi-stub-entry.c |  4 ++
 .../firmware/efi/libstub/efi-stub-helper.c    | 34 ++++++++++++++++
 drivers/firmware/efi/libstub/efistub.h        | 39 +++++++++++++++++++
 drivers/firmware/efi/libstub/fdt.c            |  8 +++-
 drivers/firmware/efi/libstub/zboot.c          | 15 ++++---
 7 files changed, 136 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 0b3c140babd944..4c95e36dd8c94b 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1377,6 +1377,18 @@ Kernel parameters
 			data set with no connector name will be used for
 			any connectors not explicitly specified.
 
+	drtm=		[EFI,EARLY]
+			Format: { "off" | "auto" | "enforce" }
+			Control the EFI stub Dynamic Root of Trust for
+			Measurement (DRTM) launch policy.
+			off: do not attempt a DRTM launch.
+			auto: attempt a DRTM launch when supported, but fall
+			back to a normal boot if preparation or launch fails.
+			enforce: require a DRTM launch and refuse to fall back
+			to a normal boot if preparation or launch fails.
+			The default is selected by the EFI_STUB_DRTM_DEFAULT_*
+			configuration options.
+
 	dscc4.setup=	[NET]
 
 	dt_cpu_ftrs=	[PPC,EARLY]
diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 29e0729299f5bd..6806bcd6a52420 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -72,6 +72,36 @@ config EFI_RUNTIME_WRAPPERS
 config EFI_GENERIC_STUB
 	bool
 
+config EFI_STUB_DRTM
+	bool
+
+choice
+	prompt "Default DRTM launch policy"
+	depends on EFI_STUB_DRTM
+	default EFI_STUB_DRTM_DEFAULT_OFF
+	help
+	  Select the DRTM policy used when no drtm= option is present on the
+	  kernel command line. The command-line option overrides this default.
+
+config EFI_STUB_DRTM_DEFAULT_OFF
+	bool "Off"
+	help
+	  Do not attempt a DRTM launch unless it is requested explicitly.
+
+config EFI_STUB_DRTM_DEFAULT_AUTO
+	bool "Automatic with fallback"
+	help
+	  Attempt a DRTM launch when the firmware supports it, but fall back to
+	  normal boot if preparation or a returnable launch attempt fails.
+
+config EFI_STUB_DRTM_DEFAULT_ENFORCE
+	bool "Enforce"
+	help
+	  Require a DRTM launch and refuse normal-boot fallback if preparation
+	  or a returnable launch attempt fails.
+
+endchoice
+
 config EFI_ZBOOT
 	bool "Enable the generic EFI decompressor"
 	depends on EFI_GENERIC_STUB && !ARM
diff --git a/drivers/firmware/efi/libstub/efi-stub-entry.c b/drivers/firmware/efi/libstub/efi-stub-entry.c
index dcf4442a16b078..fd272d07737371 100644
--- a/drivers/firmware/efi/libstub/efi-stub-entry.c
+++ b/drivers/firmware/efi/libstub/efi-stub-entry.c
@@ -47,6 +47,10 @@ efi_status_t __efiapi efi_pe_entry(efi_handle_t handle,
 	if (status != EFI_SUCCESS)
 		return status;
 
+	status = efi_drtm_prepare();
+	if (status != EFI_SUCCESS)
+		return status;
+
 	efi_info("Booting Linux Kernel...\n");
 
 	status = handle_kernel_image(&image_addr, &image_size,
diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index e50deec9968658..2840b589653fe8 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -28,6 +28,37 @@ static bool efi_disable_pci_dma = IS_ENABLED(CONFIG_EFI_DISABLE_PCI_DMA);
 
 int efi_mem_encrypt;
 
+#ifdef CONFIG_EFI_STUB_DRTM
+enum efi_drtm_policy efi_drtm_policy =
+	IS_ENABLED(CONFIG_EFI_STUB_DRTM_DEFAULT_ENFORCE) ? EFI_DRTM_ENFORCE :
+	IS_ENABLED(CONFIG_EFI_STUB_DRTM_DEFAULT_AUTO) ? EFI_DRTM_AUTO :
+	EFI_DRTM_OFF;
+
+static void efi_drtm_parse_options(char *options)
+{
+	char *keyword;
+
+	while (options) {
+		keyword = options;
+		while (*options && *options != ',')
+			options++;
+		if (*options)
+			*options++ = '\0';
+		else
+			options = NULL;
+
+		if (!strcmp(keyword, "off"))
+			efi_drtm_policy = EFI_DRTM_OFF;
+		else if (!strcmp(keyword, "auto"))
+			efi_drtm_policy = EFI_DRTM_AUTO;
+		else if (!strcmp(keyword, "enforce"))
+			efi_drtm_policy = EFI_DRTM_ENFORCE;
+	}
+}
+#else
+static void efi_drtm_parse_options(char *options) {}
+#endif
+
 bool __pure __efi_soft_reserve_enabled(void)
 {
 	return !efi_nosoftreserve;
@@ -90,6 +121,9 @@ efi_status_t efi_parse_options(char const *cmdline)
 				efi_mem_encrypt = 1;
 			else if (parse_option_str(val, "off"))
 				efi_mem_encrypt = -1;
+		} else if (IS_ENABLED(CONFIG_EFI_STUB_DRTM) &&
+			   !strcmp(param, "drtm") && val) {
+			efi_drtm_parse_options(val);
 		} else if (!strcmp(param, "efi") && val) {
 			efi_nochunk = parse_option_str(val, "nochunk");
 			efi_novamap |= parse_option_str(val, "novamap");
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index df3f88f4786b82..80b9558f9f689a 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -1077,6 +1077,45 @@ efi_status_t check_platform_features(void);
 
 void *get_efi_config_table(efi_guid_t guid);
 
+struct efi_image_info;
+
+enum efi_drtm_policy {
+	EFI_DRTM_OFF,
+	EFI_DRTM_AUTO,
+	EFI_DRTM_ENFORCE,
+};
+
+#ifdef CONFIG_EFI_STUB_DRTM
+extern enum efi_drtm_policy efi_drtm_policy;
+efi_status_t efi_drtm_prepare(void);
+unsigned long efi_drtm_get_extra_size(void);
+efi_status_t efi_drtm_prepare_launch(const struct efi_image_info *image_info,
+				     unsigned long fdt_addr);
+void efi_drtm_launch(void);
+#else
+enum {efi_drtm_policy = EFI_DRTM_OFF};
+static inline efi_status_t efi_drtm_prepare(void)
+{
+	return EFI_SUCCESS;
+}
+
+static inline unsigned long efi_drtm_get_extra_size(void)
+{
+	return 0;
+}
+
+static inline efi_status_t
+efi_drtm_prepare_launch(const struct efi_image_info *image_info,
+			unsigned long fdt_addr)
+{
+	return EFI_SUCCESS;
+}
+
+static inline void efi_drtm_launch(void)
+{
+}
+#endif
+
 void efi_char16_puts(efi_char16_t *);
 
 int efi_vsnprintf(efi_char16_t *buf, size_t size, const char *fmt, va_list ap,
diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index 09e9e5bc831e8b..d39455d38a911a 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -223,6 +223,7 @@ static
 efi_status_t allocate_new_fdt_and_exit_boot(void *handle,
 					    efi_loaded_image_t *image,
 					    unsigned long *new_fdt_addr,
+					    const struct efi_image_info *image_info,
 					    char *cmdline_ptr)
 {
 	unsigned long desc_size;
@@ -289,6 +290,10 @@ efi_status_t allocate_new_fdt_and_exit_boot(void *handle,
 		goto fail_free_new_fdt;
 	}
 
+	status = efi_drtm_prepare_launch(image_info, *new_fdt_addr);
+	if (status != EFI_SUCCESS)
+		goto fail_free_new_fdt;
+
 	priv.new_fdt_addr = (void *)*new_fdt_addr;
 
 	status = efi_exit_boot_services(handle, &priv, exit_boot_func);
@@ -351,7 +356,7 @@ efi_status_t efi_boot_kernel(void *handle, efi_loaded_image_t *image,
 	efi_status_t status;
 
 	status = allocate_new_fdt_and_exit_boot(handle, image, &fdt_addr,
-						cmdline_ptr);
+						image_info, cmdline_ptr);
 	if (status != EFI_SUCCESS) {
 		efi_err("Failed to update FDT and exit boot services\n");
 		return status;
@@ -360,6 +365,7 @@ efi_status_t efi_boot_kernel(void *handle, efi_loaded_image_t *image,
 	if (IS_ENABLED(CONFIG_ARM))
 		efi_handle_post_ebs_state();
 
+	efi_drtm_launch();
 	efi_enter_kernel(image_info, fdt_addr, fdt_totalsize((void *)fdt_addr));
 	/* not reached */
 }
diff --git a/drivers/firmware/efi/libstub/zboot.c b/drivers/firmware/efi/libstub/zboot.c
index 4089a29068caae..69962a8f094caf 100644
--- a/drivers/firmware/efi/libstub/zboot.c
+++ b/drivers/firmware/efi/libstub/zboot.c
@@ -50,7 +50,7 @@ efi_zboot_entry(efi_handle_t handle, efi_system_table_t *systab)
 {
 	static efi_guid_t loaded_image_guid = LOADED_IMAGE_PROTOCOL_GUID;
 	char *cmdline_ptr __free(efi_pool) = NULL;
-	unsigned long image_base, alloc_size;
+	unsigned long image_base, image_size, alloc_size;
 	efi_loaded_image_t *image;
 	efi_status_t status;
 
@@ -67,12 +67,17 @@ efi_zboot_entry(efi_handle_t handle, efi_system_table_t *systab)
 	if (status != EFI_SUCCESS)
 		return status;
 
-	efi_info("Decompressing Linux Kernel...\n");
-
-	status = efi_zboot_decompress_init(&alloc_size);
+	status = efi_drtm_prepare();
 	if (status != EFI_SUCCESS)
 		return status;
 
+	efi_info("Decompressing Linux Kernel...\n");
+
+	status = efi_zboot_decompress_init(&image_size);
+	if (status != EFI_SUCCESS)
+		return status;
+	alloc_size = image_size + efi_drtm_get_extra_size();
+
 	 // If the architecture has a preferred address for the image,
 	 // try that first.
 	image_base = alloc_preferred_address(alloc_size);
@@ -107,7 +112,7 @@ efi_zboot_entry(efi_handle_t handle, efi_system_table_t *systab)
 	}
 
 	// Decompress the payload into the newly allocated buffer
-	status = efi_zboot_decompress((void *)image_base, alloc_size);
+	status = efi_zboot_decompress((void *)image_base, image_size);
 	if (status != EFI_SUCCESS)
 		goto error;
 
-- 
2.43.0

