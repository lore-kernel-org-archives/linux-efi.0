From: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>
Subject: [PATCH V4 0/4] map GHES memory region according to EFI memory map
Date: Fri, 12 Jun 2015 18:01:43 -0700
Message-ID: <1434157307-32318-1-git-send-email-zjzhang@codeaurora.org>
Return-path: <linux-acpi-owner@vger.kernel.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, leif.lindholm@linaro.org, fu.wei@linaro.org, al.stone@linaro.org, bp@alien8.de, tony.luck@gmail.com, rjw@rjwysocki.net, lenb@kernel.org, ying.huang@intel.com
Cc: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-arm-msm@vger.kernel.org, linaro-acpi@lists.linaro.org, vgandhi@codeaurora.org
List-Id: linux-efi@vger.kernel.org

From: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>

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

Jonathan (Zhixiong) Zhang (4):
  efi: x86: rearrange efi_mem_attributes()
  x86: acpi: add arch_apei_get_mem_attributes()
  arm64: apei: implement arch_apei_get_mem_attributes()
  acpi, apei: use appropriate pgprot_t to map GHES memory

 arch/arm64/kernel/Makefile  |  1 +
 arch/arm64/kernel/apei.c    | 27 +++++++++++++++++++++++++++
 arch/x86/kernel/acpi/apei.c | 10 ++++++++++
 arch/x86/platform/efi/efi.c | 18 ------------------
 drivers/acpi/apei/ghes.c    |  6 ++++--
 drivers/firmware/efi/efi.c  | 18 ++++++++++++++++++
 include/acpi/apei.h         |  1 +
 7 files changed, 61 insertions(+), 20 deletions(-)
 create mode 100644 arch/arm64/kernel/apei.c

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

