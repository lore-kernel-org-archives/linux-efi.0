Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012024.outbound.protection.outlook.com [40.93.195.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141BC2DF138;
	Thu, 24 Sep 2026 13:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790258023; cv=fail; b=GackODJdXBZ4TFGr477uDhcMIkDLKwKNV2nNvX/1OuCfUD1WcVBbiIaEbKfCGFf70jUtH6Msn21ZZdV6lBqE8P5/YYxcZ0brwThw28/O+ichMmu8deaKsj1eiqihla+9UF1dlpIZo1ZB6lnD8Jt4Un2u4/Z+r3UoqoP23cFawX8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790258023; c=relaxed/simple;
	bh=eI6GIV4BZS9FXBxeN0RqStWsd+2oK+SyY3WCTN7O1Xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MPk1azLc3RcimLZ4z6A5rSMlBVDZBu5e3aG7R93J93mpB7E5lr1dPVrEBkSVfpF1r4idXJW+NpsodclRkv46TESQ88WTA7fvs1a+zCOxEDhJRIHjbkvrX4om1/2GXarahPB8lTnMpg/B74B0n7pQH8o96uR/MHHcQCa2+9HZHbY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jSBmmFGJ; arc=fail smtp.client-ip=40.93.195.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jSBmmFGJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=av5p+XLuwokyDdefwIHy9kHc6gnysZfH3ZjZQZf1OAdh8ub4bYke3r+VrTaUHFi1MHn4f7yP1lxlySF4FHCO+5S1/yonpJQTPppm7f5btn48h0hHbDg7CqOoQC8eMT74sYyx2iLL6LiDyDHdkWqTewnHDN/8H97klGK2jmJFclsRc1mVxGtXAq70g7399AQ2flCOLzPpCohq4Sx5TiQzUGJCnNXp9P/iDqMdSaSv5UFDp3gPsBzbXqItn3sZtD18kUU55T/Jx1cPTedMU3MMSGVsHukE50DCwsUISh2kMGyC/yHeM402VRDxPe4OS8ikxK1xy2tFiBA4xtWpHdMkjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+gGqu8/MQa/VZd/Iwlzt8OfZGh4jaY8NfIH8lJVXlgg=;
 b=mlHhwmUmB466w+3IZtzWyriScPHRLTRow+KVrMvEn8k3z2ih/gk855Df1ixNTyOa8HGQQ1NPWUllBATLNYruH1ndJzCROzMrADxZAa2H7QYvBSOqp2m/8VZdo6p0FMuelbsokM3rc1jn0R2Gxds60XYhBoYqgCGA0k/zuLJiZMfId573tRzUFAee1WrGzAWlaAFneyRaw5CLqBaUY9sREXC2Q3YOr8v4U1cYvBdeq0XXsEhi7/rXv+Jg4yiC2Ln7wR55HKzci7EkzU9cIeSZccEChe+4d4iGq2MHEGIp2kUdC/90f67u9LB7jAGysAjVcTYrLODnxOB8gYDTneGjPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+gGqu8/MQa/VZd/Iwlzt8OfZGh4jaY8NfIH8lJVXlgg=;
 b=jSBmmFGJE6Y2Xji2mam5TfhgQx4/4TOQPppD3nVZ/V6oUbZzynccari1WVSKSJtDVWARor/6THQnN6cuGIPgS/5v1jdFNxxBsWQlKhQ4NdbmmOdndbyy/78Vx5iCnWg2HNL+4obw7fpCY/uC50usjWFAkhX9XChnQQ0KIN9kk04XX66UONgaUGF+lPJPKcdbK+Zg7sGLrMaUDwy0/CGg5wv1jl35qiw2sXHuGTelycIazEXOvkZf21tfhYsoDYEAifQi9iH+Ha5Pmy4+pZw0EN7Vtv7JdcALVVN4jkbheM0KibDs4AvVZXibpYEMHYJwXuySAdWW0qBGNMWv3vhCDg==
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
Subject: [PATCH 07/16] efi/zboot: Lift efi_cache_sync_image() from efi_zboot_decompress()
Date: Thu, 24 Sep 2026 10:53:10 -0300
Message-ID: <7-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
In-Reply-To: <0-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR17CA0065.namprd17.prod.outlook.com
 (2603:10b6:510:325::9) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|PH8PR12MB7375:EE_
X-MS-Office365-Filtering-Correlation-Id: b1f86075-7cfc-4d49-20ad-08df1a43336d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|921020|11063799006|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	7IJgwdiLPLfXG7RW7DpSgZ0YTLk0FrQr6O4gKs9teuL2+GU83vn/BbuJZCeTjYMj3BiYmjU4PLoORhbKFMA8XeJJ5evXmisKeGqa8BV0bkXehm9npHyZjVVlOIr47DuJQoonZytXuo8wTOzKqezzOXpT0F/t9JsB8G1CVA8UhQ1URBxpf/TcOvbdtteHw0OHIxKKz6sPZOk1OvjgMnf304b7+J6EfRNOIFcrwNTWIYcg22T9SMnLoPNDg5dDRRiqcpPy4RFoTty4MDrvzY+8VUHocz+7bKup7Sqzh+j/dTsBHg8LXbDSoJ3ocJo6+yrzRb7oaL23spAAN1cx7lwoFLboqWTMPkskW0yYC8nvGKaaLHMta/MaF8ahSYMV9OYp9oLx1W+SDwFttq1Si22jf/KwHirL6Q4JFMfGzbvR4JiL9M78MqCsPQGXfxFQhM9MJdmnrsHJZPxQkcUHtqn7enFo2/B8WQ6YkbFx61sB63LdGJg9aHwf9qCMi+I5lgWxCZa0rPvcwbst2lnWk7KaksWBp9BO69YKmnYvVwVQhEZYvOKCCedDBXOO7rP26HANvCRHKqcP1KnCp2+TAgiu9ckikYciTTu7VzlU1HiyL9pe0PaugDKRJdi4na/20C5wb9TtTO1Ws1d8Cy5pTcgA+uDBxyykyWdXSQ/uz2VLxoVwhDSwy2G6Ra9cW9eu+qLB4iP5hOWCZnquc1psOjpGUA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(921020)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VNEnKX7y0QSos8WYnQgh2x4jxw5uNiedcAJyPw68NhydjUsP14RAZ7NyOLK6?=
 =?us-ascii?Q?93G3eXxZkZ1elhuossJInfwKbzks4GCkE9dUp1tJ8qT+RUX7mBhOwbg2vuiN?=
 =?us-ascii?Q?awsAghhIA0wIHiUx73Jbl5YjDZlPf/XNud/km57jDHtM4DzhM/o28AZ5XmGU?=
 =?us-ascii?Q?omLuOc1i2nMZXp0hUXxEkGwH5rBTnZosr8G3wP/9VSoqlH1vDB2VTEn7xxg6?=
 =?us-ascii?Q?QsdtIy0YlYVYBKszGkzDU9OfegWy42+nUmBLFpGZ28i3KaO10QnSwpT8h3u2?=
 =?us-ascii?Q?ysGlXaLUdtgvI1wBSrC8JanNjP7dLHoRh4UcLfBBWUxD5XfuChMZlmg7bveF?=
 =?us-ascii?Q?vCMmAS7vEYJaQSc6U491VDdlDcSRy+Z1YM5it4vjtXDfKu4L5prqg0k/sKnq?=
 =?us-ascii?Q?JgX5Cnqsxy8cR3sQJhxriybt+1qdqrUgr9uyH8TDOSixJohKZCLRQ3FgvWMT?=
 =?us-ascii?Q?rb5Kete9ZkWYfuODQ/jtAq4wAORg/n5w9O0tV9WdPKHZitEWtZ9cWP/saMJR?=
 =?us-ascii?Q?HAtfgmMfwIML7yno5ZL3/Q0NKjbhWjcIyOGVeXwrDHPzYM9SPWPwCCuGajhQ?=
 =?us-ascii?Q?DNlteDzIH6Y4fiAQQQdFinQEvag1y5SuqE1yWmKfu6oS7PSDZ8mSUX2s3SBL?=
 =?us-ascii?Q?BBRpRTPx4On6Xho3QPQjDX5wSdnKlcjmisxOzNrfnkvCakfGVIAudeiXDDQD?=
 =?us-ascii?Q?Zwpxan0mlmCuHCZTgrsNW5MFf52nwkpOutlcs80k6MBQf4AHwcEwsgauxVJp?=
 =?us-ascii?Q?gKJy0NAzKh3zrk1FbSp+qRbEjngJd0mz+YGeSAVmViFS0Jc6IcjzA3YPqk+4?=
 =?us-ascii?Q?qKlA8xazvvmF2CjrmyEA74JxJ54D3I74NJXqthvN4TmZw8HjtxAgsgRcZ5uB?=
 =?us-ascii?Q?AVNGxi2kINDYrgCnBUPCVXS2KL9gmh4s5xcoOTcxhXKeB55BZ0Lca8jPr0R5?=
 =?us-ascii?Q?Q9ZgL3RR0hkz2T4/CFueagBNsDUGplrMzFRssizL+f73cwwD9mL7KwqjRj6Z?=
 =?us-ascii?Q?K9huDVhW9HLR+fs7LpmoN2qyEMTtqtiWS3dkkuGx5/Q186w9bAAFAMvpSepC?=
 =?us-ascii?Q?bkZxp5ZHxa8uzdp/NQtEM+RaBwYBUiAUKeqXG11/40jenbtUfypJ9POQzJHc?=
 =?us-ascii?Q?3DIqCuyxJZtbRPQeEaQUnYYax4lumbaEI90ZUbfTv7qVo7Ahfn7M+gV8Szfe?=
 =?us-ascii?Q?ipWBvewFlcfcnpxSXkbyC3rNqfLWZn43Gyqz037DY0FbcUYkfqBf0ElB4Ycx?=
 =?us-ascii?Q?tGIjelrAzTDsz7EICs/30WM+VUITkLYqAuric5oA+Q1gOqBWjzNWX7bJIn+e?=
 =?us-ascii?Q?PeqoQd+47CDOgy32ZYZsamwxUxCLuKnblxn/36l7GAwexg9jGDnQ0nEPDdbv?=
 =?us-ascii?Q?jzgvcUazDbJu932zvAVHPCC+ff9dzpJZSXMyd2P/tQ9lYK+7lUUvdij0D+NP?=
 =?us-ascii?Q?dg8dhE1qGcOHrMBe1IzJl2rCa3C+azneGNf37ouE6IZxz2i6HPzhFPiyrGtF?=
 =?us-ascii?Q?HKYCQI4g1J0efiB01eGwOo2iCQiSwKzA+8/QSG7QTqB2HxWnHYKzy7hfhBNb?=
 =?us-ascii?Q?1D/2mMCFSY2YTM3KEZ11bdvIcFk4lmJEvl9RRD1v0/IAe8RHfTICoXlBXcxC?=
 =?us-ascii?Q?jqoRWwnSXCBgVjm8n0XXVglSlouEyBuZ1JLHOhXZGa+zzahk5+U1YcSTxQE6?=
 =?us-ascii?Q?CaBJsiTpN6pAmDVJ+Kx2yaM8ak/IpUmEscH57ahAmPDG/bg9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1f86075-7cfc-4d49-20ad-08df1a43336d
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 13:53:23.8522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /dREHhraWA0twXy//BWoUCYto6OV46+mxmhIk58G/s31gj7WxE6GLihr4s4+Xy2l
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7375

The two decompressors duplicate this call and the next patch needs to
change the argument. Hoist it up to remove the duplication.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/firmware/efi/libstub/zboot-decompress-gzip.c | 2 --
 drivers/firmware/efi/libstub/zboot-decompress-zstd.c | 2 --
 drivers/firmware/efi/libstub/zboot.c                 | 9 ++++++---
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/firmware/efi/libstub/zboot-decompress-gzip.c b/drivers/firmware/efi/libstub/zboot-decompress-gzip.c
index e97a7e9d3c980b..79cf8c48b03385 100644
--- a/drivers/firmware/efi/libstub/zboot-decompress-gzip.c
+++ b/drivers/firmware/efi/libstub/zboot-decompress-gzip.c
@@ -62,7 +62,5 @@ efi_status_t efi_zboot_decompress(u8 *out, unsigned long outlen)
 		return EFI_LOAD_ERROR;
 	}
 
