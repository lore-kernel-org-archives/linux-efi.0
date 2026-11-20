Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795197144;
	b=ff88ITmrxZgNyrPbo3X/DZCzJSUuqzLjhvMCR7VGm/7ojnHCm9wgoA9isSbG88LU6d1s
	 WvxQ6MfFcW7AcTq2ZI+kYdjRwIGfbcgcL3VXhQAxr6uyKsXxh99EgLLphV7mFNRCJEhiO
	 rS4bd//lLVeDlx127lrC4j7NDGPGZw0U4rXKJMu+/x0ddAAvMDR2jNe+efGr7fNf1iRmT
	 z2DXFPEb1oRt35ouvVfbWmAJwL+oS3zndMgSkDsdbxgIdoIEEI70sLriIK8jDArOfTcA+
	 53VdJwnsOXVeOqbyM68BZ7mRYB6QjIBHapREjwPLaIuNQdoIOPTcDBiVvNcGIbvMRiw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795197144;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:Content-Transfer-Encoding:Content-Type:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
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
	bh=nizx4rqFFOp6T9PbCimmV3Bgupdz2ZPc15iTGLrgiFc=;
	b=IMSK4ShFLBp2lcqlxW4ggfO1ZA1ltWFxTmsFlRsEq/2iAP5x6kAKxgZsyEZK036xJthw
	 g3JzoGbVRptYihKTE8gz7+PxKSeGdIpZj3ssNFKgLREcRJ9l150URd8s1X66dld1h1GkK
	 UVuXyIJTGYpQ1DanaVG6Gq4iCNut2eNH6lSRXJsvr9TTTQnkVqNzSe+qdXT7tESFferAi
	 jwVc45f0ist9qVyjcPGveRPx1+hQzi5VT/cKXehVO4SgQRvP+EKx/W0/L/JI9IU2/z8LH
	 sLvcONAdo7sNFKkXtHhOcw68Y2kSiqkJQmjXinYQwRKE0Ck7/mt8+5RvwBlkFyk/RLg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Tpy6MYc3;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.28
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011028.outbound.protection.outlook.com [40.93.194.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C66560A260E;
	Fri, 20 Nov 2026 17:52:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0C66560A260E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Tpy6MYc3
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VHDvGVTkvs/K5/6gfSVJIVqLyYl2uvjk5DnQIOWeD3xO/EioUkAbbSONu1/EIwJCPMSrEPyTv3Gkc0sZg1z/9IINO+pKjYuqI0zolqFd+5xcHs5wykDBq6wcAvTV+y7bYx0tAZL6j5wiouUeQ+F0yBev0yKgYfT4Y3GiCPaxRZBHqG8oyeE9CuedU9oCYMZkzLHBAVvTHSPDWBG6csNGQX3t+lrTYrSaxyUPZlQth/+LJYTfH5POF77QoSemUKjhtPkJFPara2BuIjmsxDco5JVQu2pZ7/ZYIEKdXsIrID6B65c6Hmnz+KPA83Br3GuSDe641Jb6OKduDuOBn5LFjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nizx4rqFFOp6T9PbCimmV3Bgupdz2ZPc15iTGLrgiFc=;
 b=u0RYFyPH0oRlEq/1lpKrQ/NrLA33a9/qJHpmoD36ypGRnbygHfhidVVOr9PHJnW/n0Z+ES1Sze+GotVHprPnWhL6M7w4KrL/PT+3heLe3HHDoj18Er6ag171n4bbm3lB0e80BCi4TvIlaQpgBmPUCCTa+CGRUTOyYeJ/ECakT7BgU4SPVi0c5YSsU2XY2YmIy4w5534j3Xkz/sSj8yfj/ec1I7g2xmmOsoZywO5VilXc4pyWBF3oguMZ1U35VJGnpguTyH0d9qnyiwNic0fRcHxrwtoflyX0TB0O4w8q8Dc06+Mn2u7PvUkf19YRljst1DmtlvTPHldN2293CEUkVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nizx4rqFFOp6T9PbCimmV3Bgupdz2ZPc15iTGLrgiFc=;
 b=Tpy6MYc33wB5OV1A5u/HJNNSPYaiGeH0QvVx15QLzll2M1gclsL+/NauqGMBp3OGT3EDRGz7eskdBOSbfNd3d8hkDUV6k21r4gmyw0tDt9DbSAeUuVc3z85glrypfNVwZh5I099crLX9GSf8nFWiC3BC8g9xc3ZkLEcTXH5oFshd4v1rTJU3RCU1bxYsR4kfcjCbMJngR0WKOkO1AvLptfE+gci/TU3cZI5YmzLDwcgUphfxBroaaO+IGgxnHjQTK9+XTMwF5MbpmtHoBwCQ4RZ7Ma378NnGy5JV2inSXvz8VyUnyWHKa7sPIhLpLCOt8ehrATGmjynEuVW3pmJzbw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by IA1PR12MB6329.namprd12.prod.outlook.com
 (2603:10b6:208:3e5::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Fri, 20 Nov
 2026 17:52:11 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0639.010; Fri, 20 Nov 2026
 17:52:11 +0000
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
Subject: [PATCH v3 00/11] arm64: DRTM, boot portion
Date: Fri, 20 Nov 2026 13:51:53 -0400
Message-ID: <0-v3-22d1a1eb7d2e+17de-arm64_drtm_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0749.namprd03.prod.outlook.com
 (2603:10b6:408:110::34) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 36dda0c5-e2de-4ffb-38fd-08df472efe80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|18002099003|6133799003|261009223027099003|3023799007|11063799006|5023799004|261022115727099003|56012099006|921020|261102123227099003|261028144727099003|261026140227099003|261026121527099003|261021121427099003|261021123027099003|261022105027099003|261022075727099003|261021135927099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	9j6/CoMP9w1SR2S1IoHC3w4EKqaFpg8rPLHjGTb8HLgQzRwny8t/LOT+tZPmhEW1eumWRuOHGmgBT71xy3DSU77QaBCTjPjJe7Ty4zOxVlmemTZT0uMv/b+M+rPfH8ctwL7W94EcK5VrKyHfXjZuVWp6OLnpMrojLZO5TWX3SXFx1pcicfQaDkrra5uVeGcL7HYI4fICTsU8jjaDCmKpOFwQF/XlT45iOar5mXfdW+vaLoeAEf0iIB2qdQJ6rfGnd8Sysd0X9ofWa5CFHDiDroW50LAGfDYpulCp1RLageH5xctdqy3Gy+2DBVAonATT7rrYHbKYhdIF101rdhynNjjCyaSv7kC5hr7LoSZvw8UQrpqe9OCKQwIhdk/bsBJtf9/z+XKbK50y0di0yV5DVRHBK17x/z79S9MstgCkWwiCp/n/Sd/miAWloLcwDb2mKIRch1/HskHXEYglEuV2T36kac94AU7VGR3hkX1gymYpouqo8QVZ0NCbtMsUuDNRXuD4vVJ7kepNnjWXRoHbSBCNNHOz5dg6BRNVh6aGewUJ/uKmReQl7x3hG3gc0HWPVr6sDwpu2xQwXvX/pnuMjsIFtAb3pQJ3DoBlwNMrZ/V9Zlmzls6brgUK7+aJ0Il7oPMvYe09QnZNwjOkCeZh2zhvgddAR3Rkv6xQcS/j9ICsQd7fpTQMCOypayItuLQ/5JBzWcOC+DOGa/DQ+Yjm4g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(18002099003)(6133799003)(261009223027099003)(3023799007)(11063799006)(5023799004)(261022115727099003)(56012099006)(921020)(261102123227099003)(261028144727099003)(261026140227099003)(261026121527099003)(261021121427099003)(261021123027099003)(261022105027099003)(261022075727099003)(261021135927099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JDP7Sl94P8xjC3cHmRW6kGjxUMjb6glC8EOK04SfA4+K89gufRHVDVBnW57Z?=
 =?us-ascii?Q?tYTO0olFFWcyOVR/6nNzfAntuzb2/Ggd+xxUQuA8rRkCu9aPpEMxd0X0Tc6Y?=
 =?us-ascii?Q?eVKIGC2FXI8nR0vZSSx8OKLP4LJOvaIty/MISwQ2KB3E14jOCw8MEsGu2NXB?=
 =?us-ascii?Q?JMdnte847fPSEodQu1PZyXK+FmyBHv8Xu4BIo+/Vr8gsgsXoOFYa750wN90R?=
 =?us-ascii?Q?3BXn8kT7s4je1HZ3NlaxruE97DsrQtvaAxel9gGDzsPC/K1ONbAyLqzFNwz8?=
 =?us-ascii?Q?cEJPYcpSqvNYWOdfBGbOgRbtTMep4gzJpLY59OauJmZ93B9B91Ip6OCx9k5H?=
 =?us-ascii?Q?xk8aWhcZtESxfUGzbWpfpMRCjKxyJUIsEPD54tp6Q5aG2EFzi2xJrFxg6BCF?=
 =?us-ascii?Q?PnssUUx9bt1aPIxmzNI5+EyHR5E8eCt2AG8frYc7WCB1/7zDd5wjKfUsaWHi?=
 =?us-ascii?Q?On2+mglWGFpefPoS2Bk2pBATh03Yf+Mv2hFscEDgX03PhTaZ/WMqgKJL9bdq?=
 =?us-ascii?Q?FiKvgfiCbN8HZAWNxAUcHBWDFuKrKqzPggM+rBFZ5f6gNCgdy5iYRJlHLC/a?=
 =?us-ascii?Q?LCxLyRHbZzUBXWsIS/GpxBTWQ3gK3DmdmGRBdfyF4CM0xSrxXebvMgeN6vAh?=
 =?us-ascii?Q?oBdbSFgXDYGz/URUj2c+w641dBVV92Xs79+Da0OJkEApgkhQ/lbCBdSzmEyE?=
 =?us-ascii?Q?YuML6djnXXW1+e2We/kdF6kevl/bnQhDSWr6iIYDhiSgcFgGNOCIGxKZLqlM?=
 =?us-ascii?Q?oPSObXfVTDbiAzv7lKrA6iPX5WdBCROeJkOQWsimAfHVef4DVSDRob3aw2U1?=
 =?us-ascii?Q?4/KPBd6SU0pWQn741nkUoihdQDkDoSLS8d9gAmf63QK6IULwrOjFFVMfbR0/?=
 =?us-ascii?Q?7SArhw4M8im03cEWZh2BonGu0HRRCsClHGp6gZXHfnR0NLGSIY5ozvc204pI?=
 =?us-ascii?Q?KSw46ndPeHB8WK+y8jvDj1nnNMge7gsjv4KxHLY6Aqs+UQlGkLuo87HoMcRc?=
 =?us-ascii?Q?tiqSseV2eGOaQk8lasKroqh5hzWQsvzTS0NKRV/uNfJjgGeBeeXnE3ldArgO?=
 =?us-ascii?Q?LkvfyfhJihPluk+Ws82/R6xhzzpnIPLAEuNl2zZIMb/Sy3RjS+9sDUhcSsOi?=
 =?us-ascii?Q?N+OWTZNhttgZ9XkxGshTG3wb2l6SDWxcFW2DKsxYYMD15ESfONtIPVdQyjef?=
 =?us-ascii?Q?WmLLKNFs6C9ePH+ajH3FDsTHasHAhD1lkVwGXbggw9em/DFL4KPIHE7KfQe2?=
 =?us-ascii?Q?T8ewUHq7PKb4hFfV72+MtqOzlmtvTnW5ocENsmTIp7znVn3kAkp7wWrHcuQI?=
 =?us-ascii?Q?NBiIswGH/b161svV8gYR1ghlejVjbryQmDyG8spk56m/8zEE00GGDyIDpzuP?=
 =?us-ascii?Q?Pch0Asicbw5/zjUNzmSmHBJtS6IgWVB6vrTf3eXjMV3VCGI1u/D4VNkGIuCc?=
 =?us-ascii?Q?wmQerO8Y3SpDljjvGV2vbilfiA9s1AQbkgwJGqyqqbyqVz7YdI1X9A3nynBW?=
 =?us-ascii?Q?7tPXIBP6JVN0esE5ueVrSPZkMmHwdq9sK7F4Ay6WvLigNoa0hrrnhYh/2k6o?=
 =?us-ascii?Q?TekDWX2tpbIe8nqltoma+TvC+PUb6lgnPIDxCQHM59+YAZE9LVWl2HRh7Wyd?=
 =?us-ascii?Q?ZWpSJhcHXaR7Vj8TeHPok8incGFpSkDlBUIH5t8ld3dQWHu3e11Ma1F2NZhk?=
 =?us-ascii?Q?ZM0iou/KkbhvqZ9E+u6+u9l6XwFu7IVrjSS8oTxSmqYbIXiQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36dda0c5-e2de-4ffb-38fd-08df472efe80
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 17:52:07.5326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hrXvFoxvUEwVtTTyr17dJPAF0lWQU7yUn1Fb356C+YoGsmAGpM+Cq21PXmaXAYzm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6329

This is the first series for an implementation of ARM's DEN 0113
v1.4b Dynamic Root of Trust for Measurement (DRTM) launch protocol.
It is built on some generic changes to the EFI stubs that provide for
a simple, direct DRTM launch directly into vmlinux.

DRTM is a boot security technique that jumps into some platform trusted
environment prior to launching the OS. The trusted environment will
sanitize the CPU, block DMA, measure (SHA hash) the OS to a TPM, and then
jump into the OS. The security goal is to prevent tampering across the
launch: if the measurement says X, it should be impossible to tamper with
the boot such that the CPU is actually running Y. DRTM is a reaction to
the historically bad boot security in the UEFI world. It aims to make bugs
in UEFI/etc unimportant for OS security.

When I spoke to Catalin about this, he was interested in making the flow
cross arch. After looking at what AMD and Intel do, and how different the
kernel EFI flow is on x86, I have opted to do that from the perspective of
building some generic DRTM infrastructure for the arches using EFI_ZBOOT
and FDT. I've sketched out applying the same general ideas to x86 and it
works there too, but x86 is so different that not much is directly
re-used. I would argue the security/hardening work listed below is a more
important place to get commonality.

Several people have asked me about Trenchboot, which is the x86
out-of-tree DRTM implementation. In my view, ARM and Trenchboot have
converged on the same basic design. Both offer high-level functions to the
OS that don't leak out any platform-specific details. Trenchboot offers
these through an EFI mechanism from Grub, while ARM offers it through a
standardized FW based SMC API. Effectively Trenchboot is a reaction to x86
having primitives that are far too low level and far too complicated to
implement inside the EFI stub.

ARM does not suffer the same issues as x86. The EFI stub implementation
for ARM DRTM is only 400 lines in patch 10. This is because the standard
already offers a sufficient abstraction to the OS. There is no technical
reason to bounce back to Grub to hide complexity that doesn't even exist.

Further, due to how ARM has abstracted DRTM, we cannot hide the ARM
details from the post-launch Linux. The kernel must understand it is
inside an ARM-specific DLME, it must do the ARM specific ations, and it
must process the ARM-specific post-launch data structures that the FW
writes. All of the work in this series, and its followups would still be
needed if Grub was involved. There is also a sneaky ABI here, the choices
the stub makes during launch have to be matched by the vmlinux
accomodating them. Keeping this all in one source tree and one link with
no ABI is the right answer.

My hope is that this series will encourage other platforms, like RISCV, to
follow ARM's approach and not x86's. I outlined a suggestion on how to
progress x86 DRTM upstream along these lines here:
  https://lore.kernel.org/all/20261016165135.GA494690@nvidia.com/

Broadly, ARM's abstraction does several key things for Linux:
 1) No TPM is required until after some ACPI is parsed. ARM has many
    different kinds of TPMs, so TPM without ACPI is hard.

 2) The launch uses a contiguous chunk of memory that can be
    perfectly overlaid on vmlinux, with space for the headers,
    measured section, unmeasured data, bss and trusted post-launch
    information. It is trivial to insert Linux into this scheme.

 3) The launch protocol is trivial. The launch directly measures a
    portion of vmlinux. About 50% of the stub code is just inspecting
    features and doing FW call compatibility work, not tricky DRTM
    things. Zero SOC-specific code.

 4) The post-launch world isn't special. We don't need unique kernel
    patches to undo things that DRTM did. The normal drivers work in
    the normal way just fine.

