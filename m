From: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/3] Use mm_struct and switch_mm() instead of manually
Date: Sat, 16 Dec 2017 16:05:58 -0800
Message-ID: <1513469158-5638-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sai Praneeth <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Presently, in x86, to invoke any efi function like
efi_set_virtual_address_map() or any efi_runtime_service() the code path
typically involves read_cr3() (save previous pgd), write_cr3()
(write efi_pgd) and calling efi function. Likewise after returning from
efi function the code path typically involves read_cr3() (save efi_pgd),
write_cr3() (write previous pgd). We do this couple of times in efi
subsystem of Linux kernel, instead we can use helper function
efi_switch_mm() to do this. This improves readability and maintainability.
Also, instead of maintaining a separate struct "efi_scratch" to store/restore
efi_pgd, we can use mm_struct to do this.

I have tested this patch set against LUV (Linux UEFI Validation), so I
think I didn't break any existing configurations. I have tested this
patch set for
1. x86_64,
2. x86_32,
3. Mixed mode
with efi=old_map and for kexec kernel. Please let me know if I have
missed any other configurations.

Changes in V2:
1. Resolve mm_dropping() issue by not mm_dropping()/mm_grabbing() any mm,
as we are not losing/creating any references.

Changes in V3:
1. When CPUMASK_OFFSTACK is enabled, switch_mm_irqs_off() sets cpumask
by calling cpumask_set_cpu(). This panics kernel as efi_mm is not
initialized, therefore initialize efi_mm in efi_alloc_page_tables().

Note:
This patch set is based on Linus's tree v4.15-rc3

Sai Praneeth (3):
  efi: Use efi_mm in x86 as well as ARM
  x86/efi: Replace efi_pgd with efi_mm.pgd
  x86/efi: Use efi_switch_mm() rather than manually twiddling with %cr3

 arch/x86/include/asm/efi.h           | 29 +++++++++---------
 arch/x86/platform/efi/efi_64.c       | 59 +++++++++++++++++++-----------------
 arch/x86/platform/efi/efi_thunk_64.S |  2 +-
 drivers/firmware/efi/arm-runtime.c   |  9 ------
 drivers/firmware/efi/efi.c           |  9 ++++++
 include/linux/efi.h                  |  2 ++
 6 files changed, 57 insertions(+), 53 deletions(-)

Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Tested-by: Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

-- 
2.1.4
