Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B811358388;
	Fri,  3 Jul 2026 10:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783072945; cv=none; b=naTVsvxQEOGWAPHSffmV7Lm7CPag5vecbPqv2jUFWPLpRA1005YFUrMmokDRpXq30EOtxrB1yahT17OY92x5qpGNGLGhZ8V5mqnSPbcjtR8BoAEB7tJr94L2u3LrCVHFy1WO4N3uY5GlRt3tOc9+ReXvX2HZYdK7XJX36i6Vfq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783072945; c=relaxed/simple;
	bh=48mdkA37dTy8784W7L9yLGxdd9aNk5qQK+Ij+77ual4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=D6JThRWZetUJr6C1zr9ywb/wog8mmp5Gi37dYOghSWzA2Eugq7GybbFNacpniEvfFrRP3AgPJVj7ntqJVSotjBGl6AuFravEZfHsG747cYjik0SCdtZEsbbwaQo1+2cI7ijRdyeT4VHrZv17gxkTxeg9rHmpZoT58BjJ3/iMsas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=VTHrluJO; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="VTHrluJO"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=+Be4tamqNPytL0DlmMhHstiAdEjMJ3KYct4tTEDAvpQ=;
	b=VTHrluJOOle+Ae3JMHD/J98W7USvFa5ZhBV07q33gTWT38NDnRoeqx/whESEPj+t9PtnB7Nk1
	LZTFTSeUF4sDuXS0W2YLq68pWgvr1SgBq7oCFHTMsFh8l7tsqguh4UaUVv5QnzofzdIxskFYf87
	bjQi0cY4kY+ISCFsNX0xwsQ=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4gs8Fr4HkmzcZyF;
	Fri,  3 Jul 2026 17:53:20 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id A78AA2012A;
	Fri,  3 Jul 2026 18:02:14 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 3 Jul
 2026 18:02:10 +0800
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
Subject: [PATCH 00/17] arm64: Support FEAT_NMI and Rework Exception Masking
Date: Fri, 3 Jul 2026 18:01:18 +0800
Message-ID: <20260703100135.2512312-1-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
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

Hi all,

This patch series implements support for the ARMv8.8-A/v9.3-A
hardware NMI extension (FEAT_NMI), introducing the use of PSTATE.ALLINT
to manage superpriority interrupts on arm64.

Background and Current Status
-----------------------------

The hardware ecosystem is already mature and fully ready for FEAT_NMI:

- Production Hardware: Huawei's Kunpeng servers (such as the HIP12 based
  platforms) already feature native hardware support for FEAT_NMI.

- Emulation: QEMU has integrated robust FEAT_NMI emulation[1] support
  since 2024.

Despite the hardware readiness, upstream support for FEAT_NMI has been
delayed. Previous patch[2] attempts tried to bundle ALLINT management
directly into the existing DAIF abstraction layers. As Mark Rutland
pointed out[3], pretending ALLINT or pseudo-NMI (GIC PMR) is part of
DAIF creates convoluted, unmaintainable hacks that frequently fail to
handle complex edge cases correctly (such as state escape during
context switching).

