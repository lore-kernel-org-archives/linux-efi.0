Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012009.outbound.protection.outlook.com [40.107.200.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B07E42124D;
	Thu,  8 Oct 2026 13:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791466009; cv=fail; b=Wgz9EdYqIxInsfP6HTG0W9JHo8j2i0i6083CpdAfmy4I1rct0awbv0JuSam178/RIv3z2maBIrGQXyTO8zORbuXS9pBQ9s3GJvIrEHz5m5VJN1m6hRYH7HIIP5O3BcvuVnTBFxOvgGvwl48zf4loscCDMqg9sQ+XNvLOE4CQNsg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791466009; c=relaxed/simple;
	bh=OJWeAfElV0sTAa4Jr1xmiyn3avKlb0RudbjINaroztg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EGtVMUNtr3ZNxSpjilE9mTlNCaP/DztRs4UFGidmNuj4GRFmJB0dohJq4yn8xc5nm0qDSxqQcNP/82ojHChBrhD+XKBmT3Mj39gCiLqqZ5+Pqp2AMcfPxEdksA0OQ/ZAZp0dvNn5md7UmbplTDPM36qFYUmJFvvjGYBu31tYpmM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pTPExVii; arc=fail smtp.client-ip=40.107.200.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pTPExVii"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xS6NtCrVYZsPkH5aG0vYLsXSiLFtCq0PprimcByqKMmdY43vhfejzYFmIUMpBD/LmVnQWOrPLpnR3jFsZFlHfY7z4xNy1Cd+PyNKmE6kIREWE4yIKTd4/8PNTdwJDns7hOp9r2mqJREN7zYcpoxku2yyFsennLaSGRVbo2pYzUQUwNW6MhhU8DsX6ULAmog95dcgIp8OM0ipoDw3T9Qces+TyI/L0isEui3K+vZD7U6bTeXkHLGfcnlEVVVwjVPCBiFe/Zpb/3CnzSQ5u6LB70MYYM+SmK1seLeo8DrxwCUV0g19lNbpOJakdmhlkC5w7pdwPvwsROQPml0oFZNIbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E6OT1Ia+JFOvxmOMhhnD1S9soN9wlr+tLFrF3Biymmw=;
 b=Em8EbH0M0/NCzWf9Gern1FFdowzH78Rospu9g88RCANYKsSoXarSdjS7JIenJlj9ClnsFc27ecvZsBi0/e96WbIBLcFHbMOFQZaFvDyWsyecsjRTa80bGGhgFWuW4PKhdkcRFbBT8mhRIx+ytpVSlYFTdj5E85v5yftwtwPANfH9S+Dgk9a/CnA7cLAN+/SeD8tbi7R7AR/RRbvMjHDsrh68WsVpER3Xlo9b7LWir2y39xshYoZqyVYFoMIUCzXr6tfldWjQgomSSIxphe87pTjoI5YZPU2SjIwq3Y8Qeh4aVtpEjKfbwtGtFBAnYc2nBvysxcIxXDu4Dx6n42XDAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E6OT1Ia+JFOvxmOMhhnD1S9soN9wlr+tLFrF3Biymmw=;
 b=pTPExVii7o1lpqL33xVyhuZ+wcy7P3sjzyIlIwLZbrXy52wt2hOBw9143XWZ3gzMavifSRz4r9JKSS8aCY5F6p8Zpz549MylysdQCBDt1CUHGLklsacjIVD7hbH7gaGgpio6MkmA0Vwz4azD0ZAcZoNIJx9vC0DqPSp9BJep3+CgnPuFIs1QDZ9gumeQ4lIRt+64SWAo5MUj6IOCHTN3oMj3YMCS0JypCWutWCn9jp962l7MDsimekLdIPZO5R3I1W1DwtUpTA9Gfl776rY9BKf6/dZXLycRmItE4wI4GZxZJneIPRZ3T24B4GGIGlYDRF6uSu7HQXPpbYimr/lc2g==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH8PR12MB9741.namprd12.prod.outlook.com (2603:10b6:610:27a::21)
 by CY8PR12MB7587.namprd12.prod.outlook.com (2603:10b6:930:9a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.26; Thu, 8 Oct
 2026 13:26:33 +0000
Received: from CH8PR12MB9741.namprd12.prod.outlook.com
 ([fe80::43a6:8d0:7081:65d7]) by CH8PR12MB9741.namprd12.prod.outlook.com
 ([fe80::43a6:8d0:7081:65d7%5]) with mapi id 15.21.0472.016; Thu, 8 Oct 2026
 13:26:33 +0000
From: Matthew Garrett <matthewg@nvidia.com>
To: mjg59@srcf.ucam.org
Cc: keyrings@vger.kernel.org,
	James.Bottomley@HansenPartnership.com,
	linux-integrity@vger.kernel.org,
	rafael@kernel.org,
	linux-pm@vger.kernel.org,
	linux-efi@vger.kernel.org,
	Matthew Garrett <matthewg@nvidia.com>
Subject: [PATCH 15/17] PM: hibernate: Sign and verify images with a kernel-generated TPM key
Date: Thu,  8 Oct 2026 06:20:31 -0700
Message-ID: <20261008132532.1155166-16-matthewg@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261008132532.1155166-1-matthewg@nvidia.com>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0293.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e7::6) To CH8PR12MB9741.namprd12.prod.outlook.com
 (2603:10b6:610:27a::21)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH8PR12MB9741:EE_|CY8PR12MB7587:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a8bc367-b9ff-4170-38ec-08df253fc57d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|10067099003|11063799006|5023799004|56012099006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	KiRWiOljOeWwyTcuRkSAely/IpradEcrQMjEMShFBc9sqBRWJ04CqLTRq9el4WWXAa2hIa+ZKlKxZVreD+DOlB50ck+WqThAIPIsTZyAgkZkDmyBA3sNJ+51shaoGZs2afk/arPp7HgP+MNInV1fPtUIMH/b892t0hU956tXOk7GtHQiqUo9BxUR22LeoU4ktcaNWqhvAkn7WcXzqP1baDGvHa2+03pMZgAHNmceNh+dvt3T3vDW3Hp2qtXEG2eb+5U7WkpAEoa8UJPr/NNn050CSLrwPUVvsCCtMYKoh2fRuQ9/mHWW7oItUsR6Mxy5BppH4fvul/EE2QzO7V/wDnVay308ZaN5S9JZhdsy9+VzdFAapI90ZyJFJFHrGXYBI2nxp4KYOw4Ej7MPnXCusz77ZbwIbZ12CrFndzoLCuf8PyfLdSx8DbNCYVFMPDdGhXU49bX/YfjF1oK9J4KCAeaGFu2AzpHvhEt2Bp5PNktzjRPjhr1eeeTQyjbmyLm1U6d0wkwKo31W+I7nKzuyv8wShrRtRShWSssUIaZinORc3QDBshSkUR3qhQN4OxpGA5lfBKEw5i+P77ktcxffYoum2fJBd+OqEZk3mdSnamvHlRt+ej/CFd8yAJZf2UqxEwLgReghbOnLXrkyYMRe9X0UVXmXT+plXssb3MUbH+c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH8PR12MB9741.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(10067099003)(11063799006)(5023799004)(56012099006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?L0cqxAIqoyFaeF8ZFhd9bYeQavhm2OnHA1v5vBArSe/I0ZTadAmv5pJ7LddA?=
 =?us-ascii?Q?TX0E/+8VEcDrdbFkyhobd41oQLRI1mCEhpm+tId4562wpi1AiUa91VeUoar9?=
 =?us-ascii?Q?G60NRfLIdqcTMuSlNNWiVLeswaAdWYQlrzN6vPQLs6jVz0tiPTlAM4q/m7zg?=
 =?us-ascii?Q?EjsDnEotuApGK2Un1yD6PweGm1mIgBOnbdNVVcodG6x/W55oYQm2t5ogZfSX?=
 =?us-ascii?Q?nWHcqJZCxCnAjr+ZNw269di8yYz5rbdXF4XRfDFkJCE7C4kvg8PMgo6Wwf25?=
 =?us-ascii?Q?KCm06xJ8ToekvTGPjVtnwQfyVGyLbRjySDBbVKLG6SRZ9I0ZYAzgHNFFWvsv?=
 =?us-ascii?Q?uzfZV8muRPaE2Bva3yyxWAchdqumUvcQHBCnb+GCX1MDYzuQwFYs12x89JE+?=
 =?us-ascii?Q?ZqwO8npUv0QWuXptthwsEtCQkkMZmVLd6bme+ixZv7W5erfnwbGCjGvwY0lC?=
 =?us-ascii?Q?Az97PN0BDFzFr6W2IcLZEsjlVXnWG0iCMZa435EWsPpk5dIAx0wwRM8viaZi?=
 =?us-ascii?Q?RWOlT5fSM8wk0jqF0nGHWvaMmVGy+t4jAbzTRBHg9Q10rbltcTuZV8PyglTV?=
 =?us-ascii?Q?1kVHeQRWirJcWF/+qnhgjm8uYniSrIPfY4ByNEy4xDaioKyk7YIHfbBeAE3K?=
 =?us-ascii?Q?+wC7JHG8zBjAtLdk1FlQy3JwnU4f3teP55aCtd7sFIalEnWccx+FWTts8QNa?=
 =?us-ascii?Q?z9XbP0hmaddwSolokJ9UZtRCWVflHhN2vQYS6b37azVoOYw8kxmehhKJNcOj?=
 =?us-ascii?Q?JtW5G5s5FYfGo84rmGtmBsY86KeyPq4mJ3g/pdZd/U6seJCmMcpG0hsizU6x?=
 =?us-ascii?Q?hGKdjYGEv7rT1bpa3YQQYsvnEsioxQ7i1vFdqgZiq0k9jaCSUzINspLGOVsu?=
 =?us-ascii?Q?U/dUMi36q7+Bspn5ixGvc2sJ6g4nR9TOiK9am+0Q5nAU/vunZ41VeX50PuUx?=
 =?us-ascii?Q?TJ2BJlSjXN/L1mh+HKpLeFaoyHhyHBY1RhUa0m1juqIf2CfHnM+K+ie4MCjH?=
 =?us-ascii?Q?YQvPDp1aNBH9WywJe39kinITz3eDjGrvparvirB8OdM0aFxIFZzug0KbP8+A?=
 =?us-ascii?Q?ujJB96Gg4efhAUXfSxYRO/cW4aalqShN40mYv3nnW8sXa+rICEQGVD0IE7TJ?=
 =?us-ascii?Q?AZRlVcUUyQyFBF6nwmcU8EvP4aih6Sf8OC1RYXvnbj1/m0VPILiNdiZqS5E2?=
 =?us-ascii?Q?SBJ0F6ZxKJDRIV6mEjr3qeZZEjOzptFncAUdKSOFHUqqn1z0PONYP95t/gQ7?=
 =?us-ascii?Q?Yf2MZQU7Mu4i5rvVY51CrC0luNP9ai4dnC9pi88jTtaro3SPPnVGaTyyWOvr?=
 =?us-ascii?Q?HgQ08nHLXg+A8v4MAUcHJHoSnJDdmTI5CyS+Nqn2sQoxvQbbZijqVIuy8Kf8?=
 =?us-ascii?Q?kwFu/QsU+L7aL15e0pSNtyDU4v4EZuwM8nBC72gJLiInGgWyvwxHpBBblkSi?=
 =?us-ascii?Q?YZqvLaNpcM/bcSiR6boYXya94Ka7kjcFYhUzdpaSEP158H65TZ7Wxy16LoRM?=
 =?us-ascii?Q?CDJ3pp9Ryzk1vFhHcbKtkBIE6rUnmg64efHLiiLs6cmtL4m6xl7gxrukDsX+?=
 =?us-ascii?Q?sJq1aoexIfJwhZ2kklO/jSWos1vS8iTEhHwcuVOq4rYZdS4MVIX0v0iBXi0C?=
 =?us-ascii?Q?MKqpZHOmSisnU2DiJQEaJwh0EMkRWAeHufnKMB58RP/PPqRtEQx0sIDrIluZ?=
 =?us-ascii?Q?4zC7pwNZvp863Bht64dwena8+9qog30Aq72JAY/uZv2Eb6X8eP77PfvRZGTI?=
 =?us-ascii?Q?J5rElJTkcw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a8bc367-b9ff-4170-38ec-08df253fc57d
X-MS-Exchange-CrossTenant-AuthSource: CH8PR12MB9741.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 13:26:33.8260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /D0Fwg6PgUgMXvEEUfPbk7MUumBzuARmvdden3Mh10Cv8DamtX4g64ByhyVPDUsPWpwT5OF++R/VoT5eIA8i2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7587

Add CONFIG_HIBERNATION_TPM_SIGNATURE, a hibernation image signing
backend that uses a TPM signing key created by the kernel.

When an image header is built, a fresh kernel signing key is created
with tpm2_kernel_key_create(), and its provenance, the AK-signed audit
session showing that the key was created while only the kernel could
use the TPM, is stored in the image header. Once the whole image has
been hashed, the digest is signed with the key, and the key is
destroyed. The key cannot be recreated, and as it is created under the
null hierarchy it does not survive a TPM reset, so it can sign nothing
else once the system has been powered off.

When an image is loaded, the provenance is checked with
tpm2_kernel_key_verify() as soon as the header has been read, which
yields the public key that the kernel created. The image is restored
only if its signature verifies with that key. Images that are unsigned,
modified, or signed with any other key are rejected, and the system
boots normally.

As PCR 5 can only distinguish the kernel's audit session if firmware
extends it when ExitBootServices() is called, verification requires that
we successully extend PCR 5 during the EFI stub and that the firmware
then extends it when ExitBootServices is called. Hibernation is
unavailable when the option is enabled but there is no TPM 2.0 or the
firmware does not extend PCR 5.

Signed-off-by: Matthew Garrett <matthewg@nvidia.com>
---
 kernel/power/Kconfig         |  18 +++
 kernel/power/Makefile        |   1 +
 kernel/power/hibernate.c     |   4 +-
 kernel/power/hibernate_tpm.c | 227 +++++++++++++++++++++++++++++++++++
 kernel/power/power.h         |   7 +-
 kernel/power/snapshot.c      |  11 +-
 6 files changed, 265 insertions(+), 3 deletions(-)
 create mode 100644 kernel/power/hibernate_tpm.c

diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index 846f0f91dbc0..2ff9f807ab5a 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -116,6 +116,24 @@ config HIBERNATION_DEF_COMP
 	help
 	  Default compressor to be used for hibernation.
 
+config HIBERNATION_TPM_SIGNATURE
+	bool "Sign hibernation images with a kernel-generated TPM key"
+	depends on HIBERNATION && KERNEL_TPM_SECURITY && TCG_TPM2_KERNEL_KEY
+	help
+	  Sign every hibernation image with a TPM key created by the kernel
+	  while the image is written, and refuse to restore images that are
+	  unsigned, modified, or signed by a key that cannot be shown to have
+	  been created by the kernel. This detects images that have been
+	  tampered with or written by something other than the kernel, such
+	  as userspace.
+
+	  The TPM must be a TPM 2.0 whose owner and endorsement hierarchies
+	  have empty auth values, and the firmware must extend PCR 5 when
+	  ExitBootServices() is called. If these requirements are not met,
+	  hibernation is unavailable.
+
+	  If unsure, say N.
+
 config PM_STD_PARTITION
 	string "Default resume partition"
 	depends on HIBERNATION
diff --git a/kernel/power/Makefile b/kernel/power/Makefile
index 773e2789412b..25a4ab12552e 100644
--- a/kernel/power/Makefile
+++ b/kernel/power/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_SUSPEND)		+= suspend.o
 obj-$(CONFIG_PM_TEST_SUSPEND)	+= suspend_test.o
 obj-$(CONFIG_HIBERNATION)	+= hibernate.o snapshot.o swap.o
 obj-$(CONFIG_HIBERNATION_SNAPSHOT_DEV) += user.o
+obj-$(CONFIG_HIBERNATION_TPM_SIGNATURE) += hibernate_tpm.o
 obj-$(CONFIG_PM_AUTOSLEEP)	+= autosleep.o
 obj-$(CONFIG_PM_WAKELOCKS)	+= wakelock.o
 
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 1efc2bd3a387..256790aeca86 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -110,7 +110,9 @@ bool hibernation_available(void)
 {
 	return nohibernate == 0 &&
 		!security_locked_down(LOCKDOWN_HIBERNATION) &&
-		!secretmem_active() && !cxl_mem_active();
+		!secretmem_active() && !cxl_mem_active() &&
+		(!IS_ENABLED(CONFIG_HIBERNATION_TPM_SIGNATURE) ||
+		 hibernate_tpm_available());
 }
 
 /**
diff --git a/kernel/power/hibernate_tpm.c b/kernel/power/hibernate_tpm.c
new file mode 100644
index 000000000000..96f01c80f3cb
--- /dev/null
+++ b/kernel/power/hibernate_tpm.c
@@ -0,0 +1,227 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Sign hibernation images with a kernel-generated TPM key.
+ *
+ * When an image is created, the kernel creates a fresh TPM signing key,
+ * along with evidence signed by the kernel attestation key that the key
+ * was created by the kernel rather than by userspace (see
+ * drivers/char/tpm/tpm2-kernel-key.c).  The evidence is stored in the
+ * image header, and the key signs the digest of the whole image.  The key
+ * cannot be recreated and does not survive a TPM reset, so it can sign
+ * nothing else once the system has been powered off.
+ *
+ * On resume, the evidence is checked as soon as the image header has been
+ * read, which yields the public key that the kernel created, and the
+ * image is only restored if it was signed with that key.
+ */
+
+#define pr_fmt(fmt) "PM: hibernation: " fmt
+
+#include <linux/efi.h>
+#include <linux/init.h>
+#include <linux/tpm.h>
+
+#include "power.h"
+
+#define HIB_TPM_SIG_MAGIC	"LNXHSIG1"
+
+/* The signature page */
+struct hib_tpm_sig {
+	u8 magic[8];
+	u8 x[EC_PT_SZ];
+	u8 y[EC_PT_SZ];
+	u8 r[EC_PT_SZ];
+	u8 s[EC_PT_SZ];
+};
+
+static_assert(sizeof(struct hib_tpm_sig) <= HIB_SIG_TRAILER_SIZE);
+static_assert(sizeof(struct tpm2_key_provenance) <= HIB_SIG_HEADER_SIZE);
+
+/* The key used to sign the image being created */
+static struct tpm2_kernel_key hib_tpm_key;
+static bool hib_tpm_key_valid;
+
+/* The public key shown to have been created by the kernel, on restore */
+static u8 hib_tpm_x[EC_PT_SZ], hib_tpm_y[EC_PT_SZ];
+static bool hib_tpm_header_ok;
+
+static struct tpm_chip *hib_tpm_get_chip(void)
+{
+	struct tpm_chip *chip = tpm_default_chip();
+
+	if (!chip)
+		return NULL;
+
+	if (!(chip->flags & TPM_CHIP_FLAG_TPM2) || tpm_try_get_ops(chip)) {
+		put_device(&chip->dev);
+		return NULL;
+	}
+
+	return chip;
+}
+
+static void hib_tpm_put_chip(struct tpm_chip *chip)
+{
+	tpm_put_ops(chip);
+	put_device(&chip->dev);
+}
+
+/* TPM errors are positive; report them as a failure to use the TPM */
+static int hib_tpm_err(int rc)
+{
+	return rc > 0 ? -EIO : rc;
+}
+
+static void hib_tpm_end(void)
+{
+	struct tpm_chip *chip;
+
+	if (!hib_tpm_key_valid)
+		return;
+
+	chip = hib_tpm_get_chip();
+	if (chip) {
+		tpm2_kernel_key_destroy(chip, &hib_tpm_key);
+		hib_tpm_put_chip(chip);
+	}
+
+	memzero_explicit(&hib_tpm_key, sizeof(hib_tpm_key));
+	hib_tpm_key_valid = false;
+}
+
+static int hib_tpm_begin(void *data, size_t size)
+{
+	struct tpm2_key_provenance *prov = data;
+	struct tpm_chip *chip;
+	int rc;
+
+	/* the image may be read more than once */
+	hib_tpm_end();
+
+	chip = hib_tpm_get_chip();
+	if (!chip)
+		return -ENODEV;
+
+	rc = tpm2_kernel_key_create(chip, &hib_tpm_key, prov);
+	hib_tpm_put_chip(chip);
+	if (rc) {
+		pr_err("Failed to create image signing key: %d\n", rc);
+		return hib_tpm_err(rc);
+	}
+
+	hib_tpm_key_valid = true;
+	return 0;
+}
+
+static int hib_tpm_sign(const u8 *digest, void *trailer, size_t size)
+{
+	struct hib_tpm_sig *sig = trailer;
+	struct tpm_chip *chip;
+	int rc;
+
+	if (!hib_tpm_key_valid)
+		return -EINVAL;
+
+	chip = hib_tpm_get_chip();
+	if (!chip)
+		return -ENODEV;
+
+	memcpy(sig->magic, HIB_TPM_SIG_MAGIC, sizeof(sig->magic));
+	memcpy(sig->x, hib_tpm_key.x, sizeof(sig->x));
+	memcpy(sig->y, hib_tpm_key.y, sizeof(sig->y));
+	rc = tpm2_kernel_key_sign(chip, &hib_tpm_key, digest, sig->r, sig->s);
+
+	/* the key has done its job */
+	tpm2_kernel_key_destroy(chip, &hib_tpm_key);
+	hib_tpm_key_valid = false;
+	hib_tpm_put_chip(chip);
+
+	if (rc) {
+		pr_err("Failed to sign image: %d\n", rc);
+		return hib_tpm_err(rc);
+	}
+
+	return 0;
+}
+
+static int hib_tpm_check_header(const void *data, size_t size)
+{
+	const struct tpm2_key_provenance *prov = data;
+	struct tpm_chip *chip;
+	int rc;
+
+	hib_tpm_header_ok = false;
+
+	/* PCR 5 can only distinguish the kernel if firmware extends it */
+	if (!kernel_tpm_security_available) {
+		pr_err("Cannot verify image: TPM security not available\n");
+		return -EKEYREJECTED;
+	}
+
+	chip = hib_tpm_get_chip();
+	if (!chip) {
+		pr_err("Cannot verify image: no TPM\n");
+		return -ENODEV;
+	}
+
+	rc = tpm2_kernel_key_verify(chip, prov, hib_tpm_x, hib_tpm_y);
+	hib_tpm_put_chip(chip);
+	if (rc) {
+		pr_err("Image signing key was not created by the kernel: %d\n",
+		       rc);
+		return rc > 0 ? -EKEYREJECTED : rc;
+	}
+
+	hib_tpm_header_ok = true;
+	return 0;
+}
+
+static int hib_tpm_verify(const u8 *digest, const void *trailer, size_t size)
+{
+	const struct hib_tpm_sig *sig = trailer;
+
+	if (!hib_tpm_header_ok)
+		return -EKEYREJECTED;
+
+	if (memcmp(sig->magic, HIB_TPM_SIG_MAGIC, sizeof(sig->magic)))
+		return -EKEYREJECTED;
+
+	/* the image must be signed with the key the kernel created */
+	if (memcmp(sig->x, hib_tpm_x, sizeof(hib_tpm_x)) ||
+	    memcmp(sig->y, hib_tpm_y, sizeof(hib_tpm_y)))
+		return -EKEYREJECTED;
+
+	return tpm2_kernel_key_verify_signature(hib_tpm_x, hib_tpm_y, digest,
+						sig->r, sig->s);
+}
+
+const struct hib_sig_ops hib_tpm_sig_ops = {
+	.begin		= hib_tpm_begin,
+	.sign		= hib_tpm_sign,
+	.end		= hib_tpm_end,
+	.check_header	= hib_tpm_check_header,
+	.verify		= hib_tpm_verify,
+};
+
+/**
+ * hibernate_tpm_available - Check whether images can be signed.
+ *
+ * Signing requires a TPM 2.0 and firmware that extends PCR 5 when
+ * ExitBootServices() is called.
+ */
+bool hibernate_tpm_available(void)
+{
+	struct tpm_chip *chip;
+	bool tpm2;
+
+	if (!kernel_tpm_security_available)
+		return false;
+
+	chip = tpm_default_chip();
+	if (!chip)
+		return false;
+
+	tpm2 = chip->flags & TPM_CHIP_FLAG_TPM2;
+	put_device(&chip->dev);
+	return tpm2;
+}
diff --git a/kernel/power/power.h b/kernel/power/power.h
index b4733d45e6cd..8115df3364a9 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -197,7 +197,12 @@ int snapshot_write_finalize(struct snapshot_handle *handle);
 extern int snapshot_image_loaded(struct snapshot_handle *handle);
 extern bool snapshot_image_signed(void);
 extern int snapshot_image_verify(void);
-extern void hibernate_set_sig_ops(const struct hib_sig_ops *ops);
+#ifdef CONFIG_HIBERNATION_TPM_SIGNATURE
+extern const struct hib_sig_ops hib_tpm_sig_ops;
+extern bool hibernate_tpm_available(void);
+#else
+static inline bool hibernate_tpm_available(void) { return false; }
+#endif
 
 extern bool hibernate_acquire(void);
 extern void hibernate_release(void);
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index bbf9de4b15ab..75276b73a913 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -174,7 +174,16 @@ static void *buffer;
  * of the image is signed, and the signature is stored in an extra page at
  * the end of the image.
  */
-static const struct hib_sig_ops *hib_sig;
+#ifdef CONFIG_HIBERNATION_TPM_SIGNATURE
+/*
+ * Fixed at build time rather than registered at runtime, so that signature
+ * enforcement cannot be avoided by preventing registration, for example
+ * with initcall_blacklist=.
+ */
+static const struct hib_sig_ops *const hib_sig = &hib_tpm_sig_ops;
+#else
+static const struct hib_sig_ops *const hib_sig;
+#endif
 static unsigned long nr_sig_pages;
 static struct sha256_ctx hib_sig_ctx;
 static u8 hib_sig_digest[SHA256_DIGEST_SIZE];
-- 
2.43.0

