Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012019.outbound.protection.outlook.com [52.101.53.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95F937B01F;
	Thu, 24 Sep 2026 13:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790258026; cv=fail; b=G5A/SMV9HUPixN/dvRvPVu6H/rUJ4FWSCs5rBrWCBHi+8naL9Fkf8bkLhO0e+ng3o6JXmTqiybaezL9wfVC7STjZThL6+beAZBHo3yqmFVAgWSOUWHT1oW3PfEwi/4KYFeb9w8Pg6EfUgEFQPdIOMXneTmSfrwZdzfOac10H+68=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790258026; c=relaxed/simple;
	bh=3KfMnlyJDfi3ZUHL4ggBGJ+B447clshB3XX7oXphiXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TfMwLqoRQB5RTb2gSiKCzcHhiwTEMU7O4Hlp3UInkfjehyKJcl0RFu44x1NhMi4gPhI31g3Ndkp6qukUq45TXlSbatXIyhGjzmjPLTMBPTPMjksM2kfd9iDckKCLUKEKML4ec+NgjeE4zVte0NHBlRENDfeZu9bZRu4W+xn2490=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RmTnXoBh; arc=fail smtp.client-ip=52.101.53.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RmTnXoBh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SVggcphgHEIipdmWNT76tsZwAfdvwvMeJx0cGCNmP8wprDzISR8hESnTqWpTvTGwkB+aAMm3hdjL79omBe5G9XtgaiR3rkuUDuB4vyDiBY0p65ge21W2bWacTWkmImOJhGUmb2anflu5L3Csyxm7dRlBdEq6ofjOT26zQtyL2cQqdOkaZ4zCYMhXIFfmBlbojLJHOg862L6y6slVbfhIr8tzrIequpALP6j4ER3BhVZvBqhpK6RJYabytUnAOgeKvSYuIfFJcyVyE4zKKxO92fLxjjBxMchFpNMtvvk/xahOX8g/QAMZuePQJSADVdA63p23Md/A/6WS73x+wtbRoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H7K5V/q/fUz06iuOwo7oLdNJVoNwR+GZ5zXNVLVWbKE=;
 b=n+lsLg2DQS6U2LwnL86hSztHO1BCZQyPT6+vkpQGflkEfd7b115CWP1aP8ZDGr0ajI3VXHoHGa5nK5Pas8251MR0dj5VMVsXCjJVw8laMV8dRlafiByY9zvQ7DRhd4PNTSOthvEnZ5YTLlLfqX5Hc8Sx9w7mNlSiHlLwYog1vOg0QiaY+9b0kC5mEF1aSurT3vly35L6YUg8Xmpeg9ycX46LjmCl6CTUf5zLZbm4P+D3UZpUO4JzMOZvwsVtyWGt0P5u9+9B9KlnxjTNNn7aiOY8EJ7QCII/rkOFe4x2IkLE0pOmV4g7VQBQql8xY92JAmNCsJOzNXG7HvsRATGmgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H7K5V/q/fUz06iuOwo7oLdNJVoNwR+GZ5zXNVLVWbKE=;
 b=RmTnXoBh40Lyft8rLzzVOMLZWsx4E0vnXfHHxdxbxhR8v59lvc28sVcdXewzlnt4V1k7dZQ1cSnaPsWC9AvRtAc2JxvDx8UZUhQbkMyTyEqp+3dHqVceY6tFH+MswA56PeuKdJupmz9tKpuyL1+0EcpGauw+h20E6G8QkgDZgWfz9sZiHUy8KbteRPXlQHtgyhl3xv91yZ2gmY9QZUK9z/URaqb5WmlPmUMh5OMZeCnlPyh3+MKLH9I1JCH3Qh62jpNcV6XlxMLu/PgUf/LYUoTAVlWIH/sg2pv+PGYXwXqOU8HnD8EwoVw3c1imtNBfcLzNiqQTPDUed6Mr9LZHaA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by PH7PR12MB7186.namprd12.prod.outlook.com
 (2603:10b6:510:202::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 13:53:37 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 13:53:37 +0000
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
Subject: [PATCH 06/16] arm64/efi: Use CONFIG_EFI_STUB_IMAGE_INFO for code_size
Date: Thu, 24 Sep 2026 10:53:09 -0300
Message-ID: <6-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
In-Reply-To: <0-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P220CA0101.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:32d::17) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|PH7PR12MB7186:EE_
X-MS-Office365-Filtering-Correlation-Id: 055cc95f-b60e-4f32-a79a-08df1a4334d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|921020|10067099003|56012099006|11063799006|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	8yzoWn5mgObXcCjhu3mVPOav3pxyPZmMAOSr8Zm2h2uStzCrzTUZv9uZ6C3OWfK3Ur+hdR5D+hsXj1fCAtKOJdlRMVzqwhNq/kC1/N/hfB84o++wHx6ET/04j8rofb+DO+wC5wAd1e5MdgoX4UCTtyOmgjyJHi37TEKvKnxs73SWLPhY1RVvCE28yjE8FC2u+Lh6r3eX9rfEUQOrEn4BV4LJp+ilmtdjAvV48bok1zbFgUk9VtzoRs0oXNCOb4qO8WzGHqzILD1cCh5XkQ3KzTKg8BJ5Es1j5RxF1n58cvYhAanSQ5bWawuafUggvjNzJ2gjjlq0tpMGUBwpEasAg9FuHxayYYqjaHfHskxS9XfsEgc+DcX16nri6ZUpGr6dLBoSV94fqPc++vwoj55G67ZG52WiB8h7exJcD2Hbn5CStswWd/YtrEUtwDG4GXicwYo/xJZjqD5QN43st+0sKWXEPz5flDXRLWwBWNCJRtrWTd2RKx61WBp0SvGafg2yGAKLTrR79AxZzze0t7k3pJeH4P8s36MhyzQD6V2Z3aJa2m0O1EAhnx+VQsYPF+1UD6Al2pX/qpv9mzfjC72PJ7Xh7Z8r4TAPsRGPwQDjKUXZXyhP4YskpfBJAm3SMB5cH/GaWdHyHOi7W/FfGB/d1Qj9H6W1BPfcT2IDPuU4rTbKuvmokgYdRtlRvGKqOusZSTfzzb4or8GPHEs1GMR60g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(921020)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iKF6yxefO4v923hb3qndMuxL25COqzTpZkWujEDGt/mV1Kq1nlsvPCITcsoj?=
 =?us-ascii?Q?SKNvEVWvzi6aPzwBFp0gcAiyPBIvyARqAh6F7DVDm5ntpj+p2wTda1qVyhDX?=
 =?us-ascii?Q?CJyZLsibhSkChBev8iExPsO4+aQIQi+NiiZGkDvFWTk6vD8xDyuQtbRiP8Px?=
 =?us-ascii?Q?MMpFYLNgG8uonIXvo93qaU0ELM4AnCXPRDdGAreuROfzzK4POxlJGxhIwk6A?=
 =?us-ascii?Q?LTV2Vx+ORMrThj7CjdI5KD9BiaK7k5iyTx40VBVctvJp1GUzwFlBeZWmJftS?=
 =?us-ascii?Q?Fvv9ivVDRPJb+aDqBaCi7zFcxux5kQ1wiV3OSHFoeqq6sJW16Wv53e1yUtwr?=
 =?us-ascii?Q?/8ZM68+GsChgH6IxOd3bLzfOCz5q8U+4dO+zYgYs4nIrJ9HFpCV6xY73j1kC?=
 =?us-ascii?Q?ijopEtVTFeUWIDdd3Xt0QmfnIUGWS8BKS5Fq5WqSY0iWPl7vcW7saxrbFT2T?=
 =?us-ascii?Q?fdNUih5i0bcVKfnpjY+jFyLL/cq51goeJZNSkfSNYPAdlVnzZD+jyQBfI2Up?=
 =?us-ascii?Q?ObgTPbqeb04XaWpdlzJbleFhW7I9iR9lQ0hZAvIRtd3PFCOx3+6qIAMjsWHZ?=
 =?us-ascii?Q?w53hjGnYOCAT6GB7J7g6VapfCpKPZmVPkIdrncw6Qw6xrUngqkzfTkO5ypaR?=
 =?us-ascii?Q?4r5fcuyl9ZISY4SLI3j6X/X5eMbJLMl3rHuODkCQ2RXuVToFRlP9cK2CCKv2?=
 =?us-ascii?Q?9obwTHhfgHrp1WgvdjSmkBilCd0aRaaCF/yb1vg9/D7w9rnE0LBl494uwVrO?=
 =?us-ascii?Q?NZXG/LP4FzzbnH6ZFbo/itoHh8muTy8sbtBsxYsaBg0ls91nZbKEFA1n9SNf?=
 =?us-ascii?Q?ARJW7pB1SBh5ATSDYHQJ3EyBOfXgdKUoQIYQiAYy+fH2lrtA/3aLLzhaacFZ?=
 =?us-ascii?Q?mt9jrhrkjv4YypaNCxQTdFM/0HmkzuTq4IpfiE7zcvcPBwTPYzjI6ZxNg+Lm?=
 =?us-ascii?Q?p7z4/e/hOTuJ4iybab84A6Yg/B8T8Qk+QevtMx0//DXk3oNREitbmJH+tJRu?=
 =?us-ascii?Q?5Szgb63Eg0e+qqWmLY6XwxygbtR407GsvPd1qdccTT+IZ7LdZaFRbaq6iNFq?=
 =?us-ascii?Q?gqazOq1aTCFUohbDsDb+jgpAHHU2juXe7Ub1PCXYHWHA7vjDvw1G/qUmyJO3?=
 =?us-ascii?Q?3u+51Cwm/hPIczeFpIRdOmW/9eaa7pAWhEU8G3hrWcyGVm+qbw5ZsMn0mkik?=
 =?us-ascii?Q?4di4JaxThNh8qvmQqzC2o75hEA0MZKyOt7RR8k5IGbLCVJzfVov6v5c84VH6?=
 =?us-ascii?Q?5NBMJKj9ZPoEGm9Z7ide46FHR+H5IBOqbtowkrhlQqVUoKlzJ0JrSCAGOhlu?=
 =?us-ascii?Q?xwNjLUd15q12pZCIm4ZfDD4lH9hUTG7OUzJ2RvZm0bT5ZC4L4jR03f5wh/i7?=
 =?us-ascii?Q?csq45zImcoF291d5U89uqYYFf2Qmejjf7nba/JKOiZ4mpMnr+pk5CilUzxt6?=
 =?us-ascii?Q?AXGqAlgqhNa65qc5MVPVqUoCCIK7th1xxUaBX3U0+jfciOi/zPqzI56k8ySc?=
 =?us-ascii?Q?5Zkk8fJZL0KyG1yzacMOJ3t09vYCzZDSSyS5FeZiKsayRw9iJi0t2/fDr4Sx?=
 =?us-ascii?Q?Po0mcPpWEroqwbclG3grIFhRLF/3RkfGimdDpux+5cRq+CSV0nX+TiDEYLhH?=
 =?us-ascii?Q?Hw8umWdKdArIqxNhGbcEONW1nlwKcuKwjumbxLuxALptSWH16aX5tazyU27p?=
 =?us-ascii?Q?4imU5mBgnSmlIYWuSjlBXZl2tBNz0nX/IOwdZMXgXQWcGrmj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 055cc95f-b60e-4f32-a79a-08df1a4334d3
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 13:53:26.3596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: row396Yztt5BFAOIB4sWTdIR5ccatC32T6B5YwmpC2Q6lPdZpbQaxRlSgmnc98dB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7186

Pass code_size to zboot through struct efi_image_info instead of the
custom objcopy trick and remove the objcopy way.

The linker still computes code_size, it just gets placed into the struct.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 arch/arm64/Kconfig                          |  1 +
 arch/arm64/boot/Makefile                    |  3 ---
 arch/arm64/include/asm/image.h              | 11 +++++++++++
 arch/arm64/kernel/image-vars.h              |  8 +++-----
 arch/arm64/kernel/vmlinux.lds.S             |  4 ++++
 drivers/firmware/efi/libstub/Makefile.zboot |  2 +-
 drivers/firmware/efi/libstub/arm64-stub.c   |  5 ++++-
 drivers/firmware/efi/libstub/arm64.c        |  4 ++--
 drivers/firmware/efi/libstub/zboot.lds      |  3 ---
 9 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b5a51b0ef9440a..4a752835ce1116 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2532,6 +2532,7 @@ config EFI
 	select EFI_PARAMS_FROM_FDT
 	select EFI_RUNTIME_WRAPPERS
 	select EFI_STUB
+	select EFI_STUB_IMAGE_INFO
 	select EFI_GENERIC_STUB
 	imply IMA_SECURE_AND_OR_TRUSTED_BOOT
 	default y
diff --git a/arch/arm64/boot/Makefile b/arch/arm64/boot/Makefile
index b5a08333bc57b5..cfbad0c210fa04 100644
--- a/arch/arm64/boot/Makefile
+++ b/arch/arm64/boot/Makefile
@@ -51,7 +51,4 @@ EFI_ZBOOT_BFD_TARGET	:= elf64-littleaarch64
 EFI_ZBOOT_MACH_TYPE	:= ARM64
 EFI_ZBOOT_FORWARD_CFI	:= $(CONFIG_ARM64_BTI_KERNEL)
 
-EFI_ZBOOT_OBJCOPY_FLAGS	= --add-symbol zboot_code_size=0x$$( \
-				$(NM) vmlinux|grep _kernel_codesize|cut -d' ' -f1)
-
 include $(srctree)/drivers/firmware/efi/libstub/Makefile.zboot
diff --git a/arch/arm64/include/asm/image.h b/arch/arm64/include/asm/image.h
index 9ba85173f85765..4a220c71f76c6a 100644
--- a/arch/arm64/include/asm/image.h
+++ b/arch/arm64/include/asm/image.h
@@ -5,6 +5,8 @@
 
 #define ARM64_IMAGE_MAGIC	"ARM\x64"
 
+#define EFI_IMAGE_INFO_SIZE	8
+
 #define ARM64_IMAGE_FLAG_BE_SHIFT		0
 #define ARM64_IMAGE_FLAG_PAGE_SIZE_SHIFT	(ARM64_IMAGE_FLAG_BE_SHIFT + 1)
 #define ARM64_IMAGE_FLAG_PHYS_BASE_SHIFT \
@@ -54,6 +56,15 @@ struct arm64_image_header {
 	__le32 res5;
 };
 
+/*
+ * This struct is filled in by the linker, see EFI_IMAGE_INFO.
+ * Any change requires updating arch/arm64/kernel/vmlinux.lds.S
+ */
+struct efi_image_info {
+	__le64 code_size;
+};
+static_assert(sizeof(struct efi_image_info) == EFI_IMAGE_INFO_SIZE);
+
 #endif /* __ASSEMBLER__ */
 
 #endif /* __ASM_IMAGE_H */
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 14beb7b9d304c1..13c0b77627d82e 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -35,8 +35,10 @@ PROVIDE(__efistub_caches_clean_inval_pou = __pi_caches_clean_inval_pou);
 
 PROVIDE(__efistub__text			= _text);
 PROVIDE(__efistub__end			= _end);
-PROVIDE(__efistub___inittext_end       	= __inittext_end);
 PROVIDE(__efistub__edata		= _edata);
+#ifdef CONFIG_EFI_STUB_IMAGE_INFO
+PROVIDE(__efistub_efi_image_info_offset = __efi_image_info_offset);
+#endif
 #if defined(CONFIG_EFI_EARLYCON) || defined(CONFIG_SYSFB)
 PROVIDE(__efistub_sysfb_primary_display	= sysfb_primary_display);
 #endif
@@ -150,10 +152,6 @@ KVM_NVHE_ALIAS(kvm_protected_mode_initialized);
 
 #endif /* CONFIG_KVM */
 
-#ifdef CONFIG_EFI_ZBOOT
-_kernel_codesize = ABSOLUTE(__inittext_end - _text);
-#endif
-
 /*
  * LLD will occasionally error out with a '__init_end does not converge' error
  * if INIT_IDMAP_DIR_SIZE is defined in terms of _end, as this results in a
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index af1d720209764f..8305b47995954b 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -282,6 +282,10 @@ SECTIONS
 		CON_INITCALL
 		INIT_RAM_FS
 		*(.init.altinstructions .init.bss)	/* from the EFI stub */
+		EFI_IMAGE_INFO(
+			/* code_size */
+			EFI_IMAGE_INFO_OFFSET(__inittext_end);
+		)
 	}
 	.exit.data : {
 		EXIT_DATA
diff --git a/drivers/firmware/efi/libstub/Makefile.zboot b/drivers/firmware/efi/libstub/Makefile.zboot
index 6eebac66b73b18..de89d3d84465b5 100644
--- a/drivers/firmware/efi/libstub/Makefile.zboot
+++ b/drivers/firmware/efi/libstub/Makefile.zboot
@@ -35,7 +35,7 @@ efi-zboot-objcopy-flags-$(CONFIG_EFI_STUB_IMAGE_INFO) = \
 		awk '$$3 == "_efi_image_info_offset" { print $$1 }')
 
 # avoid eager evaluation to prevent references to non-existent build artifacts