Reworking Exception Masking (Mark's Feedback)
---------------------------------------------

Following Mark Rutland's strong recommendation ("We must clean up
the existing approach before we add the real NMI support"), this series
does not simply stack FEAT_NMI on top of the old framework. Instead, it
completely reworks how the arm64 kernel manages abstract and logical
exception masks.

Per Mark's guidelines, this series achieves the following architectural
improvements:

1. Entry/Exit Specific Helpers (a):

   Introduces abstract exception mask helpers specifically for exception
   boundaries. They handle unified unmask-at-entry and mask-at-exit
   behaviors. This decouples the entry/exit paths from raw DAIF
   manipulation. In this series, these helpers are first refactored to
   manage DAIF + PMR cleanly, preparing the ground before any FEAT_NMI
   code is introduced.

2. Logical Exception Mask Separation (b):

   Introduces a decoupled logical mask tracking mechanism that treats DAIF,
   PMR, and ALLINT as separate, distinct elements. This enables accurate
   irqflag tracking and debug assertions to save, restore, and validate all
   elements without forcing them to fake or pollute a traditional DAIF
   layout.

Production Bug Fixes & Integration
-----------------------------------

On top of this solid architectural foundation, this series adds the actual
support for FEAT_NMI (ALLINT management). Crucially, during baisc testing
and validation on production Kunpeng (HIP12) servers, we identified and
resolved several critical bugs.

The series is structured as follows:

- Patches 1-5: Clean up and rework the existing DAIF/PMR masking into
  separate logical exception helpers (Pre-requisite refactoring).

- Patches 6-17: Add FEAT_NMI support for ARM64, including specific
  stability fixes found on Kunpeng hardware and QEmu.

Any feedback, testing, or review, especially regarding the exception
masking refactoring, is highly appreciated.

[1]: https://lore.kernel.org/all/20240407081733.3231820-1-ruanjinjie@huawei.com/
[2]: https://lore.kernel.org/linux-arm-kernel/20221112151708.175147-1-broonie@kernel.org/
[3]: https://lore.kernel.org/linux-arm-kernel/Y5c9SLeJacLYHmP7@FVFF77S0Q05N/

Jinjie Ruan (5):
  arm64: Move DAIF macros to ptrace.h and use them centrally
  arm64: Rework exception masking into abstract logical mask
  arm64: entry: arm64: entry: Move DAIF masking for EL1 exit to C code
  arm64: entry: Add entry-specific helpers
  arm64: Introduce helpers for restoring standard exception masks

Lorenzo Pieralisi (1):
  irqchip/gic-v3: Implement FEAT_GICv3_NMI support

Mark Brown (11):
  arm64/booting: Document boot requirements for FEAT_NMI
  arm64/sysreg: Add definitions for immediate versions of MSR ALLINT
  arm64/hyp-stub: Enable access to ALLINT
  arm64/idreg: Add an override for FEAT_NMI
  arm64/cpufeature: Detect PE support for FEAT_NMI
  KVM: arm64: Hide FEAT_NMI from guests
  arm64/nmi: Manage masking for superpriority interrupts along with DAIF
  arm64/entry: Don't call preempt_schedule_irq() with NMIs masked
  arm64/irq: Document handling of FEAT_NMI in irqflags.h
  arm64/nmi: Add handling of superpriority interrupts as NMIs
  arm64/nmi: Add Kconfig for NMI

 Documentation/arch/arm64/booting.rst     |   6 +
 arch/arm64/Kconfig                       |  17 ++
 arch/arm64/include/asm/arch_gicv3.h      |   7 +-
 arch/arm64/include/asm/assembler.h       |  17 +-
 arch/arm64/include/asm/cpufeature.h      |   5 +
 arch/arm64/include/asm/cpuidle.h         |  30 ++-
 arch/arm64/include/asm/daifflags.h       | 144 --------------
 arch/arm64/include/asm/efi.h             |  22 ++-
 arch/arm64/include/asm/el2_setup.h       |  13 ++
 arch/arm64/include/asm/entry-common.h    |  11 +-
 arch/arm64/include/asm/exception_masks.h | 232 +++++++++++++++++++++++
 arch/arm64/include/asm/irq.h             |   2 +
 arch/arm64/include/asm/irqflags.h        |  10 +
 arch/arm64/include/asm/kvm_host.h        |   2 +-
 arch/arm64/include/asm/mmu_context.h     |   2 +-
 arch/arm64/include/asm/nmi.h             |  23 +++
 arch/arm64/include/asm/ptrace.h          |  11 +-
 arch/arm64/include/asm/sysreg.h          |   2 +
 arch/arm64/include/uapi/asm/ptrace.h     |   1 +
 arch/arm64/kernel/acpi.c                 |  14 +-
 arch/arm64/kernel/cpufeature.c           |  58 +++++-
 arch/arm64/kernel/debug-monitors.c       |   9 +-
 arch/arm64/kernel/entry-common.c         | 167 +++++++++++-----
 arch/arm64/kernel/entry.S                |   4 -
 arch/arm64/kernel/hibernate.c            |  10 +-
 arch/arm64/kernel/idle.c                 |   7 +-
 arch/arm64/kernel/irq.c                  |  36 +++-
 arch/arm64/kernel/machine_kexec.c        |   4 +-
 arch/arm64/kernel/pi/idreg-override.c    |   1 +
 arch/arm64/kernel/probes/kprobes.c       |   9 +-
 arch/arm64/kernel/process.c              |   7 +-
 arch/arm64/kernel/setup.c                |   4 +-
 arch/arm64/kernel/signal.c               |   2 +-
 arch/arm64/kernel/smp.c                  |  22 +--
 arch/arm64/kernel/suspend.c              |  15 +-
 arch/arm64/kernel/traps.c                |   2 +-
 arch/arm64/kvm/emulate-nested.c          |   6 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h  |   6 +
 arch/arm64/kvm/hyp/nvhe/host.S           |   4 +-
 arch/arm64/kvm/hyp/nvhe/hyp-init.S       |   3 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c       |   4 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c          |   6 +-
 arch/arm64/kvm/hyp/vhe/switch.c          |   6 +-
 arch/arm64/kvm/reset.c                   |   6 +-
 arch/arm64/mm/fault.c                    |   2 +-
 arch/arm64/mm/mmu.c                      |   6 +-
 arch/arm64/tools/cpucaps                 |   2 +
 drivers/firmware/psci/psci.c             |   7 +-
 drivers/irqchip/irq-gic-v3.c             | 152 +++++++++++++--
 include/linux/irqchip/arm-gic-v3.h       |   4 +
 50 files changed, 822 insertions(+), 320 deletions(-)
 delete mode 100644 arch/arm64/include/asm/daifflags.h
 create mode 100644 arch/arm64/include/asm/exception_masks.h
 create mode 100644 arch/arm64/include/asm/nmi.h

-- 
2.34.1

