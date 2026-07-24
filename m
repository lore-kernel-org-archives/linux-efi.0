Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78DF402B99;
	Fri, 24 Jul 2026 18:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784916989; cv=none; b=VYFtqOWSFQ59eB03oDXVuSoA7D3ExZJZd1DjtjEVXRQQoosUzmTbNur9m8Ot0ar3LrQQW6MLmCMur4H26pD1ivbtte9Rt0PJliTVzQijoHtM5x16HqG7j3JJDrrY82y2ZEih2qhR+Lzdx2dzXjrKQELM0mSzyXZv8LS79mf3x4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784916989; c=relaxed/simple;
	bh=YBNUPhK+dSG8Rj+GgFl/0zrJ57AbV8JvJot3uj9k1OU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=b8FeexzAdOYPt9/7KzXkbdbZ1oOjat6H2k2BYg23+Ubxknlo+8KB2GAOVZlVuGq4I10w1qOTnxuG9X1Pz6HgFwd20qvn9x9fOZjblzfFeYtD9MJYw7TtKnD3ohRIKMfQH76bytPd5nJaaR3si6fnFQNdHV4PbJ7qSo5yKzovPgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AUqbyAnm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AUqbyAnm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4EA1F000E9;
	Fri, 24 Jul 2026 18:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784916985;
	bh=7cgAipI1fCRs+j94B3V9v2XQIDOdhYQSv7FLrs5JCAY=;
	h=From:Date:Subject:To:Cc;
	b=AUqbyAnmDGUatPGQMxkwrbiu1ATsGLQdktzmC3PHqH3AiLMcL9lTLmDYcmFjvCsxX
	 cVTN6Wvl/Zc3hkDuj94KNf8HRm5aW8vbWEpsocwutGck7Leuz1bXKDaKl7FZ2veQ1w
	 gs/illBPOV3R6oFGjTuCqR9qtCal1zNswOBLP2bPe6GtmjfDSXqARO8q38SYw5Z3QN
	 aOwuU3JAz7GhHA5qE9DPwIr/ce5Ld8tffwybafToOMwajpZZNGH9PUPEpzQMpA4dvv
	 /Xdnxd3+8BHIrtmGdiQ4u8PpSAtMu7sTmQ31Hrx8bbXDtG3idLCWcPHFqBEiCBd5eN
	 jpaj8f+ERLG8w==
From: Vincent Mailhol <mailhol@kernel.org>
Date: Fri, 24 Jul 2026 20:15:58 +0200
Subject: [PATCH] block: store GPT attributes as a raw value
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260724-fix_gpt_entry_attributes-v1-1-eca37d728dec@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2MwQqDMBAFf0X2bCAGW9v+ikiI9ql7SWWziiL+u
 6HHgZk5KUEYiT7FSYKNE/9ihqosaJhDnGD4m5mcdU/buNqMvPtpUY+ocvigKtyvimTwCOMb9mU
 HVJTzRZDd/7rtrusGkrwYBmoAAAA=
X-Change-ID: 20260724-fix_gpt_entry_attributes-e5af9e080ce1
To: Davidlohr Bueso <dave@stgolabs.net>, Jens Axboe <axboe@kernel.dk>
Cc: linux-efi@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Vincent Mailhol <mailhol@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1540; i=mailhol@kernel.org;
 h=from:subject:message-id; bh=YBNUPhK+dSG8Rj+GgFl/0zrJ57AbV8JvJot3uj9k1OU=;
 b=owGbwMvMwCV2McXO4Xp97WbG02pJDFnJq7/c4NFdFRP82DPgbuuKaj6lv++ta4+ttn7vemH2Y
 g+TaX7pHRNZGMS4GCzFFFmWlXNyK3QUeocd+msJM4eVCWSItEgDAxCwMPDlJuaVGukY6ZlqG+oZ
 Ahk6RgxcnAIw1QbXGP7n6yU+T1zU/6zI/FhajrTe0cV6+pz3c053bmG9/mdTl0QzI8Pc/ef+zDh
 VvyQ85kvxicuX/81P13C/qc41y+/klDmnCkX5AA==
X-Developer-Key: i=mailhol@kernel.org; a=openpgp;
 fpr=ED8F700574E67F20E574E8E2AB5FEB886DBB99C2

struct _gpt_entry_attributes currently models the GPT partition entry
attributes field with bitfields. This is broken on machines using the
__BIG_ENDIAN_BITFIELD ABI because GPT always stores the attributes on
disk as a 64-bit little-endian.

No current code consumes individual fields from that structure. So just
remove struct _gpt_entry_attributes entirely and replace it by an __le64
value in struct _gpt_entry instead. This lets users apply endian-aware
masks explicitly when inspecting attribute bits.

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
 

---
base-commit: 1590cf0329716306e948a8fc29f1d3ee87d3989f
change-id: 20260724-fix_gpt_entry_attributes-e5af9e080ce1

Best regards,
-- 
Vincent Mailhol <mailhol@kernel.org>

