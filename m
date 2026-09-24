Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012024.outbound.protection.outlook.com [40.93.195.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9189B266576;
	Thu, 24 Sep 2026 13:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790258020; cv=fail; b=G1QVErXmb5YeW9I4Wj7xVnXIXZAwn7AfIugwYPiiBjUmjAA8d5l5hhnOaYUg6pJxdsK8lijBIKCifWvMsdq/syHl5UExHsDfLDdp2LP27ocVjvF0LcMMPjDULdBu+wK6o4nDDH8XbEcyIQb+QyHgWyDRh0+4iEwx+VGjR/L3ERo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790258020; c=relaxed/simple;
	bh=eS+2Ycy++0AcGSj2gwSf3pYsbpV7prtnle8bykm4yHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lXGzCYXuuFiUymrgm5P3GjbiOcJFs3MF3vPeSqDkfzlygSSlGENm7qWbCJGpZOsKVtHArMoGH/5OyRxqXu3GEGt+l8qT4Ebo6DEmuXCpmJwbEzx54Tvb3IDx1HnPc6QiN9G1mu9DDQwrX+s6KkR1Z3idTQpEAFrqK0ozeAgsHy4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Buw+nyxZ; arc=fail smtp.client-ip=40.93.195.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Buw+nyxZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RDXfbNHYl8vcBh7nfnTTdFgktzI/H7ITxvEzZyPn0cOdMCe67PxXIh6XcqcFXtJzwtmv3AkgSbG5HPWP6PqqIPsVQGCj9uCdTHQXvIdbq6dEx1agUmR5tEk5SVkWYXQ5GQfDJ67Pce3WrZbAnvkRMwlAMKw7Oq1HHKzMSV4d6QoW5twhcoRLMlp4SVSeN/uiBI1zSXWYcQ3O0zLNwpWPUV2xw+fqDxZrljJ8VIWH86e3caG5FHSN1Sm4wtDXKvRDwS70uiuq2GrmfR4R230xKuA5CuAwNeq4Ye1Ew73spAs6HRzPbCFViWS/1WRT/mrdKr8joCs789l/cfGMbPZ3zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MgeTuNokBATGCGLhz7e5y66i2OGd/aENlw0yjpQrfbI=;
 b=K5l15H16K1k4lbrUk/A4smdVBGSNjn6J9QBCd4bBq4hCnkHOjwYQiVrLRG3bY43T1TiE+mlY5T2u1T2X7l76LLMDv50B3o2EeYw9uw6+v+L4WKzM6oRa9qLHOATPUjS8M8r/MgpB1ql2GptnGLQB+9wGYqG+lQCItIiuWrIKpXbVX9DOzMocM1eK3UsPm/l56ilH+f4KToiZM9Oag51vbzR9glnTnIcmEWDf/3APnUUuc8bu/d8pPt+k4ViXFYRTBR8P5Hmtru1mhsoJz/cGjF+gLnMMn1nJHt6hs4AstqtX0Jz4dzH2Ab9M6z2FmYb9COGheoEpptAhCbccnJPdgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MgeTuNokBATGCGLhz7e5y66i2OGd/aENlw0yjpQrfbI=;
 b=Buw+nyxZEZFqk6Vjt27nw1XaqtUYoQZ8C1VdwX02yINUUTkW7KF1i5mW7RGdsgj2TUYHCM5axKUMl4p5DDKnyuD28udx4eSOMEL/IcxX/fAKkNzaja+bPeDQNRPi2X9I821kz1DmPG3ip/GJmHyyCZ2+k1bUBNm3NOH+gcexlH6c7Z7uyAHmXcSb3H4H4NJRqsOEYJj/FdueA63a5jqCWwmrJCtD7owepRoMi/HUzlgDOvgWKzqPmpqaMizxBZJYmSrspl8yg5Vv23CSiwYNpc/IjBVSjvxEtZuuRqRJSF2jqpQx27EDpUcJTTZYDw7NB2DQfj2ygQMe0fgcOp6CwA==
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
Subject: [PATCH 15/16] arm64: drtm: Call UNPROTECT_MEMORY
Date: Thu, 24 Sep 2026 10:53:18 -0300
Message-ID: <15-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
In-Reply-To: <0-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR17CA0067.namprd17.prod.outlook.com
 (2603:10b6:510:325::13) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|PH8PR12MB7375:EE_
X-MS-Office365-Filtering-Correlation-Id: dcffe056-3fe3-447c-b432-08df1a433246
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|921020|11063799006|5023799004|56012099006|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	8DDeh+la32H+s5a91Y7zIKBuqIpeSzH0hzMwn9gQVeOkVZ+EpH6385bLgiCVu0bePkqeYPGXGnef3AnCUFipo0IORNC3vReCkF2ff0osUJgrpmLuM/BCu52LzSdziEEyDvaaZl7t7UxWoT3Zo8WbW2mJv6FpkQfrb4DLtIGjlNgmaMj0x6PgWiLGo+IlFjPAKpbeNZHlGw58rJLSBiQuz7dhtf9KEjcKaz6ZAXA1lIuzf7C8dGVybdUOvYxlUwT7EqDqNTnicunCvx3ygX6R/XOwO/dhPLfrCa+QKmF3jTINGND7+MEUTd9Fbga4H5k17MhFkc5zzivhglrswUYk7OCEptACGWsICLJ/YxbYkqq5edIrK65cADulE8vMp8AgWmg3O/k9zuY9T+HIa0koaE8VuyUpcKZllrfy6Jh4kdTl4ZBuBypuQ3JQWp4llwbuBPHnQGRDnNWwzGYBBU18prsTcQ3qOAqwJCIgN6wEeAjk5XY8xFQn9GZToKebbJNDWZ/A0m7XMQ2VDzNPalw3a/hTkHiCepd1tOTAq6T3Kju7YTXlwEbjmnN6X60TPQj0/6B9+AieKSgl5NkYo1tUvo4fS+iU+FTR59rWKAuJoLJPbhudE+qt/P0KxMX8K3Ctlnc9VFtObKA0T3i909pzkeV6mwmjfY+DpMZuVSuCdaeeluY73yUOUcwRWX5Jof8nvHR5vR3HGyievqFWzM7x7A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(921020)(11063799006)(5023799004)(56012099006)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KgB1zxnUAkKy39pETJPdU43Od4QI9H5+tjyu+IhCkESTvDLM12u3A9i+L7XL?=
 =?us-ascii?Q?QCZlmtEO/sKwL2lu/sYfEmVeDfsxY/VEcAEK/85oKhEgfKPsbmQFBd6KPvz7?=
 =?us-ascii?Q?ltrYyyZMcgkA0eDCCidPpF5KJCTlVNT5Tl0EHgdL5HL+z1OVZlGtThjG0X+N?=
 =?us-ascii?Q?NjavU3rjnGS6oMuoBNUIcpEHQ6tXDQRcaXXiwvi0gGq8e/sdh8pQDHLMRNDF?=
 =?us-ascii?Q?IRS3fK91h6F+k+DYiLFSZMIyMrX4dmITvFpF94DdN4EiLqnEoomGsRXD6N4E?=
 =?us-ascii?Q?EYPA8ZLHltG7jOShprE4he4T2NJRs4pmsva73onA/GRYBm13gVBKCK3nlST4?=
 =?us-ascii?Q?omsCF35mus5WCir4XSHr3lb/Fro81Wukr55x2I4Zh5yo8Ag+nwkLvZsp8CEY?=
 =?us-ascii?Q?9sMaqqIW5m6lzNKT6LZMWwyqNDhZKSri4hR/D0i23u5ZYzgkBS1yM7jnvy8C?=
 =?us-ascii?Q?AM1Jbzwats7sptUsTJPkAaUjP/omzg4KM9g9Rq1qWlN7DaRKduqIWDl7jj/Y?=
 =?us-ascii?Q?C4nJuwEs8lg7dNchCGKoE6Xro1L0Jd071g0irijhp9zBPTynQrvU3X/yzMfI?=
 =?us-ascii?Q?YvlZWg5qCIB1OrDrcUSQOHaypZKg3csvdVe3lDm6o/N0L9LCLOTKPitikU2D?=
 =?us-ascii?Q?UD0tBovH71eTG4HbJaCsU8h4is+bNuRRSYcpKiTV2kZ9yFWOtQVMeLYrVNuM?=
 =?us-ascii?Q?scsBIN5QEVQ+qMy/D2LtCf6RaH9RlCN3zVyqy/sI43rzfB3JJq9myp6sr124?=
 =?us-ascii?Q?zLn2xrtWdqssfm6ZIhZDLozXiPJFRbcLUGR+Jq8POgz9krAMYH5SpAu6Sgex?=
 =?us-ascii?Q?YCs10eYWw6u3xYtDdcqwiJ4fj/OpCB+g2Rd3Sm+E4k1QR7uESLQBP7tluxL6?=
 =?us-ascii?Q?6IKW4J4fHP9ocjX0hBBUxCYH5fEbpu14V1eCvEmrM0n3TpDQkcFevz9qLDqA?=
 =?us-ascii?Q?DtdrEC7L779bDON7JsZnb0YV+A6WWQrl7QhJgwA/5EEXHwGwYJ21q5ziRBFe?=
 =?us-ascii?Q?0tcil5pfrDsPEGZLjbx6m/T2JGd6WRtoBAyMlQhMM5/aX9xxCda2RMTeEY+H?=
 =?us-ascii?Q?iBswv9rbwL7vmHiQ93aac1k7thtjVI1t7klifEtdHeoPnD/3x6B6kwhJpPei?=
 =?us-ascii?Q?fq0eEn12HdQlCpSPTRacemBzKyHQubKioLJHKugbDxwAj4SKJT9QQXhjhzEA?=
 =?us-ascii?Q?sJqqTQ2CIDxu9L35T60La8WS1IBynvUDeTIQRRdPRMM7XdSJkXvInczhL9mi?=
 =?us-ascii?Q?XG5yD8EEVSJtzoHziEQWASd2UXlWNyAswwucnQFIvYbkGpqBDUWFCrPIDLAb?=
 =?us-ascii?Q?DqbryQlsqLJVs92fonjTGHKREakbwOwOqSyFKEIVE3IeTBmsNyOsxe2vnMIE?=
 =?us-ascii?Q?4BjNIRWuuKAm7ts3g9peVJLiWFJZFPm9vnzWnzRm7gVATEGoqWgBlvn4MUsJ?=
 =?us-ascii?Q?elTzv1eAaw0D46BvDi01QYD18evevRP6Y0RW9l4OAYkomOhLoto2BXlbcaHf?=
 =?us-ascii?Q?uz1whWb40/rDfhUSUj7yN3LGYFafayLZ+rEoOCmaByoXh7nw9KjGfWyBKZsK?=
 =?us-ascii?Q?hArPbUuM+t9weYAvbNdbC++J4x+qc5t6iqix/hfna2M7h1qvNmCpvuippAYF?=
 =?us-ascii?Q?LSk63WvOlhiSdkyhT2U3olMKiD3UtMg0D6EBTgaqpSrHyPZZpb0DXy0+vNIW?=
 =?us-ascii?Q?i6PYtJhfIIU9UOK0B483ObGX/NfLLm/Gm5+r1kqFFVg9NnGv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcffe056-3fe3-447c-b432-08df1a433246
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 13:53:21.9411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BwJR/hDnKCFG8t+QxJHsqDccSKc+785JgffIWsqj/Gt/6yeBpdS8ZNeydz008Oug
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7375

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
 arch/arm64/kernel/drtm.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/arch/arm64/kernel/drtm.c b/arch/arm64/kernel/drtm.c
index 14493948a27f0d..3d1af2d34c987e 100644
--- a/arch/arm64/kernel/drtm.c
+++ b/arch/arm64/kernel/drtm.c
@@ -3,8 +3,47 @@
  *
  * Support functions for ARM DEN 0113 "DRTM Architecture for Arm"
  */
+#include <linux/bug.h>
 #include <linux/efi.h>
+#include <linux/init.h>
+#include <linux/printk.h>
 
 #include <asm/drtm.h>
 
 struct arm64_drtm_handoff arm64_drtm_handoff __efi_data_handoff;
+
+static int __init arm64_drtm_unprotect_memory(void)
+{
+	s64 status;
+
+	if (!arm64_drtm_handoff.drtm_enabled)
+		return 0;
+
+	/*
+	 * Currently Linux can only fully support a DRTM implementation that
+	 * relies only the SMMU. This should be called directly after attaching
+	 * a driver to every SMMU but before binding any drivers that want to
+	 * use devices attached to the SMMU. Our boot flow does not have a way
+	 * to do that, so for now call it here.
+	 *
+	 * For SMMU based implementations their UNPROTECT_MEMORY is probably a
+	 * NOP since touching the SMMU here is forbidden, but they may still do
+	 * something interesting so be sure to call it at least.
+	 *
+	 * The stub excludes the most likely case of non-SMMU by only using
+	 * ARM_DRTM_LAUNCH_DMA_COMPLETE, which is defined as:
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

