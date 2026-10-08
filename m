Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012018.outbound.protection.outlook.com [40.93.195.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F384492E53;
	Thu,  8 Oct 2026 13:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791465991; cv=fail; b=qw6zwBpiyvdO0Is8uv8KwMZcJoLgDegVG++/S3JNtKw3W/KBE72utp8OTe1UBzzwMzAPd2uugsy0GK/QHkWbm9BpUTWAuysIBXUqX483ZkCnwQ3xrv8lkZWCM78ui0o4SDf/X43cDAiZ7CYrQOHrxnHgQa13iox8fYRZg7PFNkQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791465991; c=relaxed/simple;
	bh=9+D9JkBc8P7g2L6kVhDrwZAPe5Ynn53Scvsk7Mwf/Oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hmMZp/vDLlGmA2QxMEhwhZwK3Dd08ectV8KAWGlY/Ed3evJ3BQwxShJTSZCqayFaOOS6OaQtBBh6dgPuyE6jnDczpqYBbOdVhmzPmRvZa0gPzvVIT8WFUttcNyWPnAVqAHnThxTCH0DLvROfEQe7kvI+TzaKQmt9lFuLLnGE6zw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sJ0doNZH; arc=fail smtp.client-ip=40.93.195.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sJ0doNZH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b9/lzB+TYuFIKpsUIYL/N+4SODrXvelfpFiDLFMIlXcq1FI8A50C8SfCmZIWwd99umeSpwhq7LOE+NTeGUTYwFZkVZfHr12aN9dnDcj2ASUxrV5+GW28VXKS0huSVT+Gr2x8H0QtiWAojaew+yjWmAR29uJ0RI1DIoq/aWzw11GazHMdEFyuQj3kEC6y2m1xZC9ZCrE2rMktXwbOJhTlBv6acOITkP+o9+12hgTmB5jAv+6G5UdzKjvKGEOvlvf8lh9uvkaZexhl4pyV0a2NQ7/TNnw8Rt92UZJKgY9xE1qy+j2Rymj0fIxVtk/u1SGquE0LFnAHV0kp8cZMDrSn+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9z5vu/SJUlPt4hLk/cVwYWX+9HUv/RMUy/Ty/N5EJZU=;
 b=itgi8eieMmzGFFEGnIU1lftQf1wlthEzBZ2rMUJ/Sb66mf+aheF38EjNcBwGk+HMavy2LARWA0bt0Kv97y6GfHg71MoofP7lQgsBrCbs4OwPtC6qBF7HWvzMHLHAcH59TJfQSAr4M6RDR8g/IfIdksW9R/nRTvFiRjB2M3rprYne9z89gUU8dD8vSEKFU8KoHlgVpjXNePjraOypNovAAHraZcgNay1I58HZNTm/eM23trAuynM3ACbSYjkcTDwxLvzRcYW833gdadVCwTHvju7CMp8fT2b48X9raC+Xi1pmzsfUBB4e4oRGSQbfvpBg/cRMHN0eIN80O8Yqq100QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9z5vu/SJUlPt4hLk/cVwYWX+9HUv/RMUy/Ty/N5EJZU=;
 b=sJ0doNZH5oj0SFmj/VZvBdrYvghdhMCFFBe9o7pZZ5WtFqSVUP5r5h2M/3GrrKr0E2ONud7tb5w1LulOGlDtCTV752pMxvWRZKL/M95N37WyKB1wMysz/LEjJq72gZzpig3qaSQ/TKfnsROpuAO2F6eAno6Ey3+MY2O1gE+YniycSb8X+axZIErBmcHz9OW64YjEskE96xPOguP5bcsFrkAKgy6hSKfJIzOowm1zOJnOVHP0t37IEy5jJ/7GozR3m5QonAlCt+/Zl1/lN/zjyLCxlhtOD+XL9exYXZzg1kzvz2F1WODy6koOGyAC1bSpfCayMZtYLnd2pbWZo8Ux+g==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH8PR12MB9741.namprd12.prod.outlook.com (2603:10b6:610:27a::21)
 by DS2PR12MB9592.namprd12.prod.outlook.com (2603:10b6:8:27c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.17; Thu, 8 Oct
 2026 13:26:23 +0000
Received: from CH8PR12MB9741.namprd12.prod.outlook.com
 ([fe80::43a6:8d0:7081:65d7]) by CH8PR12MB9741.namprd12.prod.outlook.com
 ([fe80::43a6:8d0:7081:65d7%5]) with mapi id 15.21.0472.016; Thu, 8 Oct 2026
 13:26:23 +0000
From: Matthew Garrett <matthewg@nvidia.com>
To: mjg59@srcf.ucam.org
Cc: keyrings@vger.kernel.org,
	James.Bottomley@HansenPartnership.com,
	linux-integrity@vger.kernel.org,
	rafael@kernel.org,
	linux-pm@vger.kernel.org,
	linux-efi@vger.kernel.org,
	Matthew Garrett <matthewg@nvidia.com>
Subject: [PATCH 12/17] tpm: Add signing with the kernel signing key
Date: Thu,  8 Oct 2026 06:20:28 -0700
Message-ID: <20261008132532.1155166-13-matthewg@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261008132532.1155166-1-matthewg@nvidia.com>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0219.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e4::9) To CH8PR12MB9741.namprd12.prod.outlook.com
 (2603:10b6:610:27a::21)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH8PR12MB9741:EE_|DS2PR12MB9592:EE_
X-MS-Office365-Filtering-Correlation-Id: 23668b82-008c-4490-b14f-08df253fbf48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|56012099006|11063799006|10067099003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	o/7vnE6fl/bsgmFOR9HIy8zs1a8Qpa9Puk4tlgd34EgOx20RqEWXbdl6ESPefBrhji7Cgv4QiuAp6dnFKSOXsyr2O+RP74V2eqjVO/2RqBrG/IB4VszqqFPsIj4UGk01ZxtxPJnUyYfObXSOb8uQauZMvt6ZYyp27CVlScf/nRKLbQxYR5oB//y3cB8ewwGeb0jQ2zdaUNiw+NlbGLQ/2Lm3ON6deJlqZgdSYVidw0a7pUvrMDm8dkQ+/V/hY0mmS3Gs8DzU2suqoUT2wVIduHKyjeRPs6TRMMYkYmQh+o9TsLxv4qUAyil9PxC8j4YOlnhvDxVCRl/lcBuB/inmAjzBgNdm6RDQLQnSrVkm6nl/uffdMmqHW+SG/SPKpT5frdHHDlvxH49axGe6Pqx4kNM647sUC1SxbmpcfMFHvzaHy85HHk+S7n8J6Y8ojwgGfxB6Nrd+KdTmgBnpLQLjJArg/aZSsF0KpDw5Gti2dM+lkASuWgZxiPwMMjgfQUO4nrFfZnH0gLbBofR3nWeBD4iPGwA8ewsaHRy581mY495mz1AL+tlSJyO5uEDR1nhoAtJ1rzjWtHYsUSE9FM7qyz7gj+NFzwz/ATgQfOBc1dMqtF/AFue4XRrfh7DtPDHJfREfLMdcQhLR4b5OQxQxug==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH8PR12MB9741.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(56012099006)(11063799006)(10067099003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LGUMgIdTqNzra4R7yOmGgrqCob3uK/Q2/FJ/FcOb24HBvDIA1Wvzt88Ve1aN?=
 =?us-ascii?Q?A86pFPM/AXVOfRu+Ygv4m6NI2H7q2o7imNCy4QOozFRLzFluK0+txUjdXmPE?=
 =?us-ascii?Q?RPYpwCPI5raUr8fwaX1a1rwW3i6I+Be8p1OwoOPEcJeIF1v0WYUIh9e53mTG?=
 =?us-ascii?Q?rPQ9rpWy2a+gdcu8GhTqMZVmkpUGt4q8Ln/pTdoS/zX3bcysskQdlmmiA8RM?=
 =?us-ascii?Q?GQ5MDGVswkNAUXJVHbnyLAVOYgx3+fDMu8WSoxWzfrxnLjrUwo6wThOo7u2z?=
 =?us-ascii?Q?MavHxzZR1Sd68a9ycr6jJOplGIJjlrzjuY5C9+BYd5dN2vfzXJkt+3mvIlRj?=
 =?us-ascii?Q?q1+49qDbCsiInEAQaKw0h/FQ77hBORwtijzcjsYfnjBOSKhuclyxF8rUzAqz?=
 =?us-ascii?Q?q6qIuHDylU5vr/zQzlgJYcvZBXC7AmKB41CHZ79PpOqvJTExA+/dDf8CAl0l?=
 =?us-ascii?Q?cT0vZtXBonDBegHCFyEXc9wrQ6JJudTGVtulg+cEZJPEA76UfHLZNaYmJdOZ?=
 =?us-ascii?Q?sdL8NYnGHzPJ4X6MmcZ4GPogkq87BvHj8+i2nfAQ7BjjUfwbvKczYPnQaTyk?=
 =?us-ascii?Q?N5BUWKm3FoOxdrjuNkoiiEGe/X66r0Y/zxnFGtJTe1LdEmVRSr6//l+sfTHU?=
 =?us-ascii?Q?obEK0N7pv38Btww3vzT+84UyTOCq+P3WJmVurwtjIyI5xUtn3M/tkIXc+0t/?=
 =?us-ascii?Q?Y0SFUZcEaJ0GGewksA/sC0JGJFcSQ1+uwTx7yq3z7ktMyvoFCPaYDYxUb0Hy?=
 =?us-ascii?Q?Jql3mnhaTQr0wVprTnKhVFSeO+vtlz4X8Uy8qEKTV0TddNJXgHiEUsr3fMKv?=
 =?us-ascii?Q?QcCRQGmG3XhoSIpLO4pqNyAVW/dyMfSyh06K2BtBp8dLleOAwKu4PEJe6eXp?=
 =?us-ascii?Q?vO6Nxq1qtOWSgr/1xGMmYWZMpzHrSxHkiY9PbIq8XaBh+ENlC1IAVxBObTJt?=
 =?us-ascii?Q?f58+QROLJ+EtdBq4am9avR+pEWuR8Gd/r8DYQWxC86DjFhU1wmN7pKzWz9R6?=
 =?us-ascii?Q?rat+UTN3hfJ36csjS1uOeI09QLR9xlGuIcCs/dfxwPD1Vb1DV8zYEWxrN5c5?=
 =?us-ascii?Q?9kna6r+rRJfvpBZzH3AVmHfcCuIYdTQmh7uOdfLGPQMrOlXHde5pC/FhtCIh?=
 =?us-ascii?Q?QecALTuO9XiApcVQRdIhG17uqLtlWp2BBiwDYB5KCEU2qTl/oE6j/54Esfzf?=
 =?us-ascii?Q?F80uOocDXt86ZeZdmYTqS3oLpu+p/Ra7sWBpucrCLKcpTSSA/aRHkU6d8nwq?=
 =?us-ascii?Q?JaxcFk0ydl+HelAjm4w5Jq6hJYnQ+iqeXzuyArhbxcB4nirSe1xD6fsNBZ+P?=
 =?us-ascii?Q?tUOZ1p2i553l7X9ZRTupCHdWGNlewGXPAUITDIKLXynklY26IPdxTmPiJhw3?=
 =?us-ascii?Q?E7UY1Qe8WMuQIFJI751cgaljQFyecF4sv1sSYtJq+xcEDeGBBDvANi5xMYPO?=
 =?us-ascii?Q?B7+icCW0hgRRpeLsJ8jgGTDKAg2w//u/QTFWxU40Y0R2YSMlTlkERqFJ4BI/?=
 =?us-ascii?Q?QDQP65iYCtCFHMle8U4j0lEu6/iPSSsJooJc1Mza681KsE41kZXuPYLh9xUt?=
 =?us-ascii?Q?V9G9ATnRH33Qpa0i6NJVtmbLsQxXs3HVj8/tueJLi8SEtmbyrI9nmOE5vqSO?=
 =?us-ascii?Q?h/HSInN8flvg2VvGYcueN+kWeA8wl9P9KKWQhmPhwkiic2bkMow9RWABXoUp?=
 =?us-ascii?Q?fZGFVP4fl/dN96k0o3iEdGF/6ZWGNLp16kV9B8ap7xThtaUU2XKfn261WCOK?=
 =?us-ascii?Q?RqjmHExQzA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23668b82-008c-4490-b14f-08df253fbf48
X-MS-Exchange-CrossTenant-AuthSource: CH8PR12MB9741.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 13:26:23.2982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AnK6AgDX3Eq2EDaMv7sRR8Qplcq86RDAKmHbo+KbBNSvBGwRYDVhCO1UmKO+c25WA1Yb4rWaGwRv8SMt2VTknA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9592

Add tpm2_kernel_key_sign(), which signs a SHA-256 digest with a key
created by tpm2_kernel_key_create() using TPM2_Sign, and
tpm2_kernel_key_destroy(), which flushes the key and erases its auth
value.

Signed-off-by: Matthew Garrett <matthewg@nvidia.com>
---
 drivers/char/tpm/tpm2-kernel-key.c | 98 ++++++++++++++++++++++++++++++
 include/linux/tpm.h                | 16 +++++
 include/linux/tpm_command.h        |  2 +
 3 files changed, 116 insertions(+)

diff --git a/drivers/char/tpm/tpm2-kernel-key.c b/drivers/char/tpm/tpm2-kernel-key.c
index 27815525bc3f..89c11c78097a 100644
--- a/drivers/char/tpm/tpm2-kernel-key.c
+++ b/drivers/char/tpm/tpm2-kernel-key.c
@@ -402,3 +402,101 @@ int tpm2_kernel_key_create(struct tpm_chip *chip, struct tpm2_kernel_key *key,
 	return rc;
 }
 EXPORT_SYMBOL_GPL(tpm2_kernel_key_create);
+
+/**
+ * tpm2_kernel_key_sign() - sign a digest with a kernel signing key
+ * @chip:	the TPM chip
+ * @key:	a key created by tpm2_kernel_key_create()
+ * @digest:	the SHA-256 digest to sign
+ * @r:		filled with the R component of the ECDSA signature
+ * @s:		filled with the S component of the ECDSA signature
+ *
+ * The key is authorized with its auth value through an HMAC session, so
+ * the auth value is never sent to the TPM in the clear.  The caller must
+ * hold the chip's ops lock.
+ *
+ * Return:
+ * * 0		- OK
+ * * -errno	- A system error
+ * * TPM_RC	- A TPM error
+ */
+int tpm2_kernel_key_sign(struct tpm_chip *chip, struct tpm2_kernel_key *key,
+			 const u8 digest[SHA256_DIGEST_SIZE],
+			 u8 r[EC_PT_SZ], u8 s[EC_PT_SZ])
+{
+	struct tpm_buf *buf __free(kfree) = NULL;
+	struct tpm2_rsp rsp;
+	int rc;
+
+	rc = tpm2_start_auth_session(chip, false);
+	if (rc && rc != -EBUSY)
+		return rc;
+
+	buf = kzalloc(TPM_BUFSIZE, GFP_KERNEL);
+	if (!buf) {
+		tpm2_end_auth_session(chip);
+		return -ENOMEM;
+	}
+
+	tpm_buf_init(buf, TPM_BUFSIZE);
+	tpm_buf_reset(buf, TPM2_ST_SESSIONS, TPM2_CC_SIGN);
+
+	rc = tpm_buf_append_name(chip, buf, key->handle, NULL);
+	if (rc)
+		return rc;
+
+	tpm_buf_append_hmac_session(chip, buf, TPM2_SA_CONTINUE_SESSION,
+				    key->auth, sizeof(key->auth));
+
+	/* digest */
+	tpm_buf_append_u16(buf, SHA256_DIGEST_SIZE);
+	tpm_buf_append(buf, digest, SHA256_DIGEST_SIZE);
+	/* inScheme: use the key's scheme */
+	tpm_buf_append_u16(buf, TPM_ALG_NULL);
+	/* validation: a NULL ticket, as the key is not restricted */
+	tpm_buf_append_u16(buf, TPM2_ST_HASHCHECK);
+	tpm_buf_append_u32(buf, TPM2_RH_NULL);
+	tpm_buf_append_u16(buf, 0);
+
+	rc = tpm_buf_fill_hmac_session(chip, buf);
+	if (rc)
+		return rc;
+
+	rc = tpm_transmit_cmd(chip, buf, 0, "signing with kernel key");
+	rc = tpm_buf_check_hmac_response(chip, buf, rc);
+	if (rc) {
+		if (rc < 0)
+			tpm2_end_auth_session(chip);
+		return rc;
+	}
+
+	tpm2_rsp_init(&rsp, buf);
+	/* parameterSize */
+	tpm2_rsp_u32(&rsp);
+	if (tpm2_rsp_u16(&rsp) != TPM_ALG_ECDSA ||
+	    tpm2_rsp_u16(&rsp) != TPM_ALG_SHA256)
+		return -EIO;
+	tpm2_rsp_ecc_param(&rsp, r);
+	tpm2_rsp_ecc_param(&rsp, s);
+
+	return rsp.err ? -EIO : 0;
+}
+EXPORT_SYMBOL_GPL(tpm2_kernel_key_sign);
+
+/**
+ * tpm2_kernel_key_destroy() - unload a kernel signing key
+ * @chip:	the TPM chip
+ * @key:	a key created by tpm2_kernel_key_create()
+ *
+ * Flushes the key from the TPM and erases its auth value.  The caller must
+ * hold the chip's ops lock.
+ */
+void tpm2_kernel_key_destroy(struct tpm_chip *chip,
+			     struct tpm2_kernel_key *key)
+{
+	if (key->handle)
+		tpm2_flush_context(chip, key->handle);
+
+	memzero_explicit(key, sizeof(*key));
+}
+EXPORT_SYMBOL_GPL(tpm2_kernel_key_destroy);
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index 7ee553688906..505ea6f4bb46 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -388,6 +388,11 @@ struct tpm2_key_provenance {
 #ifdef CONFIG_TCG_TPM2_KERNEL_KEY
 int tpm2_kernel_key_create(struct tpm_chip *chip, struct tpm2_kernel_key *key,
 			   struct tpm2_key_provenance *prov);
+int tpm2_kernel_key_sign(struct tpm_chip *chip, struct tpm2_kernel_key *key,
+			 const u8 digest[SHA256_DIGEST_SIZE],
+			 u8 r[EC_PT_SZ], u8 s[EC_PT_SZ]);
+void tpm2_kernel_key_destroy(struct tpm_chip *chip,
+			     struct tpm2_kernel_key *key);
 #else
 static inline int tpm2_kernel_key_create(struct tpm_chip *chip,
 					 struct tpm2_kernel_key *key,
@@ -395,6 +400,17 @@ static inline int tpm2_kernel_key_create(struct tpm_chip *chip,
 {
 	return -EOPNOTSUPP;
 }
+static inline int tpm2_kernel_key_sign(struct tpm_chip *chip,
+				       struct tpm2_kernel_key *key,
+				       const u8 digest[SHA256_DIGEST_SIZE],
+				       u8 r[EC_PT_SZ], u8 s[EC_PT_SZ])
+{
+	return -EOPNOTSUPP;
+}
+static inline void tpm2_kernel_key_destroy(struct tpm_chip *chip,
+					   struct tpm2_kernel_key *key)
+{
+}
 #endif
 
 #ifdef CONFIG_TCG_TPM2_HMAC
diff --git a/include/linux/tpm_command.h b/include/linux/tpm_command.h
index cef85f532b6c..9ff2f67c55c6 100644
--- a/include/linux/tpm_command.h
+++ b/include/linux/tpm_command.h
@@ -191,6 +191,7 @@ enum tpm2_structures {
 	TPM2_ST_SESSIONS	= 0x8002,
 	TPM2_ST_ATTEST_SESSION_AUDIT = 0x8016,
 	TPM2_ST_CREATION	= 0x8021,
+	TPM2_ST_HASHCHECK	= 0x8024,
 };
 
 /* Indicates from what layer of the software stack the error comes from */
@@ -238,6 +239,7 @@ enum tpm2_command_codes {
 	TPM2_CC_CREATE			= 0x0153,
 	TPM2_CC_LOAD			= 0x0157,
 	TPM2_CC_SEQUENCE_UPDATE		= 0x015C,
+	TPM2_CC_SIGN			= 0x015D,
 	TPM2_CC_UNSEAL			= 0x015E,
 	TPM2_CC_CONTEXT_LOAD		= 0x0161,
 	TPM2_CC_CONTEXT_SAVE		= 0x0162,
-- 
2.43.0

