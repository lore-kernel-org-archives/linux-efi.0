From: shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Subject: [PATCH 00/13] Add ACPI support for Xen Dom0 on ARM64
Date: Tue, 17 Nov 2015 17:56:58 +0800
Message-ID: <1447754231-7772-1-git-send-email-shannon.zhao@linaro.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hangaohuai-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

This patch set adds ACPI support for Xen Dom0 on ARM64. The relevant Xen
ACPI on ARM64 design document could be found from [1].

This patch set adds a new FDT node "uefi" under /hypervisor to pass UEFI
information. Introduce a bus notifier of AMBA and Platform bus to map
the new added device's MMIO space. Make Xen domain use
xlated_setup_gnttab_pages to setup grant table and a new hypercall to
get event-channel irq.

Regarding the initialization flow of Linux kernel, it needs to move
xen_early_init() before efi_init(). Then xen_early_init() will check
whether it runs on Xen through the /hypervisor node and efi_init() will
call a new function fdt_find_xen_uefi_params(), to parse those
xen,uefi-* parameters just like the existing efi_get_fdt_params().

And in arm64_enable_runtime_services() it will check whether it runs on
Xen and call another new function xen_efi_runtime_setup() to setup
runtime service instead of efi_native_runtime_setup(). The
xen_efi_runtime_setup() will assign the runtime function pointers with
the functions of driver/xen/efi.c.

And since we pass a /hypervisor node and a /chosen node to Dom0, it
needs to check whether the DTS only contains a /hypervisor node and a
/chosen node in acpi_boot_table_init().

Patches are tested on FVP base model. This patch set can be found from
[2] and the corresponding Xen patches can be found from [3].

Thanks,
Shannon

[1] http://lists.xen.org/archives/html/xen-devel/2015-11/msg00488.html
[2] http://git.linaro.org/people/shannon.zhao/linux-mainline.git  ACPI_XEN_ARM_Linux_V1
[3] http://git.linaro.org/people/shannon.zhao/xen.git  ACPI_XEN_ARM_V3

Shannon Zhao (13):
  Xen : Hide UART used by Xen
  xen/grant-table: Move xlated_setup_gnttab_pages to common place
  arm/xen: Use xlated_setup_gnttab_pages to setup grant table
  xen: memory : Add new XENMAPSPACE type XENMAPSPACE_dev_mmio
  Xen: ARM: Add support for mapping platform device mmio
  Xen: ARM: Add support for mapping amba device mmio
  ARM: Xen: Document UEFI support on Xen ARM virtual platforms
  Xen: EFI: Parse DT parameters for Xen specific UEFI
  ARM: Xen: Initialize Xen specific UEFI runtime services
  ARM64: ACPI: Check if it runs on Xen to enable or disable ACPI
  xen/hvm/params: Add a new dilivery type for event-channel in
    HVM_PARAM_CALLBACK_IRQ
  arm/xen: Get event-channel irq through HVM_PARAM when booting with
    ACPI
  ARM: XEN: Move xen_early_init() before efi_init()

 Documentation/devicetree/bindings/arm/xen.txt |  25 +++++++
 arch/arm/include/asm/xen/hypercall.h          |   1 +
 arch/arm/xen/enlighten.c                      |  96 +++++++++++++++++-------
 arch/arm/xen/hypercall.S                      |   1 +
 arch/arm64/kernel/acpi.c                      |  12 ++-
 arch/arm64/kernel/efi.c                       |  20 +++--
 arch/arm64/kernel/setup.c                     |   2 +-
 arch/arm64/xen/hypercall.S                    |   1 +
 arch/x86/xen/grant-table.c                    |  51 -------------
 drivers/acpi/bus.c                            |  22 ++++++
 drivers/firmware/efi/efi.c                    |  67 +++++++++++++++--
 drivers/xen/Kconfig                           |   2 +-
 drivers/xen/Makefile                          |   2 +
 drivers/xen/amba.c                            |  99 ++++++++++++++++++++++++
 drivers/xen/efi.c                             |  22 ++++++
 drivers/xen/grant-table.c                     |  49 ++++++++++++
 drivers/xen/platform.c                        | 104 ++++++++++++++++++++++++++
 include/xen/grant_table.h                     |   1 +
 include/xen/interface/hvm/params.h            |   5 ++
 include/xen/interface/memory.h                |   1 +
 include/xen/xen-ops.h                         |  10 +++
 21 files changed, 498 insertions(+), 95 deletions(-)
 create mode 100644 drivers/xen/amba.c
 create mode 100644 drivers/xen/platform.c

-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
