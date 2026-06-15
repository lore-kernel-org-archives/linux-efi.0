Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C2A416CFC;
	Mon, 15 Jun 2026 16:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781539860; cv=none; b=seUSP5ugAnsZPn0IK756pvF9WkUYZEkPPODUF6w5TJFiQKppH5sOO+1U5BOkAjlvysCM3tMeV+V/Hio+r7FeKh0s3vY3YORMto4X4CE06PF3g1QaWZ9vArG4JUSIhZ+VEJQI8uwokcvBue5Y0tauRtvVBiHEP2KUU2/efVNjaoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781539860; c=relaxed/simple;
	bh=MBBf3ehSc0Fuqp13gO8W6qM3U/gVv2iczQdZ8HebfSQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=YSM/o6IYKTkhRGj2hvc1agAIehoBU31FGxx2QpPl1SaVQpPtdqSkUSjVsbTFmaNsjRvEIvvNZuIZrCzRVYwHCCwW5HEP8ysL3qhm3aKJipUlIvZjq+jzBvI70nC7PYHAk57g3CXl+BONJmDY/4wM3gkcysQ5m0ViOgd6Dm60txU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M1xK94Oi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M1xK94Oi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E5A1F00ACA;
	Mon, 15 Jun 2026 16:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781539859;
	bh=fZeKzeKXCaQwlAXaENJIs0wPmMYtqD5X9YZBSmtm0Ko=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=M1xK94OitzXTB6rwG3Xe91NUTwXruN6gPJyrxC06HD8QUX8X86Q8pk0LcH/L6qW9P
	 kCpqHDl8Akx3i7Vp5Vds4J1KF3th6t0R5laupfPYw7sgsjgORTMw+EQhtk/G5Z+3uu
	 mdPGYzi7FXXzYvPPKAg8LwnrzMy+bm8oWUumvigJp8LbZqA/qoVKih+4gDaYC+NMyW
	 UyCClsyZNyENr7o1smV+sBjz2LiQXf0uxWfNFvsQHNZsFpQVjp+OerKLS4K6sSIuPp
	 drDIKMmQFlECjXqjOTJY4xUFX0xNmUoxSCwOzlv/iKnqPEcG1TKdRA+UnljsQzzgIB
	 n1F4JbeTDjuUg==
From: Vincent Mailhol <mailhol@kernel.org>
Date: Mon, 15 Jun 2026 18:09:10 +0200
Subject: [PATCH 14/19] block: add early_lookup_bdev_by_type_uuid()
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-discoverable-root_partitions-v1-14-39c78fac42e2@kernel.org>
References: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
In-Reply-To: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Davidlohr Bueso <dave@stgolabs.net>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-efi@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Vincent Mailhol <mailhol@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=4863; i=mailhol@kernel.org;
 h=from:subject:message-id; bh=MBBf3ehSc0Fuqp13gO8W6qM3U/gVv2iczQdZ8HebfSQ=;
 b=owGbwMvMwCV2McXO4Xp97WbG02pJDFkGylc3bJwXfkNxOe8tYZnWK1MOrNkvHFJyNpBP8vUDU
 ecXuvlPOiayMIhxMViKKbIsK+fkVugo9A479NcSZg4rE8gQaZEGBiBgYeDLTcwrNdIx0jPVNtQz
 BDJ0jBi4OAVgqlPNGf6pG1eofmDyvangdH1SpUj681OXV/DWOR5R6nnBdynZipWR4X/FYfvJgVz
 3fj/JYTuzY33J9NTNS3fefuOpqMY2bffnyzGMAA==
X-Developer-Key: i=mailhol@kernel.org; a=openpgp;
 fpr=ED8F700574E67F20E574E8E2AB5FEB886DBB99C2

Add early_lookup_bdev_by_type_uuid() to find the root block device by
its GPT type UUID on the disk containing the active EFI System
Partition.

DPS [1] requires OS partition discovery to be limited to the disk
containing the active EFI System Partition. Reuse the existing block
class lookup and UUID matching callback to identify that disk, then do a
second lookup constrained to it. If the disk contains several partitions
with a matching type UUID, use the first match, following the DPS
discovery rule.

Extend struct uuidcmp with the new disk field so that it can be used in
the new match_dev_by_type_uuid() callback function.

Update devt_from_partuuid() to initialize cmp with a designated
initializer so that the new cmp.disk field is zero-initialized. This is
not strictly needed, but keeps the code cleaner.

