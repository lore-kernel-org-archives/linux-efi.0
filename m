Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012024.outbound.protection.outlook.com [40.93.195.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6DA379998;
	Thu, 24 Sep 2026 13:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790258025; cv=fail; b=MTccOAeLG2+KKw70Fs0T9v4Eu+JTIdqTDRldB4TqD4D2tcJ5K2m+n7bnOjl8Oo7Z5/SdToV9im58YNbesMOBqN39eepcsVOuXiFQH1U6a7Tgqn3+oUjNhToZBdo3iMg2UXenqU6nMK3hhbMZq3yB+7tyAnIdLR7gFPxu1WPfTsE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790258025; c=relaxed/simple;
	bh=o0aakCXgWlXcwYHRPX/P5yctsjN84yPdmoa3KYaeFqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VXh38PsCcRXljFTSTyytdNgHPu59NHQbCsMrqUut8qeGN3B3t+JFU8A74wz7+7SoVj5MuVF8xDD6GAqGfQ9mPns1UCmy1VMPp3VhNFnM6vJwLVe1hfQn8ZNwSZkxzR3o6q3Wq16lxqUm7loFaPGq3/6xuImi7UybTxzC9J1eSC0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gitM5XEl; arc=fail smtp.client-ip=40.93.195.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gitM5XEl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HvaZ235Cm1nDokEcqZEPAM97YS9Yj81oWqa0E5J0Mv92BUEwQypIuiAu71Xtd80RMMpf1NamukOnXIQUr0n7CmL5CljmHzkPY1IgQOJ1VEKqHoZcme/LNB5n1g6yZilHnWcMhrpdUtAYwmzaj4U3sU3rH1m70e7i0UlNHT6pTxJSZ98mk8mO0jPKzWxRqvdcl3zWNxEWbLWc8meF0di9l/emaiHNnqjhcyFQjiBv7kVvn9s4BKuc5crn51uoGX/RI9mWU7R0nUp/CR0MGyuwVO8IJrqcwiWvubsp02jctHQXdi82jgcaMjWT1xMDzDwzC9NRKgG3nBtC+tNAHrdPvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q+xYb/2yGUtggpHSNIt25jKx7MUFBT6MZ8MqIld4cR8=;
 b=nwbsvGVrL8kuJ3GQl/yRKwlWXsy4jKBKaut/m+t52r/320s0MQY/2elvwFCHbEx/pgwNFZqWZXmwoBhmlULU6jcG1DwYB2X1YY94O5BuxvCwHkWL6x+R066uEwwehRIJhPjXySOlL587eZCWci81vQe1CNOomuILm7121kqPvCbCLn+qz7wQG4zHZatoLfvdLScdw5EERXsEGftPOGPSWFJf/zU1JSUFrRY8roMM0wIYF5xEPfVbASSaDbo0P92Ox9QKGYSynv0mJDGzkQVsR0y+pskTw7yDFmZmxnrltrM0gyPM299j+HaV6Ek3cX2xYUxsqk1hV+RNvKFEzxRylg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q+xYb/2yGUtggpHSNIt25jKx7MUFBT6MZ8MqIld4cR8=;
 b=gitM5XElNyW9Z+1l8xhrJl/wAV9+T2nKk5g+yL0V0HLB55e2R3Thp7mLkdiY9ptJjSyC1NAWfvVUN5rN+C2FxrLhOkGwAOAoCGtyga/AtqfP9KDPFUqCxpWxxaf0eMYVaQczB9LyGJQx75ZrlljU6dWe9yYW4wEBdg0CfwPrC8aftHEGVwxxNRzgQVtWZ1TG8bYA5h7f/cP8EiMn4gjClCyCclKoglvMY0L4GApUSg3Gh8Ody//EXhhKjLBi6YWw6vLnQ0P0zf/ifH+kbzgPozbrwjpR3PqJok9PP9iCP7ZF3Ci2WEKMang3zJA2dzxvyBJ02cF6rIqti5X8NR47Ow==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by PH8PR12MB7375.namprd12.prod.outlook.com
 (2603:10b6:510:215::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 13:53:32 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 13:53:32 +0000
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
Subject: [PATCH 12/16] arm64: drtm: Add macro definitions for DEN0113
Date: Thu, 24 Sep 2026 10:53:15 -0300
Message-ID: <12-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
In-Reply-To: <0-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0079.namprd07.prod.outlook.com
 (2603:10b6:510:f::24) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|PH8PR12MB7375:EE_
X-MS-Office365-Filtering-Correlation-Id: e7561368-3f48-4b33-8d29-08df1a43336a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|921020|11063799006|56012099006|10067099003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	pBW0KnwF+KfFrqXw58FmEOwz0+ar7u1T3ZwQh7FpAO8HTg5AfNVznUMvTnSx4Y/TGyO8Q9/vo47/UQMg48epdrIKPasxnUHLKIyCBELVUEQe4ZD6i1BVLblvCXa/Tw9sPrZEQALkODR+WaLIeVlJJUDhbHKn9dbm7AjYaLlv9PCbG2pEF5fw2VDrf+25tzP61Zg1R9Su06zLoro8bfiFo4t4hNlJ70X1H6fhOpY5UvsLPFYY11CzBdgFHac6MknGg/rwpLcRASkgJcFF4C+e8IFylrvPgFV/M/EwFXSsuEITIw/k+JDC58JqY87XkfsX7GdB/ZhltysXVr/eV9bGBSAWAYBaqwvyde8CR9UVL2plsBRmMH+1BdpHHgR6z7XJDh9YpqgIv0ZlJVhEIonWwriY0/b5AbXVAWWm8nGIk8n4PkVQ/fzQhZv2zM2+uq3Nv2VYdXHhFGD0d2ZnqRM7Fzbk09h0tl6Zu9koTJunpxLKEJCRGIJxzVERzyOwxZwnxVdZUlEO/VJuB84C2hglZpnNtTPetNdsTqazFI2rOfl8CfMHs+kf80/Ug9RPebp8uHs4vMCVlmUbpx3QbO4PiqX6KLm07Mwu5GwAz8MAju3UxLoXnHYztAIjK9gIqbJkxLMHPNqrCgP30GhkcFNWSieBTiJe8SG4+daUfvTVnzOr9fxuV+mMhIgxR0JNlOVoyLOLPs++A4v3lYguEyI3Pw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(921020)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/TD3LeCSzvyazax3wwTBHyAIMX+YjjMUOvJ/xvAmG4uXI5YycPBm33w+D9Wc?=
 =?us-ascii?Q?aar3Cui5TOynVqqMaE++OpwTTeLpPuNTikzlDh+QBJlgOc7lkcKqhKQHQtkD?=
 =?us-ascii?Q?BtiUUt9AmTNGhih72hc3FiAxgXcesHSIbYaZjGAHF9Ji2sZlGkEYgxAaDqhy?=
 =?us-ascii?Q?c5rxUHkGamlqHq/H0VriPXnnDr/iQ5zUCdwn+HmKH8h5bQx/ii4lLIOIzAYr?=
 =?us-ascii?Q?JJklZL8fQyueilDmALhVYndCZkng6bAH0Li6S/1V/EvTSeePOGlnrjGUbRqm?=
 =?us-ascii?Q?1UZr3Aka3l43Hlkw4/qZP6eter9++gFMYDfTeWG1auZaFwzFcL85zc4PAQpq?=
 =?us-ascii?Q?/2GGB81eVHpatm+heaB59UaFdo0ofhsmHFMM8UORV0KL/PqGyllcRn378RPU?=
 =?us-ascii?Q?1Fg4H483e9Y+f02szmf22GvNHFAibhqwE2q32BpOac+fLKNev9I9HL2ukbsn?=
 =?us-ascii?Q?mlT54Zq2E2E7B9mf9USYJYF/RG482v3wKibfHvvrmKPkbcLmIzgNQLHqQX3a?=
 =?us-ascii?Q?ocALGREKkIQSUbTLY0kfrp420G9DOJpQGJQrxN7TjD91geMfIJd4NiX9iqze?=
 =?us-ascii?Q?A7+9kDnGPZLgeVSnUpT4I39+/1c1qWjZhwB30E5T2/2f32isxG8FiBLCi4BU?=
 =?us-ascii?Q?/8GLPwj2lzDUO60HFnRAMqGZbMHcjO51ABqjeNMToZOM94B6MclIQNH/TRNw?=
 =?us-ascii?Q?zN/XsxXFxXJG2lwCx8JqCmw0XhY1Ag13tbFzVdRoJesKxoPmziFn6PoNv7j3?=
 =?us-ascii?Q?jorvMzJT/dlndB4CSmQzaFWA8XZNiM8pMNkBjnHbdyu1GzDN28HpsYA+YvXP?=
 =?us-ascii?Q?VmRKXlRPCZkCZ3+8jM4BRR9XEMjul/ftqSSbbHyPOIIxbWCsuxKEEFLfnt5w?=
 =?us-ascii?Q?BWJpDZUvQniYQ5zi8gP+wsytn0ZFwhiFr82eWZUrLB8m5xQbYUKpdysTB4q+?=
 =?us-ascii?Q?LfStqrMzTpHgyvuOETUI9YarafAsBbK3jdedhjRg1s77CAeE5kU4FIeO6e8f?=
 =?us-ascii?Q?3NpM1GtQP2XU3KHqvkzbxn1x1doj7dTAxb8YDBUGaPrERQY3gAXAcnlggksC?=
 =?us-ascii?Q?UH5zY6lhPcwRUNMcjbJyk0yEKO91jSC20uPhxOY8wqqVKro5lVkFVrcmACRT?=
 =?us-ascii?Q?nQ/hcA5T8R/11MnJYrXErLf4E8idQDaxSlVXfhgSNEzwpAOJ3WmKWfZ5k67b?=
 =?us-ascii?Q?Lh/xz4bRO+LnI8E3s8IBbKPe1He0AsTa/YJ26odVPhG2ScroSKOAugh0ePu/?=
 =?us-ascii?Q?uuQry5PCWxv5ze86vt6y/+29ozE3IPyCLCW+2jrCfub6FOBP8/DBcIoJhiQX?=
 =?us-ascii?Q?rSp/fr7a35OgAjOFjx3+F6ae8QTSaBNst+0I5aqHPD5adbZKsdU/pRQSYlc2?=
 =?us-ascii?Q?20NB88VuO18LsX2aYLhXxjlGcjgoSqMNmva1djhzET4B1RIBXaR3eF22MbJd?=
 =?us-ascii?Q?ze6PXvfcHnDH6DCKlDS24myfQQy5UjAVIOBcxOTatLpztQhJNiQo2x3l113B?=
 =?us-ascii?Q?rrYUN1MrbDqVloj1xRbq+Xvys5zAPMLSKO9pUS5mfmupX1vwx3R5AfhBK5A5?=
 =?us-ascii?Q?MyuCx1iGr09dJvSi2F9CEzsNle/5cWjsPKjR1fOqYSEWxiTP1qOUONKJB9Ws?=
 =?us-ascii?Q?cJEGINLLggIIO50vz627S6owTKYHB/6TZufIDMChUbyd2eZE3Qk1yP6B87gL?=
 =?us-ascii?Q?mglYaRtxU0MEdwRyOy4TQu3Ve7vRnb3Ihd1MzhzWfaNOigfb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7561368-3f48-4b33-8d29-08df1a43336a
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 13:53:23.9882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nmw2galrf5OlIKZWAa6dyGL1KzLLfotDJMIB2lYodv+V19p1YQl/2uePYf7MevzF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7375

Taken from rev 1.4b of the spec, following the SMCC register layout and
constant names.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 arch/arm64/include/asm/drtm.h | 196 ++++++++++++++++++++++++++++++++++
 1 file changed, 196 insertions(+)
 create mode 100644 arch/arm64/include/asm/drtm.h

diff --git a/arch/arm64/include/asm/drtm.h b/arch/arm64/include/asm/drtm.h
new file mode 100644
index 00000000000000..d6dd04a4ebcea5
--- /dev/null
+++ b/arch/arm64/include/asm/drtm.h
@@ -0,0 +1,196 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright (c) 2026, NVIDIA CORPORATION & AFFILIATES
+ *
+ * Definitions from ARM DEN 0113 "DRTM Architecture for Arm"
+ */
+#ifndef __ASM_DRTM_H
+#define __ASM_DRTM_H
+
+#include <linux/arm-smccc.h>
+#include <linux/bits.h>
+
+/* Offset 0x02 is reserved by DEN0113. */
+#define ARM_DRTM_SMC_FN_BASE                                      \
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL, ARM_SMCCC_SMC_64, \
+			   ARM_SMCCC_OWNER_STANDARD, 0x110)
+#define ARM_DRTM_SMC_VERSION			(ARM_DRTM_SMC_FN_BASE + 0x00)
+#define ARM_DRTM_SMC_FEATURES			(ARM_DRTM_SMC_FN_BASE + 0x01)
+#define ARM_DRTM_SMC_UNPROTECT_MEMORY		(ARM_DRTM_SMC_FN_BASE + 0x03)
+#define ARM_DRTM_SMC_DYNAMIC_LAUNCH		(ARM_DRTM_SMC_FN_BASE + 0x04)
+#define ARM_DRTM_SMC_CLOSE_LOCALITY		(ARM_DRTM_SMC_FN_BASE + 0x05)
+#define ARM_DRTM_SMC_GET_ERROR			(ARM_DRTM_SMC_FN_BASE + 0x06)
+#define ARM_DRTM_SMC_SET_ERROR			(ARM_DRTM_SMC_FN_BASE + 0x07)
+#define ARM_DRTM_SMC_SET_TCB_HASH		(ARM_DRTM_SMC_FN_BASE + 0x08)
+#define ARM_DRTM_SMC_LOCK_TCB_HASHES		(ARM_DRTM_SMC_FN_BASE + 0x09)
+#define ARM_DRTM_SMC_ENABLE_SECURE_INTERRUPTS	(ARM_DRTM_SMC_FN_BASE + 0x0a)
+
+#define ARM_DRTM_FEATURE_SELECTOR	BIT_U64(63)
+#define ARM_DRTM_FEATURE_TPM		0x01
+#define ARM_DRTM_FEATURE_MIN_MEMORY	0x02
+#define ARM_DRTM_FEATURE_DMA_PROTECTION	0x03
+#define ARM_DRTM_FEATURE_BOOT_PE	0x04
+#define ARM_DRTM_FEATURE_TCB_HASH	0x05
+#define ARM_DRTM_FEATURE_IMAGE_AUTH	0x06
+
+#define ARM_DRTM_VERSION_MAJOR_MASK	GENMASK_U32(30, 16)
+#define ARM_DRTM_VERSION_MINOR_MASK	GENMASK_U32(15, 0)
+#define ARM_DRTM_VERSION_MAJOR		1
+#define ARM_DRTM_VERSION_MIN_MINOR	1
+
+#define ARM_DRTM_TPM_ALG_MASK		GENMASK_U64(15, 0)
+#define ARM_DRTM_TPM_HASHING		BIT_U64(32)
+#define ARM_DRTM_PCR_SCHEMA_MASK	GENMASK_U64(36, 33)
+#define ARM_DRTM_PCR_SCHEMA_DEFAULT	BIT_U64(33)
+#define ARM_DRTM_PCR_SCHEMA_AUTHORITIES	BIT_U64(34)
+
+#define ARM_DRTM_DLME_DATA_PAGES_MASK	GENMASK_U64(31, 0)
+#define ARM_DRTM_NW_DCE_PAGES_MASK	GENMASK_U64(63, 32)
+#define ARM_DRTM_PAGE_SIZE		4096
+
+#define ARM_DRTM_DMA_PROTECTION_MASK	GENMASK_U64(7, 0)
+#define ARM_DRTM_DMA_PROTECTION_COMPLETE BIT_U64(0)
+#define ARM_DRTM_DMA_PROTECTION_REGION	BIT_U64(1)
+#define ARM_DRTM_MAX_REGIONS_MASK	GENMASK_U64(23, 8)
+#define ARM_DRTM_TCB_HASH_COUNT_MASK	GENMASK_U64(7, 0)
+#define ARM_DRTM_IMAGE_AUTH_SUPPORTED	BIT_U64(0)
+
+#define ARM_DRTM_LAUNCH_HASH_FIRMWARE	0
+#define ARM_DRTM_LAUNCH_HASH_TPM	BIT_U32(0)
+#define ARM_DRTM_LAUNCH_PCR_DEFAULT	0
+#define ARM_DRTM_LAUNCH_PCR_AUTHORITIES	BIT_U32(1)
+#define ARM_DRTM_LAUNCH_DMA_COMPLETE	0
+#define ARM_DRTM_LAUNCH_DMA_REGION	BIT_U32(3)
+#define ARM_DRTM_LAUNCH_NO_AUTH		0
+#define ARM_DRTM_LAUNCH_AUTH		BIT_U32(6)
+#define ARM_DRTM_LAUNCH_KEEP_SECURE_IRQS 0
+#define ARM_DRTM_LAUNCH_DISABLE_SECURE_IRQS BIT_U32(7)
+
+#define ARM_DRTM_SUCCESS		0
+#define ARM_DRTM_NOT_SUPPORTED		-1
+#define ARM_DRTM_INVALID_PARAMETERS	-2
+#define ARM_DRTM_DENIED			-3
+#define ARM_DRTM_NOT_FOUND		-4
+#define ARM_DRTM_INTERNAL_ERROR		-5
+#define ARM_DRTM_MEM_PROTECT_INVALID	-6
+#define ARM_DRTM_OUT_OF_RESOURCES	-8
+#define ARM_DRTM_INVALID_DATA		-9
+#define ARM_DRTM_SECONDARY_PE_NOT_OFF	-10
+#define ARM_DRTM_ALREADY_CLOSED		-11
+#define ARM_DRTM_TPM_ERROR		-12
+
+/* Algorthim IDs are defined by TCG, in the kernel they are TPM_ALG_* */
+
+#define ARM_DRTM_PARAMETERS_REVISION	2
+
+#ifndef __ASSEMBLY__
+
+#include <linux/bitfield.h>
+#include <linux/build_bug.h>
+#include <linux/stddef.h>
+#include <linux/types.h>
+
+struct arm_drtm_parameters {
+	__le16 revision;
+	__le16 reserved;
+	__le32 launch_features;
+	__le64 dlme_region_address;
+	__le64 dlme_region_size;
+	__le64 dlme_image_start;
+	__le64 dlme_entry_point_offset;
+	__le64 dlme_image_size;
+	__le64 dlme_data_offset;
+	__le64 nw_dce_region_address;
+	__le64 nw_dce_region_size;
+	__le64 protection_table_address;
+	__le64 protection_table_size;
+};
+static_assert(sizeof(struct arm_drtm_parameters) == 88);
+
+static inline s32 arm_drtm_version(u16 *major, u16 *minor)
+{
+	struct arm_smccc_res res;
+	u32 version;
+
+	arm_smccc_1_1_smc(ARM_DRTM_SMC_VERSION, 0, 0, 0, 0, 0, 0, 0,
+			  &res);
+	version = res.a0;
+	/*
+	 * For this command only the output is specified as w0 a 32 bit value.
+	 * All others use x0 a 64 bit value. The -ve error and version are
+	 * overlayed together with the 32 bit sign bit telling them apart.
+	 */
+	if (version & BIT(31))
+		return version;
+
+	*major = FIELD_GET(ARM_DRTM_VERSION_MAJOR_MASK, version);
+	*minor = FIELD_GET(ARM_DRTM_VERSION_MINOR_MASK, version);
+	return ARM_DRTM_SUCCESS;
+}
+
+static inline s64 arm_drtm_features(u64 function_or_feature, u64 *value)
+{
+	struct arm_smccc_res res;
+	s64 status;
+
+	arm_smccc_1_1_smc(ARM_DRTM_SMC_FEATURES, function_or_feature,
+			  0, 0, 0, 0, 0, 0, &res);
+	status = res.a0;
+	if (status >= 0 && value)
+		*value = res.a1;
+	return status;
+}
+
+static inline s64 arm_drtm_unprotect_memory(void)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_smc(ARM_DRTM_SMC_UNPROTECT_MEMORY, 0, 0, 0, 0, 0, 0, 0,
+			  &res);
+	return res.a0;
+}
+
+static inline s64
+arm_drtm_dynamic_launch(struct arm_drtm_parameters *params_addr)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_smc(ARM_DRTM_SMC_DYNAMIC_LAUNCH,
+			  (unsigned long)params_addr, 0, 0, 0, 0, 0, 0, &res);
+	return res.a0;
+}
+
+static inline s64 arm_drtm_close_locality(u32 locality)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_smc(ARM_DRTM_SMC_CLOSE_LOCALITY, locality,
+			  0, 0, 0, 0, 0, 0, &res);
+	return res.a0;
+}
+
+static inline s64 arm_drtm_get_error(s64 *error_code)
+{
+	struct arm_smccc_res res;
+	s64 status;
+
+	arm_smccc_1_1_smc(ARM_DRTM_SMC_GET_ERROR, 0, 0, 0, 0, 0, 0, 0,
+			  &res);
+	status = res.a0;
+	if (status != ARM_DRTM_SUCCESS)
+		return status;
+
+	*error_code = res.a1;
+	return ARM_DRTM_SUCCESS;
+}
+
+static inline s64 arm_drtm_enable_secure_interrupts(void)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_smc(ARM_DRTM_SMC_ENABLE_SECURE_INTERRUPTS,
+			  0, 0, 0, 0, 0, 0, 0, &res);
+	return res.a0;
+}
+
+#endif /* !__ASSEMBLY__ */
+#endif /* __ASM_DRTM_H */
-- 
2.43.0

