From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH 5/9] efi/arm*: libstub: Invoke EFI_RNG_PROTOCOL to seed
 the UEFI RNG table
Date: Mon, 14 Nov 2016 16:10:33 +0100
Message-ID: <20161114151033.GA10141@wunner.de>
References: <20161112213237.8804-1-matt@codeblueprint.co.uk>
 <20161112213237.8804-6-matt@codeblueprint.co.uk>
 <20161113071939.GA31483@gmail.com>
 <20161113085932.GA4930@gmail.com>
 <20161114132708.GC2373@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161114132708.GC2373-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, Nov 14, 2016 at 01:27:08PM +0000, Matt Fleming wrote:
> On Sun, 13 Nov, at 09:59:32AM, Ingo Molnar wrote:
> > * Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > > I'll apply the patches from email and add your SOB.
> > 
> > Note that the attached config produces this build error:
> > 
> > drivers/firmware/efi/apple-properties.c:149:9: error: implicit declaration of function ???efi_get_device_by_path??? [-Werror=implicit-function-declaration]
> > 
> > also:
> > 
> >   warning: (THUNDERBOLT) selects APPLE_PROPERTIES which has unmet direct dependencies (EFI && EFI_STUB && X86)
> 
> Oops. Lukas, could you take a look at this (config attached).

Sorry for the breakage, I think the simplest solution is to modify
the last commit on the tip.git efi/core branch like this:


diff --git a/drivers/thunderbolt/Kconfig b/drivers/thunderbolt/Kconfig
index 0056df7..bb0318c 100644
--- a/drivers/thunderbolt/Kconfig
+++ b/drivers/thunderbolt/Kconfig
@@ -1,7 +1,7 @@
 menuconfig THUNDERBOLT
 	tristate "Thunderbolt support for Apple devices"
 	depends on PCI
-	select APPLE_PROPERTIES
+	select APPLE_PROPERTIES if EFI_STUB
 	select CRC32
 	help
 	  Cactus Ridge Thunderbolt Controller driver


A drop-in replacement commit is included below.

Thanks,

Lukas

-- >8 --
Subject: [PATCH] thunderbolt: Use Device ROM retrieved from EFI

Macs with Thunderbolt 1 do not have a unit-specific DROM: The DROM is
empty with uid 0x1000000000000. (Apple started factory-burning a unit-
specific DROM with Thunderbolt 2.)

Instead, the NHI EFI driver supplies a DROM in a device property. Use
it if available. It's only available when booting with the efistub.
If it's not available, silently fall back to our hardcoded DROM.

The size of the DROM is always 256 bytes. The number is hardcoded into
the NHI EFI driver. This commit can deal with an arbitrary size however,
just in case they ever change that.

Background information: The EFI firmware volume contains ROM files for
the NHI, GMUX and several other chips as well as key material. This
strategy allows Apple to deploy ROM or key updates by simply publishing
an EFI firmware update on their website. Drivers do not access those
files directly but rather through a file server via EFI protocol
AC5E4829-A8FD-440B-AF33-9FFE013B12D8. Files are identified by GUID, the
NHI DROM has 339370BD-CFC6-4454-8EF7-704653120818.

The NHI EFI driver amends that file with a unit-specific uid. The uid
has 64 bit but its entropy is much lower: 24 bit represent the model,
24 bit are taken from a serial number, 16 bit are fixed. The NHI EFI
driver obtains the serial number via the DataHub protocol, copies it
into the DROM, calculates the CRC and submits the result as a device
property.

A modification is needed in the resume code where we currently read the
uid of all switches in the hierarchy to detect plug events that occurred
during sleep. On Thunderbolt 1 root switches this will now lead to a
mismatch between the uid of the empty DROM and the EFI DROM. Exempt the
root switch from this check: It's built in, so the uid should never
change. However we continue to *read* the uid of the root switch, this
seems like a good way to test its reachability after resume.

