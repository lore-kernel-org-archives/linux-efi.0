Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795197141;
	b=kOlgvh7994dz7v02dNx9igvP6p8KZl6oXwVAVqbJhn2y82hgc+Mssf1fsL4Rhc67lyAb
	 qF8FQOY1Tn/rnE7QI/VC4XQei+Tsa6EfBKVlsphw9HC1LAL4Nkc5wGTS7E7wn2s/ord64
	 LKUFq8m7V/xKZw6eFA/pGj7fHtUvwaFTRwJTmaPH8EyPBM5tZlgOpBWxYzV0CRipicUP4
	 PUXZK8RU1Y8b3urGnKAA9MU5qzKH4IoZCbei4rZp2H1DQd9U086ZPctiV+ZJB2GIGY4et
	 nGO+a/uJ3kCJ7WCGGKjpPcxjNjPtmIb1ZIfXQnthNcfdKGr4WQ8AF34w2BwKFmAEbgA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795197141;
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
	bh=FFXq79dT+fk3w3JE9kPi1vOCjtxN7RIp01dx8RKsFuQ=;
	b=LlLVJdT/bdVj0Lo3Vtn8qHYtbuw+LvZXE+p/SDzKNyjR1lhGVTCPEjM3nruZc9dP3zvG
	 U6XJKBgskobtT7G4xiJucmXtLSrwO9cKEfyJ0IRW1H/OPbJyN8dv4oyqxQC+Ffjgi/aoC
	 CmpRb025b76SNiptMgzvu1j3m+pNR1SI9TybKoc9N+31q8YJhBULtebnTd4jOjwVwOC4s
	 Y+Dm7ql2+GCnsAPUl6uE34fJ2YSDrhTYD3blJxoha63TBZAtpk5AeD0SpU86L8Avvgk4t
	 lCnkzisapsiS0CdeafItA2Ez/b4N61HZFLkuzUtEwG9jA5gO/vRYJ4WwbO4Px3Sk/0A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=NBfjb13j;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.28
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011028.outbound.protection.outlook.com [40.93.194.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0031606A33C;
	Fri, 20 Nov 2026 17:52:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A0031606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=NBfjb13j
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RiBBcX2cqbzI63m7xMaNQmWxzcRERuSU28+oLSZT54doRjNk0exeQ7UXr5hkoR1u9E0lBHEp4nxiYn2y5rfXJ/vV+dP9lmF3Soa0RpWq7QCZBP8hZIwLv2z4Xa7tgYIZtB27kTUESgi5OyE0A2n2a6hnJmNDjHYIUV2+EGT6ZmjINP8Lz6vv6kXbkcJp4VlbliB2a4mV7zOTa42Z9mzBW92+ue0A+lVtRProiSVvmXiK+9JCYuI7+hFB/CXt/sJnexuPDJ0M80kCbssLhmZrxe7AzGsiffqjJRCSVPqKzHd0eXrGsUPWQTdLPkbLPS0NL50WuDetdz3F4zTMMFkRzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FFXq79dT+fk3w3JE9kPi1vOCjtxN7RIp01dx8RKsFuQ=;
 b=UyckazTDE1d1VkIcoycUMQ2yyOa6tDUGCpYlTFgXbf7sYu7L2oczeLPXCgJ/3sv1BA4FMAdFg2I7r3FsKscY2TCAw7+Px9PYa+T/JykyJPWGCSvx9n50OhALm9WevogEEjcVFKN62wgJb02YTkks9fKpgUt+HedZyP5AkvLoh0KSA3YOrp5fgwnbyJxpTiCP02MfZ/gGNCktvTvwuqD7MaC0ORPW+IE02jxnXxccodjW8pbcf1o0+G4An8pzK4WCGcBmU2+Qb0NlBWzVPLs9S2yD9RcTU9AWxnzfGbgO9ITb9biLD0W1BveAQTbTvG2vqWtBXiLgxnqK5zI9JO3TDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FFXq79dT+fk3w3JE9kPi1vOCjtxN7RIp01dx8RKsFuQ=;
 b=NBfjb13jTAy3t7baUWRT1mrXPdKZp4m6t7u7O6tCslHV4TNLGcSSyB3eQ+J6f4Dac17pZsj/LmJ8UaOv9vaU34AQH7ckBDgpOjsxHIu1ArmV/sJnS4GSsVtgsh3D8TqZ58P5MqQ27zsAI4WZbZ+g63pCNHjTZ6+TsMG1cfQyQvJ+ae5VhHZV864HBk06CKY8zU1S19hbcETPSkajkZK193U6HvJnWP9mHiFONDQ0dR0lEQatBNBikGvQ2AglYgrFcncBMXHLCjewx/4R83Raz+gTfNRD8XYA3/XxOf5NNlSkMxZzwMtCYMFb2ibhKPLounFX8YP0AQhddMcne3klsQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by IA1PR12MB6329.namprd12.prod.outlook.com
 (2603:10b6:208:3e5::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Fri, 20 Nov
 2026 17:52:10 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0639.010; Fri, 20 Nov 2026
 17:52:10 +0000
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
Subject: [PATCH v3 08/11] arm64: drtm: Add drtm_entry point to head.S
Date: Fri, 20 Nov 2026 13:52:01 -0400
Message-ID: <8-v3-22d1a1eb7d2e+17de-arm64_drtm_jgg@nvidia.com>
In-Reply-To: <0-v3-22d1a1eb7d2e+17de-arm64_drtm_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAP220CA0004.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::9) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 926d9b36-11ff-463a-9844-08df472efe21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|18002099003|6133799003|22082099003|261009223027099003|3023799007|11063799006|260925021911599003|261022115727099003|260925022911599003|260925021311599003|56012099006|921020|261102123227099003|261028144727099003|261026140227099003|261026121527099003|261022113327099003|261021121427099003|261022105027099003|261022075727099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	Fz3jObtsxHj8ZzLWoUSurKBW9Jb3VC0sEiJCKBDlzwTntBIdunsf5s3lizRV/8Mu/4swogL4CCvDiRm6+8Fz8jc5IYfpzfs2mAeGsn1T/b4vZXhvByKyI+Lk7LN+krkBuAcUFZnJT/Wz6DNaBWkKHxUEnEbOn7qPEs0lGW8QoJnlily6M7kXnGOS6vwZlHUxyiwEdzOtjL5HLIwY0oM537i2LxcZmmADF+ZO6XT998210B3iKldAnJF96tVBBSeQKCXGxoIDgAJGCDEzxNfocnM97E0ARSA536c704umEUqXpTYye9m5DhyclyXO0EQMYnLfBZiwOoRMyFvBLtdFO4lT3zs8KNlZGIGYW8oWGNHERqCVyHSs4eehrd+3gcW+I1pbFtZRUSX+yJQmHDZbj5DXq6UifKgbXMLzY8K6sgRz3RSLaUNKQNiv9QcMPZ1rnf2hF65mBEwovzsiDc0A714o28UqDaYX65AjR16fUPIm093nfhn2amFsFY/nyYTi+hUamt2Gq4GKhFVXEPrChNW9HII/AgIjQBOOFbWaniRlzbcO8n8Ik7/o/1IhU5W+4/JyLku3SDqvax7oixUAIIF6DUha59JhEp4tdyiPXouAbXA3LrWQc49c3sqe8IsrKJAXd00iZjLnpE8xnIoidCcAO61r85U5xH/xn+r21mgHBKkEaRbg0h1vcHZnaa6qqnGf4H/AZSmfzm1H2Qhrjg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(18002099003)(6133799003)(22082099003)(261009223027099003)(3023799007)(11063799006)(260925021911599003)(261022115727099003)(260925022911599003)(260925021311599003)(56012099006)(921020)(261102123227099003)(261028144727099003)(261026140227099003)(261026121527099003)(261022113327099003)(261021121427099003)(261022105027099003)(261022075727099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LrNAkOIFRomYdRq7+j4pasQL8zhIGbxPd8c9VvyC//DQDGPKXda/i81ayeAs?=
 =?us-ascii?Q?Ld4pTWlH/l/p8PvvvlHsB493jjao/7FoTWHOXPcwrXc7SAd5DWfiyTsbJCZO?=
 =?us-ascii?Q?KFYCQ45FK5gAgqan++GtZVNofWunUkzvvDsDbvQuB2plnkv8qYzIr40Z+d9A?=
 =?us-ascii?Q?bgXoJuO4dux6vocQADqOIqs2FpNd5BlKp6ndEey1NfWJM0Sl6MPMJr0I0mIj?=
 =?us-ascii?Q?Uab+Pou7QTj1dLpSJ1N6JsQc9MAxkbGgD45mGJOJze7pwDUt+YRFfWxM1F1v?=
 =?us-ascii?Q?aaOq+Awhb+524hEKrbL6KJHurXdI1cms/ZkT/UmAz/wCDJ8tSz8NtwblduF9?=
 =?us-ascii?Q?WyuaOCbpMQ3eVNK/6yXXnizw5LVjtblaWRIUM+MA93uqL5SUp5GUaLacjBFf?=
 =?us-ascii?Q?17NEg5zmEhpUtzMGPmfBcDVRYxvssLXJzK1QUl7f0jTBX4plJs+a0ZWYYyVO?=
 =?us-ascii?Q?gfhozipY0Ewo1GNnXTBh4gdYC6TONgVwPPziYpIBTnd0V8vJwyz0Ldu6ba7f?=
 =?us-ascii?Q?42I1Hnj7sbg1KouRfh6IOuX4ypogEqO4oXdK6nmYedkmOo726dXP1+8P6U5x?=
 =?us-ascii?Q?W+CKdgZMLV7XgNmr5UJFhtH9VmtKY7k+RZkrWFAieHjKRKO3GyqTJArmmbnD?=
 =?us-ascii?Q?TqdicNFtjJ0uW9iK46KcqB27kRYuQGZeoqTXUFzcIsd6IzdXvmzJ7JswqI6e?=
 =?us-ascii?Q?EFz3qt0GXxVcjfUuW5Q7tob/a35avWbUSz+YV6Qv7/YrIbp/daY1kcY1PRA3?=
 =?us-ascii?Q?w+o+/HBeDc3JTUQwJZ6IqBAJQpLYCo2H+AuCZWj4+kPxN6K2//4lhzYLrZ0B?=
 =?us-ascii?Q?pywLJ4zCEcAVIafZY4mPtzCTW7rV55zYE9yIIWlYmhSbtEQ4aIwYbmWZ5HNl?=
 =?us-ascii?Q?makixyrH6w9JRjbviTTRSXnxEwN9XCmJJgAIkSW2kgOxWt3oben1rCUggY/T?=
 =?us-ascii?Q?jF1M5Rc52Ut69EjdagIPTPYZYMZa0VGs3negdLtVJZNfqCfSjMKdbua+vD99?=
 =?us-ascii?Q?Fn8IA6Oz7cf378NAM/PIpUtChlVRFhVT/AlvmR1bPF+HtXA43WUPifHmmcIl?=
 =?us-ascii?Q?jWNK44k7Dw2lcTRUEiP2g1KcVncXdAv3XlzeRSnPOmh6xvTt1WJb2AZT/9Rc?=
 =?us-ascii?Q?JyRae+JK7kcxYMBa7IPe/7EHXUVqe3/IG/WhYRXTP5rkeQuiPgyPmClSV98l?=
 =?us-ascii?Q?DedKHcQKadB5CNwzRsBjCaY/g3eh9B4Dap0dhEohjtOItrotO/HRUuntekM9?=
 =?us-ascii?Q?ZmBnoOqfCt5Vx/NBpCoSQ4h6r4Bz5ISa3P5r1crSOwhDMZNHJ0MfvjgrC3WV?=
 =?us-ascii?Q?uhBBvHwhoYICCoMVMsi+XJaB5R5wG2TDZPxgxNnatSJW4WBVjH2lozCtVRzk?=
 =?us-ascii?Q?S9yRM5Um5k9kX3TYY81enHb7rg0gmBHpHhMyxZIDUm6yxS9ZwfYzri1SELJU?=
 =?us-ascii?Q?JCzgL+lbLvKeQzRRzl/fP9oQsBwKYVf7s1ZrTvzAH/zPrBPFbwYucqOwq9UL?=
 =?us-ascii?Q?xpvqIHUsXv9N/m8f5dIw7+gybFvgZ4Ks3Hxdq8VdH5J7nRpRWm3pnUQzNI8/?=
 =?us-ascii?Q?fvFF7N35X/IoudsPK850k4SJJnsAmKdaJrG8H/9TBC6yD4YR8nq8YvRlgLxG?=
 =?us-ascii?Q?Ufy52tmwHbf/6WP3D0Y9dRIN01nxmy3SkywVjpQlxJDNZLGJ/I6u8PJZh/EL?=
 =?us-ascii?Q?qydnWmOxN4d2Y32lrYqu/X5CfLdFojrav3SSZg0h/ffxXy8B?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 926d9b36-11ff-463a-9844-08df472efe21
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 17:52:07.0581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fE7bgKuLA2V+AKMk1QiPRBsBHIQBWB3/pjTdyC30w/an1C+D4Nst5fyEFnJuQK9v
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6329

The DRTM launch defined by DEN0113 cannot use primary_entry because the
spec defines a different launch protocol. drtm_entry is a small trampoline
that validates the DRTM provided data matches the location expected from
the link layout, acquires the DTB through an EFI stub writable handoff
struct and then jumps to primary_entry.

Add  drivers/firmware/drtm/arm64.c, as later patches and series will need more
kernel side functions.

Passing the fdt address like this will require security hardening in
future series.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 arch/arm64/include/asm/drtm.h             | 20 ++++++
 arch/arm64/kernel/head.S                  | 83 +++++++++++++++++++++++
 arch/arm64/kernel/vmlinux.lds.S           |  6 ++
 drivers/firmware/Makefile                 |  1 +
 drivers/firmware/drtm/Makefile            |  2 +
 drivers/firmware/drtm/arm64.c             | 10 +++
 drivers/firmware/efi/libstub/efistub.h    | 14 ++++
 drivers/firmware/efi/libstub/image_info.S |  2 +
 8 files changed, 138 insertions(+)
 create mode 100644 drivers/firmware/drtm/Makefile
 create mode 100644 drivers/firmware/drtm/arm64.c

diff --git a/arch/arm64/include/asm/drtm.h b/arch/arm64/include/asm/drtm.h
index 34201bc092bcc6..e74328808466c0 100644
--- a/arch/arm64/include/asm/drtm.h
+++ b/arch/arm64/include/asm/drtm.h
@@ -176,6 +176,10 @@
 #define ARM_DRTM_ALREADY_CLOSED			-11
 #define ARM_DRTM_TPM_ERROR			-12
 
+/* Offsets in struct arm64_drtm_handoff */
+#define ARM64_DRTM_HANDOFF_FDT_ADDR_OFFSET	0
+#define ARM64_DRTM_HANDOFF_ENABLED_OFFSET	8
+
 #ifndef __ASSEMBLY__
 
 #include <linux/bitfield.h>
@@ -301,5 +305,21 @@ static inline s64 arm_drtm_enable_secure_interrupts(void)
 	return res.a0;
 }
 
+/*
+ * Since we cannot pass a parameter through the launch to drtm_entry any
+ * additional data is written by the stub here.
+ */
+struct arm64_drtm_handoff {
+	__le64 fdt_addr;
+	u8 drtm_enabled;
+};
+
+static_assert(offsetof(struct arm64_drtm_handoff, fdt_addr) ==
+	      ARM64_DRTM_HANDOFF_FDT_ADDR_OFFSET);
+static_assert(offsetof(struct arm64_drtm_handoff, drtm_enabled) ==
+	      ARM64_DRTM_HANDOFF_ENABLED_OFFSET);
+
+extern struct arm64_drtm_handoff drtm_handoff;
+
 #endif /* !__ASSEMBLY__ */
 #endif /* __ASM_DRTM_H */
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index d6ba3c0af81190..dbc8a7cc0938f4 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -21,6 +21,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/cache.h>
 #include <asm/cputype.h>
+#include <asm/drtm.h>
 #include <asm/el2_setup.h>
 #include <asm/elf.h>
 #include <asm/image.h>
@@ -35,6 +36,7 @@
 #include <asm/stacktrace/frame.h>
 #include <asm/thread_info.h>
 #include <asm/virt.h>
+#include <uapi/linux/psci.h>
 
 #include "efi-header.S"
 
@@ -131,6 +133,87 @@ SYM_CODE_START(primary_entry)
 SYM_CODE_END(primary_entry)
 
 	__INIT
+#ifdef CONFIG_ARM64_DRTM
+/*
+ * Entry point used by a DRTM launch. Verify that information provided by the
+ * EFI stub matches expectations. We rely on an untrusted-write/trusted-verify
+ * approach so this doesn't have to deal with writing to cache-off memory. Per
+ * DEN0113 R45380, the launch supplies:
+ *
+ *   x0 = physical base of the DLME region
+ *   x1 = offset of thee DLME Data, which is several tables written by
+ *        the launch to pass trusted information to the post launch kernel
+ *
+ * These values must match the link layout in vmlinux.lds.S or the launch is
+ * invalid. The EFI stub will get them from the efi_image_info and pass them
+ * into arm_drtm_parameters.
+ *
+ * DEN0113 R45450-R45470 specify the remaining entry state as the PSCI CPU_ON
+ * initial state: AArch64 at the highest Non-secure EL, little-endian, with the
+ * MMU and D-cache disabled and Non-secure asynchronous/debug exceptions
+ * masked.
+ *
+ * Per DEN0113 R45220 the launch cleans and invalidates the whole "DLME region"
+ * which is everything from _text till past __drtm_dlme_start before
+ * it measures the image. Thus the handoff data written into the region by the
+ * EFI stub is safely readable here with the MMU off.
+ */
+SYM_CODE_START(drtm_entry)
+	/* Verify that x0 is the runtime physical address of _text */
+	adr_l	x2, _text
+	cmp	x0, x2
+	b.ne	.Ldrtm_bad_entry
+
+	/* x0 + x1 must be the runtime physical start of the DLME data */
+	add	x3, x0, x1
+	adr_l	x4, __drtm_dlme_start
+	cmp	x3, x4
+	b.ne	.Ldrtm_bad_entry
+
+	/* Stub must set drtm_enabled */
+	adr_l	x4, drtm_handoff
+	ldrb	w2, [x4, #ARM64_DRTM_HANDOFF_ENABLED_OFFSET]
+	cbz	x2, .Ldrtm_bad_entry
+
+	/* primary_entry(handoff->fdt_addr, 0, 0, 0) */
+	ldr	x0, [x4, #ARM64_DRTM_HANDOFF_FDT_ADDR_OFFSET]
+	mov	x1, xzr
+	mov	x2, xzr
+	mov	x3, xzr
+	b	primary_entry
+
+	/*
+	 * Can't continue, launch is corrupted, spec says the DLME can call
+	 * SET_ERROR which should forward the error to the next boot for
+	 * display.
+	 */
+.Ldrtm_bad_entry:
+	ldr	w0, =ARM_DRTM_SMC_SET_ERROR
+	mov	x1, #ARM_DRTM_MAKE_ERROR(ARM_DRTM_ERROR_PHASE_DLME,
+					 ARM_DRTM_ERROR_ID_VENDOR, 0)
+	mov	x2, xzr
+	mov	x3, xzr
+	mov	x4, xzr
+	mov	x5, xzr
+	mov	x6, xzr
+	mov	x7, xzr
+	smc	#0
+	/* Cold-reset the machine as required after reporting a DLME error */
+	ldr	w0, =PSCI_0_2_FN_SYSTEM_RESET
+	mov	x1, xzr
+	mov	x2, xzr
+	mov	x3, xzr
+	mov	x4, xzr
+	mov	x5, xzr
+	mov	x6, xzr
+	mov	x7, xzr
+	smc	#0
+	/* FW is really broken, just hang. */
+1:	wfe
+	b	1b
+SYM_CODE_END(drtm_entry)
+#endif
+
 SYM_CODE_START_LOCAL(record_mmu_state)
 	mrs	x19, CurrentEL
 	cmp	x19, #CurrentEL_EL2
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index f4e9fd90cd1b12..a68881189f2313 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -380,6 +380,8 @@ SECTIONS
 	 *   DLME Region Address = _text's PA ie the start of Image
 	 *   DLME Region Size = DLME Data Offset + "Minimum Size of DLME data"
 	 *   DLME Image Start Offset = __drtm_measured_start - _text
+	 *   DLME Entry Point Offset = drtm_entry - __drtm_measured_start
+	 *                             (in .init.text)
 	 *   DLME Image Size = __drtm_measured_end - __drtm_measured_start
 	 *   DLME Data Offset = __drtm_dlme_start - _text
 	 *   Normal World DCE region address = PA of __drtm_dlme_start +
@@ -466,6 +468,10 @@ ASSERT(__hyp_idmap_text_end - __hyp_idmap_text_start <= PAGE_SIZE,
 	"HYP init code too big")
 ASSERT(__idmap_text_end - (__idmap_text_start & ~(SZ_4K - 1)) <= SZ_4K,
 	"ID map text too big or misaligned")
+#ifdef CONFIG_ARM64_DRTM
+ASSERT(drtm_entry >= __drtm_measured_start && drtm_entry < __drtm_measured_end,
+	"DRTM entry is outside the measured image")
+#endif
 #ifdef CONFIG_HIBERNATION
 ASSERT(__hibernate_exit_text_end - __hibernate_exit_text_start <= SZ_4K,
        "Hibernate exit text is bigger than 4 KiB")
diff --git a/drivers/firmware/Makefile b/drivers/firmware/Makefile
index 50b3383131522d..7f74fd1bf75bda 100644
--- a/drivers/firmware/Makefile
+++ b/drivers/firmware/Makefile
@@ -30,6 +30,7 @@ obj-y				+= arm_rmm/
 obj-y				+= arm_scmi/
 obj-y				+= broadcom/
 obj-y				+= cirrus/
+obj-y				+= drtm/
 obj-y				+= meson/
 obj-y				+= microchip/
 obj-$(CONFIG_COREBOOT_FIRMWARE)	+= coreboot/
diff --git a/drivers/firmware/drtm/Makefile b/drivers/firmware/drtm/Makefile
new file mode 100644
index 00000000000000..658798bfd17801
--- /dev/null
+++ b/drivers/firmware/drtm/Makefile
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_ARM64_DRTM) += arm64.o
diff --git a/drivers/firmware/drtm/arm64.c b/drivers/firmware/drtm/arm64.c
new file mode 100644
index 00000000000000..bf736ceb7f0368
--- /dev/null
+++ b/drivers/firmware/drtm/arm64.c
@@ -0,0 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2026, NVIDIA CORPORATION & AFFILIATES
+ *
+ * Support functions for ARM DEN 0113 "DRTM Architecture for Arm"
+ */
+#include <linux/efi.h>
+
+#include <asm/drtm.h>
+
+struct arm64_drtm_handoff drtm_handoff __efi_data_handoff;
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index 154d2aefe6505f..386d65a3943af7 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -1182,6 +1182,8 @@ struct efi_image_info {
 #ifdef CONFIG_ARM64_DRTM
 	s32	__drtm_measured_start_offset;
 	s32	__drtm_measured_end_offset;
+	s32	drtm_entry_offset;
+	s32	drtm_handoff_offset;
 #endif
 };
 
@@ -1241,6 +1243,18 @@ efistub_drtm_measured_size(const struct efi_image_info *image_info)
 	return image_info->__drtm_measured_end_offset -
 	       image_info->__drtm_measured_start_offset;
 }
+
+static inline unsigned long
+efistub_drtm_entry_offset(const struct efi_image_info *image_info)
+{
+	return image_info->drtm_entry_offset - image_info->_text_offset;
+}
+
+static inline void *
+efistub_drtm_handoff(const struct efi_image_info *image_info)
+{
+	return offset_to_ptr(&image_info->drtm_handoff_offset);
+}
 #endif
 
 efi_status_t efi_boot_kernel(void *handle, efi_loaded_image_t *image,
diff --git a/drivers/firmware/efi/libstub/image_info.S b/drivers/firmware/efi/libstub/image_info.S
index 065bbfdf8fabad..adf82ad083b354 100644
--- a/drivers/firmware/efi/libstub/image_info.S
+++ b/drivers/firmware/efi/libstub/image_info.S
@@ -21,4 +21,6 @@ __efistub_efistub_image_info:
 #ifdef CONFIG_EFI_STUB_DRTM
 	.long	__drtm_measured_start - 0b
 	.long	__drtm_measured_end - 0b
+	.long	drtm_entry - 0b
+	.long	drtm_handoff - .
 #endif
-- 
2.43.0

