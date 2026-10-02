Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010063.outbound.protection.outlook.com [52.101.46.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE2D368D76;
	Fri,  2 Oct 2026 23:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790983929; cv=fail; b=IohmfiVgFKAp8ke5ByHQxlFFPc6L8UrNzc1oddbhvR9US0o3OIU3oaaUdbZ0FydNKEuleCGQDeIxv6REIRq2owB8HNt9yNkWyi+eOP0aUuCyAuVN+JR1QkxLSXafyagsm1kJNqbYWTlpWPc+aR/xQ7z1r85cP/60CCE8DGRKzPQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790983929; c=relaxed/simple;
	bh=p5FrrQI5O+Ws6QHIlkTmFVBUkQV8gJxwkoNQPbqGmq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WW3KYwNeiLZ/PTgd7K2PBsBlST/ZA8SpLyMemNkSrmRBxmIZBm+/OxaCPxwukIxi45mT90sU+3ftsANZH8RjCZh/0fu9K+yESmmpTUjfGUkvB9Afmktt8xMvlrMNm2Oz7lsKNXeU5XLmSqXiFZyVnxYtpqVelHh7nu51rp9UFJ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZQTqsEmk; arc=fail smtp.client-ip=52.101.46.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZQTqsEmk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ihS2u4GzeV8OZOlc5IwStkkr9QRhwzX5RkX8QAwgl2R4k2Uj1konDO17IIhBIVp4MckIp9N4WITTIjGhLNz0IZ0St9DvZO42+ZDfHgyGTThbY6zDeqnZ+VThTm4uS5JM38WYk4grbQEdvWun7qAkfFLRhnVgAIaU8l9zJkJRsVhYlD2Mh1f5znh+yVXSP60hfVCJasvXt7+QOSzmcaAYP99tCuVmLMRIFKNgxfu4sZ5H70eTg2lBa+m1DUPcVQSpA5qQQopJFoJ9MrQSvsH6mvIzQXLGWPxFWnphGlEGcTlwnPqda3Q84yvR8Y0PR4oJ3pGHtPTPsXEQspZYIYiJ1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mZy3SwrIDwhjOhBOocx3KxjQM6jYKfDUWVDywf5K+uk=;
 b=NojwbY185tTrJyLRAednz8HQd4ZhQz9+aQgdAYmkn3IXaBdWowHRoz3LEntBSR14YZvNaGHSl7aPYqMJit46fsS+mFXYGZz79F3Bv4FaN1UHI0niBwNaqMX/KexgOTgh8sODLd4tPQZe+Ml9qhROHxeOY9fBWEq0mkB+l4EdY892URvlKqK3hGK/+LjmInpBYYuu0MVNfgCTyXKHjMNwEeKReGNeZL2b1UCL1AWip7ud2GZQPzINnQnHACFZPpw3ENlHSLi9AsIIwQqRQzL1ZozJVLWit0xUyK9XED8HTk1rWYGCw+BnrN0tZKEI5muGAFNqFHwCle/EiQU8mAVHfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mZy3SwrIDwhjOhBOocx3KxjQM6jYKfDUWVDywf5K+uk=;
 b=ZQTqsEmk8DV3Gl3/kcGd7XZXLYBynf7Lo3c+BxUNEPye89lAbPgQMIcnPcl3XK01Jjl8G2a/HOO0LqJx8mUcW561K+CQgoWul/OUuuupebFunGq+aTfpe31mPTNGuksZzRBxcfPaMRD0w5a/uWXD5O06EEbs+S87/tFIJ6/QQZ2IDsGJYpJ3By4anHGXexElk9FnI+GYgTO2BsmyQJLzeZIKD8oKwqxeMYCUNrRaY2sBqsXbPeEC3++xW0hyh0K8C76ELgJPudbqSFPhMxKbBLCWpAgpRrBQ8MR+VoLixU/DpY/uRWx9lQIOz5FF1rolRC9KUZY05rJ+BKTAlzu37Q==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14) by PH7PR12MB5830.namprd12.prod.outlook.com
 (2603:10b6:510:1d5::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Fri, 2 Oct
 2026 23:31:57 +0000
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5]) by LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5%5]) with mapi id 15.21.0472.016; Fri, 2 Oct 2026
 23:31:57 +0000
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
Subject: [PATCH v2 15/15] efi/arm64: Implement ARM64 DRTM in the stub
Date: Fri,  2 Oct 2026 20:31:52 -0300
Message-ID: <15-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
In-Reply-To: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0069.namprd07.prod.outlook.com
 (2603:10b6:510:f::14) To LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LY0PR12MB325698:EE_|PH7PR12MB5830:EE_
