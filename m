From: Jerry Hoemann <jerry.hoemann@hp.com>
Subject: [PATCH 0/3] Early use of boot service memory
Date: Mon, 11 Nov 2013 19:15:55 -0700
Message-ID: <1384222558-38527-1-git-send-email-jerry.hoemann@hp.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
To: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, matt.fleming@intel.com, yinghai@kernel.org, penberg@kernel.org, akpm@linux-foundation.org, linux-doc@vger.kernel.org, linux-efi@vger.kernel.org, vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, jerry.hoemann@hp.com
List-Id: linux-efi@vger.kernel.org

Some platform have firmware that violates UEFI spec and access boot service
code or data segments after the system has called Exit Boot Services.
The call to efi_reserve_boot_services in setup_arch is a work around to
avoid using boot service memory until after the kernel has done
Set Virtual Map.

However, this reservation fragments memory which can cause
large allocations early in boot (e.g. crash kernel) to fail.

This patch set extends the add_efi_memmap with an optional
argument to specify that firmware "correctly" doesn't resuse
boot services memory after Exit Boot Services.

With this information, setup_arch avoids calling
efi_reserve_boot_services and fragmenting memory.


Jerry Hoemann (3):
  efi: Early use of boot service memory
  x86: avoid efi_reserve_boot_services
  x86, efi: Early use of boot service memory

 Documentation/kernel-parameters.txt |  8 ++++++++
 arch/x86/kernel/setup.c             |  2 +-
 arch/x86/platform/efi/efi.c         | 13 +++++++++++--
 include/linux/efi.h                 |  1 +
 4 files changed, 21 insertions(+), 3 deletions(-)

-- 
1.7.11.3

