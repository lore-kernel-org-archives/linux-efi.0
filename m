From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 0/2] efi: arm: add support for earlycon on EFI framebuffer
Date: Tue, 29 Jan 2019 10:21:48 +0100
Message-ID: <20190129092150.15184-1-ard.biesheuvel@linaro.org>
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
To: linux-efi@vger.kernel.org
Cc: graeme.gregory@linaro.org, corbet@lwn.net, pjones@redhat.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-doc@vger.kernel.org, agraf@suse.de, leif.lindholm@linaro.org, mingo@redhat.com, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

Repurpose the existing EFI earlyprintk code to implement support for
'earlycon=efi' for arm64 systems, allowing the graphical console
to be used instead of the serial port for early debug output.

Changes since v1:
- Rename earlycon= argument to 'efifb' to emphasize that this is specific
  to the EFI framebuffer.
- Replace earlyprintk=efi entirely, rather than keep it alongside earlycon.
  Since earlycon is typically enabled (along with the infrastructure), and
  earlyprintk isn't, this does not result in a lot more code to be included,
  but does make it more likely that a given [distro] kernel has support for
  this enabled out of the box.
- Switch to write-combine mappings by default. This is the default for efifb,
  and is actually required on arm64, since device attributes do not tolerate
  unaligned accesses or other operations (such as DC ZVA) that rely on memory
  semantics. This requires ARCH_USE_MEMREMAP_PROT to be wired up, which is
  why a new patch #1 has been added.
- Since adding the 'ram' parameter for framebuffers in shared memory on cache
  coherent devices is trivial after the switch to WC mappings, fold the change
  into the main patch.

Cc: corbet@lwn.net
Cc: leif.lindholm@linaro.org
Cc: graeme.gregory@linaro.org
Cc: mingo@redhat.com
Cc: tglx@linutronix.de
Cc: linux-doc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: agraf@suse.de
Cc: pjones@redhat.com

Ard Biesheuvel (2):
  x86: make ARCH_USE_MEMREMAP_PROT a generic Kconfig symbol
  efi: x86: convert x86 EFI earlyprintk into generic earlycon
    implementation

 Documentation/admin-guide/kernel-parameters.txt |   8 +-
 arch/Kconfig                                    |   3 +
 arch/x86/Kconfig                                |   5 +-
 arch/x86/Kconfig.debug                          |  10 -
 arch/x86/include/asm/efi.h                      |   1 -
 arch/x86/kernel/early_printk.c                  |   4 -
 arch/x86/platform/efi/Makefile                  |   1 -
 arch/x86/platform/efi/early_printk.c            | 240 --------------------
 drivers/firmware/efi/Kconfig                    |   6 +
 drivers/firmware/efi/Makefile                   |   1 +
 drivers/firmware/efi/earlycon.c                 | 208 +++++++++++++++++
 11 files changed, 226 insertions(+), 261 deletions(-)
 delete mode 100644 arch/x86/platform/efi/early_printk.c
 create mode 100644 drivers/firmware/efi/earlycon.c

-- 
2.20.1
