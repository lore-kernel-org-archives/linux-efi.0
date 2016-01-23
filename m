From: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 00/17] Add ACPI support for Xen Dom0 on ARM64
Date: Sat, 23 Jan 2016 11:19:27 +0800
Message-ID: <1453519184-11908-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org
Cc: catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
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

Patches are tested on FVP base model. The corresponding Xen patches can
be fetched from [2].

Thanks,
Shannon

[1] http://lists.xen.org/archives/html/xen-devel/2015-11/msg00488.html
[2] http://git.linaro.org/people/shannon.zhao/xen.git  ACPI_XEN_ARM_V3

Changes since v2:
* Use 0 to check if it should ignore the UART
* Fix the use of page_to_xen_pfn
* Factor ACPI and DT parts in xen_guest_init
* Check "uefi" node by full path
* Fix the statement of Documentation/devicetree/bindings/arm/xen.txt

Changes since v1:
* Rebase on linux mainline and wallclock patch from Stefano
* Refactor AMBA and platform device MMIO map to one file
* Use EFI_PARAVIRT to check if it supports XEN EFI
* Refactor Xen EFI codes
* Address other comments

Shannon Zhao (17):
  Xen: ACPI: Hide UART used by Xen
  xen/grant-table: Move xlated_setup_gnttab_pages to common place
  Xen: xlate: Use page_to_xen_pfn instead of page_to_pfn
  arm/xen: Use xen_xlate_map_ballooned_pages to setup grant table
  xen: memory : Add new XENMAPSPACE type XENMAPSPACE_dev_mmio
  Xen: ARM: Add support for mapping platform device mmio
  Xen: ARM: Add support for mapping AMBA device mmio
  Xen: public/hvm: sync changes of HVM_PARAM_CALLBACK_VIA ABI from Xen
  xen/hvm/params: Add a new delivery type for event-channel in
    HVM_PARAM_CALLBACK_IRQ
  arm/xen: Get event-channel irq through HVM_PARAM when booting with
    ACPI
  ARM: XEN: Move xen_early_init() before efi_init()
  ARM64: ACPI: Check if it runs on Xen to enable or disable ACPI
  ARM: Xen: Document UEFI support on Xen ARM virtual platforms
  XEN: EFI: Move x86 specific codes to architecture directory
  ARM64: XEN: Add a function to initialize Xen specific UEFI runtime
    services
  FDT: Add a helper to get specified name subnode
  Xen: EFI: Parse DT parameters for Xen specific UEFI

 Documentation/devicetree/bindings/arm/xen.txt |  34 +++++
 arch/arm/xen/enlighten.c                      | 109 +++++++++++----
 arch/arm64/include/asm/xen/xen-ops.h          |   6 +
 arch/arm64/kernel/acpi.c                      |  12 +-
 arch/arm64/kernel/efi.c                       |  17 ++-
 arch/arm64/kernel/setup.c                     |   2 +-
 arch/arm64/xen/Makefile                       |   1 +
 arch/arm64/xen/efi.c                          |  40 ++++++
 arch/x86/xen/efi.c                            | 112 ++++++++++++++++
 arch/x86/xen/grant-table.c                    |  57 +-------
 drivers/acpi/bus.c                            |  36 ++++-
 drivers/firmware/efi/efi.c                    |  45 ++++++-
 drivers/of/fdt.c                              |  35 +++++
 drivers/xen/Kconfig                           |   2 +-
 drivers/xen/Makefile                          |   1 +
 drivers/xen/arm-device.c                      | 184 ++++++++++++++++++++++++++
 drivers/xen/efi.c                             | 174 +++++-------------------
 drivers/xen/xlate_mmu.c                       |  67 ++++++++++
 include/linux/of_fdt.h                        |   2 +
 include/xen/interface/hvm/params.h            |  36 ++++-
 include/xen/interface/memory.h                |   1 +
 include/xen/xen-ops.h                         |  32 +++--
 22 files changed, 757 insertions(+), 248 deletions(-)
 create mode 100644 arch/arm64/include/asm/xen/xen-ops.h
 create mode 100644 arch/arm64/xen/efi.c
 create mode 100644 drivers/xen/arm-device.c

-- 
2.0.4


--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
