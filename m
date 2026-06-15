Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135714183B7;
	Mon, 15 Jun 2026 16:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781539866; cv=none; b=M2WoXl0q2WUfKmYzSlGS1sXU792pSrdK7SHr+fv2hdA3cNSoSg4ZEUmfcbe1iVEI7CcfK4R+Thd26joWcgOHF7KIwKwSSWhNOewuEz75vQfTEo2ZD5HhtAbdcM+QDf+jb0jnycMpy+IHwnH1D3PPleUZ0EUurmbC7vcJ+7ni2pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781539866; c=relaxed/simple;
	bh=+Nk4i4Q1Xvz/QTm+hsuVMlLwcxmHi7Wvil+zSXloNxE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=RJmlaHE4uW7TQQEH7OkRmCoNZ2Gqb1pWJzP4f/ZPr3MZRWF2J0/qDo6XTEvpuwgon71Fz9u4iPX2Kb25QIqjuqWLpjWl8RJFZDJwqFby1eMYGSET31JIoUQebrci8DBd/eeZs8cqpeTAr4sCqD5N4hfjxKpwsQXyyNdPtdnORbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Af7PcG7y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Af7PcG7y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70AFA1F00A3A;
	Mon, 15 Jun 2026 16:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781539865;
	bh=kYKvuWP/wOPMFGmSVWbRhIbxOzsCFL8d1vepCyjY8iY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Af7PcG7yWRoGpmbXaCVusXrGGeGCKcbbdH0x6uU3p/QCilZUo1N8oThybpG6zpEFX
	 c15gqV0Frp3bwp810cPHcgGd0naEMzS9g9XdVTnRX5t55oH5M656X/O45IqWozGEDB
	 S2IznHDIEobTSEGgkYXyguCvs/aYpfEjx2dU6Qqe+f70HFCWaE6oWvo32cHWb6X4Wt
	 afgctDdV4QgEKvSp8D9ekbRHgWB5ToeMHY4nPdmRoqc7+ZnM4A4RoVrTo4IbbJoFcM
	 Mn5AnV6YuTES2LtnJWXQFcfE60NpS2EXO4JdCb25azq5P1x/fQWN4dusJ8FPvSYqIo
	 lYX6KLDriSQQw==
From: Vincent Mailhol <mailhol@kernel.org>
Date: Mon, 15 Jun 2026 18:09:12 +0200
Subject: [PATCH 16/19] block: don't discover partition with DPS no-auto GPT
 attribute
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-discoverable-root_partitions-v1-16-39c78fac42e2@kernel.org>
References: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
In-Reply-To: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Davidlohr Bueso <dave@stgolabs.net>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-efi@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Vincent Mailhol <mailhol@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=4175; i=mailhol@kernel.org;
 h=from:subject:message-id; bh=+Nk4i4Q1Xvz/QTm+hsuVMlLwcxmHi7Wvil+zSXloNxE=;
 b=owGbwMvMwCV2McXO4Xp97WbG02pJDFkGyldXT9mmUmN1Nr7uXYulrp1ckIzv4rhdnTJvktV2/
 P5pzhHcMZGFQYyLwVJMkWVZOSe3Qkehd9ihv5Ywc1iZQIZIizQwAAELA19uYl6pkY6Rnqm2oZ4h
 kKFjxMDFKQBTXSvMyLDUL3fLreM56y74q6vUs2T1vYmMKY/c2vC+OulYOft1PSWG/3lFLq598t2
 Se9b3phzPeZIl7ZcosndpTzL3ndlL63rzGAA=
X-Developer-Key: i=mailhol@kernel.org; a=openpgp;
 fpr=ED8F700574E67F20E574E8E2AB5FEB886DBB99C2

DPS [1] defines GPT attribute bit 63 as no-auto. Partitions with this
bit set must not be used by automatic discovery.

Add the new GPT_ATTRIBUTE_NO_AUTO flag to designate the GPT attribute
bit 63.

Add the new ADDPART_FLAG_NO_AUTO flag and set it when
GPT_ATTRIBUTE_NO_AUTO is set during the partition scan. Then, propagate
it to the new BD_NO_AUTO_DISCOVERY flag.

Finally, add a condition to match_dev_by_type_uuid() to exclude any
partition with that flag from the automatic discovery.

