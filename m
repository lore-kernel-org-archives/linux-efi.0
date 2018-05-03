From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH v5 2/5] efi: Add embedded peripheral firmware support
Date: Thu, 3 May 2018 23:29:21 +0000
Message-ID: <20180503232920.GF27853@wotan.suse.de>
References: <20180429093558.5411-1-hdegoede@redhat.com>
 <20180429093558.5411-3-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180429093558.5411-3-hdegoede@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Jones <pjones@redhat.com>, Dave Olsthoorn <dave@bewaar.me>, Will Deacon <will.deacon@arm.com>, andresx7@gmail.com, Andy Lutomirski <luto@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, dmitry.torokhov@gmail.com, mfuzzey@parkeon.com, Kalle Valo <kvalo@codeaurora.org>, Arend Van Spriel <arend.vanspriel@broadcom.com>, Linus Torvalds <torvalds@linux-foundation.org>, nbroeking@me.com, bjorn.ande
List-Id: linux-efi@vger.kernel.org

Please Cc andresx7@gmail.com  on future patches.

On Sun, Apr 29, 2018 at 11:35:55AM +0200, Hans de Goede wrote:
> Just like with PCI options ROMs, which we save in the setup_efi_pci*
> functions from arch/x86/boot/compressed/eboot.c, the EFI code / ROM itself
> sometimes may contain data which is useful/necessary for peripheral drivers
> to have access to.

Interesting. Mimi you may want to look into that for appraisal gap coverage.

> Specifically the EFI code may contain an embedded copy of firmware which
> needs to be (re)loaded into the peripheral. Normally such firmware would be
> part of linux-firmware, but in some cases this is not feasible, for 2
> reasons:

This and other reasons have been scattered through mailing lists, and
documentation, our Kconfig does not reflect which of the reasons are
currently addressed as how. Our goal for your commit log would be to
document the precise reason you can't use any of the existing interfaces
exposed. Let's see if some of the reasons you state cannot be used
with the existing APIs.

> 1) The firmware is customized for a specific use-case of the chipset / use
> with a specific hardware model, so we cannot have a single firmware file
> for the chipset. E.g. touchscreen controller firmwares are compiled
> specifically for the hardware model they are used with, as they are
> calibrated for a specific model digitizer.

In such cases the firmware may be stashed in a separate partition of a custom
device and firmwared could be used with a uevent and the fallback mechanism,
enabling userspace to do whatever it needs.

However in your case the firmware has been found on EFI.

> 2) Despite repeated attempts we have failed to get permission to
> redistribute the firmware. This is especially a problem with customized
> firmwares, these get created by the chip vendor for a specific ODM and the
> copyright may partially belong with the ODM, so the chip vendor cannot
> give a blanket permission to distribute these.

Indeed, we don't have a good way to deal with this now except the above
noted firmwared use case, and that still ponies up the redistribution problem
up to a system integrator somehow.

But also -- your solution is super custom to only two drivers, does not
follow a standard of any sort either, and I fear of setting any wrong
precedents which will be hard to later not support.

Just look at the fallback mechanism and how hairy it got, I've put some
love into it recently but it was a pain to even comprehend. Once we add
this interface we are going to have to support it for a while so I want
to be sure we get the architecture right. Specially if were going to enable
*other* vendors to start using such interface.

Is your goal to enable or encourage other vendors in similar predicament to
use the same strategy?

There is nothing wrong in setting de-facto standards for Linux, we do this
all the time, but if we are going to do it I want to be sure we document
this well and provide proper justifications in the commit log and
documentation.

> This commit adds support for finding peripheral firmware embedded in the
> EFI code 

Please specify this is through a custom scheme.... as it reads now it seems
to read this is a sort of standard.

> diff --git a/Documentation/driver-api/firmware/request_firmware.rst b/Documentation/driver-api/firmware/request_firmware.rst
> index c8bddbdcfd10..560dfed76e38 100644
> --- a/Documentation/driver-api/firmware/request_firmware.rst
> +++ b/Documentation/driver-api/firmware/request_firmware.rst
> @@ -73,3 +73,69 @@ If something went wrong firmware_request() returns non-zero and fw_entry
>  is set to NULL. Once your driver is done with processing the firmware it
>  can call call firmware_release(fw_entry) to release the firmware image
>  and any related resource.
> +
> +EFI embedded firmware support
> +=============================

This is a new fallback mechanism, please see:

Documentation/driver-api/firmware/fallback-mechanisms.rst

Refer to the section "Types of fallback mechanisms", augument the list there
and then move the section "Firmware sysfs loading facility" to a new file, and
then add a new file for your own.

> +
> +On some devices the system's EFI code / ROM may contain an embedded copy
> +of firmware for some of the system's integrated peripheral devices and
> +the peripheral's Linux device-driver needs to access this firmware.

