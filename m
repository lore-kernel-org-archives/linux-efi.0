Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010028.outbound.protection.outlook.com [52.101.201.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E57F2EF653;
	Fri,  2 Oct 2026 23:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790983933; cv=fail; b=UcQgtY5vaoPQwIyw6DXdKCzRB/Hvxeugv5Q2eELiBQlv4h6y+yLQI5lk8z2MLl2HdhZdq23AOMvq5oISxUctkF+fjJ89tKLI+1h5UFeHu45dcu/2MlSxHiBmxsk5azEGTbrD7ttXkVhTmYXdIZ30VeW6r/5C88X4hd/sm8zlwDU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790983933; c=relaxed/simple;
	bh=wo6JrDHTJpXTgOz3YDpnxUVRJttWafVGFTL0R2L4Dcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QYncgCCunt7VyCKEiUjBe/ZOfjRO6tL4ZB5UNw1tKgOJG+686bofwfB2okJc/NFsjzRwT4zC61PQsqB/JPH34jsj2DRJrW3HQBFjo+zNhW77j0j84OJBX8c90A64N8CctPk9EwqfxP1WjjrYecb+PfCnPY5fF3jRFy+l+LAv2bg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mtoaMljS; arc=fail smtp.client-ip=52.101.201.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mtoaMljS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZKq52/n9PGxMVD7VOwAKW0g5Dw1EgkkdDVXTCwpum3RXzEPyoUs4l4sm7a9jDdmCj/rVaDEPER/31jlcJmEXSxGiGVbL6GeHDLWOAlZBuOYcBlmMtlB1xIltyCbV+x5pJssHfq7/kGYcwu2B73p4JSy+/0tuoBoZzpCUH9o3FG3ytmjV54NfqeBdupeO21afZ5BmT2fThOMmxe7B3/t9aAKo47tnnDhqHZTL+c2ibLD/xYYREVKnrmS5O+Hdcp96tLhZMgLTfCpnPJhcBleTqHUokOTnEgzpRzYhBbAK2+wZvibZfKp/HynUxjFFoOjUa2A0PS039WlooKFcW/I7xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xlnFPy9g4TWGCPPJKKz5q9InwiSNQirWh3LTHxDo+94=;
 b=fxtKDpwhe4415L0qXw5S1V9za3SnsysHBcgg2tmeJ2WkiY5qDNna+B9z94qbEJxZudJwVqtj14xjBDl/LppP20gqeCaH64enEMfnWaev7kB1YbfFu9pPSxXSLUzb2hzNvI8bki19OmaTqx8jiIcMh0ehOyTJAU6sUNPm+VVqkGp3FGZ6RBiuBPwcuzeD4FEjgyzbg6r28GtlzYfOZ33uXQRZ2bdOhyrLwb9s458o2YBVmosqQ59Q5wuTf13rF3BGomaSokUjqpmSbfp0V5ZlWyCp4APDpAaiZjZ1Kz5ef4bL8FYgMqB3NcQx+MeXsnVlf/FjSPHl6v3pV7c9Hz9g0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xlnFPy9g4TWGCPPJKKz5q9InwiSNQirWh3LTHxDo+94=;
 b=mtoaMljSi6X8urorxMy5edTGUTFzsumZWg6i4AO3SdW7F4dBCHct/5Zj56FatOjJpMa1wP2lDEdtCDc6cBekixmBfxMJ8iZlcVI36PX0obkhkPeiCl8xnCYLWUhZ3DXZ3OSTN4ItM7tMUPEVzloEa327Gz85OybPS88th0Vk2fOta9lVyNGgHrz1tz4xJBKnbuvN1UWLM90Hfn2WzDj9PYcA8ir5CFBysNA+NpGYgZRXV19lcK6YeuEvepAO57bm/9uDn5tgBgfhMfwTiYD/mCtkt9ESzLQEciO6VvrIyVTj937G8OMdbtEB9XPQpS02u+4v9bPl6zOqVjDzfGLiHA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14) by PH7PR12MB5830.namprd12.prod.outlook.com
 (2603:10b6:510:1d5::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Fri, 2 Oct
 2026 23:31:58 +0000
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5]) by LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5%5]) with mapi id 15.21.0472.016; Fri, 2 Oct 2026
 23:31:58 +0000
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
Subject: [PATCH v2 03/15] efi/libstub: Free cmdline_ptr in efi_pe_entry
Date: Fri,  2 Oct 2026 20:31:40 -0300
Message-ID: <3-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
In-Reply-To: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0072.namprd07.prod.outlook.com
 (2603:10b6:510:f::17) To LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LY0PR12MB325698:EE_|PH7PR12MB5830:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d59f29f-4370-4205-c2d8-08df20dd5909
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|1800799024|23010399003|376014|10067099003|11063799006|921020|3023799007|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	IUoaO3KyKf5ipHPDQd+sDITvAUdvp/r1N96fhUZ+miEg9u8n6xK75y/3kauphofRdBqzdOHupZ8no3d0NWl/45lk2ZzrTWrS1q+ILOpnIVr4X5JC8/PhGt+9rjsMDQA5Lm4HTseQzeyM1XMKDB45ljcXmgUV1zmd7vwLUvxSS/IMEF1JDtUwZ3t02fvlQbXO0XJVSnI1a9sJ5niGpKngVM2zmpUK6wx6odCGJkp8buspnIot3OHpdTorLxt9vW3IuTLAFrDoCdy5R9XB+eN1rIDOF+2jpUvf+6iMX0jNNFk5/ZNN6Pk9XjixeSbYKVQuss8lSyxgJ1BcWKl8TTjSjVZ1N0crrQdn2akI9stF7/9vQNM51B7mhwKp9aVnKKkvnQkmj8U3I86VfTN2IDaeqNCeiWmyLsHpKSF2gnZ+pv/+6FMy8mp632cljXHrVb0jQI4OgA3bXRqkYpp4+A6kHyOZJM6TJhL3DL8DmsFeoXe/GyVslVKmK3wTZN+4yboMIsj5V7yCelW6NnEcdx0sSnGRb3yrSQ2hmzlb0oFj15L+kKozmVauMCtQjXaAiAJYYmQH8XLhtLR0Ct72erfKsmSSuRxegRdLogV/CU+TM8XduK/W8XLygUM0dX99vnXTMTKBK8nxdS85zk8dQXDnv1jnyG8HcFNcIg1ciGiUmoUipOTflxIFqmVfGsmY0A9b1gkxBDyQC4CGCBShCSBAEQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LY0PR12MB325698.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(23010399003)(376014)(10067099003)(11063799006)(921020)(3023799007)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Fnext3aQ46hkM11e5ySc5+ENqXE0USNPkAip237HdxMRafIsfCckSieAO4Xn?=
 =?us-ascii?Q?2g1Vj7Rm6i2A63ej53on57wGbbus8OduehdfVGEltEbAeuEPpLrzMwWYUuKW?=
 =?us-ascii?Q?wsjv9Y/Vhn9X92yY0Lp0YkacM105Ej4+D7Mgl2bqtNF1B6y8SIQnMjz50I9e?=
 =?us-ascii?Q?YTb3+s2F4jPW5w4UE0VWwkQrTOnXbL3NUjhVmMtWJ4zbdOaLYM9e7P6UCwQQ?=
 =?us-ascii?Q?wMiL8AH69drR5gl0bRi+FYz+KhcaKUUpFAS5lqtTbh3/AIKj4AfINrFm/CL9?=
 =?us-ascii?Q?5jH6DbnGmOPoni0wPW9TRVfZ1WOxS5jjuXKpdh2m/SxnSkgBrkXWmgOcePlA?=
 =?us-ascii?Q?Y+I+vJBMsUDpsENjDFR6jcKDwZBlHd2HvmwTr6PjzU7moyEmlY/SH82rviVj?=
 =?us-ascii?Q?np9ZvZ0T3Aia1HiI0N+/gQNbMwpcYXYcqRyI3XgHwHV4/SfjymtVbBiTTo2b?=
 =?us-ascii?Q?Pbb1Ai8SiwDDNR86PtW5vriv24oaeQUoCn0Mup+5Bm756sAjh9D6LctC2Cpx?=
 =?us-ascii?Q?6YZfNOyQCVnGcShwQRjItmq9ZH0yeAhuOxB12MqfCXh5Lc1iaO8L9aY4NjmT?=
 =?us-ascii?Q?IK14YNYyTjJ5UfkyqV+bs2OYnFckXi4f6j4LCnkAEdgUqZul7giE2iV30J8K?=
 =?us-ascii?Q?4uOK+vYacHDfTkmLNvDV2zCswUx7Puyiwh0Hdni/FQqJD8sJxSo6CPFU2eFb?=
 =?us-ascii?Q?V0WXuaIbQAtwTC5L6+33ZaQP3FVB6NJaPuhQ84Z7dQTVC4k12wpMgVxmkI31?=
 =?us-ascii?Q?UP/fMdBqJkKgJdMWCbLGXwugwPRH/4oOkuKj4ND2ScWOwEmkKOfPsHknUZI8?=
 =?us-ascii?Q?BfqKAXjRz4RqTsZ6QiaYkndYaFk+Ku3lt1bXWcxGXyHCwmR7S4/Kn6RGfh9Q?=
 =?us-ascii?Q?eVqFqdw2SQAgh7zbSgHHGB/Tu/HXUpgSruoqr6udqqwwvLPkPpLmrU+TWm2+?=
 =?us-ascii?Q?pq88XXwNpBE3ZTcB2GVhvFutS7q81q6/UIuIP4qG/mPg0GwJkhN2qfQB+hcU?=
 =?us-ascii?Q?plhHMS5aNd6wJX/ZOidV7EmJ883jnmLkTZFNfBpEJZ7GX7fGocTO/hL/7srB?=
 =?us-ascii?Q?T5NRgx3s6g3Q95nnSczqgtuH9yKh4zqayHUa0WT+ehCZHLGnt/uoR1qI9Tik?=
 =?us-ascii?Q?b8o4xGaKbmShQ6arkdxq0eXEEOexzsOO6U3pgjCdU3XzCd4KoOi6Yv2mbZ5u?=
 =?us-ascii?Q?XtVO+b2EWfcVzGBgEoORDDcLjrRegjohL2FDzslq2Wp7VC1DlmdZE5rsBu2k?=
 =?us-ascii?Q?stEM1BATFRQRdc0JR8OG/iKdRRqBTK+AhcMpwqsJDtlq/ovR3SoxssCOQoXf?=
 =?us-ascii?Q?3A3qFTGXZpCicaQNPLDvmY1QWU4M00aGH74oNBDsvbzhWPRN4lest56XzH3z?=
 =?us-ascii?Q?s2RCzPPygCUOWumxLhhRmJvcJFXB/TYakZY7FkPHw97r7rmDGpb/K4yFlaBO?=
 =?us-ascii?Q?azrYSCMViYnU4sanhIc5Yl8Q1zB5f3Ax2urPffqzdjTZvimOsqXQaT4h/MsY?=
 =?us-ascii?Q?CebOc4bb7wxCQwIn1X+2+iASM28klUUzkYrY3Pbzceny8sCijIGU/SHJaNG0?=
 =?us-ascii?Q?PoeBnVYyoe8C0rz1JqTU6zkD+xC5yzcKw4y13in66+1r3/DLLbSj+lVqINeF?=
 =?us-ascii?Q?ajHreSFXqVRLNLyTBIoz1DZrhVFpSlB9pI7ofTgcR2Xy3U5eO3vQHnQe2DDd?=
 =?us-ascii?Q?U8WTCsSHhm41v0V7pVDaZR+5w+xOl5HfalmxadER+KsxQmNq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d59f29f-4370-4205-c2d8-08df20dd5909
