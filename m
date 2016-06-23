From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 00/11] efi: Permanent runtime EFI memmap support
Date: Thu, 23 Jun 2016 12:34:39 +0100
Message-ID: <1466681690-5850-1-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Young <dyoung@redhat.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Borislav Petkov <bp@alien8.de>, Josh Boyer <jwboyer@fedoraproject.org>, Josh Triplett <josh@joshtriplett.org>, Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Leif Lindholm <leif.lindholm@linaro.org>, Mark Rutland <mark.rutland@arm.com>, =?UTF-8?q?M=C3=B4she=20van=20der=20Sterre?= <me@moshe.nl>, Peter Jones <pjones@redhat.com>, Taku Izumi <izumi.taku@jp.fujitsu.com>, Tony Luck <tony.luck@intel.com>, Xishi Qiu <qiuxishi@huawei.com>
List-Id: linux-efi@vger.kernel.org

This series adds support for keeping the EFI memory map around at
runtime for x86 (ARM and arm64 already have this support).

Additionally, drivers can now reserve EFI boot services regions such
that they are not released back to the kernel during
efi_free_boot_services().

With these two features it becomes possible to pass things like the
EFI System Resource Table data structures across kexec reboot.

This series also includes a whole bunch of refactoring and cleanups to
move code out of arch or driver-specific files into generic places.

I've given these patches some light testing, but it would be good if
others could provide more given that this series touches so many
different code paths.

ARM/arm64 folks, you're going to want to pay particular attention to
PATCH 3 where I drop the read-only mapping of the EFI memory map since
it causes problems for x86.

I am aware that we leak memory maps when new ones get installed, e.g.
during __efi_enter_virtual_mode(), but that's an existing bug that
requires everyone to allocate memory maps the same way before it can
be fixed.

 arch/x86/include/asm/efi.h         |   1 -
 arch/x86/kernel/setup.c            |  13 +-
 arch/x86/platform/efi/efi-bgrt.c   |  13 +-
 arch/x86/platform/efi/efi.c        | 198 ++++++++++++-------------
 arch/x86/platform/efi/efi_64.c     |  20 ---
 arch/x86/platform/efi/quirks.c     | 123 ++++++++++++++--
 drivers/firmware/efi/Makefile      |   2 +-
 drivers/firmware/efi/arm-init.c    |  17 +--
 drivers/firmware/efi/arm-runtime.c |   4 +-
 drivers/firmware/efi/efi.c         |  64 ++++----
 drivers/firmware/efi/esrt.c        |  20 +--
 drivers/firmware/efi/fake_mem.c    | 125 ++--------------
 drivers/firmware/efi/memmap.c      | 292 +++++++++++++++++++++++++++++++++++++
 drivers/firmware/efi/runtime-map.c |  35 ++---
 include/linux/efi.h                |  34 ++++-
 15 files changed, 605 insertions(+), 356 deletions(-)
 create mode 100644 drivers/firmware/efi/memmap.c
