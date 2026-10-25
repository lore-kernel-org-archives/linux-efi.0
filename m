Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792933463;
	b=QNV44zgO+uCW27Zt5ej5Ax4qIzhiBGfj81mpnp4AbCUJFKoDtbaTBlRyHbhtPNhrlsFi
	 co4gW/zo5r16b9OeKdJ8OXoYI0b/lU3+XeNkIOTD1an0WImeGlNmwKYqsv3tUeiHiaQjX
	 ItUTSwP4qCLlbfovZVZYFj2dq+1XdjoH9YW8Q5GAuDJDAIMdEqR14C6pXhKQZtUUvUhwr
	 vUHVabLk9M6jg6MTkvBtudiVdKCSMd+MkeLdlwCYNMDHE6u2k6g5HZ1kcar57fXMtyj+/
	 bi9xokyKZ9RqZ3sDNGmzJ+r8womD3wr7R91YeL4XjyGND2YAKj3pl089EplrGpQNLDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792933463;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=mGVlQYzpgXJPEbDsPzTMIi1todBaCnbXnWt8lDKTTk8=;
	b=1ZOkLxLqMuBOIPi90Y7EFVUp+Nrn+oEOrhh6mh9EBf/TYaMr9bblyYyS7cfah9hyfcmu
	 STL1eLqfcGehY5JXP1FzMBVnQxL9AdaXolsNEJZgcFjHlQ6hxqZEVMXQAUX9SaLjLwWnp
	 aqjAzgYCGPw6FfRMvjcFMiIX3OQzM1b01UmlCmzMYBlSe32MrMFzcPs1677kFIZ9yPSIn
	 Un38zWyFc93AECjFAK3jabRYrT50f21LD7l+kF3vo/4349/OmWgZTmNo1djPnYmr3qskg
	 t6Mi/1mpa879d4qcpBLGKzpeYF3Br/BL+CLF+8ntDhQ4neyOSGkZrLCfz3L6QE10Sew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RoRZYwRE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B189A606A324;
	Sun, 25 Oct 2026 13:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RoRZYwRE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF3C51F01825;
	Sun, 25 Oct 2026 13:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792933462;
	bh=mGVlQYzpgXJPEbDsPzTMIi1todBaCnbXnWt8lDKTTk8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RoRZYwREUvL8RkgIkfZJ/uYOc3MggXH2vil1Ytzw5LgjNrY4VNFgBv6u5xeu2FafO
	 LsXAym/uzwmPThnEPT+ItGuCiViCfJfwIeNI6Fgm9zlR1tuomHCGxpL6qppoel0auS
	 Bd1Pl7fNM85MRaUZ2ILE+maxxmuju7FZzrzLknlQzYaA27eF4uvWRKe2kr9eHcSf0F
	 qU2O3lEAv6grwiB0i5ufrftDx5z220WevQYSuLVDpd56560IuKBnEPU0yfM4jZMa0E
	 R+EeXy7yWEL/nMogVm0Ph6tgvLQOpSjxFgwb/FVFdMMMrrdksUfiw/sL+9WuxErTcn
	 XkbcRBFS0yL7A==