Tested-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org> [MacBookPro9,1]
Tested-by: Pierre Moreau <pierre.morrow-GANU6spQydw@public.gmane.org> [MacBookPro11,3]
Signed-off-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Acked-by: Andreas Noever <andreas.noever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Pedro Vilaça <reverser-P1ImLx+pFc0@public.gmane.org>
Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Link: http://lkml.kernel.org/r/20161112213237.8804-10-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Signed-off-by: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/thunderbolt/Kconfig  |  1 +
 drivers/thunderbolt/eeprom.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 drivers/thunderbolt/switch.c |  2 +-
 3 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/drivers/thunderbolt/Kconfig b/drivers/thunderbolt/Kconfig
index c121acc..bb0318c 100644
--- a/drivers/thunderbolt/Kconfig
+++ b/drivers/thunderbolt/Kconfig
@@ -1,6 +1,7 @@
 menuconfig THUNDERBOLT
 	tristate "Thunderbolt support for Apple devices"
 	depends on PCI
+	select APPLE_PROPERTIES if EFI_STUB
 	select CRC32
 	help
 	  Cactus Ridge Thunderbolt Controller driver
diff --git a/drivers/thunderbolt/eeprom.c b/drivers/thunderbolt/eeprom.c
index 2b9602c..6392990 100644
--- a/drivers/thunderbolt/eeprom.c
+++ b/drivers/thunderbolt/eeprom.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/crc32.h>
+#include <linux/property.h>
 #include <linux/slab.h>
 #include "tb.h"
 
@@ -360,6 +361,40 @@ static int tb_drom_parse_entries(struct tb_switch *sw)
 }
 
 /**
+ * tb_drom_copy_efi - copy drom supplied by EFI to sw->drom if present
+ */
+static int tb_drom_copy_efi(struct tb_switch *sw, u16 *size)
+{
+	struct device *dev = &sw->tb->nhi->pdev->dev;
+	int len, res;
+
+	len = device_property_read_u8_array(dev, "ThunderboltDROM", NULL, 0);
+	if (len < 0 || len < sizeof(struct tb_drom_header))
+		return -EINVAL;
+
+	sw->drom = kmalloc(len, GFP_KERNEL);
+	if (!sw->drom)
+		return -ENOMEM;
+
+	res = device_property_read_u8_array(dev, "ThunderboltDROM", sw->drom,
+									len);
+	if (res)
+		goto err;
+
+	*size = ((struct tb_drom_header *)sw->drom)->data_len +
+							  TB_DROM_DATA_START;
+	if (*size > len)
+		goto err;
+
+	return 0;
+
+err:
+	kfree(sw->drom);
+	sw->drom = NULL;
+	return -EINVAL;
+}
+
+/**
  * tb_drom_read - copy drom to sw->drom and parse it
  */
 int tb_drom_read(struct tb_switch *sw)
@@ -374,6 +409,13 @@ int tb_drom_read(struct tb_switch *sw)
 
 	if (tb_route(sw) == 0) {
 		/*
+		 * Apple's NHI EFI driver supplies a DROM for the root switch
+		 * in a device property. Use it if available.
+		 */
+		if (tb_drom_copy_efi(sw, &size) == 0)
+			goto parse;
+
+		/*
 		 * The root switch contains only a dummy drom (header only,
 		 * no entries). Hardcode the configuration here.
 		 */
@@ -418,6 +460,7 @@ int tb_drom_read(struct tb_switch *sw)
 	if (res)
 		goto err;
 
+parse:
 	header = (void *) sw->drom;
 
 	if (header->data_len + TB_DROM_DATA_START != size) {
diff --git a/drivers/thunderbolt/switch.c b/drivers/thunderbolt/switch.c
index 9840fde..c6f30b1 100644
--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -460,7 +460,7 @@ int tb_switch_resume(struct tb_switch *sw)
 		tb_sw_warn(sw, "uid read failed\n");
 		return err;
 	}
-	if (sw->uid != uid) {
+	if (sw != sw->tb->root_switch && sw->uid != uid) {
 		tb_sw_info(sw,
 			"changed while suspended (uid %#llx -> %#llx)\n",
 			sw->uid, uid);
-- 
2.10.1
