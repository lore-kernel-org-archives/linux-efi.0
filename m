Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361351B4224
	for <linux-efi@vger.kernel.org>; Mon, 27 Jul 2026 04:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785125276; cv=none; b=oh5jdkQwkGD6P6GAZQgL/EcZdL1TAgAyh9fsjg9+kAjjkhPHuLMbI0CbKCOZb5Iqeg10W3KHOVWZZyUODS7uEjkxxGwn9f2rn8lrIhmWBT5ugdSmQ2vKBHZYp2VwkglspPmd7n8l8Iz8VY3BBM033zJwnHr6wogVQwI+lC77ofY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785125276; c=relaxed/simple;
	bh=Gxp3Un4AZGgro1b7wJhIj9cUYRY3ZZI3yEbM0aXczz8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jnVtCdCC5r2n8JyPlRT953dnGN3exzLozvyCzPm7mgVz1x0iVT2kk1R8bDsMjDR3XG/Ao09wPyNT8T+kd08IjjBNezCa4TF1VPsAsvquRtEYbFe9gKzKLldga5ZLcadpWD7BTStSIiGg28S1ETg/TJ9xddCY6HIQwaDsWmRvBvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=En+3+cYH; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="En+3+cYH"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2cae1a3a744so16398635ad.3
        for <linux-efi@vger.kernel.org>; Sun, 26 Jul 2026 21:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785125273; x=1785730073; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=86uk4Z2sGa/3sM3sJKSYmohCJPc9h2SJlL31GgQy+No=;
        b=En+3+cYHN4RCisczuYSD8uDNcyN6CRfIWxFRSXzGxnQwuIJFcqHjaCxgT6HI8GvkeK
         xeProrRxw42d/B+pqnBf3um0kd2GPwn7TrflTaiVty5D4B55KwHCbdZiKJcQcsu8L4uC
         EvsZmL7cHJlrTjrlMt5sD8fyy3u4tlRVRRldUlfxfGjaYmHi0sgJV16himEYyz3QW+VD
         4U92cgpqJOQgd4Krim85VAWqWL/cTzRFppYhQrKLeCDTHW32vSguylDxOYMLZ9qABoaK
         nGAOa9p8Dkq9nabU3pm/Z4TqcsGkyZqYNdUvDc8IhBSkpljw+YAaaQopzR9tOslTMrnv
         42eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785125273; x=1785730073;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=86uk4Z2sGa/3sM3sJKSYmohCJPc9h2SJlL31GgQy+No=;
        b=FvSR/dLUOB1vtGOe9n77DoD+g2PA+n3LKViFzk1IbzT/JHOSXDHjyV7+HcVDz/CjWA
         v2g7pAJWwbldsjDDrGSgHDumSeNkuw8oO7eav3E0jytBPYmmN8RzOXsTyStzbIAeJSBd
         wd6iaXJ6IC8TiaZnm0Qw4dRHe2DgiYAGr3u3IoWxwp5wf0ZQiakrlhJIsEKfya15qRY0
         gyutvgoBhwDHRsRLyNnP3mHf6Mq+qvKyh7S4PK/tWeNcVbJG3u7c4DpEQjL7tPCOyqAU
         u2hL7d7/mM0qbDMYuf+iEtRcE3IWdncWIlnCLeOyzZ6cuz9F+vh84odGDcW0QsxOAx6q
         sVqQ==
X-Gm-Message-State: AOJu0YwLD5ZjVQSVBLaIg827KdfDYFjHcxpykYA/caPLPGrCX1592Rbb
	HhhD151ghjdMiwMzC+h6qH/XSSJS0A/uPlIBAmm4fI/SIsUPK4MYh8rl
X-Gm-Gg: AR+sD1165kkGa2DLZdokJzdsizVQ/y/EAxLD7w5FguiU9m7g+DPwCBoz7tIuAxIEtEI
	WYXSjhZ3Q1M9O/b7nZDAIxGcT4tIXIqPJluCRjud9I2zDthE0Q8theEsx6TKHZfQMTRs2yF2nK9
	sfTGddFWMhCo1vw1Jb3j7Ol7p5LXCiCR4+EnfYhj7V+chN9NQZYizoGb4omxOlElZVbvmWmZ/EG
	sQF5DI7hvDaOcLmMssoL1gRyZ99mtepiQFuO7/3X6JIZ/0tNsjklPqqFHhMuGMJIDBX0ZvtFZwD
	dFFTzZ7j4bJLeKBngENSngfOECpIzYYVGvfRRzg5q2RSVYYvTn5gSgUmKjJm0KWfKhFPiGp1BEE
	C8pcff6tBsEWFY2ONty3p8j9Vbcv/OE/5FsVBfHG5BHXvToDoZfrS1uNGjCHS15BxTHnscgWPyX
	xfqeM=