This series is enough to perform the launch and get a working kernel
inside a Dynamic Launch Measured Environment (DLME). There are several
following security-focused topics/series that aim to further prevent
attackers in the unmeasured world from compromising the measured
kernel. Much of this list comes from internal security research at NVIDIA
on securing Linux post-DRTM.

 - The kernel command line needs to be measured, without any "early tpm"
   for Linux.

 - ARM's DRTM protocol for verifying the address map needs to be implemented

 - ARM's protocol for checking the "TCB" ACPI needs to be implemented

 - Non-TCB ACPI needs to be deferred until the TPM is discovered and
   then the tables are measured into the TPM

 - Initrd/Initramfs measurement by Linux before using it

 - Exposing the DRTM launches TCG audit log to userspace

 - TPM locality handling

 - Kexec, via Ard's EFI entry approach:
    https://lore.kernel.org/all/20261016144121.GA439341@nvidia.com/

 - FDT security

 - KASLR RNG security

These topics all largely require different maintainers and different
cross-arch solutions. Post-launch kernel defense against an adversarial
boot is a complicated topic with several different threat models people
are interested in. It has alot of overlap with the Confidential Computing
need to deal with an adversarial host.

This series is arranged to try to build re-usable things that any
arch can use to implement DRTM:
 - New general linker sections/etc to move mutable data out of the
   measured range
 - Cross-arch symbols __drtm_measured_start/end that allow a user
   tool to compute the measurement hash from the vmlinux itself.
   Because of the mutable values this isn't just all of vmlinux.
 - CONFIG_EFI_DRTM and general EFI stub arch hooks to plug into for
   EFI ZBOOT and FDT arches
 - Shared drtm= kernel command-line processing

