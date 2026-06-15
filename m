Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89D440BCD8;
	Mon, 15 Jun 2026 16:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781539832; cv=none; b=XA7ginGnl2KyRtDp2PkIKTpxM8F4BUuZ4Aab/hT7OsxS/UKhenKhMzH/7HeCkzMcrjSDAUueXcv1E4JS4KI4j44gRuNQ6hHXL3H4M7nsvdF6BXdnNb0IvmbqjC4cQOXmxvztKaDLXtTIBqIEKaheovPy00hlxCtUGOs7i3mgVYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781539832; c=relaxed/simple;
	bh=JVLwSwdOKVH8LGAxgA+g/fdECBLcaM60dc030mBvrLo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mtEpOemWUDoA2reP+zZjcUuqoamxH03J49LE324bA8aPvkwoB7CW68PXGsrEEos4fLtDOOm23pC/zoN04TMQE+wW90PPAWV/09TnDBJdTI0lciy/kFkWRCu3eJ1J+GlyEQ8yUOgKq5caszD4JqAVVYf+TvYB740V9Zz7CMe5e88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bTG7AUNv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bTG7AUNv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF73C1F00A3A;
	Mon, 15 Jun 2026 16:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781539830;
	bh=cWyLORJu1duRc+pDSDE2yctLaF4n1YyEH8jjavDYSRo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bTG7AUNv+QOjtKzRr8tGZfCmK7X7/d1+zMYHWGov+7jfQ3ohhOVIuPHcJKhbVYeMd
	 8xor5LSWdZDbye7sU3NUsKY2D7c5k6KW7VzuECmhNXjzB+STHLracoyoBLfycJOds1
	 bRCPQFF5niVqDMw4ul5YDEFduhZUKgLvmKAfjFyAjG6oXQtN02dsCkCvFrzLzjhnuS
	 jSVgQMlrCJ3DlZQLtjRobTwFbjaWHQtTK/NR95pcSSjdYTSGIqpuaEA8vdCpBsJlUy
	 6+sLfXdKcoIRk0cv9xl9q+QRiKjriZwy7eYC4rRzuXqa+DeVkEcul1n87LjfG52xHg
	 OZ9D5NneOlpUw==
From: Vincent Mailhol <mailhol@kernel.org>
Date: Mon, 15 Jun 2026 18:09:02 +0200
Subject: [PATCH 06/19] loongarch: define DPS root partition type UUID
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-discoverable-root_partitions-v1-6-39c78fac42e2@kernel.org>
References: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
In-Reply-To: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Davidlohr Bueso <dave@stgolabs.net>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-efi@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Vincent Mailhol <mailhol@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 WANG Xuerui <kernel@xen0n.name>, loongarch@lists.linux.dev
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1739; i=mailhol@kernel.org;
 h=from:subject:message-id; bh=JVLwSwdOKVH8LGAxgA+g/fdECBLcaM60dc030mBvrLo=;
 b=owGbwMvMwCV2McXO4Xp97WbG02pJDFkGyleXOs88onWwPrP4/qFHgQ8vKWfyZNef/RH0ULpa+
 YW51pHEjoksDGJcDJZiiizLyjm5FToKvcMO/bWEmcPKBDJEWqSBAQhYGPhyE/NKjXSM9Ey1DfUM
 gQwdIwYuTgGY6pZJDH8FEl1f3XvxUHxb6yFekVmzJs1vy/jeGH8/5sP3h3NXS1c/Z/grX9pis2b
 h/BUp1ksS9lpZzqq5yf7n7stDG/1kC9XCjh7iAQA=
X-Developer-Key: i=mailhol@kernel.org; a=openpgp;
 fpr=ED8F700574E67F20E574E8E2AB5FEB886DBB99C2

DPS [1] assigns GPT partition type UUIDs to operating system partitions.
Root partitions use architecture-specific type UUIDs so the OS can
discover the intended root filesystem without relying on a root= cmdline
option.

Define DPS_ROOT_PARTITION_TYPE_UUID in asm/dps_root.h for LoongArch64
and select ARCH_HAS_DPS_ROOT_PARTITION_TYPE_UUID.

[1] The Discoverable Partitions Specification (DPS)
Link: https://uapi-group.org/specifications/specs/discoverable_partitions_specification/

Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: loongarch@lists.linux.dev
Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
---
 arch/loongarch/Kconfig                | 1 +
 arch/loongarch/include/asm/dps_root.h | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index 606597da46b8..64c27740b8a1 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -17,6 +17,7 @@ config LOONGARCH
 	select ARCH_HAS_CPU_FINALIZE_INIT
 	select ARCH_HAS_CURRENT_STACK_POINTER
 	select ARCH_HAS_DEBUG_VM_PGTABLE
+	select ARCH_HAS_DPS_ROOT_PARTITION_TYPE_UUID
 	select ARCH_HAS_FAST_MULTIPLIER
 	select ARCH_HAS_FORTIFY_SOURCE
 	select ARCH_HAS_KCOV
diff --git a/arch/loongarch/include/asm/dps_root.h b/arch/loongarch/include/asm/dps_root.h
new file mode 100644
index 000000000000..6022b60428ad
--- /dev/null
+++ b/arch/loongarch/include/asm/dps_root.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef _ASM_LOONGARCH_DPS_ROOT_H
+#define _ASM_LOONGARCH_DPS_ROOT_H
+
+#define DPS_ROOT_PARTITION_TYPE_UUID "77055800-792c-4f94-b39a-98c91b762bb6"
+
+#endif /* _ASM_LOONGARCH_DPS_ROOT_H */

-- 
2.53.0

