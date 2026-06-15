Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25D340B6D9;
	Mon, 15 Jun 2026 16:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781539875; cv=none; b=fr6zRFawMc6cosWiAGKkC4qM+y80oyJwXKPIjyAKfOsomy/bjgJ8BXjo7bIy6urGVvhSigwPNwzCJQssu4NTe0LXRmBmvHBKDShjVIyaIGnqvEM9wm1SetmJmAsuQGvgdZRIHoNapwDVLcGDfHY1WhujyOnqA2FG2Oh8nynqDPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781539875; c=relaxed/simple;
	bh=IQn+EJfXSKnbywiAcRWsmiRkucdeNqtI6usBrzEOsOw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=DuYmWKrnE17F0tH7atJwBrB86rlxxo4v22rnNQfQt7bphKJWfRPxWlyVjQpFdhbWEjngchoANuXx07pDQQGQ1AfkSVrnTBE8cKdmoburkb367mjgXTp9hD8b9Zzk6OXJ265wOGyR9izaRo9UkCF9Z8ofmfUFiK64uSu2vTNq0wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SxSK0oMz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SxSK0oMz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6C91F00A3A;
	Mon, 15 Jun 2026 16:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781539874;
	bh=47eLSZrGC8dbgWbXEjVWdFhdpbCm8wu5R48ilZUcy3g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=SxSK0oMz+Inh9En/B/++WRvwwzyt0AQXoGQ2HB53cPc9/UR0pDwAhRJqg9jjVbLu8
	 JraPb5U0gDCRvdjBx7boKePeXuXbwRRsjupbxVNUACBueTKweQcBRdk4hmPwpQ/TOD
	 rsLkGZwTe7JVw7LP+WoAqsaauzVHHEhtZidWFIR5eJsqv41ZdY59BAsOkEl0Z2MMUT
	 SrxtWJtY9sQgVWppkYz6oT7RF/FVDyQ6IZn64ZJhzJxteoTNOiiYZbTpSUxx1bvtVh
	 NnoHa4e32JB5pdYqMHDiz+hEW1Ws/PXs0nHkMhViborx99OL4E6423Cz9j0hUCBIE6
	 yN5S7S8MhSa0A==
From: Vincent Mailhol <mailhol@kernel.org>
Date: Mon, 15 Jun 2026 18:09:15 +0200
Subject: [PATCH 19/19] docs: document discoverable root partitions
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-discoverable-root_partitions-v1-19-39c78fac42e2@kernel.org>
References: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
In-Reply-To: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Davidlohr Bueso <dave@stgolabs.net>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-efi@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Vincent Mailhol <mailhol@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3354; i=mailhol@kernel.org;
 h=from:subject:message-id; bh=IQn+EJfXSKnbywiAcRWsmiRkucdeNqtI6usBrzEOsOw=;
 b=owGbwMvMwCV2McXO4Xp97WbG02pJDFkGytc0Z+74Kx67ebba8mDmqvsr1++Z+0t7qltorvp7/
 TWL1EsrOyayMIhxMViKKbIsK+fkVugo9A479NcSZg4rE8gQaZEGBiBgYeDLTcwrNdIx0jPVNtQz
 BDJ0jBi4OAVgqufXMfyPldtTxCCrHnrj+sO1taszww99f1bc9DDgSZf7+W8Vhw6+ZGSYdEMvOmV
 xxYFPn4UlNmwI/xL2vT30yf7gxsV7P3vMzp/ICAA=
X-Developer-Key: i=mailhol@kernel.org; a=openpgp;
 fpr=ED8F700574E67F20E574E8E2AB5FEB886DBB99C2

Document the automatic root block device discovery feature.

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org
Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
---
 Documentation/admin-guide/discoverable-root.rst | 33 +++++++++++++++++++++++++
 Documentation/admin-guide/index.rst             |  1 +
 Documentation/admin-guide/kernel-parameters.txt |  5 ++++
 3 files changed, 39 insertions(+)

diff --git a/Documentation/admin-guide/discoverable-root.rst b/Documentation/admin-guide/discoverable-root.rst
new file mode 100644
index 000000000000..9645bf39e405
--- /dev/null
+++ b/Documentation/admin-guide/discoverable-root.rst
@@ -0,0 +1,33 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+.. _discoverable_root:
+
+Discoverable root partitions
+============================
+
+On EFI systems using a supported architecture, the kernel can discover the root
+block device from GPT partition type UUID metadata on the disk containing the
+active EFI System Partition.
+
+This follows the `Discoverable Partitions Specification`_ which defines a list
+of architecture-specific root partition type UUIDs.
+
+Specifying ``root=`` on the kernel command line takes precedence and entirely
+disables this automatic root partition discovery.
+
+The disk to search is identified by the Boot Loader Interface
+``LoaderDevicePartUUID`` EFI variable. If multiple partitions on that disk match
+the architecture root partition type UUID, the kernel selects the first match in
+block device enumeration order. Systems should not expose multiple eligible root
+partitions unless that ordering is intended.
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
index f68bf1cdb53b..c9bfa010883c 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -6696,6 +6696,11 @@ Kernel parameters
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
2.53.0