For x86, it does set some user-visible expectations like how to compute a
hash for vmlinux and the drtm= parameter. IMHO, these are key areas to get
cross-arch alignment on so the user tooling, like a systemd UKI, can use
DRTM easily.

I have a slop'd up qemu that implements the SMC protocol which is very
useful for testing:
  https://github.com/jgunthorpe/qemu/commits/arm64_drtm

NVIDIA has several real HW platforms this works with, I've been able to
see that one of them works now, and someone else tested it on a different
simulator. I'll get more HW testing as the review progresses.

This is on github: https://github.com/jgunthorpe/linux/commits/arm64_drtm

I've fed it to a local Sashiko and am satisfied the remaining remarks are
not applicable, and fixed several of the previously existing bugs it
found.

v3:
 - Rebase on v7.4-rc3 + Arnd's series:
     https://lore.kernel.org/all/20261118182105.1633603-21-ardb+git@google.com
 - Use the SMCC 1.0 calling convention when discovering if v1.1 is
   supported
 - Tidy comments
 - Move kernel drtm code to drivers/firmware/drtm/arm64.c
v2: https://patch.msgid.link/r/0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com
 - Swap ftd_size_allocated to be inited by efi_load_dtb
 - Move the __free
 - Use a 64 bit for efi_image_info_offset because 0-day found a randconfig
   that triggered the linker assertions for 32 bit. Clarify some of the
   var names around this flow so they are less similar
 - Fixup some issue with linker script compatability on binutils, I was
   using lld
 - Drop the le64, everything is u64
 - Adjust whitespace
 - Fix efibss placement in zboot.lds, binutils pointed out it is made
   allocated and should not be in bss
 - Significantly revise the header file with the DEN0113 definitions
 - Support v1.0 implementations and issue a revision 1 TPM parameters
   unless revision 2 is really required
 - Review the upstream sashiko notes and reject all of them talking about
   not having enough hardening, the patch plan for security progression
   is explained in the cover leter
