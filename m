Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792933472;
	b=kK5FZyHS2U8dA5I5hQrq7KZ/0uZXF5/SqhM1Uck3INxwJjCEA2/DZyoaEpUq0vGNzw8i
	 Okh9LtqGMhbTmefAaIIl/0HRJV/gVukWAZC4xje2W/2TwCoLsJmdFynOYAJGJQgr8hR2a
	 JQw5/+JVqpINHFtgYVUauNAwekMMDE6WHCVnPgIvcWBngPIKAPUybtbQpZE4k/sNT09IX
	 hPVrMnnZJDupkNQyn0V8QnGL9hGFjdBLo6ddQvLGxrU3qjonntJgkUOuI5CWcTwjGmgp7
	 zhqw6OhTcltYy5aNufSjRhUTpoUxQo3Kxeq15+6JU2g3I7/RuD6frlnFDgR9RNXePpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792933472;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=8GqKIJrQU0iiT5ZOXaogfEwISq/Cm5lAPQFVw8tt520=;
	b=T+4S+oiwlQjAG95RuAjMFiYR1tRGbPlll6S5NYrv+tHdBsY4rzTilEHVopNFBGn7WXap
	 8HMaAKg9eBdov7tdC4/o6rYpRjm91ReLwpIiYWxeSF8fVZA4GMMyn1mMrpxUfQuL5LiqF
	 TO4RbnbLPZ0KnuFk1J+N2zReCnBwrGioCRsvGGRc+Kqb/zDjOxtyUCdhRrlkuIKakWqJ0
	 H6jFhJkliS8MyH6qGi8WZC7wvd5i2oQDobp2S6hJ5Mc+p3cs+KImUdiZyGTw2ld0yGR9j
	 /ZFa8dvFQ2GNyAaD5GNKHmmHOJCN4kn2gc6SkY7bavhFGCysG4OottgWD4GhSjOvTkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hvr4n2ji;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B6E606A322;
	Sun, 25 Oct 2026 13:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hvr4n2ji
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E1951F031E0;
	Sun, 25 Oct 2026 13:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792933471;
	bh=8GqKIJrQU0iiT5ZOXaogfEwISq/Cm5lAPQFVw8tt520=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hvr4n2jiNTMZxCiZoG3qq2QJrNKTtBgS9PXKg75MgnhBqmwipGodvcDJhvE3Jera1
	 qE6XGsZiDW3SLwfrUg1lQPISdLWHK13xXpiaE1eM0EUX3LhiNcqdJJQCrdnmfsiVVS
	 2fgKwILj5/xqCk04saWwgE9z+FJ1uR7SiCRUat9j4DBtfOA4/5XOqAloUTpgPewW7l
	 co8EPthieD+DZdfbuefn8GqPK+0N4hZBVXKWmoMEtTdovCYUs7Gurhigt8Fh37XWG3
	 IJN9df0ytxCeyLFfaLsOoEcg9XfAoe+6frd1VmWMiIDiUcwRacUoI+BtlNni9OVrx8
	 aKxottTg1ibPg==
From: Vincent Mailhol <mailhol@kernel.org>
Date: Sun, 25 Oct 2026 14:03:17 +0100
Subject: [PATCH v2 7/7] docs: document discoverable root partitions
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
Message-Id: <20261025-discoverable-root_partitions-v2-7-fb77d0821fab@kernel.org>
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
 Vincent Mailhol <mailhol@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3845; i=mailhol@kernel.org;
 h=from:subject:message-id; bh=lu2vAPm/XIMWd6ql1MaEy+oIi40mOnVXPbwwRMbSOjg=;
 b=owGbwMvMwCV2McXO4Xp97WbG02pJDFl3/9k0lM6/V5/x9eyGKN4l8jyHs37OmbBVhl9eZ29G8
 LYZRcdedkxkYRDjYrAUU2RZVs7JrdBR6B126K8lzBxWJpAh0iINDEDAwsCXm5hXaqRjpGeqbahn
 CGToGDFwcQrAVMuUMDKsYNu5pYv/lrbbhHMCHjf+beFM7Tm+gLW53VVt2e+4PxM1Gf4KvPKTZJ0
 n5O/+bc3Rlu3VzAyMbM+29j8SU9pbNXvFl1kMAA==
