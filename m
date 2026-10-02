Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010063.outbound.protection.outlook.com [52.101.46.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2990D3C7DF5;
	Fri,  2 Oct 2026 23:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790983939; cv=fail; b=gW7+7jS0ABAFMQ/Pv37f/YusQ4BCER3c7MexWfrwEqXXT3WUJSfXasbeajT0L80Hzbtk5RF+djHXzsHBIteaTYGRoOSWe+nSPauv9OArDIqedLqMODIeD3ly8m1AXeR618Obb2cP/ba0lyNf0J2Q5tUMCF4wqTBd11m6wvGl1c0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790983939; c=relaxed/simple;
	bh=7MdKcuW8aPgf9QhnrbqqBxI/I9VxVWxg64SFMPDBrBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=q8A+XYuOYn8wfGuENFRYS9w5DzoFdT5YsVk7/zGXeZWuk8u+yCqAlaF1B6LU/g5W6ZkMTtLaa7swbq67YY1x7CvlgNTT2rjxeCjqajWsDrFIJqDPKlc2kZqKFrBvgWKU9s4sFqgcw5kLjivp46MxEKKvUnFUFfUiZ8k1+XNkeg0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kvb0K1Nm; arc=fail smtp.client-ip=52.101.46.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kvb0K1Nm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MAGtV+4QBnB1HEZLmF0YCevoE8RqrMr6xRVRasaglHD/3QbBH3Iq/pLCImiB6PGi68KkLhIZBJc9jaT3VXqzHyssNowQwLtrO5lZb2myFZd+2/egPzwLphX25JdZKIv9knIyMiTVqsR6ZUlJ9ltjY4TOZ2nkzYmrfZvIdA3rxER4UAkbHT6xEYQCu8Iv2DkAosfjCbhNc9/KLwMYRIBtPkHB/ncjw5ZG4nmws1iOsGaQKuscFzEW1EuRCB7FTEWU6SHb1ZS2v++s2k9ycXlEYTtVhVuMms0Tamd7Qts4NtATF1QbR7TZ7KTxFGlEU5olFNdrX3gjPZskKYMpRzSjcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b4v3WxPCCelCaNK0V1GR0gNp4BL4soqdp4YaOWdO/+s=;
 b=X9Y97npZRrKR6LBO1SZ2O/PM4dHmf44U1wkqA7iHtPrzGZ9y8I9JEWy1hiOLcvK0C3gwJlTjw/wxBm5kZO3mHAyxuh+pnZRk67OS26ULOBnQsx9e1FWGgf21/1kKrhgGhPDfgv41SOZfg6y/gISTRdy+e6q0dRMXR7e+nYCmoFKl7Ox1Blzr2satl/CA5r0Y0vZaBgtHaDWYcK2k1gxYDM/q8lIRcDt7HyPKgPBZPiTHIetfueqBt0SQ3t86OwFRLslodgH2kD+6+fdV3ts+QK0YVzPMh0c23W+hfF1Rhy1Z6X5lHaLfVOl0YHjw/iNUFC6Lv/6EDI+nAx/K04f/bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b4v3WxPCCelCaNK0V1GR0gNp4BL4soqdp4YaOWdO/+s=;
 b=kvb0K1NmjsbyJ1V7JPVpZJy04bLqX5hLV9GkUyT06Ceyn3zA0wQuqfUJq4cei/MobU2cF+HXVrUxXEb00lhf6RvwXJmmRnMlsykKcYNtgAquZNtrMkNI+LCuu9AbJQFivQBicFqew4BNWwpm00uE+Q+2y8ZgFt6lnw+5kga53B/ckA89hyQXWL9n9VF4k4Ed8I9Rb+bLCLoCIFbqZoPTgSTxMB7wovS3ImJ753v5xD4vc+MHrbXLi5ftKvehVMVkccqyv/K4CNPgvOOMBH0XhGyIQ4wjTQsOAAvsl8bJXqQcNsen3QUcvNMtvLSmFzR9JGS9SS5tWjrWDO9EYo+mmw==
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
 23:32:07 +0000
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
Subject: [PATCH v2 13/15] arm64: drtm: Add drtm_entry point to head.S
Date: Fri,  2 Oct 2026 20:31:50 -0300
Message-ID: <13-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
In-Reply-To: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0P220CA0014.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::28) To LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LY0PR12MB325698:EE_|PH7PR12MB5830:EE_
X-MS-Office365-Filtering-Correlation-Id: 55075d49-4b40-4a76-69a2-08df20dd5940
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|1800799024|23010399003|376014|10067099003|11063799006|6133799003|921020|3023799007|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	e9QGWI00+dZ+HHtU0PR0n7wPuZK3GvYXnR+D/pt6aDQhKbPQAbqg3sJpNoQh42Msp5MSGkHDDZMbx/sm1B021dzSfX5UDNPdOI/HtUyCAQbtz8FkZgLvvlGLWp2tSeIWVkXs3FJoBtQoy7vk6Pjt7cVQGxSo834vjwL4t1yRVcl33GBSy8byuKQRJ3EedcdETLW22u3CJ09UNKnKCZkk1f4FwVh1iJDVftS50FYiDjIF5/r2/ZOm3PsBi/bi5ZR8trfgdT/RdaYLvYq5xwC2LzdS2uXZVg8KBC0IZO/d3VrRzgOlKA5a2ZbG1SMFDwYeg5p6LuqJn6WBvBz9xpU2xob0scGph0t3jOKtSBr4TBUuLoUyLcJqRZLIk4IScIwOkeGrB13QhgYwg1x/581ApCAJRlTfENb9Mkq7bzAG6zEeT/PkGs94D1wnMo2+QMrddObfls1xK6G1OLh6Wsbw96J0UG7UZnHiaRYhztKaJ8a29doCSe6Hzhwl+dPhfp5Lhx+uEM7Hle4RuBw2Tg02CWq64ocn8B6fhRlV4V38pGs9OTSdnFOm7uxiAet9xxvTewFZJ9NMHVMxMZlajmzEZ1s3KhZZbkOtKfgS3oyPPvvAwAoaaR9jQwNKL7ih3hj+RO1oy6rdcwb2gMlYC2pxsQx+usmArRaC3bC9D4oBWMhvMbb/EVysZV/Us5vUle7hgLcb8qOeGwa/lDyjiwoldg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LY0PR12MB325698.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(23010399003)(376014)(10067099003)(11063799006)(6133799003)(921020)(3023799007)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qQQ9/5BWSJeGbREc/MKcxV2HdAiHaUyqTf78kwUfdEcsR5or4El96EdY/skw?=
 =?us-ascii?Q?SufOluUy0/GkQWP9A8QzZD51eUEaA/81hmka5sc3pjndiga2LdZ4VHIMzfa4?=
 =?us-ascii?Q?FO7XnAPVirvFZgS0gMhQc0kae+AlfGj3p2P0qUKkXhwXxAiigd6qO2KZbZoU?=
 =?us-ascii?Q?EjGlkocKyjwa98X896MeIk8Hx/T7OkyRgJHTRyMmTIiU6AxzlG8eXeHvbm2y?=
 =?us-ascii?Q?VTvITxgi/4Zh4z1L6vwdaiqF+SHcbcZvi+7InbUGPDEKmkNJu9Qb8GPmYTFU?=
 =?us-ascii?Q?0sT8avzO922d/h2xs8EFOi7D/ys+yYfafTIWrIOb5SSjN0/7TqS4Hn7u+JiU?=
 =?us-ascii?Q?sZNCGoULH9QBZvEemoWEkBHDKUCMK8Fmax9XMXm3pqyyuxd9p7Vgy6Nsyq1L?=
 =?us-ascii?Q?1BJBxK+tkBY03O3qObA57lFWxBQu330GoJ+y1AGlEsWBU3JCTIQa1OEdAaMT?=
 =?us-ascii?Q?pLOkkG8rXrsKBZJUGvr/NWaFLLVUv4EbVUiF0iVG0QQAMxiUNi1VimhG6ozP?=
 =?us-ascii?Q?DAeEIKt3a53KD4ipe0gOfdHIMnWVUT7t0t1nGuLvUFN7yPBfd9mq9q7qlDK9?=
 =?us-ascii?Q?ajSvl15QATx5c+tWbE11EBrW79KI5avDZDlO1Boo6N+OclCiSFBOTf0slnjp?=
 =?us-ascii?Q?Hlk6zDEsK16s8wjEX8ycgfhZ/5GGXFP85/9V1bMNCdDo0OgqhcKaBUJPsU5o?=
 =?us-ascii?Q?bi32AxeXNV7mW0p5VEQsL9HWBpp72omZFhZUcVch7JgT73YxAgGLr4qfM1sM?=
 =?us-ascii?Q?Xn1QaA62MI5tfoOGgzFG+CC/JBzWAn6He1DMWH3r7nIYqM9C6qBDTCGDTQI5?=
 =?us-ascii?Q?czn6y5DPWQcgrAqOp1goI653VERv++npK1jbDf5RQsCEHxeFW+XTGBZLTQHn?=
 =?us-ascii?Q?LVLuU/OGN3nFE/QcCrHPXae+R0UzS3kcMIvuZhM+qBXjuL2AwLK/r5JUoDW8?=
 =?us-ascii?Q?rmQFa7ZK51SYB9U5/Q6OdJGlcrFQvLbAlReJC4nrwvAl59cFK70WDpbWh+g9?=
 =?us-ascii?Q?IDs6+F3kf8EXhtdZCCgt66KmprCb4RUa8hYhbGRy1XKp4dBNMRwpkkTLvs97?=
 =?us-ascii?Q?h/C8sPsn3+HLPN23K6TTLi5v9xoCVNCnNrMUoHP4fNeA8bNNs9ZIIu4eOH3V?=
 =?us-ascii?Q?6SDkf4W48lonFW1aoXxcT+z6hztBoZSsZh0icaND+IemWTS7Zb9SCpmacHZh?=
 =?us-ascii?Q?ueOIey1YxcoLRkTDjrRSQMxuQRgOCEs+Omtu6LjA/e7RI1iGs7NjuIshV/s4?=
 =?us-ascii?Q?eeV97ZJ4LHpK93RjtWBYFWufbY+G3tLKm3D39pfuEYdLqvTVjwUcPGO/zs1i?=
 =?us-ascii?Q?I50zXvIyDB47fphwycAYQ1Y/HhOQXFqCpnB3FaKRY8JOBfrrjijhbXCiwI8U?=
 =?us-ascii?Q?+q+BGEeZRe3dW1rcuJS+FuAH2xNOcAYFpsmNcshBoeTebmt8xpBrl2bzLq4y?=
 =?us-ascii?Q?SMqJZQumj/dPN+wBOc6vP9pc+UGQ87Uc1vid9PktmEn0jZdnP/7Myx9QSB9P?=
 =?us-ascii?Q?Z6PS2VmXpZBPksuDLJusdTvtdiF2vjDwVfV9ab2LqWTyRa4pyCl6b07uzW1F?=
 =?us-ascii?Q?Tq+Er3ORmSOzSEJnH2FxRY0sUKo+OI4umvwOmDq83IfmQ7RxzMRBemqYHPhj?=
 =?us-ascii?Q?OVADjZ0Dmuy24lgMWWR68RzKaPY80p22CnnQHeNH2uwMHum3SmBRQcAsIDUK?=
 =?us-ascii?Q?yHxJz8uDos8s/ig4COdgsDHAS9tRXnwN7/TmFvzFazKSRsFX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55075d49-4b40-4a76-69a2-08df20dd5940
