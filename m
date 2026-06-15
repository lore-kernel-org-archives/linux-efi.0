Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16FA40FD87;
	Mon, 15 Jun 2026 16:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781539842; cv=none; b=K9VGmwXvz5TZsWSE1GzQK8MkC7Z4e3vbJuxdB6DVAZEco+M1uxgsf5LMZSQjhy12IL7H5T+FPSVsrB6xd0BvEk88/zWGCqS21mbSg6iuCz1ovgWTvr/byj9uA3aEVBiuwLHjmC2Gi6D8tQVJcL7bv11maSvo61oRlVf5Q2J5f84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781539842; c=relaxed/simple;
	bh=1H9x4pEZJ9qkAPBU2nBzdn+Fy1Js3SiNM+vLUchH+X8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WV/fNYtspa94g8hemj+tazQYTpP8uKCAhiWkZpTzOG4vSAsNn801TbQam0YT8cQDhIcNvJvNIiGMiNXCQGc0Fy0ghJ32kZPaUxnEM/mStPLfH3aeN3rBJlUrdjOporLDcFtN0L06zYOhCfLZsbaQZ4BaEYHTaiE17/4/pDyAUSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hRKdXCq/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hRKdXCq/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 241071F000E9;
	Mon, 15 Jun 2026 16:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781539841;
	bh=s2Nu94G1QYwV0Emq9ZE/vR9zmqebZOy/GJaBCjCaRlY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hRKdXCq/Di0yDVyM/BFZpVJYk+Eo4IVGGmK6eddql8FPf7QRcGa/NKyve+FzWWm2n
	 nJADHQ8tH3yvoRTcOANZzqjjWF5Y530YCZ5LYQjvz3u2xlCGiREWdeA70FlL5gEn1Q
	 Svf4/E+Q7kC1Ie0zaz5N7hCkhTAMur2BdHw4GGOv6qLkW00aBTzr9VYF5SH8xyP1ud
	 V+xPI13vuxiIZZNAwZG1o2v/AayOoKL2gptSuYRVmPoWHRLgBV+Gky8QdCg55vlxgG
	 PB8jN8K+g+cr0IfwJFCDqygIwgK4O1j3UISteGwd0/qeAPTbN9MmZvOp0HBcbTA+Uo
	 tzspBhR4Uc2ig==
From: Vincent Mailhol <mailhol@kernel.org>
Date: Mon, 15 Jun 2026 18:09:05 +0200
Subject: [PATCH 09/19] powerpc: define DPS root partition type UUIDs
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-discoverable-root_partitions-v1-9-39c78fac42e2@kernel.org>
References: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
In-Reply-To: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Davidlohr Bueso <dave@stgolabs.net>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-efi@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Vincent Mailhol <mailhol@kernel.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2097; i=mailhol@kernel.org;
 h=from:subject:message-id; bh=1H9x4pEZJ9qkAPBU2nBzdn+Fy1Js3SiNM+vLUchH+X8=;
 b=owGbwMvMwCV2McXO4Xp97WbG02pJDFkGylctNHnUtn/wDAwTbLtt+l0x56bd++Z5sgGO2cJ68
 wI2hWd2TGRhEONisBRTZFlWzsmt0FHoHXboryXMHFYmkCHSIg0MQMDCwJebmFdqpGOkZ6ptqGcI
 ZOgYMXBxCsBUH5vF8IdDcvnNvUHJDBJxkv7/nT87dn5N25FVWr6v4MqhD5vaewQY/md4LHCZUZ1
 vNLtYcH9OxvxLB7XWdrQcfNx8+LBMxPSrk1kA
X-Developer-Key: i=mailhol@kernel.org; a=openpgp;
 fpr=ED8F700574E67F20E574E8E2AB5FEB886DBB99C2

DPS [1] assigns GPT partition type UUIDs to operating system partitions.
Root partitions use architecture-specific type UUIDs so the OS can
discover the intended root filesystem without relying on a root= cmdline
option.

Define DPS_ROOT_PARTITION_TYPE_UUID in asm/dps_root.h for the powerpc
endian and 32/64-bit variants described by the specification and select
ARCH_HAS_DPS_ROOT_PARTITION_TYPE_UUID.

[1] The Discoverable Partitions Specification (DPS)
Link: https://uapi-group.org/specifications/specs/discoverable_partitions_specification/

Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
---
 arch/powerpc/Kconfig                |  1 +
 arch/powerpc/include/asm/dps_root.h | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index e93df95b79e7..e611280a6057 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -134,6 +134,7 @@ config PPC
 	select ARCH_HAS_DEVMEM_IS_ALLOWED
 	select ARCH_HAS_DMA_MAP_DIRECT 		if PPC_PSERIES
 	select ARCH_HAS_DMA_OPS			if PPC64
+	select ARCH_HAS_DPS_ROOT_PARTITION_TYPE_UUID
 	select ARCH_HAS_FORTIFY_SOURCE
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_GIGANTIC_PAGE		if ARCH_SUPPORTS_HUGETLBFS
diff --git a/arch/powerpc/include/asm/dps_root.h b/arch/powerpc/include/asm/dps_root.h
new file mode 100644
index 000000000000..6b3592a73d3d
--- /dev/null
+++ b/arch/powerpc/include/asm/dps_root.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef _ASM_POWERPC_DPS_ROOT_H
+#define _ASM_POWERPC_DPS_ROOT_H
+
+#ifdef CONFIG_PPC64
+#ifdef CONFIG_CPU_LITTLE_ENDIAN
+#define DPS_ROOT_PARTITION_TYPE_UUID "c31c45e6-3f39-412e-80fb-4809c4980599"
+#else
+#define DPS_ROOT_PARTITION_TYPE_UUID "912ade1d-a839-4913-8964-a10eee08fbd2"
+#endif
+#else
+#define DPS_ROOT_PARTITION_TYPE_UUID "1de3f1ef-fa98-47b5-8dcd-4a860a654d78"
+#endif
+
+#endif /* _ASM_POWERPC_DPS_ROOT_H */

-- 
2.53.0

