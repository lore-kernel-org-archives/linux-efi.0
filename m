From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v2 12/16] ARM: Xen: Document UEFI support on Xen ARM virtual platforms
Date: Fri, 15 Jan 2016 14:55:25 +0800
Message-ID: <1452840929-19612-13-git-send-email-zhaoshenglong@huawei.com>
References: <1452840929-19612-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1452840929-19612-1-git-send-email-zhaoshenglong@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org, stefano.stabellini@citrix.com, david.vrabel@citrix.com
Cc: catalin.marinas@arm.com, will.deacon@arm.com, mark.rutland@arm.com, julien.grall@citrix.com, xen-devel@lists.xen.org, devicetree@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com
List-Id: linux-efi@vger.kernel.org

From: Shannon Zhao <shannon.zhao@linaro.org>

Add a "uefi" node under /hypervisor node in FDT, then Linux kernel could
scan this to get the UEFI information.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 Documentation/devicetree/bindings/arm/xen.txt | 42 +++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/xen.txt b/Documentation/devicetree/bindings/arm/xen.txt
index 0f7b9c2..fbc17ae 100644
--- a/Documentation/devicetree/bindings/arm/xen.txt
+++ b/Documentation/devicetree/bindings/arm/xen.txt
@@ -15,6 +15,36 @@ the following properties:
 - interrupts: the interrupt used by Xen to inject event notifications.
   A GIC node is also required.
 
+To support UEFI on Xen ARM virtual platforms, Xen pupulates the FDT "uefi" node
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
+
+Below is the format of the mmap descriptor.
+typedef struct {
+	u32 type;
+	u32 pad;
+	u64 phys_addr;
+	u64 virt_addr;
+	u64 num_pages;
+	u64 attribute;
+} efi_memory_desc_t;
 
 Example (assuming #address-cells = <2> and #size-cells = <2>):
 
@@ -22,4 +52,16 @@ hypervisor {
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
+These "xen,uefi-*" parameters are similar to those in Documentation/arm/uefi.txt
+which are used by normal UEFI. But to Xen ARM virtual platforms, it needs to
+introduce a Xen specific UEFI and it doesn't want to mix with normal UEFI.
+Therefore, it defines these parameters under /hypervisor node.
-- 
2.0.4
