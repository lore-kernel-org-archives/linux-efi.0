Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010063.outbound.protection.outlook.com [52.101.46.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4955A3BB138;
	Fri,  2 Oct 2026 23:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790983921; cv=fail; b=tvxbs2D5k2SOK3rYE629/RO5Tpj2A97ngNWbA1nZq9UuX/y8lpvb8y0X9f8Iq5c+77uWRM/NAd5MWvHiOyk8jz7dTaIE8sPscPqBSvUY9Wj04t2D7D1x6IdNztu41nZvKoNnOW+wb+CiqRgvNEUjedTbK2EPwZ6cpnyqu5yJ4T0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790983921; c=relaxed/simple;
	bh=05ID9brpl34zCX+yyQpoyvKocPk4NWJ+FJ1j2+RTq2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YVGX/7Me2gc8b3+J4LgMw+DtBUh6njw1NYBQPLstM3PNRxlWGS5LMjRz8UKxllIucTFyB+w0cNBo7LJsi52VlBuhmI+U6JR/dKDCRznDqF82ool3OGOTbCx/YM2qWpOAwCtx9VyXCHF+JTHvdNunJOL7I1FZpaD5NMgRForUugw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FAs/p5/N; arc=fail smtp.client-ip=52.101.46.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FAs/p5/N"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EPLhXqhzGU+0vEJnOl7NsaMwH4b+thjxofgOFbwCMEgdUS4nk9N7TNwyl7mnEWUwFY+Y4zgPnLS8bcn8MtvjbGQX25sIH9rv+nn9aixi5+3dCnxKHXFOaUadttJF8Gyg41tmPcCQhmlE/RXfGZSoyJtlltfSJl6Z65oAXvQ154oMO41Oajx2wZKJqamAoBug61QR+pzcmVPZrP8bXTimZSxzXHDvvFJf8NSAByXTWhW1Vxplx9t5RogABP65iAynM3d5VbtBW55jFzs7IA+1s9nspC2C7d5mkGaNusr+Cep6sC3VnBOxUzCQCKImZDpPRtKdYBVYFOG3kcjl6Ex3pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yFd3p27cWOcm4Kk4NXtT9JtU4euwpZq43OG/Rp8T+Vs=;
 b=B1EnKDX3Z9gofDPIP8g/5hCeMAZVvhwpVmLI8ZN27C/bP+GDAFdrOBaNI1RroteWcP3XaKQ3eJWGZXBvLqi23s+lUZdKk+vKTJeq2oC6W/1qxYTc+Z53x5qGuww9IAceMPzvEIKPxsFa9ODjCVJAGRZ1sfB4oRpEmSfqHfKdWVZVxAoO2EbqDGqBrhfTfLPDQCg7JZHIWE87Ovhm3B5IElkDyBSDz0KMl2zPLHn37Th7f7bcAELjHkRi80V1f8o9rRxiiClm3e6PO4vZmzs1UoQfmsDA04cBh8+lUeLax33ljUJ6M/jFID8HCaJmMp5jgWukhWadAgxTLTXWBN+kcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yFd3p27cWOcm4Kk4NXtT9JtU4euwpZq43OG/Rp8T+Vs=;
 b=FAs/p5/N5NqBYI1Ja7e9ASWL0V7JPs5M4eZfpczISQXmGFUJuqAhVWM3X/lZKZdAy2xlpOHpkLSTRvitqBfP+L5wedRyFDdbGM7/FZY//55fnAtkyjOWqky+lblNsrmcmRnCO43TjeJJyZw9hQaaRm+OTGq+PjVRtwWlie6CTubKoaaKzhn6TfXwggqBgMdTSWN7340Q8Ts64GMvMn9DbCBWQQ1YDfNnCaFK5hfV+WznxKsiSj9LtC1WqzOvAMDvuLtrpkQi8J8H2v1aViQu1LA/4+jBH+pCT2CSXFwuIHaguE7z/BPjn5jZ4eTQ6KqEJ+V71rW4Ohf7gYiyuWu4iw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14) by PH7PR12MB5830.namprd12.prod.outlook.com
 (2603:10b6:510:1d5::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Fri, 2 Oct
 2026 23:31:55 +0000
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5]) by LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5%5]) with mapi id 15.21.0472.016; Fri, 2 Oct 2026
 23:31:55 +0000
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
Subject: [PATCH v2 01/15] efi/libstub: Fix error unwind freeing fdt in allocate_new_fdt_and_exit_boot()
Date: Fri,  2 Oct 2026 20:31:38 -0300
Message-ID: <1-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
In-Reply-To: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR10CA0018.namprd10.prod.outlook.com
 (2603:10b6:510:23d::15) To LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LY0PR12MB325698:EE_|PH7PR12MB5830:EE_