X-MS-Office365-Filtering-Correlation-Id: d6c3017a-ecdb-42e9-5d92-08df20dd57ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|1800799024|23010399003|376014|10067099003|11063799006|5023799004|260925022911599003|260925021911599003|6133799003|921020|3023799007|56012099006|260925021311599003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	uT84nQbLh6aHOcukOGagEWvUx1J2iDbHh9cX2VE1z3FAsd5gxRIv5ggcOtSHq2icLCk6npRbcFd1Ef0PVl48XIeYAcSGnQdzqNvKyPVwOV2uApiu1OPcMlWJHMEnYOAdUfVFMI5D0vHzog7egOMBAFI1XD1D4POidu1mtKDdNRNbz0ekkRVeeGGdTdg2GongEDycHPxDUXXm7KuXoI2esMdNFwyYXDCDr1VKzN3h++OIJjRoOFtsVbMsYu4wl2cSdqgh61xzb9TUjwffTJqYvSXVxix7dstsnUyWhQU2NnnT3rdkQC5z48ow2A+Lbw2jp1ZWRlmS/kVZxt1aihP1kcsva3hZ+xaPxviAo7Lb+0n5koFGH2ahKDmEs/kQP5Ht7kNWPUYmx2EB6gl8KLt7DtZfRMXhI2tl/dab8IjkuLpSHHGse4aL75mJShSCRZ4YE6JDoxVfbl0nWNugud38TIWvzn146IdgsPV+JrUafhNEX48JkrFUBSbyyBzQgnOb903oECHgDSOfpCLVmtX/MQoxjirUULtypTP4Zkd5JXWtZ6zPOdpxMXG0MSoZJtY6/gopEceSBtTlzJkhB0+CW6M0ur7+btF9jOWhdEEVms+Ry96SU+4bocHoXLeU1FYIjX1q8ziwzSc2Aj22NrVlbWGZdI4Z4BEiYWRkpXQfh8UYtw2vSgPa8ZGd807/QKDGhbIPTaviL8X1QVM7oSdhVw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LY0PR12MB325698.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(23010399003)(376014)(10067099003)(11063799006)(5023799004)(260925022911599003)(260925021911599003)(6133799003)(921020)(3023799007)(56012099006)(260925021311599003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2bPyAbYFD6qt/igIDU+xsyxTMyb64knvHtwl7ldi6MON1xs/jOnmLR+R53Ow?=
 =?us-ascii?Q?akesZJsdZd1q5UOoBbB0b2uviHpk5+i5PaGTgN4YRuKzvZN3+heIYVGRHQUl?=
 =?us-ascii?Q?ybxNTPJGmzWVy6V+oRywiP8h/xOjahKTnhABnx3XEnCq4cIiVP0kot71Wr5m?=
 =?us-ascii?Q?cfSHIj9ZEQTLWzexQBI63jMcsPB4oQS1gx33ixP2OpaBY3cEAaFcOO1hYC11?=
 =?us-ascii?Q?wfYNiTAfOUsXT2P99feAUrbm6+Ey4VZiv1YJn+BjqR7X2/dTuwdhzjhG+mKH?=
 =?us-ascii?Q?nyHvs1DnHlmFqUz4K16cRG6nQ6pY8QEcFLJ5jpUrGUHK749PaqV/PhLb1xTv?=
 =?us-ascii?Q?4PC7+DKHlpqvODSxl+PL3bFOxTUA400G6WFKn4Yg1bhgU1r66tMxVh1a9Hbl?=
 =?us-ascii?Q?95IxVP6677RdG2B7G2wLoKywhi9OSrUu7U8tWBN99fXzzdIlGjzWmNtQraJf?=
 =?us-ascii?Q?e5fFDDlfLlfR1BkaMkS+KUQDf11L6Ou1zw0x9QjssPojkjkHmLrMX4yPrwnV?=
 =?us-ascii?Q?HaEg4aG1E9a8pj1GIKQ98eU2gLEPKuA/jbJLywAzBmKljTjyicJ2ZLve2ZEY?=
 =?us-ascii?Q?hyMaBe1AsrH8tX4n+GkZ27IQZ9qbUFhoREvfMRL8Ns/wU9rjKa0CBVsYpaJ1?=
 =?us-ascii?Q?Y/98FiV0sk/As+3NZjncC0e9HqkuwVtUT4IZe00J40fRg7XqCRwsfn1rBJzZ?=
 =?us-ascii?Q?Nf+Fk1YAH1irL5hXTiFf+jCoJjieb6DJxtfsgpMxX2lmdhBewrcUmJPk/UlM?=
 =?us-ascii?Q?OjreDpiupKCuSR7HGLIn5UlC2KtevWPDd2go++NIwjCSnqdyfurUzs4CyKi8?=
 =?us-ascii?Q?5DnxweIlKenvZ7sX2ZcyL3hn38vrgumy+HSHQytJc94WOAVlUU2nTrVATaSZ?=
 =?us-ascii?Q?2NVJGIkq1D5F2eYhzYBPVByfdxNLiN5CsUVXXROqTXwDsby0xaK2CtCdDn4v?=
 =?us-ascii?Q?aXZnPnsAWiRI4Nd39U4hs/UCb7mgdkXcSW4rLuji5od33MYTceufByUhErkN?=
 =?us-ascii?Q?JyodIPCtXn/4ovy8epDa9zpJPDbs2r/NFVu1v+/4Auxp/jfbyfjg6ivBmGY2?=
 =?us-ascii?Q?Wk6z/b8h1tX/0tbe3koIiHsyaLuitYFTV2lawMs+SH2retqL59t9yMkRJAXZ?=
 =?us-ascii?Q?/7C7oYAlUQL40iDhBqdRzprc0DKrtGj0Av2+3JY9yvPmuJ7gUVgMhaZ0EBs2?=
 =?us-ascii?Q?IwYfA7VZjK3h0wYVc+7USHkyg/UlZhnMvFGmx1R4ctTmFnNP79xrn8e16rz1?=
 =?us-ascii?Q?TgalzAqbLsv5YN3S71k9bXmgOo2NxV4jL/ZbPKX9Fz318AmPBn9bAtcM/0Ro?=
 =?us-ascii?Q?1DQ4exeJlhmacv0yKKIoCJFUpMvA6uXQcVM71BKuVxEYst/2FvsXxFutMRKi?=
 =?us-ascii?Q?xdy6wTSwmMZQmpNKrxHBDhrxOr1SZvroyYtts5yuYPsOuDDbUolvWsLtHfEH?=
 =?us-ascii?Q?GcQIw6AcWFJDpMt4/QXoI+3Q/Axm7x4zaytN60j2EhMMRH7ZKH+LClDyvgZB?=
 =?us-ascii?Q?gVcAKflt23k0h5fwPH6FHnle0XfUPREcHNt+EXseeBrWJ3s2uTBT/pInJRL+?=
 =?us-ascii?Q?hm/iKfmOTj5useXiP3zLbyUKRDHmebrvyGh2leFVHNscaOcK5oYylp2I9XNZ?=
 =?us-ascii?Q?ggenZb1SWqGZxlNU/6FgSXixvyTvq64nlrOLmL17Sz1i4I42uEOrnYsYzrFU?=
 =?us-ascii?Q?AUGlfy+5N4YdHbsWl70r9iTf2Y7Lut4WkfYC7xM56Fu+9+Bl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6c3017a-ecdb-42e9-5d92-08df20dd57ee
X-MS-Exchange-CrossTenant-AuthSource: LY0PR12MB325698.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2026 23:31:54.8074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 63QIUYr+4jLWlu1lV/wMD0+JrPpPslENYGUXGcfdeN06vscg9FRLntqBAj1SkwJD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5830

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

One nit, if the platform does not support SMC then using drtm=auto may
crash on the SMC op. As far as I can tell there is no way to discover SMC
support through EFI. Learning it from the ACPI FADT is doable and costs
about 250 lines of code.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 arch/arm64/Kconfig                        |  16 +
 drivers/firmware/efi/libstub/Makefile     |   1 +
 drivers/firmware/efi/libstub/arm64-drtm.c | 426 ++++++++++++++++++++++
 3 files changed, 443 insertions(+)
 create mode 100644 drivers/firmware/efi/libstub/arm64-drtm.c

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 4a752835ce1116..30244bc2d57696 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2543,6 +2543,22 @@ config EFI
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
index 3f1921e6c334d1..f0958b4df16592 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -83,6 +83,7 @@ lib-$(CONFIG_EFI_GENERIC_STUB)	+= efi-stub.o string.o intrinsics.o systable.o \
 
 lib-$(CONFIG_ARM)		+= arm32-stub.o
 lib-$(CONFIG_ARM64)		+= kaslr.o arm64.o arm64-stub.o smbios.o
+lib-$(CONFIG_ARM64_DRTM)	+= arm64-drtm.o
 lib-$(CONFIG_X86)		+= x86-stub.o smbios.o
 lib-$(CONFIG_X86_64)		+= x86-5lvl.o
 lib-$(CONFIG_RISCV)		+= kaslr.o riscv.o riscv-stub.o
diff --git a/drivers/firmware/efi/libstub/arm64-drtm.c b/drivers/firmware/efi/libstub/arm64-drtm.c
new file mode 100644
index 00000000000000..2fc58babc3e7cb
--- /dev/null
+++ b/drivers/firmware/efi/libstub/arm64-drtm.c
@@ -0,0 +1,426 @@
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
+#include <linux/sizes.h>
+#include <linux/tpm_command.h>
+#include <linux/unaligned.h>
+
+#include <uapi/linux/psci.h>
+
+#include <asm/cputype.h>
+#include <asm/drtm.h>
+#include <asm/image.h>
+
+#include "efistub.h"
+
+struct efi_drtm_config {
+	u32 launch_features;
+	unsigned long dlme_data_size;
+	unsigned long nw_dce_size;
+	struct arm_drtm_parameters *params_addr;
+};
+static struct efi_drtm_config drtm_cfg;
+
+/* True if SMCCC 1.0 or later is available. */
+static bool efi_arm64_psci_smccc_compatible(void)
+{
+	struct arm_smccc_res res;
+	s32 status;
+
+	arm_smccc_1_1_smc(PSCI_0_2_FN_PSCI_VERSION, &res);
+	if ((s32)res.a0 < 0)
+		return false;
+
+	if (PSCI_VERSION_MAJOR(res.a0) < 1)
+		return false;
+
+	arm_smccc_1_1_smc(PSCI_1_0_FN_PSCI_FEATURES, ARM_SMCCC_VERSION_FUNC_ID,
+			  &res);
+	status = (s32)res.a0;
+	if (status == PSCI_RET_NOT_SUPPORTED) {
+		/*
+		 * SMCCC_VERSION was introduced by SMCCC 1.1, so firmware that
+		 * does not advertise that function through PSCI_FEATURES is
+		 * using the valid SMCCC 1.0 baseline.
+		 */
+		return true;
+	} else if (status < 0) {
+		return false;
+	} else {
+		u32 version;
+
+		arm_smccc_1_1_smc(ARM_SMCCC_VERSION_FUNC_ID, &res);
+		version = res.a0;
+		if ((version >> 16) != 1 || version < ARM_SMCCC_VERSION_1_1)
+			return false;
+	}
+	return true;
+}
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
+	if (!efi_arm64_psci_smccc_compatible())
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
+efi_status_t efi_drtm_prepare_launch(unsigned long image_base,
+				     unsigned long fdt_addr)
+{
+	const struct arm64_image_header *header = (const void *)image_base;
+	const struct efi_image_info *info = efi_get_image_info(image_base);
+	struct arm64_drtm_handoff *handoff =
+		efi_get_image_symbol(image_base, arm64_drtm_handoff);
+	struct arm_drtm_parameters *params;
+	unsigned long measured_offset;
+	unsigned long measured_size;
+	unsigned long image_size;
+	unsigned long dlme_start;
+	unsigned long dlme_end;
+	unsigned long dce_end;
+	unsigned long entry;
+
+	if (efi_drtm_policy == EFI_DRTM_OFF)
+		return EFI_SUCCESS;
+
+	image_size = le64_to_cpu(header->image_size);
+	measured_offset = info->drtm_measured_start;
+	measured_size = info->dlme_measured_size;
+	entry = info->drtm_entry;
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
+	return EFI_SUCCESS;
+}
+
+static void efi_drtm_fallback(void)
+{
+	struct arm_drtm_parameters *params = drtm_cfg.params_addr;
+	unsigned long image_base = le64_to_cpu(params->dlme_region_address);
+	struct arm64_drtm_handoff *handoff =
+		efi_get_image_symbol(image_base, arm64_drtm_handoff);
+
+	handoff->drtm_enabled = 0;
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

