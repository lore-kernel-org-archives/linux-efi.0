Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013021.outbound.protection.outlook.com [40.93.196.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2841A49E5C7;
	Thu,  8 Oct 2026 13:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791465955; cv=fail; b=OLBp7WsOdLVWK/ellw8OCcc9GYmPlY+PntiLeisG+bRRArtLWK3uE2CphSYL9ZQTEGXxXT3Is3yUphLTzbQeHJjxn06X2tZ126LehysHEZkpgxNKWjMWNnSjuJL+9lZgw53H8A63nP2J52z8u24vgLSe2ktm0aBrXYuSpfcl6Ns=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791465955; c=relaxed/simple;
	bh=vOmgZMYqSUNR61PScJ6dNOXXFRL1ZN134AlxSNojba8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PAlvlAzoD2mXKaziWSsB9MQ2eoURxN8sbJMU+S+w9sF9qEQUSwWlnhENxmNb9jY6ekRFujV4uZNB1U4DBR4Y1Hf3UjIFUeht4+gTp36cQLg23qgJU30KyGNI1k6IERJrhSosVf/3fRKK3mhHPMyuDTYX3PG+CYQLKBnibFYC90U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=o5gz+yxN; arc=fail smtp.client-ip=40.93.196.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="o5gz+yxN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TY0ny7qNokITvNh8PJqHEotg4uHEH8T1UxH+rxS6JmkZ60leQzZxpJPDasqwjsaQYIRHietKqW9Cgv/nHMwvOUaMBfaoj4tLT6yVXR18L7CN7gI4aPwWDx3qNtt/IWAIi2VFSCWKIIZKTj88AoMxVaR6ENJQDNMBFyIL5qSqtMy9XRUwKQ2zLLiCwuAxEHQzG6BEUrODAWmM47PgI+b1/lMqx3R1CANTE1fac4W9bfUNgMUxthW5IwiI0a3IadJKJh27qW0K/F/UMTREuKYC3vc9HKNJD4/W+5ly2AzrDL2231HJBr9om0P7ekKAMVIhafZbgEqk4WCoOXIMqy+4Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VZSqmtzMkhH8RgJefXHgnCxOO3Qt9DE+WIrlcl+IrLY=;
 b=gKKy81FghG2k2A8dkXApP8UrSEZTAFIpDj66l9HmYTRka36vD5C3QiAK22E181F4Zfm+0KYh3RYXYqFg25bC10G2VjyafqNVJ9Wfh25S2ROcICNDHHiVYc0vuTA89YzJwoipxw6u+p4THIWXHJ2SI3uWB4k/XiR5dfS5ZJ/6qcOu5+WMSPdFNLSPT6SXk+xjIKXvrBXbhv0dICmwTXO1rXq8lgorirc00VuycqinpELbWc3UEEtHO2LFI7GqSvVMEHCf6+3w8Wi7bvYPuyYGpe8Eu7lo2kuY+fd/v32VuZvAoiarMkbTruTuuWy6L2Mr793BM4tx12t4CkIEjtDHXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VZSqmtzMkhH8RgJefXHgnCxOO3Qt9DE+WIrlcl+IrLY=;
 b=o5gz+yxNjAeKdxDosAe1jJhkUWWkODBZ3UBbvzuw3/CqaqwEyN4CuU9JykyuFDKvyT0Khv2IqrnuWihUzYkEI/8b0B5/ZflKbyq7XY2T6XGGALltGk2D2gijswptA23wzwoEqoa5TljtvEQ5HgxhgVgtg2R4p7y1uKRwKRdrKwo4plFSKLUkZzx7XqXJXj0EIANI+QwSDxkGuXMcB14LVT3ksQnaj6kblP2msvmXUFjZleXExXvq/QBg458ipZlWkRshlnc1bL509i0knTEZrWnYw1RdmRghFTWW61tkVDhUZtvkIGApfGAbf2kyjmCSOJZm0mkRKJTK0DB4qn9m5Q==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH8PR12MB9741.namprd12.prod.outlook.com (2603:10b6:610:27a::21)
 by DS4PR12MB9796.namprd12.prod.outlook.com (2603:10b6:8:2a2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.17; Thu, 8 Oct
 2026 13:25:46 +0000
Received: from CH8PR12MB9741.namprd12.prod.outlook.com
 ([fe80::43a6:8d0:7081:65d7]) by CH8PR12MB9741.namprd12.prod.outlook.com
 ([fe80::43a6:8d0:7081:65d7%5]) with mapi id 15.21.0472.016; Thu, 8 Oct 2026
 13:25:46 +0000
From: Matthew Garrett <matthewg@nvidia.com>
To: mjg59@srcf.ucam.org
Cc: keyrings@vger.kernel.org,
	James.Bottomley@HansenPartnership.com,
	linux-integrity@vger.kernel.org,
	rafael@kernel.org,
	linux-pm@vger.kernel.org,
	linux-efi@vger.kernel.org,
	Matthew Garrett <matthewg@nvidia.com>
Subject: [PATCH 01/17] tpm: Define a kernel-owned TPM NV index that can't be modified by userland
Date: Thu,  8 Oct 2026 06:20:17 -0700
Message-ID: <20261008132532.1155166-2-matthewg@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261008132532.1155166-1-matthewg@nvidia.com>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0018.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c9::10) To CH8PR12MB9741.namprd12.prod.outlook.com
 (2603:10b6:610:27a::21)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH8PR12MB9741:EE_|DS4PR12MB9796:EE_
X-MS-Office365-Filtering-Correlation-Id: 480697c6-d89f-4960-0d88-08df253fa932
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|22082099003|18002099003|10067099003|3023799007|5023799004|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	xCgqvKDyFtV/X15LXL2pV3ARoPZIZMraw4n4j896wEFFLEcf9ohAsMySUu9zlFKQPuRcGFUNkxK9/IsZYcBBqGmX+5g6VUDfP+0ipysIj8IYoEFTdPLXOQH4Z1hN8n6Hf2ZibOU3TYFZjrc1sXhmtuEdbzw4mkShkf992dcdbDlrTWlJbkJULbXTPJkJpbT/bKgDmmRHT0HQEwBEjNGiN0FZewr1kePjawTllXoN0qvmdOYo2cTBp+/WMUtJZfp/wty3f+Pmrw8KNx8mlNlt74sfzGJ3x9tzCZiC3DR7TEfcwy963mTwF0sv0phm9qZuOWibhI/86LGvsfs4/rwIUO7R5mj26A0U41BNTRPH4DBYsFbsNedtObxxP34o06WfDxJQ/NkF7bRXNu+tRkECLhCS/ZANeF5+JeVwEam+DJLP9bZIoB+j53Yc3Qw+w1PP5Ecby7nMGhnGkwc87sjMxA9h37vP8l5teErBb+WvwbwzpXM/ypqn3zbGfc6xPn8gzB1y1M0rwIQImqgJkYe7AXz/JOxTyBdv1O6WlCSGAOy9LNHrlDwMmaOufXdlz8yHXi32erm0OFJySZuvsDiQILNCqhjWtU06h2aWAf3Vl4Z03rkmJYzhPoSFu5RgLlptVuL77zKBylOaI2Y7jKH2CXkzNR/6cp8HhZ6t+sD60Mc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH8PR12MB9741.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(22082099003)(18002099003)(10067099003)(3023799007)(5023799004)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iPxXZWyVbFyPW8Vm+wavRLtkRZuZ/0oF+AFUsnuB5VMDcK2y8fXRmAkw7Acc?=
 =?us-ascii?Q?ypi160rPMnjEvA1JwRxdoypih1QtGetZHOsbXfdHXri6WIzjdX9opRps15EJ?=
 =?us-ascii?Q?opc56w4luQs/7cubuYSWTOMSO/ilTwJKKhA0S3cqssRPoqcjYyKFbKYNtnAq?=
 =?us-ascii?Q?wkrq16i8jc/F3eCIHYxQPvcgkGMqIUCvA7ZHl3RAF9PZ12oJCGcW2VEO6Lkd?=
 =?us-ascii?Q?E4esK6xYBhKEkmCC6sqDz8ScJT7turiAG3kIv6/KYeB1TATE3ZqS6oJXFl9e?=
 =?us-ascii?Q?fvBY40X5WLirgJy7213pbzf9eS5jQVIoaPzrTBkCehx5huOMzB7QPv0LYE7O?=
 =?us-ascii?Q?keZTWaAA/4IfUx46zIzwjhSgf+a4KiTZJXmuvDnpSt7PLzON7TC4y1ZQaoSA?=
 =?us-ascii?Q?SnsNCwGF5OjZqFvF8R3V6snVHw/bFLP9ZbqXTgPa6LF/v30pfoKw9i60rLUc?=
 =?us-ascii?Q?N7IQjTgFqXqV5EZQ2OcTjz1Fv9DS1PLgVn3gdjtoTikQNIgH1Ei6Iu6KJMaN?=
 =?us-ascii?Q?DgoK+jDbySXNrBUQ8RxtfuIdPQV+KIPEcGMH/e5wplI2c67LpgbcjQNaiQLV?=
 =?us-ascii?Q?Rulbe5JPNHK2A2p2hyxZIn0V5M6eXbBnlTJZXdMQgX7NZgQHhBDmLueSTnbT?=
 =?us-ascii?Q?n4DLgX7C+eSlF2IgkroP2quHTRmcS6nXXgT5yNzrd2LupA4wMCT1SAHlcsHy?=
 =?us-ascii?Q?gfTiDD5hrspwB1oy7lpT9+NXlatji+raPXQqER53RWuOdCxM7Aqu4uyi20uy?=
 =?us-ascii?Q?4tcxIukXCATCRPFM+iCVjWXgiNmyfWAf74xD0j317E7c3mFB75jO+n/ctFb+?=
 =?us-ascii?Q?vBOlz1I8Q3J/4qJ+afhsk2ecJM/IssXZrU/I9THBEPC/kCK5lZV2b4a/eaK+?=
 =?us-ascii?Q?CxRsOTGCgVL7l3y+nengdn8n0382V5JlZTO/b+ME/DZpfbAqDErr2OEVKmBZ?=
 =?us-ascii?Q?rrCP2fvYJMoMXOv06yoEarfxwql5MTRBl20fRh5JB6poqME2QV6ivVI7ARBx?=
 =?us-ascii?Q?jzxyib7zweQM8FsPS5aNEqpo3VNR3+8tkKA+aD+t5hs627eXg9zd3RcsS2Tr?=
 =?us-ascii?Q?T83i7ehidVPWD//juq606n58Q28iYj7TXNhNVXopJZ6AhzqtTgQsCuA5g8wY?=
 =?us-ascii?Q?Rn7LEjrlrwM1fj0deKu+ogwXKqX399A8J/6hmGSFlRnX3F5KZK4kw4EF5e2n?=
 =?us-ascii?Q?vxLWLaQ3jhe6c4KmuiMR2Q+v+XFRANffCjpMk2gm+uul9HbnLPikIZimpZsi?=
 =?us-ascii?Q?+5t29BbHKgaVxw1Oy4dgszDWea9i+Cqka/70AqxI0LWt2SHvYPRGkoTysXYR?=
 =?us-ascii?Q?T58xb51pmAhzQMEcnPhKPZso5otkoxrVdlcD/0L5vm4jozMQNqXYZ/aWoslM?=
 =?us-ascii?Q?R4hpV4gP6dv5RRe0U6XlYGi/SfYk2/9stQ7P8L9mDtbdA2/KAuxxWCoQQ4lG?=
 =?us-ascii?Q?kud5dZlEDn/sJQFlRj7CgTHRVuxJ9o2oJg4F3nPkvbaMtVdfbb1kCorcn3A9?=
 =?us-ascii?Q?R4Fw0TpxJZU7IVSFj4D2/BCHKw55Qpwnpczbjv5bfpR5paGxEX07PwJeHYYB?=
 =?us-ascii?Q?RBJiPfSfc74qCgJWVoIJIU17KiZ0tJz8VEjtnBNDQbn2Hac8x+WQDZme6K5Y?=
 =?us-ascii?Q?S0VwYWK+BbRBsfvOGWZKUJxm1Ho9wSROJwZ142iqmF+nubTtcQPbe3MRpn2u?=
 =?us-ascii?Q?Hkc4bmuEQM4TzJcoeagTMHDb6E7f4obOEioNC7Dh2zEgdHrC7HyCZalKskA7?=
 =?us-ascii?Q?/DW50ba8eQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 480697c6-d89f-4960-0d88-08df253fa932
X-MS-Exchange-CrossTenant-AuthSource: CH8PR12MB9741.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 13:25:46.2341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C8EKzRWBXbfbG0NFM08T5mgvkYM7Oup3QY/woOVEeYYNp15ZL6imno0sxd6fDly9DCIVMTXLOarbKuzAXiDXiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9796

TPM NV indexes can be used for various purposes, including using them as
PCRs without depleting the limited number of hardware PCRs. It would be
beneficial to have one that's under control of the kernel in order to be
able to prove whether certain TPM operations occurred within the kernel
or not.

Reserve NV index 0x014c4853 for use by the kernel, and filter commands
submitted through /dev/tpm* and /dev/tpmrm* so that userspace cannot
undefine or modify it. Blocking definition is more awkward so let's
allow that for now, not being able to modify it means there's nothing
interesting they can do there. The filter simply validates which handle
the relevant set of commands is referring to and returns -EPERM if it's
the kernel one.

NV indexes are from allocated ranges and this is a range allocated to
Linux, so there should be no userland depending on the ability to access
this - but let's gate it behind a default N config option anyway.

Signed-off-by: Matthew Garrett <matthewg@nvidia.com>
---
 drivers/char/tpm/Kconfig          |  8 ++++
 drivers/char/tpm/tpm-dev-common.c | 67 +++++++++++++++++++++++++++++++
 include/linux/tpm.h               |  6 +++
 include/linux/tpm_command.h       | 10 +++++
 4 files changed, 91 insertions(+)

diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
index 5f672f2c01b0..a454b63edca5 100644
--- a/drivers/char/tpm/Kconfig
+++ b/drivers/char/tpm/Kconfig
@@ -253,5 +253,13 @@ config TCG_SVSM
 	  level (usually VMPL0).  To compile this driver as a module, choose M
 	  here; the module will be called tpm_svsm.
 
+config TCG_TPM_KERNEL_NVINDEX
+	bool "Kernel-only NV index"
+	help
+	  Allocate a TPM NV index and block userland from modifying it. This
+	  allows the kernel to develop a unique state that distinguishes it
+	  from userspace, making it possible to prove that a TPM object
+	  was created by the kernel.
+
 source "drivers/char/tpm/st33zp24/Kconfig"
 endif # TCG_TPM
diff --git a/drivers/char/tpm/tpm-dev-common.c b/drivers/char/tpm/tpm-dev-common.c
index f942c0c8e402..1fd93cdaf306 100644
--- a/drivers/char/tpm/tpm-dev-common.c
+++ b/drivers/char/tpm/tpm-dev-common.c
@@ -15,18 +15,85 @@
 #include <linux/poll.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
+#include <linux/unaligned.h>
 #include <linux/workqueue.h>
 #include "tpm.h"
 #include "tpm-dev.h"
 
 static struct workqueue_struct *tpm_dev_wq;
 
+#ifdef CONFIG_TCG_TPM_KERNEL_NVINDEX
+/*
+ * Commands that undefine or modify an NV index, and the position of the
+ * NV index in the command's handle area.
+ */
+static const struct {
+	u32 cc;
+	unsigned int handle;
+} tpm2_nv_modify_cmds[] = {
+	{ TPM2_CC_NV_UNDEFINE_SPACE_SPECIAL,	0 },
+	{ TPM2_CC_NV_UNDEFINE_SPACE,		1 },
+	{ TPM2_CC_NV_INCREMENT,			1 },
+	{ TPM2_CC_NV_SET_BITS,			1 },
+	{ TPM2_CC_NV_EXTEND,			1 },
+	{ TPM2_CC_NV_WRITE,			1 },
+	{ TPM2_CC_NV_WRITE_LOCK,		1 },
+	{ TPM2_CC_NV_CHANGE_AUTH,		0 },
+	{ TPM2_CC_NV_READ_LOCK,			1 },
+};
+
+/*
+ * Returns true if a command from userspace attempts to define, undefine
+ * or modify the kernel-owned NV index.
+ */
+static bool tpm2_dev_cmd_is_blocked(const u8 *buf, size_t bufsiz)
+{
+	const struct tpm_header *header = (const void *)buf;
+	size_t len = min_t(size_t, be32_to_cpu(header->length), bufsiz);
+	u32 cc;
+	int i, index;
+
+	if (len < TPM_HEADER_SIZE)
+		return false;
+
+	cc = be32_to_cpu(header->ordinal);
+
+	for (i = 0; i < ARRAY_SIZE(tpm2_nv_modify_cmds); i++) {
+		size_t offset;
+
+		if (tpm2_nv_modify_cmds[i].cc != cc)
+			continue;
+
+		offset = TPM_HEADER_SIZE +
+			 tpm2_nv_modify_cmds[i].handle * sizeof(u32);
+		if (len < offset + sizeof(u32))
+			return false;
+
+		index = get_unaligned_be32(&buf[offset]);
+
+		if (index == TPM2_KERNEL_NV_INDEX)
+			return true;
+	}
+
+	return false;
+}
+#else
+static inline bool tpm2_dev_cmd_is_blocked(const u8 *buf, size_t bufsiz)
+{
+	return false;
+}
+#endif
+
 static ssize_t tpm_dev_transmit(struct tpm_chip *chip, struct tpm_space *space,
 				u8 *buf, size_t bufsiz)
 {
 	struct tpm_header *header = (void *)buf;
 	ssize_t ret, len;
 
+	if ((chip->flags & TPM_CHIP_FLAG_TPM2) &&
+	    tpm2_dev_cmd_is_blocked(buf, bufsiz))
+		return -EPERM;
+
 	if (chip->flags & TPM_CHIP_FLAG_TPM2)
 		tpm2_end_auth_session(chip);
 
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index 0db277af45c3..b6b862c3be3b 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -178,6 +178,12 @@ static inline enum tpm2_mso_type tpm2_handle_mso(u32 handle)
 	return handle >> 24;
 }
 
+/*
+ * NV index reserved for use by the kernel. Userspace is not permitted to
+ * undefine or modify it.
+ */
+#define TPM2_KERNEL_NV_INDEX	0x014c4853
+
 #define TPM_VID_INTEL    0x8086
 #define TPM_VID_WINBOND  0x1050
 #define TPM_VID_STM      0x104A
diff --git a/include/linux/tpm_command.h b/include/linux/tpm_command.h
index fc446a1282e2..79f547ca6dbf 100644
--- a/include/linux/tpm_command.h
+++ b/include/linux/tpm_command.h
@@ -214,14 +214,24 @@ enum tpm2_return_codes {
 
 enum tpm2_command_codes {
 	TPM2_CC_FIRST			= 0x011F,
+	TPM2_CC_NV_UNDEFINE_SPACE_SPECIAL = 0x011F,
 	TPM2_CC_HIERARCHY_CONTROL	= 0x0121,
+	TPM2_CC_NV_UNDEFINE_SPACE	= 0x0122,
 	TPM2_CC_HIERARCHY_CHANGE_AUTH	= 0x0129,
+	TPM2_CC_NV_DEFINE_SPACE		= 0x012A,
 	TPM2_CC_CREATE_PRIMARY		= 0x0131,
+	TPM2_CC_NV_INCREMENT		= 0x0134,
+	TPM2_CC_NV_SET_BITS		= 0x0135,
+	TPM2_CC_NV_EXTEND		= 0x0136,
+	TPM2_CC_NV_WRITE		= 0x0137,
+	TPM2_CC_NV_WRITE_LOCK		= 0x0138,
+	TPM2_CC_NV_CHANGE_AUTH		= 0x013B,
 	TPM2_CC_SEQUENCE_COMPLETE	= 0x013E,
 	TPM2_CC_SELF_TEST		= 0x0143,
 	TPM2_CC_STARTUP			= 0x0144,
 	TPM2_CC_SHUTDOWN		= 0x0145,
 	TPM2_CC_NV_READ			= 0x014E,
+	TPM2_CC_NV_READ_LOCK		= 0x014F,
 	TPM2_CC_CREATE			= 0x0153,
 	TPM2_CC_LOAD			= 0x0157,
 	TPM2_CC_SEQUENCE_UPDATE		= 0x015C,
-- 
2.43.0