X-MS-Office365-Filtering-Correlation-Id: 38f82ca0-4231-4f22-f108-08df20dd57dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|1800799024|23010399003|376014|10067099003|11063799006|921020|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	mkMVAT60MUm7Xxk4Uqa6G2c1PjMX50lqAn/guOtTmURs+OslXqfbacsEAHkWJR2tcMTIzFKZkv1HuelqBbm2eRC3K2wFom/6Medj1dx2Sfv5rqEM/QvNelza71pvw3nb+AzQYozPuBiLeHoGapqrpbe1gUJy7XE7Y37Yj2i3qK5vHB+dA9cXilUD6nMlmiWe6wAOp8f0l5+G5tlrMlXwsomwFDpkA7ibe8GNL8ohBySFWjgLM8AKM0Ccu64xgYCrBl19pgB4R/rASEXxZGZMF5dre+5Y8J1gSA7XjrXhn2Hby2+Wkzn/zBsPPU64ewSp1Up4qBaU67tVaTV8TWXSf/v9L5Q2vn/ZO3XMnxI069+iQ2yvKf/Q/jVzNB9OPPTO16tTEjnC3nNYF0T808fMvVCHoF5PLvD4cgZVXShJZQlAfpI7tegdNrnpWsf9bAUvOX0aSzb3/yyRjmWP+q5W/xFJXH2KRH7fhZq3ZhX1v+Rzjd8uj/fp+TqkgDrnUb4eigi3HHOoGLHw7aH4dtVyI2it9JHGpxhtoLIMXqzUgigZwE46p4QSXtzTprAj5UWQFfTXPB26heVFGpIF5XBdyBBfZc7ZcUKLiiXp4lYEnhPVujdiR37r9mXPtus+PKL9IczT6h5vv8CQ+kaiRWJQ8c47YqJ6wRhr7FfqDAMoU4lxpM/lNR66yHBAZx7eXsaxLYBVfdXWIdY6eehSiYC/7g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LY0PR12MB325698.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(23010399003)(376014)(10067099003)(11063799006)(921020)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?F6k5CvRehqhOGf5hD5pUWhtBr2LEbsS45tMyRRLV80ZcZGTxM/kXIyFDSk35?=
 =?us-ascii?Q?9R0tWk7I816rJDn5ce4V1YRwZFkI7lUq3P7NDiJIpAa/fLssMDser5OyDqAW?=
 =?us-ascii?Q?B7Mg4N3HSVS5MOZ8uQ3qB5vy87iiDRkU40G4Py4Ka9mtfWlKIJ266GqIht3+?=
 =?us-ascii?Q?HmjVdKrpCNF4G7nyxF+O60yx7aK/j2/9jdcIKjZ9Jv14JSxDPLpxwYtAegeu?=
 =?us-ascii?Q?pEmC0d465idYbfLWvaxnDQVa4VJN0N3s9dxvWsplqc7uBNyhvgkKhIP1Iisw?=
 =?us-ascii?Q?qgnaHO/8JhQMuH/Lz4T48f2d7V44Gs/XEpbSYs5yvALGCn324kXfLyLDeFBR?=
 =?us-ascii?Q?MpCFTwSea/h48d9lYYM4ycCjBwPpYE5nCszQYx8zS+AOEbR03tGkC84Aqjtl?=
 =?us-ascii?Q?36xY/ufTzdbkTaNlnHDU4Y5Ty22V0GHABxNyBTnAWL1uNFOKO1kLsAOWFRf2?=
 =?us-ascii?Q?/gWabUtyNyDztwBT1VtUFYOP1mwLz0rm4eqs/h4ycNUjviBjL4b+aRBgk2gU?=
 =?us-ascii?Q?DXCqs3JudGa7kV//zTDDMjv4KMAZcJYuAnO7iF1ljLqyiSHAneujaTW1kLQF?=
 =?us-ascii?Q?1yiEOmD3UTbqb04fKn6MjIe44JG7aa+BmY3n/QUm/E/NmULVhmUjMNQM5Kyn?=
 =?us-ascii?Q?xrB6VfeYgwDLlYInsBWnb/IHpbo49DtIHL7OFrX6kUIFuniSYh9Rf4QUyadT?=
 =?us-ascii?Q?pC7V5BEbPvkPK29N5H+PT0+0j45G1B7iGnOwygjsaM1pLgcBJQk70WDOmCQy?=
 =?us-ascii?Q?isS09AbKkHufDWPS7VQOLJ2+OQnFTASYBaEQhbaOH7AtKtyWlxdNKpqLt0r8?=
 =?us-ascii?Q?Gc1f+QU1vfmrKDkW0U71ySuIU/0ihT4A+/7uWWA8U0f2pPsfNotky/7w1ZZF?=
 =?us-ascii?Q?bbR/FkM0WY2pl+Ox5TZF+mISXPDMCTnZj/1yNYSJdEmq5W5VQKWeT8t7SMdV?=
 =?us-ascii?Q?socL7tM6QTZfUX1rRSl5suuOaRWtLSm36tEUL7IHWusbccXoqBPzef5LuBSr?=
 =?us-ascii?Q?oDGaCv8ncbe/vyNVQ0GS1Q3UMpwo0R0qlgmzEux4o0HE5W63bNAWEBovbGeM?=
 =?us-ascii?Q?XRhIdoKzExjhWwp7cco6qwbMjGx5xkW0YItNCuy2++uPurSB/lmuag5y37+i?=
 =?us-ascii?Q?C0yIOqMoDW4x9PGsJihtrSDkv6hPS3o6YX3nXTj8mdQ/YKbYKLtFUUBPvTq6?=
 =?us-ascii?Q?vy5pO0SpBM+GyJng2d/10fP14PPgYSdInwVAuEPB4yeOzAbMqF8iBE8S0YDS?=
 =?us-ascii?Q?0+dyGs2+9fWWIJy3xUsmbVlTQeaeoRBE+G7g4DzGhkqx65CQ5PkXiczvAVYH?=
 =?us-ascii?Q?/5ci8UkbDupL5j5QnXr7Oth1+4myC09MOohQIPdZHfZazKrSr9a7ttMLfBSR?=
 =?us-ascii?Q?fBsyz4NbQTs9EFArStWp7+LMjw53Jt4zXrrA9muvhdaKXJTJ/JMIbdIC+aw3?=
 =?us-ascii?Q?VIzwvK95BPZQRrzMUDb30XchBKpu+FgknLEw/0fDC7pRUhCHXf63iNwXbwsa?=
 =?us-ascii?Q?a/Uo9ZNVUiRSK0ddlzBMzxEvdwBVqrZBWwZlMsl4ZNHSJjj3iQTFlQ/yqpSS?=
 =?us-ascii?Q?eLZQzGdPK98umUNh1jcmsynyNO0mHFrLxfNYm9w9Sz36EJHlyL+wPOAWlcBS?=
 =?us-ascii?Q?GdB+nQGZenvXNpSzcWfntaDgQY2Y/Kzfj/z6JLyCTZ41dA5Og2+Q8954N1VA?=
 =?us-ascii?Q?ceq+amhConPdmWG3Dbm5wcJI2JK5Ny5Hl87IuKFIUxGd8dZv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38f82ca0-4231-4f22-f108-08df20dd57dc
