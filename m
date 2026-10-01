Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15D024E9C02;
	Thu,  1 Oct 2026 11:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790852849; cv=none; b=aZr4aV8DjVZGBh63LiFkIKRSWQS7C8pEo7jC4K9rlZfY5Kw+tDZV59vQkHmwP1U3kInfX2i8VBWg2+NavuPj9qyw1x/xpliNmEPExyhkuEtQwK6qtx4aiOCUHiadIFe5YvL7o1BU/d/jBuBj1i+mcaaVJA/LPnQYOz4ps0pJjn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790852849; c=relaxed/simple;
	bh=4DAiayNigTX+g+3g54tMOjDfHo5LSjI4E5QwkB1TMt8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Sb+O2xYwFHK+btGeFbEZKDfqqHZkFfd/TQhbSoE031G3bKbTiaRnQC87r/mt8+k1mjn+l8eS1G4yZMIiVV+wLFRTVAUVuuB7IE5Krbe0KNx0ofVWl5nv0ZZy9QMbo6ePAIWy8OxtiW/dw+rHhiO6dKiEIXjR/0dm0RKPcykFsQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SEqbRqgr; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SEqbRqgr"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EF42A497;
	Thu,  1 Oct 2026 04:07:22 -0700 (PDT)
Received: from e142392.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C2D2C3F86F;
	Thu,  1 Oct 2026 04:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790852846; bh=4DAiayNigTX+g+3g54tMOjDfHo5LSjI4E5QwkB1TMt8=;
	h=From:To:Cc:Subject:Date:From;
	b=SEqbRqgr7Bz+660L1PCMbE8pEbH+yVGsLlw5/TUkc5VwETrtJn6CmW4YF7beKF14p
	 c5OJ8EJID75s14rq1YkXHLWwROvttTARh7Wx3BMQ8iUhi3T0p3mrJP+2kAdoAw4ilH
	 PIzHvnnvNV9qlJG5latOLHXa/5+9amrEMabHoYbQ=
From: =?UTF-8?q?Kristina=20Mart=C5=A1enko?= <kristina.martsenko@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-acpi@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-efi@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Hanjun Guo <guohanjun@huawei.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: [RFC 00/12] arm64: Add support for TLBI domains
Date: Thu,  1 Oct 2026 12:06:43 +0100
Message-ID: <20261001110655.461473-1-kristina.martsenko@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

This series allows the kernel to use TLBI domains. TLBI domains (FEAT_TLBID) is
an Arm architecture feature that enables a TLB invalidation to target a subset
of CPUs instead of the whole system. It can improve performance on systems with
many CPUs. TLBID is not yet part of the Arm Architecture Reference Manual but
some of it is described in the latest XML [1].

The goal of this series is to send TLBI commands only to the CPUs where a
process has run (i.e. where its page tables have been installed). The last
patch explains a bit about how it works. This is an RFC since I'm not familiar
with the kernel's TLB/mm code and I'd like feedback on whether the general
approach is correct.

A few notes and open questions:

  * Domains are described in a new "TLBI" ACPI table. This is not yet part of
    the ACPI specification. There was an initial proposal [2] but this series
    uses a newer WIP version of the table that aims to be published by the end
    of the year.

  * There is currently no device tree binding since the feature is mainly meant
    for server-class systems.

  * It's also possible to use TLBI domains to limit a KVM guest's TLB
    invalidations to CPUs where the guest has run. I'll try to include that in
    the next version. This series only disables domains for guests.

  * With this series a long-running process may eventually run on all CPUs and
    just issue broadcast TLBIs. It may be worth periodically reducing the set
    of CPUs but it's not clear when.

  * There are currently no performance numbers since there is no hardware with
    this feature yet.

  * The series has been tested on an Arm FVP which supports the TLBID
    architecture but does not have any domains (except domain 0).

Any feedback is welcome.

Thanks,
Kristina

[1] https://support.arm.com/architectures/a-profile-architecture#Downloads
[2] https://github.com/tianocore/edk2/issues/11999


Kristina Martšenko (12):
  arm64: sysreg: Add definitions for FEAT_TLBID
  arm64: Detect FEAT_TLBID
  KVM: arm64: Hide TLBID from guest sysregs
  KVM: arm64: Hide TLBID from guest instructions
  ACPICA: Add TLBI table definition
  ACPI: TLBI: Parse domains from table
  arm64: tlbid: Set up CPU domain bitmaps
  efi/arm: Check return value of init_new_context()
  arm64: tlbid: Track the TLBI domain of a task
  arm64: Support TLBIP instructions
  arm64: tlbid: Pass domain to TLBI instructions
  arm64: tlbid: Add documentation

 Documentation/arch/arm64/booting.rst    |  10 ++
 arch/arm64/Kconfig                      |  12 ++
 arch/arm64/include/asm/acpi.h           |  10 ++
 arch/arm64/include/asm/cpu.h            |   1 +
 arch/arm64/include/asm/cpufeature.h     |  15 ++
 arch/arm64/include/asm/el2_setup.h      |  76 +++++++-
 arch/arm64/include/asm/kvm_emulate.h    |   5 +
 arch/arm64/include/asm/mmu.h            |  13 ++
 arch/arm64/include/asm/mmu_context.h    |   9 +-
 arch/arm64/include/asm/tlbflush.h       | 219 +++++++++++++++++-------
 arch/arm64/kernel/cpufeature.c          |  25 +++
 arch/arm64/kernel/cpuinfo.c             |   3 +
 arch/arm64/kvm/config.c                 |   6 +
 arch/arm64/kvm/emulate-nested.c         |   1 +
 arch/arm64/kvm/hyp/include/hyp/switch.h |   7 +-
 arch/arm64/kvm/hyp/nvhe/tlb.c           |   2 +-
 arch/arm64/kvm/hyp/vhe/tlb.c            |   4 +-
 arch/arm64/kvm/sys_regs.c               |   3 +
 arch/arm64/mm/Makefile                  |   1 +
 arch/arm64/mm/context.c                 |   6 +-
 arch/arm64/mm/tlbid.c                   | 210 +++++++++++++++++++++++
 arch/arm64/tools/cpucaps                |   1 +
 arch/arm64/tools/sysreg                 |  53 +++++-
 drivers/acpi/arm64/Kconfig              |   3 +
 drivers/acpi/arm64/Makefile             |   1 +
 drivers/acpi/arm64/init.c               |   2 +
 drivers/acpi/arm64/init.h               |   1 +
 drivers/acpi/arm64/tlbi.c               | 196 +++++++++++++++++++++
 drivers/firmware/efi/arm-runtime.c      |   3 +-
 include/acpi/actbl2.h                   |  32 ++++
 30 files changed, 858 insertions(+), 72 deletions(-)
 create mode 100644 arch/arm64/mm/tlbid.c
 create mode 100644 drivers/acpi/arm64/tlbi.c


base-commit: 93f51579e7df248780214094418f205253383cc5
-- 
2.43.0