You in no way indicate this is a just an invented scheme, a custom solution and
nothing standard.  I realize Ard criticized that the EFI Firmware Volume Protocol
is not part of the UEFI spec -- however it is a bit more widely used right?
Why can't Linux support it instead?

Could your new scheme grow to support the EFI Firmware Volume Protocol rather
easily if someone wants to wrap up their sleeves? If so what likely would change?

Ensure that the documentation answers the question then, when would folks
use the EFI Firmware Volume Protocol? Why can't Linux support it? Why and would
use this alternative scheme?

Granted, we seem to have reverse engineered it, but we can certainly improve
upon it, and if we're going to make a new de-facto standard for Linux best
we cover our bases for our justifications.

> +
> +A device driver which needs this can describe the firmware it needs
> +using an efi_embedded_fw_desc struct:
> +
> +.. kernel-doc:: include/linux/efi_embedded_fw.h
> +   :functions: efi_embedded_fw_desc
> +
> +The EFI embedded-fw code works by scanning all EFI_BOOT_SERVICES_CODE memory
> +segments for an eight byte sequence matching prefix, if the prefix is found it
> +then does a crc32 over length bytes and if that matches makes a copy of length
> +bytes and adds that to its list with found firmwares.
> +
> +To avoid doing this somewhat expensive scan on all systems,

Well we should also only enable this for systems that enable these drivers
*and* enable this kernel feature. Ie, if the drivers are enabled but
the feature is disabled nothing new should happen.

I'd like this feature disabled by default for now.

>  dmi matching is
> +used. Drivers are expected to export a dmi_system_id array, with each entries'
> +driver_data pointing to an efi_embedded_fw_desc.
> +
> +To register this array with the efi-embedded-fw code, a driver needs to:
> +
> +1. Always be builtin to the kernel or store the dmi_system_id array in a
> +   separate object file which always gets builtin.
> +
> +2. Add an extern declaration for the dmi_system_id array to
> +   include/linux/efi_embedded_fw.h.
> +
> +3. Add the dmi_system_id array to the embedded_fw_table in
> +   drivers/firmware/efi/embedded-firmware.c wrapped in a #ifdef testing that
> +   the driver is being builtin.
> +
> +4. Add "select EFI_EMBEDDED_FIRMWARE if EFI_STUB" to its Kconfig entry.
> +
> +The request_firmware() function will always first try to load firmware with
> +the specified name directly from the disk, so the EFI embedded-fw can always
> +be overridden by placing a file under /lib/firmare.
> +
> +To make request_firmware() fallback to trying 

This sounds funny, best to just start off describing that this is just a new
fallback mechanism.

> EFI embedded firmwares after this,
> +the driver must set a boolean "efi-embedded-firmware" device-property on the
> +device before passing it to request_firmware()

Mention that this is for struct platform_device's and what you'd use is
PROPERTY_ENTRY_BOOL(). Provide an example.

Anyway, I'm in no way a fan of this being the only requirement. It makes
no sense to call into EFI or check a device property if the driver didn't
even  mean it to happen.

