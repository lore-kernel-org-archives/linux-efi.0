Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010028.outbound.protection.outlook.com [52.101.201.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969C5368D76;
	Fri,  2 Oct 2026 23:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790983937; cv=fail; b=VBZvdBs4YplnLzWfncIF+hkrsHyQzQaW0c0HukUD7SniPyLh150xx8Mso+jcOv2X82A0wrI4dDepebFK8fBNUnfnJWbE8E07yoX+Rjb51PrgHGwL8cYft2EAU9rWPF1HJKEIHpQwu3B2a2PXRo7Ppp5zdJCZlNPNNb0GU+SkgfU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790983937; c=relaxed/simple;
	bh=W0fKD4gKZRcfGK8wzo/cl8UfaqWOG734nKuD4mXZULo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ere9JCTAV2F3c2xRsdzpjoCVtHaqwANxqoA1ISYUjnA/AHQRsO12Kn+YvqRc9EMU1uYffAe7S6hfifpoQgxUbj1jDqH8e/bFSWl4c/V61jEShFdANATIgUy8OqYb/9/FlWJqocAdm+RtdWiljNJqhLAb17xW75Z1mUb4svlEmiQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rlZid2bL; arc=fail smtp.client-ip=52.101.201.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rlZid2bL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FGtG5/pcl0MWtkxhSlFdHWHdw5eAeCnJ/p5m7lCloOc5EXD7ASUrNrZKcEk02g2N6hXcBGoBjkCdtrCl3s5xRYKD+dTJ7MajzQWVKo4r3Jtv8a8yJsTAOMRMKWTBg6xFcsIWsqzj9xHhyJKO+qqhOJpIajGWDPN0nujFrNoHoefkyFLnyyiX5ek/UZAZ/RsxsAmbT1kUzyOWjmYB/FNRp51A3BBgGHq3fwrJeIRc01WeRTlIqJN0J2EfzC4JZRnCS6DJqbWswkvxr8oCRQrfATui51AZvAGBo3r/ht9WB/YlMxrmJOIMgdKGgFDTqItrIPiOR5gFRdFR9WTxRS4UaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wHiB5JTsZOrMDGpoj8qySC6bdboKgRserfmvAqii6Fs=;
 b=hImiwEaPXWZsCrrW1/XdWsGwsqllveAh7tE9SRNFP7Sbo69vHdpBk1KkOTO/98ssBhu9L+JUUeUjPeoax9J6D5HT+vlfZaTgOQzxHT3B9OAzjQfXyeEnSDSBH/+rrQVO4943nJ+ScvWhgA8pzjijDjxxOzOpCEMbdhgsGQkxFbvYGUB8Q2bKoyGN5tm8EzXCQp21AhkW59nOVSH7M+lyMJatpGAx0sUr7DepIVlXHic29P0JSD82ukMAgcxxSsBHo2WS5Ldl9ZGl9WCJDelor3KDw5n34C1VBid/4cySf3B8iW8yfmimShS4Bte2SoxW86bi8FrmuxGZUuUKxaolBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wHiB5JTsZOrMDGpoj8qySC6bdboKgRserfmvAqii6Fs=;
 b=rlZid2bLGlPd++aeU71BzZJy67vQA60BA84FdlzGDPoFfITHKsDKbbKzpc4XjBtKgJ2yLO/P0OqTXITfHf0gVQQoDFfU3JX6HZFWWk8VYBkV88dAaDR1QzDw+ocFsKEE59VK0WsaFYtxKdNbv+hnxgPUUqLYtdOb96JKLmn2xFWdJwAl1A021od5JSZ1LBXNUOIDn9P5Gpm8eDAkoSPJu4qxrV7j2FEcrRuFbPrAW+hLsExz7RZhuKsId+kStuWhj2k50nCh1kgwRR5U1vru1caKUFAkcvbWRMsrlkEbx2Hc0QaNxuulAT78cnIYlB3PLvPgw7630XV3RJTmEhMZqw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14) by PH7PR12MB5830.namprd12.prod.outlook.com
 (2603:10b6:510:1d5::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Fri, 2 Oct
 2026 23:32:07 +0000
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5]) by LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5%5]) with mapi id 15.21.0472.016; Fri, 2 Oct 2026
 23:32:07 +0000
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
Subject: [PATCH v2 09/15] efi: Add a __efi_data_handoff section annotation
Date: Fri,  2 Oct 2026 20:31:46 -0300
Message-ID: <9-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
In-Reply-To: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR21CA0014.namprd21.prod.outlook.com
 (2603:10b6:510:2ce::28) To LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LY0PR12MB325698:EE_|PH7PR12MB5830:EE_
