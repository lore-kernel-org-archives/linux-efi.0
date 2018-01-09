From: Daniel Kiper <daniel.kiper@oracle.com>
Subject: [PATCH 0/4] x86/xen/efi: Initialize UEFI secure boot state during dom0 boot
Date: Tue,  9 Jan 2018 15:22:21 +0100
Message-ID: <1515507745-17391-1-git-send-email-daniel.kiper@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, xen-devel@lists.xenproject.org
Cc: ard.biesheuvel@linaro.org, boris.ostrovsky@oracle.com, hpa@zytor.com, jgross@suse.com, konrad.wilk@oracle.com, mingo@redhat.com, tglx@linutronix.de
List-Id: linux-efi@vger.kernel.org

Hi,

Initialize UEFI secure boot state during dom0 boot. Otherwise the kernel
may not even know that it runs on secure boot enabled platform.

Daniel

 arch/x86/xen/Makefile                          |    4 +++-
 arch/x86/xen/efi.c                             |   14 +++++++++++++
 drivers/firmware/efi/libstub/secureboot-core.c |   77 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/firmware/efi/libstub/secureboot.c      |   66 +++++------------------------------------------------------
 4 files changed, 99 insertions(+), 62 deletions(-)

Daniel Kiper (4):
      efi/stub: Extract efi_get_secureboot() to separate file
      x86/xen/efi: Initialize boot_params.secure_boot in xen_efi_init()
      efi: Tweak efi_get_secureboot() and its data section assignment
      efi: Rename efi_get_secureboot() to __efi_get_secureboot() and make it static
