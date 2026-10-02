Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010028.outbound.protection.outlook.com [52.101.201.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310793EB7F4;
	Fri,  2 Oct 2026 23:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790983938; cv=fail; b=fb3DU+PmZ1uwrTcCa9MQynS5PRWaidaaKhYPX1Ns4HckpoJp2xitLvo1Sm4mf9Qa5NQC/JzRZGx50BsCAOlvVLN/GzYnzplDp2SqpKaUoaTZptTDjwvSqYleEY3mEPrTLI6Beq7k3u8oGxtTaisUKQ9LZPSP4Po6lih4OsfU9yw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790983938; c=relaxed/simple;
	bh=KttfUaOruDTZuBSFgHm0ZJKRmFYIBN2/mENQJ5p09FY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Wh2qyF8ollfK6/IU50OR3r/bhTLKVopk6X65LWSicy0KY1igF+hhbM7xjpxEDUVDrgUzKYXwb2nuJ09zvZtGH3OYeENqTUrr8JIo/egNVDsD7evp4xh2d9YzkGveewCmjeWJU3+XAUZynWsItKhhF1vj2FJsi4UsGy3jlm8ebjU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=r6Jxqhp3; arc=fail smtp.client-ip=52.101.201.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="r6Jxqhp3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ir4koxnddeYvd7SmU1AdptoAoNAZn2iqwyn/1E2lKgJFvZ+uq0AWBga9aqN4ff42dA7VJXPtH+tnKcuqRQMBEBtfXpyKWaExtUjf121AX/24BZ+Q5vuDKqurQE4F0hJCSntpkwMpylKaK96QP5IMnnVV9GapLagNZMsqPfAG/bG8517PXssNeATsWRiA3r1SttFPd5FgszyL7fIuEGy05jTWniS1PzGPsvqtIlIio2KMGCgJfypMvK6SPvV0jd7u36BxJe54vi/VV0ebrQ0ThG+yUOAv4BIpWwkf4aHsFnCQhq0qQGjNDlt7CGRRiFLNE/PLcrapJe8efXBov2MMfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c285ZZlXra+kpGJVRcEHjHmYQBGABd70serNtYQ32Cg=;
 b=n/Uj5AQRsinI3aOeCQMwMMtid6Vgn7DW2QNLFrpXX3zt5Hu6H2pJ6+UnH4YjbLxUI5aB7AYu6HXrN6PFX8tDRF/Bl1gey8+IM2d+c6tlwPMriXf1duIij8yHc5thX9NwVw6iviH+p+b8w+sBpPKe9Tm2euedy+HUhPRMgmWqe6k5fXSNnblqzm5sBjMXZDJ/5sVFWwcXwfP52ISKGdvF25et1/yCQfh2QlX/h2eokprwc7yBfjhcwD0d3tIeif2obJuyHY9cFHVtAzWra0YwXk3W3zi+s0up2amagP+RA5oE8PFGltnhqDtGvylDDGR3/cQAI8T3Y2PsNQR1tABf4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c285ZZlXra+kpGJVRcEHjHmYQBGABd70serNtYQ32Cg=;
 b=r6Jxqhp3agUwUcujc8a1X4LQ7iFQ68zxgVXkHtJpIjA3RzcxgpGrRtuvlaG+qUw2D6dKnr7hslYzpyzpd1xBYHqiet2pC0WMFz1X0VydhZJdtgfR04jGTlVf7ndm+XKQwyUpcsKi3wLentN8WLACtPj+KI+DknekrlwZP667/oD5xDjY8KkBTRianBBihyFoSl663qytC7kvmmW36EZxQFvtYswugi1FDoHHWCSBe8hxLs2yTTmC4mUM4c7gD1bjFP8RspjqFdj7ZI/BZHb83bs/ZgX1y9IUBBnGEunjs82iLV2MC/p3gScplNfjlyoF0SVnVKkMqQ3djygknpLTzw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14) by PH7PR12MB5830.namprd12.prod.outlook.com
 (2603:10b6:510:1d5::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Fri, 2 Oct
 2026 23:32:08 +0000
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5]) by LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5%5]) with mapi id 15.21.0472.016; Fri, 2 Oct 2026
 23:32:08 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Ard Biesheuvel <ardb@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	David Sterba <dsterba@suse.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-efi@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Simon Glass <sjg@chromium.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Nick Terrell <terrelln@fb.com>,
	Will Deacon <will@kernel.org>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	linux-integrity@vger.kernel.org,
	Palmer Dabbelt <palmer@rivosinc.com>,
	patches@lists.linux.dev,
	=?utf-8?q?Piotr_Kr=C3=B3l?= <piotr.krol@3mdeb.com>,
	Ross Philipson <ross.philipson@gmail.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Song Shuai <songshuaishuai@tinylab.org>
