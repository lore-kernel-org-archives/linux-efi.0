From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/6] efi/libstub: Introduce ExitBootServices helper
Date: Mon, 22 Aug 2016 18:41:00 +0200
Message-ID: <20160822164100.GB11327@gmail.com>
References: <1471638904-3494-1-git-send-email-matt@codeblueprint.co.uk>
 <1471638904-3494-4-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1471638904-3494-4-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:

> From: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> 
> The spec allows ExitBootServices to fail with EFI_INVALID_PARAMETER if a
> race condition has occurred where the EFI has updated the memory map after
> the stub grabbed a reference to the map.  The spec defines a retry
> proceedure with specific requirements to handle this scenario.
> 
> This scenario was previously observed on x86 - commit d3768d885c6c ("x86,
> efi: retry ExitBootServices() on failure") but the current fix is not spec
> compliant and the scenario is now observed on the Qualcomm Technologies
> QDF2432 via the FDT stub which does not handle the error and thus causes
> boot failures.

It's unclear what this 'scenario' is. How does the user notice?

> Add a helper to the stub library that correctly adhears to the spec in the
> case of EFI_INVALID_PARAMETER from ExitBootServices and can be universally
> used across all stub implementations.

s/'adheres to'

> +		status = efi_call_early(exit_boot_services, handle,
> +					*map->key_ptr);

Please don't add spurious linebreaks in such a case - just keep it a bit longer 
than col80.

> +	if (status != EFI_SUCCESS)
> +		/* exit_boot_services() was called, thus cannot free*/
> +		goto fail;

Non-standard comment format and comment placement.

Thanks,

	Ingo
