From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH][RFC] ACPI / PM: Fix poweroff issue on HW-full platforms
 without _S5
Date: Fri, 4 Mar 2016 13:33:06 +0000
Message-ID: <20160304133306.GB2715@codeblueprint.co.uk>
References: <1456925357-2899-1-git-send-email-yu.c.chen@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1456925357-2899-1-git-send-email-yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chen Yu <yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rjw-KKrjLPT3xs0@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rui.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 02 Mar, at 09:29:17PM, Chen Yu wrote:
> The problem is Linux registers pm_power_off = efi_power_off
> only if we are in hardware reduced mode. Actually, what we also
> want is to do this when ACPI S5 is simply not supported.
> That should handle both the HW reduced mode, and the HW-full
> mode where the DSDT fails to supply an _S5 object.
> 
> This patch fixes this issue by introducing a new flag acpi_no_s5 which
> indicates the non-existence of _S5. The initial state of acpi_no_s5 is
> false and probed in acpi_sleep_init, then we'll later see the updated
> value in efi_poweroff_required, according to which we can set pm_power_off
> to efi_power_off in efi_shutdown_init.
> 
> Suggested-by: Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Chen Yu <yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  arch/x86/platform/efi/quirks.c | 3 ++-
>  drivers/acpi/sleep.c           | 2 ++
>  include/acpi/acpixf.h          | 6 ++++++
>  3 files changed, 10 insertions(+), 1 deletion(-)

Are there legacy platforms without _S5 where we currently handle
reboot via some other means that are going to break if we attempt an
EFI reboot?

I ask because historically performing an EFI reboot has been all kinds
of buggy on x86.

Also, is this what Windows does if _S5 is absent?
