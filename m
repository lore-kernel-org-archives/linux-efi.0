Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795197146;
	b=VrNsqwFyzdXem4Jfby1JKJdZNk4tYeR4u6+lohfgH1FIlG5kzahhPrbQvGlgsobJDQhw
	 eCW6zHoBQLMwWwDZ2OczMhWqYc1vp46PanC8BT+rB/Q1O8Wi9aydATd4ujbfAGXV2Io37
	 auN8WOSkp49swjd+/dM7rZdqKnDiQi6XjT8LQnbUJaiGi4nrQZ2XUrA55xx7j9BACJUSb
	 DRwCobrtyjBjSGaxWWy3wI3kATYJaUgpdPRp9R5j2SyafaC72YjcydiAzDwr9YvjpVFG6
	 IW2iRcOtyBTEH1+6YBwJiXI7Q6ukZNVypiZq28Y+C1U1IYdsTaU8JA2wrnQ6gG7hmPQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795197146;
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
	bh=Qi/b+wgcK3EeA9bK+Uh0ptogQoxwZ6ZskvoY/LYykkI=;
	b=euxfDlPlabEUZgjLqpAVbG549Z1WUk/SIv39HZKB/fGuWLwXc2+tlT58oE7FeucGqtNa
	 nEAfGSD6IvZLEl893aYnj/5GVdsKMU2VJD1pOFu3R3DnbR2gMWfeqHBtMN7lLycJ2fW75
	 y2lJIinkXDMEQ2ZPbqgtT+Tg3DId56uuhkx/tpAvu5457j3CNbCINNf8fU02x0OYdjMjU
	 Z5dD/an20slg7o1teM+Pd4UKDYYrxFb8uADjA4tN4FPaGBvYFmnrQGMUqEa9LZkucVaAG
	 UXQSDax0VJgMoJ0LM9K9UluGGzwMYOMSy186xUQNrqbI5MFy92u0OJ0vk8LI8V9B+ew==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=BdGjzEDm;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.28
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011028.outbound.protection.outlook.com [40.93.194.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F96606A333;
	Fri, 20 Nov 2026 17:52:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C9F96606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=BdGjzEDm
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NQSXW3PPCBY7pdGD0us1mzCEmJlNZZ6IDWgWjqHEbQ1umppziD9gSGfSQehMVOUQNIvcpYQ2xMi0qAnkWfc5BvbNYIIDGP2K7j9nOFc/C98HwFwvt1gzAyNnosLE8HkZnUti3N3fgaz/ktC33rp8BHRP50J1mn3G+yyt6TtOi86uKDSr42eMNDMehSY3MXP83wN1svNz3YCVUPq1mOmoR5OuaMz8dIurWBOwK2hEaQ55gnBO7LbXSCkItZRO/OVAPG0YdRUYbwbcTj2SjsJot6QxjLU+7NjPyu8oabc+65iNIyJGhgftQxz3NAib++6nkmQ+d00suyTg+6dTJl52EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qi/b+wgcK3EeA9bK+Uh0ptogQoxwZ6ZskvoY/LYykkI=;
 b=TEuOR5mWa/pKm5LP/Po1CtWzjojPLXIRFw36vyxo7WOsjgA3VBMn92UMufXAFOwYUxK3YxJRDaac8YLhFLJo4GfEcyqc92bvRR/a7zXagF2itOy+n3/q2NFV86PWqguJVJ4t4tX/n6wyh7s3LzutULo6PEZF+7wMDoylhtW7oGCsfDT7sjv6A5RreQ0LFXE89LHP55kOdxlZ/h9hwCO1EFNFkHotKJ9eH19ZQel3nxW5TRNKVF0o+kFK2dC6hqxsnUY18Sfn73vNBnqTX33aqFuZiUA3Y+8I8iHjs0fS3K3jvu3EWFTRlNIuvTY3egn3BSDu77wYjWP6WvRjkdbUMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qi/b+wgcK3EeA9bK+Uh0ptogQoxwZ6ZskvoY/LYykkI=;
 b=BdGjzEDmzkU4JUaLCFAKvapEHTHiBpkz3Y7Y3TDwV1nlxBHvyLogY5eSfhEP30z1dZqDp8uhTGtEJc+QRj8FfdDapMrCeeId8a8PgbC7SD51GRAG/DXa7X9hXtfu5cgLDjSNzN1IJ4X2AUt2jze5PXLqFXN6wi+KpynvKYhfvYr2lY6axwUvIOtARcETo1k1kXe3qkK4bb0pNa9udd9tGOOUMn69/ndrJCb4830dXbt335FdtfQC9VKLjgiVH3W+ddBhazHLl+hXs/pABkrQXIIsRVW1fnvTRK+jB5YLNk8x8t1+eSDhpGVuazHZ8rNxRP0OjJWRpjC+QmhhqIYwhw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by IA1PR12MB6329.namprd12.prod.outlook.com
 (2603:10b6:208:3e5::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Fri, 20 Nov
 2026 17:52:13 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0639.010; Fri, 20 Nov 2026
 17:52:13 +0000
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
Subject: [PATCH v3 10/11] efi/arm64: Add a way to detect if SMCC 1.1 can be used
Date: Fri, 20 Nov 2026 13:52:03 -0400
Message-ID: <10-v3-22d1a1eb7d2e+17de-arm64_drtm_jgg@nvidia.com>
In-Reply-To: <0-v3-22d1a1eb7d2e+17de-arm64_drtm_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR11CA0022.namprd11.prod.outlook.com
 (2603:10b6:208:23b::27) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 4f9d1e6e-a385-41b2-5e89-08df472efec3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|18002099003|22082099003|261009223027099003|11063799006|5023799004|56012099006|921020|261102123227099003|261028144727099003|261026140227099003|261026121527099003|261022113327099003|261021121427099003|261022105027099003|261022075727099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	0xCmH0E0znyEt7bEdUlA+8s1xnWG5tr+fZSBxaChhQOYRVsJI4cE1KsageNuLPggBtGWk4XEJ+WrTLNgclK6iqRHZhXvgSCpq71pA4+qXFhX36gKdU3xIvNSFtjGeRkQCFDTtHKF7qW//TrbzXIJspz6r3YWl2hGrUVvTjMwezK7HX84yiXZx3/aTehId3JAfwtXZQ/JGyzc2eQvD8KLTLF9nKAQOiXXuvWldhngGMv796fObu56vTiBkvrLrIM/pu48XX5WJRjrzwSKSn96ukefQtC7oWI+UjpuCiFqxsENC8YT4fsffdvcY8Qt3snWlj5yV0pduHUVGlaBmFFYDgxuV0XmWU/DMHxWVfevjAvCFbRH1R3EmfQStAfysCCzgiC/W0jkiWKLh2nbIkTkxqW0SSgynCDz0cco0Lv1sRRaH2Qwj5P1Oyd834NPyYVbbISXuHcsg5rH5iFnbybsZoydDXGRXPsIMK0pWOoYkCzRvNwj15AZAgNjunWD6jYRY1/jiILZ7lDsulFSiUdWxcoEoOspjAIYz3zXB+qYk3HKLaI/THSf3nPqejKVmdh1pyIRVgryEe7mWY/IgFUEZafbiUC5UZc9HYYG5bo0JJ4+kbJ7/y3Lnu8SId/6n6mxF/ZCI96Hq73UoZjrjt+NhWrURWgTw+0SuCBC0q4DGXKel4fOZCX1nhCgDIIIgl2o9cyj790qsv9IC31ZHy9opA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(18002099003)(22082099003)(261009223027099003)(11063799006)(5023799004)(56012099006)(921020)(261102123227099003)(261028144727099003)(261026140227099003)(261026121527099003)(261022113327099003)(261021121427099003)(261022105027099003)(261022075727099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uavxV/z5fLxt8+91JYwn7n/Qy9FJ6h/4LUlpXLiWK/+aZMxt7R0/WfZg0qwc?=
 =?us-ascii?Q?qJ4wfdUvbeADgzRQnvdpaVlJQUEvApoIrnIUWhGFAqH/BW5dSTUEn41eHFZ7?=
 =?us-ascii?Q?O1v10QJ8z4tp5sqBAEWuYszZf6g1+judXCuiMyoZPnFZ0F4UApJ5qyUsRyVn?=
 =?us-ascii?Q?xoNsdwBXT7q6MG7fyCt3Gi5Qnszzn+2uRa0hA0NYOIpf3p8KXI2+FuczQROX?=
 =?us-ascii?Q?A9v0iAwL/UmoOEBPzDSvZIkBZhJHLZqnhc9bBCJwm7vn8j/TukXrIJ25XvIH?=
 =?us-ascii?Q?zcPskrzNBl2MaGZDtEYsxxPRlhESJ3JesRDt7w6SGnpr7yb3ElR48hiZdt/y?=
 =?us-ascii?Q?+XVZrRvAR+Lvk9YnDA1X03IQnmtRV04KeBvYAcuMTjVPh9+xXc5ArZrWAdYD?=
 =?us-ascii?Q?wrZJzS+9TcK00rB4zMRwnZcGtQ1B0VaZBQZnEzCXs0u4H8FHm/RB6Uv6IC1h?=
 =?us-ascii?Q?e4L0nid6q5ER5ZvwHBy1xzd4RGQhTTE4EmOPnIbWEuDYiArsHK6RpsOGVATq?=
 =?us-ascii?Q?+y3FL6tvaQsWA1GOHprv+m6sbR09SoLK3v0uoNPOV+u7WbFdeqgLcpToOdx4?=
 =?us-ascii?Q?UG4OhD/Ayp+Ofl3vUUxm1zcRta0zD281zNvYLqKlmDL54Hv4AFYX2zzFhIli?=
 =?us-ascii?Q?KW5sDPH3W7x3OtrNInbReunUYE4TyllckC3nwbOgIA7FhnaJIWD9lDyWwuig?=
 =?us-ascii?Q?QZTLXnkyHxUUsHtEIDGPTb6qkgruI5XjyD1emqVn0SeY0Xq+d23OdDlsl03j?=
 =?us-ascii?Q?8vdUOeeuTbCcmAbhWQkR1Rjljd6/JM8a/jF489dT8FrhP73+HnyT8HPH8+pk?=
 =?us-ascii?Q?A0CnDDKpbE+rxpnfusvOR0YDrv955MES675ILq65GtnY3xzdT8TQkyNx7jn4?=
 =?us-ascii?Q?+Gkw2leJrK6Q7QQbZEifmnxA11a0WCC1i6XoCyLNHgbRZS7Cp0JTmHmqcY2R?=
 =?us-ascii?Q?XIpBaXKkgOZJnG8FjAbOwoeJLmostjTKRwDQBg6CcV0+82+z6CWEzeuWzJgc?=
 =?us-ascii?Q?icrsQ6VdH888zkf9mxX4/PCmWBd8QRtUpENHxjgBd0m+Iu0fOvhYxlqO8roX?=
 =?us-ascii?Q?XUjIEm1sW8mgMuGeGy+CNYnq1d1e554izR92tF2nYx66PrxGOBrmSEO7A10E?=
 =?us-ascii?Q?k7qy3arqjG8AAyf3PQiRD1yQyJila9gk8OXvW9VK00+hKR/E1ZmUGV50ONPD?=
 =?us-ascii?Q?b++im+kALgd4RqPiWa/8iYWFGofqWnvD9KzcF+p+xUa1OqJv0laspSXhIh9d?=
 =?us-ascii?Q?I7mks1HlXHEhXWka9oSp8Zbkw3lGak5iupANr/WYuR6OYN2mQV3FcAuION9q?=
 =?us-ascii?Q?OzS+m8cbVEz9DqQRwsKn2+N4R8heVBg5H4WJcy7ByHX4cjVQCk6BQFZvl811?=
 =?us-ascii?Q?1H+6RqKby5OFWawtMRowGX4ZIZl/heM/8/xpfzVABxxm2SoiztmQ5xlqXn0b?=
 =?us-ascii?Q?pIPeQDnnqVwL/kFhH+zFAmsIKHoDnWtdJLcEpxu/byiXUXkOKSmnVgYZSoqa?=
 =?us-ascii?Q?/fmnuPELHr9dVW/YXp5icm8WnIAgxBnBP2z0I7X7U9/5TJRG5XS1xPm2g2OB?=
 =?us-ascii?Q?eDj4LyA0PBUSafC16AldHfPXTaNgJ/IY1zigNQI9mv4twt93Oh9NE0pp5hYS?=
 =?us-ascii?Q?avtmDxBVwKVEyVYHXvCeXfQdwVNCnwTGfqfsa908/oN294eddWV1K+0dY9Cx?=
 =?us-ascii?Q?j6KPLIfMIuuytLAXCMZbvd5C5v61SK7eNL7oj7HWQCqmgkEU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f9d1e6e-a385-41b2-5e89-08df472efec3
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 17:52:08.2431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /41uejh2dUuKduDRq+XmeKs1U8BNxqQXqf8k1bfm5ZRqLMtP1lD4Q/e3BJcAs2lR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6329

DRTM is defined over SMCs, but if the stub blindly issues an SMC the
machine might crash. To do this safely and automatically, the stub has to
extract the ACPI_FADT_PSCI_COMPLIANT (without HVC) from the ACPI table,
then check with PSCI if SMCC 1.1 is supported

Implement a really basic ACPI walk down to the FACP and pull it out.  Be
strict about parsing the ACPI. Put it in the drtm file for now as it is
the only expected user.

Follow the overall design in the kernel and finish up with trying to call
ARM_SMCCC_VERSION_FUNC_ID like the kernel does.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/firmware/efi/libstub/Makefile     |   1 +
 drivers/firmware/efi/libstub/arm64-smcc.c | 212 ++++++++++++++++++++++
 drivers/firmware/efi/libstub/arm64-stub.h |   3 +
 3 files changed, 216 insertions(+)
 create mode 100644 drivers/firmware/efi/libstub/arm64-smcc.c
 create mode 100644 drivers/firmware/efi/libstub/arm64-stub.h

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index 207c8f99c5e299..2ae86429315e0e 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -85,6 +85,7 @@ lib-$(CONFIG_EFI_GENERIC_STUB)	+= efi-stub.o string.o intrinsics.o systable.o \
 
 lib-$(CONFIG_ARM)		+= arm32-stub.o
 lib-$(CONFIG_ARM64)		+= kaslr.o arm64.o arm64-stub.o smbios.o
+lib-$(CONFIG_ARM64_DRTM)	+= arm64-smcc.o
 lib-$(CONFIG_X86)		+= x86-stub.o smbios.o
 lib-$(CONFIG_X86_64)		+= x86-5lvl.o
 lib-$(CONFIG_RISCV)		+= kaslr.o riscv.o riscv-stub.o
diff --git a/drivers/firmware/efi/libstub/arm64-smcc.c b/drivers/firmware/efi/libstub/arm64-smcc.c
new file mode 100644
index 00000000000000..a722522e1af85e
--- /dev/null
+++ b/drivers/firmware/efi/libstub/arm64-smcc.c
@@ -0,0 +1,212 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2026, NVIDIA CORPORATION & AFFILIATES
+ *
+ * Determine if ARM64 can use SMCC 1.1 calls.
+ */
+#include <linux/acpi.h>
+
+#include <uapi/linux/psci.h>
+
+#include "efistub.h"
+#include "arm64-stub.h"
+
+static bool efi_acpi_checksum_valid(const void *table, u32 length)
+{
+	const u8 *p = table;
+	u8 checksum = 0;
+
+	/*
+	 * Nothing this code walks is remotely close to this large.  The length
+	 * fields are firmware supplied and are used to bound checksum loops, so
+	 * cap them to avoid checksumming forever if one is corrupt.
+	 */
+	if (length > SZ_1M)
+		return false;
+
+	while (length--)
+		checksum += *p++;
+
+	return checksum == 0;
+}
+
+static const struct acpi_table_fadt *
+efi_acpi_find_fadt(const struct acpi_table_xsdt *xsdt)
+{
+	u32 nr_entries;
+	u32 i;
+
+	nr_entries = (xsdt->header.length -
+		      offsetof(struct acpi_table_xsdt, table_offset_entry)) /
+		     sizeof(xsdt->table_offset_entry[0]);
+	for (i = 0; i < nr_entries; i++) {
+		u64 address = xsdt->table_offset_entry[i];
+		const struct acpi_table_header *table;
+
+		if (!address)
+			continue;
+
+		table = (const void *)address;
+		if (!memcmp(table->signature, ACPI_SIG_FADT,
+			    sizeof(table->signature)))
+			return (const void *)table;
+	}
+
+	return NULL;
+}
+
+/**
+ * efi_arm64_smc_conduit_available() - Discover an advertised SMC conduit
+ *
+ * Very lightly parse the ACPI tables to reach FADT. The goal is to parse things
+ * that are valid and fail off for odd looking stuff. The checksums are used to
+ * double check the limited parsing hasn't gone off the rails.
+ *
+ * Return: true only if a valid ACPI 2.0-or-newer table hierarchy contains a
+ * FADT advertising PSCI over SMC.  This establishes that issuing an SMCCC SMC
+ * is permitted
+ */
+static bool efi_arm64_smc_conduit_available(void)
+{
+	const struct acpi_table_fadt *fadt;
+	const struct acpi_table_xsdt *xsdt;
+	const struct acpi_table_rsdp *rsdp;
+	u32 length;
+	u16 flags;
+
+	rsdp = get_efi_config_table(ACPI_20_TABLE_GUID);
+	if (!rsdp) {
+		efi_debug(
+			"DRTM: ACPI 2.0 RSDP is unavailable; SMC conduit is unknown\n");
+		return false;
+	}
+
+	if (memcmp(rsdp->signature, ACPI_SIG_RSDP, sizeof(rsdp->signature))) {
+		efi_err("DRTM: ACPI RSDP signature is invalid\n");
+		return false;
+	}
+
+	if (rsdp->revision < 2) {
+		efi_err("DRTM: ACPI RSDP revision does not provide an XSDT\n");
+		return false;
+	}
+
+	length = rsdp->length;
+	if (length < sizeof(*rsdp)) {
+		efi_err("DRTM: ACPI RSDP length is invalid\n");
+		return false;
+	}
+	if (!efi_acpi_checksum_valid(rsdp, offsetof(struct acpi_table_rsdp,
+						    length))) {
+		efi_err("DRTM: ACPI RSDP legacy checksum is invalid\n");
+		return false;
+	}
+
+	if (!efi_acpi_checksum_valid(rsdp, length)) {
+		efi_err("DRTM: ACPI RSDP extended checksum is invalid\n");
+		return false;
+	}
+
+	xsdt = (const void *)rsdp->xsdt_physical_address;
+	if (!xsdt) {
+		efi_err("DRTM: ACPI RSDP does not provide an XSDT\n");
+		return false;
+	}
+
+	if (memcmp(xsdt->header.signature, ACPI_SIG_XSDT,
+		   sizeof(xsdt->header.signature))) {
+		efi_err("DRTM: ACPI XSDT signature is invalid\n");
+		return false;
+	}
+
+	length = xsdt->header.length;
+	if (length < offsetof(struct acpi_table_xsdt, table_offset_entry) ||
+	    (length - offsetof(struct acpi_table_xsdt, table_offset_entry)) %
+		    sizeof(xsdt->table_offset_entry[0])) {
+		efi_err("DRTM: ACPI XSDT length is invalid\n");
+		return false;
+	}
+	if (!efi_acpi_checksum_valid(xsdt, length)) {
+		efi_err("DRTM: ACPI XSDT checksum is invalid\n");
+		return false;
+	}
+
+	fadt = efi_acpi_find_fadt(xsdt);
+	if (!fadt) {
+		efi_err("DRTM: ACPI XSDT does not contain a FADT\n");
+		return false;
+	}
+
+	length = fadt->header.length;
+
+	/*
+	 * No FADT revision check is needed, the Arm boot flags land on bytes
+	 * that every pre-5.1 revision defines as reserved and zero, which
+	 * simply reads back as 'no PSCI'.
+	 */
+	if (length < offsetofend(struct acpi_table_fadt, arm_boot_flags)) {
+		efi_debug("DRTM: ACPI FADT does not contain Arm boot flags\n");
+		return false;
+	}
+	if (!efi_acpi_checksum_valid(fadt, length)) {
+		efi_err("DRTM: ACPI FADT checksum is invalid\n");
+		return false;
+	}
+
+	flags = fadt->arm_boot_flags;
+	if (!(flags & ACPI_FADT_PSCI_COMPLIANT)) {
+		efi_debug("DRTM: ACPI FADT does not advertise PSCI\n");
+		return false;
+	}
+
+	if (flags & ACPI_FADT_PSCI_USE_HVC) {
+		efi_debug(
+			"DRTM: ACPI FADT advertises PSCI over HVC, not SMC\n");
+		return false;
+	}
+
+	return true;
+}
+
+/*
+ * Discovery must tolerate SMCCC 1.0 clobbering x0-x17. The EFI stub cannot
+ * call the kernel's out-of-line SMCCC helper, so issue these calls inline.
+ */
+static u32 efi_arm64_smc_1_0(u32 function, u32 arg)
+{
+	register unsigned long x0 asm("x0") = function;
+	register unsigned long x1 asm("x1") = arg;
+
+	asm volatile("smc #0"
+		     : "+r" (x0), "+r" (x1)
+		     :
+		     : "x2", "x3", "x4", "x5", "x6", "x7", "x8", "x9",
+		       "x10", "x11", "x12", "x13", "x14", "x15", "x16",
+		       "x17", "cc", "memory");
+
+	return x0;
+}
+
+/* True if SMCCC 1.1 or later in the 1.x series is available. */
+bool efi_arm64_smccc_1_1(void)
+{
+	u32 version;
+	s32 status;
+
+	if (!efi_arm64_smc_conduit_available())
+		return false;
+
+	version = efi_arm64_smc_1_0(PSCI_0_2_FN_PSCI_VERSION, 0);
+	if ((s32)version < 0)
+		return false;
+
+	if (PSCI_VERSION_MAJOR(version) < 1)
+		return false;
+
+	status = efi_arm64_smc_1_0(PSCI_1_0_FN_PSCI_FEATURES,
+				   ARM_SMCCC_VERSION_FUNC_ID);
+	if (status < 0)
+		return false;
+
+	version = efi_arm64_smc_1_0(ARM_SMCCC_VERSION_FUNC_ID, 0);
+	return (version >> 16) == 1 && version >= ARM_SMCCC_VERSION_1_1;
+}
diff --git a/drivers/firmware/efi/libstub/arm64-stub.h b/drivers/firmware/efi/libstub/arm64-stub.h
new file mode 100644
index 00000000000000..f55e56ecd305bd
--- /dev/null
+++ b/drivers/firmware/efi/libstub/arm64-stub.h
@@ -0,0 +1,3 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+bool efi_arm64_smccc_1_1(void);
-- 
2.43.0

