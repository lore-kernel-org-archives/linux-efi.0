From: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>
Subject: [PATCH 0/2] map GHES memory region with EFI memory map
Date: Mon,  4 May 2015 14:02:13 -0700
Message-ID: <1430773335-22897-1-git-send-email-zjzhang@codeaurora.org>
Return-path: <linux-acpi-owner@vger.kernel.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-arm-msm@vger.kernel.org, linaro-acpi@lists.linaro.org
List-Id: linux-efi@vger.kernel.org

From: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>

On a platform with APEI (ACPI Platform Error Interface) enabled, firmware
updates a memory region with hardware error record using nocache
attribute. When OS reads the region, since it maps the region with cache 
attribute even though EFI memory map defines this region as uncached, OS 
gets stale data and errorneously reports there is no new HW error.

When ghes driver maps the memory region, it uses the cache attribute
according to EFI memory map, if EFI memory map feature is enabled.

Since both arch/x86 and arc/ia64 implemented architecture agnostic EFI 
memory map attribue lookup function, the code is moved from arch/x86
and arch/ia64 into EFI subsystem.

Jonathan (Zhixiong) Zhang (2):
  efi: arch, x86: arch, ia64: rearrange EFI memmap related functions
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

