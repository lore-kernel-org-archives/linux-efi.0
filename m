Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010039.outbound.protection.outlook.com [40.93.198.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA88369D7D;
	Thu, 24 Sep 2026 13:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790258021; cv=fail; b=bg6gXObBIk6evdCmT+OSZjQWh3sjabGAlajeJnp1TlVC8tjUgR4sNpO+vQteiItyxp9G7+p50lQQaykJeQe4KC7rJ1tc3KpPRQJFv5wzRX7OtWUmIgRLEi0UnGGzZWI8tZ+dOasKO7BxfNB7+8GCeDxn7nKBXovlejuVTNab41g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790258021; c=relaxed/simple;
	bh=fW46Ui02+ouUouVtWWnpGLMP1cD19w34K2xm6mbaa54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NdQw3hzP/J5McldZS/7LYlVIZrF82gFQegjfFDTddzNDyAZ+EGFClnZgXBCxoUzYuTok4AuP+UHzqDoxMhNo8Ss5g+7mQMQfwzTdcLFrDaVQ9Vxp5eyyUsUbymzTCDCEgC8LIFRNWyuzgpKXgiQ6M0iDkytQx2W74rNegQ9ihdk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fHthSlXO; arc=fail smtp.client-ip=40.93.198.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fHthSlXO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LTViPKuUo4wyW9oNzJfHh+fl8MR97zN7J3y/r7ynCfZ2Tmxc7XmmyRIIONeZxUnudQvRDAvuY9RnrfafIUaxiduHTSAgGaPyAW5sEiTeUUrAL53tm3O/netCIw1C6CUtCMyX5OnBxeTmyJzXhBOnKy3zKMTAWv/cvAkHtfUsIfQ3hB8iobonnE3SvQltVn+ROB7VDqt5e3ahkcnK0j1+JunFtvqxcBPQjuMNaZP2Avz9IiZKuFo8J8no2tj0DwJ2lp1EaOOOSvGStltVEXfoO1dFUD6z89/6CPZhopkwGYS/y/VUqpeqAzJWRSj6z8Bn0D7+gXQBSchSWMI0ZmeMWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fUJIt7xciJNaxRmrzjtMunI6FdAJopWIAy6bzI2ldOs=;
 b=o3GWa79hej38839f5lIWxZC/PcWN7pfK5NTGQ4Rqg1MgT4daPkG9H3demNWTUmtiYqp83eCXuvOfFkX22xY1eGUW84MqAoDZsCoPzt/6itnCJSF3L+Q8t3Bx4OA7mDScplZgkWNmhQI10ARYTiAdE7vAQT1TvS+kOu++LPdbktm3TF7QE9zKWxDHkszFjRxb3Bp1mzWldJd0YZ5Dj/AJW/PFU2rcpCOM3CiC908KyPH5ea90d+MzD9G9eQxcUYuvE/jTbeRwdO+t+AaFt1DzfHI1+aKHXjsln/oYn32L1VYQYemaRS6fRpWDLs26fx491m5rQZ2kFGbchRj75e1xIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fUJIt7xciJNaxRmrzjtMunI6FdAJopWIAy6bzI2ldOs=;
 b=fHthSlXO9jCmPQNcowK/9CDfHSmX14KFxdNN4U9hcPP9BairILJZ3BNujf5LCMVNMrX7EQdsgFHgMNRRc9RASM7+AvvnPBVEWppWv48Tf/m2fCCbt2xeyKzK+hli+nZrnk+A0/f9VE8R4s1X+oNNjFoPM6mJPMeRJReDVwb3P51ZJTN5WMUFFMRLic9nR+9apwuWEoNPAj9ZFJe0+kwxj7QXCbCLWBHKNHvyngmGbDT4JW8d7rdX4++y4NmxENc+h9mnDc/WOE17z5jWNekry4k/LvVAA6X6uACAeOPJSadJ7zwsQwOx6B9IS8u6duD2Lqn0U0N/Yn2DTPEP5LNd/A==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by PH8PR12MB7375.namprd12.prod.outlook.com
 (2603:10b6:510:215::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 13:53:24 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 13:53:24 +0000
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
Subject: [PATCH 16/16] efi/arm64: Implement ARM64 DRTM in the stub
Date: Thu, 24 Sep 2026 10:53:19 -0300
Message-ID: <16-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
In-Reply-To: <0-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR13CA0016.namprd13.prod.outlook.com
 (2603:10b6:510:174::9) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|PH8PR12MB7375:EE_
X-MS-Office365-Filtering-Correlation-Id: 67b77b1e-98ff-4a02-5688-08df1a433258
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|921020|11063799006|5023799004|56012099006|10067099003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	S4ihJznLepZ+G7FaOv8BBtcSdVJeAtAQncwlc9pPmpwSdgnQjx8TRSd6Gu5NC6ZdCUMsZ9hG6o8hJAsTyKDo1kme86VRnLEKuZ+DSJSS7HNTrPGkI3x2aE3zi0+SmNcjRz+OYg6enZ7KBIcPHIRgGV3q/POfVzNVCIoOEH9Ia9vUP92zKlbsMb1p1svUAdjrmcO9Pyq/VA0OHNwZzHDgZb4DRF6nYK1l4H4BbkycaGsvBHj2aFNtdEGAFY3S9sP2CbMOETRLk8qDuyB4JzVNU/sSsU7/Yy/5xSmDdsZcUSQepRameHrZgQ7bXYDImyzzsHjcLxPlMHyWwZX70ZX4LBbpXFGcKL/3g+tTPZ5mnFO1sB+bDT++UxaU+YEppQgJunF/BmTbPu/JilZ0btbPdBmU/qQLDTpq3lkwqKy89JqpjeQ8jzSTa05tgmU2DmpU9CAU5h61QFeESJQVtC3cbbETs/emHJW1Tk0cRklacsZ9S/J4XE0NNm69mWXd9CiN8/mToRHk4ChvSH0S7wj8frOInEFtWhg/Avo/xx+oz0864zsuCqxhtmmxu6WI1ceMrRK9Vjos1eYDNNJd6WNML4P/eJPgrha7LEF1XVQ+3covXucKqb2NI7P6TmZy8Tzzqr1hD5RFXx0QKz3sze0gEdwh30WN4tfia6xq1b5qf0vBoBa+5jrnYCbB7PyolSVmiUmtxQ/hry8b56ZwPW8Jiw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(921020)(11063799006)(5023799004)(56012099006)(10067099003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+lmj59+hF8HqktNIOwtrXPkY1YQ4Iw3F34K8XRaUhBFjj6THRPkH8foB2pJE?=
 =?us-ascii?Q?fmZxjxISKJVYc96AUJPazHxKHjgcOZGeMUX43AXM12yLOMm04EvjufXufahH?=
 =?us-ascii?Q?MLn3WytG5RLZx68M8bV27cNJ6hFeT8yOd8ZYYLeHRCb2u24iwxjy8T+B0SIA?=
 =?us-ascii?Q?4OqnyN51CYcVLUkea0oVzU4vMpcynehMXgAV3nvUfhDcUqGhirFcrmnDvF3R?=
 =?us-ascii?Q?93IWMbTAp4sjYrq+fiqATVnIxm+mavbmFpkDLlaOl+3kK1027UmT683aCB+f?=
 =?us-ascii?Q?/vH1jdoQopnrDEo3kHGZyOOXmuwCzp9kxD9ku1+woy8Bdr9Cln4/dF1SHzcz?=
 =?us-ascii?Q?JHohbdE5sKEE8ibxbyjXoDXP1u3oYt5LZiZ5qdc4XuRU7+olWSQD/a/80Agj?=
 =?us-ascii?Q?GXBRUIHTwMPbaT750epRxwWgHkRD9nu6FFuzYqJ24j9rzqA2vElqq+ar9toV?=
 =?us-ascii?Q?RYLOjPNsNZRzFjENCmNbURH+g51IDan64UjZDCsYMvbMRDF1DxTp0yS6DtgK?=
 =?us-ascii?Q?ZiPTU10AN2JmjO9tbPwTfWGkxOk0SRiD1J90SCQzjCZKZR7cx1/b/MkSLkiM?=
 =?us-ascii?Q?4uJOz6cC3YYMQzEo1DbkXohC13IP6PjUoxerHZs73vkTjYQdbfhXxAQAjqc1?=
 =?us-ascii?Q?zkiDXMp9t2XwqBhVL4lyp3v7nsbppCkZ32bMDFYD8kJJE8imeSZ76M3SySm1?=
 =?us-ascii?Q?KQ3qXv/lTyvpudo1PgBsZuDo5w5vl7TFJdwi13F3UYXhm7B3E4tkUmZfbS4N?=
 =?us-ascii?Q?kh5ZcLXgCfytJOiao+uYZFod3waU/NwxfPJDJ2aobBxNPoR/mOQJ1sjZFQgb?=
 =?us-ascii?Q?kOcML63r2YcdtycfAa0gNtmkJbDoATOPWUpAQen5N1KswQNLoNsswLUia5sn?=
 =?us-ascii?Q?ndghYJk4p0xvjounqm24omokQ1Ftray/2+pyyEMaPUr/57fHx9hJNX+UyEzV?=
 =?us-ascii?Q?Q8+HwdTytoEwrigKITzPnmeLX0HNOZ5TL27RYCM/sb2LPchUZfqOh+0rQVMY?=
 =?us-ascii?Q?Aj6Ne2kpW9VUiGh7JBSjBNRQxrhct28kSzkfjSzkJfT2FOiOB9TWpce7qr1a?=
 =?us-ascii?Q?RtHy2NVAuwg6YkqDLQZO73Rc1g/UnHdDdeMrB3k9ffL2oSmt9fRyI4AXzcTk?=
 =?us-ascii?Q?8JyJ/J7rzYU8TIBx9lVaRHc6j2EIfSUe3roh3Oepy/SP94weLB/cCxRfnjWi?=
 =?us-ascii?Q?RL+JSd+KkgLJYfYrtEUCGzxDTh5vleyFxluZ8A+d/LQATf2ovm96FB4hCQvv?=
 =?us-ascii?Q?oWZFkd6wPhvNsK2tLZYR63/5WEJLtsrOtltWznirJ9HNQY+b5wfmm7MioKog?=
 =?us-ascii?Q?/9eK1rBte8n1pjqoeBabpR/hJuHZF+F5MTMA9SjXOD0yl5FNVcfbCLy8VkhW?=
 =?us-ascii?Q?21MKxGk02CtfY/RWCCKdggt3vtAIyGYHpt8y0cHXVUlzn2GWdzBaUZao+fSa?=
 =?us-ascii?Q?ow2YafUM2GiuyKmiMvHW8V82gNGJSa5KjF1fwjq895XH2Vwh9Pngh0Rolvod?=
 =?us-ascii?Q?o3KhaspBpg7bXrcQecYn9zXkTwUWqMrLouEc6COzEWhUOAD2jCapik58euyA?=
 =?us-ascii?Q?OS3HD+QdA1E1mGHvkhqJiOAtTQmrZ2LetthniGrXKKAyV9bUQJ0YkRP5/9RH?=
 =?us-ascii?Q?JVxQf4RiOVHIvlbeC9xc1gby5s4mGjYJHfWAP7ROheOYpGXGEUTpor6yJ006?=
 =?us-ascii?Q?Cxn0gK2BqO3ye7l2NaFZZYaL1staJYtYaQF0NG4dtVK/wTRU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67b77b1e-98ff-4a02-5688-08df1a433258
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 13:53:22.3473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tUI+PxmepaRvt9N9x5S/3IKVEXH1BpVXiDK0AK+8EKCEUu0FEM0U7awcmUhNJDNg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7375

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
 drivers/firmware/efi/libstub/arm64-drtm.c | 414 ++++++++++++++++++++++
 3 files changed, 431 insertions(+)
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
index 00000000000000..12ddf7c2dd056a
--- /dev/null
+++ b/drivers/firmware/efi/libstub/arm64-drtm.c
@@ -0,0 +1,414 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2026, NVIDIA CORPORATION & AFFILIATES
+ *
+ * EFI Stub implementation for ARM DEN 0113 "DRTM Architecture for Arm"
+ *
+ * This code runs on the untrusted side of the boot in the ACPI stub. Nothing it
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
+	status = arm_drtm_features(ARM_DRTM_FEATURE_SELECTOR | feature, value);
+	/*
+	 * v1.4b Section 3.3.1 says:
+	 *   A return value of greater than 0 means the feature ID is
+	 *   implemented, and there are other feature-specific
+	 *   feature or capability bits available in other return value
+	 *   registers.
+	 * And for FEATURE_SELECTOR all defined features return data in other
+	 * registers, so 0 is not an allowed return.
+	 */
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
+	if (!(value & ARM_DRTM_PCR_SCHEMA_DEFAULT)) {
+		efi_err("DRTM: default PCR schema is unavailable (feature 0x%llx)\n",
+			value);
+		return false;
+	}
+
+	efi_debug(
+		"DRTM: TPM algorithm 0x%x, TPM hashing %s, PCR schemas 0x%x\n",
+		algorithm,
+		value & ARM_DRTM_TPM_HASHING ? "available" : "unavailable",
+		schemas);
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
+	efi_debug(
+		"DRTM: minimum DLME data %lu bytes, Normal-world DCE %lu bytes\n",
+		drtm_cfg.dlme_data_size, drtm_cfg.nw_dce_size);
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
+	if (!(value & ARM_DRTM_DMA_PROTECTION_COMPLETE)) {
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
+	status = arm_drtm_features(ARM_DRTM_SMC_GET_ERROR, NULL);
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
+		efi_warn(
+			"DRTM: firmware reports previous launch error 0x%llx\n",
+			error_code);
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
+	/* VERSION must be the first DRTM call. */
+	status = arm_drtm_version(&major, &minor);
+	if (status != ARM_DRTM_SUCCESS) {
+		efi_err("DRTM: failed to read interface version (x0=%d)\n",
+			status);
+		return efi_drtm_failure();
+	}
+	if (major != ARM_DRTM_VERSION_MAJOR ||
+	    minor < ARM_DRTM_VERSION_MIN_MINOR) {
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
+	feature_status = arm_drtm_features(ARM_DRTM_SMC_DYNAMIC_LAUNCH, NULL);
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
+		ARM_DRTM_LAUNCH_HASH_FIRMWARE | ARM_DRTM_LAUNCH_PCR_DEFAULT |
+		ARM_DRTM_LAUNCH_DMA_COMPLETE | ARM_DRTM_LAUNCH_NO_AUTH |
+		ARM_DRTM_LAUNCH_KEEP_SECURE_IRQS;
+
+	return EFI_SUCCESS;
+}
+
+unsigned long efi_drtm_get_extra_size(void)
+{
+	/*
+	 * DEN0113 Table 6, feature 0x2 reports both minimum sizes in 4 KiB
+	 * pages.  The linker places the DLME data at the 4 KiB-aligned end of
+	 * the static Image as required by R314030.  The DLME region must
+	 * include all of that data (R45200), and an optional Normal-world DCE
+	 * follows it at another 4 KiB-aligned address as required by R312080.
+	 * A final page holds the 4 KiB-aligned DRTM_PARAMETERS required by
+	 * R312010.  Only the first area is part of the DLME region.
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
+	measured_offset = le64_to_cpu(info->drtm_measured_start);
+	measured_size = le64_to_cpu(info->dlme_measured_size);
+	entry = le64_to_cpu(info->drtm_entry);
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
+	 * See arch/arm64/kernel/vmlinux.lds.S for the DRTM Memory layout. After
+	 * the DLME we choose to place the Normal World DCE region followed by
+	 * the aligned DRTM_PARAMETERS structure.
+	 */
+	memset((void *)dlme_start, 0, efi_drtm_get_extra_size());
+	params = (void *)dce_end;
+	params->revision = cpu_to_le16(ARM_DRTM_PARAMETERS_REVISION);
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
+	*/
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
+
+	if (efi_drtm_policy == EFI_DRTM_OFF)
+		return;
+
+	/*
+	 * No cache maintenance is required before the launch. DEN0113 R42130
+	 * requires the DRTM_PARAMETERS to be accessible as Normal Write-Back
+	 * Cacheable, Inner Shareable memory, so the DCE reads them coherently
+	 * with the writes made above.  R45220 then has the DCE clean and
+	 * invalidate the whole DLME region to the Point of Coherency before it
+	 * measures the DLME image, which covers both the Image itself and the
+	 * handoff struct placed in the DLME region. Thus once we jump into the
+	 * kernel with MMU and caches off the CPU will see everything the stub
+	 * wrote.
+	 */
+	arm_drtm_dynamic_launch(drtm_cfg.params_addr);
+
+	/*
+	 * DEN0113 section 3.4 returns from DYNAMIC_LAUNCH only on error. Boot
+	 * services and their diagnostics are no longer available, so hang.
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

