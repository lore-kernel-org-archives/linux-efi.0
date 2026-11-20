Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795197142;
	b=gXnmkj2E/HE8sdmheNYDh+M6GJb7gCl5zXBgGXjYSxu8CCcZVYtUZayfdwZORsdJDAeE
	 xOC6Nqni2RbDdhTJDCC1Sr00RBiqX/Vt5197cJuXU8zfKF2XQDegslhZQD3Ske6Ka8VeJ
	 +jMnrNISAGbhYYspxXznXi4z53NxtaTwvfZY+MPUn3xRyUqJug9ClzGVz9o+uudRveMgK
	 eCs+QXTqZnErLIKF8hI1eeLMiUzlyU59t40qK/r3f0BX+5eIo+JJnEl0Un8cYAT42aE1M
	 HWUb1L52p+dSdy1qm6ya6UkBkKy/MPkuHslP9EYQvBX+kqs1YXYUWtk3l2JtY1k2OUg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795197142;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:In-Reply-To:References:Content-Transfer-Encoding:
	 Content-Type:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=dfP+6NynzDW+1WKIYWlSerXWi5HNe7opDqb8YYfCCTs=;
	b=E64xterhLuWNkScFKZpa1UWhd5MVu5clDLEUOXRB4mcad2fx+TifMEWp3eZmRCVYts68
	 YQjMrWMe6KazQKCVIHktk0TsI34WLMXEioRd5iMUjRaME3DdVFdALWTjirHn0BnmB/mNN
	 KWFS1OSqUDC/fq2Z9fKjw6pX38wZo31pRA0bL94quRMvE3AVyOE41ufT1Q8SRHh4oKjHC
	 cyrFicOvV1JjP8XOzlpTuD3oYF7jXcLpI0vwjA5N1n183mTloVE05obdsgcxb4cMIgqom
	 k0rmtH1cxrpM/s2q9V8n7u51Wt7EbhCYv1GfUj3jwLxhm7S3kgNQnmE3pOW7IsCJKhQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=iMrNX4on;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.28
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011028.outbound.protection.outlook.com [40.93.194.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E3F606A335;
	Fri, 20 Nov 2026 17:52:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D6E3F606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=iMrNX4on
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xFhfjbC2MLyDWPvqC//EWMeNIc6YnAxOaj6X+GlCRROP6MKFDj+AFQo1OrcivBAk6TF+C9HC501OEoeA9PXL4uCATsXMho1g6Y9ucgzS1Orv3AYBWgFhATf/N4aeXY2vhugR4agyceb56LSWD/r7dnOahliEfykFX3tOEa+y4NkappUy6QoAVORFbhk+BRJpgsj9/qEmnAbDaMonZIuDK3h6M95lz+ouQQ9PugyEiGMg/tM2m4jRbfRUSUoAdJb8zjtHW4zhi0SmTH9ywne2rJRYK0rT2Q5pbZoUS44l9bNCzRGDQVnZ9tqu5wfH9ZnMhdHX6SXBdfr+wkotfUsm0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dfP+6NynzDW+1WKIYWlSerXWi5HNe7opDqb8YYfCCTs=;
 b=vbAQZ8L6F2lYplAv3xrvW7cOFXsH88Zi95Fo2wM3u+13qenP7jZayqo2N08nFUfXC8t/cEU3i3OgPmrcXPR6Cg9bdWx8TUHWDiw7JgcL/lribcHDApNsVUKTGtDytyPaOx/WW167IFHQgT/MDwPE4K5GpPi1UhJFz8HFY1qlo9P9D/gA/dMajJN7l6gQ3x23DD+iYp6wT/NsbCAQEM8DWH/IZAHcS5Zaljc1nGsigcFZvjxSVGTNpF9E76wNWqgEv32tIPpiMKhKKIlX6H9ToE+K9g4j6niFhe4CLBHqaMAI94tebYA7xwzU5r+xgZPDTmASPpYE81+3/d3yFtp78w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dfP+6NynzDW+1WKIYWlSerXWi5HNe7opDqb8YYfCCTs=;
 b=iMrNX4onp0imAUA0xzySJx8zIyCD/2Uji2A1gi32t525biO6F52eNWer107AhOT7bW4+51QTIsm0Y5meoCHL0O8CWH4laR7BUATP8rse0QSEWUuVc+l7ZdJqZIAIQVaBFSR44SPsKLGLaAbgU8RyNyfQIRjxcYJjgMCsOlgKgQ+z3SEy1gkjoeTqvJcNkQsHnlbgEqtxKOqXL1FIPVkj0VTcmfTBjPO6f2pF0I8fmHHE1DApDvaJtbGRsBKF+t/Q0lD9tr5jOS7z9CW3ETVhy36lo0TtrWz2OeA3N+RHkobA/zrNhN7vNp1VZsD00/5tXmdLp89tMJ1T6W4W+QO3Cw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by IA1PR12MB6329.namprd12.prod.outlook.com
 (2603:10b6:208:3e5::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Fri, 20 Nov
 2026 17:52:11 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0639.010; Fri, 20 Nov 2026
 17:52:11 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Ard Biesheuvel <ardb@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Justin Stitt <justinstitt@google.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-efi@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	llvm@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Bill Wendling <morbo@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Will Deacon <will@kernel.org>
Cc: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	linux-integrity@vger.kernel.org,
	patches@lists.linux.dev,
	=?utf-8?q?Piotr_Kr=C3=B3l?= <piotr.krol@3mdeb.com>,
	Ross Philipson <ross.philipson@gmail.com>
Subject: [PATCH v3 04/11] efi: Add a __efi_data_handoff section annotation
Date: Fri, 20 Nov 2026 13:51:57 -0400
Message-ID: <4-v3-22d1a1eb7d2e+17de-arm64_drtm_jgg@nvidia.com>
In-Reply-To: <0-v3-22d1a1eb7d2e+17de-arm64_drtm_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: IA1P220CA0004.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:461::10) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|IA1PR12MB6329:EE_
X-MS-Office365-Filtering-Correlation-Id: 3544bc25-b7df-42bc-baf6-08df472efe67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|18002099003|22082099003|261009223027099003|11063799006|261022115727099003|56012099006|921020|261102123227099003|261102130727099003|261026121527099003|261021121427099003|261021123027099003|261022075727099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	iSuP7cQoEHTy+prsNzva6U1VVdef3r48o5CF22oxYc7JEk/xDPy01NxCAbB7OPuFZvEey+PeV8cEqWhtB1/nMUHrXwDg9lj7EwffmfZg08EwXriMhGQPFYVvU7E/iKmJFLC30Z6WOb1lY0FKPjdZOpd89cVGzYE0DBNAHJZjJ/ALLo2aZBlYhcOg4aaLSPhimSBwU70cDk6HXpVs4XSgBLglYieAGp9YaFYOIp5teXk+85u6+/qw/mNZJ8Yjs4MjpmQYXawUGRixLWRp4yXys1sWpk7I9csbMmBqdFLv0aekr70mlhBpJo2G0k/SOOV4aLENKVtSoJPZs8gDJSM/RM0MPWuL3yEwwpgaTaqi710RSEgTgoFcDL8Ck7SFKIvloDBPWvh3OflMowfkCDddv6KFQ5n3xCrOPM2cdSLY2n4Jy2bmGDJR6648DAKShKcIc7Vozwa3B7AeYsU+XrlHw6ZnLziNo1PufguECcUN5Qk8nm3wwlWyIV/tWRS78yGy1jWsVvK7Xv1gXvbtG2dNWT3o+km/98JzEBg0SPphEM6VjnDsJrWworXvMCb9s9AJMACEnVTKYnVkrHBqHQsZZFnEKy3qsoJn6VsRutKLGYVWE6GZoEfhrocwTN7IwkVJeC43R5II30bCGHSXpI/ErhdQ5O68LlwivGq4k5bsSK520xZVxvN/ac5ajTM/kfTEecO9DaZtGhKbwqZTRPwrCQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(18002099003)(22082099003)(261009223027099003)(11063799006)(261022115727099003)(56012099006)(921020)(261102123227099003)(261102130727099003)(261026121527099003)(261021121427099003)(261021123027099003)(261022075727099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?flWqrCjHjPW9IvUXMYeD9Om8itB1pLNpMMu/YOG1ZLhEWHSuHopLe3FmQN4/?=
 =?us-ascii?Q?6UaLE2K4IPVLy9xqdqZyY1k/EiVZfAWZABfMawK+88IbtBMdmfDKVbHrlEuB?=
 =?us-ascii?Q?LSD3SznSkWWIp7btYL2HO+iulKFqaHoU64JcgR5e6qXrRof+lG6nIU7n1Qn1?=
 =?us-ascii?Q?hcAhOkXOIRaw06z0uf7Rb0huNndDZdfv2z+Bg2//0QhEZxI0e+RmbynVHsp+?=
 =?us-ascii?Q?GlrEpR0qEus95+Az7xfEL35pY4ujegAcboLVvIoPeM/xdTw1g95BVx/MBapw?=
 =?us-ascii?Q?ImaNGebgh/0e7X3cxc6FE2adrBgDpV6+f1hdfN3j9AXUamIFC85mw5/Y8965?=
 =?us-ascii?Q?z4VOMB47teD11nEFUdNIDeJuq2eHWpv1kMchYwI1h52FdPYj33iKhoLyoj4g?=
 =?us-ascii?Q?/f+kiVPQYQpoFJla6eOLPLosJpD6rVqze0EV7NB7cAm092+rhCMP7H9Qqw8z?=
 =?us-ascii?Q?IQP6WCjo7BEr3jIhP6P9YAN7ZMJ0ugayoZQARHimJ2eIz1ysWtjWaG6RDfr6?=
 =?us-ascii?Q?RuDaw3OB7h2pFQ3X4qls4Dld1RAhvKjdFvRk60f+3mSnqBAmQ66YTfmMlWo7?=
 =?us-ascii?Q?/3QHnCEoSjKPo6YSp5H8AAj1ssFEMFmILfa4IPi+qdNHwJu1HYsQFoKGoK7S?=
 =?us-ascii?Q?8Hnn0+l73etPyu9c94jRnOCFd1uZ+hA7w/GvMWjWK8GuakCUKLvSAtkNIcpH?=
 =?us-ascii?Q?96wmg7NpscsLa3rlv60hQG+oxcPBHK1IEFHYwjhXwqgPzSMD9FycSHKb8T2j?=
 =?us-ascii?Q?PHprKCij6jhxnykFODo1wxcxldv8tyZ48eXTiyXeOzWz5wxCqTH9yd+g1IrC?=
 =?us-ascii?Q?DXJsOy0SMIpbj7o22KOGx1aXah9wTGsNAFFfq/2qIarlL8sL855TBlWQdqxW?=
 =?us-ascii?Q?RG0nDRBSHNaIimxcgO1e7R9q/mcabJ8wK0OBjrrPckvosW6ewkMQcV73nlVO?=
 =?us-ascii?Q?zqFOPt9l8M3nCI8DqXo3JiqW4Kar1r7rA11CXPd9Dj4uZUCUw/L4Pxr4x179?=
 =?us-ascii?Q?L9kTBmVX2YFAA8OCB7hRWZPlFgHUu3Sengpf12WkSe/b27I8HjMF6lnE+04R?=
 =?us-ascii?Q?PlD7SIRWXXbkiI/WQq+aqEv00GslUJ9tcRsCD8gmktY5IoL0olD/tEetQMaB?=
 =?us-ascii?Q?5fuRo1nloLLigvd1FkGf0vRGC63pebaDOB/ODlbndsLCsQ5jX2B3Ozb05GQH?=
 =?us-ascii?Q?N7y4SQkOb8yIkd3sn7uokPTplkbXegychpstUkvAvUe2yNvK70Hvn1A1Ijll?=
 =?us-ascii?Q?jr5zh9ODRmuugKD+01ilqLvLkMA+Rj6lKixy7/oTCyeeNwdcNgwpluCGM+oC?=
 =?us-ascii?Q?vbfKvOt1JLvRMBvUQ9KLkvI77QGOAw+8CQNBbhShD0DFvdnjceJVNIwTWx3A?=
 =?us-ascii?Q?+iSummEk0/LlW/UJZgyhhLqO4XGYqXSoR18Bo1gYOuEgZvRCUy0TfH2bTmDL?=
 =?us-ascii?Q?4Vc00oWIXtWRl5WIZTK2maGl5dqkzsVpXojM1QMWSQ2giHvavAgmd1g+hZv/?=
 =?us-ascii?Q?mtejxke+fCHaMM9K9aeHoChOuC1k5WyM4baek0+OyMOPOUqe9mwvYk9MX/DV?=
 =?us-ascii?Q?kwk2iEj0TzrD/fZck0inaZwDhpSZMckGE53Wstse7HZdb6wDKLxAB29Oq6T3?=
 =?us-ascii?Q?+JYAdqQgEBEgqO2C1/gmKu/q7HzVO9YHkZbZSoEj5zYp8vDnDiCnXMx2KHJ4?=
 =?us-ascii?Q?jvCUpUpXKQd8C8+eeBijmUOKbhLqIF0MS4Ke+ZpqWtmXyQU7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3544bc25-b7df-42bc-baf6-08df472efe67
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 17:52:07.3497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QpuwY4IvdqHV/+iYy/y0EnCCyYPhFKrjsQ4S8ex/tJ/wAU1NZVliUWK9safaq+oi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6329

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
index 25a5497ebb2ea1..a6ce8b7897967e 100644
--- a/drivers/firmware/efi/efi-init.c
+++ b/drivers/firmware/efi/efi-init.c
@@ -59,7 +59,7 @@ extern __weak const efi_config_table_type_t efi_arch_tables[];
  * it even without EFI, everything else can get them from here.
  */
 #if !defined(CONFIG_X86) && (defined(CONFIG_SYSFB) || defined(CONFIG_EFI_EARLYCON) || defined(CONFIG_FIRMWARE_EDID))
-struct sysfb_display_info sysfb_primary_display __section(".data");
+struct sysfb_display_info sysfb_primary_display __efi_data_handoff;
 EXPORT_SYMBOL_GPL(sysfb_primary_display);
 #endif
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 4a809c6ae7241d..f79c5669a356cb 100644
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

