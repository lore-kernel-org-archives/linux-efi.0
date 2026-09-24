Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010039.outbound.protection.outlook.com [40.93.198.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9756B372B32;
	Thu, 24 Sep 2026 13:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790258023; cv=fail; b=t4ivXKtIeLliEBQ+/ezZq38HYVomx7eZcpzYD0SOvbeDC77sDYROVneZBFFtBM5A7OgpyKxIUrGugp/5GG1aHr0k9lGDeVlHDt+Z1JknuNPmMXTBsRFTWc3r1ZbF4ugE+BSfy4JCYiOfa1gujW6WlhrxoX77TCEjlvfpZWYm8b0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790258023; c=relaxed/simple;
	bh=5++FrB5AIMxU99Vv+LaWBMmjEuZzXbsOl/xIq/+1wQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=m7kuKvc7hbI8vUxT8sN+MVtz+49CjzP+YHpKO0/ARImme81CnhLYkjecf+zl4m6OaqbTHwAHIbX8oFJ23sB4mUMcI+CAF6fEp5WX5NpfzftJC5r7rb93T8+abpXG4z7/a4k76fMUW3bOcHupyLULayURGsrQAfjKO4wQR5Hiv3E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZwH6d0c7; arc=fail smtp.client-ip=40.93.198.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZwH6d0c7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q782A5RTuxonmznSpbBz0WYdl7DgU7ucxkHQNb5qCQdF3j2f/7anw9NmfvMN1DONe8LxTDDDITnIUu7+l9lBdX+ELOBJiR3vlqzLEHbypZQYoLpc9jpVvFJ6oSTQsE8+ExzPEGzrbutgp/r2aNnzPMPdLFqpI1QaK7r2PC1efvmzD9dueBM8NWNBKOaLX109x1wPWWeLSFdDsUu8LxVewcC/iIJTgkRg0QjoSRBjA43vsHWChlqlovEYM0RivzFltv8rHQsIGBC3mc8YUMgcS2P7RiDBiBLMrbvBchc4JMRPoEPflLFWc32zfcCHZsxjkry3U1MqDgPJzBsmuoOUfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iy+N+6kKai5ROs71xVyYy+U/MC3utt9/ggIPvjuUj8U=;
 b=m+L83EIwTjVsRiFgTZ9+ZjH//kneQPXLXlO5ZKpf3N58yXUFb6k55LqMb6VR92VlH8g0Xi/+i6jvMOd4E3giYKNG7NA25ut7TID8O+CmqLIBc/NM8sSAHGMnTS8L/IdJIoCI9u+EyaidKXZRuxYALvuQTYH0ssWae1yCEux3XyePwlz0o72msuhQdqzPspBAO6kuGuC4+E3l75F07XSV8jCZg4wmrT1s3pl7b7hLKc62RHS/75vtYsX0g0fPnlMEShKKaY1eHhKK8faq24P5nEDmL8xM+8yFB3sQ7QLG7QOo2/jBH/IWxx4yF78HsvSn61W1f2NQ6EI24EWhBShp3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iy+N+6kKai5ROs71xVyYy+U/MC3utt9/ggIPvjuUj8U=;
 b=ZwH6d0c7Uxgul9Y8T/kuSMPIgDSbmxltNpDyFZbllTj38aChMZuZ4jM4XcBDVs623wq9Ht7L8WCmOr42a+/NX7V74Jt9rvrb2UtI6PZ/RIdL9Bs01eZ+UjidGidnwsRrjPJNnmi5AVd5A2yjxLU2iNjBhYe1TqMWEOSRqDTUev0czS0jkimldTTshsb2dr7W9l15QhqoH598Mv/mMtuSim/GO3YFO5dXlhweu8uSP7xXG7FbUPlZnc/WuPup19235dCTkjiUv0wJ/AwOIJitgcu6hbzk1GOxiA/690KrtgEsOjUcnomvSBPo9iZ7FdExpAwbuSJQ/teJm6HrYDpjCg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by PH8PR12MB7375.namprd12.prod.outlook.com
 (2603:10b6:510:215::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 13:53:30 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 13:53:30 +0000
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
Subject: [PATCH 13/16] arm64: drtm: Update the linker script for EFI_STUB_DRTM
Date: Thu, 24 Sep 2026 10:53:16 -0300
Message-ID: <13-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
In-Reply-To: <0-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0075.namprd07.prod.outlook.com
 (2603:10b6:510:f::20) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|PH8PR12MB7375:EE_
X-MS-Office365-Filtering-Correlation-Id: cb68d15b-f318-4898-c49a-08df1a43335a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|921020|11063799006|56012099006|10067099003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	jYbm6Ree4kOFgELGIzNWB5rHZHNNussFLXF/6x5XvvH0ircHjn6OHYjAjak2gljAz0/Ckp/ZorjJjF1rUn1GTboGZApdk7LCrAjNVaPOByw7XF02m39IIKOhffO9AvpGV4f4+jhGe+MOKRV6uyqHN8YulpLpnQ0Yt+/TiKzKaMlIFXCwcvXpUUIskezNjS7nmWm2sydRnKyjZfijwMhlQFo0Xjwp/Ns54nM3icNySy4s7ReEXE5+uscHgCyZ/kL+CMZeaemNQqlyYUzpAXvPX3fcCXrdDi3wM0+VaAo4lChh/mDbG2IjFUlDsJHK4AjIOSBJNGuPZJvSKcg61t5CEE6OHWlOveqIk1Zp35z2siEaKbIXPshJHpA427Z/AU8W8ijn3uT4jrnrmGykb3FM3yULsLOnxIwV1xxCWYO6CcCNR34qR5mO1nGrNSFsJGu3+W99lGfmCn3s2ngSR3uk6RbBBz5M6DGwZVrympr3E34IO7Ed0Ww2aYibMRfJzuizkcXt5fLXJsPbEjKA3aPpzjrmYvn01kvt+nnezTxXPlZDnu3U11wo3HxwDYjmwpqMvveaG/tMu/8VV6FS1RzjysCU0ci+bYQKfvfvmMH3MwzQGoGX0vnQrGXH/7O56YsB53UQ4TcLEBr1yoXLaN91PGKHR6Uv4LfBaWrQSxn7AdtQcBKy56uMFKM+Gh3C+nf/URBImWoGCuik/Rjm4R2KUQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(921020)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WhZ+tykOIkO9lnsjY26yKZ3p4BFsCWuYrdwru2vMzf43eyblVYWjjeXFl/1A?=
 =?us-ascii?Q?U3DqDhYZu+OzuruLXADDJ3sCn6SnhIJv0KdaHAF3+ZUrQqqyKJcHLzHd+9Np?=
 =?us-ascii?Q?4/X2OCemPUrHMJRLhtb0vZubJeQ+S4XT29SAHF++Wyb+5J898KVjb7otI71Y?=
 =?us-ascii?Q?vI3lEnvEYUb3hRtwGVb5oQRnorYSoWDSZS5zCC5KebAPUL/h9uVjBjz5baCE?=
 =?us-ascii?Q?W4QmXUiGtDTb7HzJcvycZk2agndp/Zd3y9Fqx0oIKWjS96qBSpFxf3kFow1O?=
 =?us-ascii?Q?YpzltbgJsizGNw0/a49JQKh5l9mHOBuyHPDaUHLcvwlIkQS0+bCiDdH9OBeT?=
 =?us-ascii?Q?aiALgnrEMM8xnSKYW2XzrA0+dr9Se5gDqbBdStF51tHpnT2UL83rDB+3sgKo?=
 =?us-ascii?Q?4vX/wiAhr9cpeKyD+VDM8WLJdZYpHGuKWq+qZRUi+YukdaBtRQNVkeUqb0qM?=
 =?us-ascii?Q?pSWbAHhedw3K+0t+1Cznd1hFolDxmQukA8AWDf8bJSrXJr1Dj9ftHO99ZAPE?=
 =?us-ascii?Q?8XLzEF1j9PGDgejaYUlgn/0H9aUZGhAPJo8197ptM6s6pKvToJ0dm7jJiq2m?=
 =?us-ascii?Q?XWTPbcgu5/rUeZbDQyDQs+LvGBsceuZSEX1lP/jAaSLwCdQAF+ibs1V0TOTA?=
 =?us-ascii?Q?el8pJTF2wk95yStg6RiuI/EF1qRicRR+CwIg9GDuLUYUQbYZoGMT9ymL7BBY?=
 =?us-ascii?Q?bZjdwoa+apIbH5RaWbsotbj+KjUP/wldM2zcHjF9i6rmoi8Ri1/kk52mUjVz?=
 =?us-ascii?Q?A9HrWQ2DB8MMTpHxRxWT5klhlabeAsnElvrvdW13QrY+iQwGojkppq9Z2f/A?=
 =?us-ascii?Q?niGLTQl3u5eVUCNaqL8z2p/SgeJstNM0jo+U4hz7Cf3IMhM2uZ2CWUnVPVeF?=
 =?us-ascii?Q?hp93ASWb4y5R3UvDR/lPv3nL06f4HV3VVeClUI4IEb0tcv6h0Ow+SmgBxaOn?=
 =?us-ascii?Q?G2wijnfBZpx8TXtPD0PPPknA4OTxNdlFSFtJJO/bUkdkMkZFlZUychC6MRP2?=
 =?us-ascii?Q?HQHfTjTn3l3633P0wVyh3SsTkZO6AYndM5B+r9yRBb0BqW5tKqsO+rBW6ZBR?=
 =?us-ascii?Q?KNs4lB5NzSQWOj1U5ve9WQdpqauQm/7SN4CGhZurE7wo/CGU5qbfOXiN7K0b?=
 =?us-ascii?Q?3nNTJq68/2d6VD5c/dWzka3ZUSsAqft055BT36bzBu5KI2EfkZI+T+rRAF2w?=
 =?us-ascii?Q?qHplJUGLeZRZCkx0Tmg0Llk6rX3W5HxIXyL3z8MZayu30z16Z35Gv+rEoM17?=
 =?us-ascii?Q?xTwEs00qAXorNCbnrgqAtN+JnbZMH1eZjv+M3/3jTDHAde0HB7YNgQf7KOsx?=
 =?us-ascii?Q?7nt7tv/zBViD7hfWxmns2CAb4b/6mO0CrKhj4mLsfNqjZOApeL27o2a2zSfz?=
 =?us-ascii?Q?S7+U9aK/H4/FB2q6cvb1kr2wO1jskttoIAXmCmrJq5pfBuK2yXFE7E1m6wut?=
 =?us-ascii?Q?VWmZ2MXHtWPGfg2Z6SDhZYlI3a6nEH+11nnJxU+lCOtuYUdVb2YWeYXvFMCz?=
 =?us-ascii?Q?1gpwQ58Kfn0QXbzTv4K+qD2epqjfAhqfi+LJANamR86qnwVdsXBUX5UdoOt2?=
 =?us-ascii?Q?jNq5EZBUyjL/2l529f66KOMpjrnQABE2Q1vVVl3rWoFPFG0oSgvrq7pOta+w?=
 =?us-ascii?Q?9A99GFFOcQrPEal7yoW6piRFeCRE6a941nwAw/0GY0hUc1vLXAsZC20W+3Z0?=
 =?us-ascii?Q?hrEigLOf8QUCyudT0sknFJTDM69DMiApSSKSg0Zop+yMFqCo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb68d15b-f318-4898-c49a-08df1a43335a
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 13:53:23.7546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NrKYfF/kqp3NCyJdN05QRSOjNHaMs/RC49VEfl+3Zo1hyRt90YGDpedHrUZbxAIn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7375

Implement the link layout that CONFIG_EFI_STUB_DRTM requires. This maps
vmlinux into the Dynamic Launch Measured Environment (DLME) defined by the
spec.

Broadly, Image fits into the spec defined DLME region memory layout in
this order:
 - Program headers and padding up to _stext. EFI can write to these while
   loading the stub so they do not have a stable measurement.
 - All the boot-time immutable data, including .text, .data, .init
   and so on (measured)
 - Data written by the EFI stub
 - .bss, padding and other 0'd data up to _end
 - The "DLME Data" written by the launch process. This is a datastructure
   the post launch kernel will parse to get trusted information about th
   launch.

New linker symbols are added to mark these areas and their offsets are
placed into the efi_image_info so both stubs can get them.

The spec's design of the DLME was intended to fit a typical OS image like
this, with two areas that are unmeasured and an inner measured region.

Linux zeroes the unmeasured area of .bss/etc after the DRTM launch so it
also reaches a known value. The DLME data is written by the launch and is
trusted. The EFI stub data is either ignored or will have to be sanitized.

Add a section for the unmeasured data before the PECOFF padding. This is
an allocated section so it is zero'd in the image and is only 64 bytes in
my builds. There is a high chance it gets absorbed into the padding
region.

The post-launch kernel will have to reserve the "DLME Data" before
starting the allocator since it falls outside the linker map. This will
happen in the first series to consume this data.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 arch/arm64/include/asm/image.h  |  8 +++++
 arch/arm64/kernel/vmlinux.lds.S | 64 ++++++++++++++++++++++++++++++++-
 2 files changed, 71 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/image.h b/arch/arm64/include/asm/image.h
index 4a220c71f76c6a..a4af9a94037bfb 100644
--- a/arch/arm64/include/asm/image.h
+++ b/arch/arm64/include/asm/image.h
@@ -5,7 +5,11 @@
 
 #define ARM64_IMAGE_MAGIC	"ARM\x64"
 
+#ifdef CONFIG_ARM64_DRTM
+#define EFI_IMAGE_INFO_SIZE	40
+#else
 #define EFI_IMAGE_INFO_SIZE	8
+#endif
 
 #define ARM64_IMAGE_FLAG_BE_SHIFT		0
 #define ARM64_IMAGE_FLAG_PAGE_SIZE_SHIFT	(ARM64_IMAGE_FLAG_BE_SHIFT + 1)
@@ -62,6 +66,10 @@ struct arm64_image_header {
  */
 struct efi_image_info {
 	__le64 code_size;
+#ifdef CONFIG_ARM64_DRTM
+	__le64 drtm_measured_start;
+	__le64 dlme_measured_size;
+#endif
 };
 static_assert(sizeof(struct efi_image_info) == EFI_IMAGE_INFO_SIZE);
 
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 8305b47995954b..18d9717fb26741 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -190,10 +190,24 @@ SECTIONS
 
 	.head.text : {
 		_text = .;
+#ifdef CONFIG_ARM64_DRTM
+		/* DEN0113 R314010: The DLME region must start at a 4KB aligned address. */
+		ASSERT((_text & (SZ_4K - 1)) == 0,
+		       "DLME region is not 4 KiB aligned")
+#endif
 		HEAD_TEXT
 	}
 	.text : ALIGN(SEGMENT_ALIGN) {	/* Real text segment		*/
 		_stext = .;		/* Text and read-only data	*/
+#ifdef CONFIG_ARM64_DRTM
+		__drtm_measured_start = _stext;
+		/*
+		 * DEN0113 R314020: The DLME image must start at a 4KB aligned
+		 * address. This happens always because SEGMENT_ALIGN is big.
+		 */
+		ASSERT((__drtm_measured_start & (SZ_4K - 1)) == 0,
+		       "DLME measured start is not 4 KiB aligned")
+#endif
 			IRQENTRY_TEXT
 			SOFTIRQENTRY_TEXT
 			ENTRY_TEXT
@@ -285,6 +299,11 @@ SECTIONS
 		EFI_IMAGE_INFO(
 			/* code_size */
 			EFI_IMAGE_INFO_OFFSET(__inittext_end);
+#ifdef CONFIG_ARM64_DRTM
+			EFI_IMAGE_INFO_OFFSET(__drtm_measured_start);
+			/* dlme_measured_size */
+			EFI_IMAGE_INFO_ENTRY(__drtm_measured_end - __drtm_measured_start);
+#endif
 		)
 	}
 	.exit.data : {
@@ -348,6 +367,44 @@ SECTIONS
 		__mmuoff_data_end = .;
 	}
 
+	/*
+	 * DRTM layout for DEN0113 as it relates to the link layout, refer
+	 * to Figure 8 in 1.4b. In that language:
+	 *  "Free Space 1" is the PE header and padding between _text and
+	 *        __drtm_measured_start (_stext)
+	 *  "DLME Image" is from __drtm_measured_start to __drtm_measured_end
+	 *  "Free Space 2" is kernel efi data/bss/etc till __drtm_dlme_start
+	 *  "DLME Data" is a memory sized "Minimum Size of DLME data"
+	 *        and is retained after boot for use by the kernel
+	 *
+	 * Thus, the DRTM_PARAMETERS follow from that:
+	 *   DLME Region Address = _text's PA ie the start of Image
+	 *   DLME Region Size = DLME Data Offset + "Minimum Size of DLME data"
+	 *   DLME Image Start Offset = __drtm_measured_start - _text
+	 *   DLME Image Size = __drtm_measured_end - __drtm_measured_start
+	 *   DLME Data Offset = __drtm_dlme_start - _text
+	 *   Normal World DCE region address = PA of __drtm_dlme_start +
+	 *                                  "Minimum Size of DLME data"
+	 *
+	 * The EFI stub will place any optional "Normal World DCE" region
+	 * immediately after the "DLME data". It is only used internally by the
+	 * FW during the launch and has no effect on the link layout.
+	 */
+#ifdef CONFIG_ARM64_DRTM
+	__drtm_measured_end = .;
+
+	/*
+	 * Writable EFI stub state. When DRTM is being used the stub's mutable
+	 * data cannot reside in the normal .init.data because that section
+	 * will be measured.
+	 */
+	.unmeasured.data : {
+		*(.unmeasured.data)
+		*(.init.efidata .init.efidata.*)
+		*(.init.efibss .init.efibss.*)
+	}
+#endif
+
 	PECOFF_EDATA_PADDING
 	__pecoff_data_rawsize = ABSOLUTE(. - __initdata_begin);
 	_edata = .;
@@ -370,10 +427,15 @@ SECTIONS
 
 	. += SZ_4K;		/* stack for the early C runtime */
 	early_init_stack = .;
-
 	. = ALIGN(SEGMENT_ALIGN);
 	__pecoff_data_size = ABSOLUTE(. - __initdata_begin);
 	_end = .;
+#ifdef CONFIG_ARM64_DRTM
+	/* DEN0113 R314030: The DLME data must start at a 4KB aligned address. */
+	__drtm_dlme_start = .;
+	ASSERT((__drtm_dlme_start & (SZ_4K - 1)) == 0,
+	       "DLME data is not 4 KiB aligned")
+#endif
 	__pi__end = .;
 
 	STABS_DEBUG
-- 
2.43.0

