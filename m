From: Roy Franz <roy.franz@linaro.org>
Subject: [PATCH V6 1/8] efi-stub.txt updates for ARM
Date: Fri, 10 Jan 2014 08:30:10 -0800
Message-ID: <1389371417-379-2-git-send-email-roy.franz@linaro.org>
References: <1389371417-379-1-git-send-email-roy.franz@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1389371417-379-1-git-send-email-roy.franz@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com, linux@arm.linux.org.uk
Cc: patches@linaro.org, leif.lindholm@linaro.org, Roy Franz <roy.franz@linaro.org>, msalter@redhat.com, grant.likely@linaro.org, dave.martin@arm.com
List-Id: linux-efi@vger.kernel.org

Update efi-stub.txt documentation to be more general
and not x86 specific.  Add ARM only "dtb=" command
line option description.

Signed-off-by: Roy Franz <roy.franz@linaro.org>
Acked-by: Grant Likely <grant.likely@linaro.org>
---
 Documentation/efi-stub.txt |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/Documentation/efi-stub.txt b/Documentation/efi-stub.txt
index 44e6bb6..a55a0cd 100644
--- a/Documentation/efi-stub.txt
+++ b/Documentation/efi-stub.txt
@@ -1,13 +1,16 @@
 			  The EFI Boot Stub
 		     ---------------------------
 
-On the x86 platform, a bzImage can masquerade as a PE/COFF image,
-thereby convincing EFI firmware loaders to load it as an EFI
-executable. The code that modifies the bzImage header, along with the
-EFI-specific entry point that the firmware loader jumps to are
-collectively known as the "EFI boot stub", and live in
+On the x86 and ARM platforms, a kernel zImage/bzImage can masquerade
+as a PE/COFF image, thereby convincing EFI firmware loaders to load
+it as an EFI executable. The code that modifies the bzImage header,
+along with the EFI-specific entry point that the firmware loader
+jumps to are collectively known as the "EFI boot stub", and live in
 arch/x86/boot/header.S and arch/x86/boot/compressed/eboot.c,
-respectively.
+respectively. For ARM the EFI stub is implemented in
+arch/arm/boot/compressed/efi-header.S and
+arch/arm/boot/compressed/efi-stub.c. EFI stub code that is shared
+between architectures is in drivers/firmware/efi/efi-stub-helper.c.
 
 By using the EFI boot stub it's possible to boot a Linux kernel
 without the use of a conventional EFI boot loader, such as grub or
@@ -23,7 +26,9 @@ The bzImage located in arch/x86/boot/bzImage must be copied to the EFI
 System Partiion (ESP) and renamed with the extension ".efi". Without
 the extension the EFI firmware loader will refuse to execute it. It's
 not possible to execute bzImage.efi from the usual Linux file systems
-because EFI firmware doesn't have support for them.
+because EFI firmware doesn't have support for them. For ARM the
+arch/arm/boot/zImage should be copied to the system partition, and it
+may not need to be renamed.
 
 
 **** Passing kernel parameters from the EFI shell
@@ -63,3 +68,11 @@ Notice how bzImage.efi can be specified with a relative path. That's
 because the image we're executing is interpreted by the EFI shell,
 which understands relative paths, whereas the rest of the command line
 is passed to bzImage.efi.
+
+
+**** The "dtb=" option
+
+For the ARM architecture, we also need to be able to provide a device
+tree to the kernel. This is done with the "dtb=" command line option,
+and is processed in the same manner as the "initrd=" option that is
+described above.
-- 
1.7.10.4
