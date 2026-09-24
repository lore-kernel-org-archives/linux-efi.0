Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010039.outbound.protection.outlook.com [40.93.198.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12772367291;
	Thu, 24 Sep 2026 13:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790258011; cv=fail; b=UuCzaZz3Fi8oxo7rkYKdrxyqUh9O45ZZQkAQpVL7OA7CwL9YtYUZeMy5f7KSGf2l15Ld4PJc7gxG0pk61Cg/c7lNMVWecJ2FnRGV/LBp4uSKojfLpwM5g6hUXYh3C866N3TMdzZsbaUaEFxKmCkQYJnZ01TV0UpXb/uQKsRP0B4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790258011; c=relaxed/simple;
	bh=W0fKD4gKZRcfGK8wzo/cl8UfaqWOG734nKuD4mXZULo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MIh+cFiOLBJDQD9UAm8BD/v3ApU/WK+8AA6fs4F0PDcQILa2LBqoraPBOms6pPhFtvn9G5d70i87J4a/jU6sRVnRV7AFzrhgVjs03Jc1l2kMJ351hohnMgnlvxVHF+wQtVedn4UKIhNYGIg8OJeokbqWVm4lDU256lELAGa9m9I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Are976PE; arc=fail smtp.client-ip=40.93.198.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Are976PE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dgqg19RTkDnLdOZoLtH3Fqxh07s1Qi9WcIUQPtWbl5rp29afVBV8b0DtmqCiI/aUV9nxggZQbZlcW0ONGDvTXxerlVIcpeBSXX+HoS0BVD14SJN/QtEMInlDWqfmyoouvz5dOYV+0m5Z+rV9WE/Cv4gSXlTU1TUoXVUEDsJe7y6T7zxqxaxnKJNQZ76FcpdPUg52sULwfPM+g7LRaSp8l77SsiLFC7baYSv+0I6VcttO6fNDkQ9E9eS4/A6NiUzGFbgF1KEJ0gWv0foF6mOrFsGXInUOvMoOUIL3UcVr2zTmrK6B52Lr3reoAcJo9KS0SgnIaGYv3DLZlmvEE+P6gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wHiB5JTsZOrMDGpoj8qySC6bdboKgRserfmvAqii6Fs=;
 b=Uew5W9uTv6eQCzFyCJVXNmRURv3UjCQee2ajdN3hTabwH7KVGgE61ozzTaxwYRcTKVSTCUw0iuocwNytXj6KazxOsuQipOeaFu0LuhGW7+4vOSge43NBm8Q2SkbrvQK6sldem5YTt8b3UITDEBqQAZWFPlEbu9ha+SHiKpu3Z0ebbgahu+iudQDOeG3O5q4sBpxyTVd/NdC358b9uI9W5ymL7Z4MCkhy0QUYDTKYgqbEjMt7OCx9spukGXFHaPSc5QumW10VKTdMSaalTifSDPLYKNodtdrN309tx3Ff3leo1w6nYj8bD1Haw9ioFEHSM0UydifW2I8n9srf32pJOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wHiB5JTsZOrMDGpoj8qySC6bdboKgRserfmvAqii6Fs=;
 b=Are976PE7ucn9Q3lQk2rFY80j9T2vr6Yh+bX8w2ZKPeOdR3SjdChPCu/n9QTcP1rSLsZlUvwUH5DqdMpRa/fcyGtDY332WiaJLJQfTu846hDVgIktp1Yi91rg6z7lpnABWdp50CigNbPFhCJUTDyRDceaA9xLMsnILxePbw/NKmoNhvRdmr5zB6MsTDeuNNdawiktlF/BXF1G0qDw7db9uyzvKVy/edvGFh9MsRDKrFkPZqK0Okt06d7ArJKON9J/YzVEKz86X1/qlN0m/4cb5Soy8oiSr2n4PD88v/DNuz/txsKGsIWI7/rFIx2dBWlsbD7FmfNoXq8fl8C1Ap4Qw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by PH8PR12MB7375.namprd12.prod.outlook.com
 (2603:10b6:510:215::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 13:53:23 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 13:53:23 +0000
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
Subject: [PATCH 10/16] efi: Add a __efi_data_handoff section annotation
Date: Thu, 24 Sep 2026 10:53:13 -0300
Message-ID: <10-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
In-Reply-To: <0-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0070.namprd07.prod.outlook.com
 (2603:10b6:510:f::15) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|PH8PR12MB7375:EE_
X-MS-Office365-Filtering-Correlation-Id: b0639905-542f-4fea-dadf-08df1a43323d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|921020|11063799006|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	LhRgJUymon5d4PJEQsvDrn1zYAtch0X7YOe+ogONWPWWeEDjj0TZZjUJs6l+Cw9FN6T0/jnJRdY5RiZ/DUIKJMyRkn9k09ncGRPuP1vUPt//HaAX0w/H3MFidsnrUhpb4YZOGYeS17uRYUt6dmirUlNPnOXzU501w7zykUA2U6jPEfsJOVOzMXUpEov+Re34c2DRpfm0Rr3BxkA/MeKF5TTBabU68TRCjHssWCWYnZA3g48xrupduXZqgpPCyhJI5RFdB8/I0hQbc0dc7a+INQVwW6oWoVTbYlq76Fdgs58klhKYVV4u3nd4AHQYckkc/pR4vPT/skN7wQCVlWkEA/LLUurG3YfjEHGA8qPjOwsYz9vQDIoECw7tP7nowfLHcbzRYeNdWnttYp7+WhGEMv5eU+sS1C+xtNvoDfj/74dHZM431ip/DWlWw1hbWvw4AKtKf5j8l7NW7Mk/T1uiP+gR7EwkDrpAjnTRdHdMeA4QWmDuUE8lUiPBBLKRFo6Jijnl7Ho8lLyLhGUoeWhSxyRv83jcknURzx9KtDDsIyNHuYGSMP98wDORwsBcFX1mf8SJlIBPSS6LtXCnkVoooEbZR2F/Q8P1jVIVhjKYTXfGiAfiNCiMhsNGVs3ovMQ1IqMgJwbpIqT/7u9HgbWR61GC15UN/ESlgcZ5rVK3YZOEYt1WcODDpmS3pCDnsrIVLmAf1o348TzDsgNQJMLHZg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(921020)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jTCwh/DUApZYHOHylrkW7WT/e9fJn3OjYIw3pDpkgeWmNtne37FNPwmICXkZ?=
 =?us-ascii?Q?9v0HmaXo5pgCz5SNMwbXeRB3yXEOGzMIbVIJNIVFhN1x8t5OZW9HAmHxWOQX?=
 =?us-ascii?Q?grtFWbnE0EVTKhgJxmu49T3AYJyyqag6qkfflv8h6TnJ9F43OWZLYMrCe7aU?=
 =?us-ascii?Q?qg75xPd/gnCVP43j9iDXAvzSl6EF1AVSa/Xh+ZJI9XPOdDP/9UI73QBRh1JO?=
 =?us-ascii?Q?lemG/jN7nmBKJoEaaEYB6k2Y+bUXLqVMPJUbTiqzzZ8gTnS5CumaKIaCEms1?=
 =?us-ascii?Q?L8EMcCX53Kbg0NnB92bb67C+CHLDyGXPlLDzw08lzlGnGvalLXvQSNzKOZP5?=
 =?us-ascii?Q?NJD3TRhXBBd1utC9zS0Ydu6q1b3Tz/VbAK4M+1tmkO7hAJymMaQtWaCh3MYp?=
 =?us-ascii?Q?WBaVols2ZyQGsXXyYXpbfHFZwqxRCvn/nThnYjMpGHrDghIMtbYscNtA5cad?=
 =?us-ascii?Q?XEVRhojJe+8nX3t/6mhIvgu2cjnjATYtfDw3xZjdVaRXPvZ7Ia70FRCi/KFR?=
 =?us-ascii?Q?bALkNAHaojOBw2lDwKMWFUJB4f4dxbN1AhfGLtE1lV2hBHntN15pm0jzcAxR?=
 =?us-ascii?Q?SDZVnhL2fFHKETSESzCpniJWbzjE6VbZbqSfuTtqs6yVxz2FAg8bmiNpR7KO?=
 =?us-ascii?Q?j0lDin/FGQtuRo8Fw+1ARSKuj2b31hW0oPWVJ4+ysxiaQN5abG2RX31nlJRg?=
 =?us-ascii?Q?liajcR+9ik0sB7+2ypF7enK5K+NXopPXNe2pjJqr7f+HJzWiErKdiUmtaFjM?=
 =?us-ascii?Q?XkFBCYPl1QkCSjYyimPcvHtpXBKSpFnrGV34C31tpI/gXbgbUouG6BnYKwE+?=
 =?us-ascii?Q?5PVtHKkL34eNFY9iZnuxretdDhaboaUwi/lsG0P9RtDRC6o9vr7OnZe9Hcsk?=
 =?us-ascii?Q?bIdX2tyrp4QJoS+TDdo9AiT7z2igXFbGIuiehbpo0/qkxHHnFcB4YBwNRao1?=
 =?us-ascii?Q?7YcDBY1QNFvRS5x/bgPbd3mtc8aLUAk8iW4ZJ+Dh+1clzYG4+k6Ghq7oawpL?=
 =?us-ascii?Q?YD3gzAZyQA8WgkiIPwIjhnpCwv8HNOsPBDnTpIY+3Wl4guofu6Iehg26Qrdr?=
 =?us-ascii?Q?34L+4EYqwl8Jaf0dh9wLpWO7FjRqDmicDrJhDmMvn6Xa7hxjdCID/KfULRh7?=
 =?us-ascii?Q?u17vbf8BYZSvTnkh3eYONiV7tF6ktVn5sYopEi4OFGf7tcoE8zPQ00qInKfi?=
 =?us-ascii?Q?ZJHds8pMb1HhDFFwvNm9zJ+mFeqCbDkfy8IIQlIP0TIuqAQ60dTdFSkugsDP?=
 =?us-ascii?Q?uyhC3ptfAvQ584k5QZfhjNuxP9P5+XX04FXKInLLHJLQ2ybt26OU4+rNWIhv?=
 =?us-ascii?Q?AVY4dfuxziCBnpPzLVEDpOeisQPmVSp8/iFLmn0ya2/h0FX0XjqKfAnBBGR9?=
 =?us-ascii?Q?xp0sDsgOx9B/p93gQnnAtf59d6KUc+CvZ01ECVAzOr/ERF/jkQtQ3uIT/hb3?=
 =?us-ascii?Q?h2KUGEna59ugkcTDQpy4TqUCbKOCdEhPd/SgjRgOf/E5M1iDiNlKG9z1Xvv6?=
 =?us-ascii?Q?qoF06Vj8fl7XRmxFJfq7pXQw1xBo28wsWKZW4dGMOX5p19QSABLt8vX4aD6x?=
 =?us-ascii?Q?ufS4mDjDlMjsKoKdGNKMRDWCcR/BK662DtYFDH/A+rOJeJmiXpc/q2dfkCAH?=
 =?us-ascii?Q?Iu6G+vAQFvtk5wDX6CRAphonnN2uBymVEhm6PhK8niHJKQPEjE3NuCmc/UTA?=
 =?us-ascii?Q?aQFLITZfV4IuCDquEP61g3+eOaLmfDXyOVPUMkwg0ovAWr0C?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0639905-542f-4fea-dadf-08df1a43323d
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 13:53:21.8751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HOlDMV3MYikeN2mBmOLIPTpzdhRDJ409NfdpiRRslK/JKNEf/omvCbJJMATxzLI4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7375

For a clean DRTM measurement, data written by the stub in the image must
not fall within the measured range. __efi_data_handoff can be used to mark
this data so it is placed outside the measured .data or .init.data
section, and also ensure it is force allocated and not part of .bss.

For DRTM data marked this way will need eventual hardening when the kernel
consumes it. For example sysfb_primary_display eventually leads to a blind
ioremap. Later series will look at hardening these flows.

The arch-agnostic sysfb_primary_display is the first user. The embedded
stub writes it.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/firmware/efi/efi-init.c |  2 +-
 include/linux/efi.h             | 12 ++++++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/efi-init.c b/drivers/firmware/efi/efi-init.c
index 6103b1a082d247..b00c4c03ca810a 100644
--- a/drivers/firmware/efi/efi-init.c
+++ b/drivers/firmware/efi/efi-init.c
@@ -61,7 +61,7 @@ extern __weak const efi_config_table_type_t efi_arch_tables[];
  * it even without EFI, everything else can get them from here.
  */
 #if !defined(CONFIG_X86) && (defined(CONFIG_SYSFB) || defined(CONFIG_EFI_EARLYCON) || defined(CONFIG_FIRMWARE_EDID))
-struct sysfb_display_info sysfb_primary_display __section(".data");
+struct sysfb_display_info sysfb_primary_display __efi_data_handoff;
 EXPORT_SYMBOL_GPL(sysfb_primary_display);
 #endif
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index aa15ff88539bdf..a77bb604b1d1fd 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -29,6 +29,18 @@
 
 struct screen_info;
 
+/*
+ * Data the stub wants to pass to the kernel must not land in .bss so it doesn't
+ * get zero'd during early boot, and when DRTM is enabled must not land in the
+ * measured sections. The offset of such data can be passed to both EFI stubs
+ * using a mechanism like struct efi_image_info.
+ */
+#ifdef CONFIG_EFI_STUB_DRTM
+#define __efi_data_handoff	__section(".unmeasured.data")
+#else
+#define __efi_data_handoff	__section(".data")
+#endif
+
 #define EFI_SUCCESS		0
 #define EFI_LOAD_ERROR		( 1 | (1UL << (BITS_PER_LONG-1)))
 #define EFI_INVALID_PARAMETER	( 2 | (1UL << (BITS_PER_LONG-1)))
-- 
2.43.0

