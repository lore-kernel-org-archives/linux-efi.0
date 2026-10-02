Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011022.outbound.protection.outlook.com [40.107.208.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D3636606B;
	Fri,  2 Oct 2026 23:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790983942; cv=fail; b=XDsukdWdGvogEIz+ANtf3aQNYUSGC0bc9dLVYpW5XhTeO/AZw1dBad/pyBIc82iQzem1EJ5a8gEoUFls4GbCsL4tHK4MzZ/w3z97jIyEH0q9J5IKszmcuWwx4dCc08A9rqPLApsgnHfcH0udPyMuGpFTtDDVGuBsg70KjsssgIQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790983942; c=relaxed/simple;
	bh=1kAkyL/Cc5xGsXCWCiyjShgS1seHnj2zjVv76bg8C6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FtJvG+pXUJVEK+7sZGWQJB7G047RtnROaLrY7f7SQZ51AhOr1upT7A/nQGXze+MRaQItgeB3iMGWMXQ/4rWrJ33M0qPapYcki8tFdgkUtkBRC3rz2rnbKOk/wnGmhgiSso3bRRmoAe7OD6jXD6NFe5cWXQ6MkMAsiQpo9Vfwzr4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=D63ccrDl; arc=fail smtp.client-ip=40.107.208.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="D63ccrDl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JANWgWYZj1RgbuxkdO0sXqniJ7lufEzb2X28xjaCJ/h4de6fInibTJttWkZvw/905rg7l8Vskkq/Nbs6SS9iGAn61dUNpo+8uIBafSt43HHzEQLxecDy2uG3k9J4LcJ9YxGy5/VSFMyf35uJk9zAtEaYyqviBL/vhXDL1w2DTR5ih+UQUCIsRvrji6hi4cHq1Pw147fkr+wzImHB/w7l8DGNWzvjkqMTHqXrlZuZeOG+hvGQIACd9cRiBRaz17pkq8CN8TMTHZjYN7Ysys//sDGMCknwZCxCFAfAjBGEblrC4YcC7BbxRQOYPi83tL3EN1aR2xEsCs912fQEomw3Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ExBGJA4WQRHqCGMET97qrwsDxtRZ83mx1bcwfEPylwM=;
 b=DOBGUvICxvmKIuEae4SlWX6Z40HznyJMywnk882G1HHkHgx/9hiP4pL0AgGoGfLnb4LyIkm71VJCBRAJF8LhphEc53cEfGRrcN0VAeYjwEEoYJYukTEsdrpND4t1PysYr8R0T7XmvmrfZ+3lMV7coW2RmaieUG55gTewcOmUfgaM1pEgaXjmDLFoxravEDVRvHvO0dDkSsmK1kyhAGfTZ6nyt6c0LoT1EiUByPIChk4SdWAKW/gJFlYlpScHoWTAt3yYOU5NKJ7clIawugEuQENDFZvO2kH3+cEm5cmO/vUmSxz5vioeTLzGEu0GRWBVOheyIKNbGyXV2Bj8haenGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ExBGJA4WQRHqCGMET97qrwsDxtRZ83mx1bcwfEPylwM=;
 b=D63ccrDl0udzuy8t4Qj9jjpsoC3SXCGp/24ddSXvqxAWu6DnmhpaWQSW67S52WamvHlVy4yZY6iLAAN5GxakTIGK7CP5HRZoPtqXGoV6VGbAU12uv4K2hZN4fKDAHzTERKt+s9OFER7ihnxjEskBlyBMzCFn1Z1IXBY/J+DpNe8jh8hKJmI2rPOFs5YVT/hPL6v+QktIMzvRxjlsijnY1WjH+Xj1urJRIhnX/6OpAqma5r5/h1o+8A7qaNApVdaYCbzxrHO5wNiAYitaJtAGzo2lJIfBS6x/lAwB9Oaf6x8wYMv3pTdXhEjDh/HmMkmBeTCkWXgEXRhQacyjJhON2A==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14) by DM4PR12MB6303.namprd12.prod.outlook.com
 (2603:10b6:8:a3::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Fri, 2 Oct
 2026 23:32:09 +0000
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5]) by LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5%5]) with mapi id 15.21.0472.016; Fri, 2 Oct 2026
 23:32:09 +0000
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
Subject: [PATCH v2 05/15] arm64/efi: Use CONFIG_EFI_STUB_IMAGE_INFO for code_size
Date: Fri,  2 Oct 2026 20:31:42 -0300
Message-ID: <5-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
In-Reply-To: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0P220CA0009.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::13) To LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LY0PR12MB325698:EE_|DM4PR12MB6303:EE_
X-MS-Office365-Filtering-Correlation-Id: e5e1f2b7-bf48-4655-cbf5-08df20dd5a96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|1800799024|366016|376014|10067099003|3023799007|11063799006|56012099006|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	coeGjkS/qCfnGO2GDHLz6LTRydTCspbuy0AGJ9KxuHiFyKtQWamEC2YDfmcn3+lkCSSWmXNBnxO2StxiA+gUHpybjvO9meZPT3shHSa5ikWWd6qd+vAnLOOYU/gdpMF3oEgWp+yMf13GlZvDxXl0I7AfTmOWSujflE+i+Z4wtrjElRrwEC2Pv2W9qiN+bWQnRcLdL0jr9LrGggV5z0aPrIjWAhhJIRad+ajOeQsesfu6BhU4TtXsy59v2+xPTeagXGjUtSxOS5tObF/jB04E5cZ1IZNp7Z7vlRf4RpPFa25YJmRdTTOItOuvestN0aXn5k+SN94mpnJr55602pfRu7Q5t36PMfeoT81iIY5jpB2LDKTPzFytqKdedFQRhk7oA1zuLSDDbz9EWgcg+jY7887yFqJvtj/jYFYs9tKmk7+WEzn3afHU3TTeLgkwcK33G7CgaieySaBTCpdJsujOLpVSow+marZlbAhPpDVIOiu93wSChJG/w4kaWE+QyPTn0bzNcMP5Llo02VJHdWr0l+Uh9XzXJEW7sePAF3Z4z7qwPkpBWoH1h/uXtqLjTbwgqUNU4+/XBe6orD+U6CBdD+HVjhfdptXDUkBf0aFMWW/iWPUaAbo4O8WXDiNYCSsWk/KUQgEOhzDRqCteepx09NBDirrGNjyg3BT+SSTnTcLfMQYx7MIVB00uVcEmWS35eHqpBJELtfhxbsnV45Z3pg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LY0PR12MB325698.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(1800799024)(366016)(376014)(10067099003)(3023799007)(11063799006)(56012099006)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8/ry0u+Pu4+z+MCnspdEzzKpPHExwm+2KZYXQ4PwG6TVjDjkfJ3mC9q2tECh?=
 =?us-ascii?Q?/mLQZI0VXJ42TRk+OfCx29Zi/L2SDXVJ9IH1tX3gPLxncGpHEzwJqaNzJ5EG?=
 =?us-ascii?Q?GwTV0qZo56IkhXTJ2lp6fD8O0DUjoP75yP4I3fjhTGduXaioWaCet/gX26+r?=
 =?us-ascii?Q?eCG6Sc05QGhfwIIb2TEYwXqOQ8lY3qihLU4G6Mg1LCq3tPbGPrzRDyPZOoc6?=
 =?us-ascii?Q?GJAblcOKVtmP7kKEDgyMrhtSsx4RfbQRMKqqJCQsoF7cuNtDSPvCS+f4u+Fd?=
 =?us-ascii?Q?USciQN8njfFMMzps+SeYV1DPn5o7di1k6XR3pjc1kAOz/d8oVkOSYRr6lIlp?=
 =?us-ascii?Q?XTvjAKDTt8jFfIXzvDpvXOpF8X09KZWLfH10dET7fRXXOG5jF25nGfJAgyis?=
 =?us-ascii?Q?EHUU3TQHoHBEjjUSxXqeWu8ntvj6ugz+ZIkTj3MG2BXxgVeDD3Wq6gPx36OM?=
 =?us-ascii?Q?7T8CzZ3Iz78oLBzO/QhnHAiDXLyUNYE5H6BLfM8ASosf/O7i0u3Q3pRIHjto?=
 =?us-ascii?Q?GD2b7+3xmnxypX8UA4vSwP+gLSklusiGJIG4Ll8EUuPHkfsqJE/g2N+zDnKu?=
 =?us-ascii?Q?DYog0bBbuOs0F0N9ASfmmvfLvNLJ0WL5WnEOyPLVkhhk07/5Hq5XMecAWcDL?=
 =?us-ascii?Q?ohCqQeHjOJA8NxeKMXTUyP9QJgEyxnjKYkn9QCiL2iPE8ufrEwjyJJaCuTIf?=
 =?us-ascii?Q?JOAwznuwyvk+fB93snvoDs0fZpA16oz3a2T5/SQi4cZ25ksbNDG8zosD3CTj?=
 =?us-ascii?Q?uU88Cl3oWDTlMlpLnCphtN32Y/fr2S6XjPsgunUjKSktZRZx8JlNnXqr3re4?=
 =?us-ascii?Q?wr4WXcYvDWzYz1ouXLLSdABNlxj++JJHp79mKx64sJDkourqs5R5lYKBtg0y?=
 =?us-ascii?Q?7weM56qzrTKT7CRVkeeVmY9t6WmC+T1aHhnWgXIjI5Fx1+2vS3jOjhIfLc6I?=
 =?us-ascii?Q?wd0ooXgUQXCapX7dLfeE78mCUA0mUiwoyy4ADW59WXcnXRRH901WjYBVf9W5?=
 =?us-ascii?Q?LZPuggPat0ySnpEejQ2UJmDQzFbXQlzkP2/BPby4P570DfYa/K2JfPACQnHP?=
 =?us-ascii?Q?XnR0lM/NocNVtEnxC90Kmxe7wUN9MfIbjLw1q5Guj0X9tOcMjgZ/Iv8z1Iq3?=
 =?us-ascii?Q?W4lwRxcBbzR46U/U4x9kaLftrWnJCbPlq2xt5pf9SFYwtMqlJVU/z+FpeTwU?=
 =?us-ascii?Q?9GTCFleiiZnbFdSxM3u+8DCnxZmSgJmMIhhNdNmF1OmWclt4I3gx7xXsWftX?=
 =?us-ascii?Q?w0+Qkl5WEVD4vHG+qIWWp+S6F82brGp+CGbOnm8WzddLCupF5oM4NFhryFcJ?=
 =?us-ascii?Q?S2K13SzExWVdcuT+TY2k0YrB5/c0fq79aRsy6UmGC4dvCVCZnlyVJo1y4cmC?=
 =?us-ascii?Q?iFQbPHxbpuvLYfAIIGwROtGZqBTjVuMapGAOfT/t+k37FmMV6R6kA6WktUCh?=
 =?us-ascii?Q?AJvSRqgOobUeNbWmDgo9pE6/0hYg7eyLxjvdNo/lUJ9txEtNJHYxjjw6pWiH?=
 =?us-ascii?Q?jG1mifuK5NEeG3FFZwWEekC1mYzBNaGaMv5nSWiVeLspRmBAnQ4a9FA0gA39?=
 =?us-ascii?Q?WA5pvYAN5h0mciPkmrdk1d9eppu+6Ga6KRVy8CT6N5VcBcP6g4Ttqy/gfF+D?=
 =?us-ascii?Q?nDpzOeO1K9EvFtQDjEFJ4x/J0yyB41Hy9mxjt+kniT/Zu07Br+iE5vh9MXPM?=
 =?us-ascii?Q?63jG6++UI3HU1qNWIkTG5dP1PEIIg+0enzfdQwm1BnetwKbU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5e1f2b7-bf48-4655-cbf5-08df20dd5a96
