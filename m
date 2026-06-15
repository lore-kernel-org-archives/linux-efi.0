Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55215413635;
	Mon, 15 Jun 2026 16:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781539857; cv=none; b=LaXsMZPTBeA3YvPPFf6AV60BPH6WA0Lg32f3SWuq1SiO7lmimyXSQQWc69M1Ca+2nY+eLCAS/ghf9aN5jLnmkl6vlaMG1X15KtJeE4PuAOWwByPeeCyoKqjVFvxcl27HMV+952gPGIAYREgO7CZKtBEG0xlkcCCqLIsRGjup3p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781539857; c=relaxed/simple;
	bh=x3Z5z1vPWz0+SGUXLgSImcKZ5/DB7r5vdimwcwuJvH0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Xl4pfFNyL3PQweQ1XRIHD/CrxZGXvRIDh+S20Bq/AlGxC1NArzBSPOvH5osfzGS9S/fFjfip42OVrxoMGXKy/TLdsGI9pqPZsgQ5F3eP2UEVA7GlGT3FUVqWxzb08gQMziYlearcc8RkDrw+oqhS9LRrWChYgwZKZDJ44CIuhII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mAF0QrBn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mAF0QrBn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9AC41F000E9;
	Mon, 15 Jun 2026 16:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781539856;
	bh=0f3TEMAMyk1+FLZFDBGY9r+TZxNSD5gekrnqEHRaWOg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mAF0QrBngIMEqgQJcEJQl9z9Ih4RASbKxVV34FIA9W516TmM3tKEQP6jjjEIR9c1w
	 yz1CPh3UPw8LGu2UkwUsmBsNtZWORxq40FgTcM3JLRrXR049OEv+oyTRmu2O9df80e
	 qEvqz0WHfkTww8pvHREolPshGXrnkmygJZzNE0qOnZNalbhS3vji80Sp9UM0D8l6CO
	 40i+RIMoZbPPWuXbbEioTozRVhtl3M6YkH0gukF1vBQCWqzis77pg471am0JfLmCA4
	 W9NuF06woXlx8v0bhf8d51kaZO9mlZKIRXotH5Wz68OSvOzBxdhoT7ccHGBagtdg77
	 LjIkM0jG6kLjg==
From: Vincent Mailhol <mailhol@kernel.org>
Date: Mon, 15 Jun 2026 18:09:09 +0200
Subject: [PATCH 13/19] block: store GPT partition type UUID
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-discoverable-root_partitions-v1-13-39c78fac42e2@kernel.org>
References: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
In-Reply-To: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Davidlohr Bueso <dave@stgolabs.net>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-efi@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Vincent Mailhol <mailhol@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1421; i=mailhol@kernel.org;
 h=from:subject:message-id; bh=x3Z5z1vPWz0+SGUXLgSImcKZ5/DB7r5vdimwcwuJvH0=;
 b=owGbwMvMwCV2McXO4Xp97WbG02pJDFkGylcn3P0SdXhl6I5Ii1svL81Z+1D+irt0Emfhk3bmy
 c5v9zuzdUxkYRDjYrAUU2RZVs7JrdBR6B126K8lzBxWJpAh0iINDEDAwsCXm5hXaqRjpGeqbahn
 CGToGDFwcQrAVAt+ZWToND7FlzVzyVGdliUxR8OVHJYtMb4k2NxptP/jIZOg4rfSDH84LRwT15k
 pLY5qXMN6Vs/53VFVh5I43/2yN9vWn1hmsp0bAA==
X-Developer-Key: i=mailhol@kernel.org; a=openpgp;
 fpr=ED8F700574E67F20E574E8E2AB5FEB886DBB99C2

DPS [1] identifies OS partitions by GPT partition type UUID.

Keep that UUID in partition_meta_info and populate it while scanning EFI
partition tables so early root discovery can use it.

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
index 890128cdea1c..8ce85d21a1f4 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -67,6 +67,7 @@ extern const struct class block_class;
 
 struct partition_meta_info {
 	char uuid[PARTITION_META_INFO_UUIDLTH];
+	char type_uuid[PARTITION_META_INFO_UUIDLTH];
 	u8 volname[PARTITION_META_INFO_VOLNAMELTH];
 };
 

-- 
2.53.0

