From: joeyli <jlee@suse.com>
Subject: Re: [PATCH 15/27] acpi: Ignore acpi_rsdp kernel param when the
 kernel has been locked down
Date: Fri, 20 Oct 2017 14:45:43 +0800
Message-ID: <20171020064543.GW3285@linux-l9pv.suse>
References: <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
 <150842474713.7923.4851355698276917280.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <150842474713.7923.4851355698276917280.stgit@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-security-module@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, matthew.garrett@nebula.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, jforbes@redhat.com
List-Id: linux-efi@vger.kernel.org

On Thu, Oct 19, 2017 at 03:52:27PM +0100, David Howells wrote:
> From: Josh Boyer <jwboyer@redhat.com>
> 
> This option allows userspace to pass the RSDP address to the kernel, which
> makes it possible for a user to modify the workings of hardware .  Reject
> the option when the kernel is locked down.
> 
> Signed-off-by: Josh Boyer <jwboyer@redhat.com>
> Signed-off-by: David Howells <dhowells@redhat.com>

I have reviewed this patch. Please feel free to add:

Reviewed-by: "Lee, Chun-Yi" <jlee@suse.com>

Thanks!
Joey Lee

> cc: Dave Young <dyoung@redhat.com>
> cc: linux-acpi@vger.kernel.org
> ---
> 
>  drivers/acpi/osl.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index db78d353bab1..36c6527c1b0a 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -192,7 +192,7 @@ acpi_physical_address __init acpi_os_get_root_pointer(void)
>  	acpi_physical_address pa = 0;
>  
>  #ifdef CONFIG_KEXEC
> -	if (acpi_rsdp)
> +	if (acpi_rsdp && !kernel_is_locked_down("ACPI RSDP specification"))
>  		return acpi_rsdp;
>  #endif
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
