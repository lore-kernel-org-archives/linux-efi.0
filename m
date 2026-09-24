Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012024.outbound.protection.outlook.com [40.93.195.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7773793BA;
	Thu, 24 Sep 2026 13:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790258027; cv=fail; b=mSbu4U5LUYhewQa0qGpbjvjF363VPJNwdN99YULqWHb8lPwHht/MOJPj+CAtKjIPEgNFShLu1ElIkeUemrbskxx2OwPC7W5qncUZy0EAC73eY7rgIUQ781KcAkvYl9yz1Rv5WEjxffJyEGPSx1tvZZ+rDpQS/gjvnBzSevYNdTc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790258027; c=relaxed/simple;
	bh=JDdMec+S1fIQ0pzQ/fdBwiyla8u8Z5FtxNH/w8S4KNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=J4ovLqtC3BdUy5EsD9hbKOshgNtbDFOjSxUka8LPjqKbrqDu5Lz8kjL/i1X/GkoaOINQ9SvUG4TogEgOYRSMScExOLe4tE1YJGOqv+odgJSM7D86Xi79/A8Cjgz59ybesNowgF6ULRUL0hSr5LZXpVe6e1WMcNtKjnsKQb8fSO4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bBeLISCp; arc=fail smtp.client-ip=40.93.195.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bBeLISCp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xdWRDMJBy61b3zyaTi8oX/j0J3M/vKxgXbwcMM/EILXBXW4VcjG6HyeIEIGJU83WvGWgEBhqxO4dWj0fInt2xhAzhtPuJhUc+zJ+TM0cL4hARNixG6TSrThFmjDx8g9MUA4Prk4x4VvYpHV0bjipIRG9k+JZZ7lWNBzkl3VF06fUChjbDdH+3942szH3zAZtR6q6iSOaRfkls1VHOHo/m9d85MXHI85DRW8m/7k4IzElHBgI423Y5QqxL9NfoB1TWV9ZUTGjM2P8HhjRyXv7SKJM6P0AJ93f0XAXYBcSEWqs/BpCvzjyGiOulRMFWrnmn66hlmr7ViJHCFsHYf6ILA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ezwn0mwZP/n0pEbFg+2SUr1tj4NmhxEh3O1E23I6nng=;
 b=iulbZy2l4PqIs6dj9w+o5kM50rV/5bOXOMOslKqJL5VISgwOtZ8CR5QfgET3dG2+PsidDCP9VXRTCOFEmaxZa/1FOfrwnIyDgMGhr4jRdUcN8yzwg1m3KVP0O5UNhput3S8E8ZW8hQStqIL+Ba1zpq+ftVkFXhTzKfRTCkSI7T9pzFz3XhHuBs7EtXTH15xV0XWMvUtU6kY3/kCHFWg61cWbReM5s6FD2znhVDxnVKqy6HW7Nk9S/KngpfuvPyHTYUIRhRTME2qWY7ATsEdZPq4eKEFlldi7iqO4isKf1ejzAciS0gou3/02Fp3mCVc/y8VL79u+k/Ic0bMLsBBwBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ezwn0mwZP/n0pEbFg+2SUr1tj4NmhxEh3O1E23I6nng=;
 b=bBeLISCpYl6a7yEEKX1UpwDx6A8ItTNDKk4K7xcJd3FCTEGGNIr5TA1qqRis6g8UZ+XWwkgz84nnGl0lvqAuXnFykcCPMrhjCy+ncWYPeDBf5OYY+TmO9G5brh8MazmMyQLkzz5FlmfzZQVrXdeqQRnv3P/rBD+DGRhKBEbbHBTXlDDmtDd5x5qbjKifzBHao7c9N8nKRVuxLqwapqGXpGhIfHjFHyoGPGc+K17VkvNz71vVnkCCGCB7YyUgSCfnpOth+eUF8rMPibbSbz8tCud+NTH4NE8oQPhNfvJj4OVT5OqDuWeDgXC/z4q2FDum54GvO/BlKd/cPKXmwd9HVQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by PH8PR12MB7375.namprd12.prod.outlook.com
 (2603:10b6:510:215::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 13:53:31 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 13:53:31 +0000
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
Subject: [PATCH 05/16] efi/libstub: Add a general way to get symbols from the vmlinux into zboot
Date: Thu, 24 Sep 2026 10:53:08 -0300
Message-ID: <5-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
In-Reply-To: <0-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR13CA0014.namprd13.prod.outlook.com
 (2603:10b6:510:174::28) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|PH8PR12MB7375:EE_
X-MS-Office365-Filtering-Correlation-Id: 86f093b2-5765-40bd-9d72-08df1a433368
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|921020|11063799006|56012099006|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	7TaN+V/wKMsABqk++gmeMsoBvKzAIYdaYob6NRlaMxGtO5jIewXdL44WjK5c10EEBJbuEmP8M/Hm36UJ0+rkKxxlo4f40W/VOPM4K0yO2bjUgZktp9KYhztLEE8DdQ1bo3Cii+/KVTCkUhJrResLkhypeozNMmdZ4CfzpHVLLrxqy+8w4PoHTel1ssykQPliYUtZC/Q87fao3nU5hlCB1EI+F7LZasD3Rsu4Gv7lrg87/FE8dveptT1+UO/jRw7RFld8ZjEaW/C6+4axOFX3cZOz/TvT+JHSHEq5r91YTsn1hkU/pMenA0pggsCfN95zAFauKUccqtx1ovNjlTlijT337uP1FWosGt30frVOLp4bUrbweEVM8hNoNCFCL14iPkUgpwMwnVgS3Vtns6lUkqW6p+vxMbMAO+mDeCnMjpdQaHM2rMOmBSvDD/mACmoHoCQ+mz1a0oEGX517VkdpjHeQfYqKfKMp549GW4nVOuUFE9rwWV2C1SpTgGccZ4/yu4iasF+kykdxrMvTPIUbjCr3wCR9S3VVTSRIjU18o8MJ7FC8VxM49uKt7ZKfImQj2Bk5s9gtqB2aPmtt8sFjVaZgEGNF2JrSHzGdyF+9nnNXGiE17HIIUQ9LrAswJI3p9YnXGf+47q7fQbLuATPoiVaIvGr2+YkxC8MGVsxXGsaix5OrghLvej9/Zvrq84UublvTzthnU4PqNlxYaP5gzw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(921020)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QeAhH6OtWvUORgb6GsXzP1a6s1+sGjfoeqm1J/AVggjZpxiaKIMf5q7ir/4v?=
 =?us-ascii?Q?4XvGokfQ5iAIDY8LjqqObubZm1Aku+nXDChCPVy06DUGeBd/1dBHgYdfjs0y?=
 =?us-ascii?Q?D5VdOMbTPXPT9nWB02rSgOppEm8J+hpU3qs9y3wmU+sUv4vTNhe5d8t2aaN/?=
 =?us-ascii?Q?UxCnRFRvpCG6FDNBwQeEv9HiOThENw4Q28uHDpJJ6SwSTZxn7cneJuPUqLnG?=
 =?us-ascii?Q?ymjoXc2MHcXbrSSY5PrfVbL5VKmaUNbfbOxHTaMabd8HWLkRVfjtK/TrNuiy?=
 =?us-ascii?Q?/BO6jWkq9hUSzfVFhJoq2AkHPrdsApMu6u6IUJErB2Be251Rg5NXRRX9vzUv?=
 =?us-ascii?Q?9FrdZW4vlZACbZO5gqRXf56rh3CITl3x2S/i6ge8HBRLAOrt/vpRjQZ7qhMw?=
 =?us-ascii?Q?mh6SkAiisjFDlhkG/roskG5ej4Fb5eUaBzIBZng/Ovw0HnVvZv1mj5gxQGcS?=
 =?us-ascii?Q?MQRTx9K4S6cS19oP0cIaB7ClZMLdmapuh2A294L+KyNt2xXTlyU4b2KAzUo3?=
 =?us-ascii?Q?r8YMHOJX4w1FjU0Ae9WcVj0NGTF5TOvNH4lc7IPIYRPnVcZEFHdHxYKDBWfY?=
 =?us-ascii?Q?Wa9HLiE71pkqj29ZNsJ2MrcGrfD0AJzuZ7HYV2N+gZuIuGemYRhy+wW1B1OX?=
 =?us-ascii?Q?2jAf2K0De5gmLcsIijwNvuBYzrsLEjQ8+omK4ACb2xLXXD9WLc8O2heS6U5I?=
 =?us-ascii?Q?8w2g2doqSbfk5tNMNh7MC0IKy0BrSlyklWScjII6r7PqXgAsvRWauUMDWP6/?=
 =?us-ascii?Q?I+wDd0fyGOjmkiJREBJeikqooO6kXLWt08YlVnmx8w6aqi0OzfVCyEWXuUQP?=
 =?us-ascii?Q?V03U669x4YlPzpWwsaUW106lPNeOOSDuZ97toriZ4w/DNEnotYIQ8UFFbwQy?=
 =?us-ascii?Q?xNaJMSwPefJAtmWKUe1PNoZZRJ0zKgjtO8c5imcTxNwVcr734Wj7mQq/MVfr?=
 =?us-ascii?Q?kfmzLUgzqrHPILfxqCSOQ8Xzur8P7G5U8umY0Hk7O4duD9hQx7x41GUqKYMz?=
 =?us-ascii?Q?0LGjtK32Tc4M3pEcJ2+PjcBuyVxHgWYGOQWW/wWtSlo3fcOEwhZfqz8wfiF6?=
 =?us-ascii?Q?G76o2653rDoz2R/fZYyYuArF38wgJbyUcxCKPUCgSEzUNA+mza0O3yCi+SS1?=
 =?us-ascii?Q?Ef13aR8V2g9PG0KmYcCWYda1w/Eltoo+kK08Q07VRO9Ne5xqiHVAPmn/pq5d?=
 =?us-ascii?Q?R4w8ZEufG09/b0QGJUgN5TRM9xFefuXXJ6pqa2DjeZhqfgRdGmurP+hz0MrK?=
 =?us-ascii?Q?GlI35Hd1rZY5Qun7T29Crm5U/7uRiMAxIH4KsPVlYeNE67VjZTFGZTY55tvP?=
 =?us-ascii?Q?nWNiyIJG8qaTwNEQwFBif7zYNTQSHrbDdMiw4AY39tKph4tKL0dIgrLx/DV5?=
 =?us-ascii?Q?Av1OQijkc20eBj/K2uLb33r9tGGDmsUxZ1ITPnrhUjxKmjPVIASGegII+SsR?=
 =?us-ascii?Q?4Y5IuFQEV+TgnpXJ93aVN8ZGSXadpmAV9KMmSl0SDkdB7r1CMWEse9K2gfE6?=
 =?us-ascii?Q?9sQMm4k4o6xCfMnGKMXqWtEkS96dEAQECo9pab0VcMKg5HVyH1uGUZJ5d+6Q?=
 =?us-ascii?Q?WsqEe/d2HmQ1kheQCT7BCXlt+XgFVAjFscRoD0UyhXt1cmX0aBZ/dxPHCS+0?=
 =?us-ascii?Q?pFyuRkyTIi6QT1g/2UZp04hNo+hClWSCdNdBcBvDmc7AW6Kf+IZu/CDtbgFg?=
 =?us-ascii?Q?QNF5hMSoeE0+c5SpxhYZiWsxaJdICMKta0HBZ8KGO3ZuMJa+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86f093b2-5765-40bd-9d72-08df1a433368
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 13:53:23.9695
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6N2dqPBqEv0dRbgu3Dsit6CmJYSvz3rOfCA8Sm4xM7fQIU/BjX27wRjyiQiupITP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7375

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

The makefiles arrange that both links have a "u32 efi_image_info_offset"
symbol that contains the value. For vmlinux this links to a symbol created
by the EFI_IMAGE_INFO() macro, for zboot it uses the same technique as
code_size.

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
 drivers/firmware/efi/libstub/efistub.h      | 29 ++++++++++++++
 drivers/firmware/efi/libstub/zboot.lds      |  3 ++
 include/asm-generic/vmlinux.lds.h           | 42 +++++++++++++++++++++
 5 files changed, 86 insertions(+)

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
index 832deee36e48e9..6eebac66b73b18 100644
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
+		awk '$$3 == "_efi_image_info_offset" { print $$1 }')
+
 # avoid eager evaluation to prevent references to non-existent build artifacts
 OBJCOPYFLAGS_vmlinuz.o = -I binary -O $(EFI_ZBOOT_BFD_TARGET) $(EFI_ZBOOT_OBJCOPY_FLAGS) \
+			  $(efi-zboot-objcopy-flags-y) \
 			  --rename-section .data=.gzdata,load,alloc,readonly,contents
 $(obj)/vmlinuz.o: $(obj)/vmlinuz FORCE
 	$(call if_changed,objcopy)
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index fd91fc15ec810b..da01d6005a62af 100644
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
+	extern const u32 efi_image_info_offset;
+
+	return (const struct efi_image_info *)(image_base +
+					      efi_image_info_offset);
+}
+
+static inline void *__efi_get_image_symbol(unsigned long image_base,
+					   const __le64 *symbol)
+{
+	return (void *)(image_base + (unsigned long)le64_to_cpup(symbol));
+}
+
+#define efi_get_image_symbol(image_base, symbol) \
+	__efi_get_image_symbol(image_base,       \
+			       &efi_get_image_info(image_base)->symbol);
+#endif
+
 struct efi_smbios_record {
 	u8	type;
 	u8	length;
diff --git a/drivers/firmware/efi/libstub/zboot.lds b/drivers/firmware/efi/libstub/zboot.lds
index 367907eb7d8698..cc55aa8fb0630f 100644
--- a/drivers/firmware/efi/libstub/zboot.lds
+++ b/drivers/firmware/efi/libstub/zboot.lds
@@ -3,6 +3,7 @@
 ENTRY(__efistub_efi_zboot_header);
 
 PROVIDE(zboot_code_size = ABSOLUTE(0));
+PROVIDE(efi_zboot_image_info_offset = ABSOLUTE(0));
 
 SECTIONS
 {
@@ -24,6 +25,8 @@ SECTIONS
 		. = ALIGN(4);
 		__efistub_code_size = .;
 		LONG(zboot_code_size);
+		__efistub_efi_image_info_offset = .;
+		LONG(efi_zboot_image_info_offset);
 
 		_etext = ALIGN(4096);
 		. = _etext;
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 1786a8e4323b9f..196c0f27efcd83 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -98,6 +98,48 @@
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
+ * The struct's offset from _text is emitted as a u32 at
+ * __efi_image_info_offset, which is what the stub's efi_get_image_info()
+ * reads. The arch has to alias it into the stub's symbol namespace. The
+ * absolute _efi_image_info_offset is the same value, it is extracted from
+ * vmlinux with nm and injected into the zboot stub, see Makefile.zboot.
+ */
+#ifdef CONFIG_EFI_STUB_IMAGE_INFO
+#define EFI_IMAGE_INFO_ENTRY(value)            \
+	LONG(DATA_LE32((value) & 0xffffffff)); \
+	LONG(DATA_LE32((value) >> 32))
+#define EFI_IMAGE_INFO_OFFSET(symbol) EFI_IMAGE_INFO_ENTRY(symbol - _text)
+
+#define EFI_IMAGE_INFO(contents)                                               \
+	.= ALIGN(8);                                                           \
+	__efi_image_info =.;                                                   \
+	contents;                                                              \
+	__efi_image_info_end =.;                                               \
+	ASSERT(__efi_image_info_end - __efi_image_info == EFI_IMAGE_INFO_SIZE, \
+	       "invalid EFI image-info size");                                 \
+	_efi_image_info_offset = ABSOLUTE(__efi_image_info - _text);           \
+	ASSERT(_efi_image_info_offset <= 0xffffffff,                           \
+	       "EFI image-info offset does not fit in u32");                   \
+	.= ALIGN(4);                                                           \
+	__efi_image_info_offset =.;                                            \
+	LONG(_efi_image_info_offset);
+#else
+#define EFI_IMAGE_INFO(contents)
+#endif
+
 /* Align . function alignment. */
 #define ALIGN_FUNCTION()  . = ALIGN(CONFIG_FUNCTION_ALIGNMENT)
 
-- 
2.43.0

