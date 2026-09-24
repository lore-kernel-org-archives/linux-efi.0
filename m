Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010039.outbound.protection.outlook.com [40.93.198.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D0D369D61;
	Thu, 24 Sep 2026 13:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790258017; cv=fail; b=i3aDcSQQJ22+YKGoGupNljBC75HFCxD/CxR4Aq+JhE0HIWZ2+G//pvsf7kHNOOdIoijfj4TdWVyPL+2bheN8ohL3Y3rDtArsLU4kjTW7qZHBfvQ2rt2utY/6Bo/sClJcJH6YTyZVoHXBypJumyLHUhoJXH3Ym40Eyy5Gzp3Tjdk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790258017; c=relaxed/simple;
	bh=mAa46U3PHzQlF5iZeoZjjpacWNJov/IFYnaT3vhI6wQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lCw/ONuS0CS8IOqm3p7gojufnZXy2l2A78JfIAh9887N6d4qFPMnn0NWksr0OyXHUwfIgssO10K/4z/38aVVasHtluR06mZCCouEHlMsVrPtg+Xtz2P1en6lFUGz1PrLpKYmhlSLd/2fPGW6fO9D5LrRDZ1+vT+9E3u7CmjPvCs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oAxh297B; arc=fail smtp.client-ip=40.93.198.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oAxh297B"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h2Kv7wzT3Nb0bT3LnzBVH+jf4gxvOxozJ82kLVIxCYUYbmMqGplXrwWhpuCsjB+j/FHrKtu//NqB4zkjn1H8SeYsaHw4ZpMcIBjILS/PFmBze/7jf7qMDJI/Ajs+XjGqhcwMgcUCVIpwEYLuUGYbvy3zkFvRGSUHN6zMWkoGB3hvOf35xgG6zPyRzlRV3iFHMcsvxkMscfeTIXOl5mt0agDXUz580z7njED8wths97nKIzUms6MkmVWbhePeuI7D8o2Riy80j/JV9C7faFbpqLuV+ifeYUvbhK8sSM+lrwfK7uLDyPut0U4+yrZbGIvGPyH0dHG3WSgrUExqV1xycA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aapMoT7FznaxLNFxnISDDddnIRi5cpTTpfVbn4V7PfU=;
 b=P+ajk0xEW29XREIv40yMAekxiUELhhcVjV51BbCXpLaJrYq3KpfzZnCtYkpr7nGRbm+2y9cTmCXhskkpqnxbVwEBHtIwP9oLyi6KdRnXi4SGWfMhKFh5bMBiebDygqe30pV5H7EGNnx+cvzPR9SGeIXoH3mDXa0B6sXw0m1swr/0RnGSNWhpXpksErJ/WnlNlpS007lgen4oIHzkYviQPtXdrw2rix4EBwWUW4IxRPeMyY57Ue6GLxjNk75fNy1wKrH+dxHcugMg/ksKJcYODzd/Mf4CuIUYR80ld0U1vg6aodNi4CRbycImHp0YbpX4ftjCayjj75og2lUb5UzNsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aapMoT7FznaxLNFxnISDDddnIRi5cpTTpfVbn4V7PfU=;
 b=oAxh297BhQ48YJE0TvclC/ZfvOlf2ufIkTGMOqkqlBUecZWjQ2zyZapBKtHifxf0z1P719TGjDfsfgQgi8TToF3GwLxaaYttgOLk3BBWMqoKt7lXERqDmvXGA1DYiLZwPN1KweAyABDO2uamGyqvmC5UwOopisjDda5v/3MHr7vsjchZZFvRYMxWMTkWQCsEKWnAry8J1Sxgxag4Hk8NvqjFBUpLxJMriRkKI5qlC04Fbdbw2msRTuK8SQpZEndSkR4UYleJDMEumGqO2uOPZojocTUGcVJkg0YElpwUUyMp6BZKCN1mkFj3tYvUuvtEkJMZl/mZVnIk81/fYg5ZWA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by PH8PR12MB7375.namprd12.prod.outlook.com
 (2603:10b6:510:215::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 13:53:23 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 13:53:23 +0000
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
Subject: [PATCH 14/16] arm64: drtm: Add drtm_entry point to head.S
Date: Thu, 24 Sep 2026 10:53:17 -0300
Message-ID: <14-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
In-Reply-To: <0-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P220CA0095.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:32d::24) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|PH8PR12MB7375:EE_
X-MS-Office365-Filtering-Correlation-Id: 615aa17b-223e-46f9-63fa-08df1a433230
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|921020|11063799006|56012099006|10067099003|18002099003|22082099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	Sezrwd5yGf1nCBBT/dshXOI8+WpMB1Dn7HNMwIW/jebg+wZcaxESjQWQ1kn7VelZmeRCj4PmhF+84Tg/TAiAI9JHMcTKFk4Ui3QibUUXShu4SirmlOVnkYCNVUbXnTTlNBA0Ir59F1ppHQjMFXMSKLPWcA2g1Lc7IVysdBdUH/j1NP4AvP9JoRRnCVp+HK3unZzWhuhJBjdn67uiTzR+FMmSlPbmLQPgw/UJxhNYDUKiGsEb0lEiiMtFyfgvnvKBVxCmef6c83FxwenK6GnnjvIkFOdV1RsopijYVJo5sPoVdhNSw9PHYQG6RyXD0OvgAhbKs/SB0+Ky1k4H+KhuJdHwdtPHbypkzRf1bXA/u+ezhylgi5Ai/kyWGFeZuvY+pZp+gMrxdET3QmDDRGq1j+OFT4BhUYN1CyEMod0HPqU9sgJzUFYvjW5xUoOFq7EtcZmIAi63mkrYqGVYHcQ7ioQQmrD0vUsi4AB9ml7OjFPBn9S/8JI+KcRz6Zt+1uxc7RzT374BmWn8EJyNAiG+nhTURbngzkZYya92n3/X7yzlgy/u+jpET0RGBCy0n2La4cy5OfkMLAr/z1x+esHkcHJcdjuQgQthTGme32CBng06Rsa0Gj4NL9IuIZvz9rNMH1cxWV9+PA0nRuS02FIvxLicqdmjBcON2HUpS7G240gJxPWS8eaItjRs78sAEGieoYGfnvsxJZAdHsbTNiKiyQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(921020)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ofZQPxTUVxA85ndzZgQLLoJfbcFOXygBZ9GNPNo/krYwLcu1/ChmagCzn7Ns?=
 =?us-ascii?Q?vvz0uJb2Q42GpkXd6Sky8NgTtdPl+AOJWu+sEeQjAIisCf87IvdB7o/LxaY2?=
 =?us-ascii?Q?iUwld+Gk1kiIa/DtnpvXI0H5VugPuUK33I53f2Ord9abSybBTsYrhnTRBksm?=
 =?us-ascii?Q?Jfbrc4Pi7TVzauIFmsKHfntAD/WZC2gWYk50cL2ORj+QCxAy4Z55T55fqWFp?=
 =?us-ascii?Q?0aiM1vN6T4qbiVgFGXqMFL+V479GVySbFHgd2ATLF5Wk+TD5t4dAp1KiEIcc?=
 =?us-ascii?Q?aiO48J9giPfSilrL6niao8VdCpXdFw7eUu8GVbqZW/Ab+Ixtxik0R8AZg3oM?=
 =?us-ascii?Q?UMRo2t4S61/+zpCbutGUA8dlutleKKjgt1/WDzeeJZ7wSC+Gr7NgqkcTNbFL?=
 =?us-ascii?Q?W+fWyZY7RDGYunfv9qw7gIXu0eU1Wln6pORpxKsUqInzlYyqGqRlHpJlTFsL?=
 =?us-ascii?Q?ov4R0epLmWor+KQxWeZNC7n3GrvaUQ0jDBCdSylWxWRwuBOvFMbtL3L9rXr8?=
 =?us-ascii?Q?J1dAhXNqWqlYBqZG0O4x13GKJjx+MCQATSqWYSwcFC3BHqLQv80Atlz475yi?=
 =?us-ascii?Q?p/wS8VoGdIXmtl85lUMrOSj3PWLVYGYhqGSw1zFqpR25nXQvWukY63JjSLtU?=
 =?us-ascii?Q?8zlqL0Mu5kD5pp+gcJu18MpinAjvVvrexTvVg3FwixYxHQrtsdfd/W08xLrL?=
 =?us-ascii?Q?vFp3C1iOxdiyupefpz9n0SnsRy8c7dTFQLC13jP/ni8A1yiQFOMiWIpot22B?=
 =?us-ascii?Q?O2mayZDnJDL6g3wmpFuTsWSJixDVIq+4XNe3hJrrnRc4ZQe7W548vE735k+q?=
 =?us-ascii?Q?fNfOMqHSjWUi0wJjtqnOL9TRgSOevwGQW6j7g5eq4zSqvTSCTiWzMmzJQSBs?=
 =?us-ascii?Q?mypn96y3esfS2UN8mJXw8AM88/umjY93eyasz8yqU8xwVGjN1Gb1CM0ACqW5?=
 =?us-ascii?Q?4upignANdFZKSjSQHWBB1dJ4foK+R3oGsqOsk06EEBhGYPU15kmtYu75Y9Kd?=
 =?us-ascii?Q?N5kaiY1iSzph8ycMjDT0ibC9aYthfAyd9zXGKXnkpAYgGkaY0rVf7YrSqQVU?=
 =?us-ascii?Q?5qrArl/BbuDY5hAeuEGHTOUcfJtrsv9Npl700Urwy7422dm6eKY6dMSP8YST?=
 =?us-ascii?Q?x4CjCxhvqbZUJnhOYlhfWq92GBaZGihDzK+cPME40LXE+Rqv/L/uDdDv0g/7?=
 =?us-ascii?Q?z17G0IfeqD4pod3L6aO7dtcfstc9rReYeWEBmAD6zUShwzXlL00fgUCYeOmX?=
 =?us-ascii?Q?QUeoM4u9yesSfWbO49GalZ/lZtJMv7Y5VlGiwKQQYvyrDzG/L8fEZL/s4u3p?=
 =?us-ascii?Q?NiNr7P7F9FIFMXX+LYTMXpUcOEFWO9OOwgkMckLt/8XClRwUNPSD/hwOmb88?=
 =?us-ascii?Q?V7g/hpmFP0bVtFvJmWSxz1QZ+gs7OFEMY3pa7p9oAriWiAx6xrid9TklEtNF?=
 =?us-ascii?Q?bQc4p3f2AcGzaGOCyubYyxHpJD9ff3VMxaIZfRul/vtCsWqBo7xCGEV9CW/k?=
 =?us-ascii?Q?MhoNXtpkS8uXSWEVeMI1TpIGSIlftri3zeQoW6USVHd8uCcJoN332Rla45iR?=
 =?us-ascii?Q?5pndqIv3wbajfjo8rUyKrs6BR8cH0gkNmMqqYhWOjLiHJvhz4zv6RbrAOEbR?=
 =?us-ascii?Q?U3eeWor8r56086RMT5pIb4dP2Y9llieXRIbplgor+ea5I8f6PMV6WKEyxH8v?=
 =?us-ascii?Q?5ho3HuFcRAzFhzcd6YoS0UijwxsPX7LXONG1leutwcHhWLuX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 615aa17b-223e-46f9-63fa-08df1a433230
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 13:53:21.9205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YLriA8hsSNvjc18MXZ3hhD0elcbwpfdrSpBq81tGlGAULkcQ7tNK5Jdk7pq5T4iA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7375

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
 arch/arm64/include/asm/drtm.h   | 19 ++++++++
 arch/arm64/include/asm/image.h  |  2 +
 arch/arm64/kernel/Makefile      |  1 +
 arch/arm64/kernel/drtm.c        | 10 ++++
 arch/arm64/kernel/head.S        | 83 +++++++++++++++++++++++++++++++++
 arch/arm64/kernel/vmlinux.lds.S |  8 ++++
 6 files changed, 123 insertions(+)
 create mode 100644 arch/arm64/kernel/drtm.c

diff --git a/arch/arm64/include/asm/drtm.h b/arch/arm64/include/asm/drtm.h
index d6dd04a4ebcea5..6c9ded836cb03c 100644
--- a/arch/arm64/include/asm/drtm.h
+++ b/arch/arm64/include/asm/drtm.h
@@ -82,6 +82,9 @@
 
 #define ARM_DRTM_PARAMETERS_REVISION	2
 
+#define ARM64_DRTM_HANDOFF_FDT_ADDR_OFFSET	0
+#define ARM64_DRTM_HANDOFF_ENABLED_OFFSET	8
+
 #ifndef __ASSEMBLY__
 
 #include <linux/bitfield.h>
@@ -192,5 +195,21 @@ static inline s64 arm_drtm_enable_secure_interrupts(void)
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
index a4af9a94037bfb..bdf4b655f72b1d 100644
--- a/arch/arm64/include/asm/image.h
+++ b/arch/arm64/include/asm/image.h
@@ -69,6 +69,8 @@ struct efi_image_info {
 #ifdef CONFIG_ARM64_DRTM
 	__le64 drtm_measured_start;
 	__le64 dlme_measured_size;
+	__le64 drtm_entry;
+	__le64 arm64_drtm_handoff;
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
index 87a822e5c4ca83..6ffe5b4537c7d9 100644
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
+	/* Error ID = Vendor-specific Error, DRTM Phase = DLME */
+	mov	x1, #((0xff << 3) | 5)
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
index 18d9717fb26741..dc8ab58c933009 100644
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

