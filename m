Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795197145;
	b=DdJg1O4fIC9kSAMAM3VxhuhHPe443GkWyT7cxSUUUFywn4XsvW8ed5r38qXVKFpkzduG
	 Lpf3/XM9/r/qj2U1vz1gjsvIUhEt+2MiC59hePnKRTv9e706yrAfBNgUmHhwuHHP1aA4Z
	 e/V94/F8WFSk5mbH0G345zeH2BxdcTIKcdwwRr+gBLpfoiX+1TthEz4/18nxcumSUHEvU
	 TznZgK0i8ZpGADs6wJFCPFPSd/JJwY5YvH+2r3XopznSz+bwv31ygCa3XYBvL5ZOkAUrf
	 61lpwQhZZQQsWFk9eCX5eNwUhjmWdbN2wycaCTkADxgWM/94xBE70aalD4AcnmZGKMw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795197145;
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
	bh=FAPTTXKUz+0O/TqZ4vjLdHytqGfRBpIZI/ZDDRs8aC8=;
	b=nrhVvtTZ/zWSjyfPayc7E4sEYxNvQSAKGZkPhYk9ed6xyhdwxGwnFeGhHmpY3wK4pomo
	 UjdSM3K9oAiuL4PZ+FBfbeS7gT3Eg9PN/7OPfQ0yv4wC4OF+CCT7ZYm343aNbNivbXnbF
	 GgVwOlKH1Sl9tNbQW3KW5+YZsYtBp5GbxsBOnxrZ3zuw6AZIRZI7ZzFc1uCZBqDjxhNWm
	 uJjeZU+12jywU7XotJPwsEaGEJGz9efGXOazxCLLT54opPuBRT+DZHqfQw8vgQC+o/pfw
	 Upf17hlGNNcM8xuxHRVZg+XUOHmRSN4n9/uLNZKqysOq5fvaakO14G8adnXGA24wb+w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=RFO0C3vQ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.28
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011028.outbound.protection.outlook.com [40.93.194.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3AC60A2609;
	Fri, 20 Nov 2026 17:52:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD3AC60A2609
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=RFO0C3vQ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wQySA+qlyT4MjN1TNgQtqyxOhPXWtqU7WI7onhj/2aPKsBVcBMQB3LYfddmwd/vLP9yTeneXOgE2/0ybGTQmHVZQJuSutl/KB0q6E/5bOdQZvEyVk01B+3BxrIhUUexU6n8pzK2TTmRXzTvyznTHsKM6B31bdSwwAps/+zPIo1tb48oCKBDuY3WebUGP33TF3562bVvY/ILplCuasSd3VDutlyJYwk9wKRPdeCKygSMhzh5Je6mWcUpI2ELfPnDvpHZU11dRnQ2/2V6Wfio1qbudkOSBqvAzFBcPiQ6FCdIQTwuGyjMKiG07nHtgMeIydDCB8FiZNlmUMTE/s1RC7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FAPTTXKUz+0O/TqZ4vjLdHytqGfRBpIZI/ZDDRs8aC8=;
 b=cxvn1gzBZc8KpofFRCnYZlTz83Q/7SG4isV4WBbHbGItmvnB4dBUnP1hViG7v2kHWfl1Dqx/voZ391b/+Mvn8vAlysu6RTCh6iCMPLFNzUXM8+RJNx1qPTPtw+dl/4Bz/8kCujWFSC1xSPC/LtKVppSkeiVa3sLW4ddKO+T5+k2aiAYcmPTSIDI8ZGjiZ1vYaZOV8oo9HPY3L1MtKBLcDDkkuOEwjTNJVJ3zeN1hKlKsdQpz4qTdfToO7TxMahVxqx4RKx9c7howD39UwNp9YcATxUj5CrblARyyPLmrk1BEcz818BYQNRy/QpmK/bH5TAjrZRFoam+F6qqVWWNgyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FAPTTXKUz+0O/TqZ4vjLdHytqGfRBpIZI/ZDDRs8aC8=;
 b=RFO0C3vQd+DdKT68I4ky3cQqYuFZoIBCzIfVBmKKETHugc2R7brrbwNvvM047VsVeoP4D3zb7Rp3B63j8hxvQaBBttBOdIR7WaI+PqSXasS0tWh+IqDI6IZ+vCuZGEHg8tt/VqTwH9u49/1lhAIUNpM3LkligFsgyiowFMxDVIO+F1y456deUjPR5JpxN0NiHjbSkS2i3pw8v7X3iFLuVryWLlK9j0qPrzkommdT5ZMSQ2oZ9fTAxo+NYiDd0Sjxg3FHEAwEcyGbR1KXiKJfHFI1FdG7W4k2GYfwTSvcpEzzYOYvxLVEqkPShxleqb7Pns357LgLqMALzx4F1gt2lQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by IA1PR12MB6329.namprd12.prod.outlook.com
 (2603:10b6:208:3e5::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Fri, 20 Nov
 2026 17:52:13 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0639.010; Fri, 20 Nov 2026
 17:52:13 +0000
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
Subject: [PATCH v3 03/11] efi/libstub: Have efi_kaslr_relocate_kernel() handle extra_size
Date: Fri, 20 Nov 2026 13:51:56 -0400
Message-ID: <3-v3-22d1a1eb7d2e+17de-arm64_drtm_jgg@nvidia.com>
In-Reply-To: <0-v3-22d1a1eb7d2e+17de-arm64_drtm_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAP220CA0029.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::34) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 7811cfb9-70cd-410b-1917-08df472efeb3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|18002099003|6133799003|22082099003|261009223027099003|11063799006|5023799004|261022115727099003|56012099006|921020|261026135527099003|261102123227099003|261028144727099003|261026140227099003|261021133027099003|261026121527099003|261022113327099003|261021121427099003|261021123027099003|261022105027099003|261022075727099003|261026130827099003|261021130227099003|261021135927099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	ZyBiNzP+m2npuiwnjZBBLXqcQnVE9m9RJZcZ+QMX874kklaEXmti7eyKW9jfT6Hcq2oIExjRd+vkPYZoBiEBgQvQ1ABMak93xPln6R95mt4KN/CfVsqvFrWvGyjcOaM+JkaH5E4Q9OfiDsZQ6KhgG5sk0yRFoHlt1Re11jbo7awi3vSc5DueH8MiLrNYnCH1XVaXZ7Y9ol2mMfxASI2jkdh6UIu3UkvPkMyTiIkJjPxBgApIIWyOcXbX3ctHHKxHVe6W4GvncGFX7L3e+tfzLlcFLWWHFqpWyiGirFlSZfVD1KnjoxTL3D91OFK+gEqiFSnrHf/jsXuGAW50Zs/fcvJ3tCaYMsgSOUGIcFUG1JVao68WhuCK2/1N1ivVZ2rSNB5th0cRbjbKHZ0m8ruktnTrR8MrHvNXbbJRmf7munIybDC4UYcmTJ2py/ZJmdwvJTBdHVncXJyjsfi6wJcWzNNh1/vzfao5grcEB8Ea3A+3Z3qFQiJv4G+wl4VshDRK0i+kXh0xuguuk20dPF9Vlx4SsCGjnRov6OZk7eiIq+npf0+s99fkfpN7SBa2BLExhVuBuvJfQJk7G9ds1S5k+ioiZkkUU6ba5xqiqnai84X2X9hun37YkF4mGGjC9bAxKJfVY0ImyKC0TlQqCSV9/8ui/NWSZP2DSsRPB1OB03W40k4Hee3qGTdaiLLCWNqVxkYaDbekmwuLn7fSmxEqYA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(18002099003)(6133799003)(22082099003)(261009223027099003)(11063799006)(5023799004)(261022115727099003)(56012099006)(921020)(261026135527099003)(261102123227099003)(261028144727099003)(261026140227099003)(261021133027099003)(261026121527099003)(261022113327099003)(261021121427099003)(261021123027099003)(261022105027099003)(261022075727099003)(261026130827099003)(261021130227099003)(261021135927099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PNUKdKw+K3972jG4HUAGCjQMMgS1LUYyBbEwJFpfA8+Yb3s4UyUhj3mqEyhZ?=
 =?us-ascii?Q?0mV8IDMheYOeywc9h97f05P/r2aOINn4s/1WoKtL391PHnZahFnJuTvlVZCr?=
 =?us-ascii?Q?3fvY5vvOnhmmnZmDfaphvZyZlRN5Tfxt14fxJDt20GayLzHBgfMtkCqkyTkd?=
 =?us-ascii?Q?/skry78eiRGHuZVVqHqaX4k4d0kheDybNYHziDTNUsNVe9+iqMBDBCGi0fFa?=
 =?us-ascii?Q?0rrv3MLMQBK1HbhcqbvARskh6niKWEHMGBQBUhNV8GfFI8OuytrJ0ofsXmJP?=
 =?us-ascii?Q?Sih2UMuugForVM3Y+r/xx+uEEabvAiSvB4arkGEJg3psSUN3Q0wjqwIsRUFl?=
 =?us-ascii?Q?MiQKiH4+9Sg66PFsRCfsU4JH0jrKqUSkb7b8+iUpHvmAQ/m1yyZgmzmCgpqQ?=
 =?us-ascii?Q?Fv6szj6cTguZW1oZGmN4RO1DTS9uV8pympXV7HFrS0ICFNh72FPQezaToXNG?=
 =?us-ascii?Q?PwFj4CHgZDF1mO3zXTOMyCX5cFFfhKwoTdsunPFAU8U8ZW+GHDaYOpysEgU7?=
 =?us-ascii?Q?RPIXYJveAH9mLDQfDS8kYTgDttpicdnsFZNqo9Qzo/CR3Z8+lykZLbSierfM?=
 =?us-ascii?Q?+TmPy3+Lg+z4GNAhA2jdU+QJ7DZfGI1NDSU+2Gjd7RCjqcZXH1nwNBo5q1gE?=
 =?us-ascii?Q?onGl4eEmOUGEITWiXLEea1jpIxSgIaGQpX9ckD9/HiEgH27ic7QEnIFR+QXU?=
 =?us-ascii?Q?ICoC6MzYCpAI/W3Mwnn2g7kz3pzBxNrq7VYMDIdDUP/jn8jAqxSgc4Y9/Nh+?=
 =?us-ascii?Q?RFCWwiS0IJ/mZw1vjRuwESRLOtTLPk89Ox+xvtFcUDA8+T+4x63bNnZL3vK1?=
 =?us-ascii?Q?GN/BdGN+OiMksuNZNojMDF/ydbR7OcxZnR2Af3zuTD+KPV39yYE8+gaC9e2/?=
 =?us-ascii?Q?tPuN5t7x0+4NEnW+4MDaV03WC13KYlHLyfjWqQt1BiuCdmKytQnXhG4SWbjO?=
 =?us-ascii?Q?LpX26kY0c98oHFzANwcNwo7J8njv9I9sr4mYFFJZIR9LuFYnbw5Ul9KSK1g+?=
 =?us-ascii?Q?ADJJ6nu0eIvRilto+O0E3/eGi6Uzu78mBG8rdxFdeUozV+xI7Zj1iEuq5cP5?=
 =?us-ascii?Q?grys34M2uLh8CW+cDjhf9qjfe+bIYdt7XTbt0cc6rNimJG+xtISRpfJmuMit?=
 =?us-ascii?Q?AKDp4jdqrfZh285keqrWKV/HPstffvUT+3LUnKeQFUis4NM715Bt61TPm1wf?=
 =?us-ascii?Q?4/mi6hjHfJgnOfAIbE7VzZeOglEBOPnFrtEvowOfjeBnpUViQOoNJrUFHmGr?=
 =?us-ascii?Q?B21QwwvvDWroKQwpyMo32TnPZ55t6DhhK8DYHr/YFMVZfSsvhHRMkOPxFv3v?=
 =?us-ascii?Q?g0F3hoYxgq1Vn5ocGwTzbcPxQub1ot2jbqpMKne5OR62xnmgrpyjVx9meSFv?=
 =?us-ascii?Q?cZMmxK3VIVWfE+wjarE7pWCvJ4iIuq6M6fmcVvLV6T9aZHhj1tWEMvv44N6Y?=
 =?us-ascii?Q?X+TpZ7v5r0ISQXN5RbipS3GBKzUIxirDVagHexs51psQMmfYqNJVkIoEHcU7?=
 =?us-ascii?Q?e90tEMWBkkKWCKa5h59djMSL64/2thY+QvwtzkMXOmzr80ap+P9W9Bw32aEr?=
 =?us-ascii?Q?knZzkeLKYtIBmi3OlLlULBvj2nIrYftYJTFmFoxc3ERVX8/xKZK9CI1wzq+C?=
 =?us-ascii?Q?46ljg9JQ1Frjtaz56s/G0yxSwu97wtAmbyPZeZ1p8SlHUYVGgDfBQGQSnHQR?=
 =?us-ascii?Q?RiNuf03O8zUvUY3UThUyW3IRVg2xBQdym7oJzXq3SagR25T5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7811cfb9-70cd-410b-1917-08df472efeb3
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 17:52:08.1098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JWICvMnbVG4t9kufQ6j/o0SYZ13cEEIJ+6xlnV5M9cOmXdkYSg2heA7ZB4/fr3tJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6329

extra_size is additional memory required that must be immediately after
the image.

There are three possibilities here, each a little different:
- relocating for kaslr, just request extra_size like the zboot flow does
  when allocating the random placement from EFI
- in place, attempt to allocate from EFI precisely after Image to
  confirm nothing weird is there, failing that
- like any other error with the in place EFI location allocate
  non-randomly with extra_size included

Adjust things to use a kernel_allocsize which is >= the memsize computed
from the image_info.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/firmware/efi/libstub/kaslr.c | 77 ++++++++++++++++++++++------
 1 file changed, 61 insertions(+), 16 deletions(-)

diff --git a/drivers/firmware/efi/libstub/kaslr.c b/drivers/firmware/efi/libstub/kaslr.c
index 2f1f3e19583def..f50c36a2fd635e 100644
--- a/drivers/firmware/efi/libstub/kaslr.c
+++ b/drivers/firmware/efi/libstub/kaslr.c
@@ -80,7 +80,44 @@ static bool check_image_region(u64 base, u64 size)
 	return false;
 }
 
+/*
+ * The PE loader owns only kernel_memsize of the image.  Try to own the
+ * requested tail separately at the exact adjacent address instead of
+ * relocating the complete region.
+ */
+static efi_status_t allocate_image_tail(unsigned long image_addr,
+					unsigned long kernel_memsize,
+					unsigned long extra_size,
+					unsigned long *free_addr,
+					unsigned long *free_size)
+{
+	efi_physical_addr_t tail_addr;
+	efi_status_t status;
+
+	/*
+	 * Since we intend to use efi_free() for reserve_addr it should be
+	 * aligned to the higher alignment since efi_free() includes rounding.
+	 * For ARM64 the kernel image is already aligned up to EFI_ALLOC_ALIGN
+	 * by the linker.
+	 */
+	tail_addr = image_addr + kernel_memsize;
+	if (!IS_ALIGNED(tail_addr, EFI_ALLOC_ALIGN))
+		return EFI_OUT_OF_RESOURCES;
+
+	extra_size = round_up(extra_size, EFI_ALLOC_ALIGN);
+	status = efi_bs_call(allocate_pages, EFI_ALLOCATE_ADDRESS,
+			     EFI_LOADER_CODE, extra_size / EFI_PAGE_SIZE,
+			     &tail_addr);
+	if (status != EFI_SUCCESS)
+		return status;
+
+	*free_addr = tail_addr;
+	*free_size = extra_size;
+	return EFI_SUCCESS;
+}
+
 static void efi_kaslr_copy_kernel(unsigned long image_addr,
+				  unsigned long kernel_allocsize,
 				  unsigned long *free_addr,
 				  unsigned long *free_size,
 				  const struct efi_image_info **image_info)
@@ -88,14 +125,13 @@ static void efi_kaslr_copy_kernel(unsigned long image_addr,
 	unsigned long kernel_base	= efistub_kernel_base(*image_info);
 	unsigned long kernel_size	= efistub_kernel_size(*image_info);
 	unsigned long kernel_codesize	= efistub_kernel_codesize(*image_info);
-	unsigned long kernel_memsize	= efistub_kernel_memsize(*image_info);
 
 	memcpy((void *)image_addr, (void *)kernel_base, kernel_size);
 	*free_addr = image_addr;
-	*free_size = kernel_memsize;
+	*free_size = kernel_allocsize;
 
 	efi_icache_sync(image_addr, image_addr + kernel_codesize);
-	efi_remap_image(image_addr, kernel_memsize, kernel_codesize);
+	efi_remap_image(image_addr, kernel_allocsize, kernel_codesize);
 
 	*(unsigned long *)image_info += image_addr - kernel_base;
 }
@@ -119,7 +155,9 @@ efi_status_t efi_kaslr_relocate_kernel(unsigned long *free_addr,
 				       u32 phys_seed)
 {
 	unsigned long kernel_base	= efistub_kernel_base(*image_info);
-	unsigned long kernel_memsize	= efistub_kernel_memsize(*image_info);
+	unsigned long extra_size	= efi_drtm_get_extra_size();
+	unsigned long kernel_allocsize	= efistub_kernel_memsize(*image_info) +
+					  extra_size;
 	u64 min_kimg_align		= efi_get_kimg_min_align();
 	unsigned long image_addr;
 	efi_status_t status;
@@ -129,30 +167,36 @@ efi_status_t efi_kaslr_relocate_kernel(unsigned long *free_addr,
 		 * If KASLR is enabled, and we have some randomness available,
 		 * locate the kernel at a randomized offset in physical memory.
 		 */
-		status = efi_random_alloc(kernel_memsize, min_kimg_align,
+		status = efi_random_alloc(kernel_allocsize, min_kimg_align,
 					  &image_addr, phys_seed,
 					  EFI_LOADER_CODE, 0, EFI_ALLOC_LIMIT);
 		if (status == EFI_SUCCESS) {
-			efi_kaslr_copy_kernel(image_addr, free_addr, free_size,
-					      image_info);
+			efi_kaslr_copy_kernel(image_addr, kernel_allocsize,
+					      free_addr, free_size, image_info);
 			return EFI_SUCCESS;
 		}
 		efi_warn("efi_random_alloc() failed: 0x%lx\n", status);
 	}
 
 	/* Try to use the image in place */
-	if (!check_image_region(kernel_base, kernel_memsize)) {
+	if (!check_image_region(kernel_base, kernel_allocsize)) {
 		efi_err("FIRMWARE BUG: Image BSS overlaps adjacent EFI memory region\n");
 	} else if (IS_ALIGNED(kernel_base, min_kimg_align) &&
-		   (kernel_base + kernel_memsize) < EFI_ALLOC_LIMIT) {
-		/*
-		 * Just execute from wherever we were loaded by the UEFI PE/COFF
-		 * loader if the placement is suitable.
-		 */
-		return EFI_SUCCESS;
+		   (kernel_base + kernel_allocsize) < EFI_ALLOC_LIMIT) {
+		if (!extra_size) {
+			/*
+			 * Just execute from wherever we were loaded by the UEFI
+			 * PE/COFF loader if the placement is suitable.
+			 */
+			return EFI_SUCCESS;
+		}
+		status = allocate_image_tail(kernel_base, kernel_allocsize,
+					     extra_size, free_addr, free_size);
+		if (status == EFI_SUCCESS)
+			return EFI_SUCCESS;
 	}
 
-	status = efi_allocate_pages_aligned(kernel_memsize, &image_addr,
+	status = efi_allocate_pages_aligned(kernel_allocsize, &image_addr,
 					    ULONG_MAX, min_kimg_align,
 					    EFI_LOADER_CODE);
 	if (status != EFI_SUCCESS) {
@@ -160,6 +204,7 @@ efi_status_t efi_kaslr_relocate_kernel(unsigned long *free_addr,
 		return status;
 	}
 
-	efi_kaslr_copy_kernel(image_addr, free_addr, free_size, image_info);
+	efi_kaslr_copy_kernel(image_addr, kernel_allocsize, free_addr,
+			      free_size, image_info);
 	return EFI_SUCCESS;
 }
-- 
2.43.0

