From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] efi/libstub/arm: Don't use TASK_SIZE when randomising the RT space
Date: Mon, 17 Apr 2017 10:32:01 +0100
Message-ID: <20170417093201.10181-2-ard.biesheuvel@linaro.org>
References: <20170417093201.10181-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170417093201.10181-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

As reported by James, Catalin and Mark, commit e69176d68d26
("ef/libstub/arm/arm64: Randomize the base of the UEFI rt services
region") results in a crash in the firmware regardless of whether KASLR
is in effect or not, and whether the firmware implements EFI_RNG_PROTOCOL
or not.

Mark has identified the root cause to be the inappropriate use of
TASK_SIZE in the stub, which arm64 defines as

  #define TASK_SIZE             (test_thread_flag(TIF_32BIT) ? \
                                TASK_SIZE_32 : TASK_SIZE_64)

and testing thread flags at this point results in the dereference of
pointers in uninitialized structures.

So instead, introduce a preprocessor symbol EFI_RT_VIRTUAL_LIMIT and
define it to TASK_SIZE_64 on arm64 and TASK_SIZE on ARM, both of which
are compile time constants. Also, change the 'headroom' variable to
static const to force an error if this might change in the future.

Cc: Matt Fleming <matt@codeblueprint.co.uk>
Tested-by: Mark Rutland <mark.rutland@arm.com>
Tested-by: James Morse <james.morse@arm.com>
Tested-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/libstub/arm-stub.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index 1e45ec51b094..34010ff3b77e 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -32,6 +32,12 @@
 #define EFI_RT_VIRTUAL_BASE	SZ_512M
 #define EFI_RT_VIRTUAL_SIZE	SZ_512M
 
+#ifdef CONFIG_ARM64
+#define EFI_RT_VIRTUAL_LIMIT	TASK_SIZE_64
+#else
+#define EFI_RT_VIRTUAL_LIMIT	TASK_SIZE
+#endif
+
 static u64 virtmap_base = EFI_RT_VIRTUAL_BASE;
 
 efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg,
@@ -236,8 +242,9 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 		 * shift of 21 bit positions into account when scaling
 		 * the headroom value using a 32-bit random value.
 		 */
-		u64 headroom = TASK_SIZE - EFI_RT_VIRTUAL_BASE -
-			       EFI_RT_VIRTUAL_SIZE;
+		static const u64 headroom = EFI_RT_VIRTUAL_LIMIT -
+					    EFI_RT_VIRTUAL_BASE -
+					    EFI_RT_VIRTUAL_SIZE;
 		u32 rnd;
 
 		status = efi_get_random_bytes(sys_table, sizeof(rnd),
-- 
2.9.3
