Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010063.outbound.protection.outlook.com [52.101.46.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97971357CE0;
	Fri,  2 Oct 2026 23:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790983920; cv=fail; b=smWYj5Nl5KFXtjyquas2q1qp5vP1FFXxS0mSywu0ULaK9RtXCLhp5JFzIaaP+4BVbm+FDZqFUZJkq39IpoVzXsWP9jX/row0i0EB/241b/gp9TaZonXAEgK3gPgb+06hm0meZ1zdclaj473FYCIUpmzNHJ2iaknlbuZDNUfpC74=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790983920; c=relaxed/simple;
	bh=YImPRUdhkupZy+/b8P6+YDG2XmrXK1Beph0y3TP8jas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TuL4dH2EbebueKfEBVBNijiMXxeFiw2xW8iR6gRi5r3bJSik8MmH0BZ88w1NSFrR2i/6BZjk0YOd73c2BuaXvb1bYUr3XFq7Cxe1Ufxunvz8yW3Rovib5iqGgEZ5/BKSjLflrAwDDjBjnCFdpmemS6d5cPUgBAmBsQg4URK8sqs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EvFFd4Gz; arc=fail smtp.client-ip=52.101.46.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EvFFd4Gz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hhgFqUPK+i2ep6HOiMdLPWdHidf5MCZ3c5aqQ6DdKc9+fQtmzhp+8999hfMCOrFAfO+jv+3IwDNPQBMQXxlJustRc4PAewGeHqu1F0rR9rJLFJAfpPyyEqMGlO+LvMvkZyYeyqtfCGLTiBL6c8DjLSX0W9AYzcn8HgHir03326emIVzkdMQHZfjX9wvQKWkPpquSIiz1vGN7A6yqb7uTCgWiFsDrnPRP8HYS9WLOwCndOEQEkbfMCDVhASNHTTfkeQjf++p3m/bkNVBia90OdycZWU+wPuEj8zvXy4Ve2nFY106BgbXhnW5IPHR7+pSr8a1Ar2IFkd1iNayf0BwYMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4wyNxMLNGhlEsio0XGhr6I7R5duSJRbIEQiNOHeb5tg=;
 b=HmQW/NAcSUYfMOPzgAfC9kPujhs7Y5wX1dXNX6v36YOgY8RGiArp4hqWEYna13XS2pPe5EYCB2ze+yjM8bqRJBO+OA+hhYiuUpvCdxpcYwtuVbFvK89zW27ytkIcMO5sWyu7+tBuZV4jteq9PXx2t7dNQ5AOoBeEEuO4CUO1XoCauO2ZS5WjJSMNssq5CqDwfmdpYJA+8DUUUCHUL31QIE5KtNFcVvQBeEBUGpQiRFrJEr/VyO8dcaiTQSpCOxwcZHIgfCAw4Xu6GydFUZ3gMawyAnNITCak8szzayW3IqS1K4J4gxDmNS80uUCnGks0a/37MGHxk8zrD/s8B6UaMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4wyNxMLNGhlEsio0XGhr6I7R5duSJRbIEQiNOHeb5tg=;
 b=EvFFd4GzgRMYJ5uRfHV+Z0A6gS8CVX+hbntxDtkVTCTaoajMVqf3/wFER1H11UPTXB2TeqBkwTPmMgaLplGEKzWpxZCvdWa4SyhlMYE1I9BbqTrIG4MYyzhI5ZcvsWRC0ysc1kN9ZgxTopqosHpEG47JD/6FUG6HPQKn/1DLcZ7ln1+JgSvTtxFAIqzG/g9Ro/Jcavu4GcMLWkBbL/qKRnqppTR6jBbcA+yR6Pk5XQqSQWZtTgETzLdmbjG15UW6qnJDgUTsFN8jQeLGbc4ICsWVJgkfRCKx605e53OH7UX/nn08eGZqO5t6cIXRjKqUlZlrUPTYcGsbfjGEtQYZ9g==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14) by PH7PR12MB5830.namprd12.prod.outlook.com
 (2603:10b6:510:1d5::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Fri, 2 Oct
 2026 23:31:54 +0000
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5]) by LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5%5]) with mapi id 15.21.0472.016; Fri, 2 Oct 2026
 23:31:54 +0000
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
Subject: [PATCH v2 06/15] efi/zboot: Lift efi_cache_sync_image() from efi_zboot_decompress()
Date: Fri,  2 Oct 2026 20:31:43 -0300
Message-ID: <6-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
In-Reply-To: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR10CA0019.namprd10.prod.outlook.com
 (2603:10b6:510:23d::27) To LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LY0PR12MB325698:EE_|PH7PR12MB5830:EE_
