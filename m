From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efibc: EFI Bootloader Control
Date: Thu, 14 Apr 2016 17:00:06 +0100
Message-ID: <20160414160006.GR2829@codeblueprint.co.uk>
References: <87bn5tlbkw.fsf@jcompost-MOBL1.tl.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87bn5tlbkw.fsf-e2kLcBBGnpIIbNWpFUBdLQzuBQEzu/OPQQ4Iyu8u01E@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Compostella, Jeremy" <jeremy.compostella-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Stanacar, Stefan" <stefan.stanacar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

(Sorry for the delay)

On Fri, 01 Apr, at 03:09:51PM, Compostella, Jeremy wrote:
> This module installs a reboot hook, such that if reboot() is invoked
> with a string argument NNN, "NNN" is copied to the
> "LoaderEntryOneShot" EFI variable, to be read by the bootloader. If
> the string matches one of the boot labels defined in its
> configuration, the bootloader will boot once to that label.  The
> "LoaderEntryRebootReason" EFI variable is set with the reboot reason:
> "reboot", "shutdown", "kernel_panic" or "watchdog".  The bootloader
> reads this reboot reason and takes particular action according to its
> policy.
 
This commit message is missing some info. In particular, I'd like see
to which boot loaders support this protocol and why this feature
should be a kernel driver and cannot be done with the userspace EFI
variable API.

Yes we've already discussed these bits on the mailing list, but
recording it for posterity in the commit log is very worthwhile.

> Signed-off-by: Jeremy Compostella <jeremy.compostella-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  arch/x86/Kconfig               |  16 ++++
>  arch/x86/platform/efi/Makefile |   1 +
>  arch/x86/platform/efi/efibc.c  | 164 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 181 insertions(+)
>  create mode 100644 arch/x86/platform/efi/efibc.c
 
Hehe, I suspect I was a little unclear in my previous comments about
moving this out of drivers/firmware/efi.

arch/x86/platform/efi is not the right place for this kind of stuff
either, since it contains core x86 EFI support.

That directory is no longer named appropriately, as EFI should not be
considered a feature of specific platforms - it's the standard
firmware technology nowadays on x86. I've been meaning to rename it.

But let's ignore the issue of finding the right home for now. I've got
some reservations about the panic notifier that I've outlined below.

> diff --git a/arch/x86/platform/efi/Makefile b/arch/x86/platform/efi/Makefile
> index 066619b..05cf769 100644
> --- a/arch/x86/platform/efi/Makefile
> +++ b/arch/x86/platform/efi/Makefile
> @@ -4,3 +4,4 @@ obj-$(CONFIG_EFI) 		+= quirks.o efi.o efi_$(BITS).o efi_stub_$(BITS).o
>  obj-$(CONFIG_ACPI_BGRT) += efi-bgrt.o
>  obj-$(CONFIG_EARLY_PRINTK_EFI)	+= early_printk.o
>  obj-$(CONFIG_EFI_MIXED)		+= efi_thunk_$(BITS).o
> +obj-$(CONFIG_EFI_BOOTLOADER_CONTROL)	+= efibc.o
> diff --git a/arch/x86/platform/efi/efibc.c b/arch/x86/platform/efi/efibc.c
> new file mode 100644
> index 0000000..8ca8b43
> --- /dev/null
> +++ b/arch/x86/platform/efi/efibc.c
> @@ -0,0 +1,164 @@
> +/*
> + * efibc: control EFI bootloaders which obey LoaderEntryOneShot var
> + * Copyright (c) 2013-2016, Intel Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + */
> +
> +#include <linux/efi.h>
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/reboot.h>
> +#include <linux/kexec.h>
> +#include <linux/slab.h>
> +#include <linux/nls.h>
> +
> +#define MODULE_NAME "efibc"
> +
> +static const efi_guid_t LOADER_GUID =
> +	EFI_GUID(0x4a67b082, 0x0a4c, 0x41cf,
> +		 0xb6, 0xc7, 0x44, 0x0b, 0x29, 0xbb, 0x8c, 0x4f);

Please move this guid to include/linux/efi.h.

> +
> +static const char REBOOT_TARGET[] = "LoaderEntryOneShot";
> +static const char REBOOT_REASON[] = "LoaderEntryRebootReason";
> +
> +static const char * const WDT_SOURCE_PREFIX[] = {
> +	"Kernel Watchdog", "Watchdog", "softlockup", "Software Watchdog"
> +};

Please use lowercase for names, unless you're using #define.
Additionally, because REBOOT_* are only used in one place you could
just use the strings directly instead of making them file-global.

