From: joeyli <jlee@suse.com>
Subject: Re: [PATCH 14/27] ACPI: Limit access to custom_method when the
 kernel is locked down
Date: Fri, 20 Oct 2017 14:45:02 +0800
Message-ID: <20171020064502.GV3285@linux-l9pv.suse>
References: <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
 <150842473899.7923.6590815561953001126.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <150842473899.7923.6590815561953001126.stgit@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-security-module@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, matthew.garrett@nebula.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, jforbes@redhat.com
List-Id: linux-efi@vger.kernel.org

On Thu, Oct 19, 2017 at 03:52:19PM +0100, David Howells wrote:
> From: Matthew Garrett <matthew.garrett@nebula.com>
> 
> custom_method effectively allows arbitrary access to system memory, making
> it possible for an attacker to circumvent restrictions on module loading.
> Disable it if the kernel is locked down.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> Signed-off-by: David Howells <dhowells@redhat.com>

I have reviewed this patch. Please feel free to add:

Reviewed-by: "Lee, Chun-Yi" <jlee@suse.com>

Thanks!
Joey Lee

> cc: linux-acpi@vger.kernel.org
> ---
> 
>  drivers/acpi/custom_method.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/acpi/custom_method.c b/drivers/acpi/custom_method.c
> index c68e72414a67..b33fba70ec51 100644
> --- a/drivers/acpi/custom_method.c
> +++ b/drivers/acpi/custom_method.c
> @@ -29,6 +29,9 @@ static ssize_t cm_write(struct file *file, const char __user * user_buf,
>  	struct acpi_table_header table;
>  	acpi_status status;
>  
> +	if (kernel_is_locked_down("ACPI custom methods"))
> +		return -EPERM;
> +
>  	if (!(*ppos)) {
>  		/* parse the table header to get the table length */
>  		if (count <= sizeof(struct acpi_table_header))
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
