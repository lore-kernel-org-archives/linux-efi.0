From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 2/5] efi: Add embedded peripheral firmware support
Date: Tue, 01 May 2018 15:27:27 -0400
Message-ID: <1525202847.5669.64.camel@linux.vnet.ibm.com>
References: <20180429093558.5411-1-hdegoede@redhat.com>
         <20180429093558.5411-3-hdegoede@redhat.com>
         <1525185374.5669.49.camel@linux.vnet.ibm.com>
         <dc122066-9973-a1be-3456-6d6181a8fc9f@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <dc122066-9973-a1be-3456-6d6181a8fc9f@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Peter Jones <pjones@redhat.com>, Dave Olsthoorn <dave@bewaar.me>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, David Howells <dhowells@redhat.com>, Josh Triplett <josh@joshtriplett.org>, dmitry.torokhov@gmail.com, mfuzzey@parkeon.com, Kalle Valo <kvalo@codeaurora.org>, Arend Van Spriel <arend.vanspriel@broadcom.com>, Linus Torvalds <torvalds@linux-foundation.org>, nbroeking@me.com, bjorn.andersson@linaro.org, Torsten Duwe <duwe@suse.de>, Kees Cook <keescook@chromium.org>, x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-security-module <linux-security-module@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 2018-05-01 at 21:11 +0200, Hans de Goede wrote:
> Hi,
> 
> On 01-05-18 16:36, Mimi Zohar wrote:
> > [Cc'ing linux-security]
> > 
> > On Sun, 2018-04-29 at 11:35 +0200, Hans de Goede wrote:
> > [...]
> >> diff --git a/drivers/base/firmware_loader/fallback_efi.c b/drivers/base/firmware_loader/fallback_efi.c
> >> new file mode 100644
> >> index 000000000000..82ba82f48a79
> >> --- /dev/null
> >> +++ b/drivers/base/firmware_loader/fallback_efi.c
> >> @@ -0,0 +1,51 @@
> >> +// SPDX-License-Identifier: GPL-2.0
> >> +
> >> +#include <linux/efi_embedded_fw.h>
> >> +#include <linux/property.h>
> >> +#include <linux/security.h>
> >> +#include <linux/vmalloc.h>
> >> +
> >> +#include "fallback.h"
> >> +#include "firmware.h"
> >> +
> >> +int fw_get_efi_embedded_fw(struct device *dev, struct fw_priv *fw_priv,
> >> +			   enum fw_opt *opt_flags, int ret)
> >> +{
> >> +	enum kernel_read_file_id id = READING_FIRMWARE;
> > 
> > Please define a new kernel_read_file_id for this (eg.
> > READING_FIRMWARE_EFI_EMBEDDED).
> 
> Are you sure, I wonder how useful it is to add a new
> kernel_read_file_id every time a new way to get firmware
> comes up?
> 
> I especially wonder about the sense in adding a new id
> given that the quite old FIRMWARE_PREALLOC_BUFFER is
> still not supported / checked properly by the security code.

I posted patches earlier today[1], which address this.  Patch 5/6 just
makes it equivalent to READING_FIRMWARE.  Patch 6/6 questions whether
the device has access to the pre-allocated buffer *before* the
signature has been verified.

[1] kernsec.org/pipermail/linux-security-module-archive/2018-May/006639.html

> 
> Anyways I can add a new id if you want me to, what about
> when fw_get_efi_embedded_fw is reading into a driver allocated
> buffer, do you want a separate EADING_FIRMWARE_EFI_EMBEDDED_PREALLOC_BUFFER
> for that ?

Without the kernel being able to verify the firmware's signature, I'm
not sure it makes much of a difference.

> 
> > 
> >> +	size_t size, max = INT_MAX;
> >> +	int rc;
> >> +
> >> +	if (!dev)
> >> +		return ret;
> >> +
> >> +	if (!device_property_read_bool(dev, "efi-embedded-firmware"))
> >> +		return ret;
> > 
> > Instead of calling security_kernel_post_read_file(), either in
> > device_property_read_bool() or here call security_kernel_read_file().
> > 
> > The pre read call is for deciding whether to allow this call
> > independent of the firmware being loaded, whereas the post security
> > call is currently being used by IMA-appraisal for verifying a
> > signature.  There might be other LSMs using the post hook as well.  As
> > there is no kernel signature associated with this firmware, use the
> > security pre read_file hook.
> 
> Only the pre hook?  I believe the post-hook should still be called too,
> right? So that we've hashes of all loaded firmwares in the IMA core.

Good catch!  Right, if IMA-measurement is enabled, then we would want
to add the measurement.

Mimi