X-Developer-Key: i=mailhol@kernel.org; a=openpgp;
 fpr=ED8F700574E67F20E574E8E2AB5FEB886DBB99C2

Document the automatic root block device discovery feature.

Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
---
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-doc@vger.kernel.org
---
 Documentation/admin-guide/discoverable-root.rst | 40 +++++++++++++++++++++++++
 Documentation/admin-guide/index.rst             |  1 +
 Documentation/admin-guide/kernel-parameters.txt |  5 ++++
 3 files changed, 46 insertions(+)

diff --git a/Documentation/admin-guide/discoverable-root.rst b/Documentation/admin-guide/discoverable-root.rst
new file mode 100644
index 000000000000..f4f35cdb39fe
--- /dev/null
+++ b/Documentation/admin-guide/discoverable-root.rst
@@ -0,0 +1,40 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+.. _discoverable_root:
+
+Discoverable root partitions
+============================
+
+On EFI systems, the kernel can discover the root block device from GPT partition
+type UUID metadata on the disk containing the active EFI System Partition.
+
+This follows the `Discoverable Partitions Specification`_ which defines a list
+of architecture-specific root partition type UUIDs.
+
+An initramfs providing an early userspace ``init``, a ``root=`` kernel
+command-line option, or a root device supplied through the boot protocol takes
+precedence over this automatic root partition discovery.
+
+Automatic discovery uses the Boot Loader Interface ``LoaderDevicePartUUID`` EFI
+variable to identify the partition whose disk is searched. This variable is
+provided by the boot loader or, when the kernel is booted directly by EFI
+firmware, by the Linux EFI stub.
+
+The kernel first searches for the native root partition type UUID. On
+architectures that can run compatible 32-bit user space, the matching 32-bit
+root partition type UUID may be used as a fallback if no partition with the
+native type UUID is found. If multiple partitions on that disk match the
+selected type UUID, the kernel selects the first match in block device
+enumeration order, but this may change. Systems should not expose multiple
+eligible root partitions.
+
+Partitions marked with the DPS ``no-auto`` GPT attribute are skipped. This
+allows a partition with an otherwise discoverable type UUID to opt out from
+automatic discovery.
+
+The DPS read-only attribute is not enforced by kernel root discovery. The
+root filesystem is mounted read-only by default unless ``rw`` is specified,
+and user space remains responsible for later remount policy.
+
+.. _Discoverable Partitions Specification:
+   https://uapi-group.org/specifications/specs/discoverable_partitions_specification/
diff --git a/Documentation/admin-guide/index.rst b/Documentation/admin-guide/index.rst
index cd28dfe91b06..0d9c2796ae09 100644
--- a/Documentation/admin-guide/index.rst
+++ b/Documentation/admin-guide/index.rst
@@ -50,6 +50,7 @@ Booting the kernel
 
    bootconfig
    kernel-parameters
+   discoverable-root
    efi-stub
    initrd
 
diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 03636d799837..75884ef72755 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -6732,6 +6732,11 @@ Kernel parameters
 			ramdisk, "nfs" and "cifs" for root on a network file
 			system, or "mtd" and "ubi" for mounting from raw flash.
 
+			If this option is omitted, the kernel may try to
+			discover the root block device from the GPT partition
+			type UUID metadata when additional requirements are met.
+			See Documentation/admin-guide/discoverable-root.rst.
+
 	rootdelay=	[KNL] Delay (in seconds) to pause before attempting to
 			mount the root filesystem
 

-- 
2.55.0

