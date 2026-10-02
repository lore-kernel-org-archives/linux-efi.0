Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010028.outbound.protection.outlook.com [52.101.201.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016F43BB138;
	Fri,  2 Oct 2026 23:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790983940; cv=fail; b=GNPCgwZ7QRlGOzh80U5ePjzOhOmeJka9uA9sT2nEzRWzkm0Z347chzBGk6IsgiDN+lYP6h3cuhbpc4G1HmIGkiY2liubj8YCDX/J2eu1uXYdXwyDQjpCfdUUIuSn+RLA8RfFbZTJzkMbXNcGEA7o7CjSIq+5V6T4SvHXdGVX4UQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790983940; c=relaxed/simple;
	bh=u+EOL4x75GmYt8OR4gDumxSi5K0ZouRjLa2GI9NwwM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Pfw2vhXZZ/sk8lJhpQgnqlOAr81Iyd31VrMLf7D6uan2B2zY4YXDoVnn3ZyV/WsLbbkZuhsKPmfTEOjaWLac9NoWmwo5Iw6CkO0pw1oaMztAGvG07Bpr1hle4gE9Xs51gs5jc+eCvEG7LsbGuLyQu/19L/ojZCrWNQDf3aVZQPk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tehEWrKj; arc=fail smtp.client-ip=52.101.201.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tehEWrKj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tJ22g+naMivu5yNJy1xLl0WlfzM12I7zuSjpl9bu35r1bluxqikScG/TIF/iwr6pcK7dOaXSaU0JaWK5fQhrjPC0RAH4Re3jV0tHEenGX9uC+MNiXe59gtDo46Y/67LOgj9pfsGR9YCL+sevHuj7i1/M5DmVJRvDmUnsdxc473OsH5mAlgB33z6wm/dBTmkP2QHgAMVruvYAGa+7fv54g+9qTx552ewdRTsgPHEP0MRXnRYyUUevDrPGguMFV4j/0WE5svH9ZjjZsxGp83E9spmuVH9MjgMWgqB+WCnu/Y8tiBIAOI29NMns3ldJU+6hVa02gO7VZrca8fm1QnfDPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BVsutgCPH85wCxV7ncmI+hbvXVe8/MxUvAHPpqWVvHU=;
 b=tc+ioXw0DDqrSGXXATyTdmTvYF8JTnVTdJwA5bbIAHQrByH3kGbjLoxNpAFweovhsiHd2DTflN4C5/3Na1ePe2R5K2kRNMmuuhqIck8KqIT1ZaJJx6UnIL3Nrn5Rm18qbVJZtXVl9N5kHo4h966NvIg21qvjvH6KwX2zIj8vJmZ+fhvDfz0Wi0KRz0GgNoICPMR9A8zGk/SdgDtLgSy77kFMF89esxMDIDkJEv20k1YmL2AfcvxtL6cHedRUhMu5sV+34i3nj2Qwgdg3gTakiRXC+wfAQWgP6xEFc+ragNH0/4bzL1S1aFsIqvXeM6a5IHeemK+sc/kJ+2wlRoDWPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BVsutgCPH85wCxV7ncmI+hbvXVe8/MxUvAHPpqWVvHU=;
 b=tehEWrKjJsO2rKYhjbsWBf6pHGglMlrr3r9m5aSZZ8Nr6/0dNyQLwxWhHkOme1BjJwhlGQLvTRDd2aYBcCV+mN6tN+Kuz6Mm7C43LT905yQqxxsI4UNm0dXQLmHMl4KkiCCUWvorQ7UdxjuKXh12ehIUoSkXMcKkyouTFYB6Pszh2/Y2Os9UvcPyRVnpxIDNWHt8c78Cn6ckd+zMMJJ5hoaLM1/2nBBJP7Im2q0c/18bJu9ZHuvJJ/zMv+cXZcta4oFmBTRWGY+st+ZKRWanpjBgzJ9yHeWfdAOSaVPCLloy+vNbnJFSPiJOE200iqczD6/OXOcuBndb6qof9phINw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14) by PH7PR12MB5830.namprd12.prod.outlook.com
 (2603:10b6:510:1d5::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Fri, 2 Oct
 2026 23:32:08 +0000
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5]) by LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5%5]) with mapi id 15.21.0472.016; Fri, 2 Oct 2026
 23:32:08 +0000
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
Subject: [PATCH v2 04/15] efi/libstub: Add a general way to get symbols from the vmlinux into zboot
Date: Fri,  2 Oct 2026 20:31:41 -0300
Message-ID: <4-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
In-Reply-To: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR21CA0008.namprd21.prod.outlook.com
 (2603:10b6:510:2ce::29) To LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LY0PR12MB325698:EE_|PH7PR12MB5830:EE_
