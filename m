Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012019.outbound.protection.outlook.com [52.101.53.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322F737DE8D;
	Thu, 24 Sep 2026 13:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790258030; cv=fail; b=eIVtxfz5g2c+BNOQaKyecBtk5j1N2I01ccnawT1n56Psl924tAYxFmi2wEzRWROZ8jNjtQXh5AN2paFUKKK85znuKJx8WBA8aV6q4MMPvi1UB99WDQCxhDX4WVQ7n1+Jmu7uPfIp30f5GoB8M7K+miEmJs9HjbiCeAxBAXD54n4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790258030; c=relaxed/simple;
	bh=n3rw65AQNnmcuGxxgwHV+3qDFXrfmMbkDnFp9F3UFxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=khfOUlcuwyWYE2icjAQ2lryKVhm6t9ycg0Ea/S5kBQXBNbmOhrVpSvu9PnF2SOM1VF5+Luer9/aeHyR4P2cTxSnzZS7rtA5BICh7kGZdBoJckSu8Z9UUOMzbTXaANpkeC+jT3+7va61HCJ+fnOXd7AdbrCHZWt5uiSjP8qIGBEc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Q8oRl8N/; arc=fail smtp.client-ip=52.101.53.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Q8oRl8N/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vVreV9XsuFTiBDlpCTTiVhnaNpu8kFIgH0luYR7QaBcADWR9Q8dDHfhna/458alu2RvAdwBMoHmJcDP7Dlv97LVe+PCQJsisDzSfViuUuyiLXwjkplPUjbnBNMygEeFSogIWHgWhDYFQtGxmJ/s5UH+tbOl2ddW3GdwFGFELgnK8ecRMbfKAMwbwxbI2zVEZW9tmU6hN5NW5BVmB2AOUa6EftvFnl7kpRgjfcrObO+jB8FzN1V4hKbSm2Z6IKHABwPmuvIPGl0+Q2h0NZdrMQ1UV6mRGdgxAx0RbOeHSiPJob/U+yIVAUONd3mWZ98HgWeA29r5/mNZrg8wXVgVA2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xIKqo8urN/WaCUEhDWLkEkLq1DB/HTQzdY3dhT2Pjaw=;
 b=VIwBroUxixIk8E0+mOqHn9RMNCop8t0tFNXt7D4NFOKVfII0LeyefiJqQU2CGx5F43lnVu0paGUkqScxmS2Ibcqu88263xpyUbLg23Lx8Y+nZhatCTHjkqgoNVnxMk2qyctrdhZiMDOfv4dtgCrI3o0FN3zwWPghLSQ1xuysJuepXEWVhi/vbYTtV7+vPDoSCMn/CzrntXovDeYY1VBIdOVVWQi6n09FXmA5M0H1q0gROXdZlkfhLqXNnx30VVby8664iiPxOhpe/ryspOybNtW8AIpMspb6/FU7IM5hKHlhVXhfyUGjIN8bGyHFCYaVmohUxQNyWhfdd+RsU94t/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xIKqo8urN/WaCUEhDWLkEkLq1DB/HTQzdY3dhT2Pjaw=;
 b=Q8oRl8N/SXaDyh5gMFfOJ0e1Ce5TMsTAOqqlMtYwm+irKBncy+WSS96QyQc1T0ujYTSW6/FU5bJS9q3b8hRBIqXprugEdG2XA289LE/uhf3lxx/YmQQGaSaYoSAaJtAdp6xLoA/JJ7dfEnN8gN639tBfBy2dcsSkZzJth+8q4/utzJCXIP2wQSR5VGKY9KmuVwMdzN2qDrn3KKQaefIfMwLRyOHYRgQXXYuhgZc3MXvqpJUHGaA4sKnKwnSloUzUNztiL+qI/MHbd1xzikaMZXFaUQG1RylCQDPVaHMEiVabT/HJLp1SotwyvaqIL6avIhiHg5I7+48KsR9pf84IUQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by PH7PR12MB7186.namprd12.prod.outlook.com
 (2603:10b6:510:202::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 13:53:36 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 13:53:36 +0000
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
Subject: [PATCH 08/16] efi/libstub: Add generic arch callbacks for DRTM
Date: Thu, 24 Sep 2026 10:53:11 -0300
Message-ID: <8-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
In-Reply-To: <0-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR17CA0049.namprd17.prod.outlook.com
 (2603:10b6:510:325::26) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|PH7PR12MB7186:EE_
X-MS-Office365-Filtering-Correlation-Id: d764b544-f387-4f76-65c8-08df1a43338b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|921020|10067099003|56012099006|11063799006|18002099003|22082099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	wwrZpr99108YH4t0EGTVmH4KTVmnmXFgGDX2vmOEcJ44bBCDTU0/hTMcNTyVMv6tAjJUrd0Pph+y00WQTyfw1FT9ipe1EiCmCpQ9RqLX6jxxpfO+KQh9W47+ijtIjh3LvFn0BvPa2GokLjY/in87McJqL3/otvJnV6gfUrel9HZ5mkYV1hcdMAI9M9SFvR15S95N4elTyMvMLIpKN6KF6rLczc37MLc77QiCOV5ejle0DxP60cBdfzTOKHx8FPy6+KcZtP2ZZC7liohN/mNhuOuyl2RVlcrmQFxv+ZaaL5oT7NwxSvz3LWLZtMKihd9hfR9QYaTC5Xnk0IGaIi3bAymcQhy5PQd7W1LSFOIiUqCTUKWS2vXUDa66t+eiifyXtbyaFOQL4UTP7pbC7t82DD+v73YleeAd0n8q6mNSJGwZ6rhjH7Y5l1V903l2f8qznX9op6Kdxgz3AL0Dv3VTGiMSNylyQHte8F+2zEPCzqQQMHZipjcW/HJSKn9ph4n5Ncx7ZBn18rRWipTo6TkdS1OirP8G6VEH0g/4d9tNwNQNnxsDbY3egvFXpXpOV0dbXIvnizL+Q5xTa8yuDlTMCMBcBHBmuFJOFwCXiksgYPX83WVsYM1rnhscpm4KpYNbzSlZ/E4K/heTQcNgEVwA3j+Bds62QvnNpn0LR0JyPX99OFi9wh9zXH+MRWgVs8d7ynaS/ARayIwzAZ5sL1QiOA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(921020)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uNf2xQhadXnBB+4lex9N2Q/HhmXnwSiasyooYXjLODQ9ClwyHM53L+mXle1+?=
 =?us-ascii?Q?Z2OXNshMUrSK54Eij/VxQEWPpBQ9GxPmCFMeRWngwcKS19cCMnJMcGpOhNFt?=
 =?us-ascii?Q?qlS4aN/bFfQNvPDZRKfanK1t8YAiOMjdjVmnkeHaDZA/tDPtr2fy/H1Qm/gj?=
 =?us-ascii?Q?ZMb/RvbyEimgMucy+E6x25sAsKjnTg8gtXOGx+1u8MhN12JbUm8Go5mjXpH2?=
 =?us-ascii?Q?5CHWbiP1jId+fOiJsydLturG1SQCT2XN8Uq5kyhNS1dPI/o1hCxtSb4ZVAP8?=
 =?us-ascii?Q?cNwsR/bxGxSOVSQSHxfc/B6bcyvghzQ6RoNZ8bs2wbjRyIMBVbJUVRclOI5x?=
 =?us-ascii?Q?qpUaB4gjxUrXx9hJGvi4RzkxeP+DhE8+JUXOrqeBkozXTJuS2ipsPlez5CBv?=
 =?us-ascii?Q?mxWmjLS6y69bCLCukgErSUL9LYW6bWPnvggfI/9veA+nbhkFiLtBCp68mLmT?=
 =?us-ascii?Q?MYP3gkvxnM383Tj7hEvP3S2m5TC1LsQIJ9BQN/Hrlz9Fhsud4A3hsPLq2e8e?=
 =?us-ascii?Q?EIyJ3nFDwnOxYpyW8+63QdJQhfE6pE2XaJfB3LBBjFdqd+DDrSTPeJnWmHHc?=
 =?us-ascii?Q?PInDzSBJwPgFw6/dYswgURYUgJKfxhpCaEm+yDOHp0UIrpTHXJwYTAJOohMN?=
 =?us-ascii?Q?ET/2mMxv1AMzVU4KP3G6yZAQFl/qSSDRrZj4Z4tqOsLxavgvVEJ/kjggh16V?=
 =?us-ascii?Q?7DnHUr+lIc+HWqcfpEm37QiOjE7d9J9t/Ar5pGFkOrWpBtLoA3+I+U54OmYj?=
 =?us-ascii?Q?eXcgo9tbS4ACOZq9ssttaL4lCNPSBKI5FJpOdJlbWzzpJh5JlzDmqxZ3ZkOD?=
 =?us-ascii?Q?Pbg/yTpudlYu+OJG5KGoZt0H1eO1WCsaknOp4MUBm6h+zDvYoZPo51ptlYWk?=
 =?us-ascii?Q?EqCQAwBTzX85I5eJ1sFa0q7pXmmEaoM57EhCID2PmonFjl5n3vpR7VOcCeLK?=
 =?us-ascii?Q?VKe8oN+Z+FmfxSEzvGTcupdVflIMxxg8DJubzlNik9NrxXlbUqcsi2Xnr8S/?=
 =?us-ascii?Q?2q+KMvXO7CiYZoEpTFMptyOWKcF9xWnwNZcygnLn7awqlMLgwe6w02ves0kv?=
 =?us-ascii?Q?TNEgko+4Il/rH6WtXMa7U/a8LGSl58X3PVnXcmvYeyVnlmay3GlJ6r+RmKqT?=
 =?us-ascii?Q?sEnzHaoUbiyZ3qG8urkNZrPzAQYSSwkkBrL/P6Q4MawGXQjM+KoRVKXAkD1O?=
 =?us-ascii?Q?nPPHGwTM88Zt+8m44uwk2H+c9fRZ5apR9RgOYFb4snmqATx7H8Sp74JnazX6?=
 =?us-ascii?Q?BUrwkqoHHN+0wJOnD2Gd5ZszCN1zWI3slJOtp/u+crN4DAyKiocyGMaeg6gA?=
 =?us-ascii?Q?AwmOm0xIly/P2gBHjr4Y3bevXxZR/ZFDnhKsaErW1hfKYr4svAc8zAn/RkaU?=
 =?us-ascii?Q?sQr5yIiCNGlkheiIsLqItwi1LQSlAaJA5pbMi5mJnlOl77qP2D9IKiEJPc1I?=
 =?us-ascii?Q?V6TqOsWmyGu855JMzYBVl1+LnueE6835iThN2Lj5shnFvPLkQPih0AgZXCX8?=
 =?us-ascii?Q?tE8Xul3YzoBbPN3RNZSwRV6vg0t7igHpXxlDPx+44HtWCioAC/TVsBht3Uyn?=
 =?us-ascii?Q?9sI1fM7ejWciivMe88iFiNWXHDVVRJAwBCQ5ieHXdMC1V9IHHGvaU+0lgU5o?=
 =?us-ascii?Q?DYPDbCZDJAdFJvbl5Y3++gBWhwuElCRfk5yrxtE55RPbfEEiqdoENgK18w+D?=
 =?us-ascii?Q?Gsz9mAKFn3MK58vKLxi8LDKa0qlu1RbLw/e8rklMQ31jaVz5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d764b544-f387-4f76-65c8-08df1a43338b
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 13:53:24.2162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RYO4CqQ8v054oVz75FaYavVVlu2XLC8Id752c+zxQThqMji+KYfvBI/A8OUBNHGO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7186

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
index 83fade2b0d3b84..5b356c4be78975 100644
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
index da01d6005a62af..f3a6aefdc052ca 100644
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
index 5b2dd709d7b151..15bb331f2dc56c 100644
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
index 960a542881d875..6ca231ad593b20 100644
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
 		status =
 			efi_stub_common(handle, image, image_base, cmdline_ptr);
-- 
2.43.0