X-MS-Exchange-CrossTenant-AuthSource: LY0PR12MB325698.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2026 23:31:57.0695
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yxdqLHzicajfIS3QL3ge0iOhHyaENeHpoFI9pPeXi6c9D/KBYS8bB/L6Teaz1h4u
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5830

The DRTM launch defined by DEN0113 cannot use primary_entry because the
spec defines a different launch protocol. drtm_entry is a small trampoline
that validates the DRTM provided data matches the location expected from
the link layout, acquires the DTB through an EFI stub writable handoff
struct and then jumps to primary_entry.

Add arch/arm64/kernel/drtm.c, as later patches and series will need more
kernel side functions.

Passing the fdt address like this will require security hardening in
future series.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 arch/arm64/include/asm/drtm.h   | 20 ++++++++
 arch/arm64/include/asm/image.h  |  2 +
 arch/arm64/kernel/Makefile      |  1 +
 arch/arm64/kernel/drtm.c        | 10 ++++
 arch/arm64/kernel/head.S        | 83 +++++++++++++++++++++++++++++++++
 arch/arm64/kernel/vmlinux.lds.S |  8 ++++
 6 files changed, 124 insertions(+)
 create mode 100644 arch/arm64/kernel/drtm.c

diff --git a/arch/arm64/include/asm/drtm.h b/arch/arm64/include/asm/drtm.h
index 8188af1b582bb3..4a516e00e3a0ee 100644
--- a/arch/arm64/include/asm/drtm.h
+++ b/arch/arm64/include/asm/drtm.h
@@ -174,6 +174,10 @@
 #define ARM_DRTM_ALREADY_CLOSED			-11
 #define ARM_DRTM_TPM_ERROR			-12
 
