Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC803B71A4;
	Fri,  3 Jul 2026 10:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783072950; cv=none; b=F/xcX1mdUsGYC90Npb0P4u7FeUu5/ijXgvYSu0R7mHzbompyh2vLiL30L0zAFmszEZ7mVDkMOJIdJ8CB7Bj3aINXb/fHyAlCcuO1IjW3fs0xuPlXk/VOoH0Zd2+KgQkSb+XxNWspfr8jjLbfLG3hbR15h+RPVUDv1MyS7GrDdt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783072950; c=relaxed/simple;
	bh=032/ARW3S+uTYXJQvj4l/1JT7V1vuUzRgbkrInblA9U=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JUaROtXeLjnkPTKxT51n7AI7NxmdH6Ui9iZZyceGd3bW6nnCNATgKydOXgMPccneXOCI6n4aDJ0HyjXq2YHh2Okz9joV2REoMUpHtxYv8PUR4KQIOuMaQSgZwkT1l8WgE1pi5VAE7ZL6GDNU/TPFhXxZ/o2nZ5g/wYjsAmCN4dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=dJLCxaMM; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="dJLCxaMM"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=m9R38XtJrQtsn4NIrQT2WoM7Q3dBIYtavm6X0wJ2GFM=;
	b=dJLCxaMMpv5Bq6aEao5m1OP3xEQ4vb/uFkDH0iYO16Z9eF3bP7kGJTcRimw1x1KOAn5DmqpEw
	kKI+BS7vx0EjyJBKvADeopbmspciaDImE0zeUaP2oU6DM9ikyPQG0eT6ZkJ2Ov9P5b0HAw/iqS0
	hMmdf9IjhOivQP31P6KO9rU=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4gs8Fk20ThzmVWQ;
	Fri,  3 Jul 2026 17:53:14 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 6541D4058B;
	Fri,  3 Jul 2026 18:02:25 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 3 Jul
 2026 18:02:21 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <corbet@lwn.net>,
	<skhan@linuxfoundation.org>, <maz@kernel.org>, <ardb@kernel.org>,
	<ilias.apalodimas@linaro.org>, <oupton@kernel.org>, <joey.gouly@arm.com>,
	<seiden@linux.ibm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<oleg@redhat.com>, <mark.rutland@arm.com>, <lpieralisi@kernel.org>,
	<tglx@kernel.org>, <ada.coupriediaz@arm.com>, <anshuman.khandual@arm.com>,
	<ruanjinjie@huawei.com>, <ebiggers@kernel.org>, <broonie@kernel.org>,
	<mrigendra.chaubey@gmail.com>, <baohua@kernel.org>, <lucaswei@google.com>,
	<james.morse@arm.com>, <zengheng4@huawei.com>, <thuth@redhat.com>,
	<yang@os.amperecomputing.com>, <leo.bras@arm.com>, <Sascha.Bischoff@arm.com>,
	<james.clark@linaro.org>, <peterz@infradead.org>, <leitao@debian.org>,
	<ben.horgan@arm.com>, <punit.agrawal@oss.qualcomm.com>, <gshan@redhat.com>,
	<osama.abdelkader@gmail.com>, <fengchengwen@huawei.com>,
	<ryan.roberts@arm.com>, <yangyicong@hisilicon.com>, <kevin.brodsky@arm.com>,
	<kees@kernel.org>, <jeson.gao@unisoc.com>, <zhaoyang.huang@unisoc.com>,
	<ryotkkr98@gmail.com>, <wsw9603@163.com>, <pasha.tatashin@soleen.com>,
	<jeremy.linton@arm.com>, <schuster.simon@siemens-energy.com>,
	<osandov@fb.com>, <arnd@arndb.de>, <zhangpengjie2@huawei.com>,
	<smostafa@google.com>, <vladimir.murzin@arm.com>, <tabba@google.com>,
	<vdonnefort@google.com>, <kaleshsingh@google.com>, <jic23@kernel.org>,
	<timothy.hayes@arm.com>, <alexandru.elisei@arm.com>, <zenghui.yu@linux.dev>,
	<david@kernel.org>, <akpm@linux-foundation.org>, <ljs@kernel.org>,
	<memxor@gmail.com>, <qperret@google.com>, <chaitanyas.prakash@arm.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-efi@vger.kernel.org>,
	<kvmarm@lists.linux.dev>
