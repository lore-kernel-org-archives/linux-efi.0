Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795197135;
	b=hUu6mplhffa2vyV807ygloknqXaf9ZbdrHg4g+LN5z5OueMRNpT95SrVoZiha/OCXsDD
	 7ofPvAHBuEjB36j4+0tPjKM1lnAA7VAx1qhl+6INn71YFw7O3ndzOnseGVyKtwLBFzFTH
	 F3CcJmcqsHCNnNQW1ezl48WUg11ESHNAO0+JC/Uw4RvtImUSV9co8Eqrt2Ja1SuFC/QdG
	 Xhn9m6/710KAP/65QBLfgxrevwUe1pGaB+atQz7oVHOCFiFTkTHmJ5Wnv9iiKoBZE275j
	 gTnor0IhNIDmiLR09QV9Dj8jRHj1EIFs+gLYNUTlDPIxWAowYvip+ULspX2l59/mSkQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795197135;
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
	bh=v7/kNTAlFfZ0je3wYVPzF5jEPe1IEJdaFap0k57XJ80=;
	b=fUr1UGY+Hb0kPClODcuOWqaRcsr+QQ5wJEYZuJMkAiSis0ZZ2cYLG9dXC2tgXKZ4hSuH
	 PPiwip62Nqtv+i1cge/V75Sf/ye8jrDufvDDR/DhJeSQdetLeG93GBRSyiK97X5RXJzad
	 JVpY5KZyhH7VuwmTVXSF1tCTTwN56JR6jJkKo1gEYXkch/S++oRrZJX2Slwd85Mrr8tWW
	 Jgid6iLGYJqvHJ7rKIiiT/B/w8lftP73D3A+HO9/B1HfcCzITSwoIPGoPi0FMjPrNhKAs
	 Yezy5MnHGX3rJAJgVm3NFH1Ioq0uqVnxMVcMRU+K8zcSIYA0NtyWc9FYsGNjP4Pm18g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=jImz7eBk;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.28
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011028.outbound.protection.outlook.com [40.93.194.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9265A606A330;
	Fri, 20 Nov 2026 17:52:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9265A606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=jImz7eBk
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jZtojqlQbomrLQ3U4ejJ/YGi6PENEvSOnQO4aNd58vbTGItBmrGlz7KThGAAajc0rSFxxhPXWta27fN+KpG/A2t7FQQ4LFg4ZvfUPJ0D0azJ77p9w33RdPzyAhZ/HglXkHZnCEDuRQ03BCSitQ5DhqbQ+k4e/qe2MNBEWBIfY9li15uzHbwMoVfOD0DLsVnQKrAfmK4R3OFFNL/30Rc2fEMcJABlQVHV5O8OGC5278irjdgjLf07qdsah32xH3AVNKWLmAZ5mrwOES48u9wjkx08xs+Zan8sbK2kDqCXVGnoWrJEbYWHXrMUwlpmtL3H3ULf6B7NtApTCDdb+4+Zog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v7/kNTAlFfZ0je3wYVPzF5jEPe1IEJdaFap0k57XJ80=;
 b=tSbwRPXPZqP+JiMAnV47IB87kIa89W9nHeZeBtXDHSI03OgACGecjfy1R0X7nzNAjufT1WcojW4wMd2Qfw0lUzb53fOjPbppDHd61KGRWnlKlX0sQXCn1DmW0+h5yO3xhp6q/d7mlvXrT7YXImwsMho8xZE8NSneYk8ei1r4lQLYQK2E6hojt9VV8oW7bBhCFeAmYnFxDSjhZ7Q3Nk4tkEeCo4+h5IRwMhU+PCCQ3JON6X6Q8JACXFugOeHITnGmccnz/Jgm+zcF/wukQ3d6tai2TkP8a5fdGSWorqlLV3x7dTeZfuFMUS46I5Vdl8GVVJHfOKY0iDn+IuEa0hcO8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v7/kNTAlFfZ0je3wYVPzF5jEPe1IEJdaFap0k57XJ80=;
 b=jImz7eBk3LVzvCUVe5lYFeZ9WqhwHztYks850R50EaLs7Hbf1nNuUV7hIXFwIz5NM/h3JFvRCFS3WxlLyOCuyu8IdhVu4to05e80KSc8e3f+9Br581BtEIKW/+rdmBgkHnmBQhud+rkfqXeCErwXLJxOKzvvZYZt+Vcz5jG+aR5BEzAMA/MW6WNLlvjRRh3rVxmzpa1suuHVeDqchivCm91vEugZpprAKVfpZCsvjLYPO1z474/62LEuAEs03+pqWgjqmC1150NDTbUqN+IHKP8JXlaCy5rT4r5/XkpGhIZOaFqTTqtQATFpT7UBjJjammZ4lL+dVjZX7qxVUt2LmQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by IA1PR12MB6329.namprd12.prod.outlook.com
 (2603:10b6:208:3e5::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Fri, 20 Nov
 2026 17:52:06 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0639.010; Fri, 20 Nov 2026
 17:52:06 +0000
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
Subject: [PATCH v3 05/11] efi/libstub: Put the stub's writable data in unique sections for DRTM
Date: Fri, 20 Nov 2026 13:51:58 -0400
Message-ID: <5-v3-22d1a1eb7d2e+17de-arm64_drtm_jgg@nvidia.com>
In-Reply-To: <0-v3-22d1a1eb7d2e+17de-arm64_drtm_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: IA1P220CA0011.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:461::12) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: e769e8cc-4541-4efb-787c-08df472efdde
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|18002099003|6133799003|22082099003|261009223027099003|3023799007|11063799006|56012099006|921020|261102123227099003|261026121527099003|261021121427099003|261021123027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	t2o2m0vRNXYqoDfCeAgLemClmYVxNL4Mjibt9Z6rF8RzWe+vPsRu76RQbyt3/bUxsFTdOZUzbROdJJQuqmjPMAPtC5kTp5xrLlgUzdQFUSy1/UUipIe+48Ucl32zFyYzyfyMbCYitEJBD1UnHql35dqQ1gufNsVjf9ZzLBspq4kI/m+8Ki2KbtLFvT+Kll66/pjHcC45TlmANMyD22pklPhN+X9ZY8erqtm7oDP9DdLJ3KlDuf16SzzXFf0q/ZO9vs7/lapXbEykzG1UKMYUQuor7VZsTfj99tpA1oCjZRL3w2ybVQDX3lswZ5WCXhcSrbjAxtyyGn2t2T07MS04vZ5qvQ06RecvCDr7WUAqkY60E0fyJPNMqEtROucNT870rvHstZia93pBnFE9XGBaH1U8G+sJXNw2mIFaF5ggEEv448234KcxucKH4DMAFefq4eqUeCJ3ZcfXpjw7+/KPuhPgxL6TmT2Hx2d2nxSH+WizoubTIZmLbLObqC+yPu+c3r5zLMW4IgfuDUkGncIHL5NgpoCN6ZwubzOGhPn6SGlitvvAy+sPQb+38WWzjZE9O44Jw8cBt4N2eP3ewGHu2ciUs11mxGaQsO/aH8fmHCbAj5+7UxSBAEhxe9KXbwaZyoM4Vd8QrK9PyO75vylpXsS9TfVvNWstHXju0/j8LKUpsgocTuixAFytbYsRi/UjE90ippJoJQ+ioOVMEDrYQg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(18002099003)(6133799003)(22082099003)(261009223027099003)(3023799007)(11063799006)(56012099006)(921020)(261102123227099003)(261026121527099003)(261021121427099003)(261021123027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MeXyGtXqhMTzQPXntiXHvf/kEHeYZDt90Xo6Z7N1tbgrPKypL5MfbdAcpSg5?=
 =?us-ascii?Q?zAuTaa+C47wOVNLEw2e2kzR19rF5669JZ1jkzDRey79vP1X5CCp0FFddUVCj?=
 =?us-ascii?Q?ivA2XCX5Yeff8nM6MC8a7x+6SCRDETDJFmmarzLfW6erKtGVGFed6ly/zaUo?=
 =?us-ascii?Q?toLPPeglgfSOranx9s8w80Mx8Um5ZreYTw0uPZSkRlq+P3JCzS4dld7ZZfax?=
 =?us-ascii?Q?pez3IB14qC3dRB/Owfb797OVajxgL6xYZLpW5ZBOncc13t1FaMkOmOg0B9hV?=
 =?us-ascii?Q?QkSLmX4BenMw5RU0d0/o0LcWrmOgFhNJQiTRelyJSrvc4OlGijFnU2pf0E+J?=
 =?us-ascii?Q?p7INLycTVPtCu0zJhEarKSRNzNiEjVf4+9loxBljrGIgT6rZyekTq8uBvnHz?=
 =?us-ascii?Q?6bcTd9FHGl88AQYZdTW93jEqsDweN6GXzdLGT/7LM4op3VkKE6oy9DLcrAO3?=
 =?us-ascii?Q?q1qhKWdd6Zo4WIABFjCKfoDLaHGuJBDbcdPOpE1qMWF0bA+3B44LL5EC6MeA?=
 =?us-ascii?Q?gM59trHdJ8L4tn9syNtNZTriAK4TOYXVzd8cajzFoHgqdT3hQ+p6uYhxZgVg?=
 =?us-ascii?Q?qpp/52ZHY+e0Z+gqYoYy+5u1rzMgR/HLzOpUlSZ6qQUObGklkzrPcwrF6s1g?=
 =?us-ascii?Q?x7Rk69vsSkmMORDhhZSxJ3cCT9rW+y8slrZ2siibIiWeKu76kw1jJccdM6dG?=
 =?us-ascii?Q?JVZGIwaVDRJVu0rWG+0A1xIU/7NBFFWnDIRGcg/573x9uS70BHK8+fQGmm45?=
 =?us-ascii?Q?FXWDCM9jHeFx+618Z1ns/hhangcq01UN92/w5f4gIogjSJuJkPdajGYvYOkH?=
 =?us-ascii?Q?LrOkTgUviFRUDiK6SjKcfDN8j5CnxVvJAABMFZeQZ6dPUERpxMVMXfRrfYFN?=
 =?us-ascii?Q?6FeC9VseXyhhwlo12ydAWsf0bVuAFVZVN4QqHLll7K7LWzKuj+Nv5e3gcVAl?=
 =?us-ascii?Q?qm3KT9d7ZJAhww1ar6rbWmeXStbQMMf7vA5fZ2Qt4l6akpKZJSKtkhv9sq6M?=
 =?us-ascii?Q?4MZ2vIIOCBPkzBaQ2LckKmLlsD9mjgM8u2I8xVpuQMa/mju5p4HmNhCQuSJu?=
 =?us-ascii?Q?dVnHnRyb9mJoxbMm8SAwyb9WAaS/sqW+yb+MqJoSIGq2dfHl6ziUk0iagfsd?=
 =?us-ascii?Q?STivcmpSYPtNGVtQAVBUnDDUVa3W4XKlpmcJTGSFebDIMUQEi8rH6jvlSosr?=
 =?us-ascii?Q?iQ03LoqdpjVh4N/X/qTweeIbxTIoyUaale/73r5p8HlVxl4hg73ugGJh1vwb?=
 =?us-ascii?Q?pM6efCQoQQPQDntDgbrCgn2iYA+N7lqj8HTMl4ZXQ9g3eOUAeyQIuDjkYBN5?=
 =?us-ascii?Q?lGuGPdbcaOubUYSLR+ajJydjxWB4Lebsn3Vic3C0zDp5BR+TWme3xWAjq5ap?=
 =?us-ascii?Q?ezaHaLSbofrToW36iQCOhXM78vc2DT/lwPAGeZOZN9KazjR9AG30+F7mHXZa?=
 =?us-ascii?Q?73B55RW9ApNjFni/wUiu8JW/9XY2mzNmhiFxqPhQGm5gx5KO1+/XsYxy1qDc?=
 =?us-ascii?Q?80p4oxinGVCwIKwG9bs5L8N0Te++yRQaEfoXpOe7RaL6+1/6Zcqmx749hEI5?=
 =?us-ascii?Q?nbriODJhR1+qSd3xRWrdT3NXzYvaYpaLbLyi6DbOfdmRkTxwvsSO6l5khpC/?=
 =?us-ascii?Q?j7Y6q1s4erPUIUsdQcVSwpZekXtqM0A20NuU6ykPsWH5O5eRZKLl8s5KRyjO?=
 =?us-ascii?Q?cmkMbZh4yBIqDWimBKifvd23OTDE5gRKepnRHoJmMfu3Ll95?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e769e8cc-4541-4efb-787c-08df472efdde
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 17:52:06.5036
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Bp3tgZI3R3UBXlhSEoTmb3ucmGnjKZYa9gB4VgHccoo9aDg1q6riwnAEvjOmffz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6329

Currently the EFI stub's .bss and .data are both placed in .init.data,
which allows them to be discarded after boot, but places them within the
region of memory we need to measure as part of a DRTM launch.

If the EFI stub modifies the measured data before the measurement, then we
can no longer get a predictable measurement.

Give them unique section names; the arch's linker script has to put
these sections outside the measured range.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/firmware/efi/libstub/Makefile  | 10 ++++++++++
 drivers/firmware/efi/libstub/zboot.lds |  2 +-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index 0c5fbc21d2a297..207c8f99c5e299 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -145,6 +145,16 @@ STUBCOPY_FLAGS-$(CONFIG_ARM64)	+= --prefix-alloc-sections=.init \
 				   --prefix-symbols=__efistub_
 STUBCOPY_RELOC-$(CONFIG_ARM64)	:= R_AARCH64_ABS
 
+# Give writable stub state a dedicated section namespace.  objcopy applies
+# section renames before section prefixes, irrespective of their command line
+# ordering, so these become .init.efidata and .init.efibss.
+#
+# The names must stay outside the .init.data.* namespace.  INIT_DATA collects
+# *(.init.data .init.data.*) into a measured kernel output section that the
+# arm64 linker script emits first.
+STUBCOPY_FLAGS-$(CONFIG_EFI_STUB_DRTM) += --rename-section .data=.efidata \
+					   --rename-section .bss=.efibss,load,alloc
+
 # For RISC-V, we don't need anything special other than arm64. Keep all the
 # symbols in .init section and make sure that no absolute symbols references
 # exist.
diff --git a/drivers/firmware/efi/libstub/zboot.lds b/drivers/firmware/efi/libstub/zboot.lds
index e0f0bf00585487..34dfe3c2e77d03 100644
--- a/drivers/firmware/efi/libstub/zboot.lds
+++ b/drivers/firmware/efi/libstub/zboot.lds
@@ -36,7 +36,7 @@ SECTIONS
 
 	.data : ALIGN(4096) {
 		_data = .;
-		*(.data* .init.data*)
+		*(.data* .init.data* .init.efidata* .init.efibss*)
 		_edata = ALIGN(512);
 		. = _edata;
 	}
-- 
2.43.0