X-MS-Exchange-CrossTenant-AuthSource: LY0PR12MB325698.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2026 23:31:54.5475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GdjCbygFXfcykSZT5UkdU88GcxRJ3fjNiYFIV1atPI6pAHX5YyKvIyAnzUIendxh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5830

Sashiko says fdt_addr can point to either an allocated fdt or the fdt from
get_fdt() which is memory owned by FW.

Only the allocated fdt should be freed on the error unwind path. Use a
dedicated variable for the allocation's size so that the free does not get
confused.

Fixes: 4fc8e738ff3e ("efi: libstub: remove DT dependency from generic stub")
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/firmware/efi/libstub/fdt.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index 23b3543d3041b0..f01450b4997546 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -229,6 +229,7 @@ efi_status_t allocate_new_fdt_and_exit_boot(void *handle,
 	u32 desc_ver;
 	efi_status_t status;
 	struct exit_boot_struct priv;
+	unsigned long fdt_size_allocated = 0;
 	unsigned long fdt_addr = 0;
 	unsigned long fdt_size = 0;
 
@@ -251,12 +252,13 @@ efi_status_t allocate_new_fdt_and_exit_boot(void *handle,
 		if (strstr(cmdline_ptr, "dtb="))
 			efi_err("Ignoring DTB from command line.\n");
 	} else {
-		status = efi_load_dtb(image, &fdt_addr, &fdt_size);
+		status = efi_load_dtb(image, &fdt_addr, &fdt_size_allocated);
 
 		if (status != EFI_SUCCESS && status != EFI_NOT_READY) {
 			efi_err("Failed to load device tree!\n");
 			goto fail;
 		}
+		fdt_size = fdt_size_allocated;
 	}
 
 	if (fdt_addr) {
@@ -334,7 +336,7 @@ efi_status_t allocate_new_fdt_and_exit_boot(void *handle,
 	efi_free(MAX_FDT_SIZE, *new_fdt_addr);
 
 fail:
-	efi_free(fdt_size, fdt_addr);
+	efi_free(fdt_size_allocated, fdt_addr);
 	if (!efi_novamap)
 		efi_bs_call(free_pool, priv.runtime_map);
 
-- 
2.43.0

