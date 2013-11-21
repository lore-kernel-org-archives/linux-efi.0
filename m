From: Jerry Hoemann <jerry.hoemann@hp.com>
Subject: [RFC v2 0/2] Early use of boot service memory
Date: Thu, 21 Nov 2013 14:01:24 -0700
Message-ID: <1385067686-73500-1-git-send-email-jerry.hoemann@hp.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
To: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, matt.fleming@intel.com, yinghai@kernel.org, akpm@linux-foundation.org, bp@suse.de, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Cc: penberg@kernel.org, mingo.kernel.org@gmail.com, vgoyal@redhat.com, jerry.hoemann@hp.com
List-Id: linux-efi@vger.kernel.org


Some platform have firmware that violates the UEFI spec and access boot
service code or data segments after the system has called ExitBootServices().
The call to efi_reserve_boot_services in setup_arch is a workaround to
avoid using boot service memory until after the kernel has done
SetVirtualAddressMap.  However, this reservation fragments memory
which can cause large allocations early in boot (e.g. crash kernel)
to fail.

This patch set creates a quirk list that governs whether
efi_reserve_boot_services is called.

A new kernel parameter is added that overrides the quirk list
and allows engineers developing new platforms to test whether
they need to have the quirk applied or not.

With this information, setup_arch avoids calling efi_reserve_boot_services
when it doesn't need to, thus avoiding fragmenting memory.


ChangeLog

V1 => v2)

In version 1 the control of the workaround was only by command line argument.
In version 2, the quirk list is the primary control of the whether
the workaround is applied.  This allows for seamless integration with
tools and doesn't require any special knowledge from the user.

The command line argument is retained for platform developers to
be able to test whether their platforms require the workaround.

Jerry Hoemann (2):
  efi: Early use of boot service memory
  x86, efi: Early use of boot service memory

 Documentation/kernel-parameters.txt |  5 +++
 arch/x86/kernel/setup.c             |  5 ++-
 arch/x86/platform/efi/efi.c         | 77 ++++++++++++++++++++++++++++++++++++-
 include/linux/efi.h                 |  2 +
 4 files changed, 86 insertions(+), 3 deletions(-)

-- 
1.7.11.3

