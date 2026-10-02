Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010063.outbound.protection.outlook.com [52.101.46.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F9346AA95;
	Fri,  2 Oct 2026 23:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790983937; cv=fail; b=bS2SFdzOyRw0R8tPOV16/N2lYxdBz8Llzo/DuwfXdLp7zZWxwGmyEjsAGA4axLEMT6cSZwvSkpa9GqYGm3MX3E9BZFRtVdGnOLpn0hlWYQPHXhJUEjPFGTmqwDvpXpJoZgxEHcrA5CnFORx6Vem6qQPLotk9vs6AVqZSTDzV7iU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790983937; c=relaxed/simple;
	bh=arsVhUy8c12CtvMED6/C6CcXwh++306x5SXhFKQNT2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mmqnZWdvA1IDMFJVl0YLYBnzvbVB9D9a/g+efzf2xoGU3qR3iUaTk5hLh2JMH5jfuUE07uNqPeWon9LMHnwGl3Dv7Fm3Kj47/wOGuHAo5nN3vBWQxSuguKnT4aqGYLpa680Xj3Yla6wsNBtcVXyTIodY6yU95mNUdDOeFOKc6pQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jzlZogOS; arc=fail smtp.client-ip=52.101.46.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jzlZogOS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KYYKAD/8YxucKffT7SCDNepnwwkpvzLdv8jHTqXRnNzfRYkdFGG3bruSjR97f1IdeYIjJ5mDfJGscOSXMmEW4YALkdwlOVVhwYEhonuJzck+EUJJm6kMdus6UC1VhWBBy3OmfHv3Le9cX4rcW6o6hGM32tiTzvFvQyVcfJz85evQL9oL1G3qaSBB3CfkUBdBINBbuszplSqCU7nrEaAi2WaMqohzoyp18zUjY05A3eRKzd4UOMOKm93af0GyV3E23Cq5BYTul1S+Jx3psUGmKozbHQMU3gFAeeCKJHZnbJok3HY8FiQdlQudADVzgFHBBp6a6AbGWuiLASFkhGqRAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MLNXGrzpt66PBW2DWC7FxkoF579xcvyOXpG4IATN4vI=;
 b=Z/ahaBG3VSJxRKMQdX+m09OtSD/BAYrUd1Knqy6uhwo6BdfVVTh8gXCl4l/3ezPYvD2SryxeBFmaIUjsNEXzdKVm71MKDE6nbIpZ/Eoy/XHiTi8GpRbgSxvRBjH8ERZFCy6DuCK4A8jxqvFJXu+qmkU1i3GazLuf+rFcUJRHHbrQhe9ZPwWSq9JoQTIJQ7QbCqmKLpwFfu8pMMfQ5dWJi6sZVD9Xoo02/6fHIfWSCJWkGoKZafl0StMBeq30gFYJ11zDjxmHEEcf+lWiA0BglP2HgL7X6F18NxZMnCd9rIu6JDCe9woSz9p5Og3ZGMX+oyYF8hxsw7e84ZIKVc/CDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MLNXGrzpt66PBW2DWC7FxkoF579xcvyOXpG4IATN4vI=;
 b=jzlZogOSBmvouRSwmxKT1KQVhXzCxCUSeugOq4v5IyrMlfVF0KLoeYS0Nh0WC9dAX23IJf7orsJR5w8bJG/1+Y/BynbywDM+56z1dMXN8dSHIp9KvuRTj0ayxEHZVp3ivTo6B8K8hOpTHAlAgXjhL0WHU8B/189UxyL4MEheHVEbFO+e8da2FvB/g7N0S8LvGM156j1V47gWh/kEzudRt8tOChEDczljXDGOeg8w/g6QojNGMXEsUz/mT8oGO7vO3ZLFfU56PveX/Bg/3rJyeEqY7OpRm2c3kAIx2whmyAPAAt8KKHMercovzwzlrr6WAIt2EiMbnekeY2KEifa4BQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14) by PH7PR12MB5830.namprd12.prod.outlook.com
 (2603:10b6:510:1d5::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Fri, 2 Oct
 2026 23:32:07 +0000
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
Subject: [PATCH v2 11/15] arm64: drtm: Add macro definitions for DEN0113
Date: Fri,  2 Oct 2026 20:31:48 -0300
Message-ID: <11-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
In-Reply-To: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR21CA0020.namprd21.prod.outlook.com
 (2603:10b6:510:2ce::27) To LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LY0PR12MB325698:EE_|PH7PR12MB5830:EE_
X-MS-Office365-Filtering-Correlation-Id: 33a74d59-71fa-4177-d396-08df20dd593a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|1800799024|23010399003|376014|10067099003|11063799006|6133799003|921020|3023799007|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ZpMP1n1ER/zLDCP7rpcvNvB4242o8b7hjk6AEJeR57yxg/KIxMoJrU7d8fTEcqJIcxdi2/El4KhVNY5lA1vEFD/o1SIcUcmNFtylnA8XJxNCC3j08Jc/d0Xm713OqgxMk4jfvsabGUdxcFXOjlbnnDjYJ0kidgvBd+8goA+AelqKhSCQNkrbSBRXT8oWMzEg3ITtPBEFKR8ru3j6IUQacZU8/PPDNafXheRawbn/sXR8xIiDTbFiGHFNBsf24Y1KK2ngp2Rfjwmc8RiEBGCk7QHRKkYEwNo75suD3haGiQQQ40aIEj0ouGMOHtnT+u6fGi0byk9GqnvfP1YRcShVwyTRD2WNDtmhDxC8neimLz1IBMHaCFakzoiz9IkD1BjAQPpl95Oyx7/cz8Fygs0a3FfJx0jB+7tIajuXWdeIyLkM2W8Idpftb4i4G9UpDNYhst/vzgQVG5xceFiyvA569iYiFrypREHE9v81WBJYzphdtjEaR6o0IUh3yvxAIHlL128VbZMs67EItumKgOpwjQ30IBB345eKBccr2frPRc3Dn+W2Le5upcA6XcKh7ULTMIs7mtIUXMK8G/vWcy4e8CWQtrub3b1TX84eRgednR6Plb5NX+v16BauGg8DDdHnNsnTMipMNC45PEQdWe3nXlvneHU3RlnECmldY7oFpQeDIx8J13ugDy1mcp4ieKq+X0/OJmKr+FLmCMzGzxvMWA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LY0PR12MB325698.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(23010399003)(376014)(10067099003)(11063799006)(6133799003)(921020)(3023799007)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kBztjBShoR2uaqM0t95IRDoES0FhONKmJjMB3fUH2daLysu8zFjAy+G/SLf4?=
 =?us-ascii?Q?dA904VlwUdd/75eJ3yNkvTQJmIlkwDNpMVgSStGcXtiTTqM/Zkr6iR6uzx8E?=
 =?us-ascii?Q?Rsp1HhohWLhvYs3JYfdX/V1oUTsNF6DwpiLnhFfiMmHOhb1bbHJqgOYqt6cj?=
 =?us-ascii?Q?3JpOW2Fc/duKXIQGVpibXuHeUL6CBylMSr5lHtph0KAa46GphxCH4r1fIvwt?=
 =?us-ascii?Q?MBbL5/TOhrcVcAWqXx91Hd3XSKmAAeWAP07HaKqj3xr5XE+cJ7hBWLmXbQJP?=
 =?us-ascii?Q?qPPqAvgQDrrn1UIPBPnTyf3oo8hhl0r59Z9Qz91Vz3c9isdZRZ8A28BcdymG?=
 =?us-ascii?Q?QdTV5eLS3N84vD2hRb6YKQneeLZH5DxrnXimkhhZS1g/bYl36xizrkdel/tg?=
 =?us-ascii?Q?y2IFsRYgrS5UDS6iI8XpHBrMXiSN1dGvPXbKRa5UeakilP1OhJgpJu/qb/Y+?=
 =?us-ascii?Q?0loXpKBqSdzMUJML4Qb+xMtMqsC7UNs12tB9N636VmUFj51T+zMKu/lsVZxe?=
 =?us-ascii?Q?CJSVLywH/I37kVWB+O17SRyA1/KhidRfWSvuMAbWiSl1qz4YK/yhjO1NttRh?=
 =?us-ascii?Q?mIwYks6ZAh5kF0c43E+TAILKskhGzSmE3/e1mzx55xfemqQGSDSYh0YMdEBe?=
 =?us-ascii?Q?zq4Wruk6U7iph8DBmE5ipMDeu//vJZqzGUty/Ih2y5fnCK6rtlBuwUb2H9Jx?=
 =?us-ascii?Q?6IsD6Eakb7jJbgZArzadpL/9LJBjkJKnfY7ehpi3MDkknaQHnTqoxk6CKAV4?=
 =?us-ascii?Q?HndyZ0F4uKBriUr61Ov7ZIWe9zvHuiJhBuMcv/lRCfzanNzZMoOJEVP1o+Rq?=
 =?us-ascii?Q?Ytzq7ae2Kl1AxmcFg0/4OzI0K9JZUC+ZXkokvGS9aPZA+pXN72jer+MH5j3Q?=
 =?us-ascii?Q?7d0SCjjjUearhKc7oH4EyJUL3AOcz8mM0KDW5KxwU3MK0PnLpVhxR5+SYeGQ?=
 =?us-ascii?Q?mRTj1IBdZTtxRKDC1ZcTOuBypHOyWLLpFNzH3llpZz0ny+/A4P9HUZKr8he3?=
 =?us-ascii?Q?RA0Fc7YaXyWBz0tHcXLLdRCUGBJcrF83kYxYoHWLTnVKFUCOrven6tf9YgeW?=
 =?us-ascii?Q?pOVeG48LfoigXJgUgS9DeRdTjQ56XXr2WmHvvW3I1kjcVClp18cI357XEyeu?=
 =?us-ascii?Q?P4FVY1ID6mZ4lfrhR/q5/Db5mD6qB8S69COyoh2VUf387Y2z+aE4ZPjPMG2S?=
 =?us-ascii?Q?y0iN3alHUNt9sgW7RIBPhUi4ki3bieP087QMlim1cda/JBJ2POSjFOiF8vi4?=
 =?us-ascii?Q?tXXV79NbaBxOOWmRYuvB4DCYKRH9LWgSCXGGtbFBhcXCiGdZpAKngIW59W0N?=
 =?us-ascii?Q?Ych+vAItIG2sxr8HRgi8f9gxlvF9r7E6X4soEa1TX3MISL3Yi2c2o7DQJFYI?=
 =?us-ascii?Q?U1nFUO2mw07HIy1G9lwRR9pACoZ8cnVXWtOwpRGi5auTLUCz/RrN+KAjfKp+?=
 =?us-ascii?Q?fb1QFoR+yOHW6krRB5nP986JoJODzbH256/q21Jt99Sx33JrN5FeuLEgzxDc?=
 =?us-ascii?Q?q2RJYrQ3v7h45bBdKboIs6j2okjvwVRnHyjA470MrTyOZRZO99d3RfxDPW6K?=
 =?us-ascii?Q?dCgL5WhgEipOIpxWnLGH1oL7fOxbWhll8/bH47bjYxI7AcBlSnPqZ2ZOG91h?=
 =?us-ascii?Q?IUgrvdUcKQM92dRsKFFKoaICwC+G4vAUzmGqo+VS+8h7EqfXDSwY1EtGHbjq?=
 =?us-ascii?Q?OZNNXxxYVVWAP4aEkUboXxDTdnu0J6ejv7YxeS3ZyHuJ1dnG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33a74d59-71fa-4177-d396-08df20dd593a
X-MS-Exchange-CrossTenant-AuthSource: LY0PR12MB325698.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2026 23:31:56.9818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jVH7qvN/j+TtiSxZCmhfmW/AasrePIrxZzIpwHFtF/6cywz/1llpFIn2R416/jju
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5830

Taken from rev 1.4b of the spec, following the SMCC register layout and
constant names.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 arch/arm64/include/asm/drtm.h | 304 ++++++++++++++++++++++++++++++++++
 1 file changed, 304 insertions(+)
 create mode 100644 arch/arm64/include/asm/drtm.h

diff --git a/arch/arm64/include/asm/drtm.h b/arch/arm64/include/asm/drtm.h
new file mode 100644
index 00000000000000..8188af1b582bb3
--- /dev/null
+++ b/arch/arm64/include/asm/drtm.h
@@ -0,0 +1,304 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright (c) 2026, NVIDIA CORPORATION & AFFILIATES
+ *
+ * Definitions from Arm DEN0113 "DRTM Architecture for Arm".
+ */
+#ifndef __ASM_DRTM_H
+#define __ASM_DRTM_H
+
+#include <linux/arm-smccc.h>
+#include <linux/bits.h>
+
+/*
+ * v1.4B section 3.1 "Introduction to interface functions and data
+ * structures". Function IDs are 0x110 - 0x12F, called with SMC64.
+ * Offset 0x02 is reserved.
+ */
+#define ARM_DRTM_SMC_FN_BASE                                      \
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL, ARM_SMCCC_SMC_64, \
+			   ARM_SMCCC_OWNER_STANDARD, 0x110)
+
+/*
+ * The spec uses 4KB pages for sizes and alignment throughout, see v1.4B
+ * sections 3.3, 3.13, 3.14 and 3.15.
+ */
+#define ARM_DRTM_PAGE_SIZE			4096
+
+/* v1.4B section 3.2 "DRTM_VERSION". */
+#define ARM_DRTM_SMC_VERSION			(ARM_DRTM_SMC_FN_BASE + 0x00)
+#define ARM_DRTM_VERSION_MAJOR_MASK		GENMASK_U32(30, 16)
+#define ARM_DRTM_VERSION_MINOR_MASK		GENMASK_U32(15, 0)
+#define ARM_DRTM_VERSION_MAJOR			1
+
+/* v1.4B section 3.3 "DRTM_FEATURES" */
+#define ARM_DRTM_SMC_FEATURES			(ARM_DRTM_SMC_FN_BASE + 0x01)
+/* X1 input parameter */
+#define ARM_DRTM_FEATURE_SELECTOR		BIT_U64(63)
+#define ARM_DRTM_FEATURE_ID_MASK		GENMASK_U64(7, 0)
+
+/*
+ * v1.4B section 3.3, Table 6 "Return values for DRTM features". Use with
+ * arm_drtm_query_feature() below.
+ */
+
+/* v1.4B Table 6 "TPM features" */
+#define ARM_DRTM_FEATURE_TPM			0x01
+/* Algorithm IDs are defined by TCG, in the kernel they are TPM_ALG_* */
+#define ARM_DRTM_TPM_ALG_MASK			GENMASK_U64(15, 0)
+#define ARM_DRTM_TPM_HASHING			BIT_U64(32)
+#define ARM_DRTM_PCR_SCHEMA_MASK		GENMASK_U64(36, 33)
+
+/*
+ * PCR schema numbers. ARM_DRTM_PCR_SCHEMA_MASK is a bitmap indexed by these,
+ * and the Launch Features ARM_DRTM_LAUNCH_PCR_SCHEMA_MASK field holds one.
+ */
+#define ARM_DRTM_PCR_SCHEMA_DEFAULT		0
+#define ARM_DRTM_PCR_SCHEMA_AUTHORITIES		1
+
+/* v1.4B Table 6 "Minimum memory requirement", in ARM_DRTM_PAGE_SIZE units */
+#define ARM_DRTM_FEATURE_MIN_MEMORY		0x02
+#define ARM_DRTM_DLME_DATA_PAGES_MASK		GENMASK_U64(31, 0)
+#define ARM_DRTM_NW_DCE_PAGES_MASK		GENMASK_U64(63, 32)
+
+/* v1.4B Table 6 "DMA protection features" */
+#define ARM_DRTM_FEATURE_DMA_PROTECTION		0x03
+#define ARM_DRTM_DMA_PROTECTION_MASK		GENMASK_U64(7, 0)
+/* Only valid if ARM_DRTM_DMA_PROTECTION_REGION is supported */
+#define ARM_DRTM_MAX_REGIONS_MASK		GENMASK_U64(23, 8)
+
+/*
+ * DMA protection types. ARM_DRTM_DMA_PROTECTION_MASK is a bitmap indexed by
+ * these, and the Launch Features ARM_DRTM_LAUNCH_DMA_PROTECTION_MASK field
+ * holds one.
+ */
+#define ARM_DRTM_DMA_PROTECTION_COMPLETE	0
+#define ARM_DRTM_DMA_PROTECTION_REGION		1
+
+/*
+ * v1.4B Table 6 "Boot PE ID", the value is the PSCI CPU_ON target_cpu
+ * encoding of the boot PE
+ */
+#define ARM_DRTM_FEATURE_BOOT_PE		0x04
+
+/* v1.4B Table 6 "TCB hash features", max hashes for DRTM_SET_TCB_HASH */
+#define ARM_DRTM_FEATURE_TCB_HASH		0x05
+#define ARM_DRTM_TCB_HASH_COUNT_MASK		GENMASK_U64(7, 0)
+
+/* v1.4B Table 6 "DLME image authentication features" */
+#define ARM_DRTM_FEATURE_IMAGE_AUTH		0x06
+#define ARM_DRTM_IMAGE_AUTH_SUPPORTED		BIT_U64(0)
+
+/* v1.4B section 3.4 "DRTM_DYNAMIC_LAUNCH" */
+#define ARM_DRTM_SMC_DYNAMIC_LAUNCH		(ARM_DRTM_SMC_FN_BASE + 0x04)
+
+/* v1.4B section 3.5 "DRTM_UNPROTECT_MEMORY" */
+#define ARM_DRTM_SMC_UNPROTECT_MEMORY		(ARM_DRTM_SMC_FN_BASE + 0x03)
+
+/* v1.4B section 3.6 "DRTM_CLOSE_LOCALITY" */
+#define ARM_DRTM_SMC_CLOSE_LOCALITY		(ARM_DRTM_SMC_FN_BASE + 0x05)
+
+/* v1.4B section 3.7 "DRTM_GET_ERROR" */
+#define ARM_DRTM_SMC_GET_ERROR			(ARM_DRTM_SMC_FN_BASE + 0x06)
+
+/* v1.4B section 3.8 "DRTM_SET_ERROR" */
+#define ARM_DRTM_SMC_SET_ERROR			(ARM_DRTM_SMC_FN_BASE + 0x07)
+
+/*
+ * v1.4B section 3.12 "DRTM error code encoding", Table 7. Value passed as
+ * the Error Code parameter to DRTM_SET_ERROR and returned by
+ * DRTM_GET_ERROR.
+ */
+#define ARM_DRTM_ERROR_PHASE_MASK		GENMASK_U64(2, 0)
+#define ARM_DRTM_ERROR_ID_MASK			GENMASK_U64(10, 3)
+#define ARM_DRTM_ERROR_DATA_MASK		GENMASK_U64(63, 11)
+
+/* v1.4B Table 7 "DRTM phase when error occurred" */
+#define ARM_DRTM_ERROR_PHASE_NONE		0
+#define ARM_DRTM_ERROR_PHASE_DCRTM_FW		1
+#define ARM_DRTM_ERROR_PHASE_DCRTM_COPROCESSOR	2
+#define ARM_DRTM_ERROR_PHASE_DCE		3
+#define ARM_DRTM_ERROR_PHASE_NW_DCE		4
+#define ARM_DRTM_ERROR_PHASE_DLME		5
+
+/* v1.4B Table 8 "Definition for error IDs (Bits[10:3])" */
+#define ARM_DRTM_ERROR_ID_NONE			0x0
+#define ARM_DRTM_ERROR_ID_PARAMETERS		0x2
+#define ARM_DRTM_ERROR_ID_SECURE_EXCEPTION	0x3
+#define ARM_DRTM_ERROR_ID_TCB_HASH_UNLOCKED	0x4
+#define ARM_DRTM_ERROR_ID_TPM			0x5
+#define ARM_DRTM_ERROR_ID_SIGNATURE		0x6
+#define ARM_DRTM_ERROR_ID_IMAGE_FORMAT		0x7
+#define ARM_DRTM_ERROR_ID_VENDOR		0xFF
+
+/*
+ * Construct the Table 7 error code. Plain shifts so this is usable from
+ * assembly as well as C.
+ */
+#define ARM_DRTM_MAKE_ERROR(phase, id, data) \
+	(((data) << 11) | ((id) << 3) | (phase))
+
+/* v1.4B section 3.9 "DRTM_SET_TCB_HASH" */
+#define ARM_DRTM_SMC_SET_TCB_HASH		(ARM_DRTM_SMC_FN_BASE + 0x08)
+
+/* v1.4B section 3.10 "DRTM_LOCK_TCB_HASHES" */
+#define ARM_DRTM_SMC_LOCK_TCB_HASHES		(ARM_DRTM_SMC_FN_BASE + 0x09)
+
+/* v1.4B section 3.11 "DRTM_ENABLE_SECURE_INTERRUPTS" */
+#define ARM_DRTM_SMC_ENABLE_SECURE_INTERRUPTS	(ARM_DRTM_SMC_FN_BASE + 0x0a)
+
+/*
+ * v1.4B Table 9 "Launch Features" field. The 0 constants are for
+ * self-documentation of the selected behavior.
+ */
+#define ARM_DRTM_LAUNCH_HASH_FIRMWARE		0
+#define ARM_DRTM_LAUNCH_HASH_TPM		BIT_U32(0)
+#define ARM_DRTM_LAUNCH_PCR_SCHEMA_MASK		GENMASK_U32(2, 1)
+#define ARM_DRTM_LAUNCH_DMA_PROTECTION_MASK	GENMASK_U32(5, 3)
+#define ARM_DRTM_LAUNCH_NO_AUTH			0
+#define ARM_DRTM_LAUNCH_AUTH			BIT_U32(6)
+#define ARM_DRTM_LAUNCH_KEEP_SECURE_IRQS	0
+#define ARM_DRTM_LAUNCH_DISABLE_SECURE_IRQS	BIT_U32(7)
+
+/* v1.4B section 3.18 "Return codes", Table 20 "Return codes and values" */
+#define ARM_DRTM_SUCCESS			0
+#define ARM_DRTM_NOT_SUPPORTED			-1
+#define ARM_DRTM_INVALID_PARAMETERS		-2
+#define ARM_DRTM_DENIED				-3
+#define ARM_DRTM_NOT_FOUND			-4
+#define ARM_DRTM_INTERNAL_ERROR			-5
+#define ARM_DRTM_MEM_PROTECT_INVALID		-6
+#define ARM_DRTM_COPROCESSOR_ERROR		-7
+#define ARM_DRTM_OUT_OF_RESOURCES		-8
+#define ARM_DRTM_INVALID_DATA			-9
+#define ARM_DRTM_SECONDARY_PE_NOT_OFF		-10
+#define ARM_DRTM_ALREADY_CLOSED			-11
+#define ARM_DRTM_TPM_ERROR			-12
+
+#ifndef __ASSEMBLY__
+
+#include <linux/bitfield.h>
+#include <linux/build_bug.h>
+#include <linux/stddef.h>
+#include <linux/types.h>
+
+/* v1.4B section 3.13, Table 9 "DRTM_PARAMETERS definition" */
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
+	arm_smccc_1_1_smc(ARM_DRTM_SMC_VERSION, 0, 0, 0, 0, 0, 0, 0, &res);
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
+static inline s64 arm_drtm_query_function(u64 function_id)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_smc(ARM_DRTM_SMC_FEATURES, function_id, 0, 0, 0, 0, 0, 0,
+			  &res);
+	return res.a0;
+}
+
+/*
+ * v1.4b Section 3.3.1 says:
+ *   A return value of greater than 0 means the feature ID is
+ *   implemented, and there are other feature-specific
+ *   feature or capability bits available in other return value
+ *   registers.
+ * And for FEATURE_SELECTOR all defined features return data in other
+ * registers, so 0 is not an allowed return.
+ */
+static inline s64 arm_drtm_query_feature(u64 feature, u64 *value)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_smc(ARM_DRTM_SMC_FEATURES,
+			  ARM_DRTM_FEATURE_SELECTOR |
+				  FIELD_PREP(ARM_DRTM_FEATURE_ID_MASK, feature),
+			  0, 0, 0, 0, 0, 0, &res);
+	*value = res.a1;
+	return res.a0;
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
+	arm_smccc_1_1_smc(ARM_DRTM_SMC_CLOSE_LOCALITY, locality, 0, 0, 0, 0, 0,
+			  0, &res);
+	return res.a0;
+}
+
+static inline s64 arm_drtm_get_error(s64 *error_code)
+{
+	struct arm_smccc_res res;
+	s64 status;
+
+	arm_smccc_1_1_smc(ARM_DRTM_SMC_GET_ERROR, 0, 0, 0, 0, 0, 0, 0, &res);
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
+	arm_smccc_1_1_smc(ARM_DRTM_SMC_ENABLE_SECURE_INTERRUPTS, 0, 0, 0, 0, 0,
+			  0, 0, &res);
+	return res.a0;
+}
+
+#endif /* !__ASSEMBLY__ */
+#endif /* __ASM_DRTM_H */
-- 
2.43.0

