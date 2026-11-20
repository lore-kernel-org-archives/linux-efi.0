Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795197136;
	b=5Sux6P0aUqf3b1AvVVWjgeIh/iCEjpMHbvYzWba5+ZQ4uvB/sGtEmky8cDlgo6OYrraA
	 2u6TDrTlqNkE157aLepQBwtCi1lbFemEpORJ98p6akVlKMlKsfcrlJ9CL1CkgCfy9oMhu
	 HLJXeC1eGIrEbh3XG9dnJ2m6zQVPyaOecmf6tas+XOYY/23wgbjMy512Ch+pGu8SS3lBq
	 D9Bjj5SydovtS46a7C/MpL+Ql320XhDd0V840OVTZ6rpg4p121ObOao5Zcx3bqgIYUL/t
	 fx4fidYJuv/uqzL6uyXaFB2SVXEptrfX8G1qqJ43ZJLotuKnepaa93ta5kW+yj9QRCA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795197136;
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
	bh=N5DrrFP3GY0rn0msucravho/pzUgwwp1zcKHDpuhFDw=;
	b=ZcoWTeaR2kCvfqraa973pD8VNcVqyjg+3mL1v1vh5Cp+NQCgE/si/5+PXVmiW4Acq0/0
	 87AdXtKizExwRDa0XCzHwOVjt3LMCpMnoi3OZip304OCjSXsHzldXTTOfdC32Sv68wLR/
	 DDIoCJpsv95v8NwBDhvm0Uc+Wt+j03UFjepvmeGU/eHRXKRqTSbN5dp+u6/Mr2Nip0JMp
	 cDsPpx9AQPNkRLus5hJcCPYmAuIWryZfukcq1M4+bvkk50CG2/cSxdjFhTppXpi6FnbQl
	 LxhyIQ2pmXHCXZnxRgOZ2BnV536kSBu+qVgt7JD20/N5THwh2EoAE+3Ai7mNjQAABng==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=bEYI5EwW;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.28
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011028.outbound.protection.outlook.com [40.93.194.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96046606A32A;
	Fri, 20 Nov 2026 17:52:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 96046606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=bEYI5EwW
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UNWA+3Jla7BwiX8DSjgogRYnNNuywf+5KzJ0CimKYnekEZtkUNFv0ea9wKuOIT0iHo9OvSK1IMGl4zlUUkz7/TLoyoy0wPhakt2KIMm/6fs5EgRGbRlP2fmVA/5wMGIX0VTx16v8wJzGfWJorZ+qDsw9vk1uuH0U7h7jI4BGP0RBcdskbyxoYZeN+1tiyLooq9OpINNiygazsuxh0/nhdLOUko/eLpYsr8T3wWvmEM9yJZ7fyyR1bvTXjzABMEB0W0eKB2BMgW81D5nk1VZvm+VheIARSuUvY6x8SA5XFR7zGF9lHvqO2Jev1JNJyfTeY5NTHsiCIRoyTGoNMb6w4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N5DrrFP3GY0rn0msucravho/pzUgwwp1zcKHDpuhFDw=;
 b=wYKUJqvzQmjVg345ECRZQM1hx33N9aQ+07JCmH28WtHVWUgKO1i76/kJEgzR/wIIIGnJXIrpMr5OX7vmPzcIPG1poQTDZUjgn9Jp20bTAINi4rzfAUApbe6L7VrmdfxkQrfEIkosK8YnD2o0AwMumsvYDPlLGiRaK4rAvdwZUfRhr4ftsA9iUDTr43XYT/vm0k6EqZgbrPlZOkBfa9hsQbRk61yvFho3SUrl1eHSsu/aMedOMzLJlzE3ngq0M+wu2dZ4wkRoqzWOZskJWHYHih+fzdb+ZL44qu9eMAacGn2elbnzhPajKKF4L8YwEH066Icp+tjZIXOhXiH5RboDjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N5DrrFP3GY0rn0msucravho/pzUgwwp1zcKHDpuhFDw=;
 b=bEYI5EwWtqvt5SwMfThVf2V10tDD/4YXSRG8RNF7ZkjS+Mh4Elt+1qcVBa3ZyF4ZiwZ1AFVOb2hOgL3R3O+DbWH6eOuNXWUi0rDwkk9niHzVzxXyQeg/9ToVMod1xaUrjR8zkYtvRpByppiinbJeOoYB+/qHNty6cOXtXfg+kqsH+h9Z0lHDuorq4oDOFJT8uJJCiYHeXZ1ACbEMcOg4SYTAkheQNkclQJw3cZPmHdhgPulwhnUZcJ9Y+PBBnVOKbjGzF2qykgnJJX7GsKN2tXaMUpt28DqtPMhxEOTw07Jep0iN3Tw7p94KdUOrpLIOkaQ0JbeBFkGshoc4fYvvaQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by IA1PR12MB6329.namprd12.prod.outlook.com
 (2603:10b6:208:3e5::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Fri, 20 Nov
 2026 17:52:07 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0639.010; Fri, 20 Nov 2026
 17:52:07 +0000
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
Subject: [PATCH v3 02/11] efi/libstub: Use free_addr/size as the arg to handle_kernel_image
Date: Fri, 20 Nov 2026 13:51:55 -0400
Message-ID: <2-v3-22d1a1eb7d2e+17de-arm64_drtm_jgg@nvidia.com>
In-Reply-To: <0-v3-22d1a1eb7d2e+17de-arm64_drtm_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: IA1P220CA0002.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:461::8) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: e1be3501-8468-4412-51a7-08df472efdda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|18002099003|6133799003|22082099003|261009223027099003|11063799006|261022115727099003|56012099006|921020|261026135527099003|261102123227099003|261028144727099003|261026140227099003|261021133027099003|261026121527099003|261022113327099003|261021121427099003|261021123027099003|261022105027099003|261022075727099003|261026130827099003|261021130227099003|261021135927099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	vZUxI33gdgPXs/cprGmgMR5E3GvjiUsJOoyv7BhrO2aWyWz7PyPltnU6IIrkV2uzYs1sYRQNy+iIWyYTFRitSVIdVeNn7vavtTs5VFkTUTePuyunkM46VJ1fm0juk2zpInCvHt3GHzwpDFTBR6J+Ysb4e0s8vXYpPu0ZyanslitMFRRAv37qpKPQmzcUoYvQhVJUht1JqOGcBq2ys4eoelwR8MZvMQzBYjkQ1pxFxv1M89sSgcLO+wnXtH57ITCmPbsobrEPH5j4T1CKIT6BMepvfS7fqK0e7qPUIqrOjU4UNqgkNSgICyoxBLrx7WyygAfMa+Npi7QH1FZ1G5wTTTCnO+nuSj/CPvKxCKdN1tsz5gk8J6VyUb7zUJO9RFSMsFUof0ihHdz/y+1kFG2A9zJ00KWz0dvXnZ/aGcgEso/CQEUhzYsnnZdyFnYqTtrsudgCCnu4AH8lULj19+hwwGZ/KlHeQOjDJomAnNdH+vgnzb4JlVB/I8vC2fJsTOhTdMLllFjBvNkXRgt5EJAakpMmik4DVVklQgISRZP8ERdC9IOxeQnzW3a+iiKbpZ927zrfXVIVJCtj9evCx4EEVm8v1mA1uQpZPW4lshhpb57IPRP3Z8wjCmkiDefpAJZcM7gkk/g5ElliQ0M6swx8ZT5NNfk2tsrEs3WyYWCTxcuHDEc9Y3MNRuzzVqjKG+VdNw2X/OUh0NW//YGzQr1zNQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(18002099003)(6133799003)(22082099003)(261009223027099003)(11063799006)(261022115727099003)(56012099006)(921020)(261026135527099003)(261102123227099003)(261028144727099003)(261026140227099003)(261021133027099003)(261026121527099003)(261022113327099003)(261021121427099003)(261021123027099003)(261022105027099003)(261022075727099003)(261026130827099003)(261021130227099003)(261021135927099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KBhRIqwEtqvfcyn97uHMOarNSYCfPI2vnJZHNbbkil/5wnZW/T2Z15czMXE+?=
 =?us-ascii?Q?4oTd1Ul1t/5mmudMwUD4sYREJVSTwwn985JKOjKaMU0bOaOslROdMn6lwec/?=
 =?us-ascii?Q?djfMXTOMTJR82C50h7ClMuV6YMfyy4O1O/LR2TiT4FlqIZX2jBQ0bIjJ0Ztg?=
 =?us-ascii?Q?zIgGBMeWmGkReYzT3X6Fcr+H3XhfFl9rE8aMQe5tUvwjqeIMPOUwCAqUOHni?=
 =?us-ascii?Q?dV5cHjPBxkbdiVGO7F1PCnIbjLioMAhD/Az40DYArapiwiTlcakTnAtJoe56?=
 =?us-ascii?Q?hpZLxJ5/DoPJqM8T4e8GD5FIX5/MYq94+7+FtGpDSCkXCWjvhX+1Y6EE/j87?=
 =?us-ascii?Q?HF5ZWPbnuyouiSkHUGctkb+SJSpVbH3k7zFUiHCxjxbj6CXt2jcpN7SgCO1E?=
 =?us-ascii?Q?zx7kBQoi8vL9xpKX1L3T5Lwqccy5bzGi8zIyBT21E1MiblCWAZVPjW9VrlMV?=
 =?us-ascii?Q?z7gsY3d5ImaTpaUqN1+98ULcZLIuHrqT3ovQojM7LNvbjPGjzzVDR3xfdkAo?=
 =?us-ascii?Q?KyuGrpN+f+h0wo33W2E0QGYtNObBARSJvmj9XO9vxlTRnjkjkpp+zbXb4rCo?=
 =?us-ascii?Q?c+hptdUYrTNxOj/Z1xWqj606EemBtOH2W1sFRR+yiboa4aG0Bw/jbAnbmthm?=
 =?us-ascii?Q?Jg4To+mXp5COG/BDO9c5T4vu3dngyWcWkQePrKMacJI3A//mS513vHGqcdSM?=
 =?us-ascii?Q?iuXkYrHPap72HS2pMxEX/JKEV24Y9aJE02azLaox/m2cC/qJg5kZ3+WNoa7h?=
 =?us-ascii?Q?zSbtEEBYbnpDx0ZG8/UsbKLScy0mhSC+jn4N6fO+OaNEH/SuFTQJgkg8csx1?=
 =?us-ascii?Q?06qeIGpUJ4/JNb9N1dRlc8dCZJLOgelC6Z5FR70pJbw4joDLbzVOAy3jVB9F?=
 =?us-ascii?Q?JfyZBGeUDD67wKGmybEqdFYPnlZEIlGCbTxKmo7aM6nxcsohrHu073aGIX4R?=
 =?us-ascii?Q?BF5VvIZb+vhtfSqIg0EYZ7B59RykzKOaWsgJNlYaG3F3kXcZ80jwDQ06YjHX?=
 =?us-ascii?Q?6/rlHA1OoYjHj1QhSqp3FCACKgk2U6Zu786sfaikALnyMqM8kn+PLN8sNZuY?=
 =?us-ascii?Q?IOgS2H+6k4gG+785mmY4e63zrr6+UdkZVUDIzpwx/5mNfQ97Q7JYAQRTfufK?=
 =?us-ascii?Q?m1zwlTgaPn1bb4Ackyo3BCts0h0/B0tNCntlcqfplsxQjA7wtgFpMv/CgV2M?=
 =?us-ascii?Q?7ClfXiRaxqCY9gz1L94vzcZhMLKUawFloLYSn8HMyaOPjodf/J75R4aMw09/?=
 =?us-ascii?Q?MvV7/qbmN4mxTxjqi5tkJDdf3Pek5q+TH2GVIXX2jwIDYlwVh+OI6610MvOI?=
 =?us-ascii?Q?BfcU+herMRzf7Y+lbmsHiyfMBsfaPlnSQhAyJxrbbW++o25A/u5YQffR2JDv?=
 =?us-ascii?Q?1Fjsys6wufLZCnfZ7/kaZldp6tuCp/5XsuFjEMvKi4lwnXWZv/WW4ADuf0eL?=
 =?us-ascii?Q?8Qxzh6hoUo6TGA5vjWF92tKe/UqfQW3Eutx+DXA3nN6W7PCdIszdb2GiIeGR?=
 =?us-ascii?Q?tiXK+fNpz+i+7ebs4IUPUoq6DmqZBc4LNK+FoXN8qmY9Si3qneGFgi+P5TY9?=
 =?us-ascii?Q?4USF5oBQAAVaXD2Q4uZsLa0f9diyiKqNxewso14ll35mTiuT+1d171gG6TvQ?=
 =?us-ascii?Q?TIiad47tvBwSAMsFz5h+ts708B2mgJmo5cMy/M5hOsWolb/KAluirB9HdCoJ?=
 =?us-ascii?Q?d7URBmY+/yuK4X/r8xYaDS/mrjhlaspyc7yUb55BaB/ZcKTD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1be3501-8468-4412-51a7-08df472efdda
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 17:52:06.5321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t8hIUdYsuzHhv5l0UEOX7r/xu8j5Ao42UjiG1lDLaydNh4+yEG0SVXCC136LJ5m0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6329

The only use for these values is to trigger a memory free if the boot is
aborted by efi_pe_entry(), make it clear through the call chain.

This cleanly allows them to be used to describe something that is not the
image in the next patch.

Reorganize efi_kaslr_relocate_kernel() with a efi_kaslr_copy_kernel()
helper as clang isn't able to grok the original control flow once
image_addr is only set by allocation.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/firmware/efi/libstub/arm32-stub.c     |  8 +-
 drivers/firmware/efi/libstub/arm64-stub.c     |  6 +-
 drivers/firmware/efi/libstub/efi-stub-entry.c |  8 +-
 drivers/firmware/efi/libstub/efistub.h        |  8 +-
 drivers/firmware/efi/libstub/kaslr.c          | 88 +++++++++++--------
 drivers/firmware/efi/libstub/loongarch-stub.c | 10 +--
 drivers/firmware/efi/libstub/riscv-stub.c     |  6 +-
 7 files changed, 73 insertions(+), 61 deletions(-)

diff --git a/drivers/firmware/efi/libstub/arm32-stub.c b/drivers/firmware/efi/libstub/arm32-stub.c
index 89e48ac0b7cbbe..b4c843e7f6b8fd 100644
--- a/drivers/firmware/efi/libstub/arm32-stub.c
+++ b/drivers/firmware/efi/libstub/arm32-stub.c
@@ -125,8 +125,8 @@ extern u32 zimage_magic_table[] asm("_table_start");
 
 struct efi_image_info efistub_image_info = {};
 
-efi_status_t handle_kernel_image(unsigned long *image_addr,
-				 unsigned long *image_size,
+efi_status_t handle_kernel_image(unsigned long *free_addr,
+				 unsigned long *free_size,
 				 efi_loaded_image_t *image,
 				 efi_handle_t image_handle,
 				 const struct efi_image_info **image_info)
@@ -173,8 +173,8 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 	efi_free(kernel_base - alloc_base, alloc_base);	/* no-op if 0 */
 	efi_free(alloc_base + margin - kernel_base, kernel_base + alloc_size);
 
-	*image_addr = kernel_base;
-	*image_size = alloc_size;
+	*free_addr = kernel_base;
+	*free_size = alloc_size;
 
 	return EFI_SUCCESS;
 }
diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
index 351fcb4493e19b..e0adc4de0beac3 100644
--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -13,8 +13,8 @@
 
 #include "efistub.h"
 
-efi_status_t handle_kernel_image(unsigned long *image_addr,
-				 unsigned long *image_size,
+efi_status_t handle_kernel_image(unsigned long *free_addr,
+				 unsigned long *free_size,
 				 efi_loaded_image_t *image,
 				 efi_handle_t image_handle,
 				 const struct efi_image_info **image_info)
@@ -30,7 +30,7 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 		efi_err("FIRMWARE BUG: kernel image not aligned on %dk boundary\n",
 			SEGMENT_ALIGN >> 10);
 
-	return efi_kaslr_relocate_kernel(image_addr, image_size, image_info,
+	return efi_kaslr_relocate_kernel(free_addr, free_size, image_info,
 					 efi_kaslr_get_phys_seed(image_handle));
 }
 
diff --git a/drivers/firmware/efi/libstub/efi-stub-entry.c b/drivers/firmware/efi/libstub/efi-stub-entry.c
index fd272d07737371..7febed273c8c08 100644
--- a/drivers/firmware/efi/libstub/efi-stub-entry.c
+++ b/drivers/firmware/efi/libstub/efi-stub-entry.c
@@ -21,8 +21,8 @@ efi_status_t __efiapi efi_pe_entry(efi_handle_t handle,
 	const struct efi_image_info *image_info = &efistub_image_info;
 	efi_loaded_image_t *image;
 	efi_status_t status;
-	unsigned long image_addr;
-	unsigned long image_size = 0;
+	unsigned long free_addr;
+	unsigned long free_size = 0;
 
 	WRITE_ONCE(efi_system_table, systab);
 
@@ -53,7 +53,7 @@ efi_status_t __efiapi efi_pe_entry(efi_handle_t handle,
 
 	efi_info("Booting Linux Kernel...\n");
 
-	status = handle_kernel_image(&image_addr, &image_size,
+	status = handle_kernel_image(&free_addr, &free_size,
 				     image, handle, &image_info);
 	if (status != EFI_SUCCESS) {
 		efi_err("Failed to relocate kernel\n");
@@ -62,7 +62,7 @@ efi_status_t __efiapi efi_pe_entry(efi_handle_t handle,
 
 	status = efi_stub_common(handle, image, image_info, cmdline_ptr);
 
-	efi_free(image_size, image_addr);
+	efi_free(free_size, free_addr);
 
 	return status;
 }
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index 80b9558f9f689a..e404f29693c51c 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -1187,8 +1187,8 @@ struct efi_image_info {
  * must be reserved. On failure it is required to free all
  * all allocations it has made.
  */
-efi_status_t handle_kernel_image(unsigned long *image_addr,
-				 unsigned long *image_size,
+efi_status_t handle_kernel_image(unsigned long *free_addr,
+				 unsigned long *free_size,
 				 efi_loaded_image_t *image,
 				 efi_handle_t image_handle,
 				 const struct efi_image_info **image_info);
@@ -1331,8 +1331,8 @@ const u8 *__efi_get_smbios_string(const struct efi_smbios_record *record,
 
 efi_status_t efi_remap_image(unsigned long image_base, unsigned alloc_size,
 			     unsigned long code_size);
-efi_status_t efi_kaslr_relocate_kernel(unsigned long *image_addr,
-				       unsigned long *alloc_size,
+efi_status_t efi_kaslr_relocate_kernel(unsigned long *free_addr,
+				       unsigned long *free_size,
 				       const struct efi_image_info **image_info,
 				       u32 phys_seed);
 u32 efi_kaslr_get_phys_seed(efi_handle_t image_handle);
diff --git a/drivers/firmware/efi/libstub/kaslr.c b/drivers/firmware/efi/libstub/kaslr.c
index 7cf68a6123946a..2f1f3e19583def 100644
--- a/drivers/firmware/efi/libstub/kaslr.c
+++ b/drivers/firmware/efi/libstub/kaslr.c
@@ -80,10 +80,30 @@ static bool check_image_region(u64 base, u64 size)
 	return false;
 }
 
+static void efi_kaslr_copy_kernel(unsigned long image_addr,
+				  unsigned long *free_addr,
+				  unsigned long *free_size,
+				  const struct efi_image_info **image_info)
+{
+	unsigned long kernel_base	= efistub_kernel_base(*image_info);
+	unsigned long kernel_size	= efistub_kernel_size(*image_info);
+	unsigned long kernel_codesize	= efistub_kernel_codesize(*image_info);
+	unsigned long kernel_memsize	= efistub_kernel_memsize(*image_info);
+
+	memcpy((void *)image_addr, (void *)kernel_base, kernel_size);
+	*free_addr = image_addr;
+	*free_size = kernel_memsize;
+
+	efi_icache_sync(image_addr, image_addr + kernel_codesize);
+	efi_remap_image(image_addr, kernel_memsize, kernel_codesize);
+
+	*(unsigned long *)image_info += image_addr - kernel_base;
+}
+
 /**
  * efi_kaslr_relocate_kernel() - Relocate the kernel (random if KASLR enabled)
- * @image_addr:		Pointer to variable carrying the image base address
- * @alloc_size:		Pointer to variable carrying the allocated size
+ * @free_addr:		Pointer to variable carrying the address to free
+ * @free_size:		Pointer to variable carrying the size to free
  * @image_info:		Pointer to struct efi_image_info pointer
  * @phys_seed:		Random seed used for the relocation
  *
@@ -93,16 +113,15 @@ static bool check_image_region(u64 base, u64 size)
  *
  * Return:	status code, EFI_SUCCESS if relocation is successful
  */
-efi_status_t efi_kaslr_relocate_kernel(unsigned long *image_addr,
-				       unsigned long *alloc_size,
+efi_status_t efi_kaslr_relocate_kernel(unsigned long *free_addr,
+				       unsigned long *free_size,
 				       const struct efi_image_info **image_info,
 				       u32 phys_seed)
 {
 	unsigned long kernel_base	= efistub_kernel_base(*image_info);
-	unsigned long kernel_size	= efistub_kernel_size(*image_info);
-	unsigned long kernel_codesize	= efistub_kernel_codesize(*image_info);
 	unsigned long kernel_memsize	= efistub_kernel_memsize(*image_info);
 	u64 min_kimg_align		= efi_get_kimg_min_align();
+	unsigned long image_addr;
 	efi_status_t status;
 
 	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE) && phys_seed != 0) {
@@ -111,43 +130,36 @@ efi_status_t efi_kaslr_relocate_kernel(unsigned long *image_addr,
 		 * locate the kernel at a randomized offset in physical memory.
 		 */
 		status = efi_random_alloc(kernel_memsize, min_kimg_align,
-					  image_addr, phys_seed,
+					  &image_addr, phys_seed,
 					  EFI_LOADER_CODE, 0, EFI_ALLOC_LIMIT);
-		if (status != EFI_SUCCESS)
-			efi_warn("efi_random_alloc() failed: 0x%lx\n", status);
-	} else {
-		status = EFI_OUT_OF_RESOURCES;
-	}
-
-	if (status != EFI_SUCCESS) {
-		if (!check_image_region(kernel_base, kernel_memsize)) {
-			efi_err("FIRMWARE BUG: Image BSS overlaps adjacent EFI memory region\n");
-		} else if (IS_ALIGNED(kernel_base, min_kimg_align) &&
-			   (kernel_base + kernel_memsize) < EFI_ALLOC_LIMIT) {
-			/*
-			 * Just execute from wherever we were loaded by the
-			 * UEFI PE/COFF loader if the placement is suitable.
-			 */
+		if (status == EFI_SUCCESS) {
+			efi_kaslr_copy_kernel(image_addr, free_addr, free_size,
+					      image_info);
 			return EFI_SUCCESS;
 		}
-
-		status = efi_allocate_pages_aligned(kernel_memsize, image_addr,
-						    ULONG_MAX, min_kimg_align,
-						    EFI_LOADER_CODE);
-
-		if (status != EFI_SUCCESS) {
-			efi_err("Failed to relocate kernel\n");
-			return status;
-		}
+		efi_warn("efi_random_alloc() failed: 0x%lx\n", status);
 	}
 
-	memcpy((void *)*image_addr, (void *)kernel_base, kernel_size);
-	*alloc_size = kernel_memsize;
+	/* Try to use the image in place */
+	if (!check_image_region(kernel_base, kernel_memsize)) {
+		efi_err("FIRMWARE BUG: Image BSS overlaps adjacent EFI memory region\n");
+	} else if (IS_ALIGNED(kernel_base, min_kimg_align) &&
+		   (kernel_base + kernel_memsize) < EFI_ALLOC_LIMIT) {
+		/*
+		 * Just execute from wherever we were loaded by the UEFI PE/COFF
+		 * loader if the placement is suitable.
+		 */
+		return EFI_SUCCESS;
+	}
 
-	efi_icache_sync(*image_addr, *image_addr + kernel_codesize);
-	efi_remap_image(*image_addr, kernel_memsize, kernel_codesize);
+	status = efi_allocate_pages_aligned(kernel_memsize, &image_addr,
+					    ULONG_MAX, min_kimg_align,
+					    EFI_LOADER_CODE);
+	if (status != EFI_SUCCESS) {
+		efi_err("Failed to relocate kernel\n");
+		return status;
+	}
 
-	*(unsigned long *)image_info += *image_addr - kernel_base;
-
-	return status;
+	efi_kaslr_copy_kernel(image_addr, free_addr, free_size, image_info);
+	return EFI_SUCCESS;
 }
diff --git a/drivers/firmware/efi/libstub/loongarch-stub.c b/drivers/firmware/efi/libstub/loongarch-stub.c
index df6749643bb8bd..d8886b9c74099d 100644
--- a/drivers/firmware/efi/libstub/loongarch-stub.c
+++ b/drivers/firmware/efi/libstub/loongarch-stub.c
@@ -89,8 +89,8 @@ efi_status_t efi_relocate_kernel(unsigned long *image_addr,
 	return status;
 }
 
-efi_status_t handle_kernel_image(unsigned long *image_addr,
-				 unsigned long *image_size,
+efi_status_t handle_kernel_image(unsigned long *free_addr,
+				 unsigned long *free_size,
 				 efi_loaded_image_t *image,
 				 efi_handle_t image_handle,
 				 const struct efi_image_info **image_info)
@@ -105,9 +105,9 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 	status = efi_relocate_kernel(&kernel_addr, kernel_fsize, kernel_asize,
 		     EFI_KIMG_PREFERRED_ADDRESS, efi_get_kimg_min_align(), 0x0);
 
-	*image_addr = kernel_addr;
-	*image_size = kernel_asize;
+	*free_addr = kernel_addr;
+	*free_size = kernel_asize;
 
-	*(unsigned long *)image_info += *image_addr - (unsigned long)image->image_base;
+	*(unsigned long *)image_info += kernel_addr - (unsigned long)image->image_base;
 	return status;
 }
diff --git a/drivers/firmware/efi/libstub/riscv-stub.c b/drivers/firmware/efi/libstub/riscv-stub.c
index 8cd0cd9b00486c..45a345c1701ffa 100644
--- a/drivers/firmware/efi/libstub/riscv-stub.c
+++ b/drivers/firmware/efi/libstub/riscv-stub.c
@@ -10,15 +10,15 @@
 
 #include "efistub.h"
 
-efi_status_t handle_kernel_image(unsigned long *image_addr,
-				 unsigned long *image_size,
+efi_status_t handle_kernel_image(unsigned long *free_addr,
+				 unsigned long *free_size,
 				 efi_loaded_image_t *image,
 				 efi_handle_t image_handle,
 				 const struct efi_image_info **image_info)
 {
 	efi_status_t status;
 
-	status = efi_kaslr_relocate_kernel(image_addr, image_size, image_info,
+	status = efi_kaslr_relocate_kernel(free_addr, free_size, image_info,
 					   efi_kaslr_get_phys_seed(image_handle));
 	if (status != EFI_SUCCESS)
 		efi_err("Failed to relocate kernel\n");
-- 
2.43.0