v1: https://patch.msgid.link/r/0-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com

Jason Gunthorpe (11):
  efi/libstub: Add generic arch callbacks for DRTM
  efi/libstub: Use free_addr/size as the arg to handle_kernel_image
  efi/libstub: Have efi_kaslr_relocate_kernel() handle extra_size
  efi: Add a __efi_data_handoff section annotation
  efi/libstub: Put the stub's writable data in unique sections for DRTM
  arm64: drtm: Add macro definitions for DEN0113
  arm64: drtm: Update the linker script for EFI_STUB_DRTM
  arm64: drtm: Add drtm_entry point to head.S
  arm64: drtm: Call UNPROTECT_MEMORY
  efi/arm64: Add a way to detect if SMCC 1.1 can be used
  efi/arm64: Implement ARM64 DRTM in the stub

 .../admin-guide/kernel-parameters.txt         |  12 +
 arch/arm64/Kconfig                            |  16 +
 arch/arm64/include/asm/drtm.h                 | 325 +++++++++++++++
 arch/arm64/kernel/head.S                      |  83 ++++
 arch/arm64/kernel/vmlinux.lds.S               |  65 ++-
 drivers/firmware/Makefile                     |   1 +
 drivers/firmware/drtm/Makefile                |   2 +
 drivers/firmware/drtm/arm64.c                 |  49 +++
 drivers/firmware/efi/Kconfig                  |  30 ++
 drivers/firmware/efi/efi-init.c               |   2 +-
 drivers/firmware/efi/libstub/Makefile         |  11 +
 drivers/firmware/efi/libstub/arm32-stub.c     |   8 +-
 drivers/firmware/efi/libstub/arm64-drtm.c     | 383 ++++++++++++++++++
 drivers/firmware/efi/libstub/arm64-smcc.c     | 212 ++++++++++
 drivers/firmware/efi/libstub/arm64-stub.c     |   6 +-
 drivers/firmware/efi/libstub/arm64-stub.h     |   3 +
 drivers/firmware/efi/libstub/efi-stub-entry.c |  12 +-
 .../firmware/efi/libstub/efi-stub-helper.c    |  34 ++
 drivers/firmware/efi/libstub/efistub.h        |  81 +++-
 drivers/firmware/efi/libstub/fdt.c            |   8 +-
 drivers/firmware/efi/libstub/image_info.S     |   7 +
 drivers/firmware/efi/libstub/kaslr.c          | 131 ++++--
 drivers/firmware/efi/libstub/loongarch-stub.c |  10 +-
 drivers/firmware/efi/libstub/riscv-stub.c     |   6 +-
 drivers/firmware/efi/libstub/zboot.c          |  15 +-
 drivers/firmware/efi/libstub/zboot.lds        |   2 +-
 include/linux/efi.h                           |  12 +
 27 files changed, 1457 insertions(+), 69 deletions(-)
 create mode 100644 arch/arm64/include/asm/drtm.h
 create mode 100644 drivers/firmware/drtm/Makefile
 create mode 100644 drivers/firmware/drtm/arm64.c
 create mode 100644 drivers/firmware/efi/libstub/arm64-drtm.c
 create mode 100644 drivers/firmware/efi/libstub/arm64-smcc.c
 create mode 100644 drivers/firmware/efi/libstub/arm64-stub.h


base-commit: 1e7814d34a25521a2ee48b3be8c1bc54f04821f8
-- 
2.43.0

