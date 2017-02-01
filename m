From: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH] efi: fdt: avoid FDT manipulation after ExitBootServices()
Date: Wed, 1 Feb 2017 14:08:23 -0700
Message-ID: <ac1bad94-ffa3-4acf-a719-a8e8f4c7a283@codeaurora.org>
References: <1485971102-23330-1-git-send-email-ard.biesheuvel@linaro.org>
 <1485971102-23330-2-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485971102-23330-2-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, riku.voipio-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 2/1/2017 10:45 AM, Ard Biesheuvel wrote:
> Some AArch64 UEFI implementations disable the MMU in ExitBootServices(),
> after which unaligned accesses to RAM are no longer supported.
>
> Commit abfb7b686a3e ("efi/libstub/arm*: Pass latest memory map to the
> kernel") fixed an issue in the memory map handling of the stub FDT code,
> but inadvertently created an issue with such firmwares, by moving some
> of the FDT manipulation to after the invocation of ExitBootServices().
> Given that the stub's libfdt implementation uses the ordinary, accelerated
> string functions, which rely on hardware handling of unaligned accesses,
> manipulating the FDT with the MMU off may result in alignment faults.
>
> So fix the situation by moving the update_fdt_memmap() call into the
> callback function invoked by efi_exit_boot_services() right before it
> calls the ExitBootServices() UEFI service (which is arguably a better
> place for it anyway)
>
> Note that disabling the MMU in ExitBootServices() is not compliant with
> the UEFI spec, and carries great risk due to the fact that switching from
> cached to uncached memory accesses halfway through compiler generated code
> (i.e., involving a stack) can never be done in a way that is architecturally
> safe.
>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Fixes: abfb7b686a3e ("efi/libstub/arm*: Pass latest memory map to the kernel")
> Tested-by: Riku Voipio <riku.voipio-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

NACK, please.  This causes a regression on my platform, in the form of 
an assert in UEFI once ExitBootServices() is called, per initial 
testing.  I'll do more testing to determine why.

-- 
Jeffrey Hugo
Qualcomm Datacenter Technologies as an affiliate of Qualcomm 
Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
