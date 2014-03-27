From: Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 0/5] x86/efi: Implement FPU context save/restore
Date: Thu, 27 Mar 2014 15:10:38 -0700
Message-ID: <1395958243-14458-1-git-send-email-ricardo.neri-calderon@linux.intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

It may be possible that EFI firmware wants to use the FPU. Thus, in such a case,
the kernel EFI runtime services need to make sure that they save and restore the
FPU context.

Additionally, several FPU internal functions require alternatives to be in place
when running. Some of the FPU context save/restore instances that this series
implements may occur early during boot; before the alternatives have run.
Several FPU internal functions are updated to use the alternatives-safe variant
of static_cpu_has. The performance penalty is negligible as the impacted
functions are not performance-critical.

In order to prepare to implement the FPU context save/restore, this series also
reworks many of the efi_call macros. The code will also be more readable and
continue to be reusable between x86_64 and i386.

BR,
Ricardo

Matt Fleming (2):
  x86/efi: Delete most of the efi_call* macros
  x86, fpu: Extend the use of static_cpu_has_safe

Ricardo Neri (3):
  x86/efi: Implement a __efi_call_virt macro
  x86/efi: Save and restore FPU context around efi_calls (x86_64)
  x86/efi: Save and restore FPU context around efi_calls (i386)

 arch/x86/boot/compressed/eboot.c       | 142 ++++++++++++++++-----------------
 arch/x86/include/asm/efi.h             |  98 ++++++++---------------
 arch/x86/include/asm/fpu-internal.h    |  10 +--
 arch/x86/platform/efi/efi.c            |  52 ++++++------
 arch/x86/platform/efi/efi_stub_64.S    |  81 +------------------
 drivers/firmware/efi/efi-stub-helper.c |  92 ++++++++++-----------
 6 files changed, 181 insertions(+), 294 deletions(-)

-- 
1.8.1.2
