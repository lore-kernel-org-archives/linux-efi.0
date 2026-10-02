Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010063.outbound.protection.outlook.com [52.101.46.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C498837188B;
	Fri,  2 Oct 2026 23:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790983931; cv=fail; b=E3kaFJ9W1HOcPWwepxUGMW7RWtMGi0yrEw5f64eTQeHWehP74O6T3JG6Y+0Nnyds8ed2NnG086gnZ7hE0AoDX+mQF811opubjez2aWinbtixMYhTf6mH3WmuuANDht2gm6mWd6qyZbpZgr7iCLAfYFX/dqzKCxuLP3ckcL8nFac=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790983931; c=relaxed/simple;
	bh=hSMkFXGO7IHOgxKT0sANY4I9ihmSsvytB5by+qY+TQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IilYdVjH/vq3U0dwsytIw/0WjpU75pNmonMH2T2gkTl3dpoe1O3yO6Of6VVE3A9Ll3apaCuRVSp+Mze3Nr3sO8oloHqi9CHnLrKgdHJojO10Blmod1fS5q6sDAg0PmFaZ0aP/6ULY/Zjsr/xUpw5OQFgISl8gI2PB1jKZn7yrzU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=h+EBOXqe; arc=fail smtp.client-ip=52.101.46.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="h+EBOXqe"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O2K+uvJ8u8U2IcSbftiyzyKOzpwghleqlx6YNwqLVyD2XZ3UgmOz67EFT1FvQO+LTNQHss2xqiOq7nJi5MqDqwEaSgNYaoYTctIddcHIPP52pPhmh0dtuk3KQXB8BhcYz5vsbUAh6pqI1LLc5hT/E+FO4R1MJSZ7UbaXy5geavv9WJDxjZDPSyBLnL1Wsw9iP7qLSIeE1rjg8wc9yBwaKbB1p8ZfT4vCayXb19goVUm5/rOBQjmV4BtYLPwiHTZ25xiKr2miG/aZHDHJ2V4OZ8dPJaKkAa2gYqr241Exmne81id+FWwEB6ZPnO8CJnCYNpkfmzlC4idOUi/aU7zgsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x9VtLdAgYNM0nMvePMDk9sZ3zFHENFbWGCFiZNFEjxM=;
 b=ojej+xU+tNR6c+AY861+6X4yevFBbziWjbVdSlmhzWcO/dyHis0V9e6ijlK5r8CfTYNy1Po2D9sfDQmdZ1xYAmWkyD3yu0Slv2ySpySP5oU7OToENd4iGf4PkR+4+48fpwqK/jLWcxpRjDq8Ub3HQilMIlx+/oXGd4IOheUoxH62xwEUIVndtV+Y4dBwFlfgLnf5FRPmYSBTYBLTWs8AEYBwSvCo9xhST5odW3R2pgLsd39121U70E0RopT+PTqN9q6sHPqXeBdEmgDgtQFyHJQfkG9NaW7tXEMAIOF1y2unwEWEt+qu5l12F/7axff2Dsfe/6BYcEui4oHVxFCLlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x9VtLdAgYNM0nMvePMDk9sZ3zFHENFbWGCFiZNFEjxM=;
 b=h+EBOXqeDdeZjVUBWRcKdz8oAMB24Uqq2bzPWtTpnhJqIaPN5yZ9Rf2MR2j03iDCjLMSs6mjJ9sxaIyXVylpvCZHNeARqFKOlAVgu0FJByF0betPke70J6aNaPMlr7JYZZhMjJek06Q6wv9U9p/LlUw3W0EqbhMyTiLhgLL+LAEIXMFp67aZ8UZh8Li5RXOsSc6d1fHNykn1HQYn+RsBWjwqQBqUqUW9Sf+HI5HtP/wfNX4ry6GvVLDtrmuGxvr7k4onGAKRFRwIzbHVMMws8omsAVFifi7TdWeqlOYv2MT3Boh7/yi8GvU2MV23AzRWjibVJo/Y5asInsVCPdSmag==
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
Subject: [PATCH v2 07/15] efi/libstub: Add generic arch callbacks for DRTM
Date: Fri,  2 Oct 2026 20:31:44 -0300
Message-ID: <7-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
In-Reply-To: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR21CA0022.namprd21.prod.outlook.com
 (2603:10b6:510:2ce::7) To LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LY0PR12MB325698:EE_|PH7PR12MB5830:EE_
X-MS-Office365-Filtering-Correlation-Id: be768b24-a3b2-41ff-550a-08df20dd5803
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|1800799024|23010399003|376014|10067099003|11063799006|6133799003|921020|3023799007|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	5bMbuSDqTyf/ypMg5+H64T0ptBQiKQ4aL4tPvqb4YgB/hIv7C0t4MGgpRkRBCI4t+LRNcmqQV9bTwJUhh/9WXz59WIeWt3rPA4fGh5SbeX3+BrDK49/wvowVjsQfAMjfUYWho1obubmur5q4kAY4y8490eqV1shoxVNpD47hLxw3Lzd6YnHtXBbbyNiemy1cgD/ghE+fre7E9AEwrCQOdGKn4zp4KXNKD28sWC1/N6Z6FsM6C3Hlvym1rRN64ewiZxnVZ/O/8W1xycFb1FwbQtQMycqqXQ6tZbqycx0JgA9AQQtBA7oZSYy7q5Dh7mFqUyGY3EA8bYQ8IqdY/FX+Gj0aLCU0ssi/gp0gGcehAxvG8SxSK1fxR52ilSCfdSSoev/r3lADJCCcokNEpQe0n0iMCJ1LywiQY7fFUEE+44Kjl6QG+corIM4luRe9OGck+RHQncOi0EZKdhZUjp8VnWyxiijqttplmY0YcTNg2SFR7wYIdcMBK0V2gv5yPW1H+opvKvYcYd/bte6AALgkfu2r2EBeg9N3tfKQ9F4TGKj+J+rR1gCvlyyD/1tDu3RsiVe6YpkYZMsVLp53D9nf7+vvTAb161IdJCFAAUt3OGrf6KZUlndlC4ebu8R7yNMKWu0NQmF3w1P+5ZVO1RAF+2P5dXOypnTZeN8C/ih6v3kdRoR4NIBFVmznsCxWLxjhYMxtY7kqlkCJuz3jw0hdoA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LY0PR12MB325698.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(23010399003)(376014)(10067099003)(11063799006)(6133799003)(921020)(3023799007)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?axvnjEhul/KrXR+btDdzbgTc5hAUulQzQMKaBFqjQYYF8QL4Y2BL3B6H9jHH?=
 =?us-ascii?Q?DVutblySugKPY64M+0qp7UVj7m73jwAs6DA/S4WAgisqjWsHBo0SQTVjo6Ic?=
 =?us-ascii?Q?ljhp/FffTbrgZ0ZENMwYjZPWk8lSUIGoMRTh1/sq5NsrB9zKUYq7LJolOu0z?=
 =?us-ascii?Q?tdmxOlVFFsRYxy5W38KvYGi58sSMUBrr18dKIAhkmfgd3UDI4pBbPCFQ8ZH8?=
 =?us-ascii?Q?aOPsmv4hiJ0QPztDbw5D5w90UZ1+tU3o9KVvhfeiYSYGvrOG7rrGXMlo6D09?=
 =?us-ascii?Q?PdxKAK9kh2vEA3KBGTLcXpo+ng9WnRQImzehKR6+KdRqEMolKZovXwP6wuCO?=
 =?us-ascii?Q?XPQ1O/rHiH2mUzTAcCrCMatO+lq+if2Vj+5Rv97q3g60S8qtKMXVbJ5+ubz4?=
 =?us-ascii?Q?px4urPH7RNT/SqvE4D6ODl+LnsP32/PRkh6ZeUuYS8xx3cOA2xPRAO6WAfO0?=
 =?us-ascii?Q?OiEFMNqzEi2eYpJtd+9rC30VMOTeIuM7F6RFBJqAaa8/KZSdD1ngpybKVAiP?=
 =?us-ascii?Q?wgymLuGAuTRKXvhRKJZVKoFvL3e/27XE3h2D67TONwUwW2aHJGzJk+gTJDwD?=
 =?us-ascii?Q?vEakxQgnDbcUrulHWth18J4xlGsYQhCIFxG8n1PpwksvtuhWyeBw01HSIsUx?=
 =?us-ascii?Q?7WuXceLM3CO/h/rO3qT6n79hOttQF2waYKS2eIGZWqC4J9T+sgHPewhvulC0?=
 =?us-ascii?Q?ndy5SakHDD86X+9mtr9HeGG/yR0JR+wSqL8aAxsZ/ixKOHtBpT8pYWeNZfM5?=
 =?us-ascii?Q?c97Im0Gu/f7T9IT8pO3kEZgljes74RnQXf5d2J4bn5V8i0nV2vR3UBtlnAfi?=
 =?us-ascii?Q?kLpiK3NNx19WZqm2bltozZrQfEMG3w+VbHG2qA1Yj0SOqtoN8Nb7ZSpmszXm?=
 =?us-ascii?Q?CE7OlU9UEbDstgaV3QaIRb+xCE1YBjiykaCGl2OBGi00UIFlEHbQZtx9ZYLc?=
 =?us-ascii?Q?+a32+ZXHoHnY7JcyXjGl6JEz3PSpBIBm2yYRME69OcJ3zVHzXDRvhyHBKOll?=
 =?us-ascii?Q?Lcvo8Zo/dbO27Ik8PUEmC4r87uM0YHIlbDQGBeVWN/z7FQ+b1dRkazBUvlr6?=
 =?us-ascii?Q?BYG0At+IYPH9d77aGED2OhlxrHQ1W+4a7DpteC43S4I3VbB64VXdliGRSx2U?=
 =?us-ascii?Q?bs3vO40cZUlUkpsMUgunmOTfWpaMXq7FKuZuQM7AN2xleGT9oCYiJ5iSX/Kn?=
 =?us-ascii?Q?0Tu2iwakNgfLWJB3Y699diSGHABzcsrox/h71SMnpDz53IoC0Y9H9kBvzJhM?=
 =?us-ascii?Q?1gHJ4d6Qx8XIEU75YspfYhV2JohtckC80027mqdOVPTQHYNlawuduCr7GBYY?=
 =?us-ascii?Q?y6PazbpKZjjf5crqLaY/6y54NqV+OLWrn89pf7FXfUvb4yodK55G2zMp9gL5?=
 =?us-ascii?Q?0EMHMRsP6a0gbdCwAViIWT2mM6fM3NA0rJT2zwfEFUjst1KfduS/vbDr+Cpk?=
 =?us-ascii?Q?MdKt934+PqPQLRbouhYWll9bY2acNMirFpc+cUWV1I+lACidm0FycqQ2RrJe?=
 =?us-ascii?Q?OYd+dqmRHdJ4XB0pGrGptWWtyJ3gwdqEzDEIxvWnMXQRu6MSilCfJPfMwmVX?=
 =?us-ascii?Q?G0fwc7rP/S6bqvYcYOwWJ3xtmFLL4dl8a118hApJrKzQiH3L/Mt4bksbXOGi?=
 =?us-ascii?Q?gZuV5sZPWLyRCgJrDdGr+k1e3d2ZBO9LxtbQzgMXwLwZGjSOpVSyjbhKWsnX?=
 =?us-ascii?Q?SgwXja4YinhdFtVX9xgiHYw0pumziFsT0bcHmbt2fStY7NkI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be768b24-a3b2-41ff-550a-08df20dd5803
X-MS-Exchange-CrossTenant-AuthSource: LY0PR12MB325698.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2026 23:31:54.9383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9nKQ8q4XWCvP8sg7FNjONmYSadWmkCuZ+mK2pGbOh2ocOI2tMY7YzwVydjG3CFkJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5830

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

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../admin-guide/kernel-parameters.txt         | 12 +++++++
 drivers/firmware/efi/Kconfig                  | 30 ++++++++++++++++
 drivers/firmware/efi/libstub/efi-stub-entry.c |  4 +++
 .../firmware/efi/libstub/efi-stub-helper.c    | 34 ++++++++++++++++++
 drivers/firmware/efi/libstub/efistub.h        | 36 +++++++++++++++++++
 drivers/firmware/efi/libstub/fdt.c            |  8 ++++-
 drivers/firmware/efi/libstub/zboot.c          | 19 +++++++---
 7 files changed, 137 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 68647ff4bdd24b..a576e06bd43584 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1373,6 +1373,18 @@ Kernel parameters
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
index 3d6fb3ca2806ca..f77fa1ae716843 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -75,6 +75,36 @@ config EFI_GENERIC_STUB
 config EFI_STUB_IMAGE_INFO
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
index fc1282fb442e71..2eeab9995af3e2 100644
--- a/drivers/firmware/efi/libstub/efi-stub-entry.c
+++ b/drivers/firmware/efi/libstub/efi-stub-entry.c
@@ -67,6 +67,10 @@ efi_status_t __efiapi efi_pe_entry(efi_handle_t handle,
 	if (status != EFI_SUCCESS)
 		return status;
 
+	status = efi_drtm_prepare();
+	if (status != EFI_SUCCESS)
+		return status;
+
 	efi_info("Booting Linux Kernel...\n");
 
 	status = handle_kernel_image(&image_addr, &image_size,
diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index f27f2e1f001997..2dd4a5ac916000 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -27,6 +27,37 @@ static bool efi_disable_pci_dma = IS_ENABLED(CONFIG_EFI_DISABLE_PCI_DMA);
 
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
@@ -89,6 +120,9 @@ efi_status_t efi_parse_options(char const *cmdline)
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
index d15cca8d6ff8be..a41f875bfa50bc 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -1078,6 +1078,42 @@ efi_status_t check_platform_features(void);
 
 void *get_efi_config_table(efi_guid_t guid);
 
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
+efi_status_t efi_drtm_prepare_launch(unsigned long image_base,
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
+efi_drtm_prepare_launch(unsigned long image_base, unsigned long fdt_addr)
+{
+	return EFI_SUCCESS;
+}
+
+static inline void efi_drtm_launch(void)
+{
+}
+#endif
+
 /* NOTE: These functions do not print a trailing newline after the string */
 void efi_char16_puts(efi_char16_t *);
 void efi_puts(const char *str);
diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index f01450b4997546..d47d0abe60c88f 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -223,6 +223,7 @@ static
 efi_status_t allocate_new_fdt_and_exit_boot(void *handle,
 					    efi_loaded_image_t *image,
 					    unsigned long *new_fdt_addr,
+					    unsigned long kernel_addr,
 					    char *cmdline_ptr)
 {
 	unsigned long desc_size;
@@ -289,6 +290,10 @@ efi_status_t allocate_new_fdt_and_exit_boot(void *handle,
 		goto fail_free_new_fdt;
 	}
 
+	status = efi_drtm_prepare_launch(kernel_addr, *new_fdt_addr);
+	if (status != EFI_SUCCESS)
+		goto fail_free_new_fdt;
+
 	priv.new_fdt_addr = (void *)*new_fdt_addr;
 
 	status = efi_exit_boot_services(handle, &priv, exit_boot_func);
@@ -350,7 +355,7 @@ efi_status_t efi_boot_kernel(void *handle, efi_loaded_image_t *image,
 	efi_status_t status;
 
 	status = allocate_new_fdt_and_exit_boot(handle, image, &fdt_addr,
-						cmdline_ptr);
+						kernel_addr, cmdline_ptr);
 	if (status != EFI_SUCCESS) {
 		efi_err("Failed to update FDT and exit boot services\n");
 		return status;
@@ -359,6 +364,7 @@ efi_status_t efi_boot_kernel(void *handle, efi_loaded_image_t *image,
 	if (IS_ENABLED(CONFIG_ARM))
 		efi_handle_post_ebs_state();
 
+	efi_drtm_launch();
 	efi_enter_kernel(kernel_addr, fdt_addr, fdt_totalsize((void *)fdt_addr));
 	/* not reached */
 }
diff --git a/drivers/firmware/efi/libstub/zboot.c b/drivers/firmware/efi/libstub/zboot.c
index e3abaa05fc4183..d4b3c9949e2cb4 100644
--- a/drivers/firmware/efi/libstub/zboot.c
+++ b/drivers/firmware/efi/libstub/zboot.c
@@ -35,7 +35,7 @@ asmlinkage efi_status_t __efiapi
 efi_zboot_entry(efi_handle_t handle, efi_system_table_t *systab)
 {
 	char *cmdline_ptr __free(efi_pool) = NULL;
-	unsigned long image_base, alloc_size;
+	unsigned long image_base, image_size, alloc_size;
 	efi_loaded_image_t *image;
 	efi_status_t status;
 
@@ -52,12 +52,17 @@ efi_zboot_entry(efi_handle_t handle, efi_system_table_t *systab)
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
@@ -92,8 +97,12 @@ efi_zboot_entry(efi_handle_t handle, efi_system_table_t *systab)
 	}
 
 	// Decompress the payload into the newly allocated buffer
-	status = efi_zboot_decompress((void *)image_base, alloc_size);
+	status = efi_zboot_decompress((void *)image_base, image_size);
 	if (status == EFI_SUCCESS) {
+		/*
+		 * Have to sync the entire allocation because the sync also
+		 * remaps and changes the permissions.
+		 */
 		efi_cache_sync_image(image_base, alloc_size);
 		status = efi_stub_common(handle, image, image_base, cmdline_ptr);
 	}
-- 
2.43.0

