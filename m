From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [GIT PULL 00/40] EFI changes for v4.7
Date: Mon, 25 Apr 2016 21:06:32 +0100
Message-ID: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
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
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Raphael Hertzog <hertzog@debian.org>, linux-efi@vger.kernel.org, Jeremy Compostella <jeremy.compostella@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Peter Jones <pjones@redhat.com>, David Herrmann <dh.herrmann@gmail.com>, Christoph Hellwig <hch@lst.de>, Kweh Hock Leong <hock.leong.kweh@intel.com>, Russell King <linux@arm.linux.org.uk>, Peter Zijlstra <peterz@infradead.org>, Mark Salter <msalter@redhat.com>, Darren Hart <dvhart@infradead.org>, Stefan Stanacar <stefan.stanacar@intel.com>, Borislav Petkov <bp@suse.de>, Ben Hutchings <ben@decadent.org.uk>, Robert Elliott <elliott@hpe.com>, Ricardo Neri <ricardo.neri-calderon@linux.intel.com>, Robin Murphy <robin.murphy@arm.com>, Leif Lindholm <leif.>
List-Id: linux-efi@vger.kernel.org

Folks, here's the queue of EFI material for v4.7. This is probably the
biggest EFI pull ever sent, and there quite a few different topics
covered.

On the plus side the majority of new features (EFI Memory Attribute
tables, EFI capsules, GOP framebuffer) are basically architecture
independent, and some of the existing architecture-specific code has
been generalised and moved to drivers/firmware/efi.

