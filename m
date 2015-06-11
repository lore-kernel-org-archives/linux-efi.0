From: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>
Subject: [PATCH V3 0/4] map GHES memory region with EFI memory map
Date: Thu, 11 Jun 2015 11:25:56 -0700
Message-ID: <1434047160-23358-1-git-send-email-zjzhang@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Sender: linux-arm-msm-owner@vger.kernel.org
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
  x86: acpi: define uncached page flag
  arm64: acpi: define uncached page flag
  efi: x86: rearrange efi_mem_attributes()
  acpi, apei: use EFI memmap to map GHES memory

 arch/arm64/include/asm/acpi.h |  4 ++++
 arch/x86/include/asm/acpi.h   |  4 ++++
 arch/x86/platform/efi/efi.c   | 18 ------------------
 drivers/acpi/apei/ghes.c      |  9 ++++++++-
 drivers/firmware/efi/efi.c    | 18 ++++++++++++++++++
 5 files changed, 34 insertions(+), 19 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
