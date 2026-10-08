Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013021.outbound.protection.outlook.com [40.93.196.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E148D4A441C;
	Thu,  8 Oct 2026 13:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791465968; cv=fail; b=titdCANoUcyYEdFChkHTEZe1HH9LfdDj53pLMkGmWoUQp6A4FRhdbBdoZWUntT7usvgJBTAgA9ZGS2jMbliwoK/b8Bil+TYpRkqjG5i2z2ERZhx+RKFipfZebWvavkeeqNUlnGQT8zHagGzo3q7p6dq8vFUt8rzehlohd5JSJME=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791465968; c=relaxed/simple;
	bh=Usf2lLqxmd2/lMjL2EHyfnCqTXOdjmXDoTevzbJRuAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kRf0gssTO4OR6PwuvHV9accGpTLcf+A2zI1oSInavB6KyMFmmARvSQgvxCvQ1h8tz3f+un69n2+s8VtQelQAA/7+t8yFkh+KivuMzwskwS7mbgguxzgUPIGlmONe4v9iTThq7Bmq727mYhjSLDJSX84VZD4FtsvHONN0y0nxDHY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rqipy6+k; arc=fail smtp.client-ip=40.93.196.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rqipy6+k"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S/CgQtiBIAKYYpawiPx2MIMbcVunImDNAZU6EpaBkeZi55mf6kuOakMmYH9ymzroQtMNWnRI8ZPVUipVPD0ZfFatyoKNGOCw0EHIa7dwBaNWPC3UJ0XF/vuYqzDZuBSvJuD2nTM00WaMGqWhtIN1PoMnYqgXvKPKbC3BbeFmzLnctEtGCsypsn94xBWU3o65HSTLeCUZ0mH0HmK+rAe2MCpqAa3tyiFvnpqjENGGPYVoDp6Oef3vLmz5KpCrFpL7pWQmVw6O+GH//XOYe76hSWQJOEAtFBeA/jq8a6E8LuICP975EAU7zm6E/7TLoR88sO4XCrvynctqqQqkKB/z/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a2PD3x+4t8C539ZZ4l1tcC1yYyC1a4FTyF8R/Y7GD+o=;
 b=b5WU51+tv1DKJnuhfriJzhbtpVnRyj4yr8BojuNai97ybsuOEfSgjYw7eiA3a3Ul8cAopQ1uZsZyBofFZ5KDs+mIyau7YWjt7sQbMKgNDaT0hAc54mcxirGwk94fGXSlburi2yOMjGK5HIlyMbRRwNUGYpdy4NTaIhyVUjGlAWLeuxWf9iY3oyOOSGrxBc/V6/o928ROZBlTNS8d2+9x8ZXhUYLqQhOT1hazZclRUbf0b10SY/G7O52K5EUTwxhvsT100sngB+djbu08bV7xGgPe/cmMctzpKk1IYrW/4nSL+JcUHBulkhYpJ45z/KhQdk8Ewi3IFvw+SpdrVvxllQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a2PD3x+4t8C539ZZ4l1tcC1yYyC1a4FTyF8R/Y7GD+o=;
 b=rqipy6+kyEPFXacSLW7vTxSlnyXUCnVC9htyV0AiLlkguwfWUyYgscWv9P2FBt9R9sp9BWYi10h5Bq7iTf1IueKBHvPbn9KDy8UORotSrj0Zjvn8R7ug7fyfQgIiUdyU9t3R3iwsaNNhxNAWxTO2BfNg+fRcati+G7rEPh6bzm75J2bCd7AAPjEaiGTW1gAOhvJhJhaj84P2rSEUe76+2OAopm7u0X2EqbpoOj3U8yH1Z+OGh0w1cLbi7DT2A/rxoA05GtSFD0t4z5U+f+nnwOrqYG25cKa/ahJ31boZ4G2by3jSRZHN/dhoOewLfbjtiJ9ia9jFGymKhNaeIO59OQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH8PR12MB9741.namprd12.prod.outlook.com (2603:10b6:610:27a::21)
 by DS4PR12MB9796.namprd12.prod.outlook.com (2603:10b6:8:2a2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.17; Thu, 8 Oct
 2026 13:25:56 +0000
Received: from CH8PR12MB9741.namprd12.prod.outlook.com
 ([fe80::43a6:8d0:7081:65d7]) by CH8PR12MB9741.namprd12.prod.outlook.com
 ([fe80::43a6:8d0:7081:65d7%5]) with mapi id 15.21.0472.016; Thu, 8 Oct 2026
 13:25:56 +0000
From: Matthew Garrett <matthewg@nvidia.com>
To: mjg59@srcf.ucam.org
Cc: keyrings@vger.kernel.org,
	James.Bottomley@HansenPartnership.com,
	linux-integrity@vger.kernel.org,
	rafael@kernel.org,
	linux-pm@vger.kernel.org,
	linux-efi@vger.kernel.org,
	Matthew Garrett <matthewg@nvidia.com>
Subject: [PATCH 04/17] tpm: Log commands executed in an audit session
Date: Thu,  8 Oct 2026 06:20:20 -0700
Message-ID: <20261008132532.1155166-5-matthewg@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261008132532.1155166-1-matthewg@nvidia.com>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0017.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c9::13) To CH8PR12MB9741.namprd12.prod.outlook.com
 (2603:10b6:610:27a::21)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH8PR12MB9741:EE_|DS4PR12MB9796:EE_
X-MS-Office365-Filtering-Correlation-Id: 8da523a4-83c9-4f97-dc48-08df253faf2b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|6133799003|22082099003|18002099003|10067099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	aj+JH6bJjxVd488oP74hqMXRgafb0T2xPmNMHQDaBGkkpNZT0HRyxeLz8dvxK5jJh5EZgGow4q2VsfCOxpoXzl+zPYJ3mr8Gv19vjMoekuUZbeaSCQ7qu2kEp8vLCH626PZXYFRwZZithq/Rw2SzvCtFLCgwtPFqCgxyxcbztmQkGZxM2XRdwLG92C7GIt9iFQLJLdE2tSIzT1eoSuu4mNpfq+Itdk6+rNNkW+rkMbCeOkVIc2ltDQQVIFyC0yXlg5sBbZdhyArOJr+k/p1UO8o3SVAxO5XyaaW1gOyhTQnITX/JG9Gt/gJhTw1WC/MNRYCpa3nYnc1ScgpE62rajhrUUbhRJgYBUORHNNLWPJH5KAOsH0OJdasFdcBAGrtQywB8kFBh+c6+z0WUaiQ7FHAVjTR8LXABWy5U1l6DTiVypN8d/vYwZMVexWLN56cbnYfaxvT+RXFdFbMrLItNAzZUOlxBnDRQOLP6RjvsoBCMmXsPFjHrjcrkkSykVKky6avLN9EdelU3TfoUoxLeUyhyz2uKeSoWx0KsBukwnEzW7lNKOkXe7yq4qqjR9BRzHQylzwzChcV4DgI5wAqbo+OMrK26uiYDrI90KLH8d8kUnFORZXnO8Cj1M9hFJJR0naEZv/GWTdg+0uTHJTvwpBo5gEFToFMT724NfiShtAA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH8PR12MB9741.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(6133799003)(22082099003)(18002099003)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?frgE6X8smMWsa688bZjzXMiphoMFLr08BsN+f5tQPrY22OEl1SJqrDLwRry3?=
 =?us-ascii?Q?UG1glJ6EsslZNGjUCH60f7GBF6lW3jDY6bbOUnmNQNH98tB8e9Rao7Fo9M5R?=
 =?us-ascii?Q?GdD220Ffv3x/+eg0HI45XcUGKrzMVQ5Wj7cFfR97NV9KP3cEqChQc+RIfM6Q?=
 =?us-ascii?Q?XDRDuTQOaM0//iZcipSadq8fzprkFQzycfq0FDuPZfLTH6ZABTPJWZcaXkRw?=
 =?us-ascii?Q?PDnXnSLaFFhbIOqc5dGUoUCv4j9Fjp/ybo5uUL5MUbEIMD3XxckT2Yb9ZZXq?=
 =?us-ascii?Q?jtobACTE6C4w3kZLsf4OnhSNqJRPjb770Hq91HQEV4YvWgETxmqwbouM2zjJ?=
 =?us-ascii?Q?gGsWW/YchK2jqkBGNAP3P5hBFPV/Td6UnJ3lqf++4yGO2f7A0zvAtfSw0Nwr?=
 =?us-ascii?Q?6J92JMVNryKqGCWrUMmqw4oqkQyT93hUyInaQ/lr6EGr0A62l6qMY5JkhN54?=
 =?us-ascii?Q?aSfO221hyiWdZQPH7i7SizKgej90wSfLVUIMi+p2MDFy6gebgKDYj7q+dlLK?=
 =?us-ascii?Q?1MeVml0qX6WLBbJkmaNHc/DDnkDD/LoBdhl+ESvz45A1Wt0AgO7+YhXSC/DM?=
 =?us-ascii?Q?AwRRY7NbgYrdOIbVcwLQi5ETclPZTCBebRkSGgXemR0ORYUfvkRvR2dn9aYh?=
 =?us-ascii?Q?cClkyrsl8GljeD0WsUqO7i18OtZK5men+Y1t+/OYJLEty8RF+9lEqrIPKmlf?=
 =?us-ascii?Q?iWWObUK2BONNc4gjDmiSGFgEsRvAjq8gqtKzWijXDh5rN6k1s0Pq2tgBI3cA?=
 =?us-ascii?Q?hYR++8fHK1712L9w5ucnzNh27SjAX2mjJcgeOJFv8siIDdTM09ZJ6rb2Vu+k?=
 =?us-ascii?Q?XpsNMaAt6GDH38+pDrjQO7BWHqLgSJRENd8goyMXOMN3gyOujltyAnjXTB5e?=
 =?us-ascii?Q?eQRBDq2qMUwkkMHLlOfGjxfxHtPIe7WVzFOQ1e88Q8ZHHbwsJY9IyyA1A2SU?=
 =?us-ascii?Q?jPCPYwcdhaxLv4xUL0ObnLXJU2yCXweImYvyBSTWLibUUbFJDpIzVF2i17ye?=
 =?us-ascii?Q?dP7cni19XEczZq6j9FyD1INhNeEHmvyJChjci6KX+BgyBEndguurq30PHoEk?=
 =?us-ascii?Q?dCCdTyzxjHsrDOnxuZZh3OjafLg/Jvp2bvs9m46qRKRTD886gii71dd6HOUJ?=
 =?us-ascii?Q?xd2hgys1Sj1ZcuY5ufAeJ/nJcH1gkP4auZCKQJc4fKkkTQC6VXcpPL1cLVrw?=
 =?us-ascii?Q?FPba+LuexhjfoKEwVQvkr9Eu7hnWDsi8xaZ9t1P5avpQLnDJViTBCVScKBMS?=
 =?us-ascii?Q?CSo5yAvT9cRlno0il5GOZr022fIEvrP8Ug6bhW0Tjznmrqylt/aBYgQw8zj7?=
 =?us-ascii?Q?UxmpsrjalZGm95m5Z287OKM37wS8jiPYbfjbrsyILyOZRf0KF2chAYwHyuhW?=
 =?us-ascii?Q?CyxW43YxrDjbhws1TIBznvZO6Xqu1kyQhHleGlOJqD7txVmBBi6mtt1uqVk0?=
 =?us-ascii?Q?E+oME7H3rGYH9Ul5GdsJHKtN2nMHi/ujVgX++b2qYTFOJyOQilU8l66H7++I?=
 =?us-ascii?Q?S8F1wZ8BIQLh5avwEMk5opRKqFmU9aqbM8QXaM5FEq40ZS4M/HWzNlHocvl4?=
 =?us-ascii?Q?ru8hfgDp4JBEp8O4LOsSZaQ966BKJsjyEQ687FYcCHZNsKyNZuzHa+4g5HcQ?=
 =?us-ascii?Q?A7p4ZsHAz4sSua+O43skzDuMposo700DDhwtivej6sF3NQJtxmmjtAEo9jog?=
 =?us-ascii?Q?8LtWNjUsvAMw1XGucKrGxZrlolAivkEFOpYm42ztG2eQDtbIsQG9d0Q/Mvdc?=
 =?us-ascii?Q?Iy43Mv9rnw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8da523a4-83c9-4f97-dc48-08df253faf2b
X-MS-Exchange-CrossTenant-AuthSource: CH8PR12MB9741.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 13:25:56.2890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LA4eeIsv5ggSbUNtkRBuioiug9VjZRWSQa4zlFzfGQUKNyEo88/DAyYID9s7FGpzk27WiFpqSbqLcwggI+tzIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9796

Verifying a session audit digest requires knowing every command that
was executed in the session.  The TPM extends the audit digest for
each successful command as

	digest_new := H(digest_old || cpHash || rpHash)

so the cpHash and rpHash of each command are all that is needed to
recompute it.  Both are already calculated for HMAC generation and
verification, so record them in a per-session log when the session is
an audit session. Add some helpers to retrieve and free the log.

Signed-off-by: Matthew Garrett <matthewg@nvidia.com>
---
 drivers/char/tpm/tpm-chip.c      |  2 +-
 drivers/char/tpm/tpm.h           |  1 +
 drivers/char/tpm/tpm2-sessions.c | 98 +++++++++++++++++++++++++++++++-
 include/linux/tpm.h              | 17 ++++++
 4 files changed, 115 insertions(+), 3 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 12b7394b34bd..cb10f2d1eace 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -247,7 +247,7 @@ static void tpm_dev_release(struct device *dev)
 	kfree(chip->work_space.context_buf);
 	kfree(chip->work_space.session_buf);
 #ifdef CONFIG_TCG_TPM2_HMAC
-	kfree_sensitive(chip->auth);
+	tpm2_free_auth(chip->auth);
 #endif
 	kfree(chip);
 }
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index fa554c5ad80b..e55fa22a13eb 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -144,6 +144,7 @@ void tpm_dev_common_exit(void);
 
 #ifdef CONFIG_TCG_TPM2_HMAC
 int tpm2_sessions_init(struct tpm_chip *chip);
