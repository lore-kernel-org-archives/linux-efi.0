Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793654988;
	b=2HPZpkhNZKcF7AsUia23E8CIHrPlqyDGPLD+iK7YOn9Eq8H/1RaIF/s1DYPvk9GAIzjm
	 oeaxHM6YwtZXCZmMM0qfzEBV+8tDpDpKArTpMTVwil9uCBdLNYqOD0hYocmgHsAvfreXB
	 Quju6Cz6duhUNhWtQUsaQiyRcBiDDH4/P9+gdtyWMEDP4DErlbuwwVX17thTAXsxGOwxa
	 UUY4PeEREkHH82zq+jOJo/y9RREVju2UDltkvnvlnCn0GFfGk0WC30U0pYlJBIjQNwEzK
	 2LsB03iWK0hsWIpEGActRNNm2pz6IjHuXEEXNmxaisgWdJJVmMTyyFPXIqDgQ4YeJvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793654988;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=iL0WXHPzfSDYj+2NNvJf3YEsbcQ4lzs85l94ET+86GM=;
	b=mE2F+ctyCEnaFPAbzgq7TiXg0t84ZUxMFpz96hyi7qzJGDPRw443a3Ra/zFJU+Y5EhJR
	 7Ess50OxzSeOfsRHLZ96SLXYNvsfC8K3A5b/wTcnoYRDY1z56bDpim/aGDXcCAim6icdb
	 GEMRvwf7gj97JG19itWriNG6H93TMALSHG4yRZRnYYdOwm6m6P/6+dzMDmswInr6Q902F
	 b65K9gdMQaqRuziOK53ECJ3yObm3yNPfu3v4mQ8QwP5DFEbI5sxihdSVUALcuJVtH5WCT
	 fWBpGomarzMzBNi4VCmuQyA5M/2LxZhR1dgN7h2KNmy/nfaJ9/PiC11zazh3OFGRXJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="L73xfRF/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103BE606D835;
	Mon,  2 Nov 2026 21:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L73xfRF/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43BB61F00A17;
	Mon,  2 Nov 2026 21:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793654987;
	bh=iL0WXHPzfSDYj+2NNvJf3YEsbcQ4lzs85l94ET+86GM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=L73xfRF/wcgMh0/wXCSR66SLKo3JPcyhiHDaw9m3GD6wi8/li+lNmEFV/ACGoFoYE
	 be9yxThzATISR2uD5UBSo8mjxH3W23XS3OVySFzTS/W3lrV+B1qH1U+5vqns5foHnF
	 JjxuM8YjhQxMhmwquwjKFJPVgSAUanMw7fW1Z7q9nhHNeGB6iFq9ubQqUeI+2Mpznu
	 FXBDAsytku3tUCWUjIps2lrhvYPgJhrCYjH5XXX93Phkzp9Av5be0X6/hjxBGMsumI
	 QFNjpzKQqVy/2+ScpEgNtzpxOtXV6T2VsbUX+uNZHz4npUyE4KfWL/asrhFMmvmV/g
	 Ktt2vI35FKvOQ==
From: Vincent Mailhol <mailhol@kernel.org>
Date: Mon, 02 Nov 2026 22:29:12 +0100
Subject: [PATCH v3 5/7] block: skip partitions with DPS no-auto GPT
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
Message-Id: <20261102-discoverable-root_partitions-v3-5-27f04b69b7ab@kernel.org>
References: <20261102-discoverable-root_partitions-v3-0-27f04b69b7ab@kernel.org>
In-Reply-To: <20261102-discoverable-root_partitions-v3-0-27f04b69b7ab@kernel.org>
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
 h=from:subject:message-id; bh=Yj6HfKP/i1Jap5YE+cXAWCTV9qeDS+8QPHbth9OyDkM=;
 b=owGbwMvMwCV2McXO4Xp97WbG02pJDFkvGTau2/j/c57FXrlqBn3rxuCCqgSl7M02d0L9s/6G8
 nOxMit0TGRhEONisBRTZFlWzsmt0FHoHXboryXMHFYmkCHSIg0MQMDCwJebmFdqpGOkZ6ptqGcI
 ZOgYMXBxCsBUf9Bl+B9bplT94J740SmLb9y9uDJ3yzwP9r91ZW4J/KHvDzRltVcz/DNfLi64eLd
 nq8jP89UzpqjuX2J5YtvBr+c2abyqcj2r+osFAA==
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
index e3da4bfb41e7..c59d14889fee 100644
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
index 5cfef05b552e..fd6d809189e8 100644
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
2.56.0

