From: Nayna Jain <nayna@linux.ibm.com>
Subject: [PATCH v2 0/3] powerpc: Enabling secure boot on powernv systems - Part 1
Date: Mon,  8 Apr 2019 18:52:31 -0400
Message-ID: <1554763954-11795-1-git-send-email-nayna@linux.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linuxppc-dev@ozlabs.org, linux-efi@vger.kernel.org, linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michael Ellerman <mpe@ellerman.id.au>, Paul Mackerras <paulus@samba.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jeremy Kerr <jk@ozlabs.org>, Matthew Garret <matthew.garret@nebula.com>, Mimi Zohar <zohar@linux.ibm.com>, Claudio Carvalho <cclaudio@linux.ibm.com>, Nayna Jain <nayna@linux.ibm.com>
List-Id: linux-efi@vger.kernel.org

This patch set is part of a series that implements secure boot on PowerNV
systems.

In order to verify the OS kernel on PowerNV, secure boot requires X.509
certificates trusted by the platform, the secure boot modes, and several
other pieces of information. These are stored in secure variables
controlled by OPAL, also known as OPAL secure variables.

The IMA architecture specific policy support on Power is dependent on OPAL
runtime services to access secure variables. Instead of directly accessing
the OPAL runtime services, version 1[1] of this patch set relied upon the
EFI hooks. This version drops that dependency and calls the OPAL runtime
services directly.

Exposing the OPAL secure variables to userspace will be posted as a
separate patch set, allowing the IMA architecture specific policy on Power
to be upstreamed independently.

This patch set adds the following features:

1. Add support for OPAL Runtime API to access secure variables controlled
by OPAL.
2. Define IMA arch-specific policies based on the secure boot state and
mode of the system. On secure boot enabled powernv systems, the OS kernel
signature will be verified by IMA appraisal.

[1] https://patchwork.kernel.org/cover/10882149/

Changelog:

v2:

* Removed Patch 1: powerpc/include: Override unneeded early ioremap
functions
* Updated Subject line and patch description of the Patch 1 of this series
* Removed dependency of OPAL_SECVAR on EFI, CPU_BIG_ENDIAN and UCS2_STRING
* Changed OPAL APIs from static to non-static. Added opal-secvar.h for the
same
* Removed EFI hooks from opal_secvar.c 
* Removed opal_secvar_get_next(), opal_secvar_enqueue() and
opal_query_variable_info() function
* get_powerpc_sb_mode() in secboot.c now directly calls OPAL Runtime API
rather than via EFI hooks.
* Fixed log messages in get_powerpc_sb_mode() function.
* Added dependency for PPC_SECURE_BOOT on configs PPC64 and OPAL_SECVAR
* Replaced obj-$(CONFIG_IMA) with obj-$(CONFIG_PPC_SECURE_BOOT) in
arch/powerpc/kernel/Makefile

Claudio Carvalho (1):
  powerpc/powernv: Add support for OPAL_SECVAR_GET

Nayna Jain (2):
  powerpc/powernv: detect the secure boot mode of the system
  powerpc: Add support to initialize ima policy rules

 arch/powerpc/Kconfig                         |  14 +++
 arch/powerpc/include/asm/opal-api.h          |   3 +-
 arch/powerpc/include/asm/opal-secvar.h       |  18 ++++
 arch/powerpc/include/asm/opal.h              |   2 +
 arch/powerpc/include/asm/secboot.h           |  21 ++++
 arch/powerpc/kernel/Makefile                 |   1 +
 arch/powerpc/kernel/ima_arch.c               |  54 ++++++++++
 arch/powerpc/platforms/powernv/Kconfig       |   6 ++
 arch/powerpc/platforms/powernv/Makefile      |   2 +
 arch/powerpc/platforms/powernv/opal-call.c   |   1 +
 arch/powerpc/platforms/powernv/opal-secvar.c | 107 +++++++++++++++++++
 arch/powerpc/platforms/powernv/secboot.c     |  54 ++++++++++
 include/linux/ima.h                          |   3 +-
 13 files changed, 284 insertions(+), 2 deletions(-)
 create mode 100644 arch/powerpc/include/asm/opal-secvar.h
 create mode 100644 arch/powerpc/include/asm/secboot.h
 create mode 100644 arch/powerpc/kernel/ima_arch.c
 create mode 100644 arch/powerpc/platforms/powernv/opal-secvar.c
 create mode 100644 arch/powerpc/platforms/powernv/secboot.c

-- 
2.20.1