+void tpm2_free_auth(struct tpm2_auth *auth);
 #else
 static inline int tpm2_sessions_init(struct tpm_chip *chip)
 {
diff --git a/drivers/char/tpm/tpm2-sessions.c b/drivers/char/tpm/tpm2-sessions.c
index 9fb710a1c6c6..56323a9ac87a 100644
--- a/drivers/char/tpm/tpm2-sessions.c
+++ b/drivers/char/tpm/tpm2-sessions.c
@@ -131,6 +131,13 @@ struct tpm2_auth {
 	u8 attrs;
 	/* set TPM2_SA_AUDIT on every command using this session */
 	bool audit;
+	/*
+	 * Log of every successfully executed command in an audit
+	 * session.
+	 */
+	struct tpm2_audit_entry *audit_log;
+	unsigned int audit_log_len;
+	unsigned int audit_log_size;
 	__be32 ordinal;
 
 	/*
@@ -143,6 +150,42 @@ struct tpm2_auth {
 };
 
 #ifdef CONFIG_TCG_TPM2_HMAC
+void tpm2_free_auth(struct tpm2_auth *auth)
+{
+	if (!auth)
+		return;
+
+	kfree(auth->audit_log);
+	kfree_sensitive(auth);
+}
+
+/*
+ * Make room for the entry describing the command about to be sent.
+ */
+static int tpm2_audit_log_reserve(struct tpm2_auth *auth)
+{
+	struct tpm2_audit_entry *log;
+	unsigned int size;
+
+	if (auth->audit_log_len < auth->audit_log_size)
+		return 0;
+
+	size = auth->audit_log_size ? auth->audit_log_size * 2 : 8;
+	log = kcalloc(size, sizeof(*log), GFP_KERNEL);
+	if (!log)
+		return -ENOMEM;
+
+	if (auth->audit_log) {
+		memcpy(log, auth->audit_log,
+		       auth->audit_log_len * sizeof(*log));
+		kfree_sensitive(auth->audit_log);
+	}
+	auth->audit_log = log;
+	auth->audit_log_size = size;
+
+	return 0;
+}
+
 /*
  * Name Size based on TPM algorithm (assumes no hash bigger than 255)
  */
@@ -730,6 +773,15 @@ int tpm_buf_fill_hmac_session(struct tpm_chip *chip, struct tpm_buf *buf)
 			      tpm_buf_length(buf) - offset_s);
 	sha256_final(&sctx, cphash);
 
+	if (auth->audit) {
+		ret = tpm2_audit_log_reserve(auth);
+		if (ret)
+			goto err;
+
+		memcpy(auth->audit_log[auth->audit_log_len].cphash, cphash,
+		       sizeof(cphash));
+	}
+
 	/* now calculate the hmac */
 	hmac_sha256_init_usingrawkey(&hctx, auth->session_key,
 				     sizeof(auth->session_key) +
@@ -853,6 +905,18 @@ int tpm_buf_check_hmac_response(struct tpm_chip *chip, struct tpm_buf *buf,
 	sha256_update(&sctx, &buf->data[offset_p], parm_len);
 	sha256_final(&sctx, rphash);
 
+	/*
+	 * The TPM extends the audit digest for every successful
+	 * command, so log it even if the HMAC check below fails: a
+	 * tampered response will then show up as an audit digest
+	 * mismatch.
+	 */
+	if (auth->audit) {
+		memcpy(auth->audit_log[auth->audit_log_len].rphash, rphash,
+		       sizeof(rphash));
+		auth->audit_log_len++;
+	}
+
 	/* now calculate the hmac */
 	hmac_sha256_init_usingrawkey(&hctx, auth->session_key,
 				     sizeof(auth->session_key) +
@@ -895,7 +959,7 @@ int tpm_buf_check_hmac_response(struct tpm_chip *chip, struct tpm_buf *buf,
 			/* manually close the session if it wasn't consumed */
 			tpm2_flush_context(chip, auth->handle);
 
-		kfree_sensitive(auth);
+		tpm2_free_auth(auth);
 		chip->auth = NULL;
 	} else {
 		/* reset for next use  */
@@ -924,11 +988,41 @@ void tpm2_end_auth_session(struct tpm_chip *chip)
 		return;
 
 	tpm2_flush_context(chip, auth->handle);
-	kfree_sensitive(auth);
+	tpm2_free_auth(auth);
 	chip->auth = NULL;
 }
 EXPORT_SYMBOL(tpm2_end_auth_session);
 
+/**
+ * tpm2_get_audit_log() - retrieve the log of an audit session
+ * @chip: the TPM chip structure
+ * @log: set to the array of log entries
+ *
+ * Each entry holds the cpHash and rpHash of one successfully executed
+ * command, in the order in which they were executed.  This is the
+ * information needed to recompute the session audit digest:
+ *
+ *	digest_new := SHA256(digest_old || cpHash || rpHash)
+ *
+ * The log is owned by the session and is only valid until the session
+ * is ended or another command is sent using it.
+ *
+ * Returns: the number of entries in the log, or -EINVAL if there is no
+ * active audit session.
+ */
+int tpm2_get_audit_log(struct tpm_chip *chip,
+		       const struct tpm2_audit_entry **log)
+{
+	struct tpm2_auth *auth = chip->auth;
+
+	if (!auth || !auth->audit)
+		return -EINVAL;
+
+	*log = auth->audit_log;
+	return auth->audit_log_len;
+}
+EXPORT_SYMBOL(tpm2_get_audit_log);
+
 static int tpm2_parse_start_auth_session(struct tpm2_auth *auth,
 					 struct tpm_buf *buf)
 {
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index 341fd5b46b2d..c1d0617ff8a1 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -319,9 +319,21 @@ void tpm_buf_append_hmac_session(struct tpm_chip *chip, struct tpm_buf *buf,
 void tpm_buf_append_auth(struct tpm_chip *chip, struct tpm_buf *buf,
 			 u8 *passphrase, int passphraselen);
 
+/**
+ * struct tpm2_audit_entry - a command executed in an audit session
+ * @cphash: SHA256 command parameter hash (cpHash)
+ * @rphash: SHA256 response parameter hash (rpHash)
+ */
+struct tpm2_audit_entry {
+	u8 cphash[SHA256_DIGEST_SIZE];
+	u8 rphash[SHA256_DIGEST_SIZE];
+};
+
 #ifdef CONFIG_TCG_TPM2_HMAC
 
 int tpm2_start_auth_session(struct tpm_chip *chip, bool audit);
+int tpm2_get_audit_log(struct tpm_chip *chip,
+		       const struct tpm2_audit_entry **log);
 int tpm_buf_fill_hmac_session(struct tpm_chip *chip, struct tpm_buf *buf);
 int tpm_buf_check_hmac_response(struct tpm_chip *chip, struct tpm_buf *buf,
 				int rc);
@@ -337,6 +349,11 @@ static inline int tpm2_start_auth_session(struct tpm_chip *chip,
 static inline void tpm2_end_auth_session(struct tpm_chip *chip)
 {
 }
+static inline int tpm2_get_audit_log(struct tpm_chip *chip,
+				     const struct tpm2_audit_entry **log)
+{
+	return -EOPNOTSUPP;
+}
 
 static inline int tpm_buf_fill_hmac_session(struct tpm_chip *chip,
 					    struct tpm_buf *buf)
-- 
2.43.0

