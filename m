From: Mark Salter <msalter@redhat.com>
Subject: [PATCH 0/3] arm64: Add EFI stub and runtime services support
Date: Fri, 29 Nov 2013 17:05:09 -0500
Message-ID: <1385762712-17043-1-git-send-email-msalter@redhat.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: patches@linaro.org, Mark Salter <msalter@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com, linux-efi@vger.kernel.org, Leif Lindholm <leif.lindholm@linaro.org>, roy.franz@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-doc@vger.kernel.org, Rob Landley <rob@landley.net>
List-Id: linux-efi@vger.kernel.org

This patch series adds EFI support to the arm64 kernel. This support has
two main parts: an EFI stub and runtime support. The EFI stub support
has the kernel masquerade as a PE/COFF application which can be directly
booted by EFI firmware (or by secondary loaders with EFI support). The
runtime services support provides access to various EFI firmware services
such as reboot, real-time clock, boot variables, and others.

These patches have dependencies on other patches which are not yet in
the kernel but have been posted and are currently under review. In
particular:

  - Generic fixmap support being discussed here:
      http://lkml.org/lkml/2013/11/25/474

  - early_ioremap support being discussed here:
      https://lkml.org/lkml/2013/11/27/621

  - shared EFI update_fdt() function being discussed here:
      https://lkml.org/lkml/2013/11/27/565

A repo with this patch series and the prerequisite patches is at:

  git://github.com/mosalter/linux.git (arm64-efi-patches branch)

Mark Salter (3):
  arm64: add EFI stub
  doc: arm64: add description of EFI stub support
  arm64: add EFI runtime services

 Documentation/arm64/booting.txt |   4 +
 Documentation/efi-stub.txt      |  10 +-
 arch/arm64/Kconfig              |  25 ++
 arch/arm64/include/asm/efi.h    |  18 ++
 arch/arm64/kernel/Makefile      |   4 +
 arch/arm64/kernel/efi-entry.S   |  81 +++++++
 arch/arm64/kernel/efi-stub.c    | 280 ++++++++++++++++++++++
 arch/arm64/kernel/efi.c         | 507 ++++++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/head.S        | 112 +++++++++
 arch/arm64/kernel/setup.c       |   6 +
 include/linux/efi.h             |   2 +-
 11 files changed, 1046 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm64/include/asm/efi.h
 create mode 100644 arch/arm64/kernel/efi-entry.S
 create mode 100644 arch/arm64/kernel/efi-stub.c
 create mode 100644 arch/arm64/kernel/efi.c

-- 
1.8.3.1

