Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013021.outbound.protection.outlook.com [40.93.196.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E387949E5FB;
	Thu,  8 Oct 2026 13:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791465973; cv=fail; b=JhBTN1fk4NjbKaXx2cqaF4/AMiiHICz40nZyys94nKtruPJ7nIak219Nwi+WXzX3Dnwco6xhzfWAI0xRbk04UDvOM8vDTHOP8PiBW3UBILqs0LvTKwuDRa6CR2D4K/HEwDEGvMO3jrNqxWqriW+ElJ2OsMNpGBy0ECoZK2g6u7Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791465973; c=relaxed/simple;
	bh=tdaKRHADDqrZygZwBNfzX7kdep9Q0FQ3Vsf0ZLCWX1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jlkyQL0S0ezhAa/kQLcDuFfl3d9R0o33jOwcGnnvMkocBCs5tu/wyP/KWt0I4T4nh6EMNptKLjRsgYN+bnHhMW/7nGQC/j0Zm7mwLQVtFRi+vYXN/XBA+G1JRLmPHiu31M9kF2Fgal/7q+a8kG6DsUm2yPHWTWDLJZFntvphUy0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NAvRFHos; arc=fail smtp.client-ip=40.93.196.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NAvRFHos"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HIlg0V1n1AilUJygxJdqj5Ys8CXctiWVUdMfYYXBKWYteZ1T+VHg2u7F6BZ/6LsGZwNVw2eYlK1SKLt82VT9yqJUJ0HTzucxwC96kSOaomacXqvb7coUj79wDrBDvNyg97ofPE3AhPUcgr6cytJRSmuVuPPpXzovzv9KA6fcAC8qweCWX/UcjIhHxDova/6Xi8gBKMkY0NTuQ5KPu3Xg/oq+vg612fbQ/FDtItQr+tNUX/f3kS/Hhl6L+HWDhP8KWbJ0mOD3crPKpo1+hPdCWoy8oI8pvddZ2Txps2n3semexYcqhtGFo9yOW1b+SR6rtjar4XO6NcM3rs5r1Z47Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PfOB63662550cKs72U18L1riGqcVE7uBqyVn9zX5gRU=;
 b=qzXBICCzJKzKOoViRl6uhx1tGgyH3DOXa46WEf2HadqP62cw9BiQgPGLTmJkRJbgyEflJfkGiov93tZG0g7LI6Ju4CZ3vNndm3F66UEHCOUtZFhTQwjd9RfFsD8p7Wg0mXp+EyAEkoUvbZzOSC7KmSm1mOQvIaZhnr6PX8S6D6D6+afG0N9XYB9Gxcy5liqHMVlTK8Q3sVCHz4ZeO69oY+vIKgRda/os0es0kDc9uDzyJ8lJb0IC/7eoQ4O8JvuBb3E11xA+cTmJnqXClKCaLl1t57Go9y6SzBy6boNKUOP2MPrEReLf1UbwYmkwEd3KWlVoBuNZZVIafhtrFNvrYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PfOB63662550cKs72U18L1riGqcVE7uBqyVn9zX5gRU=;
 b=NAvRFHos9qvqsiqffSdMw5sYswmL5CNQqpeuvx59juOdieV4//28a2dLbZaE1dVjeodMCrajeBp+pcFINKLfyaSeAdj4jCr+ioWfDlO1OBvCwP4XEKq1bJbO6RQktjn/AxFy9VJ+KAid7qTWdV97l02WR9vENqZsA1G3Mw80KcFHdjGIJ/MhudaUd0NdoBvSA/rf6opKpYrfs3BqM3qZc485k9fvu38I8sKdZPFUtHDVmg6kRR6aPo/+dTGS94j1VvsNPWA8j55GTQlrp2cT0e80KkMg0aP246KMtw+1vkepSjduphSTOZ/HK+wq4+DGlHAZDg5Ge2dc7LVIyOZ5Ow==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH8PR12MB9741.namprd12.prod.outlook.com (2603:10b6:610:27a::21)
 by DS4PR12MB9796.namprd12.prod.outlook.com (2603:10b6:8:2a2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.17; Thu, 8 Oct
 2026 13:25:59 +0000
Received: from CH8PR12MB9741.namprd12.prod.outlook.com
 ([fe80::43a6:8d0:7081:65d7]) by CH8PR12MB9741.namprd12.prod.outlook.com
 ([fe80::43a6:8d0:7081:65d7%5]) with mapi id 15.21.0472.016; Thu, 8 Oct 2026
 13:25:59 +0000
From: Matthew Garrett <matthewg@nvidia.com>
To: mjg59@srcf.ucam.org
Cc: keyrings@vger.kernel.org,
	James.Bottomley@HansenPartnership.com,
	linux-integrity@vger.kernel.org,
	rafael@kernel.org,
	linux-pm@vger.kernel.org,
	linux-efi@vger.kernel.org,
	Matthew Garrett <matthewg@nvidia.com>
Subject: [PATCH 05/17] tpm: Add a kernel attestation key and signed audit digest retrieval
Date: Thu,  8 Oct 2026 06:20:21 -0700
Message-ID: <20261008132532.1155166-6-matthewg@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261008132532.1155166-1-matthewg@nvidia.com>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0167.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:99::15) To CH8PR12MB9741.namprd12.prod.outlook.com
 (2603:10b6:610:27a::21)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH8PR12MB9741:EE_|DS4PR12MB9796:EE_
X-MS-Office365-Filtering-Correlation-Id: ebf5c1c9-9b34-4241-6432-08df253fb0f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|22082099003|18002099003|10067099003|3023799007|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	VsVVSG7CI8ROlsJpRvZIF5v9t/93o8XDwKfqe9d0+4OWhU8cjEnKKi+df2QIt7JNeWALggFzYsWlzTS0q5ij4EAro9PmAPG2j+rWVwKhvbKHnEo/DOkMTgtB8Zjr6fgi9CPP25eZTYQcMeNk5b+wSZjC/OvrbH/lBr5RojGBRtsSVH2JQUjODtuxuHLKGczG3OL1TN0Kr/GwH8EKyqgTlMlAc95ajs5gYYgjeohcgHbtTBcvcPnVR6zgCmxoVSCO43KzVl52DTR1GReJBXTEidburJHxwMX/9EdY3c/kzHdovGFb5oPx9qhWXZTDtkDgUDGfoDHw5L/8+sRReJthLGvDRP/roN7NqsUo95rHYZMF/CmKvE9g4+/zi6l+BzI/CYz/ltat7wbnOrtwrV57lK0RKGGBLh8Djp0EQ2Qrxk8smgiZSgKEba5l8mdvMSoromnEwU8IfhMxvwRy+w78vizsQS4WYQDeP5pucd+0Z7z+k/ofoektWGR8dLVKD6BKjX4iIO9vYtAMHghDpTfREGigvr9E+doJ6RVk6sX7vxPlQKCGkj09OYRNYHBFcAtXkyQ92nVOB/qyxd/l97gDDTvhKqjrEzF5ZME+ZbPcDG3GGwdS/BawuPi8p5itjhZPzEcsN/oCQv84S6PGg9RTNIDB+5QhXJalzNJeXLrzYkg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH8PR12MB9741.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(22082099003)(18002099003)(10067099003)(3023799007)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?C4qaduWvz/j1+p+DClCvM/29mLnUpHfe996cSw43gePAIB8LmnbB149ouQ+x?=
 =?us-ascii?Q?eUJHC9DLdyPG6/BUk9GN6ZxsOv2QH1MezvHu3k45Ax5yLfkNVOk2tE7QOSp8?=
 =?us-ascii?Q?GWWPQ6yLpb5EKX+YiGciVGB/+AXbUWiHy9I7q4id4jmOau+tI9Ap97pwYX1V?=
 =?us-ascii?Q?JWusX1Q7eLX4vqdKrP0OVF8+hj8upuFp+kvfRDcPQY7AFOyhguv7HgRTYaC4?=
 =?us-ascii?Q?FN3Aj7zvEijkP0KmoeLuVhDI6pIEr468MPsHkOX5jGwnT2tAnKJFBFPoOZX1?=
 =?us-ascii?Q?Zs3ygMFFDdvNWtGmWHRW3j+bpzO+8RnEUbdzjMhQVXJjyyhcL2XgBHqbR4wh?=
 =?us-ascii?Q?A2+98UGvf9JPVrub/4cCc6AOhQ/5hSzUGCvAQ6Xwyf2jMQQEN3+ojrkH85bI?=
 =?us-ascii?Q?knYmIsTfBvoqbEZOO9fdo056UkuRNYFmhbz+jdjojG+AcRpicBAJ2mumE5+l?=
 =?us-ascii?Q?UspkGEA1ezJo/uqVmCXttxqEnnqlwz5PTRARwXGyiR7S5ub4HrwC9HpWaCpi?=
 =?us-ascii?Q?JgdwGsH10E/gvFs72mjiLywPtXg1n7yj7+tyQmN+CuF+AAF4SbEbYhZwrUG/?=
 =?us-ascii?Q?t57mgTUatPviZfzmkLD0TrM8d17CnmdT9HkzcM20xP1OQO1X0gpWXG9NqJGV?=
 =?us-ascii?Q?x6LC9XbNd6C9iJNW8EEA9vbYDfNFIJ0DFoX1mPmrqVtfhs6nHzKobVXavcnA?=
 =?us-ascii?Q?Tt+xp75fyjNnq8lqQN8hJIFaYzyAPwZxVhYBREOy4hKppwh9fJytfIIdvMLF?=
 =?us-ascii?Q?Ts7fRJh1XC6Qem2ZajODXLdJOBS7UCz9amX42IjksrwknBSFMehysGMzueo0?=
 =?us-ascii?Q?JPsyjp+QjY/L/lCvXhCu86JXZlj7VegsThqM7zCe5Ck2QixB6jl04TXcV9Sb?=
 =?us-ascii?Q?zPSAjnwiFlscgBV4iBE0jLBwQCqbRmIBidDVC3ZdzV25Y3H5gDEAowaBQcOd?=
 =?us-ascii?Q?8fMTVkiUZdreblZWAN/CjGm6tprdrWhtfQQjMmOLX8jeNe1KEnpbeiPArWGA?=
 =?us-ascii?Q?8OgQPCYhAS2AjIAqfPbhyZWSHUxlCQ8O1A352mkNwE+KqEdt1mfQ956Hd2t+?=
 =?us-ascii?Q?Eig5o/gCXd6xdvw81Ydr3ajMSrNFMXdf6DXLMsjOzP4opcV59RIf69NrSCuY?=
 =?us-ascii?Q?D7jhL91T+R5knirjnnm59HCbAAjMdTKfGrqefdZscO8hU9RGqYhvilRfXUKk?=
 =?us-ascii?Q?E/bLnmI5g3JWy3Ul0ofZQAzq9V4PcMOd+3bQaU8OF9VSqxTdyIywvfxqCwxX?=
 =?us-ascii?Q?g9o+ynZcbmDZsG7iijNtMcqGjonOop5+oflNxdPpUa0v2KrqOfcTJVCec9gx?=
 =?us-ascii?Q?EWtXl7jxsp5V84CRqdxGGJQVdLMXhFqpaWRUUCzfJCuu01zTg8jjaP43kFZP?=
 =?us-ascii?Q?klwXvw6go00b3ABCqbuNiSOVuH0HTtqNTMoZVC3OxFlNuChQTMUY6e9isDGy?=
 =?us-ascii?Q?IvaNT2eJg4cPPjkigMvBo1r6wILP2NmDxrGmjFXqyx3fHlcIxvLdYUXg/pFH?=
 =?us-ascii?Q?Xk5C5GSMO2iRoANJMFxf2AH1KhNtgksIOoj4MjO6OW+QR/sGufDU2Q2zZ7CW?=
 =?us-ascii?Q?nTjHtb7H2DDutF2cFIfgc24Hleandpjjm4PclqFeNrfNBho1LQIs5yZ7lY5a?=
 =?us-ascii?Q?5vdJAjF3qsiYAeX4tEF/iGstXLn8gkjSwXywjevJfwI5RQuKZ9EcwTRTZSYH?=
 =?us-ascii?Q?Kysk6v7xMZo9VX7Vl2IyIhepUFQTKr9Vi+gSlISc5XLU/XapCPSoJelak7L4?=
 =?us-ascii?Q?Q6+YKAUr0g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebf5c1c9-9b34-4241-6432-08df253fb0f1
X-MS-Exchange-CrossTenant-AuthSource: CH8PR12MB9741.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 13:25:59.2514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bn8+ACwqPMFtADTloAgEDpTa0tw1ZhffuBx0TBFanO9Jn7IwGsA8kglg95RVWRSTww2jNqj6J93ibTF0FVhH3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9796

Add tpm2_create_kernel_ak(), which creates a restricted ECDSA P-256
signing key as a primary key in the owner hierarchy. The template's
unique field holds a fixed seed, which means that (since the primary
keys are derived from the seed and template) the same AK is generated on
every call until something changes the owner seed (ie, the TPM being
cleared or replaced).

We can use this to get a signed copy of the audit digest from a TPM
audit session. Add tpm2_get_signed_audit_digest(), which uses the AK to
sign the digest of the active audit session and returns the TPMS_ATTEST
structure, the signature and the AK public key.

Both the owner and endorsement hierarchies are assumed to have empty
auth values, which is the default. If this turns out to be a problem in
the real world we can look at providing a mechanism for userland to
provide the values at boot or resume times.

Signed-off-by: Matthew Garrett <matthewg@nvidia.com>
---
 drivers/char/tpm/Makefile        |   1 +
 drivers/char/tpm/tpm.h           |   1 +
 drivers/char/tpm/tpm2-ak.c       | 374 +++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm2-sessions.c |  15 ++
 include/linux/tpm.h              |  38 ++++
 include/linux/tpm_command.h      |   8 +
 6 files changed, 437 insertions(+)
 create mode 100644 drivers/char/tpm/tpm2-ak.c

diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index 5b5cdc0d32e4..10a4ed388dea 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -17,6 +17,7 @@ tpm-y += eventlog/tpm1.o
 tpm-y += eventlog/tpm2.o
 tpm-y += tpm-buf.o
 tpm-y += tpm2-sessions.o
+tpm-$(CONFIG_TCG_TPM2_HMAC) += tpm2-ak.o
 
 tpm-$(CONFIG_ACPI) += tpm_ppi.o eventlog/acpi.o
 tpm-$(CONFIG_EFI) += eventlog/efi.o
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index e55fa22a13eb..23070bdb2aa4 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -145,6 +145,7 @@ void tpm_dev_common_exit(void);
 #ifdef CONFIG_TCG_TPM2_HMAC
 int tpm2_sessions_init(struct tpm_chip *chip);
 void tpm2_free_auth(struct tpm2_auth *auth);
+int tpm2_audit_session_handle(struct tpm_chip *chip, u32 *handle);
 #else
 static inline int tpm2_sessions_init(struct tpm_chip *chip)
 {
diff --git a/drivers/char/tpm/tpm2-ak.c b/drivers/char/tpm/tpm2-ak.c
new file mode 100644
index 000000000000..ad24d36b1728
--- /dev/null
+++ b/drivers/char/tpm/tpm2-ak.c
@@ -0,0 +1,374 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Kernel attestation key (AK) support.
+ *
+ * The kernel AK is a restricted ECDSA P-256 signing key created as a
+ * primary key in the owner hierarchy from a fixed template.  Primary keys
+ * are derived from the hierarchy seed and the template, so on a given TPM
+ * the same AK is generated every time until the owner seed changes, which
+ * happens when the TPM is cleared.
+ *
+ * The AK can be used to sign the digest of the kernel's audit session,
+ * allowing the log returned by tpm2_get_audit_log() to be verified.
+ */
+
+#include <linux/slab.h>
+#include <linux/unaligned.h>
+#include "tpm.h"
+
+/*
+ * Restricted signing key whose private part never leaves the TPM.  NO_DA
+ * as the key has an empty auth value.
+ */
+#define TPM2_OA_KERNEL_AK ( \
+	TPM2_OA_FIXED_TPM | \
+	TPM2_OA_FIXED_PARENT | \
+	TPM2_OA_SENSITIVE_DATA_ORIGIN | \
+	TPM2_OA_USER_WITH_AUTH | \
+	TPM2_OA_NO_DA | \
+	TPM2_OA_RESTRICTED | \
+	TPM2_OA_SIGN)
+
+/*
+ * Placed in the unique field of the template.  Changing it changes the
+ * AK derived from the owner seed.
+ */
+static const u8 tpm2_kernel_ak_seed[EC_PT_SZ] =
+	"Linux kernel attestation key v1";
+
+/* Bounds-checked reader for TPM response data */
+struct tpm2_rsp {
+	const u8 *data;
+	u32 len;
+	u32 off;
+	bool err;
+};
+
+static const u8 *tpm2_rsp_bytes(struct tpm2_rsp *r, u32 count)
+{
+	const u8 *p;
+
+	if (r->err || r->len - r->off < count) {
+		r->err = true;
+		return NULL;
+	}
+
+	p = &r->data[r->off];
+	r->off += count;
+	return p;
+}
+
+static u16 tpm2_rsp_u16(struct tpm2_rsp *r)
+{
+	const u8 *p = tpm2_rsp_bytes(r, sizeof(u16));
+
+	return p ? get_unaligned_be16(p) : 0;
+}
+
+static u32 tpm2_rsp_u32(struct tpm2_rsp *r)
+{
+	const u8 *p = tpm2_rsp_bytes(r, sizeof(u32));
+
+	return p ? get_unaligned_be32(p) : 0;
+}
+
+/* Initialise a reader over the response held in @buf */
+static void tpm2_rsp_init(struct tpm2_rsp *r, struct tpm_buf *buf)
+{
+	struct tpm_header *head = (struct tpm_header *)buf->data;
+
+	r->data = buf->data;
+	r->len = min_t(u32, be32_to_cpu(head->length), TPM_BUFSIZE);
+	r->off = TPM_HEADER_SIZE;
+	r->err = r->len < TPM_HEADER_SIZE;
+}
+
+/* Read a TPM2B_ECC_PARAMETER, left-padding it to EC_PT_SZ bytes */
+static void tpm2_rsp_ecc_param(struct tpm2_rsp *r, u8 *out)
+{
+	u16 len = tpm2_rsp_u16(r);
+	const u8 *p;
+
+	if (len > EC_PT_SZ) {
+		r->err = true;
+		return;
+	}
+
+	p = tpm2_rsp_bytes(r, len);
+	if (!p)
+		return;
+
+	memset(out, 0, EC_PT_SZ - len);
+	memcpy(out + EC_PT_SZ - len, p, len);
+}
+
+/* Parse and validate the TPM2B_PUBLIC of the kernel AK */
+static int tpm2_parse_kernel_ak_public(struct tpm2_rsp *r, u8 *x, u8 *y)
+{
+	u16 size = tpm2_rsp_u16(r);
+	u32 end = r->off + size;
+
+	if (tpm2_rsp_u16(r) != TPM_ALG_ECC ||
+	    tpm2_rsp_u16(r) != TPM_ALG_SHA256 ||
+	    tpm2_rsp_u32(r) != TPM2_OA_KERNEL_AK ||
+	    tpm2_rsp_u16(r) != 0 ||			/* authPolicy */
+	    tpm2_rsp_u16(r) != TPM_ALG_NULL ||		/* symmetric */
+	    tpm2_rsp_u16(r) != TPM_ALG_ECDSA ||		/* scheme */
+	    tpm2_rsp_u16(r) != TPM_ALG_SHA256 ||	/* scheme hash */
+	    tpm2_rsp_u16(r) != TPM2_ECC_NIST_P256 ||
+	    tpm2_rsp_u16(r) != TPM_ALG_NULL)		/* kdf */
+		return -EINVAL;
+
+	tpm2_rsp_ecc_param(r, x);
+	tpm2_rsp_ecc_param(r, y);
+
+	if (r->err || r->off != end)
+		return -EINVAL;
+
+	return 0;
+}
+
+/**
+ * tpm2_create_kernel_ak() - create the kernel attestation key
+ * @chip:	the TPM chip
+ * @handle:	set to the transient handle of the AK on success
+ * @x:		if not NULL, filled with the X coordinate of the AK public key
+ * @y:		if not NULL, filled with the Y coordinate of the AK public key
+ *
+ * Creates the kernel AK as a primary key in the owner hierarchy using a
+ * fixed template, so the same key is returned on every call until the
+ * TPM is cleared.  The owner hierarchy must have an empty auth value.
+ * The caller must hold the chip's ops lock and is responsible for
+ * flushing @handle with tpm2_flush_context().
+ *
+ * Return:
+ * * 0		- OK
+ * * -errno	- A system error
+ * * TPM_RC	- A TPM error
+ */
+int tpm2_create_kernel_ak(struct tpm_chip *chip, u32 *handle, u8 *x, u8 *y)
+{
+	struct tpm_buf *template __free(kfree) = NULL;
+	struct tpm_buf *buf __free(kfree) = NULL;
+	u8 ak_x[EC_PT_SZ], ak_y[EC_PT_SZ];
+	struct tpm2_rsp r;
+	u32 ak;
+	int rc;
+
+	buf = kzalloc(TPM_BUFSIZE, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	template = kzalloc(TPM_BUFSIZE, GFP_KERNEL);
+	if (!template)
+		return -ENOMEM;
+
+	tpm_buf_init(buf, TPM_BUFSIZE);
+	tpm_buf_reset(buf, TPM2_ST_SESSIONS, TPM2_CC_CREATE_PRIMARY);
+	tpm_buf_init_sized(template, TPM_BUFSIZE);
+
+	/* key type */
+	tpm_buf_append_u16(template, TPM_ALG_ECC);
+	/* name algorithm */
+	tpm_buf_append_u16(template, TPM_ALG_SHA256);
+	/* object properties */
+	tpm_buf_append_u32(template, TPM2_OA_KERNEL_AK);
+	/* auth policy (empty) */
+	tpm_buf_append_u16(template, 0);
+	/* symmetric algorithm (none for a signing key) */
+	tpm_buf_append_u16(template, TPM_ALG_NULL);
+	/* signing scheme */
+	tpm_buf_append_u16(template, TPM_ALG_ECDSA);
+	tpm_buf_append_u16(template, TPM_ALG_SHA256);
+	/* ECC curve */
+	tpm_buf_append_u16(template, TPM2_ECC_NIST_P256);
+	/* KDF scheme */
+	tpm_buf_append_u16(template, TPM_ALG_NULL);
+	/* unique: the fixed seed as X, empty Y */
+	tpm_buf_append_u16(template, sizeof(tpm2_kernel_ak_seed));
+	tpm_buf_append(template, tpm2_kernel_ak_seed,
+		       sizeof(tpm2_kernel_ak_seed));
+	tpm_buf_append_u16(template, 0);
+
+	/* primary handle */
+	tpm_buf_append_handle(buf, TPM2_RH_OWNER);
+	tpm_buf_append_auth(chip, buf, NULL, 0);
+
+	/* sensitive create: empty auth and data */
+	tpm_buf_append_u16(buf, 4);
+	tpm_buf_append_u16(buf, 0);
+	tpm_buf_append_u16(buf, 0);
+
+	/* the public template */
+	tpm_buf_append(buf, template->data, template->length);
+
+	/* outside info (empty) */
+	tpm_buf_append_u16(buf, 0);
+
+	/* creation PCR (none) */
+	tpm_buf_append_u32(buf, 0);
+
+	if (buf->flags & TPM_BUF_INVALID || template->flags & TPM_BUF_INVALID)
+		return -EINVAL;
+
+	rc = tpm_transmit_cmd(chip, buf, 0, "creating kernel AK");
+	if (rc)
+		return rc;
+
+	tpm2_rsp_init(&r, buf);
+	ak = tpm2_rsp_u32(&r);
+	/* parameterSize */
+	tpm2_rsp_u32(&r);
+	if (r.err)
+		return -EINVAL;
+
+	rc = tpm2_parse_kernel_ak_public(&r, ak_x, ak_y);
+	if (rc) {
+		dev_err(&chip->dev, "unexpected kernel AK public area\n");
+		tpm2_flush_context(chip, ak);
+		return rc;
+	}
+
+	if (x)
+		memcpy(x, ak_x, EC_PT_SZ);
+	if (y)
+		memcpy(y, ak_y, EC_PT_SZ);
+	*handle = ak;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(tpm2_create_kernel_ak);
+
+/**
+ * tpm2_get_signed_audit_digest() - get the audit session digest signed by the AK
+ * @chip:	the TPM chip
+ * @nonce:	qualifying data to include in the attestation (may be NULL)
+ * @nonce_len:	length of @nonce
+ * @audit:	filled with the signed attestation and the AK public key
+ *
+ * Creates the kernel AK and uses TPM2_GetSessionAuditDigest to have it
+ * sign the digest of the active audit session.  The session itself is not
+ * used to authorize the command, so the audit digest and the log returned
+ * by tpm2_get_audit_log() are unaffected.  The endorsement and owner
+ * hierarchies must have empty auth values.  The caller must hold the
+ * chip's ops lock and must release @audit with tpm2_free_signed_audit().
+ *
+ * Return:
+ * * 0		- OK
+ * * -EINVAL	- No audit session is active, or the response was malformed
+ * * -errno	- A system error
+ * * TPM_RC	- A TPM error
+ */
+int tpm2_get_signed_audit_digest(struct tpm_chip *chip, const u8 *nonce,
+				 u16 nonce_len,
+				 struct tpm2_signed_audit *audit)
+{
+	struct tpm_buf *buf __free(kfree) = NULL;
+	u32 session, ak, param_size, end;
+	const u8 *attest;
+	struct tpm2_rsp r;
+	u16 attest_len;
+	int rc;
+
+	memset(audit, 0, sizeof(*audit));
+
+	if (nonce_len > TPM2_MAX_DIGEST_SIZE)
+		return -EINVAL;
+
+	rc = tpm2_audit_session_handle(chip, &session);
+	if (rc)
+		return rc;
+
+	buf = kzalloc(TPM_BUFSIZE, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	rc = tpm2_create_kernel_ak(chip, &ak, audit->ak_x, audit->ak_y);
+	if (rc)
+		return rc;
+
+	tpm_buf_init(buf, TPM_BUFSIZE);
+	tpm_buf_reset(buf, TPM2_ST_SESSIONS, TPM2_CC_GET_SESSION_AUDIT_DIGEST);
+
+	/* privacyAdminHandle, signHandle, sessionHandle */
+	tpm_buf_append_handle(buf, TPM2_RH_ENDORSEMENT);
+	tpm_buf_append_handle(buf, ak);
+	tpm_buf_append_handle(buf, session);
+
+	/* empty password authorizations for the endorsement hierarchy and AK */
+	tpm_buf_append_auth(chip, buf, NULL, 0);
+	tpm_buf_append_auth(chip, buf, NULL, 0);
+
+	/* qualifyingData */
+	tpm_buf_append_u16(buf, nonce_len);
+	if (nonce_len)
+		tpm_buf_append(buf, nonce, nonce_len);
+
+	/* inScheme: use the AK's scheme */
+	tpm_buf_append_u16(buf, TPM_ALG_NULL);
+
+	if (buf->flags & TPM_BUF_INVALID) {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	rc = tpm_transmit_cmd(chip, buf, 0, "getting session audit digest");
+	if (rc)
+		goto out;
+
+	rc = -EINVAL;
+	tpm2_rsp_init(&r, buf);
+	param_size = tpm2_rsp_u32(&r);
+	end = r.off + param_size;
+
+	/* auditInfo */
+	attest_len = tpm2_rsp_u16(&r);
+	attest = tpm2_rsp_bytes(&r, attest_len);
+	if (!attest)
+		goto out;
+
+	/* TPMS_ATTEST begins with magic and type */
+	if (attest_len < sizeof(u32) + sizeof(u16) ||
+	    get_unaligned_be32(attest) != TPM2_GENERATED_VALUE ||
+	    get_unaligned_be16(attest + sizeof(u32)) !=
+	    TPM2_ST_ATTEST_SESSION_AUDIT)
+		goto out;
+
+	/* signature */
+	if (tpm2_rsp_u16(&r) != TPM_ALG_ECDSA ||
+	    tpm2_rsp_u16(&r) != TPM_ALG_SHA256)
+		goto out;
+	tpm2_rsp_ecc_param(&r, audit->sig_r);
+	tpm2_rsp_ecc_param(&r, audit->sig_s);
+
+	if (r.err || r.off != end)
+		goto out;
+
+	audit->attest = kmemdup(attest, attest_len, GFP_KERNEL);
+	if (!audit->attest) {
+		rc = -ENOMEM;
+		goto out;
+	}
+	audit->attest_len = attest_len;
+	rc = 0;
+
+out:
+	if (rc < 0 && rc != -ENOMEM)
+		dev_err(&chip->dev, "failed to get session audit digest: %d\n",
+			rc);
+	tpm2_flush_context(chip, ak);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(tpm2_get_signed_audit_digest);
+
+/**
+ * tpm2_free_signed_audit() - release a signed audit digest
+ * @audit:	the structure filled by tpm2_get_signed_audit_digest()
+ */
+void tpm2_free_signed_audit(struct tpm2_signed_audit *audit)
+{
+	kfree(audit->attest);
+	audit->attest = NULL;
+	audit->attest_len = 0;
+}
+EXPORT_SYMBOL_GPL(tpm2_free_signed_audit);
diff --git a/drivers/char/tpm/tpm2-sessions.c b/drivers/char/tpm/tpm2-sessions.c
index 56323a9ac87a..badc9bec9caa 100644
--- a/drivers/char/tpm/tpm2-sessions.c
+++ b/drivers/char/tpm/tpm2-sessions.c
@@ -1023,6 +1023,21 @@ int tpm2_get_audit_log(struct tpm_chip *chip,
 }
 EXPORT_SYMBOL(tpm2_get_audit_log);
 
+/*
+ * Return the handle of the active audit session, or -EINVAL if there is
+ * no active audit session.
+ */
+int tpm2_audit_session_handle(struct tpm_chip *chip, u32 *handle)
+{
+	struct tpm2_auth *auth = chip->auth;
+
+	if (!auth || !auth->audit)
+		return -EINVAL;
+
+	*handle = auth->handle;
+	return 0;
+}
+
 static int tpm2_parse_start_auth_session(struct tpm2_auth *auth,
 					 struct tpm_buf *buf)
 {
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index c1d0617ff8a1..1d828b32847f 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -329,11 +329,35 @@ struct tpm2_audit_entry {
 	u8 rphash[SHA256_DIGEST_SIZE];
 };
 
+/**
+ * struct tpm2_signed_audit - a session audit digest signed by the kernel AK
+ * @ak_x:	X coordinate of the AK's P-256 public key
+ * @ak_y:	Y coordinate of the AK's P-256 public key
+ * @attest:	the signed TPMS_ATTEST structure, containing the audit digest
+ * @attest_len:	length of @attest
+ * @sig_r:	R component of the ECDSA-SHA256 signature over @attest
+ * @sig_s:	S component of the ECDSA-SHA256 signature over @attest
+ */
+struct tpm2_signed_audit {
+	u8 ak_x[EC_PT_SZ];
+	u8 ak_y[EC_PT_SZ];
+	u8 *attest;
+	u16 attest_len;
+	u8 sig_r[EC_PT_SZ];
+	u8 sig_s[EC_PT_SZ];
+};
+
 #ifdef CONFIG_TCG_TPM2_HMAC
 
 int tpm2_start_auth_session(struct tpm_chip *chip, bool audit);
 int tpm2_get_audit_log(struct tpm_chip *chip,
 		       const struct tpm2_audit_entry **log);
+int tpm2_create_kernel_ak(struct tpm_chip *chip, u32 *handle,
+			  u8 *x, u8 *y);
+int tpm2_get_signed_audit_digest(struct tpm_chip *chip, const u8 *nonce,
+				 u16 nonce_len,
+				 struct tpm2_signed_audit *audit);
+void tpm2_free_signed_audit(struct tpm2_signed_audit *audit);
 int tpm_buf_fill_hmac_session(struct tpm_chip *chip, struct tpm_buf *buf);
 int tpm_buf_check_hmac_response(struct tpm_chip *chip, struct tpm_buf *buf,
 				int rc);
@@ -354,6 +378,20 @@ static inline int tpm2_get_audit_log(struct tpm_chip *chip,
 {
 	return -EOPNOTSUPP;
 }
+static inline int tpm2_create_kernel_ak(struct tpm_chip *chip, u32 *handle,
+					u8 *x, u8 *y)
+{
+	return -EOPNOTSUPP;
+}
+static inline int
+tpm2_get_signed_audit_digest(struct tpm_chip *chip, const u8 *nonce,
+			     u16 nonce_len, struct tpm2_signed_audit *audit)
+{
+	return -EOPNOTSUPP;
+}
+static inline void tpm2_free_signed_audit(struct tpm2_signed_audit *audit)
+{
+}
 
 static inline int tpm_buf_fill_hmac_session(struct tpm_chip *chip,
 					    struct tpm_buf *buf)
diff --git a/include/linux/tpm_command.h b/include/linux/tpm_command.h
index 79f547ca6dbf..486493efa759 100644
--- a/include/linux/tpm_command.h
+++ b/include/linux/tpm_command.h
@@ -189,6 +189,7 @@ enum tpm2_timeouts {
 enum tpm2_structures {
 	TPM2_ST_NO_SESSIONS	= 0x8001,
 	TPM2_ST_SESSIONS	= 0x8002,
+	TPM2_ST_ATTEST_SESSION_AUDIT = 0x8016,
 	TPM2_ST_CREATION	= 0x8021,
 };
 
@@ -230,6 +231,7 @@ enum tpm2_command_codes {
 	TPM2_CC_SELF_TEST		= 0x0143,
 	TPM2_CC_STARTUP			= 0x0144,
 	TPM2_CC_SHUTDOWN		= 0x0145,
+	TPM2_CC_GET_SESSION_AUDIT_DIGEST = 0x014D,
 	TPM2_CC_NV_READ			= 0x014E,
 	TPM2_CC_NV_READ_LOCK		= 0x014F,
 	TPM2_CC_CREATE			= 0x0153,
@@ -275,10 +277,15 @@ enum tpm2_cc_attrs {
 };
 
 enum tpm2_permanent_handles {
+	TPM2_RH_OWNER		= 0x40000001,
 	TPM2_RH_NULL		= 0x40000007,
 	TPM2_RS_PW		= 0x40000009,
+	TPM2_RH_ENDORSEMENT	= 0x4000000B,
 };
 
+/* TPMS_ATTEST.magic */
+#define TPM2_GENERATED_VALUE	0xff544347
+
 /* Most Significant Octet for key types  */
 enum tpm2_mso_type {
 	TPM2_MSO_NVRAM		= 0x01,
@@ -479,6 +486,7 @@ enum tpm_algorithms {
 	TPM_ALG_SHA512		= 0x000D,
 	TPM_ALG_NULL		= 0x0010,
 	TPM_ALG_SM3_256		= 0x0012,
+	TPM_ALG_ECDSA		= 0x0018,
 	TPM_ALG_ECC		= 0x0023,
 	TPM_ALG_CFB		= 0x0043,
 };
-- 
2.43.0

