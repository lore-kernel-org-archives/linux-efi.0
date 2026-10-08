Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012009.outbound.protection.outlook.com [40.107.200.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B566F4AD7E1;
	Thu,  8 Oct 2026 13:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791465999; cv=fail; b=MZFVrxslFPvH/5ZPDdJvFZoJmzAylfUPgkY2qP8XWSd43nVQDzH/LGTaO6UiWtxIKPESplGZfwpdYmV+XBceYOT20L+bWft5e+10HTaxUVKahXDsjfjQSxQ0cqMR1SeP8OqG8dsgjagKb4MD5IGQzWrxcBl5g40KMCIUJm7DXaw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791465999; c=relaxed/simple;
	bh=zWH+F39I9m6gQFnvsIUUztY6XSmE7quNDFyCO1nB9oQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jf2zPC8HhCGi38NLQbOU66qYVPrUPNw3ZLS5C72IDDRqucrjP96eT2leEg4PLUq38jjKfzDUQkZNU1YSoL/6aIQSGr+c1RI14buQ7rU04Hez5q9QJEq7ND77k6aTk6WjFjpfUaFfylAgKmx1Rojxs+Hx7b/Ryr3DtUASdNzqDws=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EAS80pAZ; arc=fail smtp.client-ip=40.107.200.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EAS80pAZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uz8mNK+eAocIMsot6ItKp5cirRIc5JUf01zHf+j7L7g5j1FAAyXrmiaLeh1rtV421nCccrIJdtcyTe1nP+R1cOJ0PeY5y0hnA3oM12RKjOSmXh4+28X8Kdxkrz0oDAmwihG1ZR+LF9PsjnsRKXtDfaDe+4wjq+ZOEk0gmiC5OsEFjwliDaIl0+zblx33RHMCxlTwLM91Ch1AXIgNBsxIOIkZFx+uzUgguGznysv5pdevz+10rgfEfFBkaXmII5/UkHQ1JsNQYF07oa0mWN1Npw8Jym+zGsgSQf1tm/tG/cKJmqKL+W8+hha7x+Yg9CZtvo5h9zSCOxUzGmaPJrgwdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=whX7/fjc0mQ8Yp+fad3QUTmKGmlgY6eKfHw8CRp5Rsg=;
 b=DQ0VymUkw9n9lpPmavdrO7rZhrrtdiAcpFUeFEm8q0TwMoyHMh5LwXWGRx9kkoEqxhAkp0ml4NY4DhvtWbl/nH3mHmrcEtm9I+6xPm4x8+SrFArSENIf9xVbRCzde2zkdUtvwO4tKbjkUvhSJUoL0ITjFF47DUIQo48N0NOtUpZ8N/3IzqdoAhMzSF6LgcCY/1Ikr9jttgexaUwHYa/GuKQkARsDzynC3uLFLvd/j0thvAPDyKbMxjY4zOQK8n/pB5INITwWtJs9TTII43X7q326g8n3Ugt9FImIUN6O2TFP0FuMcl06vnhkwH9pGSwktYYwE+rsHgn97f4x+NxR7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=whX7/fjc0mQ8Yp+fad3QUTmKGmlgY6eKfHw8CRp5Rsg=;
 b=EAS80pAZLpo0b+llM5C+KT2u3dh+gFp8M7FjMopXZxfwHVKwJ+cysTQjCJ/9lxo6jZ6ch5UnyOAn2eHMlbqmWNHtk6t80S47Sxkp9arr23UojUdMUDz+wQp15wGteJVSq5/dfeXi2Qdewh9duVuQeIODfJcYXNYM2fgxLP3oOiLZO/+Noo/YmC0IWQRfWxo4RNXRh9sa2+XryJzWMdDbJmKFIzbPtYbwdXDKUGeiCD7TUldHy+tGgsNYkbFoBBQqKORbnklATA/akeDYwBalddxHNWzpk1Jv/hAjkv9BM1Vt6LzYM1+aYR7351yTTG7obBQ/WeBbN4B+/0ayIK++Iw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH8PR12MB9741.namprd12.prod.outlook.com (2603:10b6:610:27a::21)
 by CY8PR12MB7587.namprd12.prod.outlook.com (2603:10b6:930:9a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.26; Thu, 8 Oct
 2026 13:26:26 +0000
Received: from CH8PR12MB9741.namprd12.prod.outlook.com
 ([fe80::43a6:8d0:7081:65d7]) by CH8PR12MB9741.namprd12.prod.outlook.com
 ([fe80::43a6:8d0:7081:65d7%5]) with mapi id 15.21.0472.016; Thu, 8 Oct 2026
 13:26:26 +0000
From: Matthew Garrett <matthewg@nvidia.com>
To: mjg59@srcf.ucam.org
Cc: keyrings@vger.kernel.org,
	James.Bottomley@HansenPartnership.com,
	linux-integrity@vger.kernel.org,
	rafael@kernel.org,
	linux-pm@vger.kernel.org,
	linux-efi@vger.kernel.org,
	Matthew Garrett <matthewg@nvidia.com>
Subject: [PATCH 13/17] tpm: Add verification of kernel signing key provenance
Date: Thu,  8 Oct 2026 06:20:29 -0700
Message-ID: <20261008132532.1155166-14-matthewg@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261008132532.1155166-1-matthewg@nvidia.com>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0161.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ba::13) To CH8PR12MB9741.namprd12.prod.outlook.com
 (2603:10b6:610:27a::21)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH8PR12MB9741:EE_|CY8PR12MB7587:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c7ab637-bf3c-421e-683d-08df253fc158
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|10067099003|11063799006|56012099006|3023799007|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	AHYC+0KQ4jUdT5RkyaQh279lHpbYSBgCtm6hfQmeRw+ntebtioJuf8RAh0C+gi6zPupXzqQc+KihLG9xVEwxZMzirnrXHSAoomiCjPL/A2l4PmU+5jNbRhXaMZMqHxIzQRFbYJaah0AUDqmg4BrXWzlo95mlRed+LEBXpLC43MFuJlHtYs+yICWyoKY9YQar2Ruq+JnElcmQfF0OeZ1UFSO0NH9nLkWHRVF95IMdpCO+jdAQwcTst8/wFrSrkp4pH5OOWCiq09at4kInsEA91ZVZeQNj9CDVk3oDNbY72JeoH8UhF6+SC8r1qP9ysbnUWhdLK8cJR2GC+PXFVkp64Fpj/PFHLyTAVgcAK3w2HJw4cmP5fRQDSyfc+oH3vVlLIy6T/Yvke6FLribvgviHIfoa8TusDdE9NYKFc5J3XFLpbf2s/FWtRtsrm9WwtC51MtvfU921CZnnycUL65i6xkQ0aLwksmFSHnebybe0tKGLvCKc3I5id4xuHj9PebeVAOeR9l1ojQ/JPFYmQzRybazHE8Qg2L34Li6iASLjGf0XoC5Yff1N1Ddo+c98cWdEBAGdIc7ZPP5oiwLXBc4OeM81WCUG2x8bsJn4+rDakfjwIUOJkfyBuf2KZ2sFA9CIBoWxWGwAritjZTqd5hLCi4WQ6v008VSjEOXbSPBxgYw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH8PR12MB9741.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(10067099003)(11063799006)(56012099006)(3023799007)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MoLARHAlyVw04utp8pejfJqmeIE/RXg1+wLxVFfD+iBsODIfrJmW2CQvlC5r?=
 =?us-ascii?Q?6bLd0Dn1BnXLMsiejqGXoxiW+jqFpSluVhWrhaJ0faUlaXcTJabE3yPQS03o?=
 =?us-ascii?Q?8M0/FIQgCHs/Z9Yx19qjV8/rbdjwvuQ5jMomfn2iRdzL4wy0jICYTEeQC+Sx?=
 =?us-ascii?Q?EgvQb4oYqWO8uY6X6EM7uKGzEt7DMjWNnA+ZACCsFVV7xSLQUK/h2mLWIgzV?=
 =?us-ascii?Q?8DLwpZPx6Dsi9t4T6d1RvxnbURMp/urBhzEbZSKFbVfhpS2qZzJr5C/beGup?=
 =?us-ascii?Q?sNa9sHgDo6E8DJgVuaygaTuhW1cYuvwOlI6Yt55F2+NUqZ0S1qhHim33swSc?=
 =?us-ascii?Q?ObTdSgdZ2HDqkzBFhirQJSnypvZU6XmckL5njheYWp8wzx8h6uDlOnb6oGal?=
 =?us-ascii?Q?SoehDQN17+BO5Hmu1pw4nNVfQteRSew6P/wQPe9e6QRXloTpWO5kmM8NmzNs?=
 =?us-ascii?Q?w1pRX6KaKWErpeuyT5rF+VSfl30uoW2AJG1smnzsCP14BL5InbTiRcEVVPPW?=
 =?us-ascii?Q?wtSJxRlMPQ7XP5L/GHGJ7xB//kvYA7PEqqQi5dzOMfi1FS2XVxUG72tkWc4E?=
 =?us-ascii?Q?/2zq/c2ZL4fffXY+mBPWKpUmNM2SOtf/mNckdDP5Ve8IfsdxACm0HQejq8oh?=
 =?us-ascii?Q?ueiRcYSXBRvvUT6O9CnmvHZ3+dw+YU5T8ZqcxWEQlW/WZYf/l4AHxv2PrdUB?=
 =?us-ascii?Q?JLr32r0ocDtU8LmFHdiu2TdGP9V3PUwRGBrpTFqjKq5Opg+rKNyazkE43riW?=
 =?us-ascii?Q?Kq1K8zIOX7hMITFFltjFenalw7NBvPKCJ4CMgFT+4LEKThdsy+xyw4Ljwfr+?=
 =?us-ascii?Q?g9kasSk2dgiJcGFY3m3wvV4aPx410CzxDDWrusxeZRfrL5n8uvZObo/A07CM?=
 =?us-ascii?Q?HCg64OySJqfU8EkJNgJERgZgZEI6HAwHxIIADkmpjEmVuBM3kdAA58TmKkVb?=
 =?us-ascii?Q?xGOjbymyiDCRhtz06Q/50hiT+kNy8j01/4n1umcJNVZwYg+NLEzdQ5H4xCnI?=
 =?us-ascii?Q?MbPTjqCGJ42OTou1L5JFRx3c0RGJRYFIOI4LlafH84p7F/E/Dy5YIz4LYAt+?=
 =?us-ascii?Q?Gqs/YXvJScpw9EA/gwLRxPzDerpQ0MsK3jk2Mr0k3QRtUTRPFTHCuNZEHbk4?=
 =?us-ascii?Q?rXxLPnvqlHZBXf1XkPDxwScPEpyLsrqbEjhRK6yg1WzTYWNzB3O2n6jGtN6h?=
 =?us-ascii?Q?iZcRjFE58vk2yw+CYJYPKv61mm3NGpZoj3Wsol6oI7bQ1MNfIqtC9p48k++t?=
 =?us-ascii?Q?UvffJSBTKtGNx94gpSQETryPQn9W0sBejj3nb2/Dxa7V213rsMd+leTlD6zI?=
 =?us-ascii?Q?acfcMBWNRpCFthH+gLU7VYwG+IMq19x4dJmRg1/rgS5eeY2BspFmgm9Nr3o9?=
 =?us-ascii?Q?OnRdxHw2dWkgaBY67Cbhv/XtoXxnDnXimWQ9YQeXE6L/73MEci9xJkdD50In?=
 =?us-ascii?Q?BrimcU9oQgx9zvCixFmgzGZyZMYQZLFnc8cL6/YQkBi9C4szFdkFY4UXuMyQ?=
 =?us-ascii?Q?3lHZJCAeV3SuDBG/ZzzHjwleRuC0oxHbd99UaCxc5kLBbGTN1S6wn9KVovSb?=
 =?us-ascii?Q?g1wJCxZr1vG11ZJmP1Za/izXRtNsnZiCfMEbU8iTgVmJvzmEb5rDo2vEBIKh?=
 =?us-ascii?Q?Q7hU/flvqHdXVZ5D6nQ4aO8oX1m5ewol6hJQjvzViWQ2R745nf9FbjkefMBX?=
 =?us-ascii?Q?Qyf27YLaKZxHxyfrzQlAd8yrmxMk8mKps6T97/mTjqWDgfhHNctNUY24sOwn?=
 =?us-ascii?Q?8Q/lKiPbbQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c7ab637-bf3c-421e-683d-08df253fc158
X-MS-Exchange-CrossTenant-AuthSource: CH8PR12MB9741.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 13:26:26.8628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4bzzJXTDQPanHKU1rNezyLmVS4FGUWpHl+ghwW5q88EVjFp3BEO2vVD6N32XFOQGwfWxCMyOeanWjYNHBr05Jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7587

Add tpm2_kernel_key_verify(), which checks the provenance produced by
tpm2_kernel_key_create() and returns the public key it shows the kernel
created. It checks that:

* The session audit attestation is signed by this TPM's kernel AK

* Replaying the logged cpHash and rpHash pairs from a zero digest
reproduces the attested session digest

* Each logged rpHash matches the recorded response parameters, and the
commands were PCR_Read, NV_Read, and CreateLoaded in that order

* PCR 5 was read, and held the value it holds now

* The read of the NV index returned the magic value

* The key created has exactly the attributes of a kernel signing key.

Since userspace cannot store the magic value in the kernel NV index,
this shows that the key was created while the kernel was in control of
the TPM.

Also add tpm2_kernel_key_verify_signature(), which verifies an ECDSA
P-256 signature in software with a given public key, for checking data
signed with a kernel signing key.

Signed-off-by: Matthew Garrett <matthewg@nvidia.com>
---
 drivers/char/tpm/Kconfig           |   1 +
 drivers/char/tpm/tpm2-kernel-key.c | 372 +++++++++++++++++++++++++++++
 include/linux/tpm.h                |  21 ++
 3 files changed, 394 insertions(+)

diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
index 15d204f8fa6d..c7ad2fef6d23 100644
--- a/drivers/char/tpm/Kconfig
+++ b/drivers/char/tpm/Kconfig
@@ -45,6 +45,7 @@ config TCG_TPM2_HMAC
 config TCG_TPM2_KERNEL_KEY
 	bool "Kernel-generated TPM signing keys with provenance"
 	depends on TCG_TPM2_HMAC
+	select CRYPTO_ECDSA
 	help
 	  Allow the kernel to create TPM signing keys along with evidence,
 	  signed by the kernel attestation key, that the key was created
diff --git a/drivers/char/tpm/tpm2-kernel-key.c b/drivers/char/tpm/tpm2-kernel-key.c
index 89c11c78097a..3f9f6426a8a4 100644
--- a/drivers/char/tpm/tpm2-kernel-key.c
+++ b/drivers/char/tpm/tpm2-kernel-key.c
@@ -31,6 +31,8 @@
 #include <linux/random.h>
 #include <linux/slab.h>
 #include <linux/unaligned.h>
+#include <crypto/sha2.h>
+#include <crypto/sig.h>
 #include "tpm.h"
 #include "tpm2-rsp.h"
 
@@ -59,6 +61,16 @@ static const u8 tpm2_kkey_pcr5_select[] = {
 	0x20, 0x00, 0x00,		/* PCR 5 */
 };
 
+static const u8 tpm2_kkey_pcr5_bitmap[] = { 0x20, 0x00, 0x00 };
+
+static const struct {
+	u16 alg;
+	u16 size;
+} tpm2_kkey_pcr5_banks[] = {
+	{ TPM_ALG_SHA1,         SHA1_DIGEST_SIZE },
+	{ TPM_ALG_SHA256,       SHA256_DIGEST_SIZE },
+};
+
 /* The parameters of a response, as covered by the logged rpHash */
 struct tpm2_kkey_rsp {
 	u32 cc;
@@ -500,3 +512,363 @@ void tpm2_kernel_key_destroy(struct tpm_chip *chip,
 	memzero_explicit(key, sizeof(*key));
 }
 EXPORT_SYMBOL_GPL(tpm2_kernel_key_destroy);
+
+/**
+ * tpm2_kernel_key_verify_signature() - verify an ECDSA P-256 signature
+ * @x:		X coordinate of the public key
+ * @y:		Y coordinate of the public key
+ * @digest:	the SHA-256 digest that was signed
+ * @r:		R component of the signature
+ * @s:		S component of the signature
+ *
+ * Return: 0 if the signature is valid, -EKEYREJECTED if it is not, or
+ * another -errno on failure.
+ */
+int tpm2_kernel_key_verify_signature(const u8 x[EC_PT_SZ],
+				     const u8 y[EC_PT_SZ],
+				     const u8 digest[SHA256_DIGEST_SIZE],
+				     const u8 r[EC_PT_SZ],
+				     const u8 s[EC_PT_SZ])
+{
+	u8 pub[1 + 2 * EC_PT_SZ], sig[2 * EC_PT_SZ];
+	struct crypto_sig *tfm;
+	int rc;
+
+	tfm = crypto_alloc_sig("p1363(ecdsa-nist-p256)", 0, 0);
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
+
+	/* uncompressed point */
+	pub[0] = 0x04;
+	memcpy(&pub[1], x, EC_PT_SZ);
+	memcpy(&pub[1 + EC_PT_SZ], y, EC_PT_SZ);
+	memcpy(sig, r, EC_PT_SZ);
+	memcpy(&sig[EC_PT_SZ], s, EC_PT_SZ);
+
+	rc = crypto_sig_set_pubkey(tfm, pub, sizeof(pub));
+	if (!rc)
+		rc = crypto_sig_verify(tfm, sig, sizeof(sig), digest,
+				       SHA256_DIGEST_SIZE);
+
+	crypto_free_sig(tfm);
+	return rc == -EBADMSG ? -EKEYREJECTED : rc;
+}
+EXPORT_SYMBOL_GPL(tpm2_kernel_key_verify_signature);
+
+/* A logged command, parsed from the serialized provenance */
+struct tpm2_kkey_entry {
+	u32 cc;
+	const u8 *cphash;
+	const u8 *rphash;
+	const u8 *params;
+	u16 len;
+};
+
+static const u32 tpm2_kkey_expected_cc[TPM2_KKEY_NR_CMDS] = {
+	TPM2_CC_PCR_READ,
+	TPM2_CC_NV_READ,
+	TPM2_CC_CREATE_LOADED,
+};
+
+/* Check that the attestation is a session audit, and find its digest */
+static const u8 *tpm2_kkey_attest_digest(const u8 *attest, u16 len)
+{
+	struct tpm2_rsp r;
+	const u8 *digest;
+	u16 size;
+
+	tpm2_rsp_init_data(&r, attest, len);
+	if (tpm2_rsp_u32(&r) != TPM2_GENERATED_VALUE ||
+	    tpm2_rsp_u16(&r) != TPM2_ST_ATTEST_SESSION_AUDIT)
+		return NULL;
+
+	/* qualifiedSigner, extraData */
+	tpm2_rsp_tpm2b(&r, &size);
+	tpm2_rsp_tpm2b(&r, &size);
+	/* clockInfo (clock, resetCount, restartCount, safe), firmwareVersion */
+	tpm2_rsp_bytes(&r, 8 + 4 + 4 + 1);
+	tpm2_rsp_bytes(&r, 8);
+	/* exclusiveSession */
+	tpm2_rsp_u8(&r);
+	digest = tpm2_rsp_tpm2b(&r, &size);
+
+	if (r.err || r.off != r.len || size != SHA256_DIGEST_SIZE)
+		return NULL;
+
+	return digest;
+}
+
+static bool tpm2_kkey_bank_allocated(struct tpm_chip *chip, u16 alg)
+{
+	int i;
+
+	for (i = 0; i < chip->nr_allocated_banks; i++)
+		if (chip->allocated_banks[i].alg_id == alg)
+			return true;
+
+	return false;
+}
+
+/*
+ * Check a PCR_Read of PCR 5 against its current values.  Every bank that
+ * was read must hold the same value now, and the banks read must be
+ * exactly the SHA-1 and SHA-256 banks that are allocated.  A TPM leaves
+ * an unallocated bank out of the response or returns it with an empty
+ * selection, and since the response is covered by the attested audit
+ * digest, the set of banks read cannot be altered.
+ */
+static int tpm2_kkey_check_pcr5(struct tpm_chip *chip,
+				const struct tpm2_kkey_entry *e)
+{
+	bool read[ARRAY_SIZE(tpm2_kkey_pcr5_banks)] = { };
+	u8 cphash[SHA256_DIGEST_SIZE];
+	__be32 cc = cpu_to_be32(e->cc);
+	unsigned int nr_read = 0;
+	struct sha256_ctx ctx;
+	struct tpm2_rsp r;
+	int i, j, prev = -1, rc;
+	u32 count;
+
+	sha256_init(&ctx);
+	sha256_update(&ctx, (u8 *)&cc, sizeof(cc));
+	sha256_update(&ctx, tpm2_kkey_pcr5_select,
+		      sizeof(tpm2_kkey_pcr5_select));
+	sha256_final(&ctx, cphash);
+	if (memcmp(cphash, e->cphash, sizeof(cphash)))
+		return -EKEYREJECTED;
+
+	tpm2_rsp_init_data(&r, e->params, e->len);
+	/* pcrUpdateCounter */
+	tpm2_rsp_u32(&r);
+
+	/* pcrSelectionOut: which banks were actually read, in order */
+	count = tpm2_rsp_u32(&r);
+	if (count > ARRAY_SIZE(tpm2_kkey_pcr5_banks))
+		return -EKEYREJECTED;
+
+	for (i = 0; i < count; i++) {
+		u16 alg = tpm2_rsp_u16(&r);
+		const u8 *bitmap;
+
+		if (tpm2_rsp_u8(&r) != sizeof(tpm2_kkey_pcr5_bitmap))
+			return -EKEYREJECTED;
+		bitmap = tpm2_rsp_bytes(&r, sizeof(tpm2_kkey_pcr5_bitmap));
+		if (!bitmap)
+			return -EKEYREJECTED;
+
+		for (j = 0; j < ARRAY_SIZE(tpm2_kkey_pcr5_banks); j++)
+			if (tpm2_kkey_pcr5_banks[j].alg == alg)
+				break;
+		/* banks must be distinct and in the order requested */
+		if (j == ARRAY_SIZE(tpm2_kkey_pcr5_banks) || j <= prev)
+			return -EKEYREJECTED;
+		prev = j;
+
+		if (!memcmp(bitmap, tpm2_kkey_pcr5_bitmap,
+			    sizeof(tpm2_kkey_pcr5_bitmap))) {
+			read[j] = true;
+			nr_read++;
+		} else if (memchr_inv(bitmap, 0, sizeof(tpm2_kkey_pcr5_bitmap))) {
+			return -EKEYREJECTED;
+		}
+	}
+
+	if (!nr_read)
+		return -EKEYREJECTED;
+
+	/* TPML_DIGEST, one digest per bank read, in the same order */
+	if (tpm2_rsp_u32(&r) != nr_read)
+		return -EKEYREJECTED;
+
+	for (j = 0; j < ARRAY_SIZE(tpm2_kkey_pcr5_banks); j++) {
+		struct tpm_digest pcr = { .alg_id = tpm2_kkey_pcr5_banks[j].alg };
+		const u8 *digest;
+		u16 size;
+
+		/* every allocated bank must have been read */
+		if (!read[j]) {
+			if (tpm2_kkey_bank_allocated(chip, pcr.alg_id))
+				return -EKEYREJECTED;
+			continue;
+		}
+
+		digest = tpm2_rsp_tpm2b(&r, &size);
+		if (!digest || size != tpm2_kkey_pcr5_banks[j].size)
+			return -EKEYREJECTED;
+
+		rc = tpm2_pcr_read(chip, 5, &pcr, NULL);
+		if (rc)
+			return rc;
+
+		if (memcmp(digest, pcr.digest, size))
+			return -EKEYREJECTED;
+	}
+
+	return r.err || r.off != r.len ? -EKEYREJECTED : 0;
+}
+
+/* Check an NV_Read of the kernel index, and that it returned the magic */
+static int tpm2_kkey_check_nv_read(const struct tpm2_kkey_entry *e)
+{
+	u8 name[TPM2_NULL_NAME_SIZE], cphash[SHA256_DIGEST_SIZE];
+	struct sha256_ctx ctx;
+	__be32 cc = cpu_to_be32(e->cc);
+	__be16 size = cpu_to_be16(TPM2_KERNEL_NV_SIZE), offset = 0;
+
+	/* authHandle and nvIndex are both the index, as last written */
+	tpm2_kernel_nv_name(true, name);
+	sha256_init(&ctx);
+	sha256_update(&ctx, (u8 *)&cc, sizeof(cc));
+	sha256_update(&ctx, name, sizeof(name));
+	sha256_update(&ctx, name, sizeof(name));
+	sha256_update(&ctx, (u8 *)&size, sizeof(size));
+	sha256_update(&ctx, (u8 *)&offset, sizeof(offset));
+	sha256_final(&ctx, cphash);
+
+	if (memcmp(cphash, e->cphash, sizeof(cphash)))
+		return -EKEYREJECTED;
+
+	if (e->len != sizeof(u16) + TPM2_KERNEL_NV_SIZE ||
+	    get_unaligned_be16(e->params) != TPM2_KERNEL_NV_SIZE ||
+	    memcmp(e->params + sizeof(u16), tpm2_kernel_nv_magic,
+		   TPM2_KERNEL_NV_SIZE))
+		return -EKEYREJECTED;
+
+	return 0;
+}
+
+/* Extract the public key from a CreateLoaded response */
+static int tpm2_kkey_check_create(const struct tpm2_kkey_entry *e,
+				  u8 x[EC_PT_SZ], u8 y[EC_PT_SZ])
+{
+	struct tpm2_rsp r;
+	u16 size;
+
+	tpm2_rsp_init_data(&r, e->params, e->len);
+	/* outPrivate */
+	tpm2_rsp_tpm2b(&r, &size);
+	if (tpm2_rsp_ecdsa_public(&r, TPM2_OA_KERNEL_KEY, x, y))
+		return -EKEYREJECTED;
+	/* name */
+	tpm2_rsp_tpm2b(&r, &size);
+
+	return r.err || r.off != r.len ? -EKEYREJECTED : 0;
+}
+
+/**
+ * tpm2_kernel_key_verify() - verify the provenance of a kernel signing key
+ * @chip:	the TPM chip
+ * @prov:	provenance returned by tpm2_kernel_key_create()
+ * @x:		filled with the X coordinate of the key's public key
+ * @y:		filled with the Y coordinate of the key's public key
+ *
+ * Checks that @prov shows the key was created by the kernel:
+ *
+ * - the attestation is signed by this TPM's kernel AK;
+ * - the logged commands reproduce the attested audit digest;
+ * - the logged responses match the recorded response parameters, and the
+ *   commands were PCR_Read, NV_Read, and CreateLoaded, in order;
+ * - PCR 5 was read and held the same value as it does now;
+ * - the kernel NV index was read, and returned the magic value;
+ * - the key created has the attributes of a kernel signing key.
+ *
+ * The caller must hold the chip's ops lock.
+ *
+ * Return: 0 if the provenance is valid, -EKEYREJECTED if it is not, or
+ * another -errno or a TPM error code on failure.
+ */
+int tpm2_kernel_key_verify(struct tpm_chip *chip,
+			   const struct tpm2_key_provenance *prov,
+			   u8 x[EC_PT_SZ], u8 y[EC_PT_SZ])
+{
+	struct tpm2_kkey_entry e[TPM2_KKEY_NR_CMDS];
+	u8 ak_x[EC_PT_SZ], ak_y[EC_PT_SZ];
+	u8 digest[SHA256_DIGEST_SIZE];
+	const u8 *attest, *sig_r, *sig_s, *session_digest;
+	struct sha256_ctx ctx;
+	struct tpm2_rsp r;
+	u16 attest_len;
+	u32 ak;
+	int i, rc;
+
+	if (prov->len > sizeof(prov->data))
+		return -EKEYREJECTED;
+
+	tpm2_rsp_init_data(&r, prov->data, prov->len);
+	if (tpm2_rsp_u32(&r) != TPM2_KKEY_PROV_MAGIC ||
+	    tpm2_rsp_u16(&r) != TPM2_KKEY_PROV_VERSION)
+		return -EKEYREJECTED;
+
+	attest = tpm2_rsp_tpm2b(&r, &attest_len);
+	sig_r = tpm2_rsp_bytes(&r, EC_PT_SZ);
+	sig_s = tpm2_rsp_bytes(&r, EC_PT_SZ);
+	if (tpm2_rsp_u8(&r) != TPM2_KKEY_NR_CMDS)
+		return -EKEYREJECTED;
+
+	for (i = 0; i < TPM2_KKEY_NR_CMDS; i++) {
+		e[i].cc = tpm2_rsp_u32(&r);
+		e[i].cphash = tpm2_rsp_bytes(&r, SHA256_DIGEST_SIZE);
+		e[i].rphash = tpm2_rsp_bytes(&r, SHA256_DIGEST_SIZE);
+		e[i].params = tpm2_rsp_tpm2b(&r, &e[i].len);
+		if (e[i].cc != tpm2_kkey_expected_cc[i])
+			return -EKEYREJECTED;
+	}
+
+	if (r.err || r.off != r.len)
+		return -EKEYREJECTED;
+
+	/* the attestation must be signed by this TPM's kernel AK */
+	rc = tpm2_create_kernel_ak(chip, &ak, ak_x, ak_y);
+	if (rc)
+		return rc;
+	tpm2_flush_context(chip, ak);
+
+	sha256(attest, attest_len, digest);
+	rc = tpm2_kernel_key_verify_signature(ak_x, ak_y, digest, sig_r,
+					      sig_s);
+	if (rc)
+		return rc;
+
+	session_digest = tpm2_kkey_attest_digest(attest, attest_len);
+	if (!session_digest)
+		return -EKEYREJECTED;
+
+	/* replay the log from the initial zero digest */
+	memset(digest, 0, sizeof(digest));
+	for (i = 0; i < TPM2_KKEY_NR_CMDS; i++) {
+		u8 rphash[SHA256_DIGEST_SIZE];
+		__be32 cc = cpu_to_be32(e[i].cc);
+		__be32 rc_success = 0;
+
+		/* the response must match the recorded parameters */
+		sha256_init(&ctx);
+		sha256_update(&ctx, (u8 *)&rc_success, sizeof(rc_success));
+		sha256_update(&ctx, (u8 *)&cc, sizeof(cc));
+		sha256_update(&ctx, e[i].params, e[i].len);
+		sha256_final(&ctx, rphash);
+		if (memcmp(rphash, e[i].rphash, sizeof(rphash)))
+			return -EKEYREJECTED;
+
+		sha256_init(&ctx);
+		sha256_update(&ctx, digest, sizeof(digest));
+		sha256_update(&ctx, e[i].cphash, SHA256_DIGEST_SIZE);
+		sha256_update(&ctx, e[i].rphash, SHA256_DIGEST_SIZE);
+		sha256_final(&ctx, digest);
+	}
+
+	if (memcmp(digest, session_digest, sizeof(digest)))
+		return -EKEYREJECTED;
+
+	/* PCR 5 must hold the same value now */
+	rc = tpm2_kkey_check_pcr5(chip, &e[0]);
+	if (rc)
+		return rc;
+
+	/* the key was created after a read of the magic value */
+	rc = tpm2_kkey_check_nv_read(&e[1]);
+	if (!rc)
+		rc = tpm2_kkey_check_create(&e[2], x, y);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(tpm2_kernel_key_verify);
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index 505ea6f4bb46..9be88f1cc2aa 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -393,6 +393,14 @@ int tpm2_kernel_key_sign(struct tpm_chip *chip, struct tpm2_kernel_key *key,
 			 u8 r[EC_PT_SZ], u8 s[EC_PT_SZ]);
 void tpm2_kernel_key_destroy(struct tpm_chip *chip,
 			     struct tpm2_kernel_key *key);
+int tpm2_kernel_key_verify(struct tpm_chip *chip,
+			   const struct tpm2_key_provenance *prov,
+			   u8 x[EC_PT_SZ], u8 y[EC_PT_SZ]);
+int tpm2_kernel_key_verify_signature(const u8 x[EC_PT_SZ],
+				     const u8 y[EC_PT_SZ],
+				     const u8 digest[SHA256_DIGEST_SIZE],
+				     const u8 r[EC_PT_SZ],
+				     const u8 s[EC_PT_SZ]);
 #else
 static inline int tpm2_kernel_key_create(struct tpm_chip *chip,
 					 struct tpm2_kernel_key *key,
@@ -411,6 +419,19 @@ static inline void tpm2_kernel_key_destroy(struct tpm_chip *chip,
 					   struct tpm2_kernel_key *key)
 {
 }
+static inline int tpm2_kernel_key_verify(struct tpm_chip *chip,
+					 const struct tpm2_key_provenance *prov,
+					 u8 x[EC_PT_SZ], u8 y[EC_PT_SZ])
+{
+	return -EOPNOTSUPP;
+}
+static inline int
+tpm2_kernel_key_verify_signature(const u8 x[EC_PT_SZ], const u8 y[EC_PT_SZ],
+				 const u8 digest[SHA256_DIGEST_SIZE],
+				 const u8 r[EC_PT_SZ], const u8 s[EC_PT_SZ])
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 #ifdef CONFIG_TCG_TPM2_HMAC
-- 
2.43.0