X-Received: by 2002:a17:902:c40a:b0:2cc:61e8:5fba with SMTP id d9443c01a7336-2cfde866e46mr72199415ad.32.1785125273513;
        Sun, 26 Jul 2026 21:07:53 -0700 (PDT)
Received: from kali ([58.187.6.148])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cffa9243fcsm5645825ad.64.2026.07.26.21.07.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 21:07:53 -0700 (PDT)
From: Nguyen Le Thanh Tung <nguyenlethanhtung555@gmail.com>
To: Davidlohr Bueso <dave@stgolabs.net>,
	Jens Axboe <axboe@kernel.dk>
Cc: linux-efi@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Nguyen Le Thanh Tung <nguyenlethanhtung555@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] partitions/efi: reject GPT entries with starting_lba > ending_lba
Date: Mon, 27 Jul 2026 00:07:27 -0400
Message-ID: <20260727040727.1910700-1-nguyenlethanhtung555@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

is_pte_valid() checks that both LBAs of a GPT partition entry are within
the device, but never that the entry describes a forward range:

	if ((!efi_guidcmp(pte->partition_type_guid, NULL_GUID)) ||
	    le64_to_cpu(pte->starting_lba) > lastlba         ||
	    le64_to_cpu(pte->ending_lba)   > lastlba)
		return 0;

EndingLBA is defined as the last LBA of the partition, so a conforming
entry always has StartingLBA <= EndingLBA.  A crafted table can invert
the two while keeping both within the device, and efi_partition() then
computes the length as

	u64 size = le64_to_cpu(ptes[i].ending_lba) -
		   le64_to_cpu(ptes[i].starting_lba) + 1ULL;

which underflows to a value close to U64_MAX.

The "extends beyond EOD" clamp in blk_add_partition() does not contain
this, because it tests

	if (from + size > get_capacity(disk))

and from + size wraps for a size of that magnitude, so the sum comes out
small, the clamp is skipped and the partition is registered with the
underflowed length.  From then on bio_check_eod() is evaluated against
bdev_nr_sectors() of that partition, i.e. against the bogus length, so
I/O submitted through the partition device is no longer confined to the
partition and reaches sectors owned by other partitions of the same
disk.

This was verified on 6.8.12 with a crafted two partition image: the
inverted entry is registered as a partition of nearly 2^64 sectors
with no "extends beyond EOD" warning, and BLKZEROOUT issued on
that partition overwrote known marker data belonging to the other,
unrelated partition on the same disk.  No privileged step is
needed on the victim side beyond getting the table parsed, which happens
automatically for removable media on a typical desktop.

Reject the inverted range in is_pte_valid(), the single place every GPT
entry is gated on.  The code has been this way since the beginning of
git history.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Nguyen Le Thanh Tung <nguyenlethanhtung555@gmail.com>
---
Compile tested on 6.8.12: `make W=1 block/partitions/efi.o` produces no
new warnings.  The behaviour described above was reproduced on that same
kernel with a crafted image.  is_pte_valid() is byte identical in 6.8,
current mainline and linux-next.

 block/partitions/efi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/partitions/efi.c b/block/partitions/efi.c
index 9865d59..000219a 100644
--- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -461,7 +461,8 @@ is_pte_valid(const gpt_entry *pte, const u64 lastlba)
 {
 	if ((!efi_guidcmp(pte->partition_type_guid, NULL_GUID)) ||
 	    le64_to_cpu(pte->starting_lba) > lastlba         ||
-	    le64_to_cpu(pte->ending_lba)   > lastlba)
+	    le64_to_cpu(pte->ending_lba)   > lastlba         ||
+	    le64_to_cpu(pte->starting_lba) > le64_to_cpu(pte->ending_lba))
 		return 0;
 	return 1;
 }
-- 
2.53.0

