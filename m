From: Claudio Carvalho <cclaudio@linux.ibm.com>
Subject: [PATCH 0/4] Enabling secure boot on PowerNV systems
Date: Tue,  2 Apr 2019 15:15:01 -0300
Message-ID: <20190402181505.25037-1-cclaudio@linux.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linuxppc-dev@ozlabs.org, linux-efi@vger.kernel.org, linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michael Ellerman <mpe@ellerman.id.au>, Paul Mackerras <paulus@samba.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jeremy Kerr <jk@ozlabs.org>, Matthew Garret <matthew.garret@nebula.com>, Claudio Carvalho <cclaudio@linux.ibm.com>, Nayna Jain <nayna@linux.ibm.com>
List-Id: linux-efi@vger.kernel.org

This patch set is part of a series that implements secure boot on
PowerNV systems.

In order to verify the OS kernel on PowerNV, secure boot requires X.509
certificates trusted by the platform, the secure boot modes, and several
other pieces of information. These are stored in secure variables
controlled by OPAL, also known as OPAL secure variables.

This patch set adds the following features:

1. Enable efivarfs by selecting CONFIG_EFI in the CONFIG_OPAL_SECVAR
   introduced in this patch set. With CONFIG_EFIVAR_FS, userspace tools can
   be used to manage the secure variables.
2. Add support for OPAL secure variables by overwriting the EFI hooks
   (get_variable, get_next_variable, set_variable and query_variable_info)
   with OPAL call wrappers. There is probably a better way to add this
   support, for example, we are investigating if we could register the
   efivar_operations rather than overwriting the EFI hooks. In this patch
   set, CONFIG_OPAL_SECVAR selects CONFIG_EFI. If, instead, we registered
   efivar_operations, CONFIG_EFIVAR_FS would need to depend on
   CONFIG_EFI|| CONFIG_OPAL_SECVAR. Comments or suggestions on the
   preferred technique would be greatly appreciated.
3. Define IMA arch-specific policies based on the secure boot state and
   mode of the system. On secure boot enabled powernv systems, the host OS
   kernel signature will be verified by IMA appraisal.

Claudio Carvalho (2):
  powerpc/include: Override unneeded early ioremap functions
  powerpc/powernv: Add support for OPAL secure variables

Nayna Jain (2):
  powerpc/powernv: Detect the secure boot mode of the system
  powerpc: Add support to initialize ima policy rules

 arch/powerpc/Kconfig                         |  12 ++
 arch/powerpc/include/asm/early_ioremap.h     |  41 +++++
 arch/powerpc/include/asm/opal-api.h          |   6 +-
 arch/powerpc/include/asm/opal.h              |  10 ++
 arch/powerpc/include/asm/secboot.h           |  21 +++
 arch/powerpc/kernel/Makefile                 |   1 +
 arch/powerpc/kernel/ima_arch.c               |  54 ++++++
 arch/powerpc/platforms/Kconfig               |   3 +
 arch/powerpc/platforms/powernv/Kconfig       |   9 +
 arch/powerpc/platforms/powernv/Makefile      |   1 +
 arch/powerpc/platforms/powernv/opal-call.c   |   4 +
 arch/powerpc/platforms/powernv/opal-secvar.c | 179 +++++++++++++++++++
 arch/powerpc/platforms/powernv/secboot.c     |  54 ++++++
 include/linux/ima.h                          |   3 +-
 14 files changed, 396 insertions(+), 2 deletions(-)
 create mode 100644 arch/powerpc/include/asm/early_ioremap.h
 create mode 100644 arch/powerpc/include/asm/secboot.h
 create mode 100644 arch/powerpc/kernel/ima_arch.c
 create mode 100644 arch/powerpc/platforms/powernv/opal-secvar.c
 create mode 100644 arch/powerpc/platforms/powernv/secboot.c

-- 
2.20.1
