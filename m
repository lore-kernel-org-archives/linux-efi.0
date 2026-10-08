Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012009.outbound.protection.outlook.com [40.107.200.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7654AD4C2;
	Thu,  8 Oct 2026 13:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791466003; cv=fail; b=DzfxZiZGcZdvHxmVNR7L3QAb0OMGtimss91ACeW5XqN1/eCBzqSeYSo3riqCagzugkteLdqnBaK5WeT2zi1n6pYZp5NiFpjYrtUQ/J36o9SPtVTuBBKxjgtdEZjTCMHKJO+RuBm+0LbrcCwL+hxe8Bvt9Bv81o1f50X7KYvYmNo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791466003; c=relaxed/simple;
	bh=nDftuh9HvLG7ApnYN8XpI2Miseq77Ao4e2AESZpSmkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=b9di5kKDAd7lCtth4s4SKLrNvuGs9KBFgJkP2X4ZXYfmZ/K22EpweSiycw3QmRNZYlAfKAqGELQdSesW1Ni3ghjClZR5q/SAsFoIC+DbLW5odWCon3QB4HrHohEHX7V5r/9jkOSAE+xNFcDL2s2EySsbFww2hgosa9qZX8eJXfk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FMpjOhTM; arc=fail smtp.client-ip=40.107.200.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FMpjOhTM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pkiRY1Kuy6K48bohaAqrHa+YBOP/NOPJCL6tHNmVRHgUUbNXPnQ5/HPJWPJId1xcaklB4a4Y76EZ8hmg22CcGJmukycDJqx1g7Wf152F/M4O0g4d9ezMVCJVEhhu3BzcjIT/A4fhSVVSUjnHVRzOaYjb/rCYR6+Rl9as0rvV7IxqI7XT1SI1DwBbF28IaPlHjMUJT0sfH5fqttklcpk5XF/Y2qdabKLxvD7c0z7kmDqN/nfeClxYFPjCqm6qwnsNo4fBEVnU/AVP+hTpFToMv1jukhO9aeco7Y1aAqP7jz6K3/CKPnkTe3qnsI5OH1IaLOAfOcXNtmSmIbxSKFjUkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JbZ4eW7TqLvRll0xJBTAGjS+uIGmqNGLG+c2iAi6M+g=;
 b=uq7/96teIN/1CYxSZj3z/0u7+HHdPPKdDYPSGhMEQLtk+gGgy/GtuhaerzAHKKsrLI/OqTNGaIvZRzEKi6S4bzowciUUfzbbuawUR4wyGvB7Vsc/H57JGvHCv6TJGdNaYAN8zQU3U+6yFyxkcjqkJJS0dPWuvZkCvVkRI56qTTRHL7Iicbw9VP40Afypv5GKiaRN+Mb1HqrbDktU4g+HmLlIR2tNgmn1MB3gPE4gK0dZsHQCcqYaitx+YtjfCZVDlZBZODlD0qTQcAc/fmX5ZkRelnLR2BJ5rg33edmZyHfmbQTipk3SAs1qNWNpsA/IKakSy4euLNw9iPm6fV9j2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JbZ4eW7TqLvRll0xJBTAGjS+uIGmqNGLG+c2iAi6M+g=;
 b=FMpjOhTM2stQs3ggUtCzefynKyAPwVQ5ed3L6WXofkwUCuA3v1LpP+GTSDV53+f+KVXwMdA7YpAyql+H+8q9HeFk/zkK3BdduChn9rBLb0OWURNkWn8Hzkht3sR+gmGAbnfdy7yhBqBnUu4iwEp3FYXVmJ6+OWN5//vQIkzonPCPZuFL9tJQl8/4cCUWQygtAK8Gav4p89CTF2WTCRkdEf2eRlPVv4FXvtkSe9YntWmALTArzryCE8+jgZh1uIvoNq6AJolRm62/NDTVELyh5LtqUgvIjENgH5xQ/yrR1EGLYkrf6DHap2IkG6pm0BUVEw7RZQBNS2yM5Su55uHj9g==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH8PR12MB9741.namprd12.prod.outlook.com (2603:10b6:610:27a::21)
 by CY8PR12MB7587.namprd12.prod.outlook.com (2603:10b6:930:9a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.26; Thu, 8 Oct
 2026 13:26:30 +0000
Received: from CH8PR12MB9741.namprd12.prod.outlook.com
 ([fe80::43a6:8d0:7081:65d7]) by CH8PR12MB9741.namprd12.prod.outlook.com
 ([fe80::43a6:8d0:7081:65d7%5]) with mapi id 15.21.0472.016; Thu, 8 Oct 2026
 13:26:30 +0000
From: Matthew Garrett <matthewg@nvidia.com>
To: mjg59@srcf.ucam.org
Cc: keyrings@vger.kernel.org,
	James.Bottomley@HansenPartnership.com,
	linux-integrity@vger.kernel.org,
	rafael@kernel.org,
	linux-pm@vger.kernel.org,
	linux-efi@vger.kernel.org,
	Matthew Garrett <matthewg@nvidia.com>
Subject: [PATCH 14/17] PM: hibernate: Add image digest and signature page infrastructure
Date: Thu,  8 Oct 2026 06:20:30 -0700
Message-ID: <20261008132532.1155166-15-matthewg@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261008132532.1155166-1-matthewg@nvidia.com>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR05CA0102.eurprd05.prod.outlook.com
 (2603:10a6:20b:498::27) To CH8PR12MB9741.namprd12.prod.outlook.com
 (2603:10b6:610:27a::21)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH8PR12MB9741:EE_|CY8PR12MB7587:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d8f1f1e-08a7-451b-17fd-08df253fc37c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	qN+8Pd0/4uKbe2StwLBSHcMu+eqmb3IOXiH52Bmf5Q7ELQLe2IAEaH672vNgNSCMSY/8DGFV79WIH0or26baopsac6xozJORrX+Sk+jeALmNHTuf67ePPy4EhT5yPuwvg1A5gmQkQpypWLu64tJU6n8G55yNjmOw/VYOJdKs4VfCbks14IgQzuqRGtPYtwAMej7eolw30f7myKX2P2C6omRGLZX6WBJzOPcjAQaxKswUhpqWQbJkVh5Fv04iy0rVU6eDs4K3q+GMfzznQ8elvh1EsFjbro7RpXreeha+Bs1LavO04FbCNsSSe7ym7RD0pbWt9Zl2BqlhEmGsisDyY8Rg6xHXmDXV7cMBm3x0MkjxeVcWWmlIi+2M68EF/SZwQz0fjKSdkIRBXh54GQkz1ofm9LTgHJflKuW8q1kUzBVIhLsKcNfvydtlKnTBaVRJWkuUa/EFqN8SyHJGB3OuACDkb5LxLh3cuaZqfqzpwQx982RBpceA3z/FWrM9Cntsql/TZtLmLIHe6YBn2FDYczZTP2ERkPKafGENxTPLaPYiIA2fg3U5Ret75EwPe/HndQgaf8P4kr1G1tDefRR8H2BtiroXfZwWE3ZNCzIAXfx20/wwY80syuXG9vLiNGNDTBTCnUTCVI8yViAJPvAZgIddaxv292Xu/Hvj7kxeFO8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH8PR12MB9741.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?R0bia1eftCx5sP7nGURRRvdjy26yF83Yzgk3b0wrsIltqo5G97Ke23Q8iMJQ?=
 =?us-ascii?Q?Js9ZSCBzuBRY/Yj36GdisWykISgjLbqN9UmLwDRmw7FuYPvsrrkaf4Qj3weY?=
 =?us-ascii?Q?h6sW93yNGOl84P/8jYkTDj8PQFvqCUfA1uybrKKkVrnEICBK3Qv1u3ADC8oN?=
 =?us-ascii?Q?1cwtUOMuDC44/p8LomlUlARs05erXRVFUPvWuEf8m7qWvqdZcIDyyRqPHVZr?=
 =?us-ascii?Q?Sb5LmrDC9w8Y9vikD7nUWf7vR5jMCsLqp39hqKPBgx4Qgszd3Ou5lObulXWm?=
 =?us-ascii?Q?/AoZYi6/R43sCyLNymk6GE6xK6h/+DANrJp9KeU8QOaj/viu7uUVWBE7wACn?=
 =?us-ascii?Q?UOxFei5uE9gfIIa/AOJ2g9JvzJzgCc4ljDKhshocRHbo+p3vWFpoDCqM3XVd?=
 =?us-ascii?Q?lijPENz9k1ZaTQZawWzkV0fOYD9ANiAAUfjSVHT0p2Gm+A2Z3jX8hOT+0L9H?=
 =?us-ascii?Q?ELcPwUyykRgOWPUVueZsmk14s4yNxXDfNez9D8iNkmox0+wkX67wUBdMGFdY?=
 =?us-ascii?Q?xy8vrZyxqJTvxx66olX7fO4eypy3u7gx4zz7L7CiiKVCdz15KDzT81VIkc/D?=
 =?us-ascii?Q?HlyUH9pWID3uuS0yMEmydGcy+59WWI7GUyTwuNilSTEFj8GrV1uHLov4Rt2P?=
 =?us-ascii?Q?zqk7t8leYRl02bAhru7Pi0aF6VvAh3rObLcsmcY59yK05z+QlfWfN86t0XVJ?=
 =?us-ascii?Q?nZmPoOuRVtqlf22aeCzvkgOyOCNPPp1ao7AZz0hOTc2xsE7xUfe3PoDjA5uo?=
 =?us-ascii?Q?q8n1cAXDOa5Ifb/oBB6NlFPc2tixut9kP+G/0nu1TbrvuZVYvpKksnQwEHRX?=
 =?us-ascii?Q?WQsUhTg4S12HJ7+HA3YCmDFqI+ocwBm6jTtZITejBvWG9PKA/mJfsbMRw/2E?=
 =?us-ascii?Q?Y4RRZWI+oPOcK34/vDi3FRflzjxG2MjvJ+V7V4bC1EccK65yQEsXXSqxRoI6?=
 =?us-ascii?Q?tDYl6cu4pMHTWpJ+mh0uQnkmysC8dLojGXl7tMRduZfkIjj6yc2GZLecBDQY?=
 =?us-ascii?Q?sjYlaOdQq9D/cfeX4Qz6i4e6GVNazluKPFly9MOC5I68RTZ3zA1g+UGCEH17?=
 =?us-ascii?Q?CK870+PSVn2wD8L1vkf6ZIfR8puCITfe0a9Add0X48pV5GDIt25uK9eC14aJ?=
 =?us-ascii?Q?viklhIz9WJvC4lkOZYKkUTfCO7Wz/IDv2JYq4xSwi4C/kCTZv+WSEGUZOLW1?=
 =?us-ascii?Q?5A8HSshMJzsWU2CLIAS+a2Ve/VUfRzrFYhNSL9oBuzm1JHcFMUN7yXpGJa/y?=
 =?us-ascii?Q?NgqwBQtooHMmBS9VozjxfACXaD3nekgMBGfJ61SzFzT0p2Q8De78ZPsxclvf?=
 =?us-ascii?Q?6hf9u4DsoBevjm9zhJX8M/vvj/0cKnTkBkfvwdtdsOq3q9iWhLe3DiMZXMme?=
 =?us-ascii?Q?TUBd8HKunDlrQlW7Jw3Vz4DjzzY9+L5XS8Q8yx4P+s3dIvqxPdFyyp2EtshJ?=
 =?us-ascii?Q?552EYXEHFHOxrMPtZGgXpojTfmicG68Y8slUexum2VNar+umBtti1L04F4hJ?=
 =?us-ascii?Q?r5W/6A0ZMm6XMjdKSYdk6x9tCrbq5WqNKXpcBuhp03gwtQ4cq1vCeIBGITwx?=
 =?us-ascii?Q?rS8H8I/ZaAs1OZMSOLRp2su5P+O7TBEkLaRF63iQ4Nu3JYG2O56zeb3QDpll?=
 =?us-ascii?Q?XyCwbXCZl2qt9O3j5n0NJd9IrM5D/clTnB7FvHteRVyNbT5BiSPdGyWxuaIK?=
 =?us-ascii?Q?05G1HFqoET4DrAyHTxyn5cyBXg0ddOqLgp92nlc3wwRSVlX2cc8CwnBkUcNT?=
 =?us-ascii?Q?G7ZIf25qfA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d8f1f1e-08a7-451b-17fd-08df253fc37c
X-MS-Exchange-CrossTenant-AuthSource: CH8PR12MB9741.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 13:26:30.3582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vzdHZ7WtSeDCpgcF6KXP9apwYDjL460C8AEZW/E8erK06FtbU4PL86VPNY8tfXWq15Y79IrnaDS2a+IlTJFv5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7587

Add support for signing hibernation images, so that a kernel can refuse
to restore an image that it did not write or that has been modified.

A signing backend registers a struct hib_sig_ops. When one is
registered, the SHA-256 digest of every page of the image stream, with
a domain separation prefix, is computed as the image is produced by
snapshot_read_next(). An extra page holding the backend's signature over
the digest is added to the end of the stream, and the image header
records its presence along with up to HIB_SIG_HEADER_SIZE bytes of
backend data needed for verification. As the signature page is part of
the image stream, it is carried by every backend that stores the
stream, including uswsusp.

When the image is loaded, snapshot_write_next() hashes each page once
the caller has filled it, skipping zero pages that are reconstructed
rather than read. The backend checks its header data as soon as the
header is loaded, before the rest of the image is read, and the
signature is verified at the start of hibernation_restore(), while
devices are still usable and before anything is quiesced. With a
backend registered, an image without a signature is rejected.

The uncompressed swap reader issues reads asynchronously, so when the
image is signed it now waits for each page before passing it on to be
hashed. The compressed reader and uswsusp already copy each page
synchronously.

With no backend registered, there is no change in behaviour.

Signed-off-by: Matthew Garrett <matthewg@nvidia.com>
---
 kernel/power/Kconfig     |   1 +
 kernel/power/hibernate.c |   6 ++
 kernel/power/power.h     |  34 +++++++++
 kernel/power/snapshot.c  | 161 ++++++++++++++++++++++++++++++++++++---
 kernel/power/swap.c      |   3 +-
 5 files changed, 194 insertions(+), 11 deletions(-)

diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index 71165e7f04f4..846f0f91dbc0 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -43,6 +43,7 @@ config HIBERNATION
 	select CRYPTO
 	select CRYPTO_LZO
 	select CRYPTO_LZ4
+	select CRYPTO_LIB_SHA256
 	help
 	  Enable the suspend to disk (STD) functionality, which is usually
 	  called "hibernation" in user interfaces.  STD checkpoints the
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index c13f68ab7f6e..1efc2bd3a387 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -568,6 +568,12 @@ int hibernation_restore(int platform_mode)
 {
 	int error;
 
+	error = snapshot_image_verify();
+	if (error) {
+		pr_err("Image signature verification failed: %d\n", error);
+		return error;
+	}
+
 	pm_prepare_console();
 	console_suspend_all();
 	error = dpm_suspend_start(PMSG_QUIESCE);
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 75b63843886e..b4733d45e6cd 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -8,6 +8,9 @@
 #include <linux/cpuidle.h>
 #include <linux/crypto.h>
 
+#define HIB_SIG_HEADER_SIZE	2560
+#define HIB_SIG_TRAILER_SIZE	256
+
 struct swsusp_info {
 	struct new_utsname	uts;
 	u32			version_code;
@@ -16,8 +19,36 @@ struct swsusp_info {
 	unsigned long		image_pages;
 	unsigned long		pages;
 	unsigned long		size;
+	/* number of signature pages at the end of the image (0 or 1) */
+	unsigned long		sig_pages;
+	/* data needed to verify the signature, stored by hib_sig_ops.begin */
+	u8			sig_header[HIB_SIG_HEADER_SIZE];
 } __aligned(PAGE_SIZE);
 
+/**
+ * struct hib_sig_ops - hibernation image signing
+ * @begin:	Called when the image header is built.  May store up to
+ *		@size bytes needed to verify the signature in @data.
+ * @sign:	Sign @digest, the SHA-256 digest of every page of the image
+ *		before the signature page, storing the signature in @trailer.
+ * @end:	Release any resources held for signing, after signing or when
+ *		hibernation is aborted.  May be called more than once.
+ * @check_header: Check the data stored by @begin when the image header is
+ *		loaded, before the rest of the image is read.
+ * @verify:	Verify the signature in @trailer over @digest before the
+ *		image is restored.
+ *
+ * If signing is enabled, every image is signed and images without a valid
+ * signature are not restored.
+ */
+struct hib_sig_ops {
+	int (*begin)(void *data, size_t size);
+	int (*sign)(const u8 *digest, void *trailer, size_t size);
+	void (*end)(void);
+	int (*check_header)(const void *data, size_t size);
+	int (*verify)(const u8 *digest, const void *trailer, size_t size);
+};
+
 #if defined(CONFIG_SUSPEND) || defined(CONFIG_HIBERNATION)
 extern int pm_sleep_fs_sync(void);
 extern bool filesystem_freeze_enabled;
@@ -164,6 +195,9 @@ extern int snapshot_read_next(struct snapshot_handle *handle);
 extern int snapshot_write_next(struct snapshot_handle *handle);
 int snapshot_write_finalize(struct snapshot_handle *handle);
 extern int snapshot_image_loaded(struct snapshot_handle *handle);
+extern bool snapshot_image_signed(void);
+extern int snapshot_image_verify(void);
+extern void hibernate_set_sig_ops(const struct hib_sig_ops *ops);
 
 extern bool hibernate_acquire(void);
 extern void hibernate_release(void);
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index b209712cb2c3..bbf9de4b15ab 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -36,6 +36,7 @@
 #include <asm/mmu_context.h>
 #include <asm/tlbflush.h>
 #include <asm/io.h>
+#include <crypto/sha2.h>
 
 #include "power.h"
 
@@ -168,6 +169,37 @@ static struct linked_page *safe_pages_list;
 /* Pointer to an auxiliary buffer (1 page) */
 static void *buffer;
 
+/*
+ * Image signing.  When signing is enabled, the SHA-256 digest of every page
+ * of the image is signed, and the signature is stored in an extra page at
+ * the end of the image.
+ */
+static const struct hib_sig_ops *hib_sig;
+static unsigned long nr_sig_pages;
+static struct sha256_ctx hib_sig_ctx;
+static u8 hib_sig_digest[SHA256_DIGEST_SIZE];
+/*
+ * restore: the signature page is read here, as the image buffer is freed
+ * by prepare_image() on systems without highmem
+ */
+static u8 hib_sig_page[PAGE_SIZE] __aligned(PAGE_SIZE);
+/* restore: the page handed out last must be hashed when it is filled */
+static bool hib_sig_hash_pending;
+/* the signature page has been handed out, or (restore) received */
+static bool hib_sig_trailer_out;
+static bool hib_sig_trailer_in;
+
+static const char hib_sig_domain[] = "Linux hibernation image v1";
+
+static void hib_sig_start(void)
+{
+	sha256_init(&hib_sig_ctx);
+	sha256_update(&hib_sig_ctx, hib_sig_domain, sizeof(hib_sig_domain));
+	hib_sig_hash_pending = false;
+	hib_sig_trailer_out = false;
+	hib_sig_trailer_in = false;
+}
+
 #define PG_ANY		0
 #define PG_SAFE		1
 #define PG_UNSAFE_CLEAR	1
@@ -1591,6 +1623,9 @@ void swsusp_free(void)
 {
 	unsigned long fb_pfn, fr_pfn;
 
+	if (hib_sig && hib_sig->end)
+		hib_sig->end();
+
 	if (!forbidden_pages_map || !free_pages_map)
 		goto out;
 
@@ -2141,6 +2176,7 @@ asmlinkage __visible int swsusp_save(void)
 	/* We don't actually copy the zero pages */
 	nr_zero_pages = nr_pages - nr_copy_pages;
 	nr_meta_pages = DIV_ROUND_UP(nr_pages * sizeof(long), PAGE_SIZE);
+	nr_sig_pages = hib_sig ? 1 : 0;
 
 	pm_deferred_pr_dbg("Image created (%d pages copied, %d zero pages)\n",
 			   nr_copy_pages, nr_zero_pages);
@@ -2174,17 +2210,26 @@ static const char *check_image_kernel(struct swsusp_info *info)
 
 unsigned long snapshot_get_image_size(void)
 {
-	return nr_copy_pages + nr_meta_pages + 1;
+	return nr_copy_pages + nr_meta_pages + nr_sig_pages + 1;
 }
 
 static int init_header(struct swsusp_info *info)
 {
+	int error;
+
 	memset(info, 0, sizeof(struct swsusp_info));
 	info->num_physpages = get_num_physpages();
 	info->image_pages = nr_copy_pages;
 	info->pages = snapshot_get_image_size();
 	info->size = info->pages;
 	info->size <<= PAGE_SHIFT;
+	info->sig_pages = nr_sig_pages;
+	if (nr_sig_pages) {
+		error = hib_sig->begin(info->sig_header,
+				       sizeof(info->sig_header));
+		if (error)
+			return error;
+	}
 	return init_header_complete(info);
 }
 
@@ -2234,7 +2279,7 @@ static inline void pack_pfns(unsigned long *buf, struct memory_bitmap *bm,
  */
 int snapshot_read_next(struct snapshot_handle *handle)
 {
-	if (handle->cur > nr_meta_pages + nr_copy_pages)
+	if (handle->cur > nr_meta_pages + nr_copy_pages + nr_sig_pages)
 		return 0;
 
 	if (!buffer) {
@@ -2246,6 +2291,7 @@ int snapshot_read_next(struct snapshot_handle *handle)
 	if (!handle->cur) {
 		int error;
 
+		hib_sig_start();
 		error = init_header((struct swsusp_info *)buffer);
 		if (error)
 			return error;
@@ -2255,6 +2301,19 @@ int snapshot_read_next(struct snapshot_handle *handle)
 	} else if (handle->cur <= nr_meta_pages) {
 		clear_page(buffer);
 		pack_pfns(buffer, &orig_bm, &zero_bm);
+	} else if (handle->cur > nr_meta_pages + nr_copy_pages) {
+		int error;
+
+		/* the signature page, covering every page before it */
+		sha256_final(&hib_sig_ctx, hib_sig_digest);
+		clear_page(buffer);
+		error = hib_sig->sign(hib_sig_digest, buffer,
+				      HIB_SIG_TRAILER_SIZE);
+		if (error)
+			return error;
+		handle->buffer = buffer;
+		handle->cur++;
+		return PAGE_SIZE;
 	} else {
 		struct page *page;
 
@@ -2275,6 +2334,8 @@ int snapshot_read_next(struct snapshot_handle *handle)
 			handle->buffer = page_address(page);
 		}
 	}
+	if (nr_sig_pages)
+		sha256_update(&hib_sig_ctx, handle->buffer, PAGE_SIZE);
 	handle->cur++;
 	return PAGE_SIZE;
 }
@@ -2339,11 +2400,32 @@ static int load_header(struct swsusp_info *info)
 
 	restore_pblist = NULL;
 	error = check_header(info);
-	if (!error) {
-		nr_copy_pages = info->image_pages;
-		nr_meta_pages = info->pages - info->image_pages - 1;
+	if (error)
+		return error;
+
+	if (info->sig_pages > 1)
+		return -EINVAL;
+
+	nr_copy_pages = info->image_pages;
+	nr_sig_pages = info->sig_pages;
+	nr_meta_pages = info->pages - info->image_pages - nr_sig_pages - 1;
+
+	/* without signing enabled, a signature page is ignored */
+	if (!hib_sig)
+		return 0;
+
+	if (!nr_sig_pages) {
+		pr_err("Image is not signed\n");
+		return -EKEYREJECTED;
 	}
-	return error;
+
+	error = hib_sig->check_header(info->sig_header,
+				      sizeof(info->sig_header));
+	if (error)
+		return error;
+
+	sha256_update(&hib_sig_ctx, (u8 *)info, PAGE_SIZE);
+	return 0;
 }
 
 /**
@@ -2771,10 +2853,38 @@ int snapshot_write_next(struct snapshot_handle *handle)
 	static struct chain_allocator ca;
 	int error;
 
+	if (!handle->cur) {
+		/* A new load: discard any state left by an abandoned one. */
+		hib_sig_start();
+		nr_sig_pages = 0;
+	} else if (hib_sig_hash_pending) {
+		/* The caller has filled the page handed out last time. */
+		hib_sig_hash_pending = false;
+		if (hib_sig_trailer_out)
+			hib_sig_trailer_in = true;
+		else
+			sha256_update(&hib_sig_ctx, handle->buffer, PAGE_SIZE);
+	}
+
 next:
 	/* Check if we have already loaded the entire image */
-	if (handle->cur > 1 && handle->cur > nr_meta_pages + nr_copy_pages + nr_zero_pages)
-		return 0;
+	if (handle->cur > 1 && handle->cur > nr_meta_pages + nr_copy_pages + nr_zero_pages) {
+		if (!nr_sig_pages || hib_sig_trailer_out)
+			return 0;
+
+		/* Hand out the signature page, which is not restored. */
+		copy_last_highmem_page();
+		error = hibernate_restore_protect_page(handle->buffer);
+		if (error)
+			return error;
+		sha256_final(&hib_sig_ctx, hib_sig_digest);
+		handle->buffer = hib_sig_page;
+		handle->sync_read = true;
+		hib_sig_trailer_out = true;
+		hib_sig_hash_pending = true;
+		handle->cur++;
+		return PAGE_SIZE;
+	}
 
 	if (!handle->cur) {
 		if (!buffer)
@@ -2841,6 +2951,8 @@ int snapshot_write_next(struct snapshot_handle *handle)
 		goto next;
 	}
 
+	/* The header is hashed by load_header() once it is known to be signed */
+	hib_sig_hash_pending = handle->cur > 1 && nr_sig_pages && hib_sig;
 	return PAGE_SIZE;
 }
 
@@ -2868,7 +2980,9 @@ int snapshot_write_finalize(struct snapshot_handle *handle)
 			return error > 0 ? -ENODATA : error;
 	}
 	copy_last_highmem_page();
-	error = hibernate_restore_protect_page(handle->buffer);
+	/* The last image page was protected when the signature page was handed out */
+	error = hib_sig_trailer_out ? 0 :
+		hibernate_restore_protect_page(handle->buffer);
 	/* Do that only if we have loaded the image entirely */
 	if (handle->cur > 1 && handle->cur > nr_meta_pages + nr_copy_pages + nr_zero_pages) {
 		memory_bm_recycle(&orig_bm);
@@ -2880,7 +2994,34 @@ int snapshot_write_finalize(struct snapshot_handle *handle)
 int snapshot_image_loaded(struct snapshot_handle *handle)
 {
 	return !(!nr_copy_pages || !last_highmem_page_copied() ||
-			handle->cur <= nr_meta_pages + nr_copy_pages + nr_zero_pages);
+			handle->cur <= nr_meta_pages + nr_copy_pages + nr_zero_pages ||
+			(nr_sig_pages && !hib_sig_trailer_in));
+}
+
+/**
+ * snapshot_image_signed - Check if the image being loaded is signed.
+ */
+bool snapshot_image_signed(void)
+{
+	return nr_sig_pages && hib_sig;
+}
+
+/**
+ * snapshot_image_verify - Verify the signature of a loaded image.
+ *
+ * Return: 0 if signing is disabled or the image has a valid signature, or
+ * a negative error code otherwise.
+ */
+int snapshot_image_verify(void)
+{
+	if (!hib_sig)
+		return 0;
+
+	if (!nr_sig_pages || !hib_sig_trailer_in)
+		return -EKEYREJECTED;
+
+	return hib_sig->verify(hib_sig_digest, hib_sig_page,
+			       HIB_SIG_TRAILER_SIZE);
 }
 
 #ifdef CONFIG_HIGHMEM
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index c78f1593600b..f8840cb1a2a6 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -1116,7 +1116,8 @@ static int load_image(struct swap_map_handle *handle,
 		ret = swap_read_page(handle, data_of(*snapshot), &hb);
 		if (ret)
 			break;
-		if (snapshot->sync_read)
+		/* each page must be complete before it is hashed */
+		if (snapshot->sync_read || snapshot_image_signed())
 			ret = hib_wait_io(&hb);
 		if (ret)
 			break;
-- 
2.43.0

