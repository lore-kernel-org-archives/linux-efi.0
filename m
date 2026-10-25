Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792933446;
	b=FIjrUGdC69wBvjQ7SOZ3ZmSrLMhzFcOFpgLrt7S3rU9ewbJvAeoUan72g9PPBgiIttkf
	 jWvBJ0F0mb+eQMtL1XT5ju+RrxP8Z5f3ACFbrtlqe9bcCbpAcLqvKpSg6IZRNxoNsdMDA
	 l3h7sC76yFjDo+hxjDNOTsVjMKToESNwjFU2MFe6hIJ0WG86C5CGgCh8aTmUkHxUMBDzY
	 x2b2wjyI1rREw1XBRvHwIir4L9+KNh0hNQFeoyfXVdqEJ8bKL2JWF/JvlMx7P3pCP9G/3
	 eqzbD2GU8+cQscbQjdqVmHMMnRPEf876gdCuXKxL7ScwMQ6UNh9wIlrz3c1qtRK1Qsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792933446;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=//uaP1WFxO5u5Vpx8JSOFowIBO0whCKSAp0wSvlyerY=;
	b=l/uHYvi6/ROn4GqpCgxoYiyxeMgRUbEDdc2t5W7D6LTz5jk3yftygdg9rdd3tF6JaguA
	 lD0gc9dN9S8RmXSNQW/YTlpdO2OSo8Hvxwk5tiLj/a7AgDBohHf+fxyXNSsAmg/0HKNa5
	 M0Uapck0IQgbPVyveOJHaxClI5hrNkpBufxYv0mJr2ou2p/kpknnoojQqS9wy86uvRR3U
	 kHPGiiFKE8S0TQbLcXaYin+JkWlktv0J1GwV8uXlc7h4zqkbPCSAbedZTLo8NrM+EMk3H
	 Xk64tMRPilMC8oJKrbAsfxs6iewyM9QLvs10gUCG67y8VyzjMguEO8l6Vbku4Agc3Ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OgCMn7lv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532A2606A321;
	Sun, 25 Oct 2026 13:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OgCMn7lv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B5FF1F01828;
	Sun, 25 Oct 2026 13:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792933445;
	bh=//uaP1WFxO5u5Vpx8JSOFowIBO0whCKSAp0wSvlyerY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OgCMn7lvjJjXCk/mV6dmgiGrUWUULHjjJlbO7/8Ay7ZYANqjW2muVIYLXU1BVGtN9
	 ZV63zBEVp19NuypnZBaTDyqIyNkRoTKzj5goepU+y7SNtLwzj+upyOXC9iS66w7y3G
	 ZtQP+fGRfQMAcLjp9PIPBsYhAXWke5NzRONFPMe1Okyft+kJjy7vM7iK2A2kWRX3Gq
	 FqQp3oCuFRSBA7wkR+jHrzYKniqfyaGNhaQF7kf7LADB05wgUVlGhBWNuQ1mDBfOXf
	 5zVy5AikuJGy0pHoI/hIHBmcjN4PGXQej2c3uBuiMu3yuTrhczpBa8vwFuqJQMmfXB
	 kTzroLU6XP8zQ==
From: Vincent Mailhol <mailhol@kernel.org>
Date: Sun, 25 Oct 2026 14:03:11 +0100
Subject: [PATCH v2 1/7] block: store GPT partition type UUID
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
Message-Id: <20261025-discoverable-root_partitions-v2-1-fb77d0821fab@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1428; i=mailhol@kernel.org;
 h=from:subject:message-id; bh=56q8LlYKMAEsowAI1SuYakZ1PjWTf/maPadyXzq/xW4=;
 b=owGbwMvMwCV2McXO4Xp97WbG02pJDFl3/9lk8MqzHuqwnMKscKSdxeS7kDeLOPvOLQuzGfSuR
 Vu7u/t2TGRhEONisBRTZFlWzsmt0FHoHXboryXMHFYmkCHSIg0MQMDCwJebmFdqpGOkZ6ptqGcI
 ZOgYMXBxCsBUW7sz/M/ZEVOwKF54nSb7/hj9/VcPPH4bH5h++2x8w5qTv/SNbO8yMhwN8nlbX1q
 der9S3rBqw03he5ZXcl+dd7lg3NKyQ6LgHjsA
X-Developer-Key: i=mailhol@kernel.org; a=openpgp;
 fpr=ED8F700574E67F20E574E8E2AB5FEB886DBB99C2

DPS [1] identifies OS partitions by GPT partition type UUID.

Keep that UUID in struct partition_meta_info and populate it while
scanning GPT partition tables so early root discovery can use it.

[1] The Discoverable Partitions Specification (DPS)
Link: https://uapi-group.org/specifications/specs/discoverable_partitions_specification/

Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
---
 block/partitions/efi.c | 1 +
 include/linux/blkdev.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/block/partitions/efi.c b/block/partitions/efi.c
index 9865d59093fa..4a3835ed9561 100644
--- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -742,6 +742,7 @@ int efi_partition(struct parsed_partitions *state)
 
 		info = &state->parts[i + 1].info;
 		efi_guid_to_str(&ptes[i].unique_partition_guid, info->uuid);
+		efi_guid_to_str(&ptes[i].partition_type_guid, info->type_uuid);
 
 		/* Naively convert UTF16-LE to 7 bits. */
 		label_max = min(ARRAY_SIZE(info->volname) - 1,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d003a9d2d1f6..b99a59cd1120 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -67,6 +67,7 @@ extern const struct class block_class;
 
 struct partition_meta_info {
 	char uuid[PARTITION_META_INFO_UUIDLTH];
+	char type_uuid[PARTITION_META_INFO_UUIDLTH];
 	u8 volname[PARTITION_META_INFO_VOLNAMELTH];
 };
 

-- 
2.55.0