X-MS-Office365-Filtering-Correlation-Id: 3cb9eca9-a8ef-42e6-7b3b-08df20dd57de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|1800799024|23010399003|376014|10067099003|11063799006|921020|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	g88JC/egnz33uWKhAqqoHu7bNjW7tq1xwq2ba9gjL5xdXTKqGcxkL0+ueDJXw7Py/RW0Z5p7Fw0HnPExnrAuI1XZpkA3aSKcYwaKZMEieYBDO2mo5DCyQMpUwozmxDg+1xq46kVwDO7UkTwDPX6zbQtb7Qwuasmf0ZTBnuoxWTtyNMHayNpD3+A3iUC9od/S5AzVEx/wZgXV9WYpVW+9x1p+bQo3JKWxNHoiL6RTIMdFDvgJxeYqHdDjZMAdwgWUBQyC5wqz6jmWDb/UBA97dL1hphctayCeBIL/6PQsLgCLD0UbO5AYrW5iTYnLRTdcHGtmY6BI6bzPOVRdl4VNL/L19sZrdanBC5SfcRS9G7njeBcnSSnAalkc/3ob+LVjFGEBA6Y5Vt/HMcAd7GKG6Av34zcsL1eu1sKr+bI1kHXqigGsrSsBYcacUkzoXbOSeeDxVryywCRepkXJT9K3DlBz2L8F2084KHDCWcDGHgcRiLetEbXLv+gTupGBUtd6pDpKcqPq+fYRsXqv9/vHfZnlbluVPVG33XrtvOqMS6kPIy3sZmbWFDG7ZBKyTfuFiL2oS6AKno89TOOL6Or0Pa9fQgHZQeo4wTqATRfzEQ64UlXDaiYdhT5Qx2GN7nrm2oSXsEscbANO4GLUzxeuAMsC+A7BSAQuWaQWmLp8UZdZPpXvRquewKSML2f3egL7HLat1o8qQrFTxhyeK7C0rg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LY0PR12MB325698.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(23010399003)(376014)(10067099003)(11063799006)(921020)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/3IZHjZ0k4zPvMrwWtL/nMx6mVbjFyV5uA1nLDF3kg3XDhe23j854bcUz+Ma?=
 =?us-ascii?Q?J6wY94V1Qg7JjZqe9w8Tw8sKeqevhrXky2u1FMsrqtkzaS3iekrYgKu7Xk8A?=
 =?us-ascii?Q?xEm+gxB+Uslofn/o+vMwUokuwiSAIVmPPS3nCt5xJx4chAGZdARWbdmscBNf?=
 =?us-ascii?Q?9Gz77oD4bVp69aR23J8yG4gvOExSUNtGSyNr2mrDuxpnceb3eRPYZyrvsFM+?=
 =?us-ascii?Q?jpelYMhCL4XSGh3qNkACHzRdEL+j9fEuutqsc/CB99sDdhytcHN2P7wOjdLJ?=
 =?us-ascii?Q?4Soym8L5cNFTNTJPpQrhO5QhKy6N8FpbZsRmCrpYtVO2qgS2jzbptvh8A4S9?=
 =?us-ascii?Q?wgxWbR2BU8r4NChYBhiWyXW976ft0bu7fkcu8OPRVG+4kYRyaAWvniUc2koj?=
 =?us-ascii?Q?fKM50dv+Rp6ZR+B7lualHXM/T4XZKyQW4T39NI7NicEweK6F/fnq2tDophDC?=
 =?us-ascii?Q?AQb0RicYZCYVM7efmp3cDzBxrn55cCbeYJO8KbXT2xI4WFmeOaHGa6wvVclN?=
 =?us-ascii?Q?cCznUUd+AhGg1WcyL0TmSoxd/szSbXhReYSQU7Jb/viskAOMHn0e671NtiXP?=
 =?us-ascii?Q?6c77eTsVW0zfbb+C5zu7jibl+PByECdF+DF7R8n6tHHAGS7RTOMXAo0tcUEh?=
 =?us-ascii?Q?hCxVp8oPl7S988yciMlJf/ZqFZRT1pvkxk8+gjhdGlpymknK3QIGiKD9OV8W?=
 =?us-ascii?Q?6bA9wv4Wmm7WzV/VOW1W9cHbpIc+yTf5xBLrJPn1FK3F+zONZboWzilGDWa5?=
 =?us-ascii?Q?VfFvdgSxJZsKW2WlisM03+AgBb36a09D209lM1BXHHPeUBKB37w9hwQWyTz+?=
 =?us-ascii?Q?5MP7YkdqFfh6WLVmQjhoXejzGOC7dn7iNaOeghYHV94N69I2TrI+A6GCaYJM?=
 =?us-ascii?Q?XVo3woRoE+op2Uqfo6Ux5snq19uebybCaEG+j9JtksWGF/ujUjyc491CADgA?=
 =?us-ascii?Q?RzRl3o0z0cXBdHXfFEjOWEol8AQHXV8N5RzApwpngZ95BOSFb5+gQHopVTN3?=
 =?us-ascii?Q?8KtChWrk7Zg8NsGl7KJMhicC2J8JtSxwqoR8BukrA0shhf/e+W0wN6E4lv8a?=
 =?us-ascii?Q?kt1bg8n6cFCv+LL+IhHFP++8uXQEZ1DEmHj9fswvfxl4cuWUVxd5XOAT9qUo?=
 =?us-ascii?Q?AiPLqnn34sauIQpWpkGbzVmjUJhOeDnFne/6Aqf5znOJGeA4HsD1di1S5O9h?=
 =?us-ascii?Q?bfP0mh8/A25QpwJONjr2T7mOuYNaK272VYVCWLSVDBWSupliZxGuTadm8pnU?=
 =?us-ascii?Q?/lrMtykIMHqeq/wK2quJJh0FfsOJ/+2ISQJNCVzhL7JlyaCZJ+F983HooR5R?=
 =?us-ascii?Q?M05CpfmtSqmcW+9pjrAsML54chGkORUmZpZcF892uthWd8EVUZBFyiVbbB+Z?=
 =?us-ascii?Q?vQf5090Gcw5noaMKdgeAOeX/uDKCPKj6xMud1iB3C67L8FEe9IeMA8nWN6r0?=
 =?us-ascii?Q?1YtOy1X8Lt/WzKvX/8WHh62IywpZfFc7bYD3UHhYeZx8IaAvGpvPD3bpbJzk?=
 =?us-ascii?Q?JzU0pN3oZ7k9e/jd8uGfm+Oqg6p86pVujql4kq8d3Dbp+TVu8ebg7OBF52lB?=
 =?us-ascii?Q?uLMRJ3vazeSCzGBybZshaWHwZKcbLCWHiTLZsK7b/XRUYymOEiu5M/l7n29R?=
 =?us-ascii?Q?xUPng6Z3l2uKhPC9O6e28Eeuto5wqjuorOIJBXsbsmetW1XQRnxluj5Feq7N?=
 =?us-ascii?Q?eRblww9kol7hMOgtXWqQVGZc/p6XLMZe6B1IJ4V13JkpDHfg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cb9eca9-a8ef-42e6-7b3b-08df20dd57de