The following changes since commit c3b46c73264b03000d1e18b22f5caf63332547c9:

  Linux 4.6-rc4 (2016-04-17 19:13:32 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next

for you to fetch changes up to 4716a27d61ca3e3201d3201a6ee073da24902613:

  efi/runtime-wrappers: Remove ARCH_EFI_IRQ_FLAGS_MASK ifdef (2016-04-25 16:53:59 +0100)

----------------------------------------------------------------
 * Drop the unused EFI_SYSTEM_TABLES efi.flags bit and ensure the
   ARM/arm64 EFI System Table mapping is read-only - Ard Biesheuvel

 * Add a comment to explain that one of the code paths in the x86/pat
   code is only executed for EFI boot - Matt Fleming

 * Improve Secure Boot status checks on arm64 and handle unexpected
   errors - Linn Crosetto

 * Remove the global EFI memory map variable 'memmap' as the same
   information is already available in efi::memmap - Matt Fleming

 * EFI Memory Attribute table support for ARM/arm64 - Ard Biesheuvel

 * EFI GOP framebuffer support for ARM/arm64 - Ard Biesheuvel

 * EFI Bootloader Control driver for storing reboot(2) data in EFI
   variables for consumption by bootloaders  - Jeremy Compostella

 * Core EFI capsule support - Matt Fleming

 * EFI capsule char driver - Kweh, Hock Leong

 * EFI memory map code unification for ARM and arm64 - Ard Biesheuvel

 * Add generic EFI support for detecting when firmware corrupts cpu
   status register bits (like IRQ flags) when performing EFI runtime
   service calls - Mark Rutland

----------------------------------------------------------------
Ard Biesheuvel (19):
      efi: Get rid of EFI_SYSTEM_TABLES status bit
      efi/arm*: Drop writable mapping of the UEFI System table
      efi: Check EFI_MEMORY_DESCRIPTOR version explicitly
      efi/arm*: Use memremap() to create the persistent memmap mapping
      ARM: efi: Apply strict permissons for UEFI Runtime Services regions
      arm64: efi: Apply strict permissons for UEFI Runtime Services regions
      efi: Add support for the EFI_MEMORY_ATTRIBUTES_TABLE config table
      efi: Implement generic support for the Memory Attributes table
      efi/arm*: Take the Memory Attributes table into account
      x86/efi: Prepare GOP handling code for reuse as generic code
      efi/libstub: Move Graphics Output Protocol handling to generic code
      x86/efi: efifb: Move DMI based quirks handling out of generic code
      efifb: Use builtin_platform_driver and drop unused includes
      arm64/efi: libstub: Make screen_info accessible to the UEFI stub
      efi/arm: libstub: Make screen_info accessible to the UEFI stub
      efi/arm*: libstub: Wire up GOP protocol to struct screen_info
      efi/arm*: Wire up struct screen_info to efi-framebuffer platform device
      efifb: Enable the efi-framebuffer platform driver for ARM and arm64
      efi/arm-init: Reserve rather than unmap the memory map for ARM as well

Compostella, Jeremy (1):
      efibc: EFI Bootloader Control

Kweh, Hock Leong (1):
      efi: A misc char interface to update EFI firmware

Linn Crosetto (2):
      efi/arm64: Report unexpected errors when determining Secure Boot status
      efi/arm64: Check SetupMode when determining Secure Boot status

Mark Rutland (10):
      efi/runtime-wrappers: Add {__,}efi_call_virt templates
      arm64/efi: Move to generic {__,}efi_call_virt
      arm/efi: Move to generic {__,}efi_call_virt
      x86/efi: Move to generic {__,}efi_call_virt
      efi/runtime-wrappers: Remove redundant ifdefs
      efi/runtime-wrappers: Detect firmware irq flag corruption
      arm64/efi: Enable runtime call flag checking
      arm/efi: Enable runtime call flag checking
      x86/efi: Enable runtime call flag checking
      efi/runtime-wrappers: Remove ARCH_EFI_IRQ_FLAGS_MASK ifdef

Matt Fleming (7):
      x86/mm/pat: Document the (currently) EFI-only code path
      efi: Iterate over efi.memmap in for_each_efi_memory_desc
      efi: Remove global 'memmap'
      x86/efi: Remove the always true EFI_DEBUG symbol
      efi: Move efi_status_to_err() to drivers/firmware/efi/
      efi: Capsule update support
      x86/efi: Force EFI reboot to process pending capsules

 arch/arm/include/asm/efi.h                     |  37 +--
 arch/arm/kernel/efi.c                          |  41 +++
 arch/arm/kernel/setup.c                        |   3 +-
 arch/arm64/include/asm/efi.h                   |  37 +--
 arch/arm64/kernel/efi.c                        |  57 +++-
 arch/arm64/kernel/image.h                      |   1 +
 arch/ia64/kernel/efi.c                         |   2 -
 arch/x86/boot/compressed/eboot.c               | 308 +--------------------
 arch/x86/boot/compressed/eboot.h               |  74 ------
 arch/x86/include/asm/efi.h                     |  52 ++--
 arch/x86/kernel/reboot.c                       |   9 +
 arch/x86/kernel/sysfb_efi.c                    |  15 ++
 arch/x86/mm/pageattr.c                         |   8 +-
 arch/x86/platform/efi/efi.c                    | 133 +++++-----
 arch/x86/platform/efi/efi_64.c                 |  10 +-
 arch/x86/platform/efi/quirks.c                 |  10 +-
 drivers/firmware/efi/Kconfig                   |  25 ++
 drivers/firmware/efi/Makefile                  |   5 +-
 drivers/firmware/efi/arm-init.c                |  96 +++++--
 drivers/firmware/efi/arm-runtime.c             |  45 ++--
 drivers/firmware/efi/capsule-loader.c          | 343 ++++++++++++++++++++++++
 drivers/firmware/efi/capsule.c                 | 300 +++++++++++++++++++++
 drivers/firmware/efi/efi.c                     |  48 +++-
 drivers/firmware/efi/efibc.c                   | 101 +++++++
 drivers/firmware/efi/fake_mem.c                |  43 ++-
 drivers/firmware/efi/libstub/Makefile          |   2 +-
 drivers/firmware/efi/libstub/arm-stub.c        |  77 +++++-
 drivers/firmware/efi/libstub/arm32-stub.c      |  37 +++
 drivers/firmware/efi/libstub/efi-stub-helper.c |   6 +-
 drivers/firmware/efi/libstub/gop.c             | 354 +++++++++++++++++++++++++
 drivers/firmware/efi/memattr.c                 | 182 +++++++++++++
 drivers/firmware/efi/reboot.c                  |  12 +-
 drivers/firmware/efi/runtime-wrappers.c        |  60 +++++
 drivers/firmware/efi/vars.c                    |  33 ---
 drivers/video/fbdev/Kconfig                    |   2 +-
 drivers/video/fbdev/efifb.c                    |  21 +-
 include/linux/efi.h                            | 164 +++++++++++-
 37 files changed, 2062 insertions(+), 691 deletions(-)
 create mode 100644 drivers/firmware/efi/capsule-loader.c
 create mode 100644 drivers/firmware/efi/capsule.c
 create mode 100644 drivers/firmware/efi/efibc.c
 create mode 100644 drivers/firmware/efi/libstub/gop.c
 create mode 100644 drivers/firmware/efi/memattr.c