Subject: [PATCH v2 12/15] arm64: drtm: Update the linker script for EFI_STUB_DRTM
Date: Fri,  2 Oct 2026 20:31:49 -0300
Message-ID: <12-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
In-Reply-To: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0P220CA0016.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::19) To LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LY0PR12MB325698:EE_|PH7PR12MB5830:EE_
X-MS-Office365-Filtering-Correlation-Id: f965d048-9ff7-4f76-81e1-08df20dd5a72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|1800799024|23010399003|376014|10067099003|11063799006|921020|3023799007|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	UFzEbV7Xvc7z1SzzAgwwVgkjccjFVjeseSpgcCa+7tWcypUbx1XtuFNieWrMmY9HSCW0XcAW/YAKOHj65oJ2tZbhRiqDLZMr6urPPpzQzIGSxybZ7redXRjoecUIY006BX1Yzkb0PUv3wtCUgeQ4SMQkIG/CBuPHS6AG8SzW/6PmogNR+tBdYjVMk8GWGCcas7B4ETsvYzjhACabEm8a3kE2Uq9wG47x+ZOBqYBNtp+V1riSVL8LE1GBjZAfc4QWvNti0fb+IZepHAtVEz7R4OcLBy6ytKkqW3BAxCkpoPaxumH7phOagi8I9CN/edy6pxlQ8uSgFD5APWUGlGGOCt2cieVyw/mxH7wG5BfN/S9yuNIofE+MgaNrgXlL9QBYVPUzZudxnAOErHFuTjElfinhIoe52mORGm94mZC3W4pb90ciF7QXVWTR/WiAyzWxCLavmSs3PqZS1qUNrKv5BjtWvGvEYrypxJ3CQkAXn59Tx8QbFQZox3TiHEtddS3UZ/wluizAzzzXv7BjKbV39HOlYx+wtyE1LEA+tVsT13Qz13CCN6nNAoPPj3+b25Ep8zv77XZBAytTgcSf0yS09WlM7Dns01HnxNTgUt7vBUajdHEB181zAYLwjU5lz/HOOBKtALt0MoMT5jjRSm1T3R3eiPjLFfvOVqbZKEojUFMAlQI2+F8qJl/XXT+wC+7KFQ4//wpxpe4ehmfthrgDtA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LY0PR12MB325698.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(23010399003)(376014)(10067099003)(11063799006)(921020)(3023799007)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?m7MoLtyJjlGt+ghac4GmP6ELirOWfxipdWbOGjjhnukgoMWa3eEJ3cIACWGL?=
 =?us-ascii?Q?4xaR7F8o4+HZvOke+UlIlDlyBRdcWivbtJFcTa1vXudfpXowJJnaK2TdWa7m?=
 =?us-ascii?Q?X9BMmOn9zuQ4mt/a9iKj+aWklMvVOxEDvOs6wGyPlXAu/QvZxQcET70Col1n?=
 =?us-ascii?Q?MXP213QGi24FUrblsZtqYtsfFsp9E68RUjV6TTcnxS5TJmbuJkH9EBHYs5pu?=
 =?us-ascii?Q?oAxVMeGDAJNqqiZ5/TdHIoSTG6aCbPbjsy7st+lLFTZwEmXpNghDEYKN5Jn5?=
 =?us-ascii?Q?7bC6hliX+t+xOzbgaJyHuwX6nkICOkpjDxYkweWvlWrlpHGe2Y9jUTD0AjjQ?=
 =?us-ascii?Q?nCVgy3QX5s1+tFhyq+5wER9DhouulFPMLYsLPgjKH1LczRznKRCTRWY4tjfA?=
 =?us-ascii?Q?GZ7GoesVpp3Njui/DdZLmsRwHlhvIfYGvR7vOCH/SQh8XGdlMnx8U+7N+lEL?=
 =?us-ascii?Q?H8ZV4+OYBnohZBw8VToWIwuBjJYzgK4mxGTQqhoI/M1D5PCcpUCAfQMqZt1i?=
 =?us-ascii?Q?xblLIKJpdly/l4Q6VP8HsWiFbMqC03GREnzObbb8cv6PJJul69xAgB72gqgM?=
 =?us-ascii?Q?iz5cZtphLJZiIuZMJctO7Kc8TRWQp7G9WxpUPppfFSevqSPKjIW6Bs1udY+d?=
 =?us-ascii?Q?j44Im0uDaS4ETs1HBYLbQewcG/mAL4r0dskbir3vNzKxMHTO4Izmngousm5x?=
 =?us-ascii?Q?WxJuqPlJW3AUiVWxqc+ZB/I4z2u0mmUI67aUC7ojtmO8u2t0HAZSm6BUkbm6?=
 =?us-ascii?Q?KfWyes6sSVFhXCqhRi7W/2oNIMkTM325biBTEm5ehIVhgy4A5/DiOW/ywr+1?=
 =?us-ascii?Q?HQvdHY47ADFCxrGzDuBPrBYvbHgi0N7S8zSXoSMQzd3myzTYL4lFhOoEZSQQ?=
 =?us-ascii?Q?RpC6JNdoO2/iCHDx7YV5uXZAVJejsVICVN7+bsKOIxeO1quhBiAX8AjwyQVF?=
 =?us-ascii?Q?wmTEucQIDVJJzme0BNt4FCuie2b4QfSJ+BvstIkBxO9bk9VDGfnh+5mJipsf?=
 =?us-ascii?Q?/adOP3nAYWijHQl8G76bgFCns3ssNPn8nHYFSMOBkd569W6kF3agMXuzCqB1?=
 =?us-ascii?Q?kwr5YA8Owx3D767Nc9Bevo3wu3wzeIxar+7ibNAuPcqVsyP44OOhkcdE/Yk2?=
 =?us-ascii?Q?cfFKsjVtV5EGgVdemcsHVhbwAFedCQOP1sMFwSNxJMTOVXeWY8T60ookd8eC?=
 =?us-ascii?Q?+mXwamQKgMbfDcDXpynr63bx0T2ZvZCVenjyn0xXyKoK1Kx9G8LHWflD5Ly4?=
 =?us-ascii?Q?YAOX6cPzExH15aQj69qNZXd9lRbvkbT1YjcVv5rpp3xMCdXYqDOqX7sLyIDu?=
 =?us-ascii?Q?V8p4G4rN6muDz7DLhY7jfu0OvDJhi4qQSymqWFDzdkP2yuJWp2E2e8abXkwT?=
 =?us-ascii?Q?FPJoAwfWAfe6zj1QKnbv/SvGmWSUo5yuXAdAkYPe3xY8z2JE6bXlFb+kHUC4?=
 =?us-ascii?Q?ZIYvnBsHgSC5Y6bfFFQD8+9eIYSGNcPXNVsikKPDgmTFBJDSXJdeMMzIx3bY?=
 =?us-ascii?Q?9lYVyMQbx8+fepfRjldJCyVKOc0bBVMX/1seBPlSrz8Nsgg80oAYOfW7+7CW?=
 =?us-ascii?Q?jxgQH24ibUBwPfXHecnN5V45+U1jVETDoq/wHR3suqXogvkF8V/qO0g8qUTh?=
 =?us-ascii?Q?oo7+jvlr7FUcn2ojGCk67YBX485eJfORb7ieR+/TSPtmYUDIKawN3XTWdMvX?=
 =?us-ascii?Q?zV2+pRrc0wHgGHyGlkWyCv1ciD9mcwHNelRXjG4AK1V9zfAP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f965d048-9ff7-4f76-81e1-08df20dd5a72