X-MS-Exchange-CrossTenant-AuthSource: LY0PR12MB325698.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2026 23:31:59.2855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TjGjlqRKA8G4A2TatadaKuBAYUzKe9b4txSvUMsutGBTG+tPI0mhbaCH6EL5ms6c
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6303

Pass code_size to zboot through struct efi_image_info instead of the
custom objcopy trick and remove the objcopy way.

The linker still computes code_size, it just gets placed into the struct.

0-day found a randconfig where code_size would overflow a 32 bit number.
Move everything to 64 bit. I doubt that anyone ever uses such a large
vmlinux but u64 also fixes that silent corruption failure in the build.

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
 drivers/firmware/efi/libstub/zboot.lds      |  4 ----
 9 files changed, 26 insertions(+), 16 deletions(-)

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
index 9ba85173f85765..b18ce23a2cba7f 100644
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
+	u64 code_size;
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
index 42408132249ae7..fd4bfaaaaf0ab8 100644
--- a/drivers/firmware/efi/libstub/Makefile.zboot
+++ b/drivers/firmware/efi/libstub/Makefile.zboot
@@ -35,7 +35,7 @@ efi-zboot-objcopy-flags-$(CONFIG_EFI_STUB_IMAGE_INFO) = \
 		awk '$$3 == "_efi_image_info_offset_value" { print $$1 }')
 
 # avoid eager evaluation to prevent references to non-existent build artifacts
