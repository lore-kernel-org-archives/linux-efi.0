From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v2 00/16] Add ACPI support for Xen Dom0 on ARM64
Date: Fri, 15 Jan 2016 14:55:13 +0800
Message-ID: <1452840929-19612-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xen.org>
List-Unsubscribe: <http://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <http://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Sender: xen-devel-bounces@lists.xen.org
Errors-To: xen-devel-bounces@lists.xen.org
To: linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org, stefano.stabellini@citrix.com, david.vrabel@citrix.com
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org, linux-efi@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, xen-devel@lists.xen.org, julien.grall@citrix.com, shannon.zhao@linaro.org, peter.huangpeng@huawei.com
List-Id: linux-efi@vger.kernel.org

From: Shannon Zhao <shannon.zhao@linaro.org>

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


Changes since v1:
* Rebase on linux mainline and wallclock patch from Stefano
* Refactor AMBA and platform device MMIO map to one file
* Use EFI_PARAVIRT to check if it supports XEN EFI
* Refactor Xen EFI codes
* Address other comments

Shannon Zhao (16):
  Xen: ACPI: Hide UART used by Xen
  xen/grant-table: Move xlated_setup_gnttab_pages to common place
  Xen: xlate: Use page_to_xen_pfn instead of page_to_pfn
  arm/xen: Use xen_xlate_map_ballooned_pages to setup grant table
  xen: memory : Add new XENMAPSPACE type XENMAPSPACE_dev_mmio
  Xen: ARM: Add support for mapping platform device mmio
  Xen: ARM: Add support for mapping AMBA device mmio
  xen/hvm/params: Add a new delivery type for event-channel in
    HVM_PARAM_CALLBACK_IRQ
  arm/xen: Get event-channel irq through HVM_PARAM when booting with
    ACPI
  ARM: XEN: Move xen_early_init() before efi_init()
  ARM64: ACPI: Check if it runs on Xen to enable or disable ACPI
  ARM: Xen: Document UEFI support on Xen ARM virtual platforms
  ARM: XEN: Set EFI_PARAVIRT if Xen supports EFI
  Xen: EFI: Parse DT parameters for Xen specific UEFI
  XEN: EFI: Move x86 specific codes to architecture directory
  ARM64: XEN: Initialize Xen specific UEFI runtime services

 Documentation/devicetree/bindings/arm/xen.txt |  42 ++++++
 arch/arm/xen/enlighten.c                      | 121 +++++++++++++----
 arch/arm64/kernel/acpi.c                      |  12 +-
 arch/arm64/kernel/efi.c                       |   5 +
 arch/arm64/kernel/setup.c                     |   2 +-
 arch/arm64/xen/Makefile                       |   1 +
 arch/arm64/xen/efi.c                          |  36 +++++
 arch/x86/xen/efi.c                            | 112 ++++++++++++++++
 arch/x86/xen/grant-table.c                    |  57 +-------
 drivers/acpi/bus.c                            |  30 +++++
 drivers/firmware/efi/efi.c                    |  45 ++++++-
 drivers/xen/Kconfig                           |   2 +-
 drivers/xen/Makefile                          |   1 +
 drivers/xen/arm-device.c                      | 183 ++++++++++++++++++++++++++
 drivers/xen/efi.c                             | 174 +++++-------------------
 drivers/xen/xlate_mmu.c                       |  61 +++++++++
 include/xen/interface/hvm/params.h            |   5 +
 include/xen/interface/memory.h                |   1 +
 include/xen/xen-ops.h                         |  33 +++--
 19 files changed, 689 insertions(+), 234 deletions(-)
 create mode 100644 arch/arm64/xen/efi.c
 create mode 100644 drivers/xen/arm-device.c

-- 
2.0.4
