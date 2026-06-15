Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4656409126;
	Mon, 15 Jun 2026 16:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781539814; cv=none; b=tS5oye9bnRKoyOfQRRleUflGxe4pIgs0gRFeir9j8lLLPr7wAyeuylnZC4FQXWQj+JL3/TFonLGDAJyXfXtO/OJjnh+N2ofCo0FKMuITNq7HkBTZQcA5qxfu0aJaHM5zSrgHh4/jcjaNB272WIT7ik8Wk1lz1aYzT7ZyVZWzuNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781539814; c=relaxed/simple;
	bh=EzW6dCaDt8khHsFB0IhlvKqYCsqFRdDstlyt1WP3IH4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gQCycQI5CvDEWCBW+r0ZG/rf5Jm340noVTxYkn8F3yVoKbqwnAlx1RublrGflCg7QX0cy7hD/gfBKLihBhpSzxSggrZyB+hi4v4X6PUxhYOCJNfw71+kj+1LKPuFfHoDC0UL9xqZW1wSdrL2b0SEimvmZZzYnWdUyGB5eze/W68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ASmQF4T1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ASmQF4T1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB9A61F00A3A;
	Mon, 15 Jun 2026 16:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781539813;
	bh=Wl06eet0riGAGSqUPaZBip49FZIg1ELbDot78cgwrT4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ASmQF4T1ecqpxb9HSfLceQ00jM4iJkO5/fkIqkWULHfAe41/3BOFk/t4T/0LzgflN
	 rVMrMtafLTRchUHYo6lZ2HWIzonAQYkp3jQkWba+SAQX0YVBCILVHXE+s2D0TvV71z
	 KFQOJ6h/tNefqXGGsJp4wimnH9l6pZrlRcT39b8OM1UjCcBsYrWO952BDnWNl4kyFW
	 SI3/hMNVERpGFzvUCM5I9o9oB0G4j8qjmk+8pDizpqmB6E/ux8WkixxawjVaMo6hBU
	 TTf2mmktrJEiHvA1qcEvJvtI4xTHZDu0DhyfGBFu0mrQ8rxrJjvkJv22aZTZ7eYVLS
	 aDBnVxLFuwb0Q==
From: Vincent Mailhol <mailhol@kernel.org>
Date: Mon, 15 Jun 2026 18:08:57 +0200
Subject: [PATCH 01/19] init: add DPS root partition type UUID capability
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-discoverable-root_partitions-v1-1-39c78fac42e2@kernel.org>
References: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
In-Reply-To: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Davidlohr Bueso <dave@stgolabs.net>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-efi@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Vincent Mailhol <mailhol@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2072; i=mailhol@kernel.org;
 h=from:subject:message-id; bh=EzW6dCaDt8khHsFB0IhlvKqYCsqFRdDstlyt1WP3IH4=;
 b=owGbwMvMwCV2McXO4Xp97WbG02pJDFkGyld2+W41+p0c1Hp8nVn12jkiS68Wz58S6ybfc+fEn
 6xZPU4pHRNZGMS4GCzFFFmWlXNyK3QUeocd+msJM4eVCWSItEgDAxCwMPDlJuaVGukY6ZlqG+oZ
 Ahk6RgxcnAIw1dG9DP/dpN5Zan4VdSk+8maGfVS4vMv2jwLRkzZtmO/pstRHaoMhI8Nkj/IUTat
 tzuzvp5zl4+UQ0En3YX7yZv9+sZdSbg5LP3AAAA==
X-Developer-Key: i=mailhol@kernel.org; a=openpgp;
 fpr=ED8F700574E67F20E574E8E2AB5FEB886DBB99C2

DPS [1] assigns native root partition type UUIDs per architecture.

Add the ARCH_HAS_DPS_ROOT_PARTITION_TYPE_UUID config option so that
architectures can opt in.

Architectures that support this feature should define
DPS_ROOT_PARTITION_TYPE_UUID in asm/dps_root.h as a string
representation of the architecture's DPS root partition type UUID.

Add the hidden DPS_ROOT_AUTO_DISCOVERY symbol for the combination of
BLOCK, EFI and ARCH_HAS_DPS_ROOT_PARTITION_TYPE_UUID, and use it to
expose DPS_ROOT_PARTITION_TYPE_UUID from the common linux/root_dev.h
header only when all prerequisites are met.

[1] The Discoverable Partitions Specification (DPS)
Link: https://uapi-group.org/specifications/specs/discoverable_partitions_specification/

Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
---
 include/linux/root_dev.h | 6 ++++++
 init/Kconfig             | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/include/linux/root_dev.h b/include/linux/root_dev.h
index 847c9a06101b..6b52a10b0bca 100644
--- a/include/linux/root_dev.h
+++ b/include/linux/root_dev.h
@@ -5,6 +5,12 @@
 #include <linux/major.h>
 #include <linux/types.h>
 #include <linux/kdev_t.h>
+#include <linux/uuid.h>
+
+#ifdef CONFIG_DPS_ROOT_AUTO_DISCOVERY
+#include <asm/dps_root.h>
+static_assert(sizeof(DPS_ROOT_PARTITION_TYPE_UUID) == UUID_STRING_LEN + 1);
+#endif
 
 enum {
 	Root_NFS = MKDEV(UNNAMED_MAJOR, 255),
diff --git a/init/Kconfig b/init/Kconfig
index 147da6370bf0..982c6ad9da4d 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -2287,6 +2287,12 @@ config ARCH_HAS_PREPARE_SYNC_CORE_CMD
 config ARCH_HAS_SYNC_CORE_BEFORE_USERMODE
 	bool
 
+config ARCH_HAS_DPS_ROOT_PARTITION_TYPE_UUID
+	bool
+
+config DPS_ROOT_AUTO_DISCOVERY
+	def_bool BLOCK && EFI && ARCH_HAS_DPS_ROOT_PARTITION_TYPE_UUID
+
 # It may be useful for an architecture to override the definitions of the
 # SYSCALL_DEFINE() and __SYSCALL_DEFINEx() macros in <linux/syscalls.h>
 # and the COMPAT_ variants in <linux/compat.h>, in particular to use a

-- 
2.53.0