X-MS-Exchange-CrossTenant-AuthSource: LY0PR12MB325698.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2026 23:31:58.8460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T+sCRfZvcELSPJMDPELbbrBmYxvUHtR9tqcGZXxmH/LcMdgFtvwSPppA/YWaadDk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5830

Implement the link layout that CONFIG_EFI_STUB_DRTM requires. This maps
vmlinux into the Dynamic Launch Measured Environment (DLME) defined by the
spec.

Broadly, Image fits into the spec defined DLME region memory layout in
this order:
 - Program headers and padding up to _stext. EFI can write to these while
   loading the stub so they do not have a stable measurement.
 - All the boot-time immutable data, including .text, .data, .init
   and so on (measured)
 - Data written by the EFI stub
 - .bss, padding and other 0'd data up to _end
 - The "DLME Data" written by the launch process. This is a datastructure
   the post launch kernel will parse to get trusted information about th
   launch.

New linker symbols are added to mark these areas and their offsets are
placed into the efi_image_info so both stubs can get them.

The spec's design of the DLME was intended to fit a typical OS image like
this, with two areas that are unmeasured and an inner measured region.

Linux zeroes the unmeasured area of .bss/etc after the DRTM launch so it
also reaches a known value. The DLME data is written by the launch and is
trusted. The EFI stub data is either ignored or will have to be sanitized.