X-MS-Office365-Filtering-Correlation-Id: fe4a549d-8baf-4786-ae90-08df20dd5a62
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|1800799024|23010399003|376014|10067099003|11063799006|6133799003|921020|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	1NOC/QdHKYQIyywxJ6pD3ju8vTUCHWCoqTurXKaeixcXpTHhMYRQGfMplEvYg/ENgAYTr7LaCezbo99KL45p7XzN1JPeCW5uG/1aPrSvvzksu+hznSRzeXXYNST93mGESPx0LhQM4yPkzTPrvibeJfD6TJjgO2VcGtKXyGng/oNJHmpG3vUJYYCvXNm0jXCnWtPhXhcFBMgKwT28VR8idtyRjH5LmWi7c7OegsWjGmNyOjObjpq/Wp3un3GkSZi+yGhwBxZbpq53cKi9AuyJLJQ/kQEmuAIqPqK267y0rXhVkc+8cBTvIOFYwD6YnvPyzWRBfhTFuqy6UqvSP2VPR/thtoRLv9aofLvZC7GkxGfsYpWDqTqPVlE7LaZWm+3BUG5f4P+8fV4+RvvoKujjhFClDuG13KGeF3y9hy0F4J0jcnzcVZ2hdB012U4pVAdSdR5jbfagd36K5t6piEVpB6BgzjOf2+Xrx7bKpHON77uC8gwJ78mFfDSbh3chj24vyR+H5tciHhHTx77hogSv8gcE6dkyUnG/XA7zs58B11S3+zGVPOt9WHdb12HI0BNOzPTI2qWGtJyhZY6vpelmS8S0VihAIe61GzwzbmmOOVepNCYM4S7nXhkULoFt0pNjKh/VsFX8nm7G898+q8EBEbe5rtQ8bi7Mn7cy8eyGMo9NoKujnVsd4OBSoKO0oEbQf3WA4QK1JkRJvjjr80TCMg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LY0PR12MB325698.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(23010399003)(376014)(10067099003)(11063799006)(6133799003)(921020)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BTXzsZKbn6gS2aQu9Isr+gGuqYqK2htYfTbHXxlRR/gKiBWsmCSKPaRSqmzf?=
 =?us-ascii?Q?d7aJeK1M3ATMYvd4UyP4OxQMa10nwp0LovdOci3KAzvGmSQj5//GyNc6zYwA?=
 =?us-ascii?Q?nsTNr3LRlB79onnzY9sbPELlYO+SoGVKMxHXvWa07A1Buj1GvzyznGJhw+6a?=
 =?us-ascii?Q?ZIsyU4/mrBnfcLlZC5Dybmx42jiU4ERnzu821ofCGCP+Z6m/OME37s9reTL6?=
 =?us-ascii?Q?egfO37mzzwU5GG8gMcSpFFcUDwcWo1sgwGgb6/aIoIiWuVZNBBdR3QR6i7sM?=
 =?us-ascii?Q?o//DIJbkVo7/qRpPmppgcv0Zqmndz/hxdikzXuhCmhCuvc/PEHlVoDsN6Y39?=
 =?us-ascii?Q?vbNUCwBXlCWIJHmTE4OSXOBcO1euUNO+KHeypzJbqQcxr4NsgRH49JGkEXzU?=
 =?us-ascii?Q?vxxU+zYK54pGC3kby71Ei1RDoS+A2yvC+AQF8OnnSDqWwG5RG2mOeMa4C+01?=
 =?us-ascii?Q?QC90s1gGc/wPV6uk58REug1XvxV+YYtjGVv5CNOkyMBmKgVdp5ENwY2z7o0m?=
 =?us-ascii?Q?Z8ifZPiIWjDQWZtfUKMix89W0Eb5RoVK/7yl0M3KwC/c5pSQxMvxvJGLqViq?=
 =?us-ascii?Q?UYKzMxu6wNl0ChJUMTG277FW25AK2DvK7Tw+2CMZwZi/O7pfEDR3PjEPQ9l2?=
 =?us-ascii?Q?9lt0xVg1I5OKEhqeVFYKQHCPpyWFxRJFUQoypn/i8hp+xpuMBcHmGpvyxKTt?=
 =?us-ascii?Q?8WOIuTBLULK3EOj1NNkQyBzMExpk+fGMs0Tj1lSawTaP/KpTR5K99Capuo6Y?=
 =?us-ascii?Q?OxCp2BsW24v/E7X1u0uvWIgzbWftTxblRQiDT/FU1p6+VPrSzABURTOzIvMD?=
 =?us-ascii?Q?GcoxT/QlM48SnWt5/rG6Unuz0epW+s+dVHEiz3ZiQWGiw6Eav4tD6RvYMZVF?=
 =?us-ascii?Q?ahTYYENvLjm/rnBLahJEVmL+6cqtuA6iaGjvVNbyUfOqU2m9/3zBGEfZk71m?=
 =?us-ascii?Q?0NBxWT/4bsYYqZ2So+fReEPF6d01MhzILQ1Wt5+gnw1McYRppBF+mmqXNUJ8?=
 =?us-ascii?Q?EW/7yE4R5DKfBCVP3QeitDasa/9DtHa5thrL/fBrUQpsvEQ2h0gWyRAs9aCL?=
 =?us-ascii?Q?bVCdZAJzOmeykg9oT0D6C2OGxnvI6WYRg2usPG+mROlefSVqX5Wn01m1sD34?=
 =?us-ascii?Q?9Cj4pQXYLCXZfxxDbI15qMUg4ldgEGQ1go4TW3cd7/hynGgZdY7mOYe4qkKq?=
 =?us-ascii?Q?SE8EN1RLdu+yHWlUuV2KCSpOJj8XV9mmWj9DX4rrjZekEPGbhJ0/vHyljJD2?=
 =?us-ascii?Q?EEGGZbIO+w1Nn5gLR9XBW9GbemQdIXxxqEcjeDADNjpEWGnV70oQTTGD44C4?=
 =?us-ascii?Q?J9BdHQepc4E6bruXUrsIPTUIrEvTYLGogbWtOMRZ1v0+3KxPcounsgs7S5Lq?=
 =?us-ascii?Q?zgkfc0zHYPnS3FEHW+bSXiHdjw13d956JTPN9gOveGvT2BcyDUL0to40Kna/?=
 =?us-ascii?Q?Lav09DGjS9HgPC/mQibBNfO1fcDFvhEe3h1c3J5uvD0Hhe9PfMHLKKdfi8e9?=
 =?us-ascii?Q?mMX5X5eHn6jrG/BKA+9bBFquuFl2WOhOAA3ByfBPtrG2dLuFf7TAKt8wfFxb?=
 =?us-ascii?Q?3/fjWvTnGk0x7jOS/+ohL0Yu6XV445XEir4Oo6VHeKaIoGP7YdF0ydM7BKDr?=
 =?us-ascii?Q?fOAxGIPKibzdWJPs9WNqY90rUE95W1cLz+kaL5ZFhDiCbJvB5Qt5wwAe8OEy?=
 =?us-ascii?Q?HjRmyIV7tPQyf+ua7HNV+DYbpwi2eMRM6VQ5yUJzd+r4KhHb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe4a549d-8baf-4786-ae90-08df20dd5a62