Subject: [PATCH 03/17] arm64: entry: arm64: entry: Move DAIF masking for EL1 exit to C code
Date: Fri, 3 Jul 2026 18:01:21 +0800
Message-ID: <20260703100135.2512312-4-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260703100135.2512312-1-ruanjinjie@huawei.com>
References: <20260703100135.2512312-1-ruanjinjie@huawei.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf500011.china.huawei.com (7.185.36.131)

Move the DAIF masking logic on exception exit from the assembly
macro kernel_exit into the respective EL1 C handler functions.

Originally, when returning to a privileged mode (el != 0), kernel_exit
invoked the disable_daif macro ("msr daifset, #0xf") to ensure that the
subsequent registers and PMR state restoration occurred with all local
interrupts fully masked.

Move the DAIF masking out of the assembly macro and into the individual
C exception handlers, immediately after the core handler logic.
Specifically, add `write_sysreg(DAIF_MASK, daif)` at the end of:

- el1h_64_sync_handler().
- el1_interrupt().
- el1h_64_error_handler).

We achieve identical masking behavior before entering the low-level
assembly exit path.

This change cleans up the assembly macro and consolidates the exception
lifecycle management in C code.

No functional change intended.

Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/arm64/include/asm/assembler.h | 4 ----
 arch/arm64/kernel/entry-common.c   | 5 +++++
 arch/arm64/kernel/entry.S          | 4 ----
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index effae53e9739..0b58b550e8dc 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -34,10 +34,6 @@
 	wx\n	.req	w\n
 	.endr
 
-	.macro disable_daif
-	msr	daifset, #0xf
-	.endm
-
 /*
  * Save/restore interrupts.
  */
diff --git a/arch/arm64/kernel/entry-common.c b/arch/arm64/kernel/entry-common.c
index 195af3f8001e..6fdf74ff4835 100644
--- a/arch/arm64/kernel/entry-common.c
+++ b/arch/arm64/kernel/entry-common.c
@@ -486,6 +486,8 @@ asmlinkage void noinstr el1h_64_sync_handler(struct pt_regs *regs)
 	default:
 		__panic_unhandled(regs, "64-bit el1h sync", esr);
 	}
+
+	write_sysreg(DAIF_MASK, daif);
 }
 
 static __always_inline void __el1_pnmi(struct pt_regs *regs,
@@ -520,6 +522,8 @@ static void noinstr el1_interrupt(struct pt_regs *regs,
 		__el1_pnmi(regs, handler);
 	else
 		__el1_irq(regs, handler);
+
+	write_sysreg(DAIF_MASK, daif);
 }
 
 asmlinkage void noinstr el1h_64_irq_handler(struct pt_regs *regs)
@@ -541,6 +545,7 @@ asmlinkage void noinstr el1h_64_error_handler(struct pt_regs *regs)
 	state = irqentry_nmi_enter(regs);
 	do_serror(regs, esr);
 	irqentry_nmi_exit(regs, state);
+	write_sysreg(DAIF_MASK, daif);
 }
 
 static void noinstr el0_da(struct pt_regs *regs, unsigned long esr)
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index e0db14e9c843..f63049ac32dc 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -333,10 +333,6 @@ alternative_else_nop_endif
 	.endm
 
 	.macro	kernel_exit, el
-	.if	\el != 0
-	disable_daif
-	.endif
-
 #ifdef CONFIG_ARM64_PSEUDO_NMI
 alternative_if_not ARM64_HAS_GIC_PRIO_MASKING
 	b	.Lskip_pmr_restore\@
-- 
2.34.1

