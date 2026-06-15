Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40B940F8C4;
	Mon, 15 Jun 2026 16:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781539839; cv=none; b=YxVqtSpPVKg3ErHDgSdZ+/B27fgcnugWkl2NStAYIW0hC6npaoVYgotFpUa6MnhZhAn7w5MSaJvzd9uAnBWy/Skmkgg3LUfKERAnZ6zhdxtOE9zB6qvvdybCuaEtYlqXX0sPltiLi33xviGXP+Tn8PNZ0vVhkHc3E1x1I7djNUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781539839; c=relaxed/simple;
	bh=zCQNo0mFWp1Ik78AWhFmdJEveXdTYRwYKGYyIZlM2m0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=USKzz8BK6yW6iOkrJcwndXD4l53GVfVoPs5NBnAZQpLKr4WgKDUIANe1ruHvwgBC1S6+sZu/vqTcymnHmA/h9dxW59/n5Mpo2pn63qvfyUMvo+c7LjhmHvRB4g1Vqwu8p1ffO5qC7qkj6FzalpsZ9Dyczb7UR0MU4JmCbWEvFOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y3F5bVLq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y3F5bVLq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A26B11F00A3A;
	Mon, 15 Jun 2026 16:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781539837;
	bh=GC92LA2kah7nnUE/1p17c3ITWAloVGyasq5KAp2YPTE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Y3F5bVLq5pzOB/IDnjTXhTYr6PZwHPR1CBSuaH1OO/6T4tDvh/LzYgJ1Dlg96HbgB
	 mtyLJQaeqg1jWg5m5kK5hIw7NIRVlHiYPgnsTwUcT4Z1sKF7pH9Fha5Rnx4/bBDGVE
	 XGpd9R1Ttwqhjn+7h3kzBtrcYUiRik+31AS9tNo4cfWJ8eg91teimvJoe3Ju2ZVR96
	 9N5kalKJtVwmJKjhGxSAryFRzouCRQRQA2QJawrbOfyn7SEcT3otOq18qKFQZ/FfR/
	 6t211dai2BLxwMomrAweKktYVxOTmT1tj59ZEa1XLk1pvIW+bkmLFrjmtjx73waFEa
	 xaASllzqrhxmg==
From: Vincent Mailhol <mailhol@kernel.org>
Date: Mon, 15 Jun 2026 18:09:04 +0200
Subject: [PATCH 08/19] parisc: define DPS root partition type UUID
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-discoverable-root_partitions-v1-8-39c78fac42e2@kernel.org>
References: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
In-Reply-To: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Davidlohr Bueso <dave@stgolabs.net>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-efi@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Vincent Mailhol <mailhol@kernel.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1692; i=mailhol@kernel.org;
 h=from:subject:message-id; bh=zCQNo0mFWp1Ik78AWhFmdJEveXdTYRwYKGYyIZlM2m0=;
 b=owGbwMvMwCV2McXO4Xp97WbG02pJDFkGyle5PJ1fmfRt8jjzMK/1n7ZOUqy6u+oN+TU7mDeoF
 W/e47O5YyILgxgXg6WYIsuyck5uhY5C77BDfy1h5rAygQyRFmlgAAIWBr7cxLxSIx0jPVNtQz1D
 IEPHiIGLUwCm+s1jRobO0nzNJvckjz0/ampyst6vlZqwcF7kkU9OBfmdHfdshI4zMkziZ6n7EmT
 WcF458viMcyIFj21PzOyucY/tePCcfffpMk4A
X-Developer-Key: i=mailhol@kernel.org; a=openpgp;
 fpr=ED8F700574E67F20E574E8E2AB5FEB886DBB99C2

DPS [1] assigns GPT partition type UUIDs to operating system partitions.
Root partitions use architecture-specific type UUIDs so the OS can
discover the intended root filesystem without relying on a root= cmdline
option.

Define DPS_ROOT_PARTITION_TYPE_UUID in asm/dps_root.h for parisc and
select ARCH_HAS_DPS_ROOT_PARTITION_TYPE_UUID.

[1] The Discoverable Partitions Specification (DPS)
Link: https://uapi-group.org/specifications/specs/discoverable_partitions_specification/

Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org
Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
---
 arch/parisc/Kconfig                | 1 +
 arch/parisc/include/asm/dps_root.h | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index d3afac2f0d9b..94f0a758176a 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -24,6 +24,7 @@ config PARISC
 	select ARCH_STACKWALK
 	select ARCH_HAS_CACHE_LINE_SIZE
 	select ARCH_HAS_DEBUG_VM_PGTABLE
+	select ARCH_HAS_DPS_ROOT_PARTITION_TYPE_UUID
 	select HAVE_RELIABLE_STACKTRACE
 	select RTC_CLASS
 	select RTC_DRV_GENERIC
diff --git a/arch/parisc/include/asm/dps_root.h b/arch/parisc/include/asm/dps_root.h
new file mode 100644
index 000000000000..bf475cd5b01c
--- /dev/null
+++ b/arch/parisc/include/asm/dps_root.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef _ASM_PARISC_DPS_ROOT_H
+#define _ASM_PARISC_DPS_ROOT_H
+
+#define DPS_ROOT_PARTITION_TYPE_UUID "1aacdb3b-5444-4138-bd9e-e5c2239b2346"
+
+#endif /* _ASM_PARISC_DPS_ROOT_H */

-- 
2.53.0

