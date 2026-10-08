Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013021.outbound.protection.outlook.com [40.93.196.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E87049EC51;
	Thu,  8 Oct 2026 13:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791465961; cv=fail; b=agvH3Tu7b72Sd3RjoY5I1ULo8CvlANpAOlWy+cLpXVgAoWF3gj2N/mNrCxfsDWZAYMgdR4BbgwJ8tDaowjeUHZvZzQc/6kqECYGH8TqMT8NPl2yhQNL2kod/JkIkcFF+Vkzsc6GcgprEjvzt44Rv8w+Qm/KmT+2uQRzKAXsVnb0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791465961; c=relaxed/simple;
	bh=ahEQHTFgZm7ZReBzulzoxTKNABk98taU0DOCf7SrG+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XW/4uo6SYhewPJLC8ol8MNp1FaSKG1TrdKEe1PmljfnZsDr6Ex7hNWS64PCT2LzcvPQuLnbsACALR9BU+sGshN8x8lIj+3kqzp5Nua7W4AH9C4TN4yjjIAUNJzLFUM7mETDdUxBWANEb2/BUP4U/+TWPxQlqxgNy95eVVex+b0o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UEKNwQ/0; arc=fail smtp.client-ip=40.93.196.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UEKNwQ/0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ahWqw2N5GTosQz/rtxieWzuQ5zH9xb+2wsWGGMut1PXW1LpNOKklCTQ65p3tD6TACxZIv9uBfS0ngPWnBEjywnqK2OH+usI9aIKZhG7Nb8z4yko/Eh/ryfNIhVF4BRzJITZhVJmH2IUJ5ZAmuNB2bbYnjSbGYu00eBWW7cQwIDsYoLAx13VqicpgOL5M4UkCL/iL1XVoJoIDYllz6eBtB1LNJi297mrvg1NrfH7zopzXeZXGa8akd5SpPXlWqRTjg3Ck1kGzvxRyO/ZwKAcJ2DDOkW+ozdoatGR8w/zW/gELDPIL0ms+bQnVON5OrdrXT3kKySaOevLa/J2molmWwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hUNA8irsPS+njPCR8/PdqOYDoTClkjwsPRYdbYX9Hp0=;
 b=VawIcccnY+5ElfyOyzw2xQbfbZWbd3TRoJnZ6xojNqtyICkW2zT9+xGeP2Cjqn7zulZJ+x5VM0dENNzklkkn6z+7wNN9MCz8acRecVyBO2MwpKADyd3EdULee8dGv503MdrN8xBcuYWW1hgGK3Pxm4ZdqeQd7v/yQEqRHf1JxQ81g4si4EF6rCnfT6Hrd3Y7j4qrxq3tTExEWSCMa/zcyUlXMc3qDljJ+IOpXyBy+qdyfTTXJQ8t/l46KRmBvQg/d1X4tgJnUF4jv5rfrwFIgam4f+bP5LqmLTuaR1bpaLhxCu8ED5qZF+OLJ8KMsk2NJGWFpicjENc6yQ4Hf6+WbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hUNA8irsPS+njPCR8/PdqOYDoTClkjwsPRYdbYX9Hp0=;
 b=UEKNwQ/0al1VhC/IBpcKTBURZUrBvWcUJbDz/jWM2LejruhnmKqTPmc7fy8d127THq9CFOC7R8mjSQKZ/gEH0TnKa5HlC3oixZEvG2Uhu7PM0tdfBeHsx2cPI0T5jR973Yao5HUTDJcaWskXg2TADWhq0ul7rrfpoE4nkaImr/JejtFrHjoueXoUs3DbIBsLFAs96/lvfam/wycpq742Lr0j904iVxdOgw7m2JK8JxpTcIIL21WvV0HQZDL722cRVsCA1VFccQ1IVzamLRS68tNQMVryc7D7hSp3XCbjqU8nSpa+xWLQDUlcFkCGxfp2LG7hCCp/9maytAKYsWCLQA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH8PR12MB9741.namprd12.prod.outlook.com (2603:10b6:610:27a::21)
 by DS4PR12MB9796.namprd12.prod.outlook.com (2603:10b6:8:2a2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.17; Thu, 8 Oct
 2026 13:25:49 +0000
Received: from CH8PR12MB9741.namprd12.prod.outlook.com
 ([fe80::43a6:8d0:7081:65d7]) by CH8PR12MB9741.namprd12.prod.outlook.com
 ([fe80::43a6:8d0:7081:65d7%5]) with mapi id 15.21.0472.016; Thu, 8 Oct 2026
 13:25:49 +0000
From: Matthew Garrett <matthewg@nvidia.com>
To: mjg59@srcf.ucam.org
Cc: keyrings@vger.kernel.org,
	James.Bottomley@HansenPartnership.com,
	linux-integrity@vger.kernel.org,
	rafael@kernel.org,
	linux-pm@vger.kernel.org,
	linux-efi@vger.kernel.org,
	Matthew Garrett <matthewg@nvidia.com>
Subject: [PATCH 02/17] efi: Add a mechanism to modify TPM state depending on kernel security features
Date: Thu,  8 Oct 2026 06:20:18 -0700
Message-ID: <20261008132532.1155166-3-matthewg@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261008132532.1155166-1-matthewg@nvidia.com>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0092.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cb::13) To CH8PR12MB9741.namprd12.prod.outlook.com
 (2603:10b6:610:27a::21)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH8PR12MB9741:EE_|DS4PR12MB9796:EE_
X-MS-Office365-Filtering-Correlation-Id: fa0f6946-3e53-41e5-b03e-08df253fab3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|6133799003|22082099003|18002099003|10067099003|3023799007|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	yZbOP1SY4ktF8dJPTgm4FrL7XIlBmtfwJj/TjIcmGnuoPD3n+nM49JccU5QDfkHU3ibxPfBaRnmCIcgEuftjP+9iNDLBBREfHP4mW/9oegih/HEfsXAUxT1GPlAUw7Jlcpkp692RKtRcLO0TGISsqMluQ/yEHPcaC+M68YBKF/fdKahLnb3mv8ym+zUV75CJQZDiyEMKT9jhcaHKCnxYDeB6bjo+igIZbtDnZ6VVsIzxoBeBbqnDCSW0UEiIYRAkJotO+zczlbNrTeRlg/5SOiZdo3DgzaAkTwUDqQZnDJtUZQClG2Jml1PLT3Ppf/v7g0rTbYRZFPHgJblM3E+gNa/7tm+hwBQKuDhJaCX+5zGTIJb8TVzhGcJQnLbXJS7j9dDeQmgcPdUDjtItvqv7F4BhDg7bHRDA7IjMDSi9KmjAdOz3pvrlpZ5lQZ0+dpN0KMiLRdLOqMPnNaLmXkXWNyeT96fom9EKWWSMQaNS9pMwEjq/jezQTzQVEJhrBCKO6ksw1PS5ngcPJDg/3in/DowF0xCABhQXeEZzeF9zu/xYjy19zCpGOQMNOOqKP+07kyd70lk9iFmMWm/Kh2gCMUxyFCAKLVWixkSqX8aRQPOeO+G9iSK/28SqJl+ybD5QK97W4TnTzpaNGUSuht7aNHTpxu6r3BabORMHC09IYf0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH8PR12MB9741.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(6133799003)(22082099003)(18002099003)(10067099003)(3023799007)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LXWoetXzMT14jqHuUfBYp7ZU7Coiu8zZiQ08fCozfJSoJ3x/MoQFnocffm0p?=
 =?us-ascii?Q?9Z9+176aQwK+0yxRyAI6eR6YafrZnUfNtoFfzERcYIjNOhHG1n55sC5BG7Kh?=
 =?us-ascii?Q?Jsyw9p6BC8n29FwY9/r87JX0viUGl6/hQruQaexqS7xcwbfPDLbWc0ackKoJ?=
 =?us-ascii?Q?lU6Vfae7eOAvUrRGOOccjFCfbjmjnlm65VkcpZCE4jODBrXq/U38qHlCv3nx?=
 =?us-ascii?Q?CHhgmWERmUj7dJLSFrlzGQBxlk+YFlZTIpU718xLrRBwC0BmqV/NCAjJ9J4V?=
 =?us-ascii?Q?4sUgL+snhzrDNfkyiPFksoL5PzazqKneCMXcYvbkTqZ4GAOD06Jt+gEXoYz2?=
 =?us-ascii?Q?aHOWsDYis5H8LsI9s1GKaIXtavRo2TqMhrMePix4cfRBXKNT5/CteJf3gthp?=
 =?us-ascii?Q?z7QQiWVpc4d6C5yMraWifNt9sDcOHqI4DKdQeWYSCo8Z2fDJf2kSwYB1NqAi?=
 =?us-ascii?Q?XzSShk7dQcKICvtip+whyBukr/jn6f0DOrNCzoQe+do8hgm6LYdw6gH+jW7n?=
 =?us-ascii?Q?wtzCjfTIBJ3y2hKdNZdla2axUK63hGJKrkC7Htx/nbx6eksHkbH37MvLe6Aq?=
 =?us-ascii?Q?xKR8hYPFKv8JNUMnDUalmB/wm/GYrv5WxpKEEI2exYA1Ig0eUMz/6Q2vdAkP?=
 =?us-ascii?Q?uOsjrIf/IFNy9imSPG2xR2v3AV8NhQcrm8K+EYML1pED/oIo6UcqWdJlcd5I?=
 =?us-ascii?Q?MMfm2leAebe5cjrEOvO+5jZ1t6aUcFIGehFlPkcRbDuWa3js35OikOFtkSN+?=
 =?us-ascii?Q?iKOXfm5vJXn12M0gdNXx9jvKvsmSvRbaPfkc3oybLlAtE/tcj0UWWnce/3LR?=
 =?us-ascii?Q?e1woLD30X5soQaEWWEuRt36QwZCew7AKv7a7kDgYg3ol4luErbuewj+HagrF?=
 =?us-ascii?Q?Ze09StUmKTTp8p8S5grgb1v2Kmttwmqjyqd0EYFhwg8WOI4ufPb4fHxnxoYm?=
 =?us-ascii?Q?kyZbbkVe3NV1xwV94ghZ+DnNYWtXmKiszj4My3ffrmdwOzeXX+Tie8QGl24g?=
 =?us-ascii?Q?1HpSx1zjsBQDG19/NZeQas0IzndDqduProNq5lM89PUH0XBt9NmIhXkg6Eba?=
 =?us-ascii?Q?Pen5wMVKAgTvELOhwQnj73ZfC9w9gbJ64bmtS+EIecN1sqcHxhDITY6d/mzH?=
 =?us-ascii?Q?sR3OVmFQ4jUqXcvvXauFiPGmjKFxrrrvgyRQnVpAU/xsprY/9mw2l8UC/h5H?=
 =?us-ascii?Q?5lKO2/OpM9lnzFsKv5ekutjPP7D7KS35lV2W+EZ1TkjV0BUZ4e4hQ1azlymb?=
 =?us-ascii?Q?CQYcRoTylOkbUjHTJlnYXpmtnBHx/YoVFRfqG+OlcbX7WJAXl3O1FHFqfNHn?=
 =?us-ascii?Q?uAYQ3ZKZXFgZmU4RpZ60wVzpnVlBJdkvuRJ+xpx3Rog1HPXdyGRAF2M2c7YK?=
 =?us-ascii?Q?x7E3J9nYvR36LgA7SzMySCR8ayOo2TBLYXI8NGAYBVPJLz8X5sokIo5nwkXQ?=
 =?us-ascii?Q?rl1IRkS926KTrk1UwCM3VpfE4DGpnHUFrjgJxbpbKN/eBxPr5debn28I0JsI?=
 =?us-ascii?Q?4+Y0FdAIn77zYxlnfjHpk1EP/0H+2MqkVrYeBQoH2CdQX+HMu/B8gZpo8JLJ?=
 =?us-ascii?Q?jW1O47Bu1ZtXoUlmhhbHpIJVi0Kmu2B2jmTwjp1HpAdzVvVT3zcCHywbkKo1?=
 =?us-ascii?Q?7EcSIkpLEO4+xrMprr3YPoykvaXRTPin3wKnn8hXbLR13jIkQ+VfJfLHaKL7?=
 =?us-ascii?Q?UiWvS8aZ1shEHjX9+pz2syKfqg4D3NJ81Cl7j2WalKRRT+PeTg1Bprs7u+nc?=
 =?us-ascii?Q?lTZC8epMXw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa0f6946-3e53-41e5-b03e-08df253fab3e
X-MS-Exchange-CrossTenant-AuthSource: CH8PR12MB9741.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 13:25:49.7888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: epilnhhHas8g5kog8pEjX3Xt7Y9cIfuY4VeyUVw68dhc5vAoeJXqcgPb9X5+/73x5Ht0Q0JBrQERNhSvNtpuNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9796

"tpm: Define a kernel-owned TPM NV index that can't be modified by
userland" adds support for restricting a TPM NV index to kernel use,
allowing us to perform TPM operations in-kernel that can be proven to be
owned by the kernel. But previous kernels didn't implement this
restriction, and so an identical proof can be generated by booting an
old kernel and setting up this NV index in userland. We need some way to
differentiate these situations, which means we need some way to change the
TPM state in a way that userland can't mimic.

Thankfully the combination of the TCG specification and our EFI boot
stub give us a mechanism to achieve this. The EFI boot stub runs before
ExitBootServices is called, and ExitBootServices is (according to the
spec) supposed to extend PCR 5. If we perform an extension of PCR 5
before ExitBootServices is called, our extension will be followed by the
ExitBootServices extension before any userland code runs. Userland code
on an old kernel will be able to perform the same extension, but only
after ExitBootServices is called, and so will end up with a different
PCR 5 value because the order of extension events matters.

Obviously this depends on the platform actually extending PCR 5 on
ExitBootServices, which is something we can't fundamentally depend on
because firmware. So, let's be careful. After performing the extension,
read the SHA 1 and SHA 256 banks (because we can't guarantee the
firmware is using both) and put those in a config table to pass up to
the runtime kernel. It can then read these values and read PCR 5. If the
values are identical then the firmware didn't perform an extension and
userland could fake the same setup, so flag this as a firmware bug and
don't enable anything. If the firmware only extended one bank then
that's still sufficient - we will end up having to rely on that single
bank, but that's still sufficient to demonstrate that we're on a new
kernel (at least, until SHA 1 is broken more than it currently is).

Signed-off-by: Matthew Garrett <matthewg@nvidia.com>
---
 drivers/firmware/efi/Kconfig                  |  15 ++
 drivers/firmware/efi/Makefile                 |   1 +
 drivers/firmware/efi/efi.c                    |   3 +
 .../firmware/efi/libstub/efi-stub-helper.c    |   6 +
 drivers/firmware/efi/libstub/efistub.h        |  10 +-
 drivers/firmware/efi/libstub/tpm.c            | 170 ++++++++++++++++++
 drivers/firmware/efi/tpm-security.c           |  98 ++++++++++
 include/linux/efi.h                           |  24 +++
 8 files changed, 326 insertions(+), 1 deletion(-)
 create mode 100644 drivers/firmware/efi/tpm-security.c

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 29e0729299f5..c411fd4b6c93 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -180,6 +180,21 @@ config RESET_ATTACK_MITIGATION
 	  have been evicted, since otherwise it will trigger even on clean
 	  reboots.
 
+config KERNEL_TPM_SECURITY
+	bool "Prove that the kernel supported certain security features"
+	depends on EFI_STUB && TCG_TPM_KERNEL_NVINDEX=y
+	help
+	  Have the EFI stub extend a fixed value into TPM PCR 5 in order to
+	  indicate that the kernel implements specific security
+	  functionality. This depends on the firmware extending PCR 5 when
+	  ExitBootServices is called - a failure to do this by the firmware
+	  will be logged.
+
+	  At present, this feature proves that the kernel implements kernel
+	  NV index reservation.
+
+	  If unsure, say N.
+
 config EFI_RCI2_TABLE
 	bool "EFI Runtime Configuration Interface Table Version 2 Support"
 	depends on X86 || COMPILE_TEST
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index 8efbcf699e4f..79f7a2c977f1 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -30,6 +30,7 @@ obj-$(CONFIG_EFI_RCI2_TABLE)		+= rci2-table.o
 obj-$(CONFIG_EFI_EMBEDDED_FIRMWARE)	+= embedded-firmware.o
 obj-$(CONFIG_LOAD_UEFI_KEYS)		+= mokvar-table.o
 obj-$(CONFIG_OVMF_DEBUG_LOG)		+= ovmf-debug-log.o
+obj-$(CONFIG_KERNEL_TPM_SECURITY)	+= tpm-security.o
 
 obj-$(CONFIG_SYSFB)			+= sysfb_efi.o
 
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 0327a39d31fa..f8e2ecca9102 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -648,6 +648,9 @@ static const efi_config_table_type_t common_tables[] __initconst = {
 #endif
 #ifdef CONFIG_EFI_GENERIC_STUB
 	{LINUX_EFI_PRIMARY_DISPLAY_TABLE_GUID,	&primary_display_table			},
+#endif
+#ifdef CONFIG_KERNEL_TPM_SECURITY
+	{LINUX_EFI_PCR5_LOG_GUID,		&efi_pcr5_log,		"PCR5"		},
 #endif
 	{},
 };
diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index f27f2e1f0019..996313f59827 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -435,6 +435,12 @@ efi_status_t efi_exit_boot_services(void *handle, void *priv,
 	if (efi_disable_pci_dma)
 		efi_pci_disable_bridge_busmaster();
 
+	/*
+	 * This installs a configuration table, so must happen before the
+	 * final memory map is retrieved.
+	 */
+	efi_tpm_record_pcr5();
+
 	status = efi_get_memory_map(&map, true);
 	if (status != EFI_SUCCESS)
 		return status;
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index fd91fc15ec81..e4012bce6013 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -862,6 +862,7 @@ typedef u32 efi_tcg2_event_log_format;
 #define INITRD_EVENT_TAG_ID 0x8F3B22ECU
 #define LOAD_OPTIONS_EVENT_TAG_ID 0x8F3B22EDU
 #define EV_EVENT_TAG 0x00000006U
+#define EV_EFI_ACTION 0x80000007U
 #define EFI_TCG2_EVENT_HEADER_VERSION	0x1
 
 struct efi_tcg2_event {
@@ -898,7 +899,8 @@ union efi_tcg2_protocol {
 							       efi_physical_addr_t,
 							       u64,
 							       const efi_tcg2_event_t *);
-		void *submit_command;
+		efi_status_t (__efiapi *submit_command)(efi_tcg2_protocol_t *,
+							u32, u8 *, u32, u8 *);
 		void *get_active_pcr_banks;
 		void *set_active_pcr_banks;
 		void *get_result_of_set_active_pcr_banks;
@@ -1169,6 +1171,12 @@ efi_enable_reset_attack_mitigation(void) { }
 
 void efi_retrieve_eventlog(void);
 
+#ifdef CONFIG_KERNEL_TPM_SECURITY
+void efi_tpm_record_pcr5(void);
+#else
+static inline void efi_tpm_record_pcr5(void) { }
+#endif
+
 struct sysfb_display_info *alloc_primary_display(void);
 struct sysfb_display_info *__alloc_primary_display(void);
 void free_primary_display(struct sysfb_display_info *dpy);
diff --git a/drivers/firmware/efi/libstub/tpm.c b/drivers/firmware/efi/libstub/tpm.c
index a5c6c4f163fc..f03490a6a544 100644
--- a/drivers/firmware/efi/libstub/tpm.c
+++ b/drivers/firmware/efi/libstub/tpm.c
@@ -9,6 +9,8 @@
  */
 #include <linux/efi.h>
 #include <linux/tpm_eventlog.h>
+#include <crypto/sha1.h>
+#include <crypto/sha2.h>
 #include <asm/efi.h>
 
 #include "efistub.h"
@@ -194,3 +196,171 @@ void efi_retrieve_eventlog(void)
 	efi_retrieve_tcg2_eventlog(version, log_location, log_last_entry,
 				   truncated, final_events_table);
 }
+
+#ifdef CONFIG_KERNEL_TPM_SECURITY
+#define PCR5_INDEX	5
+
+static const char pcr5_event[] = "Linux kernel TPM NVIndex support";
+static efi_guid_t pcr5_guid = LINUX_EFI_PCR5_LOG_GUID;
+
+static const struct {
+	u16	hash_alg;
+	u16	digest_size;
+} pcr5_banks[] = {
+	{ TPM_ALG_SHA1,		SHA1_DIGEST_SIZE },
+	{ TPM_ALG_SHA256,	SHA256_DIGEST_SIZE },
+};
+
+struct tpm2_pcr_read_cmd {
+	__be16	tag;
+	__be32	size;
+	__be32	cc;
+	__be32	count;
+	__be16	hash;
+	u8	size_of_select;
+	u8	select[3];
+} __packed;
+
+/* digest is sized for the largest bank; smaller digests are shorter */
+struct tpm2_pcr_read_rsp {
+	__be16	tag;
+	__be32	size;
+	__be32	rc;
+	__be32	update_counter;
+	__be32	count;
+	__be16	hash;
+	u8	size_of_select;
+	u8	select[3];
+	__be32	digest_count;
+	__be16	digest_size;
+	u8	digest[TPM2_MAX_DIGEST_SIZE];
+} __packed;
+
+static efi_status_t efi_tpm_extend_pcr5(efi_tcg2_protocol_t *tcg2)
+{
+	struct efi_tcg2_event *evt __free(efi_pool) = NULL;
+	u32 size = sizeof(*evt) + sizeof(pcr5_event) - 1;
+	efi_status_t status;
+
+	status = efi_bs_call(allocate_pool, EFI_LOADER_DATA, size,
+			     (void **)&evt);
+	if (status != EFI_SUCCESS)
+		return status;
+
+	*evt = (struct efi_tcg2_event){
+		.event_size			= size,
+		.event_header.header_size	= sizeof(evt->event_header),
+		.event_header.header_version	= EFI_TCG2_EVENT_HEADER_VERSION,
+		.event_header.pcr_index		= PCR5_INDEX,
+		.event_header.event_type	= EV_EFI_ACTION,
+	};
+	memcpy(evt + 1, pcr5_event, sizeof(pcr5_event) - 1);
+
+	return efi_call_proto(tcg2, hash_log_extend_event, 0,
+			      (unsigned long)pcr5_event,
+			      sizeof(pcr5_event) - 1, evt);
+}
+
+static efi_status_t efi_tpm_read_pcr5(efi_tcg2_protocol_t *tcg2,
+				      u16 hash_alg, u16 digest_size,
+				      struct tpm2_pcr_read_rsp *rsp)
+{
+	struct tpm2_pcr_read_cmd cmd = {
+		.tag		= cpu_to_be16(TPM2_ST_NO_SESSIONS),
+		.size		= cpu_to_be32(sizeof(cmd)),
+		.cc		= cpu_to_be32(TPM2_CC_PCR_READ),
+		.count		= cpu_to_be32(1),
+		.hash		= cpu_to_be16(hash_alg),
+		.size_of_select	= sizeof(cmd.select),
+		.select		= { BIT(PCR5_INDEX) },
+	};
+	u32 rsp_size = sizeof(*rsp) - sizeof(rsp->digest) + digest_size;
+	efi_status_t status;
+
+	status = efi_call_proto(tcg2, submit_command, sizeof(cmd), (u8 *)&cmd,
+				sizeof(*rsp), (u8 *)rsp);
+	if (status != EFI_SUCCESS)
+		return status;
+
+	/*
+	 * A TPM without the requested bank active returns an empty
+	 * selection and no digests, so check that we got back exactly
+	 * what we asked for.
+	 */
+	if (be32_to_cpu(rsp->size) != rsp_size || rsp->rc ||
+	    be32_to_cpu(rsp->count) != 1 ||
+	    be16_to_cpu(rsp->hash) != hash_alg ||
+	    rsp->size_of_select != sizeof(rsp->select) ||
+	    rsp->select[0] != BIT(PCR5_INDEX) ||
+	    be32_to_cpu(rsp->digest_count) != 1 ||
+	    be16_to_cpu(rsp->digest_size) != digest_size)
+		return EFI_NOT_FOUND;
+
+	return EFI_SUCCESS;
+}
+
+/*
+ * Extend a fixed value into PCR 5 and publish the resulting value of each
+ * supported PCR bank in a configuration table, so that the kernel can
+ * later verify that the firmware extended PCR 5 when ExitBootServices()
+ * was called.
+ */
+void efi_tpm_record_pcr5(void)
+{
+	efi_guid_t tcg2_guid = EFI_TCG2_PROTOCOL_GUID;
+	struct linux_efi_pcr5_log *log;
+	struct tpm2_pcr_read_rsp rsp;
+	efi_tcg2_protocol_t *tcg2 = NULL;
+	efi_status_t status;
+	int i;
+
+	status = efi_bs_call(locate_protocol, &tcg2_guid, NULL, (void **)&tcg2);
+	if (status != EFI_SUCCESS || !tcg2)
+		return;
+
+	status = efi_tpm_extend_pcr5(tcg2);
+	if (status != EFI_SUCCESS) {
+		efi_warn("Failed to extend PCR 5: 0x%lx\n", status);
+		return;
+	}
+
+	status = efi_bs_call(allocate_pool, EFI_ACPI_RECLAIM_MEMORY,
+			     struct_size(log, digests, ARRAY_SIZE(pcr5_banks)),
+			     (void **)&log);
+	if (status != EFI_SUCCESS) {
+		efi_err("Unable to allocate memory for PCR 5 log\n");
+		return;
+	}
+
+	memset(log, 0, struct_size(log, digests, ARRAY_SIZE(pcr5_banks)));
+	for (i = 0; i < ARRAY_SIZE(pcr5_banks); i++) {
+		struct linux_efi_pcr5_digest *d = &log->digests[log->count];
+
+		/* inactive banks are simply not recorded */
+		status = efi_tpm_read_pcr5(tcg2, pcr5_banks[i].hash_alg,
+					   pcr5_banks[i].digest_size, &rsp);
+		if (status != EFI_SUCCESS)
+			continue;
+
+		d->hash_alg = pcr5_banks[i].hash_alg;
+		d->digest_size = pcr5_banks[i].digest_size;
+		memcpy(d->digest, rsp.digest, d->digest_size);
+		log->count++;
+	}
+
+	if (!log->count) {
+		efi_warn("Failed to read PCR 5\n");
+		goto err_free;
+	}
+
+	status = efi_bs_call(install_configuration_table, &pcr5_guid, log);
+	if (status != EFI_SUCCESS) {
+		efi_err("Unable to install PCR 5 log table\n");
+		goto err_free;
+	}
+	return;
+
+err_free:
+	efi_bs_call(free_pool, log);
+}
+#endif
diff --git a/drivers/firmware/efi/tpm-security.c b/drivers/firmware/efi/tpm-security.c
new file mode 100644
index 000000000000..aee497da0a55
--- /dev/null
+++ b/drivers/firmware/efi/tpm-security.c
@@ -0,0 +1,98 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Verify that the firmware measured the ExitBootServices() invocation
+ * into PCR 5, by comparing the current value of PCR 5 against the value
+ * recorded by the EFI stub immediately before it called
+ * ExitBootServices().
+ */
+
+#define pr_fmt(fmt) "efi: " fmt
+
+#include <linux/efi.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/tpm.h>
+
+#define PCR5_INDEX	5
+
+unsigned long __initdata efi_pcr5_log = EFI_INVALID_TABLE_ADDR;
+bool kernel_tpm_security_available __ro_after_init;
+
+static int __init efi_tpm_check_pcr5(void)
+{
+	struct linux_efi_pcr5_log *log;
+	unsigned int recorded = 0, changed = 0;
+	struct tpm_chip *chip;
+	size_t size;
+	u32 count;
+	int i, rc;
+
+	if (efi_pcr5_log == EFI_INVALID_TABLE_ADDR)
+		return 0;
+
+	log = memremap(efi_pcr5_log, sizeof(*log), MEMREMAP_WB);
+	if (!log) {
+		pr_err("Failed to map PCR 5 log\n");
+		return 0;
+	}
+	count = log->count;
+	memunmap(log);
+
+	size = struct_size(log, digests, count);
+	log = memremap(efi_pcr5_log, size, MEMREMAP_WB);
+	if (!log) {
+		pr_err("Failed to map PCR 5 log\n");
+		return 0;
+	}
+
+	chip = tpm_default_chip();
+	if (!chip) {
+		pr_warn("No TPM available to verify PCR 5\n");
+		goto out;
+	}
+
+	if (!tpm_is_tpm2(chip)) {
+		pr_warn("PCR 5 log requires a TPM 2.0\n");
+		goto out_put;
+	}
+
+	for (i = 0; i < count; i++) {
+		struct linux_efi_pcr5_digest *d = &log->digests[i];
+		struct tpm_digest digest = { .alg_id = d->hash_alg };
+
+		if (d->digest_size > sizeof(d->digest)) {
+			pr_err("Invalid PCR 5 log entry for bank 0x%04x\n",
+			       d->hash_alg);
+			continue;
+		}
+
+		rc = tpm_pcr_read(chip, PCR5_INDEX, &digest);
+		if (rc) {
+			pr_err("Failed to read PCR 5 bank 0x%04x: %d\n",
+			       d->hash_alg, rc);
+			continue;
+		}
+
+		recorded++;
+		if (memcmp(digest.digest, d->digest, d->digest_size))
+			changed++;
+	}
+
+	if (!recorded)
+		goto out_put;
+
+	if (!changed)
+		pr_err(FW_BUG "Firmware failed to extend PCR 5 for ExitBootServices\n");
+	else if (changed != recorded)
+		pr_err(FW_BUG "Firmware only extended one PCR bank in ExitBootServices\n");
+
+	if (changed)
+		kernel_tpm_security_available = true;
+
+out_put:
+	put_device(&chip->dev);
+out:
+	memunmap(log);
+	return 0;
+}
+late_initcall(efi_tpm_check_pcr5);
diff --git a/include/linux/efi.h b/include/linux/efi.h
index aa15ff88539b..6d51a4bffbd8 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -23,6 +23,7 @@
 #include <linux/pstore.h>
 #include <linux/range.h>
 #include <linux/reboot.h>
+#include <linux/tpm_command.h>
 #include <linux/uuid.h>
 
 #include <asm/page.h>
@@ -422,6 +423,7 @@ void efi_native_runtime_setup(void);
 #define LINUX_EFI_COCO_SECRET_AREA_GUID		EFI_GUID(0xadf956ad, 0xe98c, 0x484c,  0xae, 0x11, 0xb5, 0x1c, 0x7d, 0x33, 0x64, 0x47)
 #define LINUX_EFI_BOOT_MEMMAP_GUID		EFI_GUID(0x800f683f, 0xd08b, 0x423a,  0xa2, 0x93, 0x96, 0x5c, 0x3c, 0x6f, 0xe2, 0xb4)
 #define LINUX_EFI_UNACCEPTED_MEM_TABLE_GUID	EFI_GUID(0xd5d1de3c, 0x105c, 0x44f9,  0x9e, 0xa9, 0xbc, 0xef, 0x98, 0x12, 0x00, 0x31)
+#define LINUX_EFI_PCR5_LOG_GUID			EFI_GUID(0xb38f9ff0, 0xb8ef, 0xe28f,  0x80, 0x8d, 0xe2, 0x9a, 0xa7, 0xef, 0xb8, 0x8f)
 
 #define RISCV_EFI_BOOT_PROTOCOL_GUID		EFI_GUID(0xccd15fec, 0x6f73, 0x4eec,  0x83, 0x95, 0x3e, 0x69, 0xe4, 0xb9, 0x40, 0xbf)
 
@@ -631,6 +633,28 @@ typedef struct {
 
 extern unsigned long __ro_after_init efi_rng_seed;		/* RNG Seed table */
 
+/*
+ * The value of PCR 5 as read by the EFI stub immediately before calling
+ * ExitBootServices(), published via the LINUX_EFI_PCR5_LOG_GUID
+ * configuration table.  There is one entry for each supported PCR bank
+ * that was active.
+ */
+struct linux_efi_pcr5_digest {
+	u16	hash_alg;	/* TPM_ALG_* of the PCR bank */
+	u16	digest_size;
+	u8	digest[TPM2_MAX_DIGEST_SIZE];
+};
+
+struct linux_efi_pcr5_log {
+	u32				count;
+	struct linux_efi_pcr5_digest	digests[];
+};
+
+#ifdef CONFIG_KERNEL_TPM_SECURITY
+extern unsigned long efi_pcr5_log;
+extern bool kernel_tpm_security_available;
+#endif
+
 /*
  * All runtime access to EFI goes through this structure:
  */
-- 
2.43.0

