Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC7D4183AF;
	Mon, 15 Jun 2026 16:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781539863; cv=none; b=HkTRI/ooiQo2NDrEPWAXY4CFmoX42C+La6EUZKaDPgJXZJ824bnmSF9znw+pvMNmv6DvsV+B8jYTsWRxyvk9j+03OMbERfxDlqBmo1b+b3NE7MrBjok3NVm1SnB9cUcLIWK+lybw/Rb2xY32FwCa+NxUQ+6+LrdgjY6EN5GwFUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781539863; c=relaxed/simple;
	bh=25gWMdmF9nDxLwlwrCJJIMp5jRMZc9tulja6mtfUQAs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kWlAoLtQpXIRhFiupJ7mNWY7NidlASHCUV+Uc8hsgDxaZvycf78l1Nivt7q2mz7qTsMS82YGrtubfGNKtuAcOqkJGSLIufXD+JwPrhJK0dpiJhiKEM+O0KV+7RKtWhEyWuBfN8GosksjbWVn48juhw68c7p+u8rUbo5RNOrM+Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P1i5rM4L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P1i5rM4L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94BCF1F000E9;
	Mon, 15 Jun 2026 16:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781539862;
	bh=xbX6gZ/IuLUevw9P8bZkeMn3+/y1sq7OU3e25KIff48=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=P1i5rM4LBcaypoGAqBxI04p9tDPrtRacMc6XWV90y7eUKN/HG4DvoZzKOrWCMOEyY
	 Jy5iJu6uwazJ2d23TaU/LM5BoGS/eNVS5ctrkxL6klxfvLIM0bgM7Es5ICoordQEIQ
	 xpFzEzr6kk96YxZ3FtcZ6x0drUvRxqtbaF8IEK/mS3LGGvc7TVe5yj+25eMN/MbsNS
	 y3j0ko+rqU8EUK351ON43tIanFBc17vEdefA+275SHZt4cHbbJC/uelRbQRU3ON4bv
	 jOIvLXevQTa4K0zGhmABgnPj9isPDKQ4EYFTdwSZsaVygE5Vfrmc41nqacZ2h8m4vq
	 pDaCh0DNLrWfw==
From: Vincent Mailhol <mailhol@kernel.org>
Date: Mon, 15 Jun 2026 18:09:11 +0200
Subject: [PATCH 15/19] block: store GPT attributes as a raw value
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-discoverable-root_partitions-v1-15-39c78fac42e2@kernel.org>
References: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
In-Reply-To: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Davidlohr Bueso <dave@stgolabs.net>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-efi@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Vincent Mailhol <mailhol@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1281; i=mailhol@kernel.org;
 h=from:subject:message-id; bh=25gWMdmF9nDxLwlwrCJJIMp5jRMZc9tulja6mtfUQAs=;
 b=owGbwMvMwCV2McXO4Xp97WbG02pJDFkGylfjr1VPWJxqVJ5bk1CouSstbINA7NptkmoBJk1rb
 rQda7LomMjCIMbFYCmmyLKsnJNboaPQO+zQX0uYOaxMIEOkRRoYgICFgS83Ma/USMdIz1TbUM8Q
 yNAxYuDiFICp/lvFyHBnV8enFcEx2Tt9Yta9ij3r9fST+vnzfa3ty5mzlIUS5aYy/Hf9n7d7V+I
 S97ulV+Yn9olKPq44e69tgdgn63juikbbLbwA
X-Developer-Key: i=mailhol@kernel.org; a=openpgp;
 fpr=ED8F700574E67F20E574E8E2AB5FEB886DBB99C2

struct _gpt_entry_attributes currently models the GPT partition entry
attributes field with bitfields. This is broken on machines using the
__BIG_ENDIAN_BITFIELD ABI because GPT always stores the attributes on
disk as a 64-bit little-endian.

No current code consumes individual fields from that structure. So just
remove struct _gpt_entry_attributes entirely and replace it by an __le64
value in struct _gpt_entry.

Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
---
 block/partitions/efi.h | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/block/partitions/efi.h b/block/partitions/efi.h
index 84b9f36b9e47..1f56f93b2804 100644
--- a/block/partitions/efi.h
+++ b/block/partitions/efi.h
@@ -75,18 +75,12 @@ typedef struct _gpt_header {
 	 */
 } __packed gpt_header;
 
-typedef struct _gpt_entry_attributes {
-	u64 required_to_function:1;
-	u64 reserved:47;
-        u64 type_guid_specific:16;
-} __packed gpt_entry_attributes;
-
 typedef struct _gpt_entry {
 	efi_guid_t partition_type_guid;
 	efi_guid_t unique_partition_guid;
 	__le64 starting_lba;
 	__le64 ending_lba;
-	gpt_entry_attributes attributes;
+	__le64 attributes;
 	__le16 partition_name[72/sizeof(__le16)];
 } __packed gpt_entry;
 

-- 
2.53.0

