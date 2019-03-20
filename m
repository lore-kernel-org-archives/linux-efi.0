From: Robert Richter <rrichter@marvell.com>
Subject: [PATCH] efi/arm: Show SMBIOS bank/device location in cper and ghes
 error logs
Date: Wed, 20 Mar 2019 13:05:37 +0000
Message-ID: <20190320130502.16667-1-rrichter@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Robert Richter <rrichter@marvell.com>, Marcin Benka <mbenka@marvell.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

Run dmi_memdev_walk() for arch arm* as other archs do. This improves
error logging as the memory device handle is translated now to the
DIMM entry's name provided by the DMI handle.

Before:

 {1}[Hardware Error]:   DIMM location: not present. DMI handle: 0x0038

After:

 {1}[Hardware Error]:   DIMM location: N0 DIMM_A0

Signed-off-by: Marcin Benka <mbenka@marvell.com>
Signed-off-by: Robert Richter <rrichter@marvell.com>
---
 drivers/firmware/efi/arm-runtime.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-=
runtime.c
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
--=20
2.20.1