X-MS-Exchange-CrossTenant-AuthSource: LY0PR12MB325698.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2026 23:31:58.8973
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EIyP8dGNkU/VY1AFiVe7r0B3da4uOv80JJom3XCGM0blsu2JWX4Ks8FdBhyR6l3B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5830

Currently the zboot stub has no access to symbols in the vmlinux. In
contrast x86 has a voffsets.h header that allows the stub to know whatever
symbols it wants for the decompressed image. ARM DRTM needs another 4
symbol locations to work, and it also wants to compile the DRTM libstub
code once and have it work in both zboot and embedded.

The current solution in arm is "code_size" from commit 45dd403da851
("efi/zboot: arm64: Inject kernel code size symbol into the zboot
payload"). This is neat, but it makes the zboot and embedded cases
work differently.

The x86 voffsets.h approach is also nice, but it can only work in zboot
since it relies on 'nm vmlinux' to extract the locations. That's a
circular dependency for the embedded stub.

One idea that meets the requirements is to embed a struct of offsets
inside the vmlinux and then have both stubs know its offset from the start
of the image.

First, each arch defines what information it wants the stub to have in a
struct:

       struct efi_image_info {
	       __le64 code_size;
       };

Second, it populates the struct with the linker:

       EFI_IMAGE_INFO(
	       /* code_size */
	       EFI_IMAGE_INFO_OFFSET(__inittext_end)
       )

This approach with the linker is guaranteed to emit a value and not a
relocation. I looked at writing the struct initializer in C, but that can
result in relocations inside the struct. That seemed sketchy so I stuck
with a linker script approach.

Finally, any stub code, either in zboot or embedded can access the struct
through:

  const struct efi_image_info *efi_get_image_info(unsigned long image_base);

The makefiles arrange that both links have a "u64 __efi_image_info_offset"
symbol that contains the value. For vmlinux this links to a symbol created
by the EFI_IMAGE_INFO() macro, for zboot it uses the same technique as
code_size through the zboot.lds.

Since this needs arch changes, protect it under
CONFIG_EFI_STUB_IMAGE_INFO. The arch should define the struct and use the
linker macro before enabling that config.

Since everything is linked together, and the actual location of the struct
is not fixed, this is all private within the kernel build and can't become
ABI to any bootloader.

As some follow-up work, it seems interesting to standardize on this
mechanism and remove the PROVIDE() and voffset.h alternatives. This would
also avoid needing to pass sysfb_primary_display through EFI from zboot,
for example.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/firmware/efi/Kconfig                |  3 ++
 drivers/firmware/efi/libstub/Makefile.zboot |  9 +++++
 drivers/firmware/efi/libstub/efistub.h      | 29 ++++++++++++++++
 drivers/firmware/efi/libstub/zboot.lds      |  4 +++
 include/asm-generic/vmlinux.lds.h           | 38 +++++++++++++++++++++
 5 files changed, 83 insertions(+)

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 29e0729299f5bd..3d6fb3ca2806ca 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -72,6 +72,9 @@ config EFI_RUNTIME_WRAPPERS
 config EFI_GENERIC_STUB
 	bool
 
+config EFI_STUB_IMAGE_INFO
+	bool
+
 config EFI_ZBOOT
 	bool "Enable the generic EFI decompressor"
 	depends on EFI_GENERIC_STUB && !ARM
diff --git a/drivers/firmware/efi/libstub/Makefile.zboot b/drivers/firmware/efi/libstub/Makefile.zboot
index 832deee36e48e9..42408132249ae7 100644
--- a/drivers/firmware/efi/libstub/Makefile.zboot
+++ b/drivers/firmware/efi/libstub/Makefile.zboot
@@ -26,8 +26,17 @@ zboot-size-len-$(CONFIG_KERNEL_ZSTD)	:= 4
 $(obj)/vmlinuz: $(obj)/vmlinux.bin FORCE
 	$(call if_changed,$(zboot-method-y))
 
+# Architectures may expose a private image information structure to the EFI
+# stub. Inject its offset into the zboot executable so it remains available
+# after the payload has been compressed.
+efi-zboot-objcopy-flags-$(CONFIG_EFI_STUB_IMAGE_INFO) = \
+	--add-symbol efi_zboot_image_info_offset=0x$$( \
+		$(NM) vmlinux | \
+		awk '$$3 == "_efi_image_info_offset_value" { print $$1 }')
+
 # avoid eager evaluation to prevent references to non-existent build artifacts
 OBJCOPYFLAGS_vmlinuz.o = -I binary -O $(EFI_ZBOOT_BFD_TARGET) $(EFI_ZBOOT_OBJCOPY_FLAGS) \
+			  $(efi-zboot-objcopy-flags-y) \
 			  --rename-section .data=.gzdata,load,alloc,readonly,contents
 $(obj)/vmlinuz.o: $(obj)/vmlinuz FORCE
 	$(call if_changed,objcopy)
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index fd91fc15ec810b..d15cca8d6ff8be 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -1176,6 +1176,35 @@ void free_primary_display(struct sysfb_display_info *dpy);
 void efi_cache_sync_image(unsigned long image_base,
 			  unsigned long alloc_size);
 
+#ifdef CONFIG_EFI_STUB_IMAGE_INFO
+struct efi_image_info;
+
+static inline const struct efi_image_info *
+efi_get_image_info(unsigned long image_base)
+{
+	/*
+	 * The offset of the struct efi_image_info from the start of the kernel
+	 * image. The linker script of whatever is embedding the stub emits this
+	 * word, see EFI_IMAGE_INFO() for the vmlinux case and zboot.lds for the
+	 * zboot case.
+	 */
+	extern const u64 efi_image_info_offset;
+
+	return (const struct efi_image_info *)(image_base +
+					      efi_image_info_offset);
+}
+
+static inline void *__efi_get_image_symbol(unsigned long image_base,
+					   const u64 *symbol)
+{
+	return (void *)(image_base + *symbol);
+}
+
+#define efi_get_image_symbol(image_base, symbol) \
+	__efi_get_image_symbol(image_base,       \
+			       &efi_get_image_info(image_base)->symbol)
+#endif
+
 struct efi_smbios_record {
 	u8	type;
 	u8	length;
diff --git a/drivers/firmware/efi/libstub/zboot.lds b/drivers/firmware/efi/libstub/zboot.lds
index 367907eb7d8698..f389aaadbe44bd 100644
--- a/drivers/firmware/efi/libstub/zboot.lds
+++ b/drivers/firmware/efi/libstub/zboot.lds
@@ -3,6 +3,7 @@
 ENTRY(__efistub_efi_zboot_header);
 
 PROVIDE(zboot_code_size = ABSOLUTE(0));
+PROVIDE(efi_zboot_image_info_offset = ABSOLUTE(0));
 
 SECTIONS
 {
@@ -24,6 +25,9 @@ SECTIONS
 		. = ALIGN(4);
 		__efistub_code_size = .;
 		LONG(zboot_code_size);
+		. = ALIGN(8);
+		__efistub_efi_image_info_offset = .;
+		QUAD(efi_zboot_image_info_offset);
 
 		_etext = ALIGN(4096);
 		. = _etext;
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index b2988aa12f6645..4dd52ddb148401 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -83,6 +83,44 @@
 #define RO_EXCEPTION_TABLE
 #endif
 
+/*
+ * Architecture specific information made available to the EFI stub, see
+ * CONFIG_EFI_STUB_IMAGE_INFO. The architecture describes the data with a
+ * struct efi_image_info in its asm/image.h and emits the matching bytes here
+ * through contents, using linker expressions the compiler cannot compute.
+ *
+ * Place in the same section as INIT_DATA.
+ *
+ * The architecture must also define EFI_IMAGE_INFO_SIZE to sizeof(struct
+ * efi_image_info), and that definition has to be visible to the linker script
+ * before this macro is used. Keeping the two in sync is checked by a
+ * static_assert() next to the struct and by the ASSERT() below.
+ *
+ * The struct's offset from _text is emitted as a u64 at
+ * __efi_image_info_offset. The architecture aliases this location to
+ * __efistub_efi_image_info_offset for the embedded stub. The absolute
+ * _efi_image_info_offset_value contains the offset itself; Makefile.zboot
+ * extracts it with nm and zboot.lds emits it for the compressed image.
+ */
+#ifdef CONFIG_EFI_STUB_IMAGE_INFO
+#define EFI_IMAGE_INFO_ENTRY(value) QUAD(value)
+#define EFI_IMAGE_INFO_OFFSET(symbol) EFI_IMAGE_INFO_ENTRY(symbol - _text)
+
+#define EFI_IMAGE_INFO(contents)                                               \
+	. = ALIGN(8);                                                          \
+	__efi_image_info = .;                                                  \
+	contents;                                                              \
+	__efi_image_info_end = .;                                              \
+	ASSERT(__efi_image_info_end - __efi_image_info == EFI_IMAGE_INFO_SIZE, \
+	       "invalid EFI image-info size");                                 \
+	_efi_image_info_offset_value = ABSOLUTE(__efi_image_info - _text);     \
+	. = ALIGN(8);                                                          \
+	__efi_image_info_offset = .;                                           \
+	QUAD(_efi_image_info_offset_value);
+#else
+#define EFI_IMAGE_INFO(contents)
+#endif
+
 /* Align . function alignment. */
 #define ALIGN_FUNCTION()  . = ALIGN(CONFIG_FUNCTION_ALIGNMENT)
 
-- 
2.43.0

