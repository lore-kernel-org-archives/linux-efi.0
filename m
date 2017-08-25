From: Florent Revest <florent.revest@arm.com>
Subject: [RFC 09/11] EFI, arm, arm64: Enable EFI Runtime Services later
Date: Fri, 25 Aug 2017 09:31:39 +0100
Message-ID: <1503649901-5834-10-git-send-email-florent.revest@arm.com>
References: <1503649901-5834-1-git-send-email-florent.revest@arm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1503649901-5834-1-git-send-email-florent.revest@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: matt@codeblueprint.co.uk, ard.biesheuvel@linaro.org, pbonzini@redhat.com, rkrcmar@redhat.com, christoffer.dall@linaro.org, catalin.marinas@arm.com, will.deacon@arm.com, mark.rutland@arm.com, marc.zyngier@arm.com, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, leif.lindholm@arm.com, revestflo@gmail.com, Florent Revest <florent.revest@arm.com>
List-Id: linux-efi@vger.kernel.org

EFI Runtime Services on ARM are enabled very early in the boot process
although they aren't used until substantially later. This patch modifies
the efi initialization sequence on ARM to enable runtime services just
before they are effectively needed (in a subsys target instead of early).

The reason behind this change is that eventually, a late Runtime Services
initialization could take advantage of KVM's internal virtual machines to
sandbox firmware code execution. Since KVM's core is only available
starting from the subsys target, this reordering would be compulsory.

Signed-off-by: Florent Revest <florent.revest@arm.com>
---
 arch/arm/include/asm/efi.h         | 2 ++
 arch/arm64/include/asm/efi.h       | 2 ++
 arch/x86/include/asm/efi.h         | 2 ++
 drivers/firmware/efi/arm-runtime.c | 3 +--
 drivers/firmware/efi/efi.c         | 3 +++
 5 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/efi.h b/arch/arm/include/asm/efi.h
index 17f1f1a..ed575ae 100644
--- a/arch/arm/include/asm/efi.h
+++ b/arch/arm/include/asm/efi.h
@@ -35,6 +35,8 @@
        __f(args);                                                      \
 })

+int efi_arch_late_enable_runtime_services(void);
+
 #define ARCH_EFI_IRQ_FLAGS_MASK \
        (PSR_J_BIT | PSR_E_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT | \
         PSR_T_BIT | MODE_MASK)
diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index 8f3043a..373d94d 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -37,6 +37,8 @@
        kernel_neon_end();                                              \
 })

+int efi_arch_late_enable_runtime_services(void);
+
 #define ARCH_EFI_IRQ_FLAGS_MASK (PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F=
_BIT)

 /* arch specific definitions used by the stub code */
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 796ff6c..869efbb 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -233,6 +233,8 @@ static inline bool efi_is_64bit(void)

 extern bool efi_reboot_required(void);

+int __init efi_arch_late_enable_runtime_services(void) {}
+
 #else
 static inline void parse_efi_setup(u64 phys_addr, u32 data_len) {}
 static inline bool efi_reboot_required(void)
diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-=
runtime.c
index 1cc41c3..d94d240 100644
--- a/drivers/firmware/efi/arm-runtime.c
+++ b/drivers/firmware/efi/arm-runtime.c
@@ -115,7 +115,7 @@ static bool __init efi_virtmap_init(void)
  * non-early mapping of the UEFI system table and virtual mappings for all
  * EFI_MEMORY_RUNTIME regions.
  */
-static int __init arm_enable_runtime_services(void)
+int __init efi_arch_late_enable_runtime_services(void)
 {
        u64 mapsize;

@@ -154,7 +154,6 @@ static int __init arm_enable_runtime_services(void)

        return 0;
 }
-early_initcall(arm_enable_runtime_services);

 void efi_virtmap_load(void)
 {
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 045d6d3..2b447b4 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -33,6 +33,7 @@
 #include <linux/memblock.h>

 #include <asm/early_ioremap.h>
+#include <asm/efi.h>

 struct efi __read_mostly efi =3D {
        .mps                    =3D EFI_INVALID_TABLE_ADDR,
@@ -304,6 +305,8 @@ static int __init efisubsys_init(void)
 {
        int error;

+       efi_arch_late_enable_runtime_services();
+
        if (!efi_enabled(EFI_BOOT))
                return 0;

--
1.9.1

IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
