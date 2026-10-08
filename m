Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012009.outbound.protection.outlook.com [40.107.200.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0F54A4999;
	Thu,  8 Oct 2026 13:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791465987; cv=fail; b=BhIRGEZiMRijNGbSFPfdSXrwkO0ae2Yw4E1oDpGQwZNR3h8o/vyz2x2a4K8WpGMNUNsCKWStuCWo8X3kuGOeWVVP/oJICq/BgN9hf2aG44Mw+yJRJnSvXe8qOx0xxFhBQrjICgP8/O7RpKrPJMjyspMVrx2zk93l+tnTYIjatmk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791465987; c=relaxed/simple;
	bh=mOSgg2g+mRwHpkM0IwIjXyd+G+m0n66gmskoAHjHTcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=s4vwdVndkMpb05viPLu8hj2fUpFGqrg178o3gi9G60Ne7fRrQBvxXd2tcvnQrr91UQn6+cWQzPrsOdx5zJ4ly1Cj8AjSsQCHEc1sk6n84wvXlpvSGkpOIGlI1Y/Iixsoi8QkIpwz1iKEfqr1mjFXdGeNg0kyREsIC311QqtBy6g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SEqg7+g0; arc=fail smtp.client-ip=40.107.200.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SEqg7+g0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D9ix9S/uZTDmU4WsG2WhkUFdEL2ZOgN2IkqfELhmjdKMJ7vMPjf+C1YdV0U9MhgeGLFtJ1gCnVyqlB+9w237yZ566n87WC0t6Rpi4tQh4lIeGjj11NCWg7XceZwKpkuT0uHnuD3qUKOHcv/BuDtOkROEc1ANwNZB1moq1Cjy8yVhl+pjtttwphCBFLA/xOLML3YsYFL8EwnetyarswxGX7Jw/dT7NlyLEneyuOZC7ITipTWet/dtrRyWOqf3Y5SVOjtVtWPA4l1yDj0andp2TdhRhimk3GSMfLHoMf0cLGFivqgNkfEguT4pMH9e9QGon6G49ETEJ6IVUPr6RxVJgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K84sp+rJd45P4T2LRePHHFJDGdqtHs4AeM43htBMi48=;
 b=gfTcacLV+dUo8V2nzVmOnSW6653tXb46tsoToQX27l41NRE7DHZwcL8h86dNlIIWVTZhrvNWQ1e0m4C3oBqLmpY611mUZpoPbbmPlfirGFfRDffUPRLMLp+H1f85ooK2Do/iWEiZeL3H4DbE55KqzPJVFYANK4mGlXcLz2Eyw1uKZTyMhxsYTwiJdC6Wmm7pD8KnGmSqtDtqXcA6TIJl1u3YLXbFHcl2W9yuv/pHR5vDsrcJU2KR4dLaJYFabNuxY4qr0UBA3/o070pK/BMGu/Np2QwDEIBamaoGQ1ico3C4Y0lNE1+bTw4F2FBMAYyxEqH4ZKcVdffHEHKhGG8rkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K84sp+rJd45P4T2LRePHHFJDGdqtHs4AeM43htBMi48=;
 b=SEqg7+g0tXQnwOirfED5RFRF6PGEt2G3R3UWLbJdj7iJXOhBux2u6ZthCW+wluS5IW7bLl1p9dZ489vd2QNnN9TY038p3+iv1fy0bfhJ4dKOpC0wk0kUV/i0mAoJfOodCBmdnQyRjcCwaQ/p8D46+MLI0CAbxX+ufNe4lDA+9IR0OdYBlSZWw/kdaY9iCpSF0lODCG3lmueiwzmbijwpEt6HOIjoVDcE7ZhLy3npd9/4g3mwKRLfAcbIw2LAmddSvVZVtTnQQzXsXtdMOyQ3H2q4c76RFsiG6KjOFVdYZYANsGLcCKI/Xg0gdf3ybtb0SabL+Yz4idHhT9u2GeV8sA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH8PR12MB9741.namprd12.prod.outlook.com (2603:10b6:610:27a::21)
 by CY8PR12MB7587.namprd12.prod.outlook.com (2603:10b6:930:9a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.26; Thu, 8 Oct
 2026 13:26:13 +0000
Received: from CH8PR12MB9741.namprd12.prod.outlook.com
 ([fe80::43a6:8d0:7081:65d7]) by CH8PR12MB9741.namprd12.prod.outlook.com
 ([fe80::43a6:8d0:7081:65d7%5]) with mapi id 15.21.0472.016; Thu, 8 Oct 2026
 13:26:13 +0000
From: Matthew Garrett <matthewg@nvidia.com>
To: mjg59@srcf.ucam.org
Cc: keyrings@vger.kernel.org,
	James.Bottomley@HansenPartnership.com,
	linux-integrity@vger.kernel.org,
	rafael@kernel.org,
	linux-pm@vger.kernel.org,
	linux-efi@vger.kernel.org,
	Matthew Garrett <matthewg@nvidia.com>
Subject: [PATCH 09/17] tpm: Provision the kernel NV index at registration
Date: Thu,  8 Oct 2026 06:20:25 -0700
Message-ID: <20261008132532.1155166-10-matthewg@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261008132532.1155166-1-matthewg@nvidia.com>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0158.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ba::15) To CH8PR12MB9741.namprd12.prod.outlook.com
 (2603:10b6:610:27a::21)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH8PR12MB9741:EE_|CY8PR12MB7587:EE_
X-MS-Office365-Filtering-Correlation-Id: 80b2a394-9a75-4835-b7a5-08df253fb957
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|10067099003|11063799006|56012099006|3023799007|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	aLCYuK63HpiRslKXCo5RB6lpD77y4xi/Nl0lVaeALTnwtak4t3jZzxrpr98ZCtDc7rN6gV4HYpZHF/NldxNP96sMceQpaNxlVwtfaC5dcOx+zs+azxbMmcwqf0Tq+JxqVYlYEzA7l5TIFn83nmbdF0TWF+lv2AEwwgBvjnUoot3N5u6/TiYlUnHvC2VQpDZwgj9tiKovMOmJSQBwixYMM5kQnvITJrL4JBCSwxeDp/w4JpYQJKJ+Wicj/dh5FoulFh1xDGjHOglyPhx0UjGKaG6f4PaNADioy2PhA2Td2zvP3vQjwGjof26CpOrMR7wIiNYq9DUYMIQYYst9WupGToNIHc5OFz9bNHVCAvCiqDbeJa5swD0fhMV9kKakZwbr6CvRHwwXuBXqymSH5eLT/+57/AmCB54qxpR2vQuUlKe0GK9rLJBnSfhhpFIMQkvh35LxwNDQ35Gx06oz81SkqaGO7co+uaMWMTJlfqmhyelVCfziOygzNUo1WsIUsn4iHpLW6c409uepSV2IAJHdH0g4kTTFZNEO1/BU8GGRIml0AgJ8z+QPQ3MxJRkDzlmZB1kFVezG2H8B5Epg9wmwJNuDow2h4uXvjBjg37N5MD0veyhG/RAadoIB/aIaV6455Qm1SsDSG0Kjn6MmdBM53vA3HCA/MEN+a8W4Up7EUow=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH8PR12MB9741.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(10067099003)(11063799006)(56012099006)(3023799007)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CR6j6Uy773kkryDnwFejt9kP5f2RFix7q+N5gldgYYuf4dULwhgOWNkT4A1m?=
 =?us-ascii?Q?MWRmh/sf1UZTGaoA/zaKkLyK9Tt4xD7iGhlmJI1eFUX6llFEuuS2BbSD8pb7?=
 =?us-ascii?Q?JAGvqLcPVfsxAL3qLF7zG2om1MsVn+kd8eypbiucRrpPEnA08xWr7Ou6fduR?=
 =?us-ascii?Q?E5DUwnmc4UxthZmnFPa/S9L+OG+tl1U+s08y7nBtqUaJd8GfYgZ961RZRtQB?=
 =?us-ascii?Q?3GQQfbC+IWG17DdC795qoJ9YotHQvmAl1aPL23Avo7x3nWrsYbmKzyoNV6DY?=
 =?us-ascii?Q?VvnOp7TcM/RGxichDGzNFsqRRoMC+axyMA6+3kmQFQk1i8hxVlKRuZcoX2dF?=
 =?us-ascii?Q?0JhUuW4NICzQgQwocSotGuzu8py9Zz1WnCCeyMekI6prLoanoQgmF9DgsBH+?=
 =?us-ascii?Q?Iz9tXh7bV5Y5HtOeLrsVu+RsXZxc1B9O5m9Y+kYZmiIiNrANLTNvq7CB7c1s?=
 =?us-ascii?Q?F1qvLXCY/+N3nuLobvxm5uVflN5R29P8GfxT1NoIuWjNkATKpOf7wh7V+ZHh?=
 =?us-ascii?Q?JCE7bzTGWW9G6VdUvN+hpXs5B+p34HbTM9KMSvHqj1yKXQrJrmvszvbeZUXz?=
 =?us-ascii?Q?W5mv/tLKnTJUy3XV37EFT6/sbOaA7w7LY8tzaKFLGmIwdlpzUL3pwYQyb5yh?=
 =?us-ascii?Q?iVh+bvY6NGbQdVQzvcYkWDk2W3lIDaUIob1N80tdmXacOF0mb6lm/Om2N/OC?=
 =?us-ascii?Q?WaH46kG75g/GL5D6vnIdNpm2r7g9aci2ths+kICD3iLg2aYEzW7webt5lWHk?=
 =?us-ascii?Q?4rCy1kkHwr/DEwmpx2KD8WFOIreoAXiUjjrYGUDultTQyQ02pSx18i3WNERN?=
 =?us-ascii?Q?76Wz4rNJVUO/Gf1Jyqg89IBbFdwtx3NQJKf7Yx7cU4qlmGTmxFSaubtgpIUh?=
 =?us-ascii?Q?PE4GV7KfJFw+zT/1jEDdYua0RUFgldM1VjqBs+ObTZU2FkigtPiWBBd7IAyE?=
 =?us-ascii?Q?T57dOzwoeQr7km3SF+sODNM8QffdDesFTSSFVU8nZJuY+Vy7sMHgN2gIYAhg?=
 =?us-ascii?Q?nNlOOgVnkVtiDH08F2Psw6gFQ7NtoC/74UYFF3u5ALZ59BPAkQG5kz7gGhRH?=
 =?us-ascii?Q?oWZSgf8xSoFhskm2UJWiPOj8rFb4g/B0zQxSHCp1c6E5fAFZryiBSVJ4cnXg?=
 =?us-ascii?Q?wWf8SEdA2IyN60C9ZJYdsZOjUPt6pOqK6Ill2WPAfGuSlDnUWwqAt6A6ZPSV?=
 =?us-ascii?Q?6AaKh4XKvfkkPjnRsg9QJ6+hMuaVaAlGcoZ46less+D8IgyLBNUhoM7ZASP+?=
 =?us-ascii?Q?539Z07rWtoTzbJEsBN2pw9oIM5791T+9hcP+pEV1MDQSD85KNf7PiAsp93R6?=
 =?us-ascii?Q?Wq+wJ/eqjd9dLLvktfqmk//6yWdyrH0X45Wi1j0lDaBAShAeoahgXxsz2yUc?=
 =?us-ascii?Q?0I8E6bnmVg3qBmtjS7Kj2K0XT1NK5/QBfgL4VQytJHt2IaJyEYTLymjNjTp0?=
 =?us-ascii?Q?63uMuk0fh9OuB2beGWuiP1uCScLHy14CfRNeattX2LB/Fpa8hSIKVP9Xilmj?=
 =?us-ascii?Q?v8MFIyxQePjT68UM0i4rl6dIFHf854jC4/rQpTDJFUBMPAGAdWp9OLMeNLHB?=
 =?us-ascii?Q?9WvVb8k18Kx37fHsVUvEF9P6PSK5QBEQy6bSnC5G2tvZtUPjWDCiXuY5X0us?=
 =?us-ascii?Q?TZab/XbLjk3oNgYfnDzyu2d+SamY84Zo56JIAcGr9vZ0zfYMWkBI4spmnBw9?=
 =?us-ascii?Q?FjwhoE544j0fC7oaIhJ05ioGNsNEFhjDt8VUw8/2GHQgr40y2Dl4+ARJAaAV?=
 =?us-ascii?Q?iPX6A6c5QA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80b2a394-9a75-4835-b7a5-08df253fb957
X-MS-Exchange-CrossTenant-AuthSource: CH8PR12MB9741.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 13:26:13.3369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kpuj4ka9dPHZqciV0NbBswkzRu2zz+q2gipNXAUoHB1jn63nAkj145FAwsXrWgowK0SajTBp8vzA4JmfqTlucA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7587

The kernel NV index is going to be used to show that the kernel, and
not userspace, was in control of the TPM at a given point in time.
The kernel stores a magic value in it, runs the commands in an audit
session that reads the index, and resets it to zero before releasing
the TPM. Userspace cannot modify the index, so a log showing the magic
value can only have come from the kernel.

Before we expose the TPM to userland, make sure the index exists as an 8
byte ordinary index with an empty auth value, no policy, and the
expected attributes by comparing its name. An index with a different
public area, or one whose auth value turns out not to be empty, is
undefined and defined again to prevent userland or another OS from
leaving the magic value hanging around. The index is then reset to zero
if it holds anything else, which also clears a magic value left behind
by a crash. The owner hierarchy must have an empty auth value.

Add tpm2_kernel_nv_set_magic() and tpm2_kernel_nv_clear() for use by the
kernel while it holds the ops lock. Mark the chip whenever the index may
hold the magic value, and have tpm_dev_transmit() retry the reset and
refuse userspace commands while it is marked. The chip starts out
marked, so that a magic value left behind by a crash is never exposed,
and the mark is only removed once the index is known not to hold the
magic value. This means that if a region has been defined that the kernel
cannot remove (eg, because it was configured to require auth) we can fail
safe.

Signed-off-by: Matthew Garrett <matthewg@nvidia.com>
---
 drivers/char/tpm/Makefile         |   1 +
 drivers/char/tpm/tpm-chip.c       |  30 ++++
 drivers/char/tpm/tpm-dev-common.c |  10 ++
 drivers/char/tpm/tpm.h            |  14 ++
 drivers/char/tpm/tpm2-kernel-nv.c | 267 ++++++++++++++++++++++++++++++
 include/linux/tpm.h               |   3 +
 include/linux/tpm_command.h       |   1 +
 7 files changed, 326 insertions(+)
 create mode 100644 drivers/char/tpm/tpm2-kernel-nv.c

diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index 10a4ed388dea..88a96fee0934 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -18,6 +18,7 @@ tpm-y += eventlog/tpm2.o
 tpm-y += tpm-buf.o
 tpm-y += tpm2-sessions.o
 tpm-$(CONFIG_TCG_TPM2_HMAC) += tpm2-ak.o
+tpm-$(CONFIG_TCG_TPM2_HMAC) += tpm2-kernel-nv.o
 
 tpm-$(CONFIG_ACPI) += tpm_ppi.o eventlog/acpi.o
 tpm-$(CONFIG_EFI) += eventlog/efi.o
diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index cb10f2d1eace..1ec294d081ae 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -584,6 +584,34 @@ EXPORT_SYMBOL_GPL(tpm_chip_bootstrap);
  * This function should be only called after the chip initialization is
  * complete.
  */
+/*
+ * Make sure the kernel NV index is defined and does not hold the magic
+ * value before userspace is given access to the TPM.
+ */
+static void tpm_chip_provision_kernel_nv(struct tpm_chip *chip)
+{
+	int rc;
+
+	if (!IS_ENABLED(CONFIG_TCG_TPM2_HMAC) ||
+	    !(chip->flags & TPM_CHIP_FLAG_TPM2))
+		return;
+
+	/*
+	 * A crash while the magic value was set leaves it in the index, so
+	 * assume the worst until provisioning shows otherwise.
+	 */
+	chip->flags |= TPM_CHIP_FLAG_KERNEL_NV_DIRTY;
+
+	if (tpm_try_get_ops(chip))
+		return;
+
+	rc = tpm2_kernel_nv_provision(chip);
+	tpm_put_ops(chip);
+
+	if (rc)
+		dev_warn(&chip->dev, "kernel NV index unavailable: %d\n", rc);
+}
+
 int tpm_chip_register(struct tpm_chip *chip)
 {
 	int rc;
@@ -602,6 +630,8 @@ int tpm_chip_register(struct tpm_chip *chip)
 	if (rc)
 		goto out_ppi;
 
+	tpm_chip_provision_kernel_nv(chip);
+
 	rc = tpm_add_char_device(chip);
 	if (rc)
 		goto out_hwrng;
diff --git a/drivers/char/tpm/tpm-dev-common.c b/drivers/char/tpm/tpm-dev-common.c
index 1fd93cdaf306..44323f55da51 100644
--- a/drivers/char/tpm/tpm-dev-common.c
+++ b/drivers/char/tpm/tpm-dev-common.c
@@ -94,6 +94,16 @@ static ssize_t tpm_dev_transmit(struct tpm_chip *chip, struct tpm_space *space,
 	    tpm2_dev_cmd_is_blocked(buf, bufsiz))
 		return -EPERM;
 
+	/*
+	 * Never give userspace access while the kernel NV index may hold
+	 * the magic value.
+	 */
+	if (chip->flags & TPM_CHIP_FLAG_KERNEL_NV_DIRTY) {
+		tpm2_kernel_nv_clear(chip);
+		if (chip->flags & TPM_CHIP_FLAG_KERNEL_NV_DIRTY)
+			return -EPERM;
+	}
+
 	if (chip->flags & TPM_CHIP_FLAG_TPM2)
 		tpm2_end_auth_session(chip);
 
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 880327e3faa9..54e8d5820b6d 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -152,11 +152,25 @@ void tpm_dev_common_exit(void);
 int tpm2_sessions_init(struct tpm_chip *chip);
 void tpm2_free_auth(struct tpm2_auth *auth);
 int tpm2_audit_session_handle(struct tpm_chip *chip, u32 *handle);
+
+extern const u8 tpm2_kernel_nv_magic[TPM2_KERNEL_NV_SIZE];
+void tpm2_kernel_nv_name(bool written, u8 name[TPM2_NULL_NAME_SIZE]);
+int tpm2_kernel_nv_provision(struct tpm_chip *chip);
+int tpm2_kernel_nv_set_magic(struct tpm_chip *chip);
+int tpm2_kernel_nv_clear(struct tpm_chip *chip);
 #else
 static inline int tpm2_sessions_init(struct tpm_chip *chip)
 {
 	return 0;
 }
+static inline int tpm2_kernel_nv_provision(struct tpm_chip *chip)
+{
+	return 0;
+}
+static inline int tpm2_kernel_nv_clear(struct tpm_chip *chip)
+{
+	return 0;
+}
 #endif
 
 #endif
diff --git a/drivers/char/tpm/tpm2-kernel-nv.c b/drivers/char/tpm/tpm2-kernel-nv.c
new file mode 100644
index 000000000000..cd9ec0f24c2f
--- /dev/null
+++ b/drivers/char/tpm/tpm2-kernel-nv.c
@@ -0,0 +1,267 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Management of the kernel-owned NV index.
+ *
+ * TPM2_KERNEL_NV_INDEX is an 8 byte ordinary NV index with an empty auth
+ * value.  Userspace is prevented from modifying it by the /dev/tpm command
+ * filter, so while it holds tpm2_kernel_nv_magic the kernel is the only
+ * party that can have put it there.  The kernel sets the magic value only
+ * while it holds the chip's ops lock and resets the index to zero before
+ * releasing it, so userspace never observes the magic value.
+ */
+
+#include <linux/slab.h>
+#include <linux/unaligned.h>
+#include <crypto/sha2.h>
+#include "tpm.h"
+
+#define TPM2_KERNEL_NV_ATTRS \
+	(TPM2_NV_AUTHWRITE | TPM2_NV_AUTHREAD | TPM2_NV_NO_DA)
+
+const u8 tpm2_kernel_nv_magic[TPM2_KERNEL_NV_SIZE] = "LNXKEYGN";
+static const u8 tpm2_kernel_nv_zero[TPM2_KERNEL_NV_SIZE];
+
+/**
+ * tpm2_kernel_nv_name() - compute the expected name of the kernel NV index
+ * @written:	whether the index has been written (TPMA_NV_WRITTEN is set)
+ * @name:	filled with the name: the SHA256 algorithm ID followed by the
+ *		hash of the index's TPMS_NV_PUBLIC
+ */
+void tpm2_kernel_nv_name(bool written, u8 name[TPM2_NULL_NAME_SIZE])
+{
+	u32 attrs = TPM2_KERNEL_NV_ATTRS | (written ? TPM2_NV_WRITTEN : 0);
+	u8 pub[14];
+
+	/* TPMS_NV_PUBLIC */
+	put_unaligned_be32(TPM2_KERNEL_NV_INDEX, &pub[0]);
+	put_unaligned_be16(TPM_ALG_SHA256, &pub[4]);
+	put_unaligned_be32(attrs, &pub[6]);
+	/* authPolicy (empty) */
+	put_unaligned_be16(0, &pub[10]);
+	put_unaligned_be16(TPM2_KERNEL_NV_SIZE, &pub[12]);
+
+	put_unaligned_be16(TPM_ALG_SHA256, name);
+	sha256(pub, sizeof(pub), name + 2);
+}
+
+/*
+ * Read the name of the kernel NV index.  Returns 0 and fills @name, a
+ * positive TPM error code if the index does not exist, or -errno.
+ */
+static int tpm2_kernel_nv_read_name(struct tpm_chip *chip,
+				    u8 name[TPM2_NULL_NAME_SIZE])
+{
+	struct tpm_buf *buf __free(kfree) = NULL;
+	off_t offset = TPM_HEADER_SIZE;
+	u16 len;
+	int rc;
+
+	buf = kzalloc(TPM_BUFSIZE, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	tpm_buf_init(buf, TPM_BUFSIZE);
+	tpm_buf_reset(buf, TPM2_ST_NO_SESSIONS, TPM2_CC_NV_READ_PUBLIC);
+	tpm_buf_append_u32(buf, TPM2_KERNEL_NV_INDEX);
+
+	rc = tpm_transmit_cmd(chip, buf, 0, NULL);
+	if (rc)
+		return rc;
+
+	/* skip nvPublic */
+	if (tpm_buf_length(buf) < offset + sizeof(u16))
+		return -EIO;
+	offset += sizeof(u16) + get_unaligned_be16(&buf->data[offset]);
+
+	/* nvName */
+	if (tpm_buf_length(buf) < offset + sizeof(u16))
+		return -EIO;
+	len = get_unaligned_be16(&buf->data[offset]);
+	offset += sizeof(u16);
+	if (len != TPM2_NULL_NAME_SIZE || tpm_buf_length(buf) < offset + len)
+		return -EIO;
+
+	memcpy(name, &buf->data[offset], len);
+	return 0;
+}
+
+static int tpm2_kernel_nv_write(struct tpm_chip *chip, const u8 *value)
+{
+	return tpm2_nv_write(chip, TPM2_KERNEL_NV_INDEX, TPM2_KERNEL_NV_INDEX,
+			     0, value, TPM2_KERNEL_NV_SIZE);
+}
+
+/*
+ * Determine whether the index may hold the magic value, without changing
+ * it.  Only a definite answer that it does not is trusted: the index does
+ * not exist, has never been written, or holds some other value.
+ */
+static bool tpm2_kernel_nv_may_hold_magic(struct tpm_chip *chip)
+{
+	u8 name[TPM2_NULL_NAME_SIZE], value[TPM2_KERNEL_NV_SIZE];
+	int rc;
+
+	rc = tpm2_kernel_nv_read_name(chip, name);
+	if (rc > 0 && tpm2_rc_value(rc) == TPM2_RC_HANDLE)
+		return false;
+	if (rc)
+		return true;
+
+	rc = tpm2_nv_read(chip, TPM2_KERNEL_NV_INDEX, TPM2_KERNEL_NV_INDEX, 0,
+			  value, sizeof(value));
+	if (rc == TPM2_RC_NV_UNINITIALIZED)
+		return false;
+	if (rc)
+		return true;
+
+	return !memcmp(value, tpm2_kernel_nv_magic, sizeof(value));
+}
+
+static void tpm2_kernel_nv_update_dirty(struct tpm_chip *chip, bool dirty)
+{
+	if (dirty)
+		chip->flags |= TPM_CHIP_FLAG_KERNEL_NV_DIRTY;
+	else
+		chip->flags &= ~TPM_CHIP_FLAG_KERNEL_NV_DIRTY;
+}
+
+static int tpm2_kernel_nv_recreate(struct tpm_chip *chip)
+{
+	int rc;
+
+	rc = tpm2_nv_undefine(chip, TPM2_KERNEL_NV_INDEX);
+	if (rc)
+		return rc;
+
+	rc = tpm2_nv_define(chip, TPM2_KERNEL_NV_INDEX, TPM2_KERNEL_NV_ATTRS,
+			    TPM2_KERNEL_NV_SIZE);
+	if (rc)
+		return rc;
+
+	return tpm2_kernel_nv_write(chip, tpm2_kernel_nv_zero);
+}
+
+/*
+ * Reset the index to zero unless it already is, to avoid an NV write on
+ * every boot.
+ */
+static int tpm2_kernel_nv_ensure_zero(struct tpm_chip *chip)
+{
+	u8 value[TPM2_KERNEL_NV_SIZE];
+	int rc;
+
+	rc = tpm2_nv_read(chip, TPM2_KERNEL_NV_INDEX, TPM2_KERNEL_NV_INDEX, 0,
+			  value, sizeof(value));
+	if (!rc && !memcmp(value, tpm2_kernel_nv_zero, sizeof(value)))
+		return 0;
+
+	return tpm2_kernel_nv_clear(chip);
+}
+
+static int __tpm2_kernel_nv_provision(struct tpm_chip *chip)
+{
+	u8 expected[TPM2_NULL_NAME_SIZE], name[TPM2_NULL_NAME_SIZE];
+	int rc;
+
+	rc = tpm2_kernel_nv_read_name(chip, name);
+	if (rc < 0)
+		return rc;
+
+	if (rc > 0) {
+		/* the index does not exist */
+		rc = tpm2_nv_define(chip, TPM2_KERNEL_NV_INDEX,
+				    TPM2_KERNEL_NV_ATTRS, TPM2_KERNEL_NV_SIZE);
+		if (rc)
+			return rc;
+
+		return tpm2_kernel_nv_clear(chip);
+	}
+
+	tpm2_kernel_nv_name(true, expected);
+	if (memcmp(name, expected, sizeof(name))) {
+		tpm2_kernel_nv_name(false, expected);
+		if (memcmp(name, expected, sizeof(name))) {
+			dev_warn(&chip->dev,
+				 "kernel NV index has unexpected attributes, redefining\n");
+			rc = tpm2_kernel_nv_recreate(chip);
+			if (rc)
+				return rc;
+
+			return tpm2_kernel_nv_clear(chip);
+		}
+	}
+
+	rc = tpm2_kernel_nv_ensure_zero(chip);
+	if (rc > 0) {
+		/* auth value is not empty: the index was not defined by us */
+		dev_warn(&chip->dev,
+			 "kernel NV index cannot be written, redefining\n");
+		rc = tpm2_kernel_nv_recreate(chip);
+		if (rc)
+			return rc;
+
+		return tpm2_kernel_nv_clear(chip);
+	}
+
+	return rc;
+}
+
+/**
+ * tpm2_kernel_nv_provision() - ensure the kernel NV index is usable
+ * @chip:	the TPM chip
+ *
+ * Makes sure the kernel NV index exists with the expected public area and
+ * an empty auth value, and that it holds zero.  An index with an unexpected
+ * public area, or one that cannot be written with an empty auth value, is
+ * undefined and defined again.  The owner hierarchy must have an empty auth
+ * value.  If this fails and the index may still hold the magic value, the
+ * chip is marked so that userspace commands are refused.  The caller must
+ * hold the chip's ops lock.
+ *
+ * Return: 0 on success, -errno or a TPM error code on failure.
+ */
+int tpm2_kernel_nv_provision(struct tpm_chip *chip)
+{
+	int rc = __tpm2_kernel_nv_provision(chip);
+
+	tpm2_kernel_nv_update_dirty(chip,
+				    rc && tpm2_kernel_nv_may_hold_magic(chip));
+	return rc;
+}
+
+/**
+ * tpm2_kernel_nv_set_magic() - store the magic value in the kernel NV index
+ * @chip:	the TPM chip
+ *
+ * The caller must hold the chip's ops lock, and must call
+ * tpm2_kernel_nv_clear() before releasing it.
+ *
+ * Return: 0 on success, -errno or a TPM error code on failure.
+ */
+int tpm2_kernel_nv_set_magic(struct tpm_chip *chip)
+{
+	/* assume the worst until the index is known to be clear again */
+	chip->flags |= TPM_CHIP_FLAG_KERNEL_NV_DIRTY;
+
+	return tpm2_kernel_nv_write(chip, tpm2_kernel_nv_magic);
+}
+
+/**
+ * tpm2_kernel_nv_clear() - reset the kernel NV index to zero
+ * @chip:	the TPM chip
+ *
+ * If the index cannot be reset, it may still hold the magic value, so the
+ * chip is marked so that userspace commands are refused until a reset
+ * succeeds.  The caller must hold the chip's ops lock.
+ *
+ * Return: 0 on success, -errno or a TPM error code on failure.
+ */
+int tpm2_kernel_nv_clear(struct tpm_chip *chip)
+{
+	int rc;
+
+	rc = tpm2_kernel_nv_write(chip, tpm2_kernel_nv_zero);
+	tpm2_kernel_nv_update_dirty(chip,
+				    rc && tpm2_kernel_nv_may_hold_magic(chip));
+	return rc;
+}
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index d5a3320efe8b..35ba30a2674d 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -183,6 +183,7 @@ static inline enum tpm2_mso_type tpm2_handle_mso(u32 handle)
  * undefine or modify it.
  */
 #define TPM2_KERNEL_NV_INDEX	0x014c4853
+#define TPM2_KERNEL_NV_SIZE	8
 
 #define TPM_VID_INTEL    0x8086
 #define TPM_VID_WINBOND  0x1050
@@ -203,6 +204,8 @@ enum tpm_chip_flags {
 	TPM_CHIP_FLAG_HWRNG_DISABLED		= BIT(9),
 	TPM_CHIP_FLAG_DISABLE			= BIT(10),
 	TPM_CHIP_FLAG_SYNC			= BIT(11),
+	/* the kernel NV index may hold the magic value */
+	TPM_CHIP_FLAG_KERNEL_NV_DIRTY		= BIT(12),
 };
 
 #define to_tpm_chip(d) container_of(d, struct tpm_chip, dev)
diff --git a/include/linux/tpm_command.h b/include/linux/tpm_command.h
index c8e867d8bd4b..cef85f532b6c 100644
--- a/include/linux/tpm_command.h
+++ b/include/linux/tpm_command.h
@@ -203,6 +203,7 @@ enum tpm2_return_codes {
 	TPM2_RC_HANDLE		= 0x008B,
 	TPM2_RC_INTEGRITY	= 0x009F,
 	TPM2_RC_INITIALIZE	= 0x0100, /* RC_VER1 */
+	TPM2_RC_NV_UNINITIALIZED = 0x014A,
 	TPM2_RC_FAILURE		= 0x0101,
 	TPM2_RC_DISABLED	= 0x0120,
 	TPM2_RC_UPGRADE		= 0x012D,
-- 
2.43.0