-OBJCOPYFLAGS_vmlinuz.o = -I binary -O $(EFI_ZBOOT_BFD_TARGET) $(EFI_ZBOOT_OBJCOPY_FLAGS) \
+OBJCOPYFLAGS_vmlinuz.o = -I binary -O $(EFI_ZBOOT_BFD_TARGET) \
 			  $(efi-zboot-objcopy-flags-y) \
 			  --rename-section .data=.gzdata,load,alloc,readonly,contents
 $(obj)/vmlinuz.o: $(obj)/vmlinuz FORCE
diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
index 2c38693561475c..1d3fc8ac13efa7 100644
--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -9,6 +9,7 @@
 
 #include <linux/efi.h>
 #include <asm/efi.h>
+#include <asm/image.h>
 #include <asm/memory.h>
 #include <asm/sections.h>
 
@@ -21,6 +22,7 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 				 efi_loaded_image_t *image,
 				 efi_handle_t image_handle)
 {
+	const struct efi_image_info *info;
 	unsigned long kernel_size, kernel_codesize, kernel_memsize;
 
 	if (image->image_base != _text) {
@@ -33,7 +35,8 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 			SEGMENT_ALIGN >> 10);
 
 	kernel_size = _edata - _text;
-	kernel_codesize = __inittext_end - _text;
+	info = efi_get_image_info((unsigned long)_text);
+	kernel_codesize = le64_to_cpu(info->code_size);
 	kernel_memsize = kernel_size + (_end - _edata);
 	*reserve_size = kernel_memsize;
 	*image_addr = (unsigned long)_text;
diff --git a/drivers/firmware/efi/libstub/arm64.c b/drivers/firmware/efi/libstub/arm64.c
index e57cd3de0a00f4..67d66fdea77122 100644
--- a/drivers/firmware/efi/libstub/arm64.c
+++ b/drivers/firmware/efi/libstub/arm64.c
@@ -88,11 +88,11 @@ efi_status_t check_platform_features(void)
 #define DCTYPE	"cvau"
 #endif
 
-u32 __weak code_size;
-
 void efi_cache_sync_image(unsigned long image_base,
 			  unsigned long alloc_size)
 {
+	const struct efi_image_info *info = efi_get_image_info(image_base);
+	unsigned long code_size = le64_to_cpu(info->code_size);
 	u32 ctr = read_cpuid_effective_cachetype();
 	u64 lsize = 4 << cpuid_feature_extract_unsigned_field(ctr,
 						CTR_EL0_DminLine_SHIFT);
diff --git a/drivers/firmware/efi/libstub/zboot.lds b/drivers/firmware/efi/libstub/zboot.lds
index cc55aa8fb0630f..c7c2f4dd144301 100644
--- a/drivers/firmware/efi/libstub/zboot.lds
+++ b/drivers/firmware/efi/libstub/zboot.lds
@@ -2,7 +2,6 @@
 
 ENTRY(__efistub_efi_zboot_header);
 
-PROVIDE(zboot_code_size = ABSOLUTE(0));
 PROVIDE(efi_zboot_image_info_offset = ABSOLUTE(0));
 
 SECTIONS
@@ -23,8 +22,6 @@ SECTIONS
 		*(.rodata* .init.rodata* .srodata*)
 
 		. = ALIGN(4);
-		__efistub_code_size = .;
-		LONG(zboot_code_size);
 		__efistub_efi_image_info_offset = .;
 		LONG(efi_zboot_image_info_offset);
 
-- 
2.43.0