Add a section for the unmeasured data before the PECOFF padding. This is
an allocated section so it is zero'd in the image and is only 64 bytes in
my builds. There is a high chance it gets absorbed into the padding
region.

The post-launch kernel will have to reserve the "DLME Data" before
starting the allocator since it falls outside the linker map. This will
happen in the first series to consume this data.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 arch/arm64/include/asm/image.h  |  8 +++++
 arch/arm64/kernel/vmlinux.lds.S | 64 ++++++++++++++++++++++++++++++++-
 2 files changed, 71 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/image.h b/arch/arm64/include/asm/image.h
index b18ce23a2cba7f..36afe95ffa7544 100644
--- a/arch/arm64/include/asm/image.h
+++ b/arch/arm64/include/asm/image.h
@@ -5,7 +5,11 @@
 
 #define ARM64_IMAGE_MAGIC	"ARM\x64"
 
+#ifdef CONFIG_ARM64_DRTM
+#define EFI_IMAGE_INFO_SIZE	40
+#else
 #define EFI_IMAGE_INFO_SIZE	8
+#endif
 
 #define ARM64_IMAGE_FLAG_BE_SHIFT		0
 #define ARM64_IMAGE_FLAG_PAGE_SIZE_SHIFT	(ARM64_IMAGE_FLAG_BE_SHIFT + 1)
