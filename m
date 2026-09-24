Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010039.outbound.protection.outlook.com [40.93.198.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70FC5361943;
	Thu, 24 Sep 2026 13:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790258009; cv=fail; b=O3c6IXgBVro+3+JcpdpsuhSGQ41B5WZPLB4AB2eB7+A1q/O/tpIEFW6NCZBguLiA/aYOyY+JAztQXaVYZ4V94p4iRtil2MmMb2uNdYUdPfFQQL4rQvRHEyv/qbnEGNqn3icwh0G6sSCLwul5KZCZ4xeTtiJsA0fd2p3tbUWhkKk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790258009; c=relaxed/simple;
	bh=+6JpSVohiwlYQsOe4Yc/fnBWJUlM9dhGPNqSZOo96dE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CbZX2JfwaeLqmur4QTZaaWskTsIIv+nxlPXMKTOJ+DiFvzNZ5vD1LJ5ZFnD+vSVkVGM4Z0/WFeSjM41lCJOkS+SSkI9SNUdeS1+MxqwmsWnpYCtFb6ZksTZOyu/skNyHpQ82XsUsPCP8A/JniEp/7GcXJYmlQQRxpoP/Z9UEPbE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Qz8EDvkd; arc=fail smtp.client-ip=40.93.198.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Qz8EDvkd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tg5uiENtkeOayXz40hujcsYb7reErk3d8llU3M3AyDhvL7pXjvb/BcI4uqOQ54Is1g3H23J6GNPhZzVJRtgUgddDFGNFg/PyPYjPzQFxD9ZrJbgqvk8pyvlrXSguE41HzXqYzJxi5RI6OUqkhRND76Cpq1PwMUTZsWuVU/wJ/aZWEHlBFH7YZDTHvQDAoUHtbXJMQ37SCCyYBrVDttnudBnrp4OFw877nfR+JLPPVdMZB2Vxpj2t5NletAq/8BaW7djFEL/qdGc9ADJnWW7r0ATGcIx1fhWLBP63Z+Q2tZFiFmYoNe9c6uSwi22auWqPbuKICqRrw239J5dnQjgjPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YL2IObc4xhli+zxlMqDet/3lEUN4WBbb0xY4qWdIfps=;
 b=YwmfXqZe3kuyCdTa/KIdIWJF6tZuv0/0hrVFxFWydvmavLSZICfDi/lUbaaEjZu1pCZSg/CpHQZFhKeCohqfLh5bNUxgnQJKqsSQI4M/zI5IwZBDbpLdvITqoyazv9Nrkcbqo2zMC+5pu/jhzbjSG1+YhMcbkEGwNurqX7ESMYv/QqVq6wgWC+rvO61zro8w1CgpQXeJdK+W9lDq+UAqLdrVitanJr4cs8x7AvBbqT/qOY3ly2fPmiV5XgdsI+AhkqA0CHhhCGM7NnpddhSckDs681Kh1tUTgP9advC/Y8AB94R1lsSCE6PeUaznwNBtj39Y8jChNd0zMLeR3zrvzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YL2IObc4xhli+zxlMqDet/3lEUN4WBbb0xY4qWdIfps=;
 b=Qz8EDvkdT44smGnhGRDWtMpPVusN+6VG7KZITmRzCXPqI4MR1/ATRQfORyILq75tuIZxQKGU4FJejx/TUgOQto2N1m1W5Jlc51Q0SG+HkZx0/rUpriVMDzGQco6tB/u1FB8GvGLlh6cAPJDcTNYj/aKTlVL8Kx26F/0im9QtNRGE3hj87SJUIt8cAOc4bGyuZeo96DwRnVTP7p3iORQQlksyshJdcxVszMKRsW6LqwWwllDERWcLkV8tjoRAXTsyJ7TNdOIrkRdH/FUO87bGF0CBnMVCRO7RmvZFpJd21XI5EhirOU6DlFyq/t8O83lOp2eeLDI7hROQhQiGCQbhhg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by PH8PR12MB7375.namprd12.prod.outlook.com
 (2603:10b6:510:215::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 13:53:22 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 13:53:22 +0000
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
	linux-integrity@vger.kernel.org,
	Palmer Dabbelt <palmer@rivosinc.com>,
	patches@lists.linux.dev,
	Ross Philipson <ross.philipson@gmail.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Song Shuai <songshuaishuai@tinylab.org>
Subject: [PATCH 04/16] vmlinux.lds: Move DATA_LE32() from arm64 to the common linker script
Date: Thu, 24 Sep 2026 10:53:07 -0300
Message-ID: <4-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
In-Reply-To: <0-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR13CA0010.namprd13.prod.outlook.com
 (2603:10b6:510:174::20) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|PH8PR12MB7375:EE_
X-MS-Office365-Filtering-Correlation-Id: 25754f48-d46e-4da8-e624-08df1a433221
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|921020|11063799006|56012099006|10067099003|18002099003|22082099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	qUbGpzqNRxY3zQll+AEbng5L0d+NU9pj2kMuLkDYKF1KEoQvPeWVRBsJHAoa4iteqV3dY7TRlLK4UmniE1bKhyps41P8d4yvvCkmcvDlIk87f9sOIvs/VWm4WppXh7OBs/Tiuwazl8l7lg/5ywtopxuCFq/uO13YHeMC3UKB/fsgmIDnwbXsRJK7bpbrAaQ/9sGMAvcdQUvFlcAoYGXzoo0jt7E2x3I07OJnmZ0biUyuWUmTratM81GwoB8yX/y6/021FCxdOK4p+I80dufgndxOhNse78do14FXfJiEI/+4ies2a752hrQwNOaa2jV8BPXkMwE6WYArItQlg3U3n0aZG7DeJoJr5NPwxjTMTTgUDYm1mqcQj5DI1Jzc5TjMoisVwmzKWlDrBwZufjScpmL7DI/VU9hc/suMoGknhhzyDi+RjknYOiQ6E1H0iRipf1evpXER6PWu97A/qtKHFujdc6akbX5Wv9zCKkPaQ6NP95SDoOYckXrdqYwI/g2DUDz1xUI6+vjPWd+ZergYKqnVKBU2LhUsp8cIDceJrtlga8Uj25MuTNcXFkcvFkcAW/yegg7T286zP4kt3rykSzUqTy98Hywk4eArMlPjCLgTIhTJT9m/MG58fUko4W0ooT0Igl0bE+Gj3Qqa1A3nlrw/FzqENNUO+qCu6C9umUNTUdG2wspSr9Ce+OfBN/J6hmMLOo/x4hNBLGAkC3U28Q==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(921020)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RJtF2qROXR/CzdoKZF5SfNy78H7EQyUJQyOKu6O+y7+3+TYQrjeERlp5U0J2?=
 =?us-ascii?Q?W+ozcFgr1yGZwMPcKboVJXMHjpPJDPRY3yQzY+H9vz3p8pqbZTo7E+wpnlFB?=
 =?us-ascii?Q?63iN9ZvIwNCNQcsXAECYAqLVnmyC9n+lvknjiah8CYyJ5QJzTRNbzT6PIRDU?=
 =?us-ascii?Q?pTG+ljJNE8TU8p9bH/i18so8VRlqATgzykqtWzMmIUKvpD9cNkGx+UfvGzdR?=
 =?us-ascii?Q?9GmLQrK/7zBFD1X61Ehwf+UKmHzjLLMCnUufGMnRa0XEJvpuaIrgema2pCqM?=
 =?us-ascii?Q?hHtzGXIVzaA5uqqFb3GIc3u+3R3FJ5s6trLZy+1Suh6ejJQ8F21VXpu53vq3?=
 =?us-ascii?Q?HBVlv81KWAiylRQlEZKJOWl4yP7+SzpDTaBjw2d+2NV+07ydHU0Xu4zGqvri?=
 =?us-ascii?Q?Dg+Qxm3E0qByfUMLdyINLfMSe7b6hjJRsWQfhzT4apCSAPKuVcQ4nA359meS?=
 =?us-ascii?Q?yKvIj/TiNuX5bFZuoFmRbyJIPX3ExDIUGH6KPgPjGhQg11/KvQFWFwg/T7jS?=
 =?us-ascii?Q?62BOeY/Z8mihBI9axQAhm42UnKWCJCLqYfQpuqoYLtNZX4sdw9LFcDh5hsqD?=
 =?us-ascii?Q?OanAFu2tZ6O5LTvopXfaPRP4dptG6kqaidATqWLeutygrpc07MwbzjKjaZoq?=
 =?us-ascii?Q?bwyfsb5OXwyJ+luaQ7v0+6/JA2cowHQl9WSh+KZz7NL9CW+1gk5yuYvALzfi?=
 =?us-ascii?Q?5U/qlnt3OfuBM1X97IAph5m24Pq4d2DkI2/Gh1DCYa1FNhDN2Mywx/Bu0gGa?=
 =?us-ascii?Q?Tp9Ey6GjsNj2hHrG5bibVW/im075nI/YqFp3c72PhVWIgAAydrdJUdO7hA7a?=
 =?us-ascii?Q?sDWXTA+kbFVZ9/W2kFEIeTVmPr1QskgEgbdoL/8iSR1A2VCQWiOhEXV2uX2x?=
 =?us-ascii?Q?PZlWaGdn1LuhQwa/LiKpyNWJrApI5776jM/GgVVdXiNAUYPconA6sQxh6rhJ?=
 =?us-ascii?Q?0IlANkO3bVyFiod9gg0KI3crm/pvjsQDk9YI4J1sydtx7ELdwLK0IHry8jnY?=
 =?us-ascii?Q?TIgcPPQLgEEoRBtngBifrJ1h7GxPbH8mmWjK7E7uJ4fTdrlKRipdDRkLUAi1?=
 =?us-ascii?Q?PLETBnzoDELzhmT8OuX2BP/FL+gonjdG8SEOeAIotHh6HOD8+eSjIJVB3oJK?=
 =?us-ascii?Q?H5d8uqvkODl39azd8l2wYlq18KYoL8a0VdP4P0FGZl+rxzBUvcZB42qvKADi?=
 =?us-ascii?Q?h2Yu4ttOyEjND4MAmLitjsu2lpC6cH4awBAjwKNfUNeVNFpjHm6dMcwMVU/K?=
 =?us-ascii?Q?1XAr0oCOdl8SpwL8y/x3vZ2cM/b6UZJ168M3VHVoyGLJR0zmj5zJeld+1qok?=
 =?us-ascii?Q?t8wV3XXhAtmv5r1s9SUwH8RzUlnUnbrH5Wbg1P8syY9IYYH8AM3Ua/oKV3IG?=
 =?us-ascii?Q?g7ymbpCUlDvnS6CkcyT6eEkLr0u4CFOChQrZ4GIrrd+4lWt/nPDfXxH7Z7P4?=
 =?us-ascii?Q?6+PINm+dw593raP6uWIngr9YQs+PVWBLKyKriu5QT4Ry1voPebgJa1q5j1CA?=
 =?us-ascii?Q?O/wIfQf+Y4SQDgwNjjq+35MebIaqyt611RYwHxIsZlFyr+Hdgy78q2i5sg6R?=
 =?us-ascii?Q?kgWgtSTnrVXxyaDacU3Az8qKfUKj+Ouzp0cL4jGualUe5M4a/1FOXKm2JKiN?=
 =?us-ascii?Q?n58uLQ+di3Lssypyo0s1+6Mdbo4WjGAG0Gs6oYYatv5PffC2XKAgYH5htR+t?=
 =?us-ascii?Q?uuzQnPME08LxJLp5U9KO1pqGvmj5/KzXbcHCX4Lvpm3DqtQq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25754f48-d46e-4da8-e624-08df1a433221
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 13:53:21.7166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aj5dpBcajpLUt1SRDHFPL+yFezT5ZVpCuFMyHFOUusy7gwReemNxtMXzHUlW2B+z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7375

Other arches may want to use this to get consistent fixed endian output.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 arch/arm64/kernel/image.h         | 14 --------------
 include/asm-generic/vmlinux.lds.h | 15 +++++++++++++++
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kernel/image.h b/arch/arm64/kernel/image.h
index 7bc3ba89790191..1bff6b061b6cab 100644
--- a/arch/arm64/kernel/image.h
+++ b/arch/arm64/kernel/image.h
@@ -14,26 +14,12 @@
 #include <asm/image.h>
 
 /*
- * There aren't any ELF relocations we can use to endian-swap values known only
- * at link time (e.g. the subtraction of two symbol addresses), so we must get
- * the linker to endian-swap certain values before emitting them.
- *
  * Note that, in order for this to work when building the ELF64 PIE executable
  * (for KASLR), these values should not be referenced via R_AARCH64_ABS64
  * relocations, since these are fixed up at runtime rather than at build time
  * when PIE is in effect. So we need to split them up in 32-bit high and low
  * words.
  */
-#ifdef CONFIG_CPU_BIG_ENDIAN
-#define DATA_LE32(data)				\
-	((((data) & 0x000000ff) << 24) |	\
-	 (((data) & 0x0000ff00) << 8)  |	\
-	 (((data) & 0x00ff0000) >> 8)  |	\
-	 (((data) & 0xff000000) >> 24))
-#else
-#define DATA_LE32(data) ((data) & 0xffffffff)
-#endif
-
 #define DEFINE_IMAGE_LE64(sym, data)				\
 	sym##_lo32 = DATA_LE32((data) & 0xffffffff);		\
 	sym##_hi32 = DATA_LE32((data) >> 32)
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index b2988aa12f6645..1786a8e4323b9f 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -56,6 +56,21 @@
 #define LOAD_OFFSET 0
 #endif
 
+/*
+ * There aren't any ELF relocations we can use to endian-swap values known only
+ * at link time (e.g. the subtraction of two symbol addresses), so we must get
+ * the linker to endian-swap certain values before emitting them.
+ */
+#ifdef CONFIG_CPU_BIG_ENDIAN
+#define DATA_LE32(data)				\
+	((((data) & 0x000000ff) << 24) |	\
+	 (((data) & 0x0000ff00) << 8)  |	\
+	 (((data) & 0x00ff0000) >> 8)  |	\
+	 (((data) & 0xff000000) >> 24))
+#else
+#define DATA_LE32(data) ((data) & 0xffffffff)
+#endif
+
 /*
  * Only some architectures want to have the .notes segment visible in
  * a separate PT_NOTE ELF Program Header. When this happens, it needs
-- 
2.43.0

