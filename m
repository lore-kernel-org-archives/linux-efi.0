From: Shanker Donthineni <shankerd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH 0/3] Implement a software workaround for Falkor erratum 1041
Date: Thu,  2 Nov 2017 22:27:41 -0500
Message-ID: <1509679664-3749-1-git-send-email-shankerd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, Shanker Donthineni <shankerd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Falkor CPU, we’ve discovered a hardware issue which might lead to a
kernel crash or the unexpected behavior. The Falkor core may errantly
access memory locations on speculative instruction fetches. This may
happen whenever MMU translation state, SCTLR_ELn[M] bit is being changed
from enabled to disabled for the currently running exception level. To
prevent the errant hardware behavior, software must execute an ISB
immediately prior to executing the MSR that changes SCTLR_ELn[M] from a
value of 1 to 0. To simplify the complexity of a workaround, this patch
series issues an ISB whenever SCTLR_ELn[M] is changed to 0 to fix the
Falkor erratum 1041.

Patch1:
  - CPUTYPE definitions for Falkor CPU.

Patch2:
  - Define two ASM helper macros to read/write SCTLR_ELn register.

Patch3:
  - Actual workaround changes for erratum E1041.

Shanker Donthineni (3):
  arm64: Define cputype macros for Falkor CPU
  arm64: Prepare SCTLR_ELn accesses to handle Falkor erratum 1041
  arm64: Add software workaround for Falkor erratum 1041

 Documentation/arm64/silicon-errata.txt |  1 +
 arch/arm64/Kconfig                     | 10 ++++++++++
 arch/arm64/include/asm/assembler.h     | 35 ++++++++++++++++++++++++++++++++++
 arch/arm64/include/asm/cpucaps.h       |  3 ++-
 arch/arm64/include/asm/cputype.h       |  2 ++
 arch/arm64/kernel/cpu-reset.S          |  4 ++--
 arch/arm64/kernel/cpu_errata.c         | 16 ++++++++++++++++
 arch/arm64/kernel/efi-entry.S          |  8 ++++----
 arch/arm64/kernel/head.S               | 18 ++++++++---------
 arch/arm64/kernel/relocate_kernel.S    |  4 ++--
 arch/arm64/kvm/hyp-init.S              |  6 +++---
 arch/arm64/mm/proc.S                   |  6 +++---
 12 files changed, 89 insertions(+), 24 deletions(-)

-- 
Qualcomm Datacenter Technologies, Inc. on behalf of the Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
