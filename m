Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795197143;
	b=bhT9VRc+HDXMHeMO8/5JWM69DRXQhwR9UJ64D4UBAwynAecSx8ef5e+hFETgfRm3PhBe
	 E79DHmwUBW+hH0weq4eWsjVO/q3ygPo/AOoa02NJmufxqKwHAnbfUtANG7TW+cblAYakX
	 5mEgibI+maI84gAzX2DPUj+HhIJ8kqmK4dOhLOaXGoG75ny9b7lsHBNX/w5kiSshVbB80
	 Uql/XCSw1qrish/QKFtsVB/Kg71/cwFeOlL+oiH3FnIm5ANREY2UJx+QrShWGIgbHbj+N
	 +71qBaer2xnkAkHaEtNI8if9bUwEtbofE5hmOUphuRJHGbZpk1NYmhFlS3q2qIvq0zQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795197143;
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
	bh=+V2Pv5u7tZEWOi11vMXa7wdfnQUir1NP1GiYBLNC9Yo=;
	b=XP4jhD/HW3Xyseoibi6dRGTnPBD/+ctoYTtQN1gqDswKPIgvei9KpF9XMmY36CQnH0VE
	 TfiaQp4qlLVZrdLHTJp0X2KDbmmjj+E9uQedicFyFGh2UuDdO09lie33Osxh8eMVJn9SN
	 me5w+o7aZ6fenAUB4JK7Js4qmL0VNyx+M+45Yf5Z2Psa47eMU3tzfszylUVvpNp0LdI5o
	 AkEYAQmzOhXAJqqA+IHoM+m2d52mkC9vMpKuqXd2Q6/vSEawkTyLbPN4mZ6KRfft8rwaU
	 3GUaohgK+bD9C8akIol9WGpMxpIw74Edbmxo36mbBNxSEaaa8omXwTxp3mO6DtovAyQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=HE8VOYxb;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.28
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011028.outbound.protection.outlook.com [40.93.194.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF0E60A2607;
	Fri, 20 Nov 2026 17:52:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8EF0E60A2607
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=HE8VOYxb
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fa/xYHb+NjEFISPJsCTARU4uZU+rS31K3yqrB+rPkBYQ9MwqmFvb3EocgC5ymdtbbi/dZemH+oMUOsmNNm/3SmDcl9GqGSOhqP8PNWT175Y9++c3PWCTeI5bw3T9hD5nQf+Kf8uOnFpY7fwW7CRkUa+PabJHALxUw2piLJ2Qp5nkR7MA0so7UIrsvL6On2mz+AqK9qHW2g+85GygS4Uvc0pjieWbdxxJGzJXMn+Pg4wXuN96FVfG47CiWzL9fzS/It1lDAyfgFly+qsEZYCatgdEMxEL4AY9+qzEYHdVoPbM8QcXHQQcasuUcCjvdxt8NL6S0lTaTi43YTZ5CwgzsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+V2Pv5u7tZEWOi11vMXa7wdfnQUir1NP1GiYBLNC9Yo=;
 b=Gupr9klpXVO5uKtwnRBufL3cB56hK699ixhAGtTdsbDCx3qdgfYmtC4GtuFDwI9JNuUM06E/FZLo028ufG8rJ4JO+866U7HPaGlKStIkz+8/aJa3f2kGcShwLUM3sK2CkRK6yB3l0OcTngazLTzTnZh/bCJ8qGIsm4dHrSQ85AZ5Yu19oHlizfTgB8+TpX4VyxbQEbdEtvdIwrvuAJn2n+0MdaxpQsWufHwud2bP/NW0qiXwWhyX9OWqZxLzIL+XolT9Y7/lahLpt3g8tAbxDYs4i7iI/ESGNBPjzXtCyqmwhd4ZEH4z/0UQY+aXkAncdjbEQd+hBdSQYHubts8PvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+V2Pv5u7tZEWOi11vMXa7wdfnQUir1NP1GiYBLNC9Yo=;
 b=HE8VOYxbFxRZDDLeQhsC46oYIC8RtxQ+Bhd/s8nfeilHUrTI0u/NsYDc+XUFDvWi4iuaas0XlWNogvJIVE2c3Uh7xyO1xejKiZd6d1Cpm2vrnOSxzFzKt09bJbmqRLZcQd0kKVcaXUNyrQVgXYhTxeTl0cPGI7GFQnjMmGlFd54bWzUp/eA/YUj6UrOjuYsAYYZm2kox3cxkSkOilyKyw+sfF2CC95YuZ4yA7qBP09Z355EKgHiJayzlmdtktG2GZrK+MPkYmVBtjUEdhuLP7yAq6p8krGuhd6cF6sguZriGHK7SCG3WN7zakuU4YpBVm1dBuNlZYMpJ8VYV6CpYNQ==
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
Subject: [PATCH v3 09/11] arm64: drtm: Call UNPROTECT_MEMORY
Date: Fri, 20 Nov 2026 13:52:02 -0400
Message-ID: <9-v3-22d1a1eb7d2e+17de-arm64_drtm_jgg@nvidia.com>
In-Reply-To: <0-v3-22d1a1eb7d2e+17de-arm64_drtm_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0737.namprd03.prod.outlook.com
 (2603:10b6:408:110::22) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 9996a294-d6c6-4d78-6a1f-08df472efe86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|18002099003|6133799003|22082099003|261009223027099003|11063799006|5023799004|56012099006|921020|261102123227099003|261028144727099003|261026140227099003|261026121527099003|261021121427099003|261022105027099003|261022075727099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	fFvIyOgRCVV6yYl8HK927lVQaoKC4GEJWUmni0nUpOkqZ0FwSFqS9FhnEIGk7VsDpVnHbh6IuzTL0VoXolwp0gHX6f7XtZUghfpwBFv8BkE8PjqiT4cdM0/m365h5/0AaCYZqhXOazj27KvX7RLGs4u9q7aygbRJOVvfUzeLzL8WJXTfK68/qfsgevY5ODINhkPd4XGio6H7Yf3OfcWE9mLQI9+A60CIorIUOkfIkG7q69eJ33T0xJWZjXsbuOSYllG5BnBhhIhXiM/9OS2R1jvgjdIpOsNDN5JC6M61fURra2jbaCsF5RuFBPmyMVXuTLYzKAFrl7+36dck0oTgqXO3RKdacsT01LYDyMJgGdmCAAB5m20/h39gdGi1fpp7K4sK7bZOvUc9BBgkcEXGzzp+v1KtpMaA+fR2fq0E/aFtwLwY66UUgyz0M0FYm8oXZwysl+tTc+f7dRswpqAk/ObnWozd9Z7iMVTST9qbZXuMtWr6wBFEeq0EPhqxcXpduAk8Wp4ybE7biQ9DBz9KJ5u4tx4v44LehCGjarJGmKS8h1ovNW6fWzDywu+t8IIXaNDXojRbsEpF7lrdSxnt8xmhhYvcIUdIV+JGdXpbe7OYxQ7/+HZFNR05TJeGOtbXPqn3P9zucsX7JwBKoRgk0T7aEicbIuykUuRRnDi6OHkb7KFeqLjwb75hGYKYtyIqlGHMXqXKwAga86B6JBQd7Q==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(18002099003)(6133799003)(22082099003)(261009223027099003)(11063799006)(5023799004)(56012099006)(921020)(261102123227099003)(261028144727099003)(261026140227099003)(261026121527099003)(261021121427099003)(261022105027099003)(261022075727099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6BCXEPpKBOAMIYXuJ4KOCK+lDujrcGbVqc5QRLMLFG4GkS2BF7CRli3V0/lI?=
 =?us-ascii?Q?FGByS2JyHUOLa1SrWvvGPTlb963nRa6h9V7GaSsoFSeDGVDqRLebrYjz7l8e?=
 =?us-ascii?Q?TUrfsuOAb+155LcOm7kXW0IS7qQBOd4y2HTvYAsypn692ZqEgkhSiRjgDsVz?=
 =?us-ascii?Q?TVc4alG/oSauCFhFajxyl0k1CHnmB9reVEg/s1NEimUbWcl1bXfQUehRhj/p?=
 =?us-ascii?Q?UrBqjh2AwqvyreReeZVPUH6DDXYiZAZDUsP7TdKmEIJ2+C1yja/d2oSjuQ8+?=
 =?us-ascii?Q?+eYY70LusZN6Zu3zpY77AoXLSLXAoLtAzYNUDZXqyLQtwKCaWqBebq4eLIbT?=
 =?us-ascii?Q?mDu9VLHi5dTKJVGTVUs0DQ1i3kWn8jbYMG9iqs9oZ4fo1pgUqqSWbEB7icje?=
 =?us-ascii?Q?CE780daijkw8tsrzhD2iFf1yw7hWgZIzOThO2TFWWQf+ufULUQGo5qWDWJFd?=
 =?us-ascii?Q?lamOX60JC/PoympBFjreqKTTxJjjh8s9zBtY36/dzOpf1ChHyjOG8PDUf0AS?=
 =?us-ascii?Q?iyW110bQMUuMoTuvk/aH6c7MwCzars0DIWHRtfb1f+9Uf+CJMv2jhIvpCy5Y?=
 =?us-ascii?Q?sYvuHoCsBxG97ne4m+w602A1bgc0TKJh2SaO90FKIbQecCmJ5WjfOALggUut?=
 =?us-ascii?Q?juieQTEPE8fniZzkf+xrZ+WG23vIDQuSVlJy8dGKq6ULKz8BgOPjNkND+wnh?=
 =?us-ascii?Q?WUA5paeX4TNL70BhMTrwGvm2LKDFcNOxiTNLsYPjIQBg8Emkw3S60EokPmQ4?=
 =?us-ascii?Q?6EKIFdm2yiQ12GQv/zYHjQPZn6gUkVjHtSIZRaKgoo2va/ZUly/3OksUuJ4u?=
 =?us-ascii?Q?eb5ECmNW/PEcAF/DlDyVK11IzrnGZNOyIVmGKMaDwHVll5WNT2PCa5JCCraU?=
 =?us-ascii?Q?QzGqngEkuUmMwdzWpcMXCVyPzwTXPtbqb6sLT5ysxzFBqIMOlbOI6RmplxaJ?=
 =?us-ascii?Q?Kji56ec5OUIsySQRnbO3Ktw+YpGK7ZqnYAiz4qV0BkxLjmJrsGkCx1azipHS?=
 =?us-ascii?Q?w0lPBoW+bMwAWklXlWZybxxHNsNO6QeNPRrRDnxpE6TPXGB8nf6CC3oSc0Lk?=
 =?us-ascii?Q?ENJOgXsHlotjDZrNH3dDOQhm4b3MlwGLycAREPimuzUF2v1H1aczsP0MBnui?=
 =?us-ascii?Q?kLS+QtEHGlsXw/2uqbWdy+eq2pRuPY71l7yjRMGozq0hqKa2lgcLt8wHyTD7?=
 =?us-ascii?Q?ncNuAkVCdZfaJ88ejrpQ4ivOLtxGcha3zXO2gHqqhyOR6mwuAN5m+F70eICS?=
 =?us-ascii?Q?4i9BLasI3Uxpx68pU/6JOZwX/t82H45+Dt8+t3ahD6WysH1WhWPN1ZQEieSa?=
 =?us-ascii?Q?2XiyebswpTyTLCMJZ0qe6JNalCF6aRScOEAM7++mohuITXoJjlElwAsrx2Sj?=
 =?us-ascii?Q?gR46iixI/9bnJu/ecaf9NSt7x8pAs26oDR9y0mzu2o8PB5hesNo2lSu5O4Xy?=
 =?us-ascii?Q?DJkLDWrM/OxWk70teSiQnSo/6GwX3oLXntPWn5squtqOWispQLfyaXcWRPsn?=
 =?us-ascii?Q?vrZnlzJ5MCNvC30azFu9T1mXnPobB0GRIEOFaA8ZLl3zhr4DxCZAcqEqxRWm?=
 =?us-ascii?Q?1BhTmIDLIv2cGD7bg/Cc4mvEOSaHCYZQKjt8W3Q8DlOemOFGivqPMTENjjns?=
 =?us-ascii?Q?1K+XrELTwH8/o12Ow7mMzm9cSC/Un0UtkdnZxXaOmxott8h59AiJyW8hY0lW?=
 =?us-ascii?Q?OPhSmBrncKAwAvjHlbM/udtqMPsL4PwKH4/lFUvYI/3zLxRt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9996a294-d6c6-4d78-6a1f-08df472efe86
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 17:52:07.5165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XSzzxnTtnc5BAbf7ZnT6v0le1CLR+o4uInXiUNusV93rt3FnPcEMSygdWFoG5HTp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6329

The stub always requests ARM_DRTM_LAUNCH_DMA_COMPLETE. On a system
with an SMMU the COMPLETE option is sanely implemented using the SMMU
global abort register. DMA_COMPLETE should be mostly a no-op. It
seems to be designed for the region protection mode that Linux does
not use.

However, the FW can still do something interesting under it and we
should call it. Choose late_initcall as we know the SMMU drivers are
loaded by then. If some platform does actually block DMA beyond the
SMMU, then this would result in a noisy failure of built-in driver
DMA, not a silent security gap.

The platforms I'm aware of are OK with this placement, and it is a
reasonable place to start.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/firmware/drtm/arm64.c | 39 +++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/firmware/drtm/arm64.c b/drivers/firmware/drtm/arm64.c
index bf736ceb7f0368..07783d55275fd0 100644
--- a/drivers/firmware/drtm/arm64.c
+++ b/drivers/firmware/drtm/arm64.c
@@ -3,8 +3,47 @@
  *
  * Support functions for ARM DEN 0113 "DRTM Architecture for Arm"
  */
+#include <linux/bug.h>
 #include <linux/efi.h>
+#include <linux/init.h>
+#include <linux/printk.h>
 
 #include <asm/drtm.h>
 
 struct arm64_drtm_handoff drtm_handoff __efi_data_handoff;
+
+static int __init arm64_drtm_unprotect_memory(void)
+{
+	s64 status;
+
+	if (!drtm_handoff.drtm_enabled)
+		return 0;
+
+	/*
+	 * Currently Linux can only fully support a DRTM implementation that
+	 * relies only on the SMMU. This should be called directly after
+	 * attaching a driver to every SMMU but before binding any drivers that
+	 * want to use devices attached to the SMMU. Our boot flow does not have
+	 * a way to do that, so for now call it here.
+	 *
+	 * For SMMU based implementations their UNPROTECT_MEMORY is probably a
+	 * NOP since touching the SMMU here is forbidden by spec, but they may
+	 * still do something interesting so be sure to still call it.
+	 *
+	 * The stub excludes the most likely case of non-SMMU by only using
+	 * ARM_DRTM_DMA_PROTECTION_COMPLETE, which is defined as:
+	 *    Complete DMA protection is hardware-based enforcement at the SMMU
+	 *    that blocks all DMA from Non- secure devices."
+	 *
+	 * For now if people have such systems they cannot include built-in
+	 * drivers for any DMA devices, those have to be modules to be ordered
+	 * after this.
+	 */
+	status = arm_drtm_unprotect_memory();
+	WARN(status != ARM_DRTM_SUCCESS,
+	     "DRTM: failed to unprotect memory (x0=%lld)", status);
+	if (status == ARM_DRTM_SUCCESS)
+		pr_info("DRTM: launch completed\n");
+	return 0;
+}
+late_initcall_sync(arm64_drtm_unprotect_memory);
-- 
2.43.0

