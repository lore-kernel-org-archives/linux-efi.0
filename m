Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013021.outbound.protection.outlook.com [40.93.196.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D5E4A4F0B;
	Thu,  8 Oct 2026 13:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791465977; cv=fail; b=Yx9iqEgX8FLPdc6nVXMT3mubPK0pyamj4/ciLc5LA+nj4W4qBOjkvMt6iy28IRdFWUUgnxfnepgDjiNBLWjjPMwX62ojmY2cRPOzzTfQ/6MAQBVaz+kOKczaCyY668C5VEyDdA8h/kSzg5CoRlywXXZgNgx8zEsnmzymTC20qSU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791465977; c=relaxed/simple;
	bh=IhObJ4YwMFfuuXVPcp7Qw6/RytNetvqVaP3SPfnA7k4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JSHNpTHTxja7FxxKuBUad8lwvvIrWrfXqIN9yxsdsV4gr8wgPZVWvOn9X4LlpYwAgiXUqmlz+c2Ny2ulD1DlOlFsz/IlJ53GtWOs/EydCvERny7qPUHhoTZgNIRMHcJiwJ0w6Ej1ghN/bSgN+1q0hlp5lLQRdC4UXGewCwfBpAA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=D8Vuvclw; arc=fail smtp.client-ip=40.93.196.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="D8Vuvclw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vfje6X3QshqfLb6x7e5/NqlP4x+mWXek6MymS8RpG81YMePP5AUrXra8NFHEVpE/4JFdO34aTA6H5w/UCVppO60qzMQP28dzCLm9Pj+BQwkfcFyF2dMR4PUwJLactqXy5DD9aBHEHuTUSWHyk0ItLSq7bx0x7ucx11tj20PjIMymaEHj14WxtwCEVo4kXqLJ8e9d1Zih/UnBEk2cQqNbjVESI2k5wHtJU/XHRJohLhH4XWhXv9hBGX0Zyx8Hx2xEskWUktLoUR3vh/zkNMVG5R0gTgnsGg9kxgRAciP03qCJVzmskVdLGSXPUWyk0DUmF2xm0JqPyrsmYXWIIYmcTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8jV02VBGD133qCvquv0occcWQrFzhT5m/tXiM9fesOw=;
 b=r6FtUUsOwwRFzLBHUglgGCS039AhzSB8DAqqXR5VrEd0Qa1+8INtbUBvyKJVMwCeEZMUuUP2BBO0l5tkKm8/OnLAfckbTCWanae+Rsps/CulbHLtZyxaDn58hWnL8uY0ZBpjz5akV/T0Bh9OnIrf0hWzUWO3Tn5B/p/Yh6Tj+gXzIwXuHi0+wYrsw10Q5A99peXZ6F4uCt+7JRQTw+gicYoldNGiGkhkU25DobBcjQlIN6IJ69WsnJZYJ35sJYo5PyDdETld89HuUxdYf95ZdGKLQCxfvODRmpKWeflwTXbBhZDPWxoffGwmrqvnIfbBVnLSmIIAzoNT/QX70JcjwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8jV02VBGD133qCvquv0occcWQrFzhT5m/tXiM9fesOw=;
 b=D8Vuvclwo+aanGPUwZWxwH+LZXmgUnz7EaNOW9SrZBBebHFWl6uiOGmddGFO27TWiYAV3UVEjGTf/Fib/aHbMnAO14Lshi0qbDJjResco9ZVlz0wCAQm8lUXxACetk5Rx8JJYvxlRZsVfwDTC25Nkypg6+r6usbuKZBTq2r24nWbAx10HefD1n/CLdapzt90Z5U1wklUOrCuYKIVN0sgRBXBK/WAER/cSNKVwDG2lmBrlSTDyrcG4b1FK1syiABj7isVCBiiVi/wAceKWmGV9XfYgeBWKJ1A0Azpos4N1Uya7PMFrOx4SgwuSikD/XF0khxXTVDJUqQlRUvmoxxERQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH8PR12MB9741.namprd12.prod.outlook.com (2603:10b6:610:27a::21)
 by DS4PR12MB9796.namprd12.prod.outlook.com (2603:10b6:8:2a2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.17; Thu, 8 Oct
 2026 13:26:06 +0000
Received: from CH8PR12MB9741.namprd12.prod.outlook.com
 ([fe80::43a6:8d0:7081:65d7]) by CH8PR12MB9741.namprd12.prod.outlook.com
 ([fe80::43a6:8d0:7081:65d7%5]) with mapi id 15.21.0472.016; Thu, 8 Oct 2026
 13:26:06 +0000
From: Matthew Garrett <matthewg@nvidia.com>
To: mjg59@srcf.ucam.org
Cc: keyrings@vger.kernel.org,
	James.Bottomley@HansenPartnership.com,
	linux-integrity@vger.kernel.org,
	rafael@kernel.org,
	linux-pm@vger.kernel.org,
	linux-efi@vger.kernel.org,
	Matthew Garrett <matthewg@nvidia.com>
Subject: [PATCH 07/17] tpm: Add in-kernel support for reading NV indices
Date: Thu,  8 Oct 2026 06:20:23 -0700
Message-ID: <20261008132532.1155166-8-matthewg@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261008132532.1155166-1-matthewg@nvidia.com>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0295.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e7::9) To CH8PR12MB9741.namprd12.prod.outlook.com
 (2603:10b6:610:27a::21)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH8PR12MB9741:EE_|DS4PR12MB9796:EE_
X-MS-Office365-Filtering-Correlation-Id: 32af4e96-64e4-434d-62ff-08df253fb524
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|6133799003|22082099003|18002099003|10067099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	mvgO/hLKGBnfpwCVHiTzvYhj3ZhXG0+GSPyEO3YpAS1J2dG8AbpjoGDgEyHMEmLwa7zr9+GaCnKsqInkjzGofI+dTbRv7s7bTKGuCwzu1aeJUDub05fBlafwO0qD8KnlL/p0yA96t7vBa0+Jg59V46XhhtHHcLVZ3Eo7PSryh21dEbnjjMLDVqMjhpN+3AGw4li8xmHDQmBITD3qWvSPzxgpSHJjFWw6n1xu7QqxRFgIGIB08CtNxohg5z1ZYAsisRbN5cYjUOv+vlaXXdqqUGwI7SEmeRW0o0x+QUzmv0ALuoy0Hqt0wpVOjhfyk157uRY/sAGIzo8ZTkTuSIfkq1PaZiJaQKlV1RtHhsmP3wbT2rTneluUxApyn/f8ICuhTNeCHO3pNbhjgLPbHl2oxGWCcrlTx/D1ov+rBCkfMe0JJlC/yhUV630BrS+mOKuA4ZdeQViKR3oAzrCKJRJvvAXMHOzEiMkujHbmF/+OlJsflZZuh/YVYEGEkX60OwziAeCPnsEkMDJPf4m4sI3WYameL4w1TmS2ble2e2+BQ1xJuJsPBuok9vkrOSc7YxXre0V+i1hNkXSrYMa+9LStwe5HUK0u32+50+cxJjrx/I77DvmIcdIXLr1QPQq62aKl8dui26BM3vI0GMIPsM3Q63EfuMVW9r/YLaDki86kLx4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH8PR12MB9741.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(6133799003)(22082099003)(18002099003)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vxaptwJBw75fuT9JwMIuUIz9i+/ueYPZwKHVNM8RKt3LVgVIMDZE2x+mpdR1?=
 =?us-ascii?Q?xIE27h/DzPzVAdhKINgB1iMugjPbQie1UwGdCeC0L72NZCsSYEzlMdKkpvY8?=
 =?us-ascii?Q?5vAkWPxTuEsRMdKyQHReYQwwdXs5dgPJii4br5o1yUPhtF8QsmqPRHmRPpY0?=
 =?us-ascii?Q?cICN1ppNa6RqQS4SjeUtEK63frN15LdpAMoYxTpeqnhhEVj5wIR0Qiv6RGU8?=
 =?us-ascii?Q?zS+5lH9zO1dJEfCYY0VSMxCTWlMtOfgRwJEKLBD0BwElnBNwjaG8b0oauPFp?=
 =?us-ascii?Q?HIoKuolSuZCFa9hy6Osm6EFaVvBr1yPdyjPrPzQ3rQzjKOThthsk0TTfYsx+?=
 =?us-ascii?Q?Ve0lGYktp4kf/1poIZgKvLMrwbWSnKWYAORJSHWMTmt9vR+qOX42igkRzgcn?=
 =?us-ascii?Q?kAf8JkSUCSrWkwTUfKyb0AiU/HG4XKeJNj1FJPo90SHck3HwnSr31hWuw448?=
 =?us-ascii?Q?0niSCy+3w+R2k7SlmSt4u00DGYM0dQlQdUvKvpQrXZ6nu+klQ0wZyWVNm45t?=
 =?us-ascii?Q?DScHvsvP1hGMYB2JVg3VX2Apfj6ZBN47hZSDFBm28ZfiGZdP6m1jCBYtms7H?=
 =?us-ascii?Q?Npoj5y8d93LlYgTuDMI3RWZtUg2yxgcIeVAjvrRswr2o9aRvXS8nJshtZlAN?=
 =?us-ascii?Q?a+sxDi8CqQifPKeg4QV6BElA5XXD9FC2nagJgb8xUwufkFG2G6JtCTN8HlBw?=
 =?us-ascii?Q?bdS2W6+dDjaJA5nxNuIK2YqAULTjJGMGxesXLbPxd3OuoxCuz+kXsdaK07mC?=
 =?us-ascii?Q?iA7MlEp5BGh4pINVcJmG1w2STkfvUdNnDb6hsmbZAbNhVj+rwC7HqwQ9nSRM?=
 =?us-ascii?Q?2tWLa2d0hi9XRyEtEUcREwyZ4pHkM0acJMEySBZfsbdHxk7L2uysdA6GSy2s?=
 =?us-ascii?Q?2FEAvkTHXRx3F9ZYVgbb66m2qlGtlGGn+CgaOtVGxjE9YcCXlo1SzoaaXvF0?=
 =?us-ascii?Q?EMAVdh7qZfEgiN7Ksb2651LoQnNqpMmRF12jp0DZzlR6IaI4GM0HtDCAzHny?=
 =?us-ascii?Q?AI3q90K91kAh00n3ogt6a+Ve2Ihrx+FHyQ+B2TXTfhH4HoPTCCt32dh3U10l?=
 =?us-ascii?Q?3BVnTlkv4QXKweHHbiU1Z+o49F45lNCKDTQwGdDcVHCCQdpDtoQSpr85gl1x?=
 =?us-ascii?Q?CK3N/DBHIM2+/IzXn3QHHP7lUfDob/X0nvdo2chazFYUkuHgJ3RbDg9SVyzo?=
 =?us-ascii?Q?wWQ0hiAuaG/Fqm39eTyXWRXU9JzdARXC+6rYfI6t3HaHDSdu2YJ6TsJgwGnb?=
 =?us-ascii?Q?Gi7HGJK62DmHSpRwNpaqTRa4+CUjWXXzl/XPnA+67sV6x7jL8Ig5AxkBNsUm?=
 =?us-ascii?Q?e37X4KUnVclQE5BZ/rqm3mRCVl9GopO6CQeY5N5LFFHaisNqIYx7NH7re3un?=
 =?us-ascii?Q?wQwoXSxkXWTep73OOOhlgXZ9+UyJYRFkcRasIUD968JUfY6N5QKpwaVymXUE?=
 =?us-ascii?Q?JgtYiefuepZI5THFdjmxbGptLQAfuTRWhmZby+pt5oL3Fd4+emOVmXbtEB8E?=
 =?us-ascii?Q?+pV4b3pbc/OqfC8BowROvuOdTVWZoj030uz2d02bQ9dgptsnz3OIDOcs7c/d?=
 =?us-ascii?Q?mcB4ZEAJxy+pULUxdmLc3Asdzr0MjPeXwqH+6f4pqtGh9nXwWQwvmf3MvqeH?=
 =?us-ascii?Q?9qEUpQyYIKs/qL+M0FPb6TrO0YqA3t6oz9fKEK8rseAg0B+Iysyh0MA08JRH?=
 =?us-ascii?Q?RjDytIXlDqtH2aU6+poYveN2Bq65Cvt9ji5ujzJBZS/PXLYKLn2Sord64FP5?=
 =?us-ascii?Q?cE96pzwHEw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32af4e96-64e4-434d-62ff-08df253fb524
X-MS-Exchange-CrossTenant-AuthSource: CH8PR12MB9741.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 13:26:06.2924
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TvNje5Ard0Srr4qf1jUCT1Z8dAmMUVgqVacBQca8wdvswt7ZGtirMYW51+bFdJK20XeUoCojxjJKMYYHfyy3KA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9796

Add tpm_nv_read(), which reads a range of a TPM 2.0 NV index using
TPM2_NV_Read. The caller supplies the authorization handle, which may
be the index itself or a hierarchy depending on the index's
attributes, and which must have an empty auth value.

Reads are split into chunks no larger than the TPM's reported
TPM2_PT_NV_BUFFER_MAX, falling back to the 512 byte minimum required
by the PC Client profile if it cannot be queried. When HMAC sessions
are enabled the reads are integrity protected and the responses
encrypted. If an audit session is already active it is used, so the
reads appear in its log. TPM errors such as a missing index leave the
session intact.

Signed-off-by: Matthew Garrett <matthewg@nvidia.com>
---
 drivers/char/tpm/tpm-interface.c |  36 +++++++++++
 drivers/char/tpm/tpm.h           |   2 +
 drivers/char/tpm/tpm2-cmd.c      | 106 +++++++++++++++++++++++++++++++
 include/linux/tpm.h              |   8 +++
 4 files changed, 152 insertions(+)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 1ccdbde98b69..b5540493dfe6 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -358,6 +358,42 @@ int tpm_pcr_read(struct tpm_chip *chip, u32 pcr_idx,
 }
 EXPORT_SYMBOL_GPL(tpm_pcr_read);
 
+/**
+ * tpm_nv_read - read data from a TPM 2.0 NV index
+ * @chip:	a &struct tpm_chip instance
+ * @nv_index:	the NV index to read
+ * @auth_handle: the handle authorizing the read: @nv_index itself, or
+ *		the owner or platform hierarchy, depending on the index's
+ *		attributes.  Its auth value must be empty.
+ * @offset:	offset within the NV index to start reading at
+ * @data:	buffer to receive the data
+ * @len:	number of bytes to read
+ *
+ * Return: same as with tpm_transmit_cmd()
+ */
+int tpm_nv_read(struct tpm_chip *chip, u32 nv_index, u32 auth_handle,
+		u16 offset, u8 *data, u16 len)
+{
+	int rc;
+
+	if (!chip)
+		return -ENODEV;
+
+	rc = tpm_try_get_ops(chip);
+	if (rc)
+		return rc;
+
+	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+		rc = tpm2_nv_read(chip, nv_index, auth_handle, offset, data,
+				  len);
+	else
+		rc = -EOPNOTSUPP;
+
+	tpm_put_ops(chip);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(tpm_nv_read);
+
 /**
  * tpm_pcr_extend - extend a PCR value in SHA1 bank.
  * @chip:	a &struct tpm_chip instance, %NULL for the default chip
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 23070bdb2aa4..5bd3b5658909 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -113,6 +113,8 @@ int tpm2_pcr_read(struct tpm_chip *chip, u32 pcr_idx,
 int tpm2_pcr_extend(struct tpm_chip *chip, u32 pcr_idx,
 		    struct tpm_digest *digests);
 int tpm2_get_random(struct tpm_chip *chip, u8 *dest, size_t max);
+int tpm2_nv_read(struct tpm_chip *chip, u32 nv_index, u32 auth_handle,
+		 u16 offset, u8 *data, u16 len);
 ssize_t tpm2_get_tpm_pt(struct tpm_chip *chip, u32 property_id,
 			u32 *value, const char *desc);
 
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index bfad86ed0132..5c2831ee3981 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -323,6 +323,112 @@ int tpm2_get_random(struct tpm_chip *chip, u8 *dest, size_t max)
 	return total ? total : -EIO;
 }
 
+/* Minimum MAX_NV_BUFFER_SIZE required by the PC Client TPM profile */
+#define TPM2_NV_BUFFER_MIN	512
+
+/**
+ * tpm2_nv_read() - read data from an NV index
+ * @chip:	TPM chip to use
+ * @nv_index:	the NV index to read
+ * @auth_handle: the handle authorizing the read, which must have an empty
+ *		auth value
+ * @offset:	offset within the NV index to start reading at
+ * @data:	buffer to receive the data
+ * @len:	number of bytes to read
+ *
+ * Reads are split into chunks no larger than the TPM's NV buffer.  When
+ * HMAC sessions are enabled the read is integrity protected and the
+ * response encrypted.  If an audit session is active it is used, so the
+ * reads are recorded in its log.
+ *
+ * Return: same as with tpm_transmit_cmd()
+ */
+int tpm2_nv_read(struct tpm_chip *chip, u32 nv_index, u32 auth_handle,
+		 u16 offset, u8 *data, u16 len)
+{
+	struct tpm_buf *buf __free(kfree) = NULL;
+	u32 chunk_max;
+	off_t off;
+	int rc;
+
+	if ((u32)offset + len > U16_MAX + 1)
+		return -EINVAL;
+
+	if (tpm2_get_tpm_pt(chip, TPM2_PT_NV_BUFFER_MAX, &chunk_max, NULL) ||
+	    !chunk_max)
+		chunk_max = TPM2_NV_BUFFER_MIN;
+
+	rc = tpm2_start_auth_session(chip, false);
+	/* -EBUSY means an audit session is active, which we can use */
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
+
+	while (len) {
+		u16 chunk = min_t(u32, len, chunk_max);
+		u16 size;
+
+		tpm_buf_reset(buf, TPM2_ST_SESSIONS, TPM2_CC_NV_READ);
+
+		/* these end the session on failure */
+		rc = tpm_buf_append_name(chip, buf, auth_handle, NULL);
+		if (rc)
+			return rc;
+		rc = tpm_buf_append_name(chip, buf, nv_index, NULL);
+		if (rc)
+			return rc;
+
+		tpm_buf_append_hmac_session(chip, buf, TPM2_SA_ENCRYPT |
+					    TPM2_SA_CONTINUE_SESSION, NULL, 0);
+		tpm_buf_append_u16(buf, chunk);
+		tpm_buf_append_u16(buf, offset);
+
+		rc = tpm_buf_fill_hmac_session(chip, buf);
+		if (rc)
+			return rc;
+
+		rc = tpm_transmit_cmd(chip, buf, 0, "attempting to read NV index");
+		rc = tpm_buf_check_hmac_response(chip, buf, rc);
+		if (rc) {
+			/*
+			 * A TPM error such as a missing index leaves the
+			 * session usable, so only end it on a system error.
+			 */
+			if (rc < 0)
+				tpm2_end_auth_session(chip);
+			return rc;
+		}
+
+		/* skip the parameter size */
+		off = TPM_HEADER_SIZE + sizeof(u32);
+		if (tpm_buf_length(buf) < off + sizeof(u16))
+			goto err_short;
+		size = get_unaligned_be16(&buf->data[off]);
+		off += sizeof(u16);
+		if (size != chunk || tpm_buf_length(buf) < off + size)
+			goto err_short;
+
+		memcpy(data, &buf->data[off], size);
+		data += size;
+		offset += size;
+		len -= size;
+	}
+
+	return 0;
+
+err_short:
+	/* the response passed the HMAC check, so the session is still valid */
+	dev_err(&chip->dev, "short NV read response\n");
+	return -EIO;
+}
+
 /**
  * tpm2_flush_context() - execute a TPM2_FlushContext command
  * @chip:	TPM chip to use
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index 1d828b32847f..d5a3320efe8b 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -257,6 +257,8 @@ extern int tpm_pcr_read(struct tpm_chip *chip, u32 pcr_idx,
 extern int tpm_pcr_extend(struct tpm_chip *chip, u32 pcr_idx,
 			  struct tpm_digest *digests);
 extern int tpm_get_random(struct tpm_chip *chip, u8 *data, size_t max);
+extern int tpm_nv_read(struct tpm_chip *chip, u32 nv_index, u32 auth_handle,
+		       u16 offset, u8 *data, u16 len);
 extern struct tpm_chip *tpm_default_chip(void);
 void tpm2_flush_context(struct tpm_chip *chip, u32 handle);
 int tpm2_find_hash_alg(unsigned int crypto_id);
@@ -292,6 +294,12 @@ static inline int tpm_get_random(struct tpm_chip *chip, u8 *data, size_t max)
 	return -ENODEV;
 }
 
+static inline int tpm_nv_read(struct tpm_chip *chip, u32 nv_index,
+			      u32 auth_handle, u16 offset, u8 *data, u16 len)
+{
+	return -ENODEV;
+}
+
 static inline struct tpm_chip *tpm_default_chip(void)
 {
 	return NULL;
-- 
2.43.0

