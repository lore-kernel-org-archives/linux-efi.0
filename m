Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793654971;
	b=A4NXyfXh+tn4LXcfZ3zLOJ1POXIfXoMQAM71Ydzmn+AJq857m0O2OuImW4fjDtz2nsju
	 4iwb188ymrwkam17surB+VOI++2jM+PvsZMbE43ZZHVmfnGL27OUamL4qyi/7nPenYb/8
	 cISJFzNUE6E+UzXOJLAVM64C3/2XcgQj4Gbb+RTdEwwZ/HUb/O9Aw/KgWFipbOIVNUBne
	 HhP/FJFaFNNLHBggtzF+wFoUaAd/KdFYGz7HiGtCWZtHROd2JakKcDCDFdek+F5c/83uw
	 LakEuCHFFdg99IcHM7NR2fsU7xvh7wRqlnqpLrfR9F8LGdyEkkkLWB93a8UZ/Yy4rXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793654971;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=dcWLXpaNV2JhqvlrEnfLP7jgKO1/sog2NIrFUicv56c=;
	b=3PtDuy5ClkglpZJLTMc2TT5hPCzw6WwGljyu7F5jWODPd6BcnIl4qxNhqnNskejcy34j
	 rwZF395EW5WdLn8btjmUzchNbU0sFnNqZuuaV6RgzHArGQcjO5lkY5VpGvXZw3QhhyPdx
	 tvQCQBFoGnoLSibnupjHuy8IV50vLXdxtgBQ7dPzyYVSgWT2Kt4QBblrmk0/j/IX3xo2l
	 lD1Qn8UzJQ/XQsbmwlz4vjYzBN16RSAyUoPp95AUKuVc028OHJxxXtLAjTIDt3fCoob6J
	 PU+ePPYemG/e/aCcFLKcohtOhlJxudOU5SSXoDk45CXOwVMU9Iet0KY82JlmTwgi2lQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A5RrK9D9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96580606A32C;
	Mon,  2 Nov 2026 21:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A5RrK9D9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89E181F00A17;
	Mon,  2 Nov 2026 21:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793654971;
	bh=dcWLXpaNV2JhqvlrEnfLP7jgKO1/sog2NIrFUicv56c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=A5RrK9D9ByaxZ2uVPxfRxEa2X/zufQllris0Sl1XGKydOpqGUTws8E5Gpw3TyGttJ
	 PKnvbkhE6fuHLFY6As+XRnVGKUNYCLb5615aL/eFHTJLIYaIkweoZ3D8zxwNM17tO/
	 ZPJ6rYHPOy/D+PP0nyW0QjL9SDeFmOf+1lGvpbQhN1+HQmW2alX+N8tdOZAxOCvZbk
	 POXF5BEcqduQIuVgfRjJQhz8mlOzYj4OSKV0CGJGpI+lQXASQ008lTsELNgiN15oqH
	 4lUSb9bDq5VRVwSAP/Gz52JWAfiyCn8CHw4K6Y+RBiUNfkIZUe7pykDas48rpX2Vcv
	 KcMPn2Kl/w8mg==
From: Vincent Mailhol <mailhol@kernel.org>
Date: Mon, 02 Nov 2026 22:29:08 +0100
Subject: [PATCH v3 1/7] block: store GPT partition type UUID
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
Message-Id: <20261102-discoverable-root_partitions-v3-1-27f04b69b7ab@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1428; i=mailhol@kernel.org;
 h=from:subject:message-id; bh=zHJaJ3biSybyW4bT4rUFlc5rC+iYKQjhDtfQVSfv2+E=;
 b=owGbwMvMwCV2McXO4Xp97WbG02pJDFkvGTYeerw5Y2P9N+a2aYELpnrlv/ijFB1s7+hUl/jqZ
 tSZrmlSHRNZGMS4GCzFFFmWlXNyK3QUeocd+msJM4eVCWSItEgDAxCwMPDlJuaVGukY6ZlqG+oZ
 Ahk6RgxcnAIw1ZtqGf4HpvyNjmfUPlA09/yviq1uwvUMYd/9XtjUGr/xOCu7tGI5I8O7n1Ec7Q1
 cvxquhmw/6n9O2VZm++FzN+YcF+w5lRLXW8IDAA==
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
index 0c2010230632..0e0f5d68425d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -67,6 +67,7 @@ extern const struct class block_class;
 
 struct partition_meta_info {
 	char uuid[PARTITION_META_INFO_UUIDLTH];
+	char type_uuid[PARTITION_META_INFO_UUIDLTH];
 	u8 volname[PARTITION_META_INFO_VOLNAMELTH];
 };
 

-- 
2.56.0