X-MS-Exchange-CrossTenant-AuthSource: LY0PR12MB325698.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2026 23:31:54.5286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sYY5s94ELf157e/j3Z/pPZsH32S+WfzTwNBZYFzuYrY6gzh8FUJxxQLFZHpqcshe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5830

The two decompressors duplicate this call and the next patch needs to
change the argument. Hoist it up to remove the duplication.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/firmware/efi/libstub/zboot-decompress-gzip.c | 2 --
 drivers/firmware/efi/libstub/zboot-decompress-zstd.c | 2 --
 drivers/firmware/efi/libstub/zboot.c                 | 8 +++++---
 3 files changed, 5 insertions(+), 7 deletions(-)

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
index 4b76f74c56dae0..e3abaa05fc4183 100644
--- a/drivers/firmware/efi/libstub/zboot.c
+++ b/drivers/firmware/efi/libstub/zboot.c
@@ -92,9 +92,11 @@ efi_zboot_entry(efi_handle_t handle, efi_system_table_t *systab)
 	}
 
 	// Decompress the payload into the newly allocated buffer
-	status = efi_zboot_decompress((void *)image_base, alloc_size) ?:
-	         efi_stub_common(handle, image, image_base, cmdline_ptr);
-
+	status = efi_zboot_decompress((void *)image_base, alloc_size);
+	if (status == EFI_SUCCESS) {
+		efi_cache_sync_image(image_base, alloc_size);
+		status = efi_stub_common(handle, image, image_base, cmdline_ptr);
+	}
 	efi_free(alloc_size, image_base);
 	return status;
 }
-- 
2.43.0

