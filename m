Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012009.outbound.protection.outlook.com [40.107.200.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F544AA57C;
	Thu,  8 Oct 2026 13:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791465990; cv=fail; b=RzNV6nxCi7MtevoyQ5HPCZrcnDrh96ztq/Vht0s9IgtFw/VOEo7Ya58LmppQ+bXzA6WpyjWZ3uZCxY+tG1CJqpcZaJ5KG1j6G3Yv+w49SroeSyxnGk7ECBO18o9/JzcWWFOJtWHbfUmdX+d6M0QWjbF8miIfK2ATCJzxblGl3no=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791465990; c=relaxed/simple;
	bh=e7GoBoYtTrcsLrsaHXlFEO1B4WtLuZp0y5BhA9Y8wfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=S1NVszXc6T84u0g/+b6FWEhECKgbOAaAc5YNxz0sTAY0GisczsB4DW8zFiEGRSLvLs5f1u+o/4LHTAVgoE9nDwdPoiRvWbnNx/bMIEnclsJLgQSqviJify88g4sugGnXvuX9b65k1nElZckDmXaR+MKn6GZySpOthYCsVoztetg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lg2hfTFv; arc=fail smtp.client-ip=40.107.200.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lg2hfTFv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RdI58ZEdGnntokxwtmx6SyXjEXt8GWV7axsnvvdb1/asoCp7RGO2NP7CGzEJfSNL3kAhBqh6OMWxEdVS3mL9jcV8ccmuhLq8ks+r4n4PkeBRpEW9ktpY/bt6yQKA/1c+LUoG+A4/OrPCUL1EtOnx6JsYw+PJ15TqChW07IOYXpvnv9cstVM2lFPq12wL9l3KVST8yowVjsJEP2HocUnbIleb+W8lB9428U3kSHV7CZn19I40NLp1yKdVIEmCn9kHiZmntP46d4Nvlk5XliGkUBNISHw8PRP4yDm2gPrqO7xQDpeGAN4nBs70SHldnZZddw4x1CSOrpB0Cua8KNNHlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ty3x9j43JJiWJdKDZLtcN5SYdGlS/WIIbtC12z8fy1w=;
 b=roqtWPQ3taWNFWZek0a/e3MOphp6edg+orJ1Eun6vSS7TMmsx4c3YQuvsVaP3XkeVK7WPHEhR35FLpxsHrpa5sv6shaUbx26JxGXKOf22j/C7QmiFRs7CUwaEYhG4dfZadqd1na+seNMsAEnsc9wsvXljym5VEv/IlmOTpR4Ql0e8xhF7Efm28dvZ4nv81y9k8sLeJS1/O+jH+OXIFpt2WKoZxpn0Y6OqmgmxkRFKSrcK3IWeA2jwWrZTPESfXgKfEx+nqmqS1xZu2wM5+tCG5VEaSyCnN0J3xlGBMzV2OxABI7HFkbS3XgnHWFDsK4ttXHvsvHN+bWIPT4Tma7t6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ty3x9j43JJiWJdKDZLtcN5SYdGlS/WIIbtC12z8fy1w=;
 b=lg2hfTFvrONz/nxVwOxecpHWfxZUY5dX4MTH55AmTC/Tzf3du8MqwLsUQlje296Pglg+n2MqKztnwyd2BEKyg9KD2Q4KEG1oKIH7tk9b+owC2cQEHw3QZ2MkflyPNSQ1VflkvF1Uny326BcYod5wiqZL35lPP/3kbDp6olY0FXXWpF8Vung6lmKCI9NG6Sa1YEQPw+NUHApurU6SUTYGXiz2FDh10v4HRzmjpHMJcn81KngfxyYVcUXUDJthfw6vPIsEUQgABME+EPimn2HGZWwi0gOpNe47lw4mErWPxDAH5Fp3CLHsmGLtcNlRRVCI+Jn50F5mdNYfCb/y5u7BMg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH8PR12MB9741.namprd12.prod.outlook.com (2603:10b6:610:27a::21)
 by CY8PR12MB7587.namprd12.prod.outlook.com (2603:10b6:930:9a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.26; Thu, 8 Oct
 2026 13:26:17 +0000
Received: from CH8PR12MB9741.namprd12.prod.outlook.com
 ([fe80::43a6:8d0:7081:65d7]) by CH8PR12MB9741.namprd12.prod.outlook.com
 ([fe80::43a6:8d0:7081:65d7%5]) with mapi id 15.21.0472.016; Thu, 8 Oct 2026
 13:26:17 +0000
From: Matthew Garrett <matthewg@nvidia.com>
To: mjg59@srcf.ucam.org
Cc: keyrings@vger.kernel.org,
	James.Bottomley@HansenPartnership.com,
	linux-integrity@vger.kernel.org,
	rafael@kernel.org,
	linux-pm@vger.kernel.org,
	linux-efi@vger.kernel.org,
	Matthew Garrett <matthewg@nvidia.com>
Subject: [PATCH 10/17] tpm: Move the bounds-checked response reader to a header
Date: Thu,  8 Oct 2026 06:20:26 -0700
Message-ID: <20261008132532.1155166-11-matthewg@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261008132532.1155166-1-matthewg@nvidia.com>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0082.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9b::9) To CH8PR12MB9741.namprd12.prod.outlook.com
 (2603:10b6:610:27a::21)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH8PR12MB9741:EE_|CY8PR12MB7587:EE_
X-MS-Office365-Filtering-Correlation-Id: bcbf5575-dc95-4069-0de7-08df253fbb6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|10067099003|11063799006|56012099006|3023799007|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	sLdRpMhl0OcAkc/1EBjP/eVBAUp4IgG4SPYHMySHlS6aJMGKa6jcn1y/YKBVRIEYNcLqOdstmpvZehLgmaqtIIB0ri8hBjgJ0+Wxyt8xz0UCxNeB9EfqcgaBidWPhhSBtbry4hiPNM2fZhAK+NAatPejKXR2qT/054+VogVoOXzZmW3h/guB1j9021/bmiOqvO/u+vY5O7FgE/TF8tDp5SPzPiVZvlXcWRXWU4rI9eW5qnLBgr2xcKGZsPhV9rWv/ui8c+m9PLLjghjLzxNeyQy174rqPBpDX6guyTEEPfwQBhc3ZCyRLLQVnFOyIwICSRNdJGjNsypHCA7hebvYjo7Coxni+BvacsCtNmcbpKcmCqj/KaWsGR0Pyd9qz2gmaNaZQNYvpBdmiVk/v5iGqM/cU113+IEjjpY9IlEOVNSOTXUdfjrZF6EC8wz8y/1qVvYHC4CoT47X+xsaVd7kgU54sNsrJdfLzissjBEOMEYskLzH0uX9ttpECVsa12R8014wcFrUeWs+ItL4gawf/V6NtO6Vhk26ugr6Dp5o+8r8hC3I7CyDNsYxFvCQHXJYVgfE/zc4OzvPAWzRel/n+DFlGoRbHunyvS3L2/5t7iWtgB0zjoHgbiQ0OuBino5TynQwMBi9WzIwMinuzs8f+iEWI7hdYoTcYC+D0EpPDbU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH8PR12MB9741.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(10067099003)(11063799006)(56012099006)(3023799007)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cfI9sFrXhTwhb2uErtTQvWC1PhTQrTo4CwE1O10GiulJXnGfeQK1R2BShr1g?=
 =?us-ascii?Q?C3UogGEbBYw/7JZXy50Tc7ZyN9/6qweebZBC4DdHFPkW+h1Ed66vuCILx58s?=
 =?us-ascii?Q?Hs1Vc576GDSsP/2brqdVnv3iylKyIkNh7VLUqNy3iCxFvTy2iAZZ0i0pswDm?=
 =?us-ascii?Q?hlz/dJUzYlAFLHB3dZ6dfouHB0TJ3ag8N4Wz9aYlUjOR/dZy2bcGvdpvILa4?=
 =?us-ascii?Q?Hi5AAm3wKPRcyO1gaQAPqS3i8TJb6XVZs0MjUdjpil6UWaHp5/D04JcbCJ39?=
 =?us-ascii?Q?J8qrzoKjGh1Gc/wdsrDbmgxEv8lqDFAw7zroNXyYrNNU0KXn1P1doRbJJyqY?=
 =?us-ascii?Q?EbR6fl2nsvr5ANeyACAnihRZdniD+5XsAxpH8imAhgdpXZUojQP4qhfy6ueU?=
 =?us-ascii?Q?17gnYjd5xQeuNU7hpQRvoBcVP2l3ww9Ge+5xN93JoHG1CiEblTpV/Wfr4GRe?=
 =?us-ascii?Q?Jh+pf7tGTXyy8cPxt/uxsdve0vlYuXHecAIe97ZIi8Xl+if6SYpLxo2w5ejV?=
 =?us-ascii?Q?PNceyWS03aavzitRAA7rSGE54Ax4U9bWl6usOc6w3pIGknpqc8pDFwcUHzQj?=
 =?us-ascii?Q?91x4WOwAJH5MuhP6+ybJiydgjwxf6YYy6R2i3STMv50eFPyfTSIiejjhaBp6?=
 =?us-ascii?Q?d6lH/E4EJJxD4Ous4OPfvrPmGaGnjFIcZKYE/Kmp3ae8dkIDiAwnUoLDDpwK?=
 =?us-ascii?Q?XvMqaGMWzmBafhaLvXIDp6C4DoSpo1qXqoVlhayZKJpn7SZffMe7PJRXlEyF?=
 =?us-ascii?Q?eyQWc/8OR1uwwWmKb1Rwt6jworRuQ+h37KZofgWbnpeK7e77lcSzEZRE8OC/?=
 =?us-ascii?Q?+1cfbAtCMEMkT95C/KkrEZ8OYMs3aA9Gq4NHGFzHjGdTWAacosKIup3tGIxY?=
 =?us-ascii?Q?Sklzr7lEuiiZpX8Je+CYDibdP4SYu6A6oXg36CIfo0ijRRrZ17RTNnlY6VF4?=
 =?us-ascii?Q?xrXoeIlJuuSw/UlKLNTTeCm6z6ZVdfrjKmaKZw2GzdNFae/LYqTwotEY6iMu?=
 =?us-ascii?Q?khkBOUV0V6MtIwE21pQ7eWH7LA0SDlRA5KuNV0ZwVcKqKEZJEkc4pvkIklk1?=
 =?us-ascii?Q?xCGtu5loi/eI79xpQmrgtNcq61YfPZfHVofb5iAOlorzr4pXb+eTNCyfYbZ1?=
 =?us-ascii?Q?Xvdg2T3+Hhh8nXQe04H9uG8fXNI4ZfPpci1AKji+ZBFKLu9+I1tjR/rqalrb?=
 =?us-ascii?Q?aS+yXjWmkoxLe627uNPYG3vCOUByy3D8STdRpgKXKg1TRy6bKa9Rbt3IPSGW?=
 =?us-ascii?Q?mwk6jAZAvuGmmf2N/OrZnhLNkvb/hvWUZCbwrZHndoS01y4e1U76bsUFm+TQ?=
 =?us-ascii?Q?nCAcBcIjYUTNgTUlIqIehP76mgmD0xu7QqCgTnUGt9eJJSXTj8VmUnVLOMRk?=
 =?us-ascii?Q?ege8jbEwuGMXYaTjzET55jg+HBRz7zKlDiLMviG0T833MhsRaBkMq/EU0Qz8?=
 =?us-ascii?Q?cBOJb0DGxSEPe1OC2qBVys0gC9ivMNHImrBZ4vxgCkk44IOq0GFK52wK7+33?=
 =?us-ascii?Q?tjrw3zI6Sqp7fO+kzuso721Oc7ARdR3xZgvzcsHrreCj/wX/PebeLH522bCT?=
 =?us-ascii?Q?hZYgaseazXS+ch+516PAddY+YbTKTmX5t64FJsLmZVmB6pVRcHK7CDy0UXKe?=
 =?us-ascii?Q?CRlJ0c5HF2L4SrlWgJD4jUJ1PZ1GKQn5JbQVAffCCwaufBfegI2rCdW9RlnT?=
 =?us-ascii?Q?uGphE4NSXO4Zj/JjFD2ca6X4qP+vpKd/DGfXJ9CXJljDEmq13EuawGBF7s9S?=
 =?us-ascii?Q?6D6TcwBgYQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcbf5575-dc95-4069-0de7-08df253fbb6d
X-MS-Exchange-CrossTenant-AuthSource: CH8PR12MB9741.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 13:26:16.9446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BzjeKTyA3mDaBj9qeQZsqyciAVOa2o5HOMVCIpuxaTGcC1htuc7jGWPvjUB9fpaI2hUUeHYf6XIxvCl1+lOUgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7587

"tpm: Add NV define, undefine and write helpers" added some helper code
to reduce duplication in parsing TPM responses. This could be useful
elsewhere, so move it out to a header and add some additional features
that will be used shortly.

Signed-off-by: Matthew Garrett <matthewg@nvidia.com>
---
 drivers/char/tpm/tpm2-ak.c  |  89 +-----------------------
 drivers/char/tpm/tpm2-rsp.h | 132 ++++++++++++++++++++++++++++++++++++
 2 files changed, 134 insertions(+), 87 deletions(-)
 create mode 100644 drivers/char/tpm/tpm2-rsp.h

diff --git a/drivers/char/tpm/tpm2-ak.c b/drivers/char/tpm/tpm2-ak.c
index ad24d36b1728..18968c8d2b48 100644
--- a/drivers/char/tpm/tpm2-ak.c
+++ b/drivers/char/tpm/tpm2-ak.c
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <linux/unaligned.h>
 #include "tpm.h"
+#include "tpm2-rsp.h"
 
 /*
  * Restricted signing key whose private part never leaves the TPM.  NO_DA
@@ -36,96 +37,10 @@
 static const u8 tpm2_kernel_ak_seed[EC_PT_SZ] =
 	"Linux kernel attestation key v1";
 
-/* Bounds-checked reader for TPM response data */
-struct tpm2_rsp {
-	const u8 *data;
-	u32 len;
-	u32 off;
-	bool err;
-};
-
-static const u8 *tpm2_rsp_bytes(struct tpm2_rsp *r, u32 count)
-{
-	const u8 *p;
-
-	if (r->err || r->len - r->off < count) {
-		r->err = true;
-		return NULL;
-	}
-
-	p = &r->data[r->off];
-	r->off += count;
-	return p;
-}
-
-static u16 tpm2_rsp_u16(struct tpm2_rsp *r)
-{
-	const u8 *p = tpm2_rsp_bytes(r, sizeof(u16));
-
-	return p ? get_unaligned_be16(p) : 0;
-}
-
-static u32 tpm2_rsp_u32(struct tpm2_rsp *r)
-{
-	const u8 *p = tpm2_rsp_bytes(r, sizeof(u32));
-
-	return p ? get_unaligned_be32(p) : 0;
-}
-
-/* Initialise a reader over the response held in @buf */
-static void tpm2_rsp_init(struct tpm2_rsp *r, struct tpm_buf *buf)
-{
-	struct tpm_header *head = (struct tpm_header *)buf->data;
-
-	r->data = buf->data;
-	r->len = min_t(u32, be32_to_cpu(head->length), TPM_BUFSIZE);
-	r->off = TPM_HEADER_SIZE;
-	r->err = r->len < TPM_HEADER_SIZE;
-}
-
-/* Read a TPM2B_ECC_PARAMETER, left-padding it to EC_PT_SZ bytes */
-static void tpm2_rsp_ecc_param(struct tpm2_rsp *r, u8 *out)
-{
-	u16 len = tpm2_rsp_u16(r);
-	const u8 *p;
-
-	if (len > EC_PT_SZ) {
-		r->err = true;
-		return;
-	}
-
-	p = tpm2_rsp_bytes(r, len);
-	if (!p)
-		return;
-
-	memset(out, 0, EC_PT_SZ - len);
-	memcpy(out + EC_PT_SZ - len, p, len);
-}
-
 /* Parse and validate the TPM2B_PUBLIC of the kernel AK */
 static int tpm2_parse_kernel_ak_public(struct tpm2_rsp *r, u8 *x, u8 *y)
 {
-	u16 size = tpm2_rsp_u16(r);
-	u32 end = r->off + size;
-
-	if (tpm2_rsp_u16(r) != TPM_ALG_ECC ||
-	    tpm2_rsp_u16(r) != TPM_ALG_SHA256 ||
-	    tpm2_rsp_u32(r) != TPM2_OA_KERNEL_AK ||
-	    tpm2_rsp_u16(r) != 0 ||			/* authPolicy */
-	    tpm2_rsp_u16(r) != TPM_ALG_NULL ||		/* symmetric */
-	    tpm2_rsp_u16(r) != TPM_ALG_ECDSA ||		/* scheme */
-	    tpm2_rsp_u16(r) != TPM_ALG_SHA256 ||	/* scheme hash */
-	    tpm2_rsp_u16(r) != TPM2_ECC_NIST_P256 ||
-	    tpm2_rsp_u16(r) != TPM_ALG_NULL)		/* kdf */
-		return -EINVAL;
-
-	tpm2_rsp_ecc_param(r, x);
-	tpm2_rsp_ecc_param(r, y);
-
-	if (r->err || r->off != end)
-		return -EINVAL;
-
-	return 0;
+	return tpm2_rsp_ecdsa_public(r, TPM2_OA_KERNEL_AK, x, y);
 }
 
 /**
diff --git a/drivers/char/tpm/tpm2-rsp.h b/drivers/char/tpm/tpm2-rsp.h
new file mode 100644
index 000000000000..3ee1f0f2e6ad
--- /dev/null
+++ b/drivers/char/tpm/tpm2-rsp.h
@@ -0,0 +1,132 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Bounds-checked reader for data returned by the TPM.  Reading past the
+ * end of the data sets an error flag and returns zeros, so a sequence of
+ * reads can be checked once at the end.
+ */
+#ifndef __TPM2_RSP_H__
+#define __TPM2_RSP_H__
+
+#include <linux/tpm.h>
+#include <linux/unaligned.h>
+
+struct tpm2_rsp {
+	const u8 *data;
+	u32 len;
+	u32 off;
+	bool err;
+};
+
+static inline void tpm2_rsp_init_data(struct tpm2_rsp *r, const u8 *data,
+				      u32 len)
+{
+	r->data = data;
+	r->len = len;
+	r->off = 0;
+	r->err = false;
+}
+
+/* Initialise a reader over the parameters of the response held in @buf */
+static inline void tpm2_rsp_init(struct tpm2_rsp *r, struct tpm_buf *buf)
+{
+	struct tpm_header *head = (struct tpm_header *)buf->data;
+
+	r->data = buf->data;
+	r->len = min_t(u32, be32_to_cpu(head->length), TPM_BUFSIZE);
+	r->off = TPM_HEADER_SIZE;
+	r->err = r->len < TPM_HEADER_SIZE;
+}
+
+static inline const u8 *tpm2_rsp_bytes(struct tpm2_rsp *r, u32 count)
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
+static inline u8 tpm2_rsp_u8(struct tpm2_rsp *r)
+{
+	const u8 *p = tpm2_rsp_bytes(r, sizeof(u8));
+
+	return p ? *p : 0;
+}
+
+static inline u16 tpm2_rsp_u16(struct tpm2_rsp *r)
+{
+	const u8 *p = tpm2_rsp_bytes(r, sizeof(u16));
+
+	return p ? get_unaligned_be16(p) : 0;
+}
+
+static inline u32 tpm2_rsp_u32(struct tpm2_rsp *r)
+{
+	const u8 *p = tpm2_rsp_bytes(r, sizeof(u32));
+
+	return p ? get_unaligned_be32(p) : 0;
+}
+
+/* Read a TPM2B, returning its contents and setting @len */
+static inline const u8 *tpm2_rsp_tpm2b(struct tpm2_rsp *r, u16 *len)
+{
+	*len = tpm2_rsp_u16(r);
+	return tpm2_rsp_bytes(r, *len);
+}
+
+/* Read a TPM2B_ECC_PARAMETER, left-padding it to EC_PT_SZ bytes */
+static inline void tpm2_rsp_ecc_param(struct tpm2_rsp *r, u8 *out)
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
+/*
+ * Parse a TPM2B_PUBLIC for an ECDSA-SHA256 P-256 signing key with no
+ * symmetric algorithm, KDF or policy, checking that it has exactly the
+ * object attributes @attrs, and return its public point.
+ */
+static inline int tpm2_rsp_ecdsa_public(struct tpm2_rsp *r, u32 attrs,
+					u8 *x, u8 *y)
+{
+	u16 size = tpm2_rsp_u16(r);
+	u32 end = r->off + size;
+
+	if (tpm2_rsp_u16(r) != TPM_ALG_ECC ||
+	    tpm2_rsp_u16(r) != TPM_ALG_SHA256 ||
+	    tpm2_rsp_u32(r) != attrs ||
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
+#endif
-- 
2.43.0

