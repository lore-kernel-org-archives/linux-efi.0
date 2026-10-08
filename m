Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013021.outbound.protection.outlook.com [40.93.196.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06EA34A4984;
	Thu,  8 Oct 2026 13:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791465982; cv=fail; b=FJao7UocI9I5kFdIEiD0WfGLYmCrAvXoCFRR50lJgI5cFfl8yN6oshp6W8kw5JV+4cCTqI4pljcIne7sQg1eg5rhobjJe5jCSm/9aasf8Qvr4B96CiO2u4OHlQ1hst+bueYaeFcinDaqqLTG6wYSOp2EmPKwjsp4ZFAHLs5/Obc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791465982; c=relaxed/simple;
	bh=+SKhaDKJbJmooXViiFd347838H3aGqGCQ7HXxFsD8EI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aIFSPKVayrQcsQirJ7RtTpwidFsiajgZ42oOG5WK3JPvogPHAz12RSSiS3SwtRArkYeld1r0MUHpiXuMVlYIiIDrv3Zbl5adf7/giaTFaNLCYoCPQyvP346ijZQ6zItQV7TgS6TOuTLx2OvM1txt+WaIjduuVwyCWzsbYGvpsp4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=plm8TqSN; arc=fail smtp.client-ip=40.93.196.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="plm8TqSN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RBosWDeBIR1/tXtLlnFHi+J9adSYGDHjtBaBlYrQrSi8vpVxJqyyOSUeSuAsDe0PJFrEHvlFko4wqtH9qnLBTCPRvoJ/x/uyBBR8ae5IGX2RU6mOnEh85czjAQmwcXMGYpUjNwtwfgauLrPDAw0TV4zibsRVm17GEQP6ot/1q7FuB/fpKs6N8qT06QmdyMR9XuDHQqBBuGedrzL1kqVEWWKuOArba/h4f6aYhWVRdaM6CUWdd3DBnMMJa7lj+YocGxErZ5tO98LPBCBJN1h8Uw+Y/JFu4BpH7QjMbXpb9dSdpqzBALXhjlwTeUKAY/Lgr3BguxkuUIkV0mhBbN5dOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0FRnwTPCRE2M1+qHpvDWSQHv1RbOJf7PtthzeqPaWpo=;
 b=BRoF9YtfncPvuob8v8Eev2Gn5YC2Ndaqb09BFgbNOQErmXZbVrs7vSEPBQZJ4O4O0ow6xeInFdMUT9DLX1BbvjJ5X9SnOT5lEWxZCDOms6Le6APcyCWFVTUeQSIkJbs4YWqv4NQU83Rv9//HxtynOWS9HZizYOsG6WjURksAwpMBMTdl0cbdT5u5c4R+W5MNbV/4KW0a4dau+WgxxKXSrxVIQ2Ofw149JadTRS3XccXYhsF+ABd+7P0JjWig5TzOuY3KaBp+tjb9yxm13K/14ohUlHTo+HGgiRc0QcEl5MPZhKPZijPMr5q2w7Fquguk4lsqrGeNfZDzpGvujWHRIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0FRnwTPCRE2M1+qHpvDWSQHv1RbOJf7PtthzeqPaWpo=;
 b=plm8TqSNW9n02QdhV/QCiWtcHskV/gPP9eQxBUxLR+Y29bq4vvKibwWBkTzWPSisUP0MpnYvSp0csZIeNnPFkYoXTfIBTxyyATJAdzY8bcmgME9Bv6KdrPhr9STwzWlhE/sGuP58nM59nlVDPw65PqjTFLc2zfEjwa0gl+fMmv3KzOo5FBC8GAJaep6IDbGSfLDT+mx4i0VRh+IrlNih1FJknMTZcrR+a8g0M1UKiMH5kQN4YELhXj/5FxHdwqjjQCzMw9jmSqSXl0f8KxN4kk3Z2H8k+fguvHvq7zMdjVvntgB6R+0N4dl13/qmkZ0SkDlN3oqBDpGDZYSSoeca6A==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH8PR12MB9741.namprd12.prod.outlook.com (2603:10b6:610:27a::21)
 by DS4PR12MB9796.namprd12.prod.outlook.com (2603:10b6:8:2a2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.17; Thu, 8 Oct
 2026 13:26:10 +0000
Received: from CH8PR12MB9741.namprd12.prod.outlook.com
 ([fe80::43a6:8d0:7081:65d7]) by CH8PR12MB9741.namprd12.prod.outlook.com
 ([fe80::43a6:8d0:7081:65d7%5]) with mapi id 15.21.0472.016; Thu, 8 Oct 2026
 13:26:10 +0000
From: Matthew Garrett <matthewg@nvidia.com>
To: mjg59@srcf.ucam.org
Cc: keyrings@vger.kernel.org,
	James.Bottomley@HansenPartnership.com,
	linux-integrity@vger.kernel.org,
	rafael@kernel.org,
	linux-pm@vger.kernel.org,
	linux-efi@vger.kernel.org,
	Matthew Garrett <matthewg@nvidia.com>
Subject: [PATCH 08/17] tpm: Add NV define, undefine and write helpers
Date: Thu,  8 Oct 2026 06:20:24 -0700
Message-ID: <20261008132532.1155166-9-matthewg@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261008132532.1155166-1-matthewg@nvidia.com>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0157.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ba::12) To CH8PR12MB9741.namprd12.prod.outlook.com
 (2603:10b6:610:27a::21)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH8PR12MB9741:EE_|DS4PR12MB9796:EE_
X-MS-Office365-Filtering-Correlation-Id: 2388b1a9-9eb4-4912-bdf9-08df253fb769
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|22082099003|18002099003|10067099003|3023799007|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	DmSB1QSnvQ1cgCODFUpZkaT6R9qNSdUjvSG0oBLOFHYY+EGgs9dptksbNcwDPgX6YJt+Urf5PaswQU3vC8GTPveQeI5yiXCs8W0zZVoSsKesbgNWbU46xfWWoJMmNOpZAtYh2Osj1pWYHUAZ93n9QAM6QPJUmqRuNY0XFs0qJGQts4uRBE66p4A6vJIFgNCSmWLguVzLPmtPp/jTsVFik1WICDQX7VCQqB1UIYjEefKYBygn+tCRBp2jP62g2UM+NEZGjKlA82T4Qlnlb5lxnIgv4GzxiuL23DFLbE3y/U7Ej3qrAvW1RLY8uYSmwSfYieiMT24vXFQgG0XKyhpRKn3m8eVoEeNShve3FQr5xKU3V+us72dRJVQQVkVk9U1pJJcQ7kHtmLvxpoaoeKHn4jzERtWgxTcoLcv8kakXsyV4Q+YnXRVBVBU82ChlDosqB9CYjydU1BnNhAaUPX2rjjrF9lnGicbwdAyM6rHZ4yQKlvZLLefR3pNWlT5KkzI8XgVDuzYBaCT5zOf3vDyiAb+6k0f9UMB/NcrW8UgOxD2HfBFTn1/zGY9WIbyEZQrGOWkoz4XKKuHdwJ78gbdlYgdIWYv1YAM/igU9QVC+uVX5dmfgrxQr/uq5GWy1aAt7bnTt0iH3A3xIS6Xa6S1t4NLL/jGkkWPKP9zkLVXi+Hg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH8PR12MB9741.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(22082099003)(18002099003)(10067099003)(3023799007)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uUUDG/TXpjgDFK20hT4cPAME9u8k43w85KeP7IxPm3FRaS1WGpr0HfTHqePf?=
 =?us-ascii?Q?uWkW6Yrk0Gkzt1K85RD6+bY7AUJ2h3IEvCMN4AcPzMjtEAuSQmY1zPEupYlA?=
 =?us-ascii?Q?t03/RllR13VzqUi/WP04lL/yCt9UDjLj5UYTCcIeiJtItn2+WK2t5fVfdwzm?=
 =?us-ascii?Q?DyDy8bH4zjb6d9rv9pop2kVF9zP0y1Yh9ULJ/RvHG0P9djScvelEMKztfMKN?=
 =?us-ascii?Q?VpysvophmIGWDYd4vuerBhhmcCRzZsF3tBLyeQw3NRVqxkA/NchcOJGN6dP2?=
 =?us-ascii?Q?TaqxNZvpm3o0i8/tMFe8Qb9gqjkZa/8foBw6NCJPx+v5sJwZEFQJtawoydel?=
 =?us-ascii?Q?oOAbm4BgRoDJr91yRNqXcr1u33zEDRzihAv7fFuZxj9kWKo/mrHuWa1GbUAV?=
 =?us-ascii?Q?LvWc/yMDwhd6b/Bg27sR2tN0Jg4S+T+wqdMrXsj67yt7l02HiXfN+d3s0o4F?=
 =?us-ascii?Q?zpyuEDTNYgNRolEMgm9uUDKyD4zN43HCw/Tcwr1g09X6FEIjEfWqtTWOTLQB?=
 =?us-ascii?Q?ZiidA2YJT+OsjpXQXWYvLcxfFIiGatRaj6lTBh2XSrfn1U2/IxH3nfkQXILT?=
 =?us-ascii?Q?H58UxuslXN67HMeEkMcszlspmTfiyoExfu4C2XvPSLbm0R+QktiWoTQntWQo?=
 =?us-ascii?Q?4i4COkNODBD1uwQUrG1Jlz/X2YFqqbTpf2Z1HiIoE0FBxiBuYwE6MkSly+Cl?=
 =?us-ascii?Q?tGtw+ypO9RqZar3yEg80eNN/DnexNRAI0VbBmQcE54be4Kn8IghxEOqsmmhv?=
 =?us-ascii?Q?fwzsEBeWE+GfeVAVd9T2ox7F6KrmkXgVclxhQGO6Vr1dOjKPtYmBJF+BCdaH?=
 =?us-ascii?Q?D8kGl8PRrCu92yoLdqHxDeGMIg+orrj+oSuX+ZFdrVDnKF0JEyHVkpzJHROL?=
 =?us-ascii?Q?eF2kLEjEGHhJwGUHfgc9ZPPNR3XdfoHhEA+CJRipCXZ6qb6Y0TmwVB2ICaU1?=
 =?us-ascii?Q?zq2WvtCSHjdGgBrdLDMTsa8rMT01fC8D6CNqTmj/E8s8u/2UAZ//JJQCCIB5?=
 =?us-ascii?Q?dF6sE+C9uM4xWIcsuAX60i3VlPipKsNZ1PsIu4infa2VDLiib1KTVZQYpCiB?=
 =?us-ascii?Q?/WlQJCF0PTp5S3ziMqKyI5WtjlopODeXon3fdXwwPpyjbhs9XzWlWXs0osEY?=
 =?us-ascii?Q?+unMqQc2Jm3jhqMknOkFuShIiwcBjJ16wlAnkw2UdjIStJWboF7VxGiWKHlk?=
 =?us-ascii?Q?JT1BhGzaolmG+RdCglsxC6WXCzNuYu0A2mZye/lGv3My06U54kKb8lVMW25p?=
 =?us-ascii?Q?II3u+8aQlHhZ8bue2HA+7pVfqqZQlD4QWur4VCZ0hO5Yl5SN3jn1rZFOG7Zk?=
 =?us-ascii?Q?+atpELPf87CKjTj/a2Nm1zB8CFuuUEylZMnSfnlUekVy7q9RshCrMOQoDEbU?=
 =?us-ascii?Q?nmLD4pQMG9w71LYvAXWKAUFh5s3u9TSr+pwv+olJhoXTAnm1UXTISr0F+yN7?=
 =?us-ascii?Q?nWi1k5G7ov8K1xRPxhjRBcQLhb6t3xaB6jlgNNaKbgoKT15sAYLL1BuFy4x0?=
 =?us-ascii?Q?pO2OeY8djF7IP1F4QxHbXrFM/dTvEzDQfzAqEMlb+o6W+8nMN4fYcLiNb392?=
 =?us-ascii?Q?7K7I33wrTYxNHdCvuFfaNR3uYmZqgZCOKV/+25xOF7BtMFJgkgVUAmnOydDm?=
 =?us-ascii?Q?Si5YGcNe+z954IdQnWVujgaOTWUrfFxLSlIn53s4YJYbul0YvhFTVZZYBaFa?=
 =?us-ascii?Q?oGwjU0oUg9wIMeh1D8dvCbRNHtn8grS3RA9dmhkaG5QM10hL82xV6pIbZU7a?=
 =?us-ascii?Q?k1mJMMeeVg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2388b1a9-9eb4-4912-bdf9-08df253fb769
X-MS-Exchange-CrossTenant-AuthSource: CH8PR12MB9741.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 13:26:10.0911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: usnzuq4/+2bGIIeN/36XnrIM5iE7oQrHUvSwBm1Ko2jaIInLpOOYLrux9JkNlHiw/EBI05mxgdYo0Uc7tsxDeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9796

Add tpm2_nv_define(), tpm2_nv_undefine() and tpm2_nv_write() alongside
tpm2_nv_read(). Definition and removal use the owner hierarchy, and
indices are defined as ordinary indices with an empty auth value and no
policy. As with reads, the commands use the kernel's HMAC session when
available, with writes encrypting the data, and use an active audit
session if there is one.

Factor the session setup and transmit/check sequence shared with
tpm2_nv_read() into helpers to reduce boilerplate duplication, and add
the TPMA_NV attribute bits needed to define an index.

Signed-off-by: Matthew Garrett <matthewg@nvidia.com>
---
 drivers/char/tpm/tpm.h      |   4 +
 drivers/char/tpm/tpm2-cmd.c | 229 +++++++++++++++++++++++++++++++++---
 include/linux/tpm_command.h |   8 ++
 3 files changed, 222 insertions(+), 19 deletions(-)

diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 5bd3b5658909..880327e3faa9 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -115,6 +115,10 @@ int tpm2_pcr_extend(struct tpm_chip *chip, u32 pcr_idx,
 int tpm2_get_random(struct tpm_chip *chip, u8 *dest, size_t max);
 int tpm2_nv_read(struct tpm_chip *chip, u32 nv_index, u32 auth_handle,
 		 u16 offset, u8 *data, u16 len);
+int tpm2_nv_write(struct tpm_chip *chip, u32 nv_index, u32 auth_handle,
+		  u16 offset, const u8 *data, u16 len);
+int tpm2_nv_define(struct tpm_chip *chip, u32 nv_index, u32 attrs, u16 size);
+int tpm2_nv_undefine(struct tpm_chip *chip, u32 nv_index);
 ssize_t tpm2_get_tpm_pt(struct tpm_chip *chip, u32 property_id,
 			u32 *value, const char *desc);
 
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 5c2831ee3981..0de7bcd9ec07 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -326,6 +326,212 @@ int tpm2_get_random(struct tpm_chip *chip, u8 *dest, size_t max)
 /* Minimum MAX_NV_BUFFER_SIZE required by the PC Client TPM profile */
 #define TPM2_NV_BUFFER_MIN	512
 
+static u32 tpm2_nv_buffer_max(struct tpm_chip *chip)
+{
+	u32 val;
+
+	if (tpm2_get_tpm_pt(chip, TPM2_PT_NV_BUFFER_MAX, &val, NULL) || !val)
+		return TPM2_NV_BUFFER_MIN;
+
+	return val;
+}
+
+/*
+ * Start an HMAC session for an NV command.  -EBUSY means an audit session
+ * is already active, which is used instead so the command is audited.
+ */
+static int tpm2_nv_session_begin(struct tpm_chip *chip)
+{
+	int rc = tpm2_start_auth_session(chip, false);
+
+	return rc == -EBUSY ? 0 : rc;
+}
+
+/*
+ * Send a command built with HMAC sessions and check the response.  A TPM
+ * error such as a missing index leaves the session usable, so it is only
+ * ended on a system error.
+ */
+static int tpm2_nv_transmit(struct tpm_chip *chip, struct tpm_buf *buf,
+			    const char *desc)
+{
+	int rc;
+
+	rc = tpm_buf_fill_hmac_session(chip, buf);
+	if (rc)
+		return rc;
+
+	rc = tpm_transmit_cmd(chip, buf, 0, desc);
+	rc = tpm_buf_check_hmac_response(chip, buf, rc);
+	if (rc < 0)
+		tpm2_end_auth_session(chip);
+
+	return rc;
+}
+
+/**
+ * tpm2_nv_define() - define an ordinary NV index in the owner hierarchy
+ * @chip:	TPM chip to use
+ * @nv_index:	the NV index to define
+ * @attrs:	TPMA_NV attributes of the index
+ * @size:	size of the index in bytes
+ *
+ * The index is given an empty auth value and no policy.  The owner
+ * hierarchy must have an empty auth value.
+ *
+ * Return: same as with tpm_transmit_cmd()
+ */
+int tpm2_nv_define(struct tpm_chip *chip, u32 nv_index, u32 attrs, u16 size)
+{
+	struct tpm_buf *buf __free(kfree) = NULL;
+	int rc;
+
+	rc = tpm2_nv_session_begin(chip);
+	if (rc)
+		return rc;
+
+	buf = kzalloc(TPM_BUFSIZE, GFP_KERNEL);
+	if (!buf) {
+		tpm2_end_auth_session(chip);
+		return -ENOMEM;
+	}
+
+	tpm_buf_init(buf, TPM_BUFSIZE);
+	tpm_buf_reset(buf, TPM2_ST_SESSIONS, TPM2_CC_NV_DEFINE_SPACE);
+
+	rc = tpm_buf_append_name(chip, buf, TPM2_RH_OWNER, NULL);
+	if (rc)
+		return rc;
+
+	tpm_buf_append_hmac_session(chip, buf, TPM2_SA_CONTINUE_SESSION,
+				    NULL, 0);
+
+	/* auth (empty) */
+	tpm_buf_append_u16(buf, 0);
+
+	/* publicInfo: TPM2B_NV_PUBLIC */
+	tpm_buf_append_u16(buf, sizeof(u32) + sizeof(u16) + sizeof(u32) +
+			   sizeof(u16) + sizeof(u16));
+	tpm_buf_append_u32(buf, nv_index);
+	tpm_buf_append_u16(buf, TPM_ALG_SHA256);
+	tpm_buf_append_u32(buf, attrs);
+	/* authPolicy (empty) */
+	tpm_buf_append_u16(buf, 0);
+	tpm_buf_append_u16(buf, size);
+
+	return tpm2_nv_transmit(chip, buf, "attempting to define NV index");
+}
+
+/**
+ * tpm2_nv_undefine() - undefine an NV index in the owner hierarchy
+ * @chip:	TPM chip to use
+ * @nv_index:	the NV index to undefine
+ *
+ * The owner hierarchy must have an empty auth value.
+ *
+ * Return: same as with tpm_transmit_cmd()
+ */
+int tpm2_nv_undefine(struct tpm_chip *chip, u32 nv_index)
+{
+	struct tpm_buf *buf __free(kfree) = NULL;
+	int rc;
+
+	rc = tpm2_nv_session_begin(chip);
+	if (rc)
+		return rc;
+
+	buf = kzalloc(TPM_BUFSIZE, GFP_KERNEL);
+	if (!buf) {
+		tpm2_end_auth_session(chip);
+		return -ENOMEM;
+	}
+
+	tpm_buf_init(buf, TPM_BUFSIZE);
+	tpm_buf_reset(buf, TPM2_ST_SESSIONS, TPM2_CC_NV_UNDEFINE_SPACE);
+
+	rc = tpm_buf_append_name(chip, buf, TPM2_RH_OWNER, NULL);
+	if (rc)
+		return rc;
+	rc = tpm_buf_append_name(chip, buf, nv_index, NULL);
+	if (rc)
+		return rc;
+
+	tpm_buf_append_hmac_session(chip, buf, TPM2_SA_CONTINUE_SESSION,
+				    NULL, 0);
+
+	return tpm2_nv_transmit(chip, buf, "attempting to undefine NV index");
+}
+
+/**
+ * tpm2_nv_write() - write data to an NV index
+ * @chip:	TPM chip to use
+ * @nv_index:	the NV index to write
+ * @auth_handle: the handle authorizing the write, which must have an empty
+ *		auth value
+ * @offset:	offset within the NV index to start writing at
+ * @data:	data to write
+ * @len:	number of bytes to write
+ *
+ * Writes are split into chunks no larger than the TPM's NV buffer.  When
+ * HMAC sessions are enabled the write is integrity protected and the data
+ * encrypted.
+ *
+ * Return: same as with tpm_transmit_cmd()
+ */
+int tpm2_nv_write(struct tpm_chip *chip, u32 nv_index, u32 auth_handle,
+		  u16 offset, const u8 *data, u16 len)
+{
+	struct tpm_buf *buf __free(kfree) = NULL;
+	u32 chunk_max;
+	int rc;
+
+	if ((u32)offset + len > U16_MAX + 1)
+		return -EINVAL;
+
+	chunk_max = tpm2_nv_buffer_max(chip);
+
+	rc = tpm2_nv_session_begin(chip);
+	if (rc)
+		return rc;
+
+	buf = kzalloc(TPM_BUFSIZE, GFP_KERNEL);
+	if (!buf) {
+		tpm2_end_auth_session(chip);
+		return -ENOMEM;
+	}
+
+	tpm_buf_init(buf, TPM_BUFSIZE);
+
+	while (len) {
+		u16 chunk = min_t(u32, len, chunk_max);
+
+		tpm_buf_reset(buf, TPM2_ST_SESSIONS, TPM2_CC_NV_WRITE);
+
+		rc = tpm_buf_append_name(chip, buf, auth_handle, NULL);
+		if (rc)
+			return rc;
+		rc = tpm_buf_append_name(chip, buf, nv_index, NULL);
+		if (rc)
+			return rc;
+
+		tpm_buf_append_hmac_session(chip, buf, TPM2_SA_DECRYPT |
+					    TPM2_SA_CONTINUE_SESSION, NULL, 0);
+		tpm_buf_append_u16(buf, chunk);
+		tpm_buf_append(buf, data, chunk);
+		tpm_buf_append_u16(buf, offset);
+
+		rc = tpm2_nv_transmit(chip, buf, "attempting to write NV index");
+		if (rc)
+			return rc;
+
+		data += chunk;
+		offset += chunk;
+		len -= chunk;
+	}
+
+	return 0;
+}
+
 /**
  * tpm2_nv_read() - read data from an NV index
  * @chip:	TPM chip to use
@@ -354,13 +560,10 @@ int tpm2_nv_read(struct tpm_chip *chip, u32 nv_index, u32 auth_handle,
 	if ((u32)offset + len > U16_MAX + 1)
 		return -EINVAL;
 
-	if (tpm2_get_tpm_pt(chip, TPM2_PT_NV_BUFFER_MAX, &chunk_max, NULL) ||
-	    !chunk_max)
-		chunk_max = TPM2_NV_BUFFER_MIN;
+	chunk_max = tpm2_nv_buffer_max(chip);
 
-	rc = tpm2_start_auth_session(chip, false);
-	/* -EBUSY means an audit session is active, which we can use */
-	if (rc && rc != -EBUSY)
+	rc = tpm2_nv_session_begin(chip);
+	if (rc)
 		return rc;
 
 	buf = kzalloc(TPM_BUFSIZE, GFP_KERNEL);
@@ -390,22 +593,10 @@ int tpm2_nv_read(struct tpm_chip *chip, u32 nv_index, u32 auth_handle,
 		tpm_buf_append_u16(buf, chunk);
 		tpm_buf_append_u16(buf, offset);
 
-		rc = tpm_buf_fill_hmac_session(chip, buf);
+		rc = tpm2_nv_transmit(chip, buf, "attempting to read NV index");
 		if (rc)
 			return rc;
 
-		rc = tpm_transmit_cmd(chip, buf, 0, "attempting to read NV index");
-		rc = tpm_buf_check_hmac_response(chip, buf, rc);
-		if (rc) {
-			/*
-			 * A TPM error such as a missing index leaves the
-			 * session usable, so only end it on a system error.
-			 */
-			if (rc < 0)
-				tpm2_end_auth_session(chip);
-			return rc;
-		}
-
 		/* skip the parameter size */
 		off = TPM_HEADER_SIZE + sizeof(u32);
 		if (tpm_buf_length(buf) < off + sizeof(u16))
diff --git a/include/linux/tpm_command.h b/include/linux/tpm_command.h
index 9c393f98bac2..c8e867d8bd4b 100644
--- a/include/linux/tpm_command.h
+++ b/include/linux/tpm_command.h
@@ -284,6 +284,14 @@ enum tpm2_permanent_handles {
 	TPM2_RH_ENDORSEMENT	= 0x4000000B,
 };
 
+/* TPMA_NV, for an ordinary NV index (TPM_NT_ORDINARY in bits 4-7) */
+enum tpm2_nv_attributes {
+	TPM2_NV_AUTHWRITE	= BIT(2),
+	TPM2_NV_AUTHREAD	= BIT(18),
+	TPM2_NV_NO_DA		= BIT(25),
+	TPM2_NV_WRITTEN		= BIT(29),
+};
+
 /* TPMS_ATTEST.magic */
 #define TPM2_GENERATED_VALUE	0xff544347
 
-- 
2.43.0

