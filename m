From: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH V8 0/5]  map GHES memory region according to EFI memory map
Date: Fri, 24 Jul 2015 16:51:04 -0700
Message-ID: <1437781869-29721-1-git-send-email-zjzhang@codeaurora.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tony.luck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, fu.wei-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, al.stone-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linaro-acpi-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, vgandhi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>

On a platform with APEI (ACPI Platform Error Interface) enabled, firmware
updates a memory region with hardware error record using nocache
attribute. When OS reads the region, since it maps the region with
cacahed attribute even though EFI memory map defines this region as
uncached, OS gets stale data and errorneously reports there is no new
HW error.

When ghes driver maps the memory region, it uses the cache attribute
according to EFI memory map, if EFI memory map feature is enabled
at runtime.

Since both arch/x86 and arch/ia64 implemented architecture agnostic EFI
memory map attribue lookup function efi_memattributes(), the code is
moved from arch/x86 into EFI subsystem and is declared as __weak; archs
other than ia64 should not override the default implementation.

V8:
1. For x86, always return PAGE_KERNEL for arch_apei_get_mem_attribute().
   The rational is explained in comment.
2. Rebased to arm64-upstream-14201 of arm64/master,
   next-20150724 of linux-next/master.
V7:
1. Added PROT_DEVICE_nGnRnE and PROT_NORMAL_WT to support all
   possible UEFI memory types for arm64.
V6:
1. Implemented arch_apei_get_mem_attributes() for arm64 as inline
   function.
2. Rebased to efi-next-14364 of efi/next, pm+acpi-4.2-rc3 of
   linux-pm/master, arm64-upstream-13521 of arm64/master,
   next-20150720 of linux-next/master.
V5:
1. Rebased to next-20150713 of linux-next/master, efi-next-14359 of
   efi/next, pm+acpi-4.2-rc2 of linux-pm/master,
   arm64-fixes-1215 of arm64/master.
2. Added comment for efi_mem_attributes(), explained why it is marked
   as __weak at the function definition site.
V4:
1. Introduced arch_apei_get_mem_attributes() to allow arch specific
   implementation of getting pgprot_t appropriate for a physical
   address.
2. Implemented arch_apei_get_mem_attributes() for x86 and for arm64.
V3:
1. Rebased to v4.1-rc7.
2. Moved efi_mem_attributes() from arch/x86 to drivers/firmware/efi
   and declared it as __weak.
3. Introduced ARCH_APEI_PAGE_KERNEL_UC to allow arch specific page
   protection type for UC.
4. Removed efi_ioremap(). It can not be used for GHES memory region
   mapping purpose since ioremap can not be used in atomic context.
V2:
1. Rebased to v4.1-rc5.
2. Split removal of efi_mem_attributes() and creation of efi_ioremap()
   into two patches.

Jonathan (Zhixiong) Zhang (5):
  efi: x86: rearrange efi_mem_attributes()
  x86: acpi: implement arch_apei_get_mem_attributes()
  arm64: mm: add PROT_DEVICE_nGnRnE and PROT_NORMAL_WT
  arm64: apei: implement arch_apei_get_mem_attributes()
  acpi, apei: use appropriate pgprot_t to map GHES memory

 arch/arm64/include/asm/acpi.h    | 26 ++++++++++++++++++++++++++
 arch/arm64/include/asm/memory.h  |  1 +
 arch/arm64/include/asm/pgtable.h |  2 ++
 arch/arm64/mm/proc.S             |  4 +++-
 arch/x86/kernel/acpi/apei.c      | 19 +++++++++++++++++++
 arch/x86/platform/efi/efi.c      | 18 ------------------
 drivers/acpi/apei/ghes.c         |  6 ++++--
 drivers/firmware/efi/efi.c       | 31 +++++++++++++++++++++++++++++++
 include/acpi/apei.h              |  1 +
 9 files changed, 87 insertions(+), 21 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
