From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v3 13/17] ARM: Xen: Document UEFI support on Xen ARM virtual platforms
Date: Sat, 23 Jan 2016 11:19:40 +0800
Message-ID: <1453519184-11908-14-git-send-email-zhaoshenglong@huawei.com>
References: <1453519184-11908-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1453519184-11908-1-git-send-email-zhaoshenglong@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org, mark.rutland@arm.com, stefano.stabellini@citrix.com, david.vrabel@citrix.com
Cc: catalin.marinas@arm.com, will.deacon@arm.com, julien.grall@citrix.com, xen-devel@lists.xen.org, devicetree@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, ian.campbell@citrix.com, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, Rob Herring <robh@kernel.org>
List-Id: linux-efi@vger.kernel.org

From: Shannon Zhao <shannon.zhao@linaro.org>

Add a "uefi" node under /hypervisor node in FDT, then Linux kernel could
scan this to get the UEFI information.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
Acked-by: Rob Herring <robh@kernel.org>
---
CC: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/arm/xen.txt | 34 +++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/xen.txt b/Documentation/devicetree/bindings/arm/xen.txt
index 0f7b9c2..aa69405 100644
--- a/Documentation/devicetree/bindings/arm/xen.txt
+++ b/Documentation/devicetree/bindings/arm/xen.txt
@@ -15,6 +15,26 @@ the following properties:
 - interrupts: the interrupt used by Xen to inject event notifications.
   A GIC node is also required.
 
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
 
@@ -22,4 +42,18 @@ hypervisor {
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
+The format and meaning of these "xen,uefi-*" parameters are similar to those in
+Documentation/arm/uefi.txt which are used by normal UEFI. But to distinguish
+from normal UEFI, for Xen ARM virtual platforms it needs to introduce a Xen
+specific UEFI which requires Xen hypervisor to provide hypercalls for Dom0 to
+make use of the runtime services. Therefore, it defines these parameters under
+/hypervisor node.
-- 
2.0.4