@@ -62,6 +66,10 @@ struct arm64_image_header {
  */
 struct efi_image_info {
 	u64 code_size;
+#ifdef CONFIG_ARM64_DRTM
+	u64 drtm_measured_start;
+	u64 dlme_measured_size;
+#endif
 };
 static_assert(sizeof(struct efi_image_info) == EFI_IMAGE_INFO_SIZE);
 
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 8305b47995954b..5c14decf0dd4d3 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -190,10 +190,24 @@ SECTIONS
 
 	.head.text : {
 		_text = .;
+#ifdef CONFIG_ARM64_DRTM
+		/* DEN0113 R314010: The DLME region must start at a 4KB aligned address. */
+		ASSERT((_text & (SZ_4K - 1)) == 0,
+		       "DLME region is not 4 KiB aligned");
+#endif
 		HEAD_TEXT
 	}
 	.text : ALIGN(SEGMENT_ALIGN) {	/* Real text segment		*/
 		_stext = .;		/* Text and read-only data	*/
+#ifdef CONFIG_ARM64_DRTM
+		__drtm_measured_start = _stext;
+		/*
+		 * DEN0113 R314020: The DLME image must start at a 4KB aligned
+		 * address. This happens always because SEGMENT_ALIGN is big.
+		 */
+		ASSERT((__drtm_measured_start & (SZ_4K - 1)) == 0,
+		       "DLME measured start is not 4 KiB aligned");
+#endif
 			IRQENTRY_TEXT
 			SOFTIRQENTRY_TEXT
 			ENTRY_TEXT
@@ -285,6 +299,11 @@ SECTIONS
 		EFI_IMAGE_INFO(
 			/* code_size */
 			EFI_IMAGE_INFO_OFFSET(__inittext_end);
+#ifdef CONFIG_ARM64_DRTM
+			EFI_IMAGE_INFO_OFFSET(__drtm_measured_start);
+			/* dlme_measured_size */
+			EFI_IMAGE_INFO_ENTRY(__drtm_measured_end - __drtm_measured_start);
+#endif
 		)
 	}
 	.exit.data : {
@@ -348,6 +367,44 @@ SECTIONS
 		__mmuoff_data_end = .;
 	}
 
+	/*
+	 * DRTM layout for DEN0113 as it relates to the link layout, refer
+	 * to Figure 8 in 1.4b. In that language:
+	 *  "Free Space 1" is the PE header and padding between _text and
+	 *        __drtm_measured_start (_stext)
+	 *  "DLME Image" is from __drtm_measured_start to __drtm_measured_end
+	 *  "Free Space 2" is kernel efi data/bss/etc till __drtm_dlme_start
+	 *  "DLME Data" is a memory sized "Minimum Size of DLME data"
+	 *        and is retained after boot for use by the kernel
+	 *
+	 * Thus, the DRTM_PARAMETERS follow from that:
+	 *   DLME Region Address = _text's PA ie the start of Image
+	 *   DLME Region Size = DLME Data Offset + "Minimum Size of DLME data"
+	 *   DLME Image Start Offset = __drtm_measured_start - _text
+	 *   DLME Image Size = __drtm_measured_end - __drtm_measured_start
+	 *   DLME Data Offset = __drtm_dlme_start - _text
+	 *   Normal World DCE region address = PA of __drtm_dlme_start +
+	 *                                  "Minimum Size of DLME data"
+	 *
+	 * The EFI stub will place any optional "Normal World DCE" region
+	 * immediately after the "DLME data". It is only used internally by the
+	 * FW during the launch and has no effect on the link layout.
+	 */
+#ifdef CONFIG_ARM64_DRTM
+	__drtm_measured_end = .;
+
+	/*
+	 * Writable EFI stub state. When DRTM is being used the stub's mutable
+	 * data cannot reside in the normal .init.data because that section
+	 * will be measured.
+	 */
+	.unmeasured.data : {
+		*(.unmeasured.data)
+		*(.init.efidata .init.efidata.*)
+		*(.init.efibss .init.efibss.*)
+	}
+#endif
+
 	PECOFF_EDATA_PADDING
 	__pecoff_data_rawsize = ABSOLUTE(. - __initdata_begin);
 	_edata = .;
@@ -370,10 +427,15 @@ SECTIONS
 
 	. += SZ_4K;		/* stack for the early C runtime */
 	early_init_stack = .;
-
 	. = ALIGN(SEGMENT_ALIGN);
 	__pecoff_data_size = ABSOLUTE(. - __initdata_begin);
 	_end = .;
+#ifdef CONFIG_ARM64_DRTM
+	/* DEN0113 R314030: The DLME data must start at a 4KB aligned address. */
+	__drtm_dlme_start = .;
+	ASSERT((__drtm_dlme_start & (SZ_4K - 1)) == 0,
+	       "DLME data is not 4 KiB aligned")
+#endif
 	__pi__end = .;
 
 	STABS_DEBUG
-- 
2.43.0