As I have been asking for a while now, please also add a new
firmware_request_efi() which if called would enable a new internal
firmware_loader flag FW_OPT_EFI which you'd kdoc'ify and add to
drivers/base/firmware_loader/firmware.h.
Then only if *this* internal flag is set would we call fw_get_efi_embedded_fw()
(I'm also asking you to rename this to firmware_fallback_efi() below).

> . Note that this disables the
> +usual usermodehelper fallback, so you may want to only set this on systems
> +which match your dmi_system_id array.

You'll need both the device property and for the driver to use this new
firmware_request_efi() call.

> +
> +Once the device-property is set, the driver can use the regular
> +request_firmware() function to get the firmware, using the name filled in
> +in the efi_embedded_fw_desc.

And nuke this.

> +
> +Note that:
> +
> +1. The code scanning for EFI embbedded-firmware runs near the end
> +   of start_kernel(), just before calling rest_init(). For normal drivers and
> +   subsystems using subsys_initcall() to register themselves this does not
> +   matter. This means that code running earlier cannot use EFI
> +   embbedded-firmware.
> +
> +2. ATM the EFI embedded-fw code assumes that firmwares always start at an offset
> +   which is a multiple of 8 bytes, if this is not true for your case send in
> +   a patch to fix this.
> +
> +3. ATM the EFI embedded-fw code only works on x86 because other archs free
> +   EFI_BOOT_SERVICES_CODE before the EFI embedded-fw code gets a chance to
> +   scan it.
> diff --git a/drivers/base/firmware_loader/Makefile b/drivers/base/firmware_loader/Makefile
> index a97eeb0be1d8..365a040995d3 100644
> --- a/drivers/base/firmware_loader/Makefile
> +++ b/drivers/base/firmware_loader/Makefile
> @@ -5,3 +5,4 @@ obj-y			:= fallback_table.o
>  obj-$(CONFIG_FW_LOADER)	+= firmware_class.o
>  firmware_class-objs := main.o
>  firmware_class-$(CONFIG_FW_LOADER_USER_HELPER) += fallback.o
> +firmware_class-$(CONFIG_EFI_EMBEDDED_FIRMWARE) += fallback_efi.o

Please add a CONFIG_FW_LOADER_FALLBACK_EFI which will be properly
documented on a Kconfig which then if selected would select
CONFIG_EFI_EMBEDDED_FIRMWARE which enables the efi_check_for_embedded_firmwares().
Note you'd be expanding CONFIG_FW_LOADER_FALLBACK_EFI with the new call too.


> diff --git a/drivers/base/firmware_loader/fallback.h b/drivers/base/firmware_loader/fallback.h
> index 8cfaa3299bb7..92f462415d25 100644
> --- a/drivers/base/firmware_loader/fallback.h
> +++ b/drivers/base/firmware_loader/fallback.h
> @@ -66,4 +66,16 @@ static inline void unregister_sysfs_loader(void)
>  }
>  #endif /* CONFIG_FW_LOADER_USER_HELPER */
>  
> +#ifdef CONFIG_EFI_EMBEDDED_FIRMWARE
> +int fw_get_efi_embedded_fw(struct device *dev, struct fw_priv *fw_priv,
> +			   enum fw_opt *opt_flags, int ret);
> +#else
> +static inline int fw_get_efi_embedded_fw(struct device *dev,
> +					 struct fw_priv *fw_priv,
> +					 enum fw_opt *opt_flags, int ret)
> +{
> +	return ret;
> +}
> +#endif /* CONFIG_EFI_EMBEDDED_FIRMWARE */
> +
>  #endif /* __FIRMWARE_FALLBACK_H */
> diff --git a/drivers/base/firmware_loader/fallback_efi.c b/drivers/base/firmware_loader/fallback_efi.c
> new file mode 100644
> index 000000000000..82ba82f48a79
> --- /dev/null
> +++ b/drivers/base/firmware_loader/fallback_efi.c
> @@ -0,0 +1,51 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/efi_embedded_fw.h>
> +#include <linux/property.h>
> +#include <linux/security.h>
> +#include <linux/vmalloc.h>
> +
> +#include "fallback.h"
> +#include "firmware.h"
> +
> +int fw_get_efi_embedded_fw(struct device *dev, struct fw_priv *fw_priv,
> +			   enum fw_opt *opt_flags, int ret)
> +{

Please rename to firmware_fallback_efi() and kdocify it above. I'll soon post a
patch which does the same for firmware_fallback_sysfs(). Andres's
pending patch renames fw_sysfs_fallback() to firmware_sysfs_fallback()
but in retrospect it should be firmware_fallback_sysfs() -- I'll fix this.

> +	enum kernel_read_file_id id = READING_FIRMWARE;
> +	size_t size, max = INT_MAX;
> +	int rc;
> +
> +	if (!dev)
> +		return ret;
> +
> +	if (!device_property_read_bool(dev, "efi-embedded-firmware"))
> +		return ret;
> +
> +	*opt_flags |= FW_OPT_NO_WARN | FW_OPT_NOCACHE | FW_OPT_NOFALLBACK;
> +
> +	/* Already populated data member means we're loading into a buffer */
> +	if (fw_priv->data) {
> +		id = READING_FIRMWARE_PREALLOC_BUFFER;
> +		max = fw_priv->allocated_size;
> +	}
> +
> +	rc = efi_get_embedded_fw(fw_priv->fw_name, &fw_priv->data, &size, max);
> +	if (rc) {
> +		dev_warn(dev, "Firmware %s not in EFI\n", fw_priv->fw_name);
> +		return ret;
> +	}
> +
> +	rc = security_kernel_post_read_file(NULL, fw_priv->data, size, id);
> +	if (rc) {
> +		if (id != READING_FIRMWARE_PREALLOC_BUFFER) {
> +			vfree(fw_priv->data);
> +			fw_priv->data = NULL;
> +		}
> +		return rc;
> +	}
> +
> +	dev_dbg(dev, "using efi-embedded fw %s\n", fw_priv->fw_name);
> +	fw_priv->size = size;
> +	fw_state_done(fw_priv);
> +	return 0;
> +}
> diff --git a/drivers/base/firmware_loader/main.c b/drivers/base/firmware_loader/main.c
> index f009566acd35..23c5392eb59e 100644
> --- a/drivers/base/firmware_loader/main.c
> +++ b/drivers/base/firmware_loader/main.c
> @@ -576,6 +576,8 @@ _firmware_request(const struct firmware **firmware_p, const char *name,
>  		goto out;
>  
>  	ret = fw_get_filesystem_firmware(device, fw->priv);
> +	if (ret)
> +		ret = fw_get_efi_embedded_fw(device, fw->priv, &opt_flags, ret);

This is going to get complex. If you can come up with a nicer scheme for dealing
with fallback that'd be appreciated. If you this is the most legible you can
come up with I understand though, I can have a look later.

  Luis