X-MS-Office365-Filtering-Correlation-Id: 65d2e129-cc16-4065-bf03-08df20dd5961
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|1800799024|23010399003|376014|10067099003|11063799006|921020|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	2xdHxD6GsRYbOEKtkqUgIOuvIH14LuTiw8y3RobVs8fqtcyZdytU/OqzDOq8ngC77moOdUoH5b7Jed+fxNeWdqtNodUit/iZhuMn7v8WbCTN1huxoQMa6E2w0s8X4AF4qVB0cKw6oA7IqV3HGn50B2JRiBm+uYCwbmERAKsytrJndmeu/O8KpIdOXUHNd5+LEBujkv6ayjvZ2ceMn6fCwCr/XKMo1aMbicVq/Ch3acr7j2KI0Cfs4pPu5kalta6tG+KqKUQjNhd4PGDOK6SPRn3+FkRGffhmb4Gon4zh2GUVp/rDOk8nIgO1rhke/00PvThwguSz7ghVYDtI4SgubsfJDOr9DSfNndD1IxswHgC6uDKLs0zY49rjUmCb+q44aOztrDTyWrSosP1v4ly0AMTAxziXxmd2EpZF2095JLzU3+bbEBQrrikl2+veE0zf7eT3rLxUOTQpKBj08Y0Y330FTVdu5MnF+QpmqH2QlsW2YIS1XkY9xn3nRay5z9Fyw4ugKRxmIcvOLd9G+IKc1NKsfDUnjX0COqcMUz3DfyQZnqQINfcJdbL2yFnERwIb2BEoYhLuwIUwyNvEa0+ba/DmMRAN4FD671ixt4XE/rEWZuH2WN73g280n+Gh1Sggo7kcnbwr7roOAVWFdNGo5fAjFeKH+kT4NsUHq5UODxURrbz3skIO8IIGWjiT2YtPLZg57qNnV+0LmsT3Lf0Ptg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LY0PR12MB325698.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(23010399003)(376014)(10067099003)(11063799006)(921020)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BC8s+dta1pOKMabpUQePIxPd8rIawQRrEyruSXrG7l0x5qtjuZtY2B5fF/ks?=
 =?us-ascii?Q?ggoGSX3noRcdF+KRHhs33hgdofZx1G/0Ou2TWD9X6tY3ckQYMzwhQ/lvmOEG?=
 =?us-ascii?Q?12ycSFi3Acur4SFRcCQ75BaDRI0CYCAqdW4Fap1Gx6k2C0vm9dN45qLBhbCq?=
 =?us-ascii?Q?3yHzdrqCxttDjRRE7CbNMIVOGCdACQowWEqygU1H8Fj8UC3Ktaa7gUg52Aog?=
 =?us-ascii?Q?YfzUTtrF9d4T6DhJmpttLSrKetKXa9MiNrI5tgXwkUFgBoo59Nai19epLeRu?=
 =?us-ascii?Q?WvjW7vr8MJFt3/ve1iaGae8sDcAQDUeHOqkPLSZwA6agbFlqFMEkO0upHq4i?=
 =?us-ascii?Q?sPxmM/RSq6vEB4gSOR2+XKT+K7/MmWiQa6cuiC1fRh7d48NS4dd7JjPSX2vs?=
 =?us-ascii?Q?gaalFSSf1kP4osjvUOtyppbj3v3vr4D7OjhIC/khnndNG1xMXCp9CI5mOdvu?=
 =?us-ascii?Q?fpRs0M/JWVWHfj0XuFinDaLD0erkH2w2OU7Q5F1k+dUFRYdNHPN9PaNk/nuh?=
 =?us-ascii?Q?jwgID/SG7pY8FsqH8Yqv1jLuOp+IiC+wr/m5ojSViBbmzoS3e5QO5Zqq5pY8?=
 =?us-ascii?Q?BT/NYWg4OyxQAX6qQpSUjV50Ms6tJr9yF3fduVEYrj58PegOS77j77ZnHRPu?=
 =?us-ascii?Q?KS9Xopuxv5fPuU6+xLUag8IOi2HE2kTovUZ+2tsCyGVU3dkYdmeMqMBsNd4e?=
 =?us-ascii?Q?tWuZyEpRcjZjttphdgzoFTwoaj+vaeApO0xK6CqRi+od+d+4d+HOUClk+w2R?=
 =?us-ascii?Q?tKIApbxzsxx9kE/43BD1FNHro+bNt8kkiMt9KWUCaU5+FkTKT0XlaH83MTcH?=
 =?us-ascii?Q?6fnR8Ht4Gxh5wAG1POSRlNr0HFQbOb4BtqSxJliXL4yT53si+M9mM3ghWzk1?=
 =?us-ascii?Q?8E0BUy0q7Wx3Bi+MBMpkbRSNDrpYBVVLhMf0AUdOeO7FxSUjVpfy7YSAV+Jf?=
 =?us-ascii?Q?Ffo6sJxWhJOmNh4x9qmyElPMlW6oyRsA8G8uePj0G5WQCtx6QUCCGtuqMsfl?=
 =?us-ascii?Q?73SGXoCcgNcfow5eulxH7Yo9E6g5y83/2k9LBU4dHRWndX9VxV51g+eSPW93?=
 =?us-ascii?Q?9Jy989cRmW4rTAIqa2MwXZzLj2W+xJW5QrQD/ppBV4QHbzlsI8Ewhv7iBuYg?=
 =?us-ascii?Q?yp1NRKgA5P1LUhGmIdkiaUKrgu0LbOsB3/SKYBX3f+FYcpmttpn9WlOQss5D?=
 =?us-ascii?Q?GwX86jn7Vjqy+nTzYlSfFYAARlgq9/m9/f8JkBmy/6hu2kq81FDEnJTk+W3O?=
 =?us-ascii?Q?d5nLzrEOAr89ltWSqOxHrm2uKnJx7Q8K0Lw2G6kPZ8/+gpuoINjUuefnHeC1?=
 =?us-ascii?Q?vfFUXbJz+30Jko2h720xCj+A7Nwha/9Aa5sg9ujvGvEu4cobdUe7ahVJiyOn?=
 =?us-ascii?Q?T4gx0dj9JHlu2DvqgCtv//dzalm5pWITzNn7ZTgJCSWc1iJJ1Jm6W6IVG6G5?=
 =?us-ascii?Q?POwOy4EqOFyLDdN64NXgDlNWEHNaVRqs1dYicVBts9GPy1dnt8TnDblMRu9v?=
 =?us-ascii?Q?4rhig9kxhMn7gafTNsi0kOsJMylcVjNG8w7C+7oJtTFtm+1zpOsx2ljS3PkN?=
 =?us-ascii?Q?hkpSthVyf2GGeWHSN/J1cOIZeAOYQpLWH+wic7PyNLnSaLgv8d2i53Zpt6T5?=
 =?us-ascii?Q?mt/luhqQia2/ktmCJGPt1vBR2mjEo3i3xudyAJLwNAFGW/av37ys2al25Nc4?=
 =?us-ascii?Q?xFovQN0qmW5w1P3J24vUCGIxm7AAnDOU7iN+raOGOsQMuhys?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65d2e129-cc16-4065-bf03-08df20dd5961
X-MS-Exchange-CrossTenant-AuthSource: LY0PR12MB325698.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2026 23:31:57.0438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2nqV7mkfPEeIigwowzLhH2aIe/PwsXaIWNRZDbIOEV2eQQJLWEicXTRYxSGHpWn2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5830

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

