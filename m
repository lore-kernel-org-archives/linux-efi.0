Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010039.outbound.protection.outlook.com [40.93.198.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C2136F90C;
	Thu, 24 Sep 2026 13:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790258019; cv=fail; b=NJqIrWnoL7jeqyeKpvdiUPEt4HmOqIUjrTGrR5f1v+VwCOspbJv82suY0jcqCoBPbf8+amAEsL3SBjBMzYEZTcSWJrGqx2sMSpO3rc8CaUqIiNEUd+L3EHpTf5ifbj41NWwe9Qd/MHgAWnAQ88AEq2e1VJobUz0l2lHtH+8t2AM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790258019; c=relaxed/simple;
	bh=vIuIYrhJdhndFBYTpVNxF24CEVlccZfuXHcNt3yXuXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=K9l9EKqvDau4DzFZTBN40M660uH06pvxflaMQAlQ31tVZmgXCCkFU6C95qd1XjTP+Mr8LIC7B0kWzY532RkFJLlr8Ni6ZxMdv/p0bPvmS8NqExAPpvKndalMPwDm5dHu+1V5rLV5ktMQjYnQBZnMn9d6zg1kkqj4t5JJzG5ZUAI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=F4n2Gfxn; arc=fail smtp.client-ip=40.93.198.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="F4n2Gfxn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J6PmON4GAwM3RHAlRh1UR15fx+5eBfniUlpxxbcD/9JZQV6wuW5EV0R1NcAEmtDi2s0K/tKU1v4P7VsbmtOs+gdVinnsXPZadYbKoWMlhFuyCjBP6m2jQ8x3kYAa9qB3ND1d/k3F8ekVQpa9FuOt2nvYUJWww4N4bO8ZwXhkH/2kyJShD7t4nuoOJXQgQ3fhJKo5DTlU+Sex5pulLowcgso8D0LBNoaxn7Bm+MYsLiNMiuCFUhTsxEFpxcRpPxFOYP2rqWc8AeABuN+q62GRBXikBAmk+sxxPwzAbT40yc8SYEdBwU/LfqlL/q7A0NqlQhoFcjrVKiPhOKRZ+bsK9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rnYwpdQaYV8yTZ+Bc7ku3AH2VwC1T3GWJ/8EukkmdV8=;
 b=ra9vJuj73H3Sw6VzhotjpG19WCaB3X2TGY2gEFHkDhs0CWBfh169ASrwEBw0hL9cfVmereiZ/r7qt/FoijGJFjcy/9KGsTZ3S5jsfK8G1WfjUfFqjW/pmPzHOc29Zjgip5jATFbDWk4r4Csq8QLJVUA+b5C1snr20UzHmSGe9n+taWgCy7OnUZoVruscppXzoZByaHtyfYeXslPjbKctyv3xH73YInffSuXEOZBS5ZMk1Pamopv0gDRnfXwRAZcfokVxUc6bcsxp1Px9eAKPBMOkWdd8EVIQ3RPrKcSQfC7MmguHI7zJxyV/YQdJHB5bCl8AiyvtMP3ILqnECzP4Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rnYwpdQaYV8yTZ+Bc7ku3AH2VwC1T3GWJ/8EukkmdV8=;
 b=F4n2GfxnyCSU7WkWcmTCBejLMqnfVudchWD5tFaDm92JfdDPjh10aalhN4Shjy9/3IjhZcsZx8F0eigP6paRqgNt4OaF2PSa7DqZpgCbi0uVkcEBY1zpkzdzJm+4wPQXZzlMCcQUb2fFkNR9YwR1JaVoMAoWEOlZcbsXToGmdU+vbC4M9KV6SkyiI7AQxIzKgDdSi8MbYOlgXi0p3n4gjJqm75VMQb4kZ1wKCHR2HsWQpRYhSvj5ftH5uniZNUjTNq9eY+YGDN7PMAUMKeNiH6DdMia3YELSitmrYAP+TTVa1daDf5kbXmaFLweb169NcmN8xp3Y0ZQ+hJsxBsD90g==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by PH8PR12MB7375.namprd12.prod.outlook.com
 (2603:10b6:510:215::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 13:53:25 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 13:53:25 +0000
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
Subject: [PATCH 02/16] efi/riscv: libstub: Don't set image_size in handle_kernel_image()
Date: Thu, 24 Sep 2026 10:53:05 -0300
Message-ID: <2-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
In-Reply-To: <0-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P220CA0094.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:32d::30) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|PH8PR12MB7375:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f9403ac-ed2f-42fb-36e8-08df1a433348
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|921020|11063799006|56012099006|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	2WcH1VdHyN69DRIv/7nihXhjgwf0gTA/w/aEqyl7CleZ4y8abuufwUr8OKghhGXcvhU7suL3ObVmBh9155iyGMXUHhasbkDsnDUwic+AC9d5125QcRLswaJqd5eCbD4v8zluk1lhICh8zJabUuNPXvHNam+1fBJnvQT8+2icGKEif4b1G1ccTCnQDJDrI4WccHqSg4CWtP04Cyoz4FFG7SLjN21JImyh+v5yaEZcu3q+CtLkN+ULBnwK8ZxhEran9UA+G+Deneh1EVx1IpRjxoT7S+7t0J15+FZyqa2VA7Tw7vBqqg3GlImrIAk0nDIfdlXthADmsLgiklsS+fOiHgZTekDW2TU+/um06UBL+g59jNILIfYCMaRh4jGl7IxQaM5zTjFTgUsPgjyCZ9f2prbqTSg4iO1VFc5scMwhSy+H2IkLAfXR0YRkPbS5GGwna8Bq0gTsIBcTZ/atsgXV6rVIxIwdPEHoCGgN+or5GUCKfBADZCQwBwn6HFa+MbGCz3Gfo/EApvBOrlQCHBGxQGV8E5q7q3TGcdR/TSHj35GeMYqJ3SgZ4CX6c8/Fu7RfRpizPcIMnTgXnSYwZkY9j2TxRAbr5aqdVsV8dFTwLn5PSLQlghxt6bil6RUvKCZMbURKgeSgZvVpH3JZY5qtJEgeXI2PM71ZyhoN8kQY6L8KyD1uQMlgmEhxqCArOLFevb1bAmT1E/GYxdresoEnHA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(921020)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lfZt/MZrMbgsKiWtxkO/GeOAx+QmMR6V9WEjDJra659JXm1oSUkYHwQrDNUs?=
 =?us-ascii?Q?UewYh81bQ7z6lJsFPnB9OINpPC54H8YcG/HApsZ62omEZQ/O3tIKkONKnS7c?=
 =?us-ascii?Q?Efyop5CDxzua0FNpFREkpmGlmqXk3eL5W4h8maVBvgztO3MGn/8MCXLmZ8Pt?=
 =?us-ascii?Q?vluuUdiVWcU61+iUcAU1vQiVCoTWGBNJ8jiyd7enNqvZkUhXqB+E8HPsvjxi?=
 =?us-ascii?Q?O1sEUwRKQTY45ZAsvCt1vNMQkgtryJyy4Z14H1XtgGVI6dgvMe2flWbC7PpS?=
 =?us-ascii?Q?KwjXlOES/nzzurkf1+xjFJtGrKpJXnrIA8ldUxDg6WXGkuzrNZ5ssXl8dbKb?=
 =?us-ascii?Q?4ZksPF7Hv2VbWy6Av7p5h+WBFhUuTgbTM5UzLrxMl8e35CYW+c1EvN+iDFqX?=
 =?us-ascii?Q?vsFGvhTDmAP0tyAJyOFSy6XZdXf0p91QT8OGUY+ddxBRZmyDZa2uFx1AcVGK?=
 =?us-ascii?Q?tMC+wzA/v+nX+kkKQKfkKsZxl3zutZcIhMsz5fm0oocuyRNK9xmloxjOuaZo?=
 =?us-ascii?Q?x1DynCRuOwKSIDYia9FQEOCQnfPDykfN/AXDMKPH9X48FLVsbvyDWvvL+tjG?=
 =?us-ascii?Q?NzwOwVT4yhiyWuSKagb0HSJxHsPEkJ3qGtR29Y0ZzYoEIX4EyiskjwSb4YKJ?=
 =?us-ascii?Q?sZS91tW4Wv2xqhXueepU50nnn1DSz4t2QvS5Fd9DLbrjCa9rRsUqedu/ZPl+?=
 =?us-ascii?Q?qcjYnrP9VGjd/NDA+OcQmbhnB0PnTf0gCEVIcDfSX/+QAddDR/7ybe/3XnTn?=
 =?us-ascii?Q?HYkC6TqfJxY5aXmVqH5vMHEtrto84aKMKhE+sG3x4eWVuljzMvE5796GffR0?=
 =?us-ascii?Q?Lm5QI+S0WAI0XjzuTS1UsP/Gmc3qSzIHWZCoGN15cMvW961aor3wA+UqmvNi?=
 =?us-ascii?Q?OMbN4Qry+pPXq/+zXqG6WEzOIO+/mRfuF5vZmvRI5EaK//3ia2JfkPbORMa5?=
 =?us-ascii?Q?eS6w2bDPgPdfP/uw2Pt7sbH3FAjFE0upxa9r0EBH8zuc/UJD1/maEzLp1q+E?=
 =?us-ascii?Q?UdQWX8pIZ9qjOcrBGEdbafoUv1wG2YSy+jXnl0RQzVJ12TtngAGO2eIh2ceY?=
 =?us-ascii?Q?oG06moDjmLJPp1zbxVlM4ksP2yW/xSW0N5GNNYBFw7GN7kctDjWqy2XAN2GF?=
 =?us-ascii?Q?BS14b4md3V7TYVUNOwvdC9fL/ZpkIW2F+TXe680/XS+ZG3Lve39sdoAKcdxu?=
 =?us-ascii?Q?Ga0SPZPPSOq/Rxact37SE0kGjWRkwg2PjfeQzKPf6QwlxmRtYydMCUNXOnXT?=
 =?us-ascii?Q?6vZgCDrlsl8DyVFgLkBj05rsiIoK1jsHCV/o6M9eRlOyI+RWIpbJPODj0QDe?=
 =?us-ascii?Q?TEEyjYfB5pFg/8A3P/zn65XoULg7xVmk/v41k/HO/nfW+XbmgAtfVdHJ2GUD?=
 =?us-ascii?Q?MBKG7vbpE0pDKnnNCUI+J3T8rE+5RD0QG+u+AZDeNkmdOO5DnlCIskwwdMVV?=
 =?us-ascii?Q?ksCpvDkFxj0Y2UfkaL0e6WvSc0A4IPkMqdboc1tH+WWCUTIaZ7yGKewvkbS4?=
 =?us-ascii?Q?DuPY4M6/g8YSu8r2/VDmo11yNkc3U5XANiHVY0mSHSq2znzv46oV0SO+7Rlq?=
 =?us-ascii?Q?N6zJwyjWHRUwrkDRQhGeBmk2HC+fRM4y3BCvAWrogQdjpaM/BVsffdidTZZ6?=
 =?us-ascii?Q?A/ijykprFbg20fopgKCzz38OGTh0eagi5MJvNZaS9/8BIKxN0uFwHBqYwrz2?=
 =?us-ascii?Q?wm2n/AoXU3U52TOFJl141z0SK3w5yZsifiaCsYDonWrkSL/V?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f9403ac-ed2f-42fb-36e8-08df1a433348
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 13:53:23.6325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jf62BFqB3WikG9og9sngMITfzzDK+QMFBHzlivBmPgHguR0lfSStPbVwGBt/6HyD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7375

Sashiko points out the image_size should only be set if image_addr was
reassigned to some allocated memory. If image_size is not zero then the
caller will free the image_addr pointer.

efi_kaslr_relocate_kernel() never works like that, if it changes
image_addr to allocated memory the free is done through reserve_size.

Fixes: b7ac4b8ee73d ("riscv: libstub: Implement KASLR by using generic functions")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/firmware/efi/libstub/riscv-stub.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/efi/libstub/riscv-stub.c b/drivers/firmware/efi/libstub/riscv-stub.c
index e7d9204baee312..725b634c517919 100644
--- a/drivers/firmware/efi/libstub/riscv-stub.c
+++ b/drivers/firmware/efi/libstub/riscv-stub.c
@@ -37,17 +37,14 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 	kernel_codesize = __init_text_end - _start;
 	kernel_memsize = kernel_size + (_end - _edata);
 	*image_addr = (unsigned long)_start;
-	*image_size = kernel_memsize;
-	*reserve_size = *image_size;
+	*reserve_size = kernel_memsize;
 
 	status = efi_kaslr_relocate_kernel(image_addr,
 					   reserve_addr, reserve_size,
 					   kernel_size, kernel_codesize, kernel_memsize,
 					   efi_kaslr_get_phys_seed(image_handle));
-	if (status != EFI_SUCCESS) {
+	if (status != EFI_SUCCESS)
 		efi_err("Failed to relocate kernel\n");
-		*image_size = 0;
-	}
 
 	return status;
 }
-- 
2.43.0

