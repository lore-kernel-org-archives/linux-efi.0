Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B0D410D36;
	Mon, 15 Jun 2026 16:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781539846; cv=none; b=F0lTZRkcN5J5NzDdTHZLiJaC0lWy2ZIUYnv7kjE7roN6VmdhNkWLWeQfTPRyDN6D9iH5G99EzU5pNwx5b2bst1mL/gwVao6ur8MxVvLSijtu+EZAYoYRktLnOUb49gQd493bNTnDJL3V9+WHAa6fLIMCVwkON9+aNHcCFqOXKls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781539846; c=relaxed/simple;
	bh=FmlPIWGCIvIlUIPHOexioNcZhv322lLYPDrGA5VKPpY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=J4FoCP4sO5NT3Y+CE1LZfYJXM1NCWmlP3GN5lPikBqI8maZpqI4xsIunCGYtytH8pdhtHw7Jmvow6EsKEeAdZW9sc9QFeHxQfLomNXDNvyUUO3Tf2zNUuAQUv6qs3FPWaR7NMIIUwZmucwlzi1Vcxbd0V5hAH/7zClrpFgynvA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F7G+I+PA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F7G+I+PA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097B31F00A3A;
	Mon, 15 Jun 2026 16:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781539845;
	bh=xUrauuBapLOJYjxbxmUd3tzFxeamy0yQVyo2zDWxkcU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=F7G+I+PAjJXK5S6q4WuWyXDK2ImeSYfY+SDkyC73I1GjSE2K9DO9DjvZxSQE9GKjV
	 emiNrHMb+72bowkBmTW+iU3cGBzzCnDU2bClqmv8Dne9cvKXi0i1RXOoRRBuduQXE8
	 le9hJW20xxM1sCuMWQiKw1NxkUJQE64+ABZIoK+kBiaQVFimLUvRmtgzXC6ex9AqlY
	 2fC+dDE8+HQhML754k2km7oQaT1cwkdKIKwSABYAOAtMBYUCFi2ianimpp59uLcWuP
	 LWS3I0zGmZuckxCWLDB0kLerr8+LX+6wpaTwoh4165egoOUniXtnj6JU8a6u1h0tVg
	 pfPcR+ZBDo7Kg==
From: Vincent Mailhol <mailhol@kernel.org>
Date: Mon, 15 Jun 2026 18:09:06 +0200
Subject: [PATCH 10/19] riscv: define DPS root partition type UUIDs
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-discoverable-root_partitions-v1-10-39c78fac42e2@kernel.org>
References: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
In-Reply-To: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Davidlohr Bueso <dave@stgolabs.net>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-efi@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Vincent Mailhol <mailhol@kernel.org>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 linux-riscv@lists.infradead.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1933; i=mailhol@kernel.org;
 h=from:subject:message-id; bh=FmlPIWGCIvIlUIPHOexioNcZhv322lLYPDrGA5VKPpY=;
 b=owGbwMvMwCV2McXO4Xp97WbG02pJDFkGylc/LlGQvnfx2FpJTt1Gxl3/o5ep39NbX115wl8m8
 J7jZTenjoksDGJcDJZiiizLyjm5FToKvcMO/bWEmcPKBDJEWqSBAQhYGPhyE/NKjXSM9Ey1DfUM
 gQwdIwYuTgGY6p+hDP+05a+XbMmw4vZ9/kv59o1XuyrELlufWdyR4XHz6A6uVSWHGf7Z70p5aCK
 9Z9aKqsZD50v9Ip4+4VpwVns+R8qf+VJZ/r/ZAQ==
X-Developer-Key: i=mailhol@kernel.org; a=openpgp;
 fpr=ED8F700574E67F20E574E8E2AB5FEB886DBB99C2

DPS [1] assigns GPT partition type UUIDs to operating system partitions.
Root partitions use architecture-specific type UUIDs so the OS can
discover the intended root filesystem without relying on a root= cmdline
option.

Define DPS_ROOT_PARTITION_TYPE_UUID in asm/dps_root.h for the RISC-V
32/64-bit variants described by the specification and select
ARCH_HAS_DPS_ROOT_PARTITION_TYPE_UUID.

[1] The Discoverable Partitions Specification (DPS)
Link: https://uapi-group.org/specifications/specs/discoverable_partitions_specification/

Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: linux-riscv@lists.infradead.org
Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
---
 arch/riscv/Kconfig                |  1 +
 arch/riscv/include/asm/dps_root.h | 12 ++++++++++++
 2 files changed, 13 insertions(+)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 1a2fadccd4c4..526be67e858a 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -28,6 +28,7 @@ config RISCV
 	select ARCH_HAS_DEBUG_VIRTUAL if MMU
 	select ARCH_HAS_DEBUG_VM_PGTABLE
 	select ARCH_HAS_DEBUG_WX
+	select ARCH_HAS_DPS_ROOT_PARTITION_TYPE_UUID
 	select ARCH_HAS_ELF_CORE_EFLAGS if BINFMT_ELF && ELF_CORE
 	select ARCH_HAS_FAST_MULTIPLIER
 	select ARCH_HAS_FORTIFY_SOURCE
diff --git a/arch/riscv/include/asm/dps_root.h b/arch/riscv/include/asm/dps_root.h
new file mode 100644
index 000000000000..86f8e1dbd6ad
--- /dev/null
+++ b/arch/riscv/include/asm/dps_root.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef _ASM_RISCV_DPS_ROOT_H
+#define _ASM_RISCV_DPS_ROOT_H
+
+#ifdef CONFIG_64BIT
+#define DPS_ROOT_PARTITION_TYPE_UUID "72ec70a6-cf74-40e6-bd49-4bda08e8f224"
+#else
+#define DPS_ROOT_PARTITION_TYPE_UUID "60d5a7fe-8e7d-435c-b714-3dd8162144e1"
+#endif
+
+#endif /* _ASM_RISCV_DPS_ROOT_H */

-- 
2.53.0

