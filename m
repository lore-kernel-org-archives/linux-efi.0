Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71CE635C180;
	Tue,  8 Sep 2026 18:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788893931; cv=none; b=i5WEeE/wK+a5MrmyAui2Hsida4ssYDzOcaZTAhgo04oZhv1LBVqpAzpyL42HAIh32k7dxJZVtMVQLYOHinX8+6t4jsqWMt2kJcqsjgno4z2Zk4I40740XE/2uA4Cwue/ENfu7PuhV7y6zhL+mTeV6eOFipuq2yDi2s+60L0ljkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788893931; c=relaxed/simple;
	bh=YBNUPhK+dSG8Rj+GgFl/0zrJ57AbV8JvJot3uj9k1OU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=GiN5c4X9x/7K46mUofNwp7bd1Vxh+tpGciVdELPXWlF6+h0fhawvp7TPY3VmWq96e3+tMOqzNZlfw/2zR9xl7mXM9pcXi/5xn+9TTj7AZz4WuY4218s/++OGMkjh6KT1NMK0Bw9qlbozLDEvvPIl1Kd8Rm5kHJF0GCXIrA3mDYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JhnzMcGd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JhnzMcGd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9229F1F00A3A;
	Tue,  8 Sep 2026 18:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788893930;
	bh=7cgAipI1fCRs+j94B3V9v2XQIDOdhYQSv7FLrs5JCAY=;
	h=From:Date:Subject:To:Cc;
	b=JhnzMcGdo5B88I00ke3UkNQOidATxO+8bKtleRggm9yHIQlT7LKi0GwEqqTQgIuIL
	 R27ZPKyuSXLv9IavHDkQT3t/KtWSTqsNIP1EF8PZFnrXiGDWfDAtEcpy0EYI0ThjNK
	 UFZ76y18WiCVlz747GuC4UVuGmwChjWNO7ILlxCcsWbZJEfXx15lBDhAsu/9tpYOx9
	 bvVTQB08qrvqi/sCSBCaJLqitV8mkjzUGXUbHu/HeK7YufipaFCLrJuBLoVDMVxc0k
	 LeCPRXZzofFKCS7epSG3/U2bnkn9dGHzf5y7TPvSwsFvrc9l29O7PISYsVTXUU7ETZ
	 EKXpaNVkOFQsQ==
From: Vincent Mailhol <mailhol@kernel.org>
Date: Tue, 08 Sep 2026 20:58:26 +0200
Subject: [PATCH RESEND] block: store GPT attributes as a raw value
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-fix_gpt_entry_attributes-v1-1-a4dcb417e8fc@kernel.org>
To: Davidlohr Bueso <dave@stgolabs.net>, Jens Axboe <axboe@kernel.dk>
Cc: linux-efi@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Vincent Mailhol <mailhol@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1540; i=mailhol@kernel.org;
 h=from:subject:message-id; bh=YBNUPhK+dSG8Rj+GgFl/0zrJ57AbV8JvJot3uj9k1OU=;
 b=owGbwMvMwCV2McXO4Xp97WbG02pJDFkLop7anP2VP+O0YM6ZpawlzAWGbifMgjRbXs839GsV5
 k1x/Di1YyILgxgXg6WYIsuyck5uhY5C77BDfy1h5rAygQyRFmlgAAIWBr7cxLxSIx0jPVNtQz1D
 IEPHiIGLUwCm+qUCw3+n3pnblvPPnFoU9vWRwgrdTXUZW7feWveC87GH6nP+l+sbGP7XbFHrnv+
 uyDbrXoXmlf+PIncs5F3MNC9up9T7D6dCs/9wAwA=
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