+/* Offsets in struct arm64_drtm_handoff */
+#define ARM64_DRTM_HANDOFF_FDT_ADDR_OFFSET	0
+#define ARM64_DRTM_HANDOFF_ENABLED_OFFSET	8
+
 #ifndef __ASSEMBLY__
 
 #include <linux/bitfield.h>
@@ -300,5 +304,21 @@ static inline s64 arm_drtm_enable_secure_interrupts(void)
 	return res.a0;
 }
 
+/*
+ * Since we cannot pass a parameter through the launch to drtm_entry any
+ * additional data is written by the stub here.
+ */
+struct arm64_drtm_handoff {
+	__le64 fdt_addr;
+	u8 drtm_enabled;
+};
+
+static_assert(offsetof(struct arm64_drtm_handoff, fdt_addr) ==
+	      ARM64_DRTM_HANDOFF_FDT_ADDR_OFFSET);
+static_assert(offsetof(struct arm64_drtm_handoff, drtm_enabled) ==
+	      ARM64_DRTM_HANDOFF_ENABLED_OFFSET);
+
+extern struct arm64_drtm_handoff arm64_drtm_handoff;
+
 #endif /* !__ASSEMBLY__ */
 #endif /* __ASM_DRTM_H */
diff --git a/arch/arm64/include/asm/image.h b/arch/arm64/include/asm/image.h
index 36afe95ffa7544..4419325cd10149 100644
--- a/arch/arm64/include/asm/image.h
+++ b/arch/arm64/include/asm/image.h
@@ -69,6 +69,8 @@ struct efi_image_info {
 #ifdef CONFIG_ARM64_DRTM
 	u64 drtm_measured_start;
 	u64 dlme_measured_size;
+	u64 drtm_entry;
+	u64 arm64_drtm_handoff;
 #endif
 };
 static_assert(sizeof(struct efi_image_info) == EFI_IMAGE_INFO_SIZE);
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index d2690c3ec52885..bd9a4c5179173f 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -50,6 +50,7 @@ obj-$(CONFIG_HAVE_STATIC_CALL)		+= static_call.o
 obj-$(CONFIG_CPU_PM)			+= sleep.o suspend.o
 obj-$(CONFIG_KGDB)			+= kgdb.o
 obj-$(CONFIG_EFI)			+= efi.o efi-rt-wrapper.o
