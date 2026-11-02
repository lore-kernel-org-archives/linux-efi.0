Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793654997;
	b=LKzhL7XPbjlYt8tralOXk3F0t5Y6ih5cqXuSSnf8jlE60dXetrSfLyOyK0W/W2561gHZ
	 EPHXcHNeJZNChL1n4ROQ8XCwcP548PjCHMdFfO7ZM1or+2rymZxJK31T3Cg679npkl7gx
	 ZGaosxXD6lfXjXCUJQyTXmGB/ThV88T3hHVdsNRkuP0TCTyY13YFuTS+givxuFzKpR+Hh
	 5mTsu6X9YkvsE5S/0brqpaJ28nvfJg+tyLnmJK4sR4ANQ1oHbo1aTop6SJ0hJ98Dj89p6
	 CVIvfdFbzMNSh0LCWrnxM3se2Um0cHh3mSaV02Z7+HlZg4OBDRMrLXksvoHelh4I2tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793654997;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=Qr7ZW6hh4tFasdpF0XfzpgnxQrmEptjL7eOaOR9FQJU=;
	b=yd9V4K/6J/X4P9+ttrDyqpOIdyhJ/jN88b6pz8StLTC1UKh7O8v3ZhSgN7AV8Z7TQdhL
	 57vgXqDC3sEzh1/pVZhbR6blpNNLRXLQSsj4ekC1hH1QCt1ic9vXeOydVwKfK/QbViRwh
	 mN2JieN1ArRVCrD6mib6Ak4FcQ5hq2AK+jwo0JsnQK3xVrulip0sYwggIrojCgj2CuqlN
	 BoAzBSAfJXVj1iK2UFZCuL77m2dEKm/VFqdhFgRaNgBHh3Srf2qn2rg8KDdpcWf2Kgzlq
	 YDj8w+FmJvo0K4ZAm3mhQH0Fupd9QccGv2VsEuu2gPt/HmYu7yOsO9bbxuXGbrvcIJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YE1u68wU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C91606D80C;
	Mon,  2 Nov 2026 21:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YE1u68wU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5731F00A16;
	Mon,  2 Nov 2026 21:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793654997;
	bh=Qr7ZW6hh4tFasdpF0XfzpgnxQrmEptjL7eOaOR9FQJU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YE1u68wUELx1TkvP7hh8A2l6M3A1csKfttKvbOSjKcXhCW5xlxwj6V8tUHo4VfQ1b
	 LJbecdPP9xzvbaIZHDSViev4/e2qwOKC8gv5aHPR9GBMpdKCD4A9SieUWYKTBm4o7+
	 pG7aVSOWRSJ7Hevro26exPilDJZvNqHR19M7oG8f/jYSu5fiyYCa1HNdC1iz2EUft1
	 1mkgUAWXlOeT4rUHILDK5F4/K4oow4HfPYFwhsHixyrwUfGo4r1l+ZYhr+hxjecEqN
	 /NgsiNu5+qkquJOo81SOhXxk88Kx5ZNt3hwtFLAEbcoog4pl3xPBrg3bLWd8A0vJX8
	 WnGlmKFGqy8Gg==
From: Vincent Mailhol <mailhol@kernel.org>
Date: Mon, 02 Nov 2026 22:29:14 +0100
Subject: [PATCH v3 7/7] docs: document discoverable root partitions
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
Message-Id: <20261102-discoverable-root_partitions-v3-7-27f04b69b7ab@kernel.org>
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
 Vincent Mailhol <mailhol@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4200; i=mailhol@kernel.org;
 h=from:subject:message-id; bh=gdnxG7x9j+BB8OhhI8GWAeHqbzX7tVWdfqif6sgGXEI=;
 b=owGbwMvMwCV2McXO4Xp97WbG02pJDFkvGTYqCDr0ph+6Yf/izAoDh8KVW+4+2lTxwf3ZYba5O
 lnuO6bHdUxkYRDjYrAUU2RZVs7JrdBR6B126K8lzBxWJpAh0iINDEDAwsCXm5hXaqRjpGeqbahn
 CGToGDFwcQrAVJuZMfz3jjd7zumuGXZttWWCmebVNx9vT/mVuI3vZPCtCXzr7xYtZmRYd0FSQeb
 DvJOsz/I4n7VUi33L/+pmyazy26BFZPaP+rk8AA==
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
 Documentation/admin-guide/discoverable-root.rst | 46 +++++++++++++++++++++++++
 Documentation/admin-guide/index.rst             |  1 +
 Documentation/admin-guide/kernel-parameters.txt |  5 +++
 3 files changed, 52 insertions(+)

diff --git a/Documentation/admin-guide/discoverable-root.rst b/Documentation/admin-guide/discoverable-root.rst
new file mode 100644
index 000000000000..29c93b3526a6
--- /dev/null
+++ b/Documentation/admin-guide/discoverable-root.rst
@@ -0,0 +1,46 @@
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
+With ``rootwait`` or ``rootwait=<seconds>``, discovery retries while the EFI
+System Partition is unavailable, subject to any specified timeout. Once its disk
+has been scanned, discovery either selects an eligible root partition or stops
+if none was found. Waiting is also disabled if ``LoaderDevicePartUUID`` is not
+available or is malformed.
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
index 0b3c140babd9..2e7b89a05944 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -6746,6 +6746,11 @@ Kernel parameters
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
2.56.0

