Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795693807;
	b=Uquw1BYeX1jU0pPUXKmjdi1BMg1kVgp9JhOXX9QFcgjpM9s+q7nRIjYaGPA34HnVU9MM
	 evCS4vfLgAx306wh/nifQVQH7IxbPCHJSekJ9mdG414nW9c2hqh7L6DGAmlFHkkmdyDGk
	 9IsSsq8/Z4k/DgXUbGUdaoHQ+4q98Lf9ISARvZGd7WpFo3Z2FsEUs07YCQWUpgfe2fj6p
	 6Y72iUbcbUqCBeJJ8ptidwiHiyteAZcnVTV0S005yPmcLHbqSIP9LlQzZN3VOfNGSmwEM
	 z7/W7IBd+7SaKsMOYhg3rTZq0lAZAswzj1h8eIQuF/25JtbX3wq6XdfBCfZlWsJyQ5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795693807;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=nVCD3WqvgCoqhKy/l3yuhy8HMKgb8NDwxlYf03aauoU=;
	b=2z/IFLDZNRB2l5CiaaH+RMOyVn9rPxL1CkP8sh2Yx+NAqUBH8ez5GzcjwcOkKkw0V5yd
	 gR3qwRBlx9Rd0ntkgQlAv/NTfTPdToHFk/PyIeE+7aRE/uRmpTSlnnZlA4AO43shBJ7ij
	 /PIeCVyrKEIKOsA8zkTyJ4hEVClUmhI5p02lKp8YRZo0sC9rbr8HJE+P6NNWnXVwbXjht
	 tJvJs2V9cDdPkWxVa/sMoFmCwJR1udbkId3EZhBTvjvPgLzEzzTv/iLHBR8f3x76EWwij
	 4uYroV0KPBsqqwVXZZUpbzSIygmKbXKCWfbFuU3wKhrag8phNXtGVc11RLbrVBz4VEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=fky3xG22;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A7A0606A321;
	Thu, 26 Nov 2026 11:50:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2A7A0606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=fky3xG22
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0D3CA1C2B;
	Thu, 26 Nov 2026 03:50:01 -0800 (PST)
Received: from e142392.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9D3AD3F632;
	Thu, 26 Nov 2026 03:50:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795693803; bh=8yLuitpP6g12fQ0y1lDT3Vae2vvpE/cs2esk4Vshcdc=;
	h=From:To:Cc:Subject:Date:From;
	b=fky3xG22aklLR/T8p1iKGBqJmbO08vZSmDznbP72j7LKp3kpGCOylRpc68JsNkmPX
	 j5KE7hddFz474U50G9BOo7j870/4lAyURjD1G3tr80qU1kS1PvDRK+SmE5vwl/YeRG
	 3cHHsUDx5RzHHyGo5a66SzN1G2H8JAaxvWftJS44=
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
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Jinqian Yang <yangjinqian1@huawei.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [RFC v2 00/13] arm64: Add support for TLBI domains
Date: Thu, 26 Nov 2026 11:49:23 +0000
Message-ID: <20261126114936.864256-1-kristina.martsenko@arm.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

This is a follow-up to the initial TLBI domain RFC:
  https://lore.kernel.org/all/20261001110655.461473-1-kristina.martsenko@arm.com/

The goal of the series is to improve performance by using TLBI domains
(FEAT_TLBID) to send TLB invalidations only to the CPUs where a process has
run. (Specifically, TLBI commands are sent to a fixed “domain”, which may be
wider than the set of target CPUs.)

This RFC v2 addresses review feedback from the previous RFC v1. It is still an
RFC because the ACPI table specification is still not public, so this series
can't be merged yet.

The series does not include KVM support, it only disables domains for guests.
KVM support has been posted by Jinqian [1].

Thanks,
Kristina

[1] https://lore.kernel.org/all/20261030065617.4090073-1-yangjinqian1@huawei.com/


Changes in RFC v2:
  - Made context-switch only update domains if they would change (and updated
    the barrier) [Zi]
  - Explained in commit message why mm_cpumask is not used [Zi]
  - Added WARN_ON to EFI init [Ard]
  - Split EL2 setup into a separate patch [Linu]
  - Fixed ipas2e1is() to use __tlbip() [Jinqian, sashiko]
  - Fixed memory leaks in error paths [Jinqian, sashiko]
  - Made ACPI table sanity checks more robust [sashiko]
  - Fixed 'tlbi' variable to be static [sashiko]
  - Fixed __tlbip() macro argument expansion [sashiko]
  - Link to RFC v1: https://lore.kernel.org/all/20261001110655.461473-1-kristina.martsenko@arm.com/


Kristina Martšenko (13):
  arm64: sysreg: Add definitions for TLBID
  arm64: boot: Handle TLBID boot requirements
  arm64: Detect TLBID
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
 arch/arm64/include/asm/el2_setup.h      |  77 +++++++-
 arch/arm64/include/asm/kvm_emulate.h    |   5 +
 arch/arm64/include/asm/mmu.h            |  13 ++
 arch/arm64/include/asm/mmu_context.h    |   9 +-
 arch/arm64/include/asm/tlbflush.h       | 218 +++++++++++++++++------
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
 arch/arm64/mm/tlbid.c                   | 227 ++++++++++++++++++++++++
 arch/arm64/tools/cpucaps                |   1 +
 arch/arm64/tools/sysreg                 |  53 +++++-
 drivers/acpi/arm64/Kconfig              |   3 +
 drivers/acpi/arm64/Makefile             |   1 +
 drivers/acpi/arm64/init.c               |   2 +
 drivers/acpi/arm64/init.h               |   1 +
 drivers/acpi/arm64/tlbi.c               | 217 ++++++++++++++++++++++
 drivers/firmware/efi/arm-runtime.c      |   3 +-
 include/acpi/actbl2.h                   |  32 ++++
 30 files changed, 897 insertions(+), 71 deletions(-)
 create mode 100644 arch/arm64/mm/tlbid.c
 create mode 100644 drivers/acpi/arm64/tlbi.c


base-commit: aebb7274476403040d582c61478df8f4a7bf9cd3
-- 
2.43.0

