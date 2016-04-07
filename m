From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v11 13/17] ARM: Xen: Document UEFI support on Xen ARM virtual platforms
Date: Thu, 7 Apr 2016 20:03:30 +0800
Message-ID: <1460030614-16112-14-git-send-email-zhaoshenglong@huawei.com>
References: <1460030614-16112-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1460030614-16112-1-git-send-email-zhaoshenglong@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, sstabellini@kernel.org
Cc: catalin.marinas@arm.com, will.deacon@arm.com, julien.grall@arm.com, david.vrabel@citrix.com, xen-devel@lists.xen.org, devicetree@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, Rob Herring <robh@kernel.org>
List-Id: linux-efi@vger.kernel.org

From: Shannon Zhao <shannon.zhao@linaro.org>

Add a "uefi" node under /hypervisor node in FDT, then Linux kernel could
scan this to get the UEFI information.

CC: Rob Herring <robh@kernel.org>
Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
Acked-by: Rob Herring <robh@kernel.org>
Reviewed-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 Documentation/devicetree/bindings/arm/xen.txt | 35 +++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/xen.txt b/Documentation/devicetree/bindings/arm/xen.txt
index 0f7b9c2..c9b9321 100644
--- a/Documentation/devicetree/bindings/arm/xen.txt
+++ b/Documentation/devicetree/bindings/arm/xen.txt
@@ -11,10 +11,32 @@ the following properties:
   memory where the grant table should be mapped to, using an
   HYPERVISOR_memory_op hypercall. The memory region is large enough to map
   the whole grant table (it is larger or equal to gnttab_max_grant_frames()).
+  This property is unnecessary when booting Dom0 using ACPI.
 
 - interrupts: the interrupt used by Xen to inject event notifications.
   A GIC node is also required.
+  This property is unnecessary when booting Dom0 using ACPI.
 
+To support UEFI on Xen ARM virtual platforms, Xen populates the FDT "uefi" node
+under /hypervisor with following parameters:
+
+________________________________________________________________________________
+Name                      | Size   | Description
+================================================================================
+xen,uefi-system-table     | 64-bit | Guest physical address of the UEFI System
+			  |	   | Table.
+--------------------------------------------------------------------------------
+xen,uefi-mmap-start       | 64-bit | Guest physical address of the UEFI memory
+			  |	   | map.
+--------------------------------------------------------------------------------
+xen,uefi-mmap-size        | 32-bit | Size in bytes of the UEFI memory map
+                          |        | pointed to in previous entry.
+--------------------------------------------------------------------------------
+xen,uefi-mmap-desc-size   | 32-bit | Size in bytes of each entry in the UEFI
+                          |        | memory map.
+--------------------------------------------------------------------------------
+xen,uefi-mmap-desc-ver    | 32-bit | Version of the mmap descriptor format.
+--------------------------------------------------------------------------------
 
 Example (assuming #address-cells = <2> and #size-cells = <2>):
 
@@ -22,4 +44,17 @@ hypervisor {
 	compatible = "xen,xen-4.3", "xen,xen";
 	reg = <0 0xb0000000 0 0x20000>;
 	interrupts = <1 15 0xf08>;
+	uefi {
+		xen,uefi-system-table = <0xXXXXXXXX>;
+		xen,uefi-mmap-start = <0xXXXXXXXX>;
+		xen,uefi-mmap-size = <0xXXXXXXXX>;
+		xen,uefi-mmap-desc-size = <0xXXXXXXXX>;
+		xen,uefi-mmap-desc-ver = <0xXXXXXXXX>;
+        };
 };
+
+The format and meaning of the "xen,uefi-*" parameters are similar to those in
+Documentation/arm/uefi.txt, which are provided by the regular UEFI stub. However
+they differ because they are provided by the Xen hypervisor, together with a set
+of UEFI runtime services implemented via hypercalls, see
+http://xenbits.xen.org/docs/unstable/hypercall/x86_64/include,public,platform.h.html.
-- 
2.0.4
