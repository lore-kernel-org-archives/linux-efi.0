From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 16/27] acpi: Disable ACPI table override if the kernel is
 locked down
Date: Fri, 20 Oct 2017 14:46:12 +0800
Message-ID: <20171020064612.GX3285@linux-l9pv.suse>
References: <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
 <150842475442.7923.12198790224494561644.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <150842475442.7923.12198790224494561644.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jforbes-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Oct 19, 2017 at 03:52:34PM +0100, David Howells wrote:
> From: Linn Crosetto <linn-ZPxbGqLxI0U@public.gmane.org>
> 
> >From the kernel documentation (initrd_table_override.txt):
> 
>   If the ACPI_INITRD_TABLE_OVERRIDE compile option is true, it is possible
>   to override nearly any ACPI table provided by the BIOS with an
>   instrumented, modified one.
> 
> When securelevel is set, the kernel should disallow any unauthenticated
> changes to kernel space.  ACPI tables contain code invoked by the kernel,
> so do not allow ACPI tables to be overridden if the kernel is locked down.
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
>  drivers/acpi/tables.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
> index 80ce2a7d224b..5cc13c42daf9 100644
> --- a/drivers/acpi/tables.c
> +++ b/drivers/acpi/tables.c
> @@ -526,6 +526,11 @@ void __init acpi_table_upgrade(void)
>  	if (table_nr == 0)
>  		return;
>  
> +	if (kernel_is_locked_down("ACPI table override")) {
> +		pr_notice("kernel is locked down, ignoring table override\n");
> +		return;
> +	}
> +
>  	acpi_tables_addr =
>  		memblock_find_in_range(0, ACPI_TABLE_UPGRADE_MAX_PHYS,
>  				       all_tables_size, PAGE_SIZE);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
