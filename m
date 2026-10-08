Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012009.outbound.protection.outlook.com [40.107.200.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C504ABBD1;
	Thu,  8 Oct 2026 13:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791465995; cv=fail; b=mLUZZLO/g5kBEOdbZ7Tw5zOaCC+n60mYmb4CeuehPILcEDKq08pMfaiHCyjBlh35X+mA2i6Bzb0ws6XnsyKy5+30rCcYYsS7BtrHQ2v5rBIZKRrgeIsn4s0OJoSgMZr/mF5gre5Nw/HG1LGChwGzucQPQB1EZPWN+9Fz9kKEtn8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791465995; c=relaxed/simple;
	bh=J/veRLVJBZD8ydTMqDVycePIDppfO1H1uI9LMo4zHw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PFYYPWzb7Bn+cBi6EbaqeKsGZzgTidEABBLpPEjtGeHa66acNHx4Q1xHc0t4y/UIsxR1l4qwcu29krqZM+e68/rZiTiyNV2LVMwrUJfgzONjJ1TwMgE7qFP+0oSBh86SbUTNJJDe87AFIHIu7KphhoP1aIBssEuSlwa+gt8Q0Q4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UKaYPDc+; arc=fail smtp.client-ip=40.107.200.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UKaYPDc+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=afkRmja6vh5Sr6K338cSFa6X8syNda90RJVnPavcrxZdr/w4HP4ZebWSraboB5hK8kQnrcyqoJ0n9z3W/0bmlYAOwoJdNjfLkadEwfsaUdO7r2twTZRreBQgHd3S74OwggcrOxJu62CsIe2hhQkT/0uaINkcz1uthuKUT9sJcqaPYD2S+TDS8cz5Pcy4C6idenqNnXKru4Q1QuDZbxMNeCBh+hT8K++WeJdZ3/hB+NMn8scKsNWo0MxhexqIKl2inWDUje9a0ilP3ipMKHbAxMOSycEYh/PWp2cb3f14vrHtAvQQULZAsNSyk0LdFptxcrhqwZj0gOwcIBF+eg5GCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nkEdWywMOKnEgwNcelBupLuMV7VLsdNG0vZgUjXhcLM=;
 b=gEwBfSmh1dfcy+BOxaTRZAif+2oP7p4W2h2lFm9pO6XoEJm5jcrxmx40gUWKw8ETtV5Gi9KdxQw/X3QBCwt16DpKma+fFcC6HRDuGA8DfUvBTti+zPoo2NPS+S2qwr6ZS8FT83Rob2lk7diCPdYlwakejRP2vS/+M42+gtN1l8f614+HRjw5ayZC8YAWP/JoZbc1t+WQbrCLsNbKhZKvSBQeOf19bB45pmgqIUOuHdiae+SJF4b9fbXI44uqO/Trb1Wb4o+mNkxUWt8ZEzdSPgl2+6UeWpIj8N6NKrrg2jWuc0OBa6foyOvBdOxuZclCEhmL5Qwvr1SstRNcRrFO2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nkEdWywMOKnEgwNcelBupLuMV7VLsdNG0vZgUjXhcLM=;
 b=UKaYPDc+8KLNuwFIH3cSUIdDtK3gFO9hlxB+gHQXciLwKmED4fsP4esEqa7YCuNPAglylpytcEOggNpmMhSfxWSKAGAdOT/hNRn+Y48eHcqSDbmFzUEQxMFpsR/ceGyh1fuPetcdUWxpgna7MRNnXM+tGZHepqFtl+wWD/z2aO/gznmACbg2/wFqoduXl7f5YcRqnHuk3SVd3sT9Y+h44t1VRXgQ6GdoGem5CVfOFX1wz0Rqh1j8jsOQfWms6bbvo0jIlDG31q3DKiAupxIx5d7aj0YehOptS06kv+3CLNmRV1Xrj1FxLk1TAknLpspTU44WI/CvAUixLZoqu/gECQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH8PR12MB9741.namprd12.prod.outlook.com (2603:10b6:610:27a::21)
 by CY8PR12MB7587.namprd12.prod.outlook.com (2603:10b6:930:9a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.26; Thu, 8 Oct
 2026 13:26:20 +0000
Received: from CH8PR12MB9741.namprd12.prod.outlook.com
 ([fe80::43a6:8d0:7081:65d7]) by CH8PR12MB9741.namprd12.prod.outlook.com
 ([fe80::43a6:8d0:7081:65d7%5]) with mapi id 15.21.0472.016; Thu, 8 Oct 2026
 13:26:20 +0000
From: Matthew Garrett <matthewg@nvidia.com>
To: mjg59@srcf.ucam.org
Cc: keyrings@vger.kernel.org,
	James.Bottomley@HansenPartnership.com,
	linux-integrity@vger.kernel.org,
	rafael@kernel.org,
	linux-pm@vger.kernel.org,
	linux-efi@vger.kernel.org,
	Matthew Garrett <matthewg@nvidia.com>
Subject: [PATCH 11/17] tpm: Add kernel signing key creation with audited provenance
Date: Thu,  8 Oct 2026 06:20:27 -0700
Message-ID: <20261008132532.1155166-12-matthewg@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261008132532.1155166-1-matthewg@nvidia.com>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0102.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cb::9) To CH8PR12MB9741.namprd12.prod.outlook.com
 (2603:10b6:610:27a::21)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH8PR12MB9741:EE_|CY8PR12MB7587:EE_
X-MS-Office365-Filtering-Correlation-Id: a9c47815-259e-4164-09dc-08df253fbd5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|10067099003|11063799006|56012099006|3023799007|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	gvqL38JV7nzIG/tI+AzmfK0iuWhcpnP6HcrK8usR8UxnbDTCMXNM0E0qzcxJ7HNfvd3g0Rygj1Hg18ERCrIjaNzGe17W+W1lOdtI2PnBLq/DirMa6HA3Ej2KB9hQRqwFf4hMy2t3VrMqmG2UK+r4V0yHfcKnHSQyhDIBgEwu1MwpazSoTQng9cZtdOip1lIw7xyMsIknE2kPTkIhMqMl3HwmV1fI658NrexdwcY9p1e3UL57WFLZfuhphkj5WGBxt8MgaFmLgZnzmWHO/YgvvcYDM7Gqm02hyCVAwNhDcXT1agDMweMwGCTlV9FMNJlQLC8/f+N0ih02K8JrZwpAMeY4uwXj7IuhLyoYrk/eX6xdsHvLUyal3O14NlgaY+UGC35Pm5txB1WHBob2QeYK3M1Cy927VEQxNXmkTWGmT/qFuMpsLcBXVz2avIm4dk8Yx2KUcUZyETSoQUeB9+3CHTCLo1T604SibBlpJF9wfqa7ceGgrNndFYwakhAvAiIHXJ9G2QmBooFwlOrSJ+xtI6iFbjNy+Jv8lyAHvDzAXDjSymAEOPlWb8hc0P1SD8I0DLN+LM+ntSIjwzCaUm782BO1WXzG+QAeddvMGR+ZSlnmUxo0J4fYSDCsUBlw55oM/2WBEY9qWSQsRXeiZEqNOgvtSSAHvyy82rz5IUZ0s/A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH8PR12MB9741.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(10067099003)(11063799006)(56012099006)(3023799007)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Sy6NaNW6vnh+4PuAmwGTvlw41dxhzmtskouS9Q/pLNLS80q6Q3PtjgLKsKsV?=
 =?us-ascii?Q?B2Tv5py+5s6hHZbgv9EaK+4QTSfHvrhxhE/2s2Bzrrig1H1mCBXQ+5QFvpWC?=
 =?us-ascii?Q?+wNyZYxUJ1xmDpXglSlW06rIROuAs2V8fMFglEHAGQ4LQdWJaw8n12xNd1AU?=
 =?us-ascii?Q?HBRG4Ls8zAz9o3KK75/xgvZ/neI4xqlKOy5L4SNyUc376UtBT7WKvfg8OJUU?=
 =?us-ascii?Q?ZzZNm/tSDYdQOFazZfuH2RbLrPfLMY5pkUosVaYlopAi76OyGB+nykTaStB2?=
 =?us-ascii?Q?HTBRQTsJLT25cioy5dGE0X63tZklddPtBo2IGWTiammXflIF/Fp3J4Jv1O+T?=
 =?us-ascii?Q?YfSYebNeJKx8pYThvGekwoBrsbxn3X1xKkLQoNhYio7HrB4JcByqLPhB2kko?=
 =?us-ascii?Q?iJgpIttWWQxobgItXBLXvtVMZsN8P5OHsawrPdujvU7a9HIB6BTXVFHszYyA?=
 =?us-ascii?Q?8b2uar7Bv1UOZBEmpmtqYR8Qdyt2/RfD1fAldgJbpJePdaS1IEfB5K2LLoKe?=
 =?us-ascii?Q?gr+/EGZ5KWcvVzekqK3W/3W8Nd0vFQvHaDft8fH/WYWAyEFBakLn/Q37vBcm?=
 =?us-ascii?Q?shXIDoh4oBggg1hJzUPrfGTPOocXpyHSFj8YBfQJe4UA5SFRr4beLq0VMZGJ?=
 =?us-ascii?Q?0ZrqBBVm3VagpRPlPkIvQM3y17uUa98bBO2OGjBacvzMjUDFZDf07ge8rAlN?=
 =?us-ascii?Q?KhWxNQJ57CGFoxLVM+zSaltRawqBDMYiwjapztYAQKvzVwCuvAT/GTY+mUYs?=
 =?us-ascii?Q?pw1WaXGdPzmeAIMXTj64gH2PlDZVDPfoSuN2Racbc9/xsMUSiOX1RhFmk9pY?=
 =?us-ascii?Q?iKHpBXIJ5JXMljzuRwqK5tvtX7q59F4iL3FuP4buwXgpShODKJ+vlPeOd4MA?=
 =?us-ascii?Q?mGTBvFrORcINBNVBVyKbBvPZEPPvvvA6z7Z/mFMZoNf8TFQyj98/LwFMKdk+?=
 =?us-ascii?Q?bzsQvV7b64tvc9jZiL4EYeP0U85cDtLcXdgGiA47fG+WS/CkAnZQCtT+Gsk8?=
 =?us-ascii?Q?npxsVP99X9G7k5sHItRZZkJZrQtP570m8sCJwt7ZKmbxIkUG8t7ZaNAPcZjC?=
 =?us-ascii?Q?3hcZ1SgQEzMCToXB9HB/GRBK8NJUdEeFn+5VqaLoo/7ZOnb8Q1gTnKvwV4jA?=
 =?us-ascii?Q?gk0jB5CGJixTjUjnW/Heu7CntYn194QGHOnUnOcii1p7nKW0ZhHoaw0DXTLY?=
 =?us-ascii?Q?cDaHtUFCurGfbYw7LZDmfv3KttCTbBEjt5JJ8Q+ge9H/LujwALYoThIUb9Uk?=
 =?us-ascii?Q?TtjfsQJl/lWsfMzVzbBWTjYIns9lvhLD7CMzyEJt0eT80Ffykj6677NPiDnb?=
 =?us-ascii?Q?xi0pSFuirDRDw9m+7MicxDQHi0ASa15RRetsW4+eWoH6LB5Tu5PEaj4nVSJf?=
 =?us-ascii?Q?S0rjPYUSEakY3/zv87aqKXI32WXMWYyLJi/TFEiz5y6N1r+lPUvAhNZgt6Z4?=
 =?us-ascii?Q?QL2e6kskJyZfdW0bAUmaJRpUioQZrKlZK1b3JtGdgemytQYuU4FXBd+pO91r?=
 =?us-ascii?Q?L4YOFaKGSUAIcbgvciNyN5SXw7/RWjY366C4UV0Bo9qVnyawWUuLelhy20FL?=
 =?us-ascii?Q?ZxV5gGkGRC1ctJDgsNH0+8Vn9V9z980L0/oHaqZOrJx+STspMc5eCa0pQsKY?=
 =?us-ascii?Q?h/IVr9N7c/euSOpU/n7g9nD8sLLhR8j0DMfW20svRJJoA9LX5F6gGl2BzRfx?=
 =?us-ascii?Q?dKZyA2QXfqV8xp8ttrdp6LNrzL3XuM50WX7oIpM96+PRq/POzaCqn7Tfci5N?=
 =?us-ascii?Q?xDB2hf+U7A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9c47815-259e-4164-09dc-08df253fbd5b
X-MS-Exchange-CrossTenant-AuthSource: CH8PR12MB9741.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 13:26:20.1943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SKNxz868bX4iKlmRnoGgruflam0g7DE+XFKH1n5WZ/dMfmCtt+YuVPJXoHiyuMR6M70lexdiK6A3jPSeQLEitw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7587

Add tpm2_kernel_key_create(), which creates an ECDSA P-256 signing key
for the kernel along with evidence that the kernel, rather than
userspace, created it. The key is created with TPM2_CreateLoaded under
the null hierarchy primary, with a random auth value that is sent
encrypted and never leaves the kernel. Its private part comes from the
TPM's RNG and the null seed changes on every TPM reset, so it can
neither be recreated nor used after a reboot.

The key is created inside an audit session while the kernel NV index
holds its magic value. Inside that audit session we:

* Read PCR 5. This will be used to bind the key to a kernel that
implements the restricted NV index feature.

* Read the kernel NV index. This will prove that the session was owned
by the kernel - userland will never be able to set this index to the
magic value.

* Generate the key. The above information proves (1) that the kernel
blocks userland from modifying the NV index, and (2) that the NV index
indicated that the session was in-kernel, which means that the key must
have been generated by the kernel.

Once this is done the NV index is set back to 0. The audit log can then
be later used to validate the key identity.

Signed-off-by: Matthew Garrett <matthewg@nvidia.com>
---
 drivers/char/tpm/Kconfig           |  10 +
 drivers/char/tpm/Makefile          |   1 +
 drivers/char/tpm/tpm.h             |   1 +
 drivers/char/tpm/tpm2-kernel-key.c | 404 +++++++++++++++++++++++++++++
 drivers/char/tpm/tpm2-sessions.c   |   2 +-
 include/linux/tpm.h                |  39 +++
 6 files changed, 456 insertions(+), 1 deletion(-)
 create mode 100644 drivers/char/tpm/tpm2-kernel-key.c

diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
index a454b63edca5..15d204f8fa6d 100644
--- a/drivers/char/tpm/Kconfig
+++ b/drivers/char/tpm/Kconfig
@@ -42,6 +42,16 @@ config TCG_TPM2_HMAC
 	  here adds some encryption overhead to all kernel to TPM
 	  transactions.
 
+config TCG_TPM2_KERNEL_KEY
+	bool "Kernel-generated TPM signing keys with provenance"
+	depends on TCG_TPM2_HMAC
+	help
+	  Allow the kernel to create TPM signing keys along with evidence,
+	  signed by the kernel attestation key, that the key was created
+	  by the kernel rather than by userspace. This is used to sign
+	  data that must later be shown to have been produced by the
+	  kernel, such as hibernation images.
+
 config HW_RANDOM_TPM
 	bool "TPM HW Random Number Generator support"
 	depends on TCG_TPM && HW_RANDOM && !(TCG_TPM=y && HW_RANDOM=m)
diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index 88a96fee0934..66e5b27ad7c6 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -19,6 +19,7 @@ tpm-y += tpm-buf.o
 tpm-y += tpm2-sessions.o
 tpm-$(CONFIG_TCG_TPM2_HMAC) += tpm2-ak.o
 tpm-$(CONFIG_TCG_TPM2_HMAC) += tpm2-kernel-nv.o
+tpm-$(CONFIG_TCG_TPM2_KERNEL_KEY) += tpm2-kernel-key.o
 
 tpm-$(CONFIG_ACPI) += tpm_ppi.o eventlog/acpi.o
 tpm-$(CONFIG_EFI) += eventlog/efi.o
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 54e8d5820b6d..228230b2d5bb 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -152,6 +152,7 @@ void tpm_dev_common_exit(void);
 int tpm2_sessions_init(struct tpm_chip *chip);
 void tpm2_free_auth(struct tpm2_auth *auth);
 int tpm2_audit_session_handle(struct tpm_chip *chip, u32 *handle);
+int tpm2_load_null(struct tpm_chip *chip, u32 *null_key);
 
 extern const u8 tpm2_kernel_nv_magic[TPM2_KERNEL_NV_SIZE];
 void tpm2_kernel_nv_name(bool written, u8 name[TPM2_NULL_NAME_SIZE]);
diff --git a/drivers/char/tpm/tpm2-kernel-key.c b/drivers/char/tpm/tpm2-kernel-key.c
new file mode 100644
index 000000000000..27815525bc3f
--- /dev/null
+++ b/drivers/char/tpm/tpm2-kernel-key.c
@@ -0,0 +1,404 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Kernel-generated TPM signing keys with provenance.
+ *
+ * A kernel signing key is an ECDSA P-256 key created by the TPM under the
+ * null hierarchy primary, with a random auth value known only to the
+ * kernel.  Its private part is generated by the TPM's RNG and cannot be
+ * recreated, and the null seed changes on every TPM reset, so the key
+ * cannot be used once the system has rebooted.
+ *
+ * To show that the key was created by the kernel and not by userspace,
+ * it is created inside an audit session while the kernel NV index holds
+ * its magic value, which userspace is unable to store there:
+ *
+ *	set kernel NV index to magic
+ *	start audit session
+ *	  TPM2_PCR_Read(PCR 5, SHA-1 and SHA-256 banks)
+ *	  TPM2_NV_Read(kernel NV index)
+ *	  TPM2_CreateLoaded(signing key)
+ *	TPM2_GetSessionAuditDigest, signed by the kernel AK
+ *	end audit session
+ *	reset kernel NV index to zero
+ *
+ * The signed audit digest, the audit log and the parameters of each
+ * response form the key's provenance.  A verifier can recompute the
+ * audit digest from the log, check that each logged response matches the
+ * recorded parameters, and so learn that the NV read returned the magic
+ * value, what PCR 5 held, and the public key that was created.
+ */
+
+#include <linux/random.h>
+#include <linux/slab.h>
+#include <linux/unaligned.h>
+#include "tpm.h"
+#include "tpm2-rsp.h"
+
+#define TPM2_KKEY_PROV_MAGIC	0x544b5056	/* "TKPV" */
+#define TPM2_KKEY_PROV_VERSION	1
+#define TPM2_KKEY_NR_CMDS	3
+#define TPM2_KKEY_RSP_MAX	512
+
+/* Kernel signing keys may sign arbitrary digests */
+#define TPM2_OA_KERNEL_KEY ( \
+	TPM2_OA_FIXED_TPM | \
+	TPM2_OA_FIXED_PARENT | \
+	TPM2_OA_SENSITIVE_DATA_ORIGIN | \
+	TPM2_OA_USER_WITH_AUTH | \
+	TPM2_OA_NO_DA | \
+	TPM2_OA_SIGN)
+
+/* TPML_PCR_SELECTION for PCR 5 in the SHA-1 and SHA-256 banks */
+static const u8 tpm2_kkey_pcr5_select[] = {
+	0x00, 0x00, 0x00, 0x02,		/* count */
+	0x00, 0x04,			/* TPM_ALG_SHA1 */
+	0x03,				/* sizeofSelect */
+	0x20, 0x00, 0x00,		/* PCR 5 */
+	0x00, 0x0b,			/* TPM_ALG_SHA256 */
+	0x03,				/* sizeofSelect */
+	0x20, 0x00, 0x00,		/* PCR 5 */
+};
+
+/* The parameters of a response, as covered by the logged rpHash */
+struct tpm2_kkey_rsp {
+	u32 cc;
+	u16 len;
+	u8 data[TPM2_KKEY_RSP_MAX];
+};
+
+/*
+ * Send a command in the audit session and save its response parameters.
+ * If the response has a handle it is returned in @handle.
+ */
+static int tpm2_kkey_transmit(struct tpm_chip *chip, struct tpm_buf *buf,
+			      u32 *handle, struct tpm2_kkey_rsp *rsp,
+			      const char *desc)
+{
+	struct tpm_header *head = (struct tpm_header *)buf->data;
+	struct tpm2_rsp r;
+	const u8 *params;
+	u32 len;
+	int rc;
+
+	rsp->cc = be32_to_cpu(head->ordinal);
+
+	rc = tpm_buf_fill_hmac_session(chip, buf);
+	if (rc)
+		return rc;
+
+	rc = tpm_transmit_cmd(chip, buf, 0, desc);
+	rc = tpm_buf_check_hmac_response(chip, buf, rc);
+	if (rc)
+		return rc;
+
+	tpm2_rsp_init(&r, buf);
+	if (handle)
+		*handle = tpm2_rsp_u32(&r);
+	len = tpm2_rsp_u32(&r);
+	params = tpm2_rsp_bytes(&r, len);
+	if (!params || len > sizeof(rsp->data))
+		return -EIO;
+
+	memcpy(rsp->data, params, len);
+	rsp->len = len;
+	return 0;
+}
+
+static int tpm2_kkey_pcr_read(struct tpm_chip *chip, struct tpm_buf *buf,
+			      struct tpm2_kkey_rsp *rsp)
+{
+	tpm_buf_reset(buf, TPM2_ST_SESSIONS, TPM2_CC_PCR_READ);
+	/* the session is used only for audit */
+	tpm_buf_append_hmac_session(chip, buf, TPM2_SA_CONTINUE_SESSION,
+				    NULL, 0);
+	tpm_buf_append(buf, tpm2_kkey_pcr5_select,
+		       sizeof(tpm2_kkey_pcr5_select));
+
+	return tpm2_kkey_transmit(chip, buf, NULL, rsp, "reading PCR 5");
+}
+
+static int tpm2_kkey_nv_read(struct tpm_chip *chip, struct tpm_buf *buf,
+			     struct tpm2_kkey_rsp *rsp)
+{
+	int rc;
+
+	tpm_buf_reset(buf, TPM2_ST_SESSIONS, TPM2_CC_NV_READ);
+	rc = tpm_buf_append_name(chip, buf, TPM2_KERNEL_NV_INDEX, NULL);
+	if (rc)
+		return rc;
+	rc = tpm_buf_append_name(chip, buf, TPM2_KERNEL_NV_INDEX, NULL);
+	if (rc)
+		return rc;
+
+	/* no response encryption, so the logged rpHash covers the value */
+	tpm_buf_append_hmac_session(chip, buf, TPM2_SA_CONTINUE_SESSION,
+				    NULL, 0);
+	tpm_buf_append_u16(buf, TPM2_KERNEL_NV_SIZE);
+	tpm_buf_append_u16(buf, 0);
+
+	rc = tpm2_kkey_transmit(chip, buf, NULL, rsp,
+				"reading kernel NV index");
+	if (rc)
+		return rc;
+
+	/* the TPM2B_MAX_NV_BUFFER must hold the magic value */
+	if (rsp->len != sizeof(u16) + TPM2_KERNEL_NV_SIZE ||
+	    get_unaligned_be16(rsp->data) != TPM2_KERNEL_NV_SIZE ||
+	    memcmp(rsp->data + sizeof(u16), tpm2_kernel_nv_magic,
+		   TPM2_KERNEL_NV_SIZE))
+		return -EIO;
+
+	return 0;
+}
+
+static int tpm2_kkey_create_loaded(struct tpm_chip *chip,
+				   struct tpm_buf *buf, u32 parent,
+				   struct tpm2_kernel_key *key,
+				   struct tpm2_kkey_rsp *rsp)
+{
+	struct tpm_buf *template __free(kfree) = NULL;
+	struct tpm2_rsp r;
+	u16 len;
+	int rc;
+
+	template = kzalloc(TPM_BUFSIZE, GFP_KERNEL);
+	if (!template)
+		return -ENOMEM;
+
+	tpm_buf_init_sized(template, TPM_BUFSIZE);
+	tpm_buf_append_u16(template, TPM_ALG_ECC);
+	tpm_buf_append_u16(template, TPM_ALG_SHA256);
+	tpm_buf_append_u32(template, TPM2_OA_KERNEL_KEY);
+	/* auth policy (empty) */
+	tpm_buf_append_u16(template, 0);
+	/* symmetric algorithm (none for a signing key) */
+	tpm_buf_append_u16(template, TPM_ALG_NULL);
+	/* signing scheme */
+	tpm_buf_append_u16(template, TPM_ALG_ECDSA);
+	tpm_buf_append_u16(template, TPM_ALG_SHA256);
+	tpm_buf_append_u16(template, TPM2_ECC_NIST_P256);
+	/* KDF scheme */
+	tpm_buf_append_u16(template, TPM_ALG_NULL);
+	/* unique (empty points) */
+	tpm_buf_append_u16(template, 0);
+	tpm_buf_append_u16(template, 0);
+
+	tpm_buf_reset(buf, TPM2_ST_SESSIONS, TPM2_CC_CREATE_LOADED);
+	rc = tpm_buf_append_name(chip, buf, parent, chip->null_key_name);
+	if (rc)
+		return rc;
+
+	/* encrypt inSensitive so the key's auth value is not exposed */
+	tpm_buf_append_hmac_session(chip, buf, TPM2_SA_DECRYPT |
+				    TPM2_SA_CONTINUE_SESSION, NULL, 0);
+
+	/* inSensitive: the auth value and no data */
+	tpm_buf_append_u16(buf, sizeof(u16) + sizeof(key->auth) + sizeof(u16));
+	tpm_buf_append_u16(buf, sizeof(key->auth));
+	tpm_buf_append(buf, key->auth, sizeof(key->auth));
+	tpm_buf_append_u16(buf, 0);
+
+	/* inPublic */
+	tpm_buf_append(buf, template->data, template->length);
+
+	if (buf->flags & TPM_BUF_INVALID || template->flags & TPM_BUF_INVALID)
+		return -EINVAL;
+
+	rc = tpm2_kkey_transmit(chip, buf, &key->handle, rsp,
+				"creating kernel signing key");
+	if (rc)
+		return rc;
+
+	/* outPrivate, then outPublic */
+	tpm2_rsp_init_data(&r, rsp->data, rsp->len);
+	tpm2_rsp_tpm2b(&r, &len);
+
+	return tpm2_rsp_ecdsa_public(&r, TPM2_OA_KERNEL_KEY, key->x, key->y);
+}
+
+/* Bounds-checked writer for the serialized provenance */
+struct tpm2_kkey_writer {
+	struct tpm2_key_provenance *prov;
+	bool err;
+};
+
+static void tpm2_kkey_put(struct tpm2_kkey_writer *w, const void *data,
+			  u16 len)
+{
+	struct tpm2_key_provenance *prov = w->prov;
+
+	if (w->err || sizeof(prov->data) - prov->len < len) {
+		w->err = true;
+		return;
+	}
+
+	memcpy(&prov->data[prov->len], data, len);
+	prov->len += len;
+}
+
+static void tpm2_kkey_put_u8(struct tpm2_kkey_writer *w, u8 val)
+{
+	tpm2_kkey_put(w, &val, sizeof(val));
+}
+
+static void tpm2_kkey_put_u16(struct tpm2_kkey_writer *w, u16 val)
+{
+	__be16 v = cpu_to_be16(val);
+
+	tpm2_kkey_put(w, &v, sizeof(v));
+}
+
+static void tpm2_kkey_put_u32(struct tpm2_kkey_writer *w, u32 val)
+{
+	__be32 v = cpu_to_be32(val);
+
+	tpm2_kkey_put(w, &v, sizeof(v));
+}
+
+/*
+ * Serialized provenance, all integers big-endian:
+ *
+ *	u32	magic ("TKPV")
+ *	u16	version (1)
+ *	u16	attestation length, then the TPMS_ATTEST
+ *	u8[32]	AK signature R
+ *	u8[32]	AK signature S
+ *	u8	number of commands, then for each command:
+ *		u32	command code
+ *		u8[32]	cpHash
+ *		u8[32]	rpHash
+ *		u16	response parameter length, then the parameters
+ */
+static int tpm2_kkey_serialize(struct tpm2_key_provenance *prov,
+			       const struct tpm2_signed_audit *audit,
+			       const struct tpm2_audit_entry *log,
+			       const struct tpm2_kkey_rsp *rsp)
+{
+	struct tpm2_kkey_writer w = { .prov = prov };
+	int i;
+
+	prov->len = 0;
+	tpm2_kkey_put_u32(&w, TPM2_KKEY_PROV_MAGIC);
+	tpm2_kkey_put_u16(&w, TPM2_KKEY_PROV_VERSION);
+	tpm2_kkey_put_u16(&w, audit->attest_len);
+	tpm2_kkey_put(&w, audit->attest, audit->attest_len);
+	tpm2_kkey_put(&w, audit->sig_r, sizeof(audit->sig_r));
+	tpm2_kkey_put(&w, audit->sig_s, sizeof(audit->sig_s));
+	tpm2_kkey_put_u8(&w, TPM2_KKEY_NR_CMDS);
+
+	for (i = 0; i < TPM2_KKEY_NR_CMDS; i++) {
+		tpm2_kkey_put_u32(&w, rsp[i].cc);
+		tpm2_kkey_put(&w, log[i].cphash, sizeof(log[i].cphash));
+		tpm2_kkey_put(&w, log[i].rphash, sizeof(log[i].rphash));
+		tpm2_kkey_put_u16(&w, rsp[i].len);
+		tpm2_kkey_put(&w, rsp[i].data, rsp[i].len);
+	}
+
+	return w.err ? -E2BIG : 0;
+}
+
+/**
+ * tpm2_kernel_key_create() - create a kernel signing key with provenance
+ * @chip:	the TPM chip
+ * @key:	filled with the new key, which remains loaded in the TPM
+ * @prov:	filled with evidence that the key was created by the kernel
+ *
+ * Creates an ECDSA P-256 signing key as described at the top of this
+ * file.  The kernel NV index must be usable and the owner and endorsement
+ * hierarchies must have empty auth values.  Any existing auth session is
+ * ended.  The caller must hold the chip's ops lock, and must release the
+ * key with tpm2_kernel_key_destroy().
+ *
+ * Return:
+ * * 0		- OK
+ * * -errno	- A system error
+ * * TPM_RC	- A TPM error
+ */
+int tpm2_kernel_key_create(struct tpm_chip *chip, struct tpm2_kernel_key *key,
+			   struct tpm2_key_provenance *prov)
+{
+	struct tpm2_kkey_rsp *rsp __free(kfree) = NULL;
+	struct tpm_buf *buf __free(kfree_sensitive) = NULL;
+	struct tpm2_signed_audit audit = { };
+	const struct tpm2_audit_entry *log;
+	bool magic = false;
+	u32 null_key = 0;
+	int rc, rc2;
+
+	memset(key, 0, sizeof(*key));
+	prov->len = 0;
+
+	rsp = kcalloc(TPM2_KKEY_NR_CMDS, sizeof(*rsp), GFP_KERNEL);
+	buf = kzalloc(TPM_BUFSIZE, GFP_KERNEL);
+	if (!rsp || !buf)
+		return -ENOMEM;
+	tpm_buf_init(buf, TPM_BUFSIZE);
+
+	get_random_bytes(key->auth, sizeof(key->auth));
+
+	/* the index may have been removed by TPM2_Clear since boot */
+	rc = tpm2_kernel_nv_provision(chip);
+	if (rc)
+		goto out;
+
+	tpm2_end_auth_session(chip);
+
+	rc = tpm2_load_null(chip, &null_key);
+	if (rc)
+		goto out;
+
+	magic = true;
+	rc = tpm2_kernel_nv_set_magic(chip);
+	if (rc)
+		goto out;
+
+	/* setting the index used an ordinary session */
+	tpm2_end_auth_session(chip);
+	rc = tpm2_start_auth_session(chip, true);
+	if (rc)
+		goto out;
+
+	rc = tpm2_kkey_pcr_read(chip, buf, &rsp[0]);
+	if (!rc)
+		rc = tpm2_kkey_nv_read(chip, buf, &rsp[1]);
+	if (!rc)
+		rc = tpm2_kkey_create_loaded(chip, buf, null_key, key, &rsp[2]);
+	if (rc)
+		goto out;
+
+	rc = tpm2_get_signed_audit_digest(chip, NULL, 0, &audit);
+	if (rc)
+		goto out;
+
+	if (tpm2_get_audit_log(chip, &log) != TPM2_KKEY_NR_CMDS) {
+		rc = -EIO;
+		goto out;
+	}
+
+	rc = tpm2_kkey_serialize(prov, &audit, log, rsp);
+
+out:
+	tpm2_free_signed_audit(&audit);
+	tpm2_end_auth_session(chip);
+
+	if (magic) {
+		rc2 = tpm2_kernel_nv_clear(chip);
+		if (!rc)
+			rc = rc2;
+	}
+
+	if (null_key)
+		tpm2_flush_context(chip, null_key);
+
+	if (rc) {
+		if (key->handle)
+			tpm2_flush_context(chip, key->handle);
+		memzero_explicit(key, sizeof(*key));
+		prov->len = 0;
+		dev_err(&chip->dev, "failed to create kernel signing key: %d\n",
+			rc);
+	}
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(tpm2_kernel_key_create);
diff --git a/drivers/char/tpm/tpm2-sessions.c b/drivers/char/tpm/tpm2-sessions.c
index e5ef30238fbe..78457843084e 100644
--- a/drivers/char/tpm/tpm2-sessions.c
+++ b/drivers/char/tpm/tpm2-sessions.c
@@ -1073,7 +1073,7 @@ static int tpm2_parse_start_auth_session(struct tpm2_auth *auth,
 	return 0;
 }
 
-static int tpm2_load_null(struct tpm_chip *chip, u32 *null_key)
+int tpm2_load_null(struct tpm_chip *chip, u32 *null_key)
 {
 	unsigned int offset = 0; /* dummy offset for null seed context */
 	u8 name[SHA256_DIGEST_SIZE + 2];
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index 35ba30a2674d..7ee553688906 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -358,6 +358,45 @@ struct tpm2_signed_audit {
 	u8 sig_s[EC_PT_SZ];
 };
 
+/**
+ * struct tpm2_kernel_key - a signing key created by the kernel
+ * @handle:	transient handle of the loaded key
+ * @auth:	the key's random auth value, which never leaves the kernel
+ * @x:		X coordinate of the P-256 public key
+ * @y:		Y coordinate of the P-256 public key
+ */
+struct tpm2_kernel_key {
+	u32 handle;
+	u8 auth[SHA256_DIGEST_SIZE];
+	u8 x[EC_PT_SZ];
+	u8 y[EC_PT_SZ];
+};
+
+#define TPM2_KEY_PROVENANCE_MAX	2048
+
+/**
+ * struct tpm2_key_provenance - evidence that a key was created by the kernel
+ * @len:	length of @data
+ * @data:	serialized AK-signed audit session attestation and log, in a
+ *		format private to the TPM driver
+ */
+struct tpm2_key_provenance {
+	u16 len;
+	u8 data[TPM2_KEY_PROVENANCE_MAX];
+};
+
+#ifdef CONFIG_TCG_TPM2_KERNEL_KEY
+int tpm2_kernel_key_create(struct tpm_chip *chip, struct tpm2_kernel_key *key,
+			   struct tpm2_key_provenance *prov);
+#else
+static inline int tpm2_kernel_key_create(struct tpm_chip *chip,
+					 struct tpm2_kernel_key *key,
+					 struct tpm2_key_provenance *prov)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
 #ifdef CONFIG_TCG_TPM2_HMAC
 
 int tpm2_start_auth_session(struct tpm_chip *chip, bool audit);
-- 
2.43.0

