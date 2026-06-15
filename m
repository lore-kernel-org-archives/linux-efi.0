Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C459A33F598
	for <linux-efi@vger.kernel.org>; Mon, 15 Jun 2026 23:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781566128; cv=none; b=pcYAlgIbpSkUVQBetNLM32bPo5FMCKDncJeJgmIO75gS7eUOb4vr2g+y+QV2Vqwx7c21tTwXux9h2a5FgM98t9NGCs/ycz+AtVm8mVpK0RVJPDrbWVnDwB/CVuTdsDqjLf/STP3wdZt0VQViEFYZiqOA+kWiDBny724MmP2TmGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781566128; c=relaxed/simple;
	bh=reMArt3H78H+Qxsn/bUuLgYmBqTX/c+i3s4SiDQSd/8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Y17gTTf5si+hkq9XeFAWBl1J247HikMnuDGV3d2fVxG2J798wliBMwQ7fsLZjgpS16NCkDr9K6vZFv2FvO+CDUcWWozF0jRV2p2ulYUgGiCAlKmE/8KRh8W7C04VmiGVgrTEVYOUhQ4lX6/jBhjvUuGoa88GutaTMZ/0A3hmtHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QI7Xs72A; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QI7Xs72A"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781566124;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dY5mBb64gTkFKsOa15ef2GQOxLaHZRK6NOzG/t/3yRw=;
	b=QI7Xs72Azf722gJqQ9cxaQjtSQ2xaEoF0Yx9/zYgWZ8cg8CSmHYZ/3MUQeOVl4iXFWi5rw
	4IfbQ2o/aGn2LnsoR+uitpfCW3KKYR5oOUjhrewjn2yrumkeugfkJDGJXQKJsrpTNcc4iU
	IT3vfho4jKUK/5WGfOlwilLILY/zboQ=
From: Atish Patra <atish.patra@linux.dev>
Date: Mon, 15 Jun 2026 16:28:22 -0700
Subject: [PATCH 2/2] riscv: Restart via EFI runtime services when available
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-efi_reset_shutdown-v1-2-9414edcbbab0@meta.com>
References: <20260615-efi_reset_shutdown-v1-0-9414edcbbab0@meta.com>
In-Reply-To: <20260615-efi_reset_shutdown-v1-0-9414edcbbab0@meta.com>
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
 Atish Patra <atish.patra@linux.dev>
Cc: linux-efi@vger.kernel.org, linux-riscv@lists.infradead.org, 
 linux-kernel@vger.kernel.org, Atish Patra <atishp@meta.com>
X-Migadu-Flow: FLOW_OUT

From: Atish Patra <atishp@meta.com>

Firmware-preferred reset and EFI capsule update support requires reset
via EFI runtime services rather than direction M-mode firmware invocation
via SBI. Unlike poweroff, restart mechanism is directly controlled from
machine_restart function though.

Prefer the EFI runtime ResetSystem() service for restart when UEFI
runtime services are available.

Signed-off-by: Atish Patra <atishp@meta.com>
---
 arch/riscv/kernel/reset.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/riscv/kernel/reset.c b/arch/riscv/kernel/reset.c
index 912288572226..541e2162c85a 100644
--- a/arch/riscv/kernel/reset.c
+++ b/arch/riscv/kernel/reset.c
@@ -3,6 +3,7 @@
  * Copyright (C) 2012 Regents of the University of California
  */
 
+#include <linux/efi.h>
 #include <linux/reboot.h>
 #include <linux/pm.h>
 
@@ -17,6 +18,12 @@ EXPORT_SYMBOL(pm_power_off);
 
 void machine_restart(char *cmd)
 {
+	/*
+	 * UpdateCapsule() depends on the system being reset via ResetSystem().
+	 */
+	if (efi_enabled(EFI_RUNTIME_SERVICES))
+		efi_reboot(reboot_mode, NULL);
+
 	do_kernel_restart(cmd);
 	while (1);
 }

-- 
2.53.0-Meta