+obj-$(CONFIG_ARM64_DRTM)		+= drtm.o
 obj-$(CONFIG_PCI)			+= pci.o
 obj-$(CONFIG_ARMV8_DEPRECATED)		+= armv8_deprecated.o
 obj-$(CONFIG_ACPI)			+= acpi.o
diff --git a/arch/arm64/kernel/drtm.c b/arch/arm64/kernel/drtm.c
new file mode 100644
index 00000000000000..14493948a27f0d
--- /dev/null
+++ b/arch/arm64/kernel/drtm.c
@@ -0,0 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2026, NVIDIA CORPORATION & AFFILIATES
+ *
+ * Support functions for ARM DEN 0113 "DRTM Architecture for Arm"
+ */
+#include <linux/efi.h>
+
+#include <asm/drtm.h>
+
+struct arm64_drtm_handoff arm64_drtm_handoff __efi_data_handoff;
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 87a822e5c4ca83..1de5c0628b40fd 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -21,6 +21,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/cache.h>
 #include <asm/cputype.h>
+#include <asm/drtm.h>
 #include <asm/el2_setup.h>
 #include <asm/elf.h>
 #include <asm/image.h>
@@ -35,6 +36,7 @@
 #include <asm/stacktrace/frame.h>
 #include <asm/thread_info.h>
 #include <asm/virt.h>
+#include <uapi/linux/psci.h>
 
 #include "efi-header.S"
 
@@ -131,6 +133,87 @@ SYM_CODE_START(primary_entry)
 SYM_CODE_END(primary_entry)
 
 	__INIT
