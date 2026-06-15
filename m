Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8173040913C;
	Mon, 15 Jun 2026 16:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781539854; cv=none; b=izbNIM8N1dTpBriHtpfOsZPW4fmzao6OHE4twQQeX0ns3SSCK0+OtOYNvE7DUHjidU8E6vWgM8KiatUPpJIHl3bhp1Ysngfaws6XnMbE1q5GQ6ZrUfu6Bjg3o1YDeuYWciLqjqsuh6bYyIzT9mqyTP4vJ3IUY0IWGQUkpdIbAPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781539854; c=relaxed/simple;
	bh=5YHw8EUONmlZy2eutAm4V6EttATg+v0U1yX80Dbp4rU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jBVG3iRrxzlBZKjnVuiCzQpbYN+jD1HhXct8vOtzNqT66uCknsRDTWW3Z8U2SawvTWvMTL3jgXJNNnJp/FByYMBUtAywpX1gBaq+aZyYzQ3CPUGziBPJZPSt73FXiIacqUT2gLK+8Dlp6QaXB0xX7X4PJBBhOhMbs8z7f3q+8fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E0lt+ubT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E0lt+ubT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC8D21F00A3A;
	Mon, 15 Jun 2026 16:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781539853;
	bh=c/TSOjS4JNuAfZOD2VN45im/LIbFGgPJlORf4/1RDdQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=E0lt+ubTRCw0jNqPKCY0vTugPLNO1dlPYijEppVzICTFEVG4gOkPu3m/vNLZ2e5e2
	 xOAqMwqV6E9DJh+gc3ZHN/aH6E1RJ1aVjPX98iL9pJKHUJricVpOWemqsBKrvhvykR
	 nFfd8o0IMe/EuETkYNSZR3A/uDSdziRUt0WMzy4bYcJft9YeDCZDHw5HwirO7XP/yS
	 A04QPHrrxbkhrXOQ3Nu4C4BITPHbGuZdg8h+pieRRMoWMArIMHCbTQbIvB8I6ukWVl
	 9Jcj7A7vI+IlqE+INVBbK+NaxMFuJw0qa6islp4fNS3ywLSkuPyjRLi2lJxq/ZHWmq
	 Y6kB34VIDa37A==
From: Vincent Mailhol <mailhol@kernel.org>
Date: Mon, 15 Jun 2026 18:09:08 +0200
Subject: [PATCH 12/19] x86: define DPS root partition type UUIDs
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-discoverable-root_partitions-v1-12-39c78fac42e2@kernel.org>
References: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
In-Reply-To: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Davidlohr Bueso <dave@stgolabs.net>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-efi@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Vincent Mailhol <mailhol@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1967; i=mailhol@kernel.org;
 h=from:subject:message-id; bh=5YHw8EUONmlZy2eutAm4V6EttATg+v0U1yX80Dbp4rU=;
 b=owGbwMvMwCV2McXO4Xp97WbG02pJDFkGylcjRZq8+z5PfZOsphQhvrWnUtJeO4wx3cdSqT6Dd
 2uVXmLHRBYGMS4GSzFFlmXlnNwKHYXeYYf+WsLMYWUCGSIt0sAABCwMfLmJeaVGOkZ6ptqGeoZA
 ho4RAxenAEz19FhGhsnZ1nIGkfYnVooabd17ot99asKKfV8Xqn9gnrMxoaybrZeR4VmD4vat/lc
 iys8mWeRE+pofVXtdZPW1NoJv/YEZSjHuPAA=
X-Developer-Key: i=mailhol@kernel.org; a=openpgp;
 fpr=ED8F700574E67F20E574E8E2AB5FEB886DBB99C2

DPS [1] assigns GPT partition type UUIDs to operating system partitions.
Root partitions use architecture-specific type UUIDs so the OS can
discover the intended root filesystem without relying on a root= cmdline
option.

Define DPS_ROOT_PARTITION_TYPE_UUID in asm/dps_root.h for the x86
32/64-bit variants described by the specification and select
ARCH_HAS_DPS_ROOT_PARTITION_TYPE_UUID.

[1] The Discoverable Partitions Specification (DPS)
Link: https://uapi-group.org/specifications/specs/discoverable_partitions_specification/

Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: x86@kernel.org
Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
---
 arch/x86/Kconfig                |  1 +
 arch/x86/include/asm/dps_root.h | 12 ++++++++++++
 2 files changed, 13 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b875d2f27e48..6b6e7b56f972 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -82,6 +82,7 @@ config X86
 	select ARCH_HAS_DEBUG_VM_PGTABLE	if !X86_PAE
 	select ARCH_HAS_DEVMEM_IS_ALLOWED
 	select ARCH_HAS_DMA_OPS			if GART_IOMMU || XEN
+	select ARCH_HAS_DPS_ROOT_PARTITION_TYPE_UUID
 	select ARCH_HAS_EARLY_DEBUG		if KGDB
 	select ARCH_HAS_ELF_RANDOMIZE
 	select ARCH_HAS_EXECMEM_ROX		if X86_64 && STRICT_MODULE_RWX
diff --git a/arch/x86/include/asm/dps_root.h b/arch/x86/include/asm/dps_root.h
new file mode 100644
index 000000000000..7c6ba5519d88
--- /dev/null
+++ b/arch/x86/include/asm/dps_root.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef _ASM_X86_DPS_ROOT_H
+#define _ASM_X86_DPS_ROOT_H
+
+#ifdef CONFIG_X86_64
+#define DPS_ROOT_PARTITION_TYPE_UUID "4f68bce3-e8cd-4db1-96e7-fbcaf984b709"
+#else
+#define DPS_ROOT_PARTITION_TYPE_UUID "44479540-f297-41b2-9af7-d131d5f0458a"
+#endif
+
+#endif /* _ASM_X86_DPS_ROOT_H */

-- 
2.53.0