-OBJCOPYFLAGS_vmlinuz.o = -I binary -O $(EFI_ZBOOT_BFD_TARGET) $(EFI_ZBOOT_OBJCOPY_FLAGS) \
+OBJCOPYFLAGS_vmlinuz.o = -I binary -O $(EFI_ZBOOT_BFD_TARGET) \
 			  $(efi-zboot-objcopy-flags-y) \
 			  --rename-section .data=.gzdata,load,alloc,readonly,contents
 $(obj)/vmlinuz.o: $(obj)/vmlinuz FORCE
diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
index 2c38693561475c..1d10a166abf8d1 100644
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
+	kernel_codesize = info->code_size;
 	kernel_memsize = kernel_size + (_end - _edata);
 	*reserve_size = kernel_memsize;
 	*image_addr = (unsigned long)_text;
diff --git a/drivers/firmware/efi/libstub/arm64.c b/drivers/firmware/efi/libstub/arm64.c
index e57cd3de0a00f4..f6c250711de8cc 100644
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
+	unsigned long code_size = info->code_size;
 	u32 ctr = read_cpuid_effective_cachetype();
 	u64 lsize = 4 << cpuid_feature_extract_unsigned_field(ctr,
 						CTR_EL0_DminLine_SHIFT);
diff --git a/drivers/firmware/efi/libstub/zboot.lds b/drivers/firmware/efi/libstub/zboot.lds
index f389aaadbe44bd..8d32be32931494 100644
--- a/drivers/firmware/efi/libstub/zboot.lds
+++ b/drivers/firmware/efi/libstub/zboot.lds
@@ -2,7 +2,6 @@
 
 ENTRY(__efistub_efi_zboot_header);
 
-PROVIDE(zboot_code_size = ABSOLUTE(0));
 PROVIDE(efi_zboot_image_info_offset = ABSOLUTE(0));
 
 SECTIONS
@@ -22,9 +21,6 @@ SECTIONS
 		__efistub__gzdata_end = .;
 		*(.rodata* .init.rodata* .srodata*)
 
-		. = ALIGN(4);
-		__efistub_code_size = .;
-		LONG(zboot_code_size);
 		. = ALIGN(8);
 		__efistub_efi_image_info_offset = .;
 		QUAD(efi_zboot_image_info_offset);
-- 
2.43.0