[1] The Discoverable Partitions Specification (DPS)
Link: https://uapi-group.org/specifications/specs/discoverable_partitions_specification/

Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
---
 block/blk.h               | 1 +
 block/early-lookup.c      | 1 +
 block/partitions/core.c   | 2 ++
 block/partitions/efi.c    | 2 ++
 block/partitions/efi.h    | 3 +++
 include/linux/blk_types.h | 1 +
 6 files changed, 10 insertions(+)

diff --git a/block/blk.h b/block/blk.h
index b998a7761faf..14e0f349ff14 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -604,6 +604,7 @@ void blk_free_ext_minor(unsigned int minor);
 #define ADDPART_FLAG_RAID	1
 #define ADDPART_FLAG_WHOLEDISK	2
 #define ADDPART_FLAG_READONLY	4
+#define ADDPART_FLAG_NO_AUTO	8
 int bdev_add_partition(struct gendisk *disk, int partno, sector_t start,
 		sector_t length);
 int bdev_del_partition(struct gendisk *disk, int partno);
diff --git a/block/early-lookup.c b/block/early-lookup.c
index cd10785e70ac..8db0abec141e 100644
--- a/block/early-lookup.c
+++ b/block/early-lookup.c
@@ -266,6 +266,7 @@ static int __init match_dev_by_type_uuid(struct device *dev, const void *data)
 	const struct uuidcmp *cmp = data;
 
 	return bdev->bd_disk == cmp->disk && bdev->bd_meta_info &&
+	       !bdev_test_flag(bdev, BD_NO_AUTO_DISCOVERY) &&
 	       !strcasecmp(cmp->uuid, bdev->bd_meta_info->type_uuid);
 }
 
diff --git a/block/partitions/core.c b/block/partitions/core.c
index 5d5332ce586b..4529ea1d308e 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -382,6 +382,8 @@ static struct block_device *add_partition(struct gendisk *disk, int partno,
 
 	if (flags & ADDPART_FLAG_READONLY)
 		bdev_set_flag(bdev, BD_READ_ONLY);
+	if (flags & ADDPART_FLAG_NO_AUTO)
+		bdev_set_flag(bdev, BD_NO_AUTO_DISCOVERY);
 
 	/* everything is up and running, commence */
 	err = xa_insert(&disk->part_tbl, partno, bdev, GFP_KERNEL);
diff --git a/block/partitions/efi.c b/block/partitions/efi.c
index 4a3835ed9561..50c21625e256 100644
--- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -739,6 +739,8 @@ int efi_partition(struct parsed_partitions *state)
 		/* If this is a RAID volume, tell md */
 		if (!efi_guidcmp(ptes[i].partition_type_guid, PARTITION_LINUX_RAID_GUID))
 			state->parts[i + 1].flags = ADDPART_FLAG_RAID;
+		if (le64_to_cpu(ptes[i].attributes) & GPT_ATTRIBUTE_NO_AUTO)
+			state->parts[i + 1].flags |= ADDPART_FLAG_NO_AUTO;
 
 		info = &state->parts[i + 1].info;
 		efi_guid_to_str(&ptes[i].unique_partition_guid, info->uuid);
diff --git a/block/partitions/efi.h b/block/partitions/efi.h
index 1f56f93b2804..fb50edb66e84 100644
--- a/block/partitions/efi.h
+++ b/block/partitions/efi.h
@@ -11,6 +11,7 @@
 #ifndef FS_PART_EFI_H_INCLUDED
 #define FS_PART_EFI_H_INCLUDED
 
+#include <linux/bits.h>
 #include <linux/types.h>
 #include <linux/fs.h>
 #include <linux/kernel.h>
@@ -30,6 +31,8 @@
 #define GPT_HEADER_REVISION_V1 0x00010000
 #define GPT_PRIMARY_PARTITION_TABLE_LBA 1
 
+#define GPT_ATTRIBUTE_NO_AUTO BIT_U64(63)
+
 #define PARTITION_SYSTEM_GUID \
     EFI_GUID( 0xC12A7328, 0xF81F, 0x11d2, \
               0xBA, 0x4B, 0x00, 0xA0, 0xC9, 0x3E, 0xC9, 0x3B) 
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 8808ee76e73c..c6cdc99b0490 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -54,6 +54,7 @@ struct block_device {
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 #define BD_MAKE_IT_FAIL		(1u<<12)
 #endif
+#define BD_NO_AUTO_DISCOVERY	(1u<<13)
 	dev_t			bd_dev;
 	struct address_space	*bd_mapping;	/* page cache */
 

-- 
2.53.0

