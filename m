From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH][RFC,v4] ACPI / PM: Introduce efi poweroff for HW-full
 platforms without _S5
Date: Fri, 11 Mar 2016 15:55:46 +0000
Message-ID: <20160311155546.GJ15775@codeblueprint.co.uk>
References: <1457687133-3730-1-git-send-email-yu.c.chen@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1457687133-3730-1-git-send-email-yu.c.chen@intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Chen Yu <yu.c.chen@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>, Len Brown <lenb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, rui.zhang@intel.com, linux-efi@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Salter <msalter@redhat.com>
List-Id: linux-efi@vger.kernel.org

On Fri, 11 Mar, at 05:05:33PM, Chen Yu wrote:
> The problem is Linux registers pm_power_off = efi_power_off
> only if we are in hardware reduced mode. Actually, what we also
> want is to do this when ACPI S5 is simply not supported on
> non-legacy platforms. That should handle both the HW reduced mode,
> and the HW-full mode where the DSDT fails to supply an _S5 object.
> 
> This patch introduces pm_power_off_default which would be used by
> pm_power_off if nothing else is available. And in this case we
> leverage efi power off to be this role. However since efi power off
> may not be stable enough thus in order not to interfere with other
> poweroff path, we only make a minimum enhancement for x86 in
> native_machine_power_off.
> 
> Suggested-by: Len Brown <len.brown@intel.com>
> Signed-off-by: Chen Yu <yu.c.chen@intel.com>
> ---
> v4:
>  - Since in v3 efi_poweroff_required() is not guaranteed to run
>    after all of the other code that may register alternative
>    power off handling, add the pm_power_off_default that would
>    be used by pm_power_off if nothing else is available.
> v3:
>  - Only assign pm_power_off to efi_power_off when there are no
>    other pm_power_off registered at that time, in case other
>    commponents would like to customize their own implementation.
> ---
> v2:
>  - Convert the acpi_no_s5 to a global bool variable in sleep.c and
>    add a declaration to include/linux/acpi.h.
> ---
>  arch/x86/kernel/reboot.c       | 3 +++
>  arch/x86/platform/efi/quirks.c | 5 +++++
>  drivers/acpi/sleep.c           | 7 +++++++
>  drivers/firmware/efi/reboot.c  | 8 ++++++++
>  include/linux/acpi.h           | 1 +
>  include/linux/efi.h            | 1 +
>  include/linux/pm.h             | 1 +
>  kernel/reboot.c                | 1 +
>  8 files changed, 27 insertions(+)

Couple of things,

  1) I'm still waiting for an answer to my question on whether
     platforms without _S5 that need EFI reset actually exist. You
     said they "might" exist, which makes this all sound very
     speculative. It is not obvious to me that this approach makes
     sense. 

  2) In v4 you're modifying the generic EFI reboot code and should Cc
     other developers who might care, e.g. the arm64 folks. I've Cc'd
     them now.
