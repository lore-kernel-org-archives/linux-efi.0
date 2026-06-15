Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B64540B36B;
	Mon, 15 Jun 2026 16:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781539821; cv=none; b=ozCSpCq8Z8ee2t9V0dcI6bc7DLMZnIvhvUHDfHYguZBzJz8WG/LDgXeoUJKgltwV0OkAE7w9WTNJ9l/lYmOcFBa621RjIy6CtlEtXUfKHV8Qp9ltD5KBS5XfgTv8ZNKiNlq17TwoJKxYbkzxP0UUm/Z7w/dk+nwo96kABTaYWDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781539821; c=relaxed/simple;
	bh=9rZS9bTuDmSM/994XMcxvjwv7RdqUU6T4byJTl6W7zg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=D8HSH6V6pp6XOfRNC7Y16Nk1nlE9HlWrTc4hABEYrCyxrDiU4GRqUJTeMZIAQ3DkDINZGcLil/HMTUN/RFAY2kvkjpaJuGz+NR7Cc/G5OHhd2VH1uvLOH4Lx77cBpR4F4GvpiYUBBNM5QEBIh9vgAg/iboeRxTIZhRJlpjkCO6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OUEma+3u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OUEma+3u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5681F000E9;
	Mon, 15 Jun 2026 16:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781539820;
	bh=b7O/iX8ZXf9+ETUEbNQJOgOfGswd15/Oz6mytb/pT90=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OUEma+3u83c0WZamH6riqLuFbxXAAGPEndgpJDLcE658tAQHZIq4NRTbExHLaQwct
	 /2VbAphR70z01LnEPwK7lDSR+h43fx5Xl6kri8wEPa4AL9DiRXljNc9c06nABkeuya
	 IUaqGmP3F5mq6FQD2YzvjrhJiJWUQFX2zbBGP4mtOvMz5GOXPt8s50Fii1GIL0+Igl
	 Gs++T/pi8dYU71N08stJBdTa39iWDjglW+Gf3hAJIASZnT59rO/kALPOSSanq8R3Rw
	 aQiqegpypPj2cevXkyInQB24AWfW0UpuCKsEJ5NSWce/K4V8Vt2Ckr5xuM5QCqbPG1
	 OsPd7fpJBcGwQ==
From: Vincent Mailhol <mailhol@kernel.org>
Date: Mon, 15 Jun 2026 18:08:59 +0200
Subject: [PATCH 03/19] arc: define DPS root partition type UUID
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-discoverable-root_partitions-v1-3-39c78fac42e2@kernel.org>
References: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
In-Reply-To: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Davidlohr Bueso <dave@stgolabs.net>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-efi@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Vincent Mailhol <mailhol@kernel.org>, Vineet Gupta <vgupta@kernel.org>, 
 linux-snps-arc@lists.infradead.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1623; i=mailhol@kernel.org;
 h=from:subject:message-id; bh=9rZS9bTuDmSM/994XMcxvjwv7RdqUU6T4byJTl6W7zg=;
 b=owGbwMvMwCV2McXO4Xp97WbG02pJDFkGylfOr9WS7LkdJiZTzfFVbGmu/r1LoW3n/ywOtip+H
 NRz+nRqx0QWBjEuBksxRZZl5ZzcCh2F3mGH/lrCzGFlAhkiLdLAAAQsDHy5iXmlRjpGeqbahnqG
 QIaOEQMXpwBMtXEzw1+piq9LVmXN229V/c7kw1a9LYzC6zktVHj1Iu5OCk/trMhjZFj1vLVi1l3
 3rHAGsdN/ky3ZZ3L/zrq6+/r2M7MrjBflXGUGAA==
X-Developer-Key: i=mailhol@kernel.org; a=openpgp;
 fpr=ED8F700574E67F20E574E8E2AB5FEB886DBB99C2

DPS [1] assigns GPT partition type UUIDs to operating system partitions.
Root partitions use architecture-specific type UUIDs so the OS can
discover the intended root filesystem without relying on a root= cmdline
option.

Define DPS_ROOT_PARTITION_TYPE_UUID in asm/dps_root.h for ARC and select
ARCH_HAS_DPS_ROOT_PARTITION_TYPE_UUID.

[1] The Discoverable Partitions Specification (DPS)
Link: https://uapi-group.org/specifications/specs/discoverable_partitions_specification/

Cc: Vineet Gupta <vgupta@kernel.org>
Cc: linux-snps-arc@lists.infradead.org
Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
---
 arch/arc/Kconfig                | 1 +
 arch/arc/include/asm/dps_root.h | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index 2ed7186c81c5..cc3a57a0111f 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -10,6 +10,7 @@ config ARC
 	select ARCH_HAS_CACHE_LINE_SIZE
 	select ARCH_HAS_DEBUG_VM_PGTABLE
 	select ARCH_HAS_DMA_PREP_COHERENT
+	select ARCH_HAS_DPS_ROOT_PARTITION_TYPE_UUID
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_SETUP_DMA_OPS
 	select ARCH_HAS_SYNC_DMA_FOR_CPU
diff --git a/arch/arc/include/asm/dps_root.h b/arch/arc/include/asm/dps_root.h
new file mode 100644
index 000000000000..c9db3ddf1a53
--- /dev/null
+++ b/arch/arc/include/asm/dps_root.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef _ASM_ARC_DPS_ROOT_H
+#define _ASM_ARC_DPS_ROOT_H
+
+#define DPS_ROOT_PARTITION_TYPE_UUID "d27f46ed-2919-4cb8-bd25-9531f3c16534"
+
+#endif /* _ASM_ARC_DPS_ROOT_H */

-- 
2.53.0

