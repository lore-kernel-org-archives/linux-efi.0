From: Grant Likely <grant.likely@arm.com>
Subject: [PATCH] efi_stub: update documentation on dtb= parameter
Date: Wed,  5 Sep 2018 20:07:50 +0100
Message-ID: <20180905190750.4566-1-grant.likely@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Jonathan Corbet <corbet@lwn.net>, arnd@arndb.de, scott.branden@broadcom.com, catalin.marinas@arm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>, will.deacon@arm.com, agraf@suse.de, leif.lindholm@linaro.org, Grant Likely <grant.likely@arm.com>, olof@lixom.net
List-Id: linux-efi@vger.kernel.org

The dtb= parameter is no longer the primary mechanism for providing a
devicetree to the kernel. Now either firmware or the boot selector (ex.
Grub) should provide the devicetree and dtb= should only be used for
debug or when using firmware that doesn't understand DT.
Update the EFI stub documentation to reflect the current usage.

Signed-off-by: Grant Likely <grant.likely@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Jonathan Corbet <corbet@lwn.net>
---
 Documentation/efi-stub.txt | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/Documentation/efi-stub.txt b/Documentation/efi-stub.txt
index 41df801f9a50..833edb0d0bc4 100644
--- a/Documentation/efi-stub.txt
+++ b/Documentation/efi-stub.txt
@@ -83,7 +83,18 @@ is passed to bzImage.efi.
 The "dtb=" option
 -----------------

-For the ARM and arm64 architectures, we also need to be able to provide a
-device tree to the kernel. This is done with the "dtb=" command line option,
-and is processed in the same manner as the "initrd=" option that is
+For the ARM and arm64 architectures, a device tree must be provided to
+the kernel. Normally firmware shall supply the device tree via the
+EFI CONFIGURATION TABLE. However, the "dtb=" command line option can
+be used to override the firmware supplied device tree, or to supply
+one when firmware is unable to.
+
+Please note: Firmware adds runtime configuration information to the
+device tree before booting the kernel. If dtb= is used to override
+the device tree, then any runtime data provided by firmware will be
+lost. The dtb= option should only be used either as a debug tool, or
+as a last resort when a device tree is not provided in the EFI
+CONFIGURATION TABLE.
+
+"dtb=" is processed in the same manner as the "initrd=" option that is
 described above.
--
2.11.0

IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