-	efi_cache_sync_image((unsigned long)out, outlen);
-
 	return EFI_SUCCESS;
 }
diff --git a/drivers/firmware/efi/libstub/zboot-decompress-zstd.c b/drivers/firmware/efi/libstub/zboot-decompress-zstd.c
index bde9d94dd2e3ac..dd7f11238154e1 100644
--- a/drivers/firmware/efi/libstub/zboot-decompress-zstd.c
+++ b/drivers/firmware/efi/libstub/zboot-decompress-zstd.c
@@ -43,7 +43,5 @@ efi_status_t efi_zboot_decompress(u8 *out, unsigned long outlen)
 		return EFI_LOAD_ERROR;
 	}
 
-	efi_cache_sync_image((unsigned long)out, outlen);
-
 	return EFI_SUCCESS;
 }
diff --git a/drivers/firmware/efi/libstub/zboot.c b/drivers/firmware/efi/libstub/zboot.c
index 4b76f74c56dae0..960a542881d875 100644
--- a/drivers/firmware/efi/libstub/zboot.c
+++ b/drivers/firmware/efi/libstub/zboot.c
@@ -92,9 +92,12 @@ efi_zboot_entry(efi_handle_t handle, efi_system_table_t *systab)
 	}
 
 	// Decompress the payload into the newly allocated buffer
-	status = efi_zboot_decompress((void *)image_base, alloc_size) ?:
-	         efi_stub_common(handle, image, image_base, cmdline_ptr);
-
+	status = efi_zboot_decompress((void *)image_base, alloc_size);
+	if (status == EFI_SUCCESS) {
+		efi_cache_sync_image(image_base, alloc_size);
+		status =
+			efi_stub_common(handle, image, image_base, cmdline_ptr);
+	}
 	efi_free(alloc_size, image_base);
 	return status;
 }
-- 
2.43.0

