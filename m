Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010039.outbound.protection.outlook.com [40.93.198.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFE0368D77;
	Thu, 24 Sep 2026 13:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790258013; cv=fail; b=S7+tlYvI+l3jrF9ucfEvZFlBGYC+6Ugagi27f3P8nunl9NV7v7LiRd+IHxtJvmiaAvdtzuZii1D6oFbBDm2F7EE0zLA0HrL2L7JE6fsp2gXLzG5QECk0/LaUypZkKgjuCuiFCKb9gp1bEpvtzsBUZVB9h3PJ/tOTfZigMN0PF5I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790258013; c=relaxed/simple;
	bh=JTSUsptm373fm+I/1DXCFnczhX2ZRfhvCZyeA9mmViU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=D5YneZLMcW8UWMpK/KfFaLFag2AntrZYn7WLgUZ6ekerb8HKvKZPQdDhn4ByRZxepsIwXloQOBduhGG6sKF2A1G9EeLGND2UUOQGmjfG3pr2tDqiRA9djl1bwCm+jyTW0N3maoEnbQ1Phqm7cR4+yrTrfh5aYXjVpVAaC9pdsG0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LTqKM7iZ; arc=fail smtp.client-ip=40.93.198.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LTqKM7iZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zsj/Tl20JqrHxOeJCeybN8cBz3S6pkfe279eOsu8+OiOU8qpUFRWCB6VgzLlguU26ndKvfyqS2+jojnBaDVohenda7S1AucBd9qaAEhVC/xnTPdI63UNm+UOYy9Nsq478cMWFrmBBPfmf7FYsIsP2TysoDqL5X3nC5JmaLxU1h8HR22KbeTJbZUyjw+MBhVtchuHjAODVB4FD3r4/PrX3wiElsOFYv+KaCioax3pbuFKQW1EwlhuFiAFIe8WHZzkZjFxEwE22G71AV+BDJAFyRqThrcA53v57GiprgErGtujupTwAox/HdN6FFc/rnFVfd+Deo/Ux+GuzPNqY5ZiTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CGcQ4E1S6THl3CYYeo8ODd1RXxDnNzE8f7Zikaal3yk=;
 b=C0eyTxCBJEAu1xU7xM5xVtl0kBW2yAqq08PAtQYOe56xhq64CIZKqzCQoiqsVQsmY9vQ8WTuS/qLFflBmGiUAY77o62wlOKyLB9CohPycbGXRAdMpdwTbTAc8lYVdkk4ynINFR2NpdjR7EP84YJY46zyxKYsgU/9fKJCtUZuPYmj5Uz+RRj/T288K17CCnzyiXfLc0MsJw809IwCQfVgyoo2KW14axyNGAgebLzoNR4AM2Hmfyn1C1/mUMCjL1s8CcGRWT4ma5sDxdezb4wScbKMfAro3Iii6KmFf0eAhOS1bou1+8JfzsM5+ajnGa8uiDeMyPumlPmK7MB0Cgog4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CGcQ4E1S6THl3CYYeo8ODd1RXxDnNzE8f7Zikaal3yk=;
 b=LTqKM7iZzhzHK0uh1PIHzbpvKc3qnUkbxu896PcwjD2QqRf75T1dGl/phQkrjOSLvFJx+apcNv+Ztjfm38I2VcU8s7QsYvlGhl9asWQoe8fVh5PNdFs+kVKe3hbwdkxLBjkjo+qtHoP9xQya2vu8yn+Txsd9AdCxoF3YwHqKECZaZ6nJK6rao/Pp7lWMMz0NzksAahl+HuNr5QdlTKRXc5rSyj8BUduqvm9FaeUS7zfOJKk3Zd06xnPWPUT3ksQUsuHeTdv+ZFAWFoli9Dc8thWAsBsXrFCkVdE1/ersHfjPSU1UfxJ8S+mfRB7nr+uYR2HYchJe4U4RzHLmC5K9dQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by PH8PR12MB7375.namprd12.prod.outlook.com
 (2603:10b6:510:215::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 13:53:22 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 13:53:22 +0000
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
Subject: [PATCH 09/16] efi/libstub: Have efi_kaslr_relocate_kernel() handle extra_size
Date: Thu, 24 Sep 2026 10:53:12 -0300
Message-ID: <9-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
In-Reply-To: <0-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0068.namprd07.prod.outlook.com
 (2603:10b6:510:f::13) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|PH8PR12MB7375:EE_
X-MS-Office365-Filtering-Correlation-Id: b4c48286-b7b8-4a32-c0bb-08df1a43321b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|921020|11063799006|5023799004|56012099006|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	nkVl2F7Rqwpwv2W2jezAyGUqcbCxnO+Y7xF07QodHAbHDgAqUr/8LDUlCgOk7SHrD2anCMFt27H5m4GQuF2kQ1FHzrtOOpg7xT1tJ96eKHKpSK1I3o9R2tz7C6WCdDne1EkgSheQFzpn4ILJn92smRcGJiYTRIt0aFkoAC0ZAdiL54r5rvNZVFqJOSfatCMJz/GG27rfOr3F4qvKf4aSoMdZjT6EPbkl7vr+Ionr2uTa6lZ4YNqPhSlgxjChb7XV0mD94kuQinwK73Yle7pM3e7+EZqqlunTgv6ZaribwKCA4/NKSIQz97sYeEJ491/TmQjgf9HPC7vm5Ot5dPb7Xv8oPz4L2y6IpJezcPLr8IZsncS+x71EyiYlIutonPE6FqVtIkZaX/QU9S0Bd+8wE0a2s/uZQlnEKYW0gGJyLVSjNEgRdkCmK7NcI0niLu//SDx9uBZ118N9L/mb7m8xHoDXWQO9d5Y/cdK13iSB20K837P4tT5RaWEpQshbFe6pAXkI/GYS34PmyI/bnw6UOkQOva5dfB9KYroON7B4U8QmTD5kV6yqXhlmIarJfWAiHFUCzyICIo+YG/mIWVPFSw3Js9k/XLhO+q+4ZOid+1I1GnauRh1tpk1HFBbK3oa9V/J1Pt1vXvKLmRMJR6Ys6zTsyqhvoWreTGw7wAuQ/fZE7YeqEdxrwmAkB50Rxnh1vCz9VSQ3Z/Z6aLim8FHBmA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(921020)(11063799006)(5023799004)(56012099006)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GVk3ndSV9P6KQctFA03Eogpw5ZVFqyO40w6CGvs9uzO2At/b7D7waAIEwYcG?=
 =?us-ascii?Q?uP60pwRspvlJBMRLoOVQNTqz7sjOpZiq3gXyU8l6k/k2QB9+iDXtJtYlXnbc?=
 =?us-ascii?Q?BI5ZplGPXjAPKrPIjBmimSsYg0vkRiexzW/x9FI0WIuCiay+350VhU0LSpBC?=
 =?us-ascii?Q?Ewnd0VnlIvkyzjwnLcOAQt7p1GR6gaj7e+OGpKjKH6kk5bDud4pOzx4UQXD3?=
 =?us-ascii?Q?SvhJbloc7Rnjf4JfZPe8wStxRO3pS3abRChmxZy6oY+OsboqnKMDeX9HV5nD?=
 =?us-ascii?Q?AHi6Yotd52VrGKruSLf32eWxaUxvOZCmYQ/l6LDqDLVKne80G9pxWFRN32fg?=
 =?us-ascii?Q?WtMrZAvJ0A4E990509Do8V7sBx7TmTT+GvYUMO0H4wyYJyY4FrYFCAvD+/Y4?=
 =?us-ascii?Q?/yIFqFbsNVbhmODhbPukCXZrB8SynzdmvrI7yuP4EuTz0nTk0swRAtTuyhC6?=
 =?us-ascii?Q?sTPAb05i3becBgxXsvrjgsy0RedSbvE0jJZcBE85u8bgEPPfrks8rhEL0+eV?=
 =?us-ascii?Q?AtLGUhkNzL+Qau9bnbgyFeElQNJErHvuVWTC7kn84ajllBohHjcHHG5Oq/J3?=
 =?us-ascii?Q?1H5Um8l4lJ4IIchy1BEV7FsdSUm9nCqmOr6Grfuth1OXvPmL9OZG3LNqi+Hq?=
 =?us-ascii?Q?VxVfIY4fuUgU035k/s5rjDjsBOLJxmCc1X5blKrGiP7ci73b4Adps1Z6TdeF?=
 =?us-ascii?Q?UizjVXScI8Vd1pOVuVrPbg69xxRF/uyCujAEsCK6EmH9E5rYY6xemTO7TJOt?=
 =?us-ascii?Q?aAnPJOqG6Nt63mT2S7Sld95GJMtXCkeKrJ/+p/Ml2KkoRbPp+XSUZ3SBOAMl?=
 =?us-ascii?Q?Dq2PLazvEObV9GYW8+D5k7aQVEzYIEFlEp+3XHl+sZpPJiIZyQNgufTpFR+3?=
 =?us-ascii?Q?Vs4DPBSkgHlIwOW5HOH94mA9PzlwvMGGcsgoqr35o3JhVCSCBir8f+0gco59?=
 =?us-ascii?Q?3SIU9TEqeuhYUigZd3CqmwA16gvHT0zjEFKF5hG2bT8nkukvOo/3+Nc8RsXI?=
 =?us-ascii?Q?BeEZgQnAyAWUfxnDWTdCkltJsGJwQX5C9m5gh0aWgKuCtZLFZd+MeasvfWc6?=
 =?us-ascii?Q?7zYIuITzW/0ICAtcI6UY0vWtfA6HQGCf/yqMhB/e9RLFJmsWlsfalBQIXxUP?=
 =?us-ascii?Q?K+ZrbU4K/Q6HSMRcPufuMewzfRRSaycdg10ufM0QzJltNHfrE/OQToFksA+o?=
 =?us-ascii?Q?0Xa2HxWEnWZ1mJ8+zSjqlt3dvNq02IwMng5aMWpOAestYXZDMyJsFawThcw9?=
 =?us-ascii?Q?s3rDICfZaJVdEiqxkgADQXvQAO4tHgFJsdZXOwLwsLB/z1eCXlODkS4A7fog?=
 =?us-ascii?Q?QfeUMA9fPbjl5MO9yqzbc3p7YCaazhqmuixD0nLRBjuVf7urf1boVNOa5pO7?=
 =?us-ascii?Q?k0xKospg9DsysR1A950RNthFjX6YZCP2yMBO5y5GZhPE8xvRYiBirSbfxSK3?=
 =?us-ascii?Q?fu2E0CmIQjGWV5adqWgMj06KZ/lJ0VG2WWySsbrkj2YVwBS7TvKb8QeUUJW6?=
 =?us-ascii?Q?iQgWUCswMxmGPGPoO1+Ip2KB5k8/ZCJvXduVs9pZrxoX2UfIi8gfHNwR7Y0n?=
 =?us-ascii?Q?vgEStSXX3Fb2vxba9fx31pnMLxe1LP5finGolFRhiqiLy6DNyXwmyfL7j6uu?=
 =?us-ascii?Q?BD2e5czJIckZvF9Ypd78g6KQu1BdqmhsUkkHV93bBvtAK9whOAuD5x68dXvN?=
 =?us-ascii?Q?NR/EO/Z8b+QdyniMy1gykEyGxvhKYQ60g6JPGQOLxPUqAZ/h?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4c48286-b7b8-4a32-c0bb-08df1a43321b
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 13:53:21.6693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qd8Dx1fxR4ClaIJUOiMTHvGWklQk6dYKUOckKLMhfwj2si5MKnbPi3mrnxPURAee
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7375

There are three possibilities here, each a little different:
- relocating for kaslr, just request extra_size like the zboot flow does
  when allocating from EFI
- in place, attempt to allocate from EFI precisely after Image to
  confirm nothing weird is there, failing that
- like any other error with the in place EFI location allocate
  non-randomly with extra_size included

Remove the callers' assignments of reserve_size since
efi_kaslr_relocate_kernel() now does it.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/firmware/efi/libstub/arm64-stub.c |  1 -
 drivers/firmware/efi/libstub/kaslr.c      | 72 +++++++++++++++++++----
 drivers/firmware/efi/libstub/riscv-stub.c |  1 -
 3 files changed, 62 insertions(+), 12 deletions(-)

diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
index 1d3fc8ac13efa7..1aa169464e529e 100644
--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -38,7 +38,6 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 	info = efi_get_image_info((unsigned long)_text);
 	kernel_codesize = le64_to_cpu(info->code_size);
 	kernel_memsize = kernel_size + (_end - _edata);
-	*reserve_size = kernel_memsize;
 	*image_addr = (unsigned long)_text;
 
 	return efi_kaslr_relocate_kernel(image_addr, reserve_addr, reserve_size,
diff --git a/drivers/firmware/efi/libstub/kaslr.c b/drivers/firmware/efi/libstub/kaslr.c
index 4bc963e999eb97..e419f3800af517 100644
--- a/drivers/firmware/efi/libstub/kaslr.c
+++ b/drivers/firmware/efi/libstub/kaslr.c
@@ -83,11 +83,47 @@ static bool check_image_region(u64 base, u64 size)
 	return ret;
 }
 
+/*
+ * The PE loader owns only kernel_memsize of the image.  Try to own the
+ * requested tail separately at the exact adjacent address instead of
+ * relocating the complete region.
+ */
+static efi_status_t allocate_image_tail(unsigned long image_addr,
+					unsigned long kernel_memsize,
+					unsigned long extra_size,
+					unsigned long *reserve_addr,
+					unsigned long *reserve_size)
+{
+	efi_physical_addr_t tail_addr;
+	efi_status_t status;
+
+	/*
+	 * Since we intend to use efi_free() for reserve_addr it should be
+	 * aligned to the higher alignment since efi_free() includes rounding.
+	 * For ARM64 the kernel image is already aligned up to EFI_ALLOC_ALIGN
+	 * by the linker.
+	 */
+	tail_addr = image_addr + kernel_memsize;
+	if (!IS_ALIGNED(tail_addr, EFI_ALLOC_ALIGN))
+		return EFI_OUT_OF_RESOURCES;
+
+	extra_size = round_up(extra_size, EFI_ALLOC_ALIGN);
+	status = efi_bs_call(allocate_pages, EFI_ALLOCATE_ADDRESS,
+			     EFI_LOADER_CODE, extra_size / EFI_PAGE_SIZE,
+			     &tail_addr);
+	if (status != EFI_SUCCESS)
+		return status;
+
+	*reserve_addr = tail_addr;
+	*reserve_size = extra_size;
+	return EFI_SUCCESS;
+}
+
 /**
  * efi_kaslr_relocate_kernel() - Relocate the kernel (random if KASLR enabled)
  * @image_addr: Pointer to the current kernel location
- * @reserve_addr:	Pointer to the relocated kernel location
- * @reserve_size:	Size of the relocated kernel
+ * @reserve_addr:	Pointer to any allocated memory
+ * @reserve_size:	Size that was allocated
  * @kernel_size:	Size of the text + data
  * @kernel_codesize:	Size of the text
  * @kernel_memsize:	Size of the text + data + bss
@@ -109,6 +145,9 @@ efi_status_t efi_kaslr_relocate_kernel(unsigned long *image_addr,
 {
 	efi_status_t status;
 	u64 min_kimg_align = efi_get_kimg_min_align();
+	unsigned long extra_size = efi_drtm_get_extra_size();
+
+	*reserve_size = kernel_memsize + extra_size;
 
 	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE) && phys_seed != 0) {
 		/*
@@ -125,16 +164,29 @@ efi_status_t efi_kaslr_relocate_kernel(unsigned long *image_addr,
 	}
 
 	if (status != EFI_SUCCESS) {
-		if (!check_image_region(*image_addr, kernel_memsize)) {
+		bool image_region_ok =
+			check_image_region(*image_addr, kernel_memsize);
+
+		if (!image_region_ok) {
 			efi_err("FIRMWARE BUG: Image BSS overlaps adjacent EFI memory region\n");
 		} else if (IS_ALIGNED(*image_addr, min_kimg_align) &&
-			   (unsigned long)_end < EFI_ALLOC_LIMIT) {
-			/*
-			 * Just execute from wherever we were loaded by the
-			 * UEFI PE/COFF loader if the placement is suitable.
-			 */
-			*reserve_size = 0;
-			return EFI_SUCCESS;
+			   (unsigned long)_end + extra_size < EFI_ALLOC_LIMIT) {
+			if (!extra_size) {
+				/*
+				 * Just execute from wherever we were loaded by
+				 * the UEFI PE/COFF loader if the placement is
+				 * suitable.
+				 */
+				*reserve_size = 0;
+				return EFI_SUCCESS;
+			}
+
+			status = allocate_image_tail(*image_addr,
+						     kernel_memsize, extra_size,
+						     reserve_addr,
+						     reserve_size);
+			if (status == EFI_SUCCESS)
+				return EFI_SUCCESS;
 		}
 
 		status = efi_allocate_pages_aligned(*reserve_size, reserve_addr,
diff --git a/drivers/firmware/efi/libstub/riscv-stub.c b/drivers/firmware/efi/libstub/riscv-stub.c
index 725b634c517919..a88b2d275e5bb0 100644
--- a/drivers/firmware/efi/libstub/riscv-stub.c
+++ b/drivers/firmware/efi/libstub/riscv-stub.c
@@ -37,7 +37,6 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 	kernel_codesize = __init_text_end - _start;
 	kernel_memsize = kernel_size + (_end - _edata);
 	*image_addr = (unsigned long)_start;
-	*reserve_size = kernel_memsize;
 
 	status = efi_kaslr_relocate_kernel(image_addr,
 					   reserve_addr, reserve_size,
-- 
2.43.0