X-MS-Exchange-CrossTenant-AuthSource: LY0PR12MB325698.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2026 23:31:56.4743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rsqUjB6CHGAktB07G4UjauqZX/9yKNPzmHlzjw1tBCL2z5qFx+rwHA8ctFPE3s2i
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5830

Sashiko points out that efi_handle_cmdline() allocates this memory and
hands it over to the caller. If efi_pe_entry() ever returns it should be
freed. Add a __free annotation.

Fixes: 42c8ea3dca09 ("efi: libstub: Factor out EFI stub entrypoint into separate file")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/firmware/efi/libstub/efi-stub-entry.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/efi-stub-entry.c b/drivers/firmware/efi/libstub/efi-stub-entry.c
index aa85e910fe595e..fc1282fb442e71 100644
--- a/drivers/firmware/efi/libstub/efi-stub-entry.c
+++ b/drivers/firmware/efi/libstub/efi-stub-entry.c
@@ -40,7 +40,6 @@ efi_status_t __efiapi efi_pe_entry(efi_handle_t handle,
 	unsigned long image_addr;
 	unsigned long image_size = 0;
 	/* addr/point and size pairs for memory management*/
-	char *cmdline_ptr = NULL;
 	efi_guid_t loaded_image_proto = LOADED_IMAGE_PROTOCOL_GUID;
 	unsigned long reserve_addr = 0;
 	unsigned long reserve_size = 0;
@@ -63,6 +62,7 @@ efi_status_t __efiapi efi_pe_entry(efi_handle_t handle,
 		return status;
 	}
 
+	char *cmdline_ptr __free(efi_pool) = NULL;
 	status = efi_handle_cmdline(image, &cmdline_ptr);
 	if (status != EFI_SUCCESS)
 		return status;
-- 
2.43.0

