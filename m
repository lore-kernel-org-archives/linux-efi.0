Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795197138;
	b=adPpx/lAJZV2zdkjR+B9FWzZ5RDmuiduRg0YAXF55lPar8hK+ZmorCXCNNiElTkJXBOk
	 vaXkSt4TGDgoWZ0wP10UD35tVKm3sN+tTRzjD6FFxOsvcAx3rgc4cQd+0xxiuybtyGlKE
	 NzHX4ssUUZp+EFFIoXvS/o7wt33SoIJpjXEmx5eFgKGUlnCBQGm30NzGx5Et7RqhjIRW9
	 uyKUYIdszhuxp8AysMDd1XaaMutRXsMZA4CYzQiMVP3oeCR+cf4a4sCF628NsMVbSvh34
	 p1RR04p+HKYqGfC4xoXfU0DeQDHqPbT/inOrRg2YTLjRKO1i+mYcBRzrn7d0bW5vuiA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795197138;
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
	bh=0ewwS5IIfcxDN3gGz7/TxoTcH5TtWJJvMkrlEmnMpWI=;
	b=AB4bEDa31wbBfHZdrt8dqN6eg5/Q6+10PXSEctnp+VM4vaSCYqEejyGzuhWkNJWvi9WD
	 nFuadjpS8sV3IIo52+zUrkIsoc57A2Vcw6opPH8k3ySHs7zYyPB3px+IysTFtAa48MsOt
	 e9j0IrhmIvlNu5bZMf6ImRNHR8dzuZYYN0GtSMtS3WN5pHSkyIpBYJ5TFJ43Z2Myi5fPQ
	 NBRZgaDaEYbaip41F0t81AbF7pjFrZpCSd4L69GPNeOnzFDdP7MVAgJL4x1BqLos2VjSf
	 R1GUoq+Cdi35G7/SE/5XiBNSxtgjqPJ69DlIMut//QOj9DYC9KS0gjf3A5+IjsMAyjw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Uht+96Za;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.28
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011028.outbound.protection.outlook.com [40.93.194.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4D5606A333;
	Fri, 20 Nov 2026 17:52:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2E4D5606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Uht+96Za
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pAkFwPERnLiTWlry3p6ADeruQb+rK012IvccdlbCSDq57SZiESiEB0rLK/Lv7LUAuYsTKL5iJes2jHhsw4QinRfKX79E1QvTJKmaCdff5YcSLfDD9R2pdc5sFqDGPmISoFnROqGa2vEo5C4ciNW5eEIudNQf7byPz9SsndF0Ur2RzntlLwMaWTs3G5RVWAA6t2W0KY8phSmf5FXyiBBnKFRhYY8C4K9XtF3qF7sqSO1mH9S4WVk02o7qlenRVF4YDXf/Geh0+pHD7CwDHv6NYobwYWMD7cgwVuEQoKJ87z43lsLbsvFzF1ICre07oA1PJLYgTar1BSJL0Xo4Jy78EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ewwS5IIfcxDN3gGz7/TxoTcH5TtWJJvMkrlEmnMpWI=;
 b=HTt3kXuQ8MurF8/kvvTwzdvPt9/Yvhd03cB53s+oY/A+j1orMDadBbiIET6uD7Z2nLmCtZ+OqT3183rROg/TU3VqLJG4+vTMr6QjzDAuel7UGUyG00jwLYDZPX/FdKSHSMWnbzDsJRiTpNNgNejXnXwGyhnP4VVlTUd/wNEhvn9xPqoKwCrsIMPXl7WTLc2XDhaEq4aJgGIjetoPvF9Xl0Olz6cFpAhkajTr28DQJJXA3MLsqpPJnUpQJ89SNuI6TSpYgFcKbpA24HKsg8p+Rw72EVUU2Zok+HZbfnqVROXyibmms/nnCKw7nE1nbVoDdvCqvncC+eGJvX4gFFFstg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ewwS5IIfcxDN3gGz7/TxoTcH5TtWJJvMkrlEmnMpWI=;
 b=Uht+96ZamqU3/wdsW9HqKPr9KMHvTyPw4FWCTRDMMUpGr90kqpIfdvbzRVs6G5PeVmCl1TEgZCCRFYEZFhU7gFU0aixIodbYTffCOqtRBAQyNml7v3d3sIkTKFi/L+uNJqxaeOv/A8JAlCBPObzZBz+AjKMoaLLZbdV2pQRGuw1zSmj8Vt00rnOel6JwExUCBcNzT6XgEATaMzS9dvuNrD4zBIyvJ/RrVmSMd7+YWVDmxnlKQTbiwSw/dnTTx3HPv2Cw/rW3EIhLvYidMtvL5goRGQYl0fjXr3lFuKVQAeNb5qwlRcUcVsWNFuo3Xw5TV/i5FUw2LzsgE997nG6WWw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by IA1PR12MB6329.namprd12.prod.outlook.com
 (2603:10b6:208:3e5::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Fri, 20 Nov
 2026 17:52:07 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0639.010; Fri, 20 Nov 2026
 17:52:07 +0000
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
Subject: [PATCH v3 06/11] arm64: drtm: Add macro definitions for DEN0113
Date: Fri, 20 Nov 2026 13:51:59 -0400
Message-ID: <6-v3-22d1a1eb7d2e+17de-arm64_drtm_jgg@nvidia.com>
In-Reply-To: <0-v3-22d1a1eb7d2e+17de-arm64_drtm_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAP220CA0026.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::31) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 53680e0c-761a-46a2-2aa7-08df472efe16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|18002099003|6133799003|22082099003|261009223027099003|3023799007|11063799006|261022115727099003|56012099006|921020|261102123227099003|261028144727099003|261026140227099003|261026121527099003|261022113327099003|261021121427099003|261022105027099003|261022075727099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	OsmIJfZh/Rzxkr2+sMZOBOAzlHFAQvoJ1jkFbTHEUdsKcfddTHOsZDtDJU1bsG0FSOAzmI9wUcBLmPq8aA/76ZlGtdQHFq0vSW3MLThHYoF4L2oux8H6KEHE/Fba3+PCt6V5rCRKvYsXVCqtOLEoNmzq45+bhxtC+Heoc8DjBz1FwbgWg1OG8fgnF8Bn55OE0pMfMtmNRrFel0HLOlo/HkV0VkoZhXfS20SJmgnlOT1jcD4rXgxMiao7tHkJM3HRYmWq89CQSpgxeTkGR4NHG3l7gG/WTQBa8enHe2h5wUOXId6+gP+jKP0De0jjEbFKAcIsQw9xNlWaDFWY5DyItSyicqthfMuvzFghHPsDhP8CYugrwXss9UlNv2BSj4/49FKi7OO8p1pe2ThcStnqXvm1kFRgjXnhDRA5ez6SZOf/WJ+hndXNp/YgzYwSgMsuNj93bIA9LiaJMfELgzDxK10i+Zwq7IHNTmwW1HuryBurl6AAaqQHM5hzxcdmrowSgellANG9R8iFKsCYW4eQSGNP8kV/glGXzqZ+IlZAvsExDdv/cuwUwAaJ/MpqTA4x0ZAFXwYiwlW+uMUN280ivp4PqZZmXoXtdgwa/nOjljOJ6jyKB1GNTUAxx866QqobUZ/LUXKNNyIaj8dvq3K3eVwltJyCAZVxdLsU5UwZ9jYnHdc4K7u+RMl3D94wUCArK2E9KYidGu9B8Rvuj6kl2g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(18002099003)(6133799003)(22082099003)(261009223027099003)(3023799007)(11063799006)(261022115727099003)(56012099006)(921020)(261102123227099003)(261028144727099003)(261026140227099003)(261026121527099003)(261022113327099003)(261021121427099003)(261022105027099003)(261022075727099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HAy2EqMgpjrLpHhqHe7YaN9xw4vdLhqmupdEEX6KJ17vipuFmhv3A0xdqfNG?=
 =?us-ascii?Q?hC4XwyQs5sENtuKKY8Im8gR6gQnYnbsEz1pryNoZo3oYd/8PUpgkNKVv87+c?=
 =?us-ascii?Q?jZDPQWRcvzQoZTFQeVWdBK9EvO8g6+FxSMmY2rdzoe5+ZlpAa1E5a9YRLiqj?=
 =?us-ascii?Q?UW4ZDEoCCG8QURlSlpQg4wXObTIzNcltB6eoCqjUAtU4D+hQgnEXd4KH2lH3?=
 =?us-ascii?Q?PIAXEZSbwgg4nlNNNUY2u/XBit9GZGlAcSQwV9kxYIPlOkyFuJP1QzZRqpZp?=
 =?us-ascii?Q?62Q5ox6F2uVnoYsKF4KOW1VxB/KLUrf5MXqiDMGXRGfKBkz5bTUKIFUAzP1f?=
 =?us-ascii?Q?vP+e4afPSpO6hNVkysUSXPXmxGpLd31SaiCT4uuY1lHxXklzucnodY4fm9Zu?=
 =?us-ascii?Q?QxFZ9PlKhTkvGVnTHKanAcRAfxglk9sa1+4ZUa/iG+XJfmMWujWAnWXTTmE7?=
 =?us-ascii?Q?lEn0JcN+5YJR56He+3DsnHgebhoP87Qpen84h/JQ08DToi6KJgwSZzFMZoM0?=
 =?us-ascii?Q?rcb31uSS9pMzxUA2XiwQy7/cJQuwecjPwuCd5aounYR4l0AQH5+8VsBKIHd/?=
 =?us-ascii?Q?tOdxOJ36EuDGVP6UhasW5OUDIT6szUveDMII2TS2Cp8MZWAiSA3ntgyd7ho5?=
 =?us-ascii?Q?eIi4aBpEXGoV8Y4Nvizpe+zf2MWD9kZdDN0R610CiaGLSrEyX0fgIweX+5Jq?=
 =?us-ascii?Q?LIxp49/AZA7Uup0HH72mZweGpCFEY+VzY/lpEymwBQxtnAdZS8nVYsHweCJ7?=
 =?us-ascii?Q?0GvmUe6VGVC6+bm7a053YwmyLR9YlQtPPnyO2JJc4UaSJx1GA/ck46p3uTJH?=
 =?us-ascii?Q?Y2L/B3ttY3dA/IfRs16VWrcQsKQ9y8BXZqiUgzEeOQGjA9dYJj7WQksz4pwU?=
 =?us-ascii?Q?Z2lSeTgJjXzbLwcH/C+pzxflQzpKwNUFOZjtZIzQxVzOm+74R62UzJGJAcXR?=
 =?us-ascii?Q?UB/NtMRnamp/zgCEbtuO2BN6s7/YLY+UTyN7VjFHfemy2RlyOEnlG+HCmOPo?=
 =?us-ascii?Q?Q6FrqKXbemBwrxnC+ZdEBg+FMQd6Zxpy0SH1G8t4y843WiDx+CmzoLP41DaR?=
 =?us-ascii?Q?WqXmE18fYJq+Jk5/RYAieGzhgEktgL5TCxjkHP/QG/UagQbTacjJ2w5hYAzB?=
 =?us-ascii?Q?VvpI+5WmJdyFVXRBtCTrUOQp/WMhNWN5JtJGmhfIkN8L02lDGrCpdQrWZm+t?=
 =?us-ascii?Q?MsbH4tY1qDWMQd6AiZsvxgKQDkOf+qLGonuZT8PoQ31OVP8Plor+tLPNeZW6?=
 =?us-ascii?Q?oa+j2weiSZsD7pAWJQNbr2xvleKSE0Z4X1kW7zqALQ2bhRVG+pFBTCGI4Ih+?=
 =?us-ascii?Q?NTGN8/QyeQdnIBQP2uZaQ2x/GcrajK7PRoTso9Ye4wQXUtfmwjE8SnQbekfz?=
 =?us-ascii?Q?C+j18LwNZJtfkShxwZXn4ZwyaPAYupTiONkwVjW4fHm79Ykv39gs19QIXTVJ?=
 =?us-ascii?Q?xg1F6pR6OT3E6lLR2STWLOUlYcflrxUMw9hp8UXIZlK81gU3+pCG4ugoZnlu?=
 =?us-ascii?Q?LhXm8BqBM+rleMDoQ4ltA8tek49hBx91I61WY2onFkAZpo8ABet18tBSYIFl?=
 =?us-ascii?Q?PbJrx8mMmVkgYZLmJopAl45gY6jtPkCUIS0kNvIB4q/NDN5B3QqJMOWC5kHV?=
 =?us-ascii?Q?rK2ngFcVaxxXAvJwIA+KuIqdZ6ftXQoguIpQ/pjaR+V0Q+NtjxgkA4m026kG?=
 =?us-ascii?Q?yaa9HljlnsUhPrflyralsmVi5ld9pKZAuwD2dsYSopzUYKAk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53680e0c-761a-46a2-2aa7-08df472efe16
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 17:52:06.8242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ndy5twfSqu0Y+uoF/2JucEsVlyKlZSyB3q5oYtIi3L+2ocDQa9JhU3OXV4ncxXuf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6329

Taken from rev 1.4b of the spec, following the SMCC register layout and
constant names.

Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 arch/arm64/include/asm/drtm.h | 305 ++++++++++++++++++++++++++++++++++
 1 file changed, 305 insertions(+)
 create mode 100644 arch/arm64/include/asm/drtm.h

diff --git a/arch/arm64/include/asm/drtm.h b/arch/arm64/include/asm/drtm.h
new file mode 100644
index 00000000000000..34201bc092bcc6
--- /dev/null
+++ b/arch/arm64/include/asm/drtm.h
@@ -0,0 +1,305 @@
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
+#include <linux/sizes.h>
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
+#define ARM_DRTM_PAGE_SIZE			SZ_4K
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
+#define ARM_DRTM_FEATURE_FUNCID_MASK		GENMASK_U64(31, 0)
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
+#define ARM_DRTM_ERROR_ID_TCB_HASH_NOT_LOCKED	0x4
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
+ *   A return value of greater than 0 means the feature ID is implemented, and
+ *   there are other feature-specific feature or capability bits available in
+ *   other return value registers.
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

