Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013021.outbound.protection.outlook.com [40.93.196.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CA34A4F0A;
	Thu,  8 Oct 2026 13:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791465965; cv=fail; b=txHEll0aXWoUMgRgoPhfNXWo+b99wb0FnY1h6b135GU8R44VldZfJv8m5mblwVhoCoMEIeRKrIla378jDlpdFhzDeXqq2aXDMW/n32HtEy1bMpMYA53//TUUu4friefCDXSIhJJcT7+TRN7Gw1dfWnUNbWJTB7oHavB7Gbx7rOI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791465965; c=relaxed/simple;
	bh=WLfSzTTxATkGkakQv6LSNRuer8CdpX/CeCgBpKFbiDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=llAgHezsmNohKw6nWGZ4qem/yKdF7eg2I/TV+WhaqOTLFMWnsqTOwMnWdZvND6kVlT2uv/Z4wMmOCyAF3nKXQAwOLlroYblksok+Iz+fIXJfq2XkjvyLllAJWPisaXo8ekaf6vTNlSGdqJP9LmK0q+PrfSGWLahLmpnfLn8dcUw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nZShny0W; arc=fail smtp.client-ip=40.93.196.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nZShny0W"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I0V7lnDGDLuzpTbHiBrltcwQ+boDk+/tcO+fTt4AKuV5vKi2Ofm0LrlwFhzjglj2gWutYfCqhmByPvP9UTzKAxrFTMawE5V7PFbHDvU3E4v0nEuyx1cwqs4lCCtl4RB5YRmAlDHItaeyeJThl5dEZV969jyvLx0ntbo5XIBzEW6sfbcIVZsItFfwLoPltrGNydbSZ2+7KDXQLHT3iFkAmoLoi0ngBaa/t044Rood5fE+pbVRz9hWwNHM9q8j8r8/2j4G2vxQ4IUiJUee/YExtGc6VEuMEw1FhroETe97+7wkkP3kpVA3DboUIVUrTxkPoLfC1nOeQlvAW0VDVFQKXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=viooGuj3L5ZqKefdzhUKfuFLXgfVjPM6NKllWH6y7yU=;
 b=Xc9mcUxACznCxMbqGPg0UAMDUpp7DUJQWOaKQ0QX1Eir+vwSV8NjReECvUh4VN1K17TWXca4PUHJvTtgDSnVlc+tX0OMjEx25hAIvgV7RzTf9eumDfrzgkc9lXgNX+QRjmyhPtJnwrxx/APc22AslHf5JOqlJ3dtD4RUUedIxorjSywTUhOHihRpLQOKqvotRzYAH31uv9Bu1fSS8GcvKo5lsh32A3nV3ZdyFoKO6rosmC2YYoCiZLIOaghiqvhfRbCDVdXJH/pKY3DcOPoVDyZ1UmpUT/ybZu5g6IrV3W7f4Kf3fkGQdhz/WvIzBV2zaSQ/lyDVwzeBObhaSdwwbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=viooGuj3L5ZqKefdzhUKfuFLXgfVjPM6NKllWH6y7yU=;
 b=nZShny0WdP1XdMx71ffJRJFrxWVyv9j5sbTmRIKR7YiBNWqC+eWo1p43/26OpwyvczULptzgAjdwPM+0/iZrpBCwO/+kDZC2hnuTR1Wsc/wIV4iYtb9MPvibbO4tYK5VKgUvYp4me66Y/qZINANx2RCFnPZOdD3xxsyr2xx+0HLdaGF1kzBRrS60gXOme/oJLHFtFl++PbC1nH2hoMVJZoPlSyShDvLrYz+lENKrprhO41avyT1AMVU/FneAdhOtguX6VjPlWk+MdgnnmszGtIMFFfGwzz9pFlYTrXasiIAHu8sJKgaBIl0TFBPxEUPFATM+V2JuvGr3tyWixQnPcA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH8PR12MB9741.namprd12.prod.outlook.com (2603:10b6:610:27a::21)
 by DS4PR12MB9796.namprd12.prod.outlook.com (2603:10b6:8:2a2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.17; Thu, 8 Oct
 2026 13:25:53 +0000
Received: from CH8PR12MB9741.namprd12.prod.outlook.com
 ([fe80::43a6:8d0:7081:65d7]) by CH8PR12MB9741.namprd12.prod.outlook.com
 ([fe80::43a6:8d0:7081:65d7%5]) with mapi id 15.21.0472.016; Thu, 8 Oct 2026
 13:25:53 +0000
From: Matthew Garrett <matthewg@nvidia.com>
To: mjg59@srcf.ucam.org
Cc: keyrings@vger.kernel.org,
	James.Bottomley@HansenPartnership.com,
	linux-integrity@vger.kernel.org,
	rafael@kernel.org,
	linux-pm@vger.kernel.org,
	linux-efi@vger.kernel.org,
	Matthew Garrett <matthewg@nvidia.com>
Subject: [PATCH 03/17] tpm: Allow tpm2_start_auth_session() to start an audit session
Date: Thu,  8 Oct 2026 06:20:19 -0700
Message-ID: <20261008132532.1155166-4-matthewg@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261008132532.1155166-1-matthewg@nvidia.com>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0271.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e6::20) To CH8PR12MB9741.namprd12.prod.outlook.com
 (2603:10b6:610:27a::21)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH8PR12MB9741:EE_|DS4PR12MB9796:EE_
X-MS-Office365-Filtering-Correlation-Id: 527532b4-cf63-4834-866b-08df253fad26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|22082099003|18002099003|10067099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	zEuhe1VQWyOQF7X2qQiGNAhWlppyRRxBjticJNuCslRs4RdXyNMj9kbhidsYe90EQR//FIa5mrdfoq/FEUEbRWGUv1v64pC93pG0NpoVJwP9q/4+Ibj+XR66edxCSAUWx+/B1Ottdn2y7JhyiiJ05Tfd+4yGi84yv+8wBIOFXJsVI3v/iz0GpT6/Np7NSVMK28w+OZoWCnKtqcNLjd7MIXUu52OEvL4KWsNq1EC59LoIssHvk7tdOfC27Tm8fnhuoObiS81+LHwvNp6EzIOHdUalrRElqwL8DfTyb4vCDBeRX0ExoIwHBQKt4+uDQh+jfLiI5pp2wgHTyjZ9FwJWHkDgIPPNKB4PdjECYXQvBzVJ9N0bTcS//CdPCTNGbCKbFnaCnlEWR7n1tkrVYy4q7334BJxMddwNNpEVA1rbvBO1gU+dkGgFazRZkmez8y18YzNuI4xrPAURAF9NFgpQiD0EnipIAnLjyuWbtB2NUCpnsBc3+LUanVbwd/rVX7NMS2al5f48EpihYnaABmYJRDWqdCcObwGQV6W0QB3qTBQ5HBVqDr/3Tpb1wrqAdspEd43USwf+xxw8JQKNtGtgOpZSu29E7XTL5RSHBQQws5CWzfyZ+hHauF/rnU0t/wZ3nsurnm7rbg/mPpG3a3cY3j14VHAvzyA0Ql4/KEXIUaU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH8PR12MB9741.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(22082099003)(18002099003)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uvNi8/C1elTeLxat3z+UxtKrfsKfZLbG8Wj6NIyhm3BNYJAfpbRsasobvKAE?=
 =?us-ascii?Q?XZtd2s9ebBLrR/mNugzMXk6kPyIPYXQkhzrkayfop5ecvjhHa4erGlFG8/jd?=
 =?us-ascii?Q?wsfaXDJ33F9yIavc+mRRVWF2Q1GUrYlcvAIf17Obkc3DgWQ143lehjn3CdLq?=
 =?us-ascii?Q?i2Vb7RPYlquZKPhX/akqEA78pKu+92oghGURmwBLa24XKKp3e6qqlmFbINGC?=
 =?us-ascii?Q?wKkdBKsjxqtzaRWOFGNzJmvkQ+jN+rL9JP4EQd1EmE30QCqGwfQnXfRsjweh?=
 =?us-ascii?Q?wHZq4V0oSE5VI0NuEiNLToAGCXjJ9RB5tAFlnp3QOtpdPGqfwqUZndUBzs1c?=
 =?us-ascii?Q?U9dfK5/zv4XJX6c+MGsCVWmRslhsoXfpNbzVbebOTe6UJ/L9nlWCpR1wkB9F?=
 =?us-ascii?Q?dkZt1XMmBLs6u7kTLbf+BGxrXKp95sJKXPuESdaKyCvOBZ4yOAwwdGM6X5Hl?=
 =?us-ascii?Q?zAQyNn/wHB9rIExuI8IrYTC7JT5j6/aWJ5MYBjXm4A7QGUoNG8kQaHzRDJJ6?=
 =?us-ascii?Q?y/7K06YzD+yygBp+GroX77T5Fm1mAzIlvI59RHj3fFtOhW8sG7s9zcxal3Ng?=
 =?us-ascii?Q?p62iZZ6VVGID1SsoTGhddoj7RZDrWLu7V+yDO78Hjs0kj81ml4y+ojGS2cj+?=
 =?us-ascii?Q?Q+qqUzswjTpRPl53aiZB8Ps82fTZ1TW1x3tb0kcXgiFVn6IwX8ZylSWbcROV?=
 =?us-ascii?Q?SWnOG/8scnLB5QMLIFeXHuP4ArH9CrQRWWcpyorn5kYG37O2Pnc8j6TUSHRx?=
 =?us-ascii?Q?b5SZDbZRsW1kWaJiNHFWd6Bq/nFwKu0q8F4JiHt+/ZWkhNecWJ9lALOm5tnw?=
 =?us-ascii?Q?KNpn6vHYVf7RpqEdDc0fP4LE/fTUzEfDTlzUHDml97UvSuisNYYqNWjSZdLR?=
 =?us-ascii?Q?WRt59l6zRZtXpLpI4vMKHoTxKoLfCIZ18Tr8KSw78FDXwUiF3pH7j1WgrLQ6?=
 =?us-ascii?Q?HVyc5JN7OIi/gC5hkTy1XSItsBNJEI7+Qc4XVF1oZ94c87Fg9czFMBeR5WW9?=
 =?us-ascii?Q?iBrA0DJk8ZSta//ibGcRrV6U6PAKhOmeE6nsvMBpHLPPzWNVj9IkvBupiQ4T?=
 =?us-ascii?Q?TfIFnBTDCRxNrEbl6sDVSNA26AyxaOumq9WottS1MN9kypzSN5jIp/YhO0iV?=
 =?us-ascii?Q?7OzPaD9X90tDzg4BFQ0S6EM5i2PyDb3/dD6G00yRqSKyVK92Ij3MOSG6Yo+a?=
 =?us-ascii?Q?hRnkH3p25ulwIevOCT86QM6tNfa3Q9THlLwdK04VMX69rkKCqP2MLIM7j+FU?=
 =?us-ascii?Q?6MzzYRI45TwXBxWznyx+rNcMjA7mCfrnDReuDryl3K9ga1xEBeQILGZHKwq1?=
 =?us-ascii?Q?hm9FiUYGp/96haCRW7BgqSPzs5jYvt8ILLdTEd4axsLwE14yLeAKXbpAFngF?=
 =?us-ascii?Q?8NP+TpIYYP8emLi1ZyPvUSzVpLgkAb8wY7BCL9LP3V0f94PUDdn5JcLsOue9?=
 =?us-ascii?Q?+z3smanxoSACSC8e5F1rVW6Q+FdqZOO+cFfUq5CF6hfK3Y349jw8KqKmXEAZ?=
 =?us-ascii?Q?KjVfCcogZhPvAQ9f1lzNi9achCSLPeEJQGBg3RPZzfEQRSvlekENRYXwdH1o?=
 =?us-ascii?Q?ewnGuQ3OKpgUJ3sZJyHFXZsdhnEj5GOpipauhYi7TT2G9K72YbOS4PtJioWx?=
 =?us-ascii?Q?tBetE8OQHxP06DPwrv/lRn6j8e05MWftAbIxceKLRO4tvc8iuFcQY2Gf3pr9?=
 =?us-ascii?Q?cQza+lcWP00I4SrQIgs/kRv6YPQ/r2ianh834Pe1POjeBjJepyugTVumhFOW?=
 =?us-ascii?Q?JrnjTRb1gw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 527532b4-cf63-4834-866b-08df253fad26
X-MS-Exchange-CrossTenant-AuthSource: CH8PR12MB9741.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 13:25:52.8903
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nQWoAqL64l8G2hjYOWsbMlc71wnNrdH8Iz/FlGzFY3JgyyO57Ygx0WTpeBL2sFQAdQdtYAejIUWa0ufyJfNgdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9796

Add an audit argument to tpm2_start_auth_session(). When set, the
session is flagged so that tpm_buf_append_hmac_session() sets
TPM2_SA_AUDIT (TPMA_SESSION_AUDIT) on every command using it, causing
the TPM to extend the session audit digest with each command and
response.

Since only a single session is held per chip, return -EBUSY if a
session is already active with a different audit setting rather than
silently reusing it.

Signed-off-by: Matthew Garrett <matthewg@nvidia.com>
---
 drivers/char/tpm/tpm2-cmd.c               |  4 +--
 drivers/char/tpm/tpm2-sessions.c          | 30 ++++++++++++++++++-----
 include/linux/tpm.h                       |  5 ++--
 security/keys/trusted-keys/trusted_tpm2.c |  6 ++---
 4 files changed, 32 insertions(+), 13 deletions(-)

diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index ae22295df798..bfad86ed0132 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -178,7 +178,7 @@ int tpm2_pcr_extend(struct tpm_chip *chip, u32 pcr_idx,
 	int i;
 
 	if (!disable_pcr_integrity) {
-		rc = tpm2_start_auth_session(chip);
+		rc = tpm2_start_auth_session(chip, false);
 		if (rc)
 			return rc;
 	}
@@ -254,7 +254,7 @@ int tpm2_get_random(struct tpm_chip *chip, u8 *dest, size_t max)
 	if (!num_bytes || max > TPM_MAX_RNG_DATA)
 		return -EINVAL;
 
-	err = tpm2_start_auth_session(chip);
+	err = tpm2_start_auth_session(chip, false);
 	if (err)
 		return err;
 
diff --git a/drivers/char/tpm/tpm2-sessions.c b/drivers/char/tpm/tpm2-sessions.c
index ca1e2bf424e1..9fb710a1c6c6 100644
--- a/drivers/char/tpm/tpm2-sessions.c
+++ b/drivers/char/tpm/tpm2-sessions.c
@@ -129,6 +129,8 @@ struct tpm2_auth {
 	struct aes_enckey aes_key;
 	/* saved session attributes: */
 	u8 attrs;
+	/* set TPM2_SA_AUDIT on every command using this session */
+	bool audit;
 	__be32 ordinal;
 
 	/*
@@ -376,6 +378,10 @@ void tpm_buf_append_hmac_session(struct tpm_chip *chip, struct tpm_buf *buf,
 	/* The first write to /dev/tpm{rm0} will flush the session. */
 	attributes |= TPM2_SA_CONTINUE_SESSION;
 
+	auth = chip->auth;
+	if (auth->audit)
+		attributes |= TPM2_SA_AUDIT;
+
 	/*
 	 * The Architecture Guide requires us to strip trailing zeros
 	 * before computing the HMAC
@@ -383,7 +389,6 @@ void tpm_buf_append_hmac_session(struct tpm_chip *chip, struct tpm_buf *buf,
 	while (passphrase && passphrase_len > 0 && passphrase[passphrase_len - 1] == '\0')
 		passphrase_len--;
 
-	auth = chip->auth;
 	auth->attrs = attributes;
 	auth->passphrase_len = passphrase_len;
 	if (passphrase_len)
@@ -777,6 +782,7 @@ int tpm_buf_check_hmac_response(struct tpm_chip *chip, struct tpm_buf *buf,
 	off_t offset_s, offset_p;
 	u8 rphash[SHA256_DIGEST_SIZE];
 	u32 attrs, cc;
+	u8 rsp_attrs;
 	struct sha256_ctx sctx;
 	struct hmac_sha256_ctx hctx;
 	u16 tag = be16_to_cpu(head->tag);
@@ -828,7 +834,7 @@ int tpm_buf_check_hmac_response(struct tpm_chip *chip, struct tpm_buf *buf,
 		goto out;
 	memcpy(auth->tpm_nonce, &buf->data[offset_s], len);
 	offset_s += len;
-	attrs = tpm_buf_read_u8(buf, &offset_s);
+	rsp_attrs = tpm_buf_read_u8(buf, &offset_s);
 	len = tpm_buf_read_u16(buf, &offset_s);
 	if (offset_s + len != tpm_buf_length(buf))
 		goto out;
@@ -854,7 +860,12 @@ int tpm_buf_check_hmac_response(struct tpm_chip *chip, struct tpm_buf *buf,
 	hmac_sha256_update(&hctx, rphash, sizeof(rphash));
 	hmac_sha256_update(&hctx, auth->tpm_nonce, sizeof(auth->tpm_nonce));
 	hmac_sha256_update(&hctx, auth->our_nonce, sizeof(auth->our_nonce));
-	hmac_sha256_update(&hctx, &auth->attrs, 1);
+	/*
+	 * The response HMAC covers the response's session attributes, which
+	 * can differ from the command's - the TPM sets auditExclusive in the
+	 * response to an exclusive audit session.
+	 */
+	hmac_sha256_update(&hctx, &rsp_attrs, 1);
 	/* we're done with the rphash, so put our idea of the hmac there */
 	hmac_sha256_final(&hctx, rphash);
 	if (crypto_memneq(rphash, &buf->data[offset_s], SHA256_DIGEST_SIZE)) {
@@ -988,13 +999,17 @@ static int tpm2_load_null(struct tpm_chip *chip, u32 *null_key)
 /**
  * tpm2_start_auth_session() - Create an a HMAC authentication session
  * @chip:	A TPM chip
+ * @audit:	Set TPM2_SA_AUDIT on every command using the session
  *
  * Loads the ephemeral key (null seed), and starts an HMAC authenticated
- * session. The null seed is flushed before the return.
+ * session. The null seed is flushed before the return. If @audit is
+ * true, the session is used as an audit session and the TPM will
+ * extend the session digest with each command and response.
  *
- * Returns zero on success, or a POSIX error code.
+ * Returns zero on success, -EBUSY if a session with a different audit
+ * setting is already active, or a POSIX error code.
  */
-int tpm2_start_auth_session(struct tpm_chip *chip)
+int tpm2_start_auth_session(struct tpm_chip *chip, bool audit)
 {
 	struct tpm_buf *buf __free(kfree) = NULL;
 	struct tpm2_auth *auth;
@@ -1002,6 +1017,8 @@ int tpm2_start_auth_session(struct tpm_chip *chip)
 	int rc;
 
 	if (chip->auth) {
+		if (chip->auth->audit != audit)
+			return -EBUSY;
 		dev_dbg_once(&chip->dev, "auth session is active\n");
 		return 0;
 	}
@@ -1009,6 +1026,7 @@ int tpm2_start_auth_session(struct tpm_chip *chip)
 	auth = kzalloc_obj(*auth);
 	if (!auth)
 		return -ENOMEM;
+	auth->audit = audit;
 
 	rc = tpm2_load_null(chip, &null_key);
 	if (rc) {
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index b6b862c3be3b..341fd5b46b2d 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -321,7 +321,7 @@ void tpm_buf_append_auth(struct tpm_chip *chip, struct tpm_buf *buf,
 
 #ifdef CONFIG_TCG_TPM2_HMAC
 
-int tpm2_start_auth_session(struct tpm_chip *chip);
+int tpm2_start_auth_session(struct tpm_chip *chip, bool audit);
 int tpm_buf_fill_hmac_session(struct tpm_chip *chip, struct tpm_buf *buf);
 int tpm_buf_check_hmac_response(struct tpm_chip *chip, struct tpm_buf *buf,
 				int rc);
@@ -329,7 +329,8 @@ void tpm2_end_auth_session(struct tpm_chip *chip);
 #else
 #include <linux/unaligned.h>
 
-static inline int tpm2_start_auth_session(struct tpm_chip *chip)
+static inline int tpm2_start_auth_session(struct tpm_chip *chip,
+					  bool audit)
 {
 	return 0;
 }
diff --git a/security/keys/trusted-keys/trusted_tpm2.c b/security/keys/trusted-keys/trusted_tpm2.c
index 01f18bb37047..8a15bf542a9e 100644
--- a/security/keys/trusted-keys/trusted_tpm2.c
+++ b/security/keys/trusted-keys/trusted_tpm2.c
@@ -252,7 +252,7 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 	if (rc)
 		return rc;
 
-	rc = tpm2_start_auth_session(chip);
+	rc = tpm2_start_auth_session(chip, false);
 	if (rc)
 		goto out_put;
 
@@ -428,7 +428,7 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
 	if (blob_len > payload->blob_len)
 		return -E2BIG;
 
-	rc = tpm2_start_auth_session(chip);
+	rc = tpm2_start_auth_session(chip, false);
 	if (rc)
 		return rc;
 
@@ -492,7 +492,7 @@ static int tpm2_unseal_cmd(struct tpm_chip *chip,
 	u8 *data;
 	int rc;
 
-	rc = tpm2_start_auth_session(chip);
+	rc = tpm2_start_auth_session(chip, false);
 	if (rc)
 		return rc;
 
-- 
2.43.0

