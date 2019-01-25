From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 0/2] efi: arm: add support for earlycon on EFI framebuffer
Date: Fri, 25 Jan 2019 17:18:04 +0100
Message-ID: <20190125161806.13472-1-ard.biesheuvel@linaro.org>
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
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, graeme.gregory@linaro.org, linux-doc@vger.kernel.org, pjones@redhat.com, corbet@lwn.net, agraf@suse.de, leif.lindholm@linaro.org, mingo@redhat.com, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

Repurpose the existing EFI earlyprintk code to implement support for
'earlycon=efi' for arm64 systems, allowing the graphical console
to be used instead of the serial port for early debug output.

Ard Biesheuvel (2):
  efi: x86: move EFI earlyprintk code to shared location
  efi: arm64: Enable earlycon for the GOP framebuffer

 Documentation/admin-guide/kernel-parameters.txt                         |  9 ++-
 arch/arm64/include/asm/efi.h                                            |  6 ++
 arch/x86/Kconfig.debug                                                  |  2 +-
 arch/x86/include/asm/efi.h                                              |  6 ++
 arch/x86/platform/efi/Makefile                                          |  1 -
 drivers/firmware/efi/Kconfig                                            |  5 ++
 drivers/firmware/efi/Makefile                                           |  1 +
 arch/x86/platform/efi/early_printk.c => drivers/firmware/efi/earlycon.c | 62 ++++++++++++++------
 8 files changed, 70 insertions(+), 22 deletions(-)
 rename arch/x86/platform/efi/early_printk.c => drivers/firmware/efi/earlycon.c (76%)

-- 
2.20.1
