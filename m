From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 3/5] efi/arm: Show SMBIOS bank/device location in cper and ghes error logs
Date: Thu, 28 Mar 2019 20:34:27 +0100
Message-ID: <20190328193429.21373-4-ard.biesheuvel@linaro.org>
References: <20190328193429.21373-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190328193429.21373-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Marcin Benka <mbenka@marvell.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Robert Richter <rrichter@marvell.com>
List-Id: linux-efi@vger.kernel.org

From: Marcin Benka <mbenka@marvell.com>

Run dmi_memdev_walk() for arch arm* as other archs do. This improves
error logging as the memory device handle is translated now to the
DIMM entry's name provided by the DMI handle.

Before:

 {1}[Hardware Error]:   DIMM location: not present. DMI handle: 0x0038

After:

 {1}[Hardware Error]:   DIMM location: N0 DIMM_A0

Signed-off-by: Marcin Benka <mbenka@marvell.com>
Signed-off-by: Robert Richter <rrichter@marvell.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/arm-runtime.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
index 0c1af675c338..4a0dfe4ab829 100644
--- a/drivers/firmware/efi/arm-runtime.c
+++ b/drivers/firmware/efi/arm-runtime.c
@@ -167,6 +167,7 @@ static int __init arm_dmi_init(void)
 	 * itself, depends on dmi_scan_machine() having been called already.
 	 */
 	dmi_scan_machine();
+	dmi_memdev_walk();
 	if (dmi_available)
 		dmi_set_dump_stack_arch_desc();
 	return 0;
-- 
2.20.1