> +static void efibc_str_to_str16(const char *str, wchar_t *str16)
> +{

s/wchar_t/efi_char16_t/

> +	size_t size = strlen(str) + 1;
> +
> +	utf8s_to_utf16s(str, size, UTF16_LITTLE_ENDIAN, str16,
> +			size * sizeof(*str16) / sizeof(*str));
> +	str16[size - 1] = '\0';

	for (i = 0; i < strlen(str); i++)
		str16[i] = str[i];

	str16[i] = '\0';

right? Are there some scenarios where utf8s_to_utf16s() works and the
above loop doesn't? We have to do this conversion in the efivarfs file
system too, so does that need updating?

> +static struct efivar_entry *efibc_get_var_entry(const char *name)
> +{
> +	wchar_t name16[strlen(name) + 1];
> +	struct efivar_entry *entry;
> +
> +	efibc_str_to_str16(name, name16);
> +
> +	efivar_entry_iter_begin();
> +	entry = efivar_entry_find(name16, LOADER_GUID,
> +				  &efivar_sysfs_list, false);

Hmm... there's an interesting consequence of using efivar_sysfs_list
here, and that is that if someone creates this variable manually via
the efivarfs file system you won't see it on efivar_sysfs_list.

Of course, when you restart the machine you will see it then, so it's
probably not a big deal for this driver that only cares about reboot;
I just wanted to make you aware.

> +	efivar_entry_iter_end();
> +
> +	return entry;
> +}
> +
> +static void efibc_set_variable(const char *name, const char *value)
> +{
> +	u32 attributes = EFI_VARIABLE_NON_VOLATILE
> +		| EFI_VARIABLE_BOOTSERVICE_ACCESS
> +		| EFI_VARIABLE_RUNTIME_ACCESS;
> +	wchar_t name16[strlen(name) + 1];
> +	wchar_t value16[strlen(value) + 1];
> +	int ret;

Please put the attribute value on a separate line from the
declaration.

> +
> +	efibc_str_to_str16(name, name16);
> +	efibc_str_to_str16(value, value16);
> +
> +	ret = efivar_entry_set_safe(name16, LOADER_GUID, attributes, true,
> +				    sizeof(value16), value16);

If it is always OK to block when calling SetVariable() you don't want
to be using efivar_entry_set_safe(). The regular efivar_entry_set()
will suffice.

The *_safe() version is special because it will handle being called in
a context where it is not allowed to block.

Oh but I just realised you call this from a panic handler, so it's not
safe to always block.

In which case, yes, using efivar_entry_set_safe() is correct but you
cannot always pass 'true' for the @block parameter.

> +	if (ret)
> +		pr_err(MODULE_NAME ": failed to set %s EFI variable: 0x%x\n",
> +		       name, ret);
> +}

You can redefine pr_fmt to avoid having to specify MODULE_NAME here,
e.g.

#define pr_fmt(fmt)	"efifbc: "

> +
> +static int efibc_reboot_notifier_call(struct notifier_block *notifier,
> +				      unsigned long what, void *data)
> +{
> +	char *reason = what == SYS_RESTART ? "reboot" : "shutdown";
> +

Let's rename 'what' to 'event' to provide an idea of the kind of data
it contains. This line needs breaking down too.

How about,

	const char *reason = "shutdown";

	if (event == SYS_RESTART)
		reason = "reboot";

Which makes it a little clearer that we treat the SYS_RESTART event as
being special and lump all other events under "shutdown".

> +}
> +
> +static bool is_watchdog_source(const char *str)
> +{
> +	size_t i;
> +
> +	for (i = 0; i < ARRAY_SIZE(WDT_SOURCE_PREFIX); i++)
> +		if (!strncmp(str, WDT_SOURCE_PREFIX[i],
> +			     strlen(WDT_SOURCE_PREFIX[i])))
> +			return true;
> +
> +	return false;
> +}
> +
> +static int efibc_panic_notifier_call(struct notifier_block *notifier,
> +				     unsigned long what, void *data)
> +{
> +	char *reason;
> +
> +	/* If the reboot reason has already been supplied, keep it. */
> +	if (efibc_get_var_entry(REBOOT_REASON))
> +		return NOTIFY_DONE;

I'm not sure this is the best idea. If, in the process of doing a
normal reboot, we panic, wouldn't the user rather see the panic
reason and not the reboot reason?

> +
> +	if (data && is_watchdog_source((char *)data))
> +		reason = "watchdog";
> +	else
> +		reason = "kernel_panic";
> +
> +	efibc_set_variable(REBOOT_REASON, reason);

Checking the panic string prefix for known watchdog strings is a bit
hacky. For example, this won't work with the hard lockup detector.
What happens if someone adds a new watchdog driver?

On second thought, I'm not at all sure of the value of this panic
notifier. As I understood it, the proposition of this driver was that
it allows the user to pass information via the kernel to the boot
loader upon reboot. This data is strictly opaque to the kernel, and
I'm OK with that.

However, with this panic handler, you're doing something different.
You're passing kernel strings directly (albeit translated to
"watchdog" or "kernel_panic") to the boot loader. You're creating an
ABI between the kernel and boot loaders.

Besides which, we already have code to store information in EFI
variables on panic; the efi-pstore driver.

Sorry, but NAK on this part of the patch.