From: Vincent Mailhol <mailhol@kernel.org>
Date: Sun, 25 Oct 2026 14:03:15 +0100
Subject: [PATCH v2 5/7] block: skip partitions with DPS no-auto GPT
 attribute
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261025-discoverable-root_partitions-v2-5-fb77d0821fab@kernel.org>
References: <20261025-discoverable-root_partitions-v2-0-fb77d0821fab@kernel.org>
In-Reply-To: <20261025-discoverable-root_partitions-v2-0-fb77d0821fab@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Davidlohr Bueso <dave@stgolabs.net>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-efi@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Dave Hansen <dave.hansen@intel.com>, 
 James Bottomley <James.Bottomley@HansenPartnership.com>, 
 Helge Deller <deller@gmx.de>, Matthew Wilcox <willy@infradead.org>, 
 Vincent Mailhol <mailhol@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2347; i=mailhol@kernel.org;
 h=from:subject:message-id; bh=BgyjQQyr8g/odX8GGZbNyc4sQht2nRYi6b3mE76ilOg=;
 b=owGbwMvMwCV2McXO4Xp97WbG02pJDFl3/9msD7p8JPaISen8lMWs7EEvc5bZRi9ac3jS9s0Ph
 Jy6Ve/Kd0xkYRDjYrAUU2RZVs7JrdBR6B126K8lzBxWJpAh0iINDEDAwsCXm5hXaqRjpGeqbahn
 CGToGDFwcQrAVHs+YGSY4jPvxPr8ObdeB/grhx+pify+qkrFdXEs52SZBTL26/o+MPx3nV/28aK
 853qWZ9/qXk83iC9s2Rq0rvZrXWhzm5/r+u28AA==
X-Developer-Key: i=mailhol@kernel.org; a=openpgp;
 fpr=ED8F700574E67F20E574E8E2AB5FEB886DBB99C2

DPS [1] defines GPT attribute bit 63 as no-auto. Partitions with this
bit set must not be used by automatic discovery.

Store the GPT attributes in partition_meta_info and check
GPT_ATTR_NO_AUTO_DISCOVERY when matching a root partition by type UUID.

[1] The Discoverable Partitions Specification (DPS)
Link: https://uapi-group.org/specifications/specs/discoverable_partitions_specification/

Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
---
 block/early-lookup.c   | 1 +
 block/partitions/efi.c | 1 +
 include/linux/blkdev.h | 4 ++++
 3 files changed, 6 insertions(+)

diff --git a/block/early-lookup.c b/block/early-lookup.c
index a1cb67eab4a0..6c9664eeeb1b 100644
--- a/block/early-lookup.c
+++ b/block/early-lookup.c
@@ -261,6 +261,7 @@ static int __init match_dev_by_type_uuid(struct device *dev, const void *data)
 	const struct uuidcmp *cmp = data;
 
 	return bdev->bd_disk == cmp->disk && bdev->bd_meta_info &&
+		!(bdev->bd_meta_info->gpt_attr & GPT_ATTR_NO_AUTO_DISCOVERY) &&
 		!strcasecmp(cmp->uuid, bdev->bd_meta_info->type_uuid);
 }
 
diff --git a/block/partitions/efi.c b/block/partitions/efi.c
index 4a3835ed9561..ed5e2f21ad85 100644
--- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -741,6 +741,7 @@ int efi_partition(struct parsed_partitions *state)
 			state->parts[i + 1].flags = ADDPART_FLAG_RAID;
 
 		info = &state->parts[i + 1].info;
+		info->gpt_attr = le64_to_cpu(ptes[i].attributes);
 		efi_guid_to_str(&ptes[i].unique_partition_guid, info->uuid);
 		efi_guid_to_str(&ptes[i].partition_type_guid, info->type_uuid);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 52bd5683da77..629ddf1b8b7a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -5,6 +5,7 @@
 #ifndef _LINUX_BLKDEV_H
 #define _LINUX_BLKDEV_H
 
+#include <linux/bits.h>
 #include <linux/types.h>
 #include <linux/blk_types.h>
 #include <linux/blk_plug.h>
@@ -65,10 +66,13 @@ extern const struct class block_class;
  */
 #define PARTITION_META_INFO_UUIDLTH	(UUID_STRING_LEN + 1)
 
+#define GPT_ATTR_NO_AUTO_DISCOVERY	BIT_U64(63)
+
 struct partition_meta_info {
 	char uuid[PARTITION_META_INFO_UUIDLTH];
 	char type_uuid[PARTITION_META_INFO_UUIDLTH];
 	u8 volname[PARTITION_META_INFO_VOLNAMELTH];
+	u64 gpt_attr;
 };
 
 /**

-- 
2.55.0

