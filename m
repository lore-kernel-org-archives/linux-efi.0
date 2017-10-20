From: joeyli <jlee@suse.com>
Subject: Re: [PATCH 13/27] asus-wmi: Restrict debugfs interface when the
 kernel is locked down
Date: Fri, 20 Oct 2017 14:44:31 +0800
Message-ID: <20171020064431.GU3285@linux-l9pv.suse>
References: <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
 <150842473184.7923.9538070958624850416.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <150842473184.7923.9538070958624850416.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-security-module@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, matthew.garrett@nebula.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, jforbes@redhat.com
List-Id: linux-efi@vger.kernel.org

On Thu, Oct 19, 2017 at 03:52:11PM +0100, David Howells wrote:
> From: Matthew Garrett <matthew.garrett@nebula.com>
> 
> We have no way of validating what all of the Asus WMI methods do on a given
> machine - and there's a risk that some will allow hardware state to be
> manipulated in such a way that arbitrary code can be executed in the
> kernel, circumventing module loading restrictions.  Prevent that if the
> kernel is locked down.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> Signed-off-by: David Howells <dhowells@redhat.com>

I have reviewed this patch. Please feel free to add:

Reviewed-by: "Lee, Chun-Yi" <jlee@suse.com>

Thanks!
Joey Lee

> cc: acpi4asus-user@lists.sourceforge.net
> cc: platform-driver-x86@vger.kernel.org
> ---
> 
>  drivers/platform/x86/asus-wmi.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
> index 48e1541dc8d4..ef5587469337 100644
> --- a/drivers/platform/x86/asus-wmi.c
> +++ b/drivers/platform/x86/asus-wmi.c
> @@ -1905,6 +1905,9 @@ static int show_dsts(struct seq_file *m, void *data)
>  	int err;
>  	u32 retval = -1;
>  
> +	if (kernel_is_locked_down("Asus WMI"))
> +		return -EPERM;
> +
>  	err = asus_wmi_get_devstate(asus, asus->debug.dev_id, &retval);
>  
>  	if (err < 0)
> @@ -1921,6 +1924,9 @@ static int show_devs(struct seq_file *m, void *data)
>  	int err;
>  	u32 retval = -1;
>  
> +	if (kernel_is_locked_down("Asus WMI"))
> +		return -EPERM;
> +
>  	err = asus_wmi_set_devstate(asus->debug.dev_id, asus->debug.ctrl_param,
>  				    &retval);
>  
> @@ -1945,6 +1951,9 @@ static int show_call(struct seq_file *m, void *data)
>  	union acpi_object *obj;
>  	acpi_status status;
>  
> +	if (kernel_is_locked_down("Asus WMI"))
> +		return -EPERM;
> +
>  	status = wmi_evaluate_method(ASUS_WMI_MGMT_GUID,
>  				     0, asus->debug.method_id,
>  				     &input, &output);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
