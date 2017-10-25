From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/2] efi/libstub: arm: don't randomize runtime regions when CONFIG_HIBERNATION=y
Date: Wed, 25 Oct 2017 11:04:48 +0100
Message-ID: <20171025100448.26056-3-ard.biesheuvel@linaro.org>
References: <20171025100448.26056-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171025100448.26056-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, James Morse <james.morse@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

Commit

  e69176d68d26 ef/libstub/arm/arm64: Randomize the base of the UEFI rt services region

implemented randomization of the virtual mapping that the OS chooses for
the UEFI runtime services. This was motivated by the fact that UEFI usually
does not bother to specify any permission restrictions for those regions,
making them prime real estate for exploitation now that the OS is getting
more and more careful not to leave any R+W+X mapped regions lying around.

However, this randomization breaks assumptions in the resume from
hibernation code, which expects all memory regions populated by UEFI to
remain in the same place, including their virtual mapping into the OS
memory space. While this assumption may not be entirely reasonable in the
first place, breaking it deliberately does not make a lot of sense either.
So let's refrain from this randomization pass if CONFIG_HIBERNATION=y.

Cc: James Morse <james.morse@arm.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/libstub/arm-stub.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index 1cb2d1c070c3..a94601d5939e 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -238,7 +238,8 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 
 	efi_random_get_seed(sys_table);
 
-	if (!nokaslr()) {
+	/* hibernation expects the runtime regions to stay in the same place */
+	if (!IS_ENABLED(CONFIG_HIBERNATION) && !nokaslr()) {
 		/*
 		 * Randomize the base of the UEFI runtime services region.
 		 * Preserve the 2 MB alignment of the region by taking a
-- 
2.11.0