+#ifdef CONFIG_ARM64_DRTM
+/*
+ * Entry point used by a DRTM launch. Verify that information provided by the
+ * EFI stub matches expectations. We rely on an untrusted-write/trusted-verify
+ * approach so this doesn't have to deal with writing to cache-off memory. Per
+ * DEN0113 R45380, the launch supplies:
+ *
+ *   x0 = physical base of the DLME region
+ *   x1 = offset of thee DLME Data, which is several tables written by
+ *        the launch to pass trusted information to the post launch kernel
+ *
+ * These values must match the link layout in vmlinux.lds.S or the launch is
+ * invalid. The EFI stub will get them from the efi_image_info and pass them
+ * into arm_drtm_parameters.
+ *
+ * DEN0113 R45450-R45470 specify the remaining entry state as the PSCI CPU_ON
+ * initial state: AArch64 at the highest Non-secure EL, little-endian, with the
+ * MMU and D-cache disabled and Non-secure asynchronous/debug exceptions
+ * masked.
+ *
+ * Per DEN0113 R45220 the launch cleans and invalidates the whole "DLME region"
+ * which is everything from _text till past __drtm_dlme_start before
+ * it measures the image. Thus the handoff data written into the region by the
+ * EFI stub is safely readable here with the MMU off.
+ */
+SYM_CODE_START(drtm_entry)
+	/* Verify that x0 is the runtime physical address of _text */
+	adr_l	x2, _text
+	cmp	x0, x2
+	b.ne	.Ldrtm_bad_entry
+
+	/* x0 + x1 must be the runtime physical start of the DLME data */
+	add	x3, x0, x1
+	adr_l	x4, __drtm_dlme_start
+	cmp	x3, x4
+	b.ne	.Ldrtm_bad_entry
+
+	/* Stub must set drtm_enabled */
+	adr_l	x4, arm64_drtm_handoff
+	ldrb	w2, [x4, #ARM64_DRTM_HANDOFF_ENABLED_OFFSET]
+	cbz	x2, .Ldrtm_bad_entry
+
+	/* primary_entry(handoff->fdt_addr, 0, 0, 0) */
+	ldr	x0, [x4, #ARM64_DRTM_HANDOFF_FDT_ADDR_OFFSET]
+	mov	x1, xzr
+	mov	x2, xzr
+	mov	x3, xzr
+	b	primary_entry
+
+	/*
+	 * Can't continue, launch is corrupted, spec says the DLME can call
+	 * SET_ERROR which should forward the error to the next boot for
+	 * display.
+	 */
+.Ldrtm_bad_entry:
+	ldr	w0, =ARM_DRTM_SMC_SET_ERROR
+	mov	x1, #ARM_DRTM_MAKE_ERROR(ARM_DRTM_ERROR_PHASE_DLME,
+					 ARM_DRTM_ERROR_ID_VENDOR, 0)
+	mov	x2, xzr
+	mov	x3, xzr
+	mov	x4, xzr
+	mov	x5, xzr
+	mov	x6, xzr
+	mov	x7, xzr
+	smc	#0
+	/* Cold-reset the machine as required after reporting a DLME error */
+	ldr	w0, =PSCI_0_2_FN_SYSTEM_RESET
+	mov	x1, xzr
+	mov	x2, xzr
+	mov	x3, xzr
+	mov	x4, xzr
+	mov	x5, xzr
+	mov	x6, xzr
+	mov	x7, xzr
+	smc	#0
+	/* FW is really broken, just hang. */
+1:	wfe
+	b	1b
+SYM_CODE_END(drtm_entry)
+#endif
+
 SYM_CODE_START_LOCAL(record_mmu_state)
 	mrs	x19, CurrentEL
 	cmp	x19, #CurrentEL_EL2
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 5c14decf0dd4d3..880d0d0911b110 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -303,6 +303,8 @@ SECTIONS
 			EFI_IMAGE_INFO_OFFSET(__drtm_measured_start);
 			/* dlme_measured_size */
 			EFI_IMAGE_INFO_ENTRY(__drtm_measured_end - __drtm_measured_start);
+			EFI_IMAGE_INFO_OFFSET(drtm_entry);
+			EFI_IMAGE_INFO_OFFSET(arm64_drtm_handoff);
 #endif
 		)
 	}
@@ -381,6 +383,8 @@ SECTIONS
 	 *   DLME Region Address = _text's PA ie the start of Image
 	 *   DLME Region Size = DLME Data Offset + "Minimum Size of DLME data"
 	 *   DLME Image Start Offset = __drtm_measured_start - _text
+	 *   DLME Entry Point Offset = drtm_entry - __drtm_measured_start
+	 *                             (in .init.text)
 	 *   DLME Image Size = __drtm_measured_end - __drtm_measured_start
 	 *   DLME Data Offset = __drtm_dlme_start - _text
 	 *   Normal World DCE region address = PA of __drtm_dlme_start +
@@ -467,6 +471,10 @@ ASSERT(__hyp_idmap_text_end - __hyp_idmap_text_start <= PAGE_SIZE,
 	"HYP init code too big")
 ASSERT(__idmap_text_end - (__idmap_text_start & ~(SZ_4K - 1)) <= SZ_4K,
 	"ID map text too big or misaligned")
+#ifdef CONFIG_ARM64_DRTM
+ASSERT(drtm_entry >= __drtm_measured_start && drtm_entry < __drtm_measured_end,
+	"DRTM entry is outside the measured image")
+#endif
 #ifdef CONFIG_HIBERNATION
 ASSERT(__hibernate_exit_text_end - __hibernate_exit_text_start <= SZ_4K,
        "Hibernate exit text is bigger than 4 KiB")
-- 
2.43.0