[1] The Discoverable Partitions Specification (DPS)
Link: https://uapi-group.org/specifications/specs/discoverable_partitions_specification/

Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
---
 block/early-lookup.c   | 67 +++++++++++++++++++++++++++++++++++++++++++++++---
 include/linux/blkdev.h |  4 +++
 2 files changed, 68 insertions(+), 3 deletions(-)

diff --git a/block/early-lookup.c b/block/early-lookup.c
index 3fb57f7d2b12..cd10785e70ac 100644
--- a/block/early-lookup.c
+++ b/block/early-lookup.c
@@ -5,10 +5,12 @@
  */
 #include <linux/blkdev.h>
 #include <linux/ctype.h>
+#include <linux/uuid.h>
 
 struct uuidcmp {
 	const char *uuid;
 	int len;
+	struct gendisk *disk;
 };
 
 /**
@@ -45,13 +47,11 @@ static int __init match_dev_by_uuid(struct device *dev, const void *data)
  */
 static int __init devt_from_partuuid(const char *uuid_str, dev_t *devt)
 {
-	struct uuidcmp cmp;
+	struct uuidcmp cmp = { .uuid = uuid_str };
 	struct device *dev = NULL;
 	int offset = 0;
 	char *slash;
 
-	cmp.uuid = uuid_str;
-
 	slash = strchr(uuid_str, '/');
 	/* Check for optional partition number offset attributes. */
 	if (slash) {
@@ -252,6 +252,67 @@ int __init early_lookup_bdev(const char *name, dev_t *devt)
 	return devt_from_devnum(name, devt);
 }
 
+#ifdef CONFIG_DPS_ROOT_AUTO_DISCOVERY
+/**
+ * match_dev_by_type_uuid - callback for finding a partition using its type UUID
+ * @dev:	device passed in by the caller
+ * @data:	opaque pointer to the desired struct uuidcmp to match
+ *
+ * Returns: 1 if the device matches, and 0 otherwise.
+ */
+static int __init match_dev_by_type_uuid(struct device *dev, const void *data)
+{
+	struct block_device *bdev = dev_to_bdev(dev);
+	const struct uuidcmp *cmp = data;
+
+	return bdev->bd_disk == cmp->disk && bdev->bd_meta_info &&
+	       !strcasecmp(cmp->uuid, bdev->bd_meta_info->type_uuid);
+}
+
+/**
+ * early_lookup_bdev_by_type_uuid - look up a partition by its type UUID
+ * @type_uuid:		partition type UUID to search for
+ * @efi_partuuid:	partition UUID identifying the active EFI partition
+ * @devt:		matching dev_t result
+ *
+ * This helper follows the Discoverable Partitions Specification rules. It uses
+ * @efi_partuuid to find the disk containing the active EFI System Partition,
+ * then searches only partitions on that disk for the partition type UUID
+ * specified by @type_uuid.
+ *
+ * Returns: 0 on success or a negative error code on failure.
+ */
+int __init early_lookup_bdev_by_type_uuid(const char *type_uuid,
+					  const char *efi_partuuid, dev_t *devt)
+{
+	struct uuidcmp efi_cmp = {
+		.uuid = efi_partuuid,
+		.len = UUID_STRING_LEN,
+	};
+	struct uuidcmp type_cmp = {
+		.uuid = type_uuid,
+	};
+	struct device *efi_dev;
+	struct device *type_dev;
+
+	efi_dev = class_find_device(&block_class, NULL, &efi_cmp,
+				    &match_dev_by_uuid);
+	if (!efi_dev)
+		return -ENODEV;
+
+	type_cmp.disk = dev_to_disk(efi_dev);
+	type_dev = class_find_device(&block_class, NULL, &type_cmp,
+				     &match_dev_by_type_uuid);
+	put_device(efi_dev);
+	if (!type_dev)
+		return -ENODEV;
+
+	*devt = type_dev->devt;
+	put_device(type_dev);
+	return 0;
+}
+#endif
+
 static char __init *bdevt_str(dev_t devt, char *buf)
 {
 	if (MAJOR(devt) <= 0xff && MINOR(devt) <= 0xff) {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 8ce85d21a1f4..c2b7d07c92e7 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1800,6 +1800,10 @@ void sync_bdevs(bool wait);
 void bdev_statx(const struct path *path, struct kstat *stat, u32 request_mask);
 void printk_all_partitions(void);
 int __init early_lookup_bdev(const char *pathname, dev_t *dev);
+#ifdef CONFIG_DPS_ROOT_AUTO_DISCOVERY
+int __init early_lookup_bdev_by_type_uuid(const char *type_uuid,
+					  const char *efi_partuuid, dev_t *dev);
+#endif
 #else
 static inline void invalidate_bdev(struct block_device *bdev)
 {

-- 
2.53.0

