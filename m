From: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>
Subject: [PATCH V2 0/3] map GHES memory region with EFI memory map
Date: Mon,  1 Jun 2015 12:12:17 -0700
Message-ID: <1433185940-24770-1-git-send-email-zjzhang@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, leif.lindholm@linaro.org, al.stone@linaro.org, fu.wei@linaro.org, rjw@rjwysocki.net, lenb@kernel.org, ying.huang@intel.com
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

Since both arch/x86 and arc/ia64 implemented architecture agnostic EFI
memory map attribue lookup function efi_memattributes(), the code is
moved from arch/x86 and arch/ia64 into EFI subsystem. On top of that,
efi_remap() is added.

V2:
1. Rebased to v4.1-rc5.
2. Split removal of efi_mem_attributes() and creation of efi_ioremap()
into two patches.

Jonathan (Zhixiong) Zhang (3):
  efi: arch, x86: arch, ia64: move efi_mem_attributes()
  efi: add efi_remap()
  acpi, apei: use EFI memmap to map GHES memory

 arch/ia64/kernel/efi.c      | 11 -----------
 arch/x86/platform/efi/efi.c | 18 ------------------
 drivers/acpi/apei/ghes.c    | 13 +++++++++++++
 drivers/firmware/efi/efi.c  | 27 +++++++++++++++++++++++++++
 include/linux/efi.h         |  1 +
 5 files changed, 41 insertions(+), 29 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
