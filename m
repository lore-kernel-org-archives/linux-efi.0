Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B32D409636;
	Mon, 15 Jun 2026 16:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781539818; cv=none; b=stn3rVLhxmzaI0+U+IV1PR1NwdSvh6TrryzDSt6Wwdyj4z3XGyNA4wKI2Dth88/MF3q74WYLfxWAuoAgPxpBwfmWmDZsWisOLhBM3ZIPUpzyzJZKlvrAYF/j42gexv96mqP1Zi85GmlRXbGwhzW42l03NEs+mdqUcva51Z/vnw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781539818; c=relaxed/simple;
	bh=4mxqW8AVI0jK2FpwPdzys8Gb9YWIetklNTMPOBbQpMs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PCuddjT6liLBOy0zvUWj1ELfUcXm4ACNKjRqJfGPIHtzvTJlh3EO2nJDVko2qtdjkCOXS/oQC5aOTwTBGqvXSJIzCO3x5chGvRVClCywIiJ9emiwTqnLaLf1cMV6uAQ3ipOGo9NaXU4Ijf4U9YTAK1fjd4SoHoMab5V65XLa64Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dwEzd3VA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dwEzd3VA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3DA1F00A3D;
	Mon, 15 Jun 2026 16:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781539817;
	bh=XgEw8VzDOeN00GX/f4SQZXmzNyfAjAdVxW2eorZU+eU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dwEzd3VADX2YsaAB3hEXO3VToWTfeY0gBFecLojFYV8vTjhKEy+BGcAEY/9HbxnRP
	 hNXklnK91dihcYIZxbn6/bpzDag/VTX9cCIkmfdi+XQomA0AF1FzvVxsv6lmDlcw1g
	 0ShklUIfXD2vDaOyFBvELBaMmkBFi4CJ4oa/KnBSD4heu3UqWsKKE6i1co+Ah/4xmy
	 MM6YZvht3bxrHsXBIBffOARbZpTxrNKImynlP4SHPA7AB64YUKSuL56nj/eB6dLOUC
	 AMqjuuuOy3oUawqbhrIciEeS6so5lIKqByE1czU5/V/N8pdsvWspWCOJ8xbZZLdUzh
	 Z/B7MVlYqJLhA==
From: Vincent Mailhol <mailhol@kernel.org>
Date: Mon, 15 Jun 2026 18:08:58 +0200
Subject: [PATCH 02/19] alpha: define DPS root partition type UUID
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-discoverable-root_partitions-v1-2-39c78fac42e2@kernel.org>
References: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
In-Reply-To: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Davidlohr Bueso <dave@stgolabs.net>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-efi@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Vincent Mailhol <mailhol@kernel.org>, 
 Richard Henderson <richard.henderson@linaro.org>, 
 Matt Turner <mattst88@gmail.com>, Magnus Lindholm <linmag7@gmail.com>, 
 linux-alpha@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1760; i=mailhol@kernel.org;
 h=from:subject:message-id; bh=4mxqW8AVI0jK2FpwPdzys8Gb9YWIetklNTMPOBbQpMs=;
 b=owGbwMvMwCV2McXO4Xp97WbG02pJDFkGylfuSE/X95f0UXj9OuHgWuO0bS4rdio1H67WmtwV4
 xqt9D2nYyILgxgXg6WYIsuyck5uhY5C77BDfy1h5rAygQyRFmlgAAIWBr7cxLxSIx0jPVNtQz1D
 IEPHiIGLUwCm+uVcRoa9rZn9vyJiSt5kVYpb7zc6vXQmi+Przr0pQkJ2F7Xli/cw/JWyS/yVOPu
 cbk/eja2Z2+Uc+u/e//Bn6epuJv9radrer5kB
X-Developer-Key: i=mailhol@kernel.org; a=openpgp;
 fpr=ED8F700574E67F20E574E8E2AB5FEB886DBB99C2

DPS [1] assigns GPT partition type UUIDs to operating system partitions.
Root partitions use architecture-specific type UUIDs so the OS can
discover the intended root filesystem without relying on a root= cmdline
option.

Define DPS_ROOT_PARTITION_TYPE_UUID in asm/dps_root.h for alpha and
select ARCH_HAS_DPS_ROOT_PARTITION_TYPE_UUID.

[1] The Discoverable Partitions Specification (DPS)
Link: https://uapi-group.org/specifications/specs/discoverable_partitions_specification/

Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Magnus Lindholm <linmag7@gmail.com>
Cc: linux-alpha@vger.kernel.org
Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
---
 arch/alpha/Kconfig                | 1 +
 arch/alpha/include/asm/dps_root.h | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 7b7dafe7d9df..400cbb7525c8 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -5,6 +5,7 @@ config ALPHA
 	select ARCH_32BIT_USTAT_F_TINODE
 	select ARCH_HAS_CURRENT_STACK_POINTER
 	select ARCH_HAS_DMA_OPS if PCI
+	select ARCH_HAS_DPS_ROOT_PARTITION_TYPE_UUID
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_MIGHT_HAVE_PC_SERIO
 	select ARCH_MODULE_NEEDS_WEAK_PER_CPU if SMP
diff --git a/arch/alpha/include/asm/dps_root.h b/arch/alpha/include/asm/dps_root.h
new file mode 100644
index 000000000000..7f70a83f72de
--- /dev/null
+++ b/arch/alpha/include/asm/dps_root.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef _ASM_ALPHA_DPS_ROOT_H
+#define _ASM_ALPHA_DPS_ROOT_H
+
+#define DPS_ROOT_PARTITION_TYPE_UUID "6523f8ae-3eb1-4e2a-a05a-18b695ae656f"
+
+#endif /* _ASM_ALPHA_DPS_ROOT_H */

-- 
2.53.0

