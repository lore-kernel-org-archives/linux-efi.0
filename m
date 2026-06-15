Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D4040913C;
	Mon, 15 Jun 2026 16:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781539850; cv=none; b=QMwoYsw5L/VEAn2wG2Qa2c/JrmD1sJZe3eR+wkRKjXzgupyTT7TQGWsODSalK++8QragiKtfuUauh58D9wLDcMyUNuyGyuwsr9qPPAqAaIzplkGNR2kaA+pZ95P9tFfP1jZj0AL7qbwZPvx5HBpwY3J2zd8kYhwbWMVh9qJBDLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781539850; c=relaxed/simple;
	bh=pGGyh2TRFwNAqUaNVPHy3MdxdEXBcZz1ASOfsY2J0hU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mnoZsD+hJXzsM1uAshQae2d/X557syBVA0pF/2p6W95WGG4DxGJZCuM0crqu7G1uSOEGQQX8gz9ESJdJfOlj70pLHEbwfmDJxy/NEy0y6WkyB+z7I1jfFzP0CKQ0xQCVM5CggAOUER6IFW7k6BY7tcVEFaDzoRfo4dlgea+ZGAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ncLsD/vW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ncLsD/vW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0A971F000E9;
	Mon, 15 Jun 2026 16:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781539849;
	bh=lFxkCMBfVV3FCRRMIo+bBBEG8tTSxaqkdb7xuvcsV4E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ncLsD/vWptoJUo1ITW0lSHHZTP2t1jFEPCgv+CTUd42u/OmeM6lJ2bvGv/O2cguq/
	 CGRVS+fQrV+ar2Dep2OqgxJGfaZb/u8VsZa3u3S1sYb5LxUDRAYgkk9yHZ3HbgLW8D
	 hN7dHzVTxwwfwBmjSo2anFbJEMEw/z9vnC7/1IMQl8nlKuJJFyCsq5uKANHsNyPr82
	 g3RuFX94bHb3kaiXw2kU3R+KxyuSepsnY8gGVuuMfvQsnZHtU3+XkENGhZiuDGSfWI
	 Pmc3cW0zvvtQqyxSc6OuWgej1RK+iBlO7UmLdgN8dwmIPLTZA155+Fg8KmHxQA13T5
	 ltKQBxyPSAsLg==
From: Vincent Mailhol <mailhol@kernel.org>
Date: Mon, 15 Jun 2026 18:09:07 +0200
Subject: [PATCH 11/19] s390: define DPS root partition type UUIDs
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-discoverable-root_partitions-v1-11-39c78fac42e2@kernel.org>
References: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
In-Reply-To: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Davidlohr Bueso <dave@stgolabs.net>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-efi@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Vincent Mailhol <mailhol@kernel.org>, Heiko Carstens <hca@linux.ibm.com>, 
 Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1915; i=mailhol@kernel.org;
 h=from:subject:message-id; bh=pGGyh2TRFwNAqUaNVPHy3MdxdEXBcZz1ASOfsY2J0hU=;
 b=owGbwMvMwCV2McXO4Xp97WbG02pJDFkGylfLshtvnHJ7dCT+Qb6LaOoZ2cSaSGWeDZO36e04H
 lG3IYSzYyILgxgXg6WYIsuyck5uhY5C77BDfy1h5rAygQyRFmlgAAIWBr7cxLxSIx0jPVNtQz1D
 IEPHiIGLUwCmWp2PkWHe/f23jm29Zx09SfrVUYHpPHJnpG+4W3zP3do6a7mA0V5LRobOPc+Z101
 rrNpbYNj6z6D1wbdnXgFyX5UVrU71F3Hc3MYKAA==
X-Developer-Key: i=mailhol@kernel.org; a=openpgp;
 fpr=ED8F700574E67F20E574E8E2AB5FEB886DBB99C2

DPS [1] assigns GPT partition type UUIDs to operating system partitions.
Root partitions use architecture-specific type UUIDs so the OS can
discover the intended root filesystem without relying on a root= cmdline
option.

Define DPS_ROOT_PARTITION_TYPE_UUID in asm/dps_root.h for the s390
(32-bit) and s390x (64-bit) variants described by the specification and
select ARCH_HAS_DPS_ROOT_PARTITION_TYPE_UUID.

[1] The Discoverable Partitions Specification (DPS)
Link: https://uapi-group.org/specifications/specs/discoverable_partitions_specification/

Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: linux-s390@vger.kernel.org
Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
---
 arch/s390/Kconfig                |  1 +
 arch/s390/include/asm/dps_root.h | 12 ++++++++++++
 2 files changed, 13 insertions(+)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 9921a3772bf7..af2cf67fffd7 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -91,6 +91,7 @@ config S390
 	select ARCH_HAS_DEBUG_WX
 	select ARCH_HAS_DEVMEM_IS_ALLOWED
 	select ARCH_HAS_DMA_OPS if PCI
+	select ARCH_HAS_DPS_ROOT_PARTITION_TYPE_UUID
 	select ARCH_HAS_ELF_RANDOMIZE
 	select ARCH_HAS_FORCE_DMA_UNENCRYPTED
 	select ARCH_HAS_FORTIFY_SOURCE
diff --git a/arch/s390/include/asm/dps_root.h b/arch/s390/include/asm/dps_root.h
new file mode 100644
index 000000000000..e72e44a66097
--- /dev/null
+++ b/arch/s390/include/asm/dps_root.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef _ASM_S390_DPS_ROOT_H
+#define _ASM_S390_DPS_ROOT_H
+
+#ifdef CONFIG_64BIT
+#define DPS_ROOT_PARTITION_TYPE_UUID "5eead9a9-fe09-4a1e-a1d7-520d00531306"
+#else
+#define DPS_ROOT_PARTITION_TYPE_UUID "08a7acea-624c-4a20-91e8-6e0fa67d23f9"
+#endif
+
+#endif /* _ASM_S390_DPS_ROOT_H */

-- 
2.53.0

