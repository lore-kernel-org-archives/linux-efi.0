Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4974840DFC4;
	Mon, 15 Jun 2026 16:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781539835; cv=none; b=eBDe9RF9h1Zv+dCKBkT50xWprKIbzH2LimqTigbxFujQjIwczmecBtRfqUoDciKliTTwG7kUOrs5W2iN3R6jeVJ9iLhDaGPTxVaLDS7I6/eAJ+npYy5lw1m5WcFybvbv36hltONRksA1ADsw8El3ofxVHy9yLVOxJayNKlfMoqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781539835; c=relaxed/simple;
	bh=+9oFedjXmWJlU0N63fssHK3oltcYRMpi/GQpCHpHAwM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qrGfJCoYr2qbhQX9FUiNQsxBAuy7Mikh5puCjrBJpiGnesOsqWG7hC271baorq8wXtxm3V5paJSZnZSuFLgjMWGygQwVi5Le7JkD/QFPsIY7p2MYWrTgCk78AOdmWh07IX/k7djVhLX7sUe8GD7GU/WHZ6h4XWNf2ZxTXDnVa+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YPrhrb4p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YPrhrb4p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1980B1F000E9;
	Mon, 15 Jun 2026 16:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781539834;
	bh=WfXVIugkImUS1LbGAeaBhDb5JXqHI0J1V5oUk6XY8HY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YPrhrb4pezl3P9gN7qN8/dXs8Aakdgwxds8HiO9FJi9dTK6GaWh32Y6P2hUxA9ny1
	 8DEmD3CCONgRUDcddYDaaq3XEFBZAoSap/uIzF+Ledn7hg2joHt+tu3RZgrJWGsuGp
	 EQJ4t2Ihe7thelqBYY/iHiuCsw+DgKVtrqNjmDt5pOpwokqQTOXv68rIRCiVMok0xl
	 bKtf7XcOUa4LA7NbjycB7bAJqEEg6608T86lcR8AQykb985wd2NTtLc4eoh9D4YOSq
	 1GjcI6oP6uhfSFzC0hskkjx8JEBujVMe1f45rCg1K94dgbh5a7jMt0pkpsNuUfKesE
	 g73LjxIxjV6Xw==
From: Vincent Mailhol <mailhol@kernel.org>
Date: Mon, 15 Jun 2026 18:09:03 +0200
Subject: [PATCH 07/19] mips: define DPS root partition type UUIDs
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-discoverable-root_partitions-v1-7-39c78fac42e2@kernel.org>
References: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
In-Reply-To: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Davidlohr Bueso <dave@stgolabs.net>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-efi@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Vincent Mailhol <mailhol@kernel.org>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, linux-mips@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2120; i=mailhol@kernel.org;
 h=from:subject:message-id; bh=+9oFedjXmWJlU0N63fssHK3oltcYRMpi/GQpCHpHAwM=;
 b=owGbwMvMwCV2McXO4Xp97WbG02pJDFkGyle3H/vkd/xIl/nKY3I1m/x1l3526PwhNOdV7NuHo
 TEhvPJ+HRNZGMS4GCzFFFmWlXNyK3QUeocd+msJM4eVCWSItEgDAxCwMPDlJuaVGukY6ZlqG+oZ
 Ahk6RgxcnAIw1SYqDP+sF+o/DPh/6GT1jschF2cdEfzKPNX4At/boxFq0zfzOb9fzciw55E9398
 87r5LXWqXTD3aF4XKqfcYMIhO2bA76MeRXwfZAQ==
X-Developer-Key: i=mailhol@kernel.org; a=openpgp;
 fpr=ED8F700574E67F20E574E8E2AB5FEB886DBB99C2

DPS [1] assigns GPT partition type UUIDs to operating system partitions.
Root partitions use architecture-specific type UUIDs so the OS can
discover the intended root filesystem without relying on a root= cmdline
option.

Define DPS_ROOT_PARTITION_TYPE_UUID in asm/dps_root.h for the MIPS
endian and 32/64-bit variants described by the specification and select
ARCH_HAS_DPS_ROOT_PARTITION_TYPE_UUID.

[1] The Discoverable Partitions Specification (DPS)
Link: https://uapi-group.org/specifications/specs/discoverable_partitions_specification/

Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-mips@vger.kernel.org
Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
---
 arch/mips/Kconfig                |  1 +
 arch/mips/include/asm/dps_root.h | 20 ++++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 4364f3dba688..15dd7d336cfa 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -10,6 +10,7 @@ config MIPS
 	select ARCH_HAS_CURRENT_STACK_POINTER
 	select ARCH_HAS_DEBUG_VIRTUAL if !64BIT
 	select ARCH_HAS_DMA_OPS if MACH_JAZZ
+	select ARCH_HAS_DPS_ROOT_PARTITION_TYPE_UUID
 	select ARCH_HAS_FORTIFY_SOURCE
 	select ARCH_HAS_KCOV
 	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE if !EVA
diff --git a/arch/mips/include/asm/dps_root.h b/arch/mips/include/asm/dps_root.h
new file mode 100644
index 000000000000..b07cab7399ad
--- /dev/null
+++ b/arch/mips/include/asm/dps_root.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef _ASM_MIPS_DPS_ROOT_H
+#define _ASM_MIPS_DPS_ROOT_H
+
+#ifdef CONFIG_CPU_LITTLE_ENDIAN
+#ifdef CONFIG_64BIT
+#define DPS_ROOT_PARTITION_TYPE_UUID "700bda43-7a34-4507-b179-eeb93d7a7ca3"
+#else
+#define DPS_ROOT_PARTITION_TYPE_UUID "37c58c8a-d913-4156-a25f-48b1b64e07f0"
+#endif
+#else
+#ifdef CONFIG_64BIT
+#define DPS_ROOT_PARTITION_TYPE_UUID "d113af76-80ef-41b4-bdb6-0cff4d3d4a25"
+#else
+#define DPS_ROOT_PARTITION_TYPE_UUID "e9434544-6e2c-47cc-bae2-12d6deafb44c"
+#endif
+#endif
+
+#endif /* _ASM_MIPS_DPS_ROOT_H */

-- 
2.53.0

