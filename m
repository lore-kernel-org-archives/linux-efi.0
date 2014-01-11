From: Leif Lindholm <leif.lindholm@linaro.org>
Subject: [PATCH v4 0/5] arm: add UEFI runtime services support
Date: Sat, 11 Jan 2014 13:05:19 +0000
Message-ID: <1389445524-30623-1-git-send-email-leif.lindholm@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, linux-efi@vger.kernel.org, linux@arm.linux.org.uk, patches@linaro.org, Leif Lindholm <leif.lindholm@linaro.org>, roy.franz@linaro.org, matt.fleming@intel.com, msalter@redhat.com, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

In systems based on [U]EFI-conformant firmware, runtime services provide
a standardised way for the kernel to update firmware environment
variables. This is used for example by efibootmgr to update which image
should be loaded on next boot.

This patchset implements basic support for UEFI runtime services on ARM
platforms, as well as the basic underlying EFI support. It also defines
a mechanism by which the required information is passed from the
bootloader (the EFI stub submitted separately) to the kernel via FDT
entries.

This patchset depends on the presence of early_ioremap(). It has been
validated against Mark Salter's generic implementation.
It also depends on Mark's "efi: add helper function to get UEFI params
from FDT" patch.

Changes since v3:
- Use new common function (from arm64 set) for extracting UEFI params
  from FDT.
- Use new generic early_ioremap implementation (with early_memunmap).
- Reworked/simplified phys_call code, using new shared functions/macros.
- Slightly refactored to reduce number of explicit casts.
- Also preserve and map EFI_ACPI_MEMORY_NVS regions.
- Added some ACKs.

Change since v2:
- Updated FDT bindings.
- Preserve regions marked RESERVED (but don't map them).
- Rename 'efi' -> 'uefi' within this new port (leaving core code as is).

Leif Lindholm (5):
  arm: break part of __soft_restart out into separate function
  arm: add new asm macro update_sctlr
  Documentation: arm: add UEFI support documentation
  arm: Add [U]EFI runtime services support
  init: efi: arm: enable (U)EFI runtime services on arm

 Documentation/arm/00-INDEX       |    3 +
 Documentation/arm/uefi.txt       |   61 ++++++
 arch/arm/Kconfig                 |   16 ++
 arch/arm/include/asm/assembler.h |   13 ++
 arch/arm/include/asm/idmap.h     |    1 +
 arch/arm/include/asm/uefi.h      |   28 +++
 arch/arm/kernel/Makefile         |    2 +
 arch/arm/kernel/process.c        |   12 +-
 arch/arm/kernel/setup.c          |    4 +
 arch/arm/kernel/uefi.c           |  418 ++++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/uefi_phys.S      |   67 ++++++
 arch/arm/mm/idmap.c              |   15 ++
 include/linux/efi.h              |    2 +-
 init/main.c                      |    4 +
 14 files changed, 634 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/arm/uefi.txt
 create mode 100644 arch/arm/include/asm/uefi.h
 create mode 100644 arch/arm/kernel/uefi.c
 create mode 100644 arch/arm/kernel/uefi_phys.S

-- 
1.7.10.4
