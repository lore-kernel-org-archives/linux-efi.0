From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 17/27] acpi: Disable APEI error injection if the kernel
 is locked down
Date: Fri, 20 Oct 2017 14:47:05 +0800
Message-ID: <20171020064705.GY3285@linux-l9pv.suse>
References: <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
 <150842476188.7923.14340260837257633120.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <150842476188.7923.14340260837257633120.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jforbes-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Oct 19, 2017 at 03:52:41PM +0100, David Howells wrote:
> From: Linn Crosetto <linn-ZPxbGqLxI0U@public.gmane.org>
> 
> ACPI provides an error injection mechanism, EINJ, for debugging and testing
> the ACPI Platform Error Interface (APEI) and other RAS features.  If
> supported by the firmware, ACPI specification 5.0 and later provide for a
> way to specify a physical memory address to which to inject the error.
> 
> Injecting errors through EINJ can produce errors which to the platform are
> indistinguishable from real hardware errors.  This can have undesirable
> side-effects, such as causing the platform to mark hardware as needing
> replacement.
> 
> While it does not provide a method to load unauthenticated privileged code,
> the effect of these errors may persist across reboots and affect trust in
> the underlying hardware, so disable error injection through EINJ if
> the kernel is locked down.
> 
> Signed-off-by: Linn Crosetto <linn-ZPxbGqLxI0U@public.gmane.org>
> Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

I have reviewed this patch. Please feel free to add:

Reviewed-by: "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>

Thanks!
Joey Lee

> cc: linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
> 
>  drivers/acpi/apei/einj.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/acpi/apei/einj.c b/drivers/acpi/apei/einj.c
> index b38737c83a24..6d71e1e97b20 100644
> --- a/drivers/acpi/apei/einj.c
> +++ b/drivers/acpi/apei/einj.c
> @@ -518,6 +518,9 @@ static int einj_error_inject(u32 type, u32 flags, u64 param1, u64 param2,
>  	int rc;
>  	u64 base_addr, size;
>  
> +	if (kernel_is_locked_down("ACPI error injection"))
> +		return -EPERM;
> +
>  	/* If user manually set "flags", make sure it is legal */
>  	if (flags && (flags &
>  		~(SETWA_FLAGS_APICID|SETWA_FLAGS_MEM|SETWA_FLAGS_PCIE_SBDF)))
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
