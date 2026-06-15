Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D336140B6C8;
	Mon, 15 Jun 2026 16:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781539824; cv=none; b=mINrn1PqvMoCY3FJWN5Yp/KmsKkj+qV5A/8wNkn9tly0UGXbYSk6R7+PDv1Yq4o2GAqYH4y5oOI7zcJYH1LuT32US/M2Ic8hkq7D+esSaqp0pNeVXxdlPI/1dXgzyhOFUPIACAY3792ZBzT3PBBfmtC+Qr+yY5hcWsuKqJYLu8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781539824; c=relaxed/simple;
	bh=buQA0OLsJoBfvfUeMOaxxlJAmvEFctKXcDw8iTDomJw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=lbFjldnTL3gwwTxDFcpx9Ct+mH9w24NQ88aPz+q+45EE5EokX3mUcsL7ddjpd4Da8jyo0ukqywaVHo+OoJtgQYjoSc9If1wnzy9qNpDzP0blmfqc4Q5X+kqBTigGCMZTiB4Cgs+LX1lw4JT3HFncQjnzLHhqJLK38h1g3itcsg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ImWjuFDP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ImWjuFDP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC7051F00A3D;
	Mon, 15 Jun 2026 16:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781539823;
	bh=oavtcVs5GMUEYIHSjYOMZmbm65xOw75SXSw2tCo9C/Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ImWjuFDPO6Xe+bOe18Xx7H8FSwtJc2F8hOBS98xRCMXBXkpzCz/lPIN8oY0vJkH9A
	 h0jSfVJThF7ChGDW9k1EMfif+1OwATGLyDnRvRKbYdU491SJHdaFZn7XTwNpLKHnlO
	 if7h6jeFFp0EMeUKOomAVxsYo4fJw/z4wQcqopTD1XG42oBfRHV1r2NXEs+TBmzyQy
	 L8jWtwbITndX7YRP6tonb8C2ofQD01OUobSqj/MPogQRH9uBWU1A1XDkZ/H8eB8kT4
	 tJ1EMQPyp3xzhe+4a380wJH4IT/jL/NsPrkPF8ZARnMs/tWAW/PBdSHbqXOpRXVsY+
	 w8N0QtWoE97cg==
From: Vincent Mailhol <mailhol@kernel.org>
Date: Mon, 15 Jun 2026 18:09:00 +0200
Subject: [PATCH 04/19] arm: define DPS root partition type UUID
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-discoverable-root_partitions-v1-4-39c78fac42e2@kernel.org>
References: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
In-Reply-To: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Davidlohr Bueso <dave@stgolabs.net>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-efi@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Vincent Mailhol <mailhol@kernel.org>, Russell King <linux@armlinux.org.uk>, 
 linux-arm-kernel@lists.infradead.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1645; i=mailhol@kernel.org;
 h=from:subject:message-id; bh=buQA0OLsJoBfvfUeMOaxxlJAmvEFctKXcDw8iTDomJw=;
 b=owGbwMvMwCV2McXO4Xp97WbG02pJDFkGylfu1+2t5847cU6x5rmgPENA1clQbvVX/pcec0hPe
 HzL9Mf2joksDGJcDJZiiizLyjm5FToKvcMO/bWEmcPKBDJEWqSBAQhYGPhyE/NKjXSM9Ey1DfUM
 gQwdIwYuTgGY6v13GRnOXLGy+qLWd9aTZ6KNhelUtX/iP7jCUoMrw6v83oqeVPJj+KeQ/2yqyMa
 cZ0/k2IvYJ76beSFWZfPdsyePrZ+74//i8CcsAA==
X-Developer-Key: i=mailhol@kernel.org; a=openpgp;
 fpr=ED8F700574E67F20E574E8E2AB5FEB886DBB99C2

DPS [1] assigns GPT partition type UUIDs to operating system partitions.
Root partitions use architecture-specific type UUIDs so the OS can
discover the intended root filesystem without relying on a root= cmdline
option.

Define DPS_ROOT_PARTITION_TYPE_UUID in asm/dps_root.h for ARM and select
ARCH_HAS_DPS_ROOT_PARTITION_TYPE_UUID.

[1] The Discoverable Partitions Specification (DPS)
Link: https://uapi-group.org/specifications/specs/discoverable_partitions_specification/

Cc: Russell King <linux@armlinux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
---
 arch/arm/Kconfig                | 1 +
 arch/arm/include/asm/dps_root.h | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 73e6647bea46..deedb5d808fb 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -14,6 +14,7 @@ config ARM
 	select ARCH_HAS_DMA_ALLOC if MMU
 	select ARCH_HAS_DMA_OPS
 	select ARCH_HAS_DMA_WRITE_COMBINE if !ARM_DMA_MEM_BUFFERABLE
+	select ARCH_HAS_DPS_ROOT_PARTITION_TYPE_UUID
 	select ARCH_HAS_ELF_RANDOMIZE
 	select ARCH_HAS_FORTIFY_SOURCE
 	select ARCH_HAS_KEEPINITRD
diff --git a/arch/arm/include/asm/dps_root.h b/arch/arm/include/asm/dps_root.h
new file mode 100644
index 000000000000..e9f0f24bcac2
--- /dev/null
+++ b/arch/arm/include/asm/dps_root.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef _ASM_ARM_DPS_ROOT_H
+#define _ASM_ARM_DPS_ROOT_H
+
+#define DPS_ROOT_PARTITION_TYPE_UUID "69dad710-2ce4-4e3c-b16c-21a1d49abed3"
+
+#endif /* _ASM_ARM_DPS_ROOT_H */

-- 
2.53.0

