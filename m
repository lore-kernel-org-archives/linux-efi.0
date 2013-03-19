From: Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 10/12] acpi: Ignore acpi_rsdp kernel parameter in a
 secure boot environment
Date: Tue, 19 Mar 2013 07:19:17 -0400
Message-ID: <20130319111916.GI11243@hansolo.jdub.homelinux.org>
References: <1363642353-30749-1-git-send-email-matthew.garrett@nebula.com>
 <1363642353-30749-10-git-send-email-matthew.garrett@nebula.com>
 <5148261F.3030806@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5148261F.3030806-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, Mar 19, 2013 at 04:47:27PM +0800, Dave Young wrote:
> On 03/19/2013 05:32 AM, Matthew Garrett wrote:
> > From: Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > 
> > This option allows userspace to pass the RSDP address to the kernel.  This
> > could potentially be used to circumvent the secure boot trust model.
> > We ignore the setting if we don't have the CAP_COMPROMISE_KERNEL capability.
> > 
> > Signed-off-by: Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/acpi/osl.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> > index 586e7e9..0ef63f1 100644
> > --- a/drivers/acpi/osl.c
> > +++ b/drivers/acpi/osl.c
> > @@ -245,7 +245,7 @@ early_param("acpi_rsdp", setup_acpi_rsdp);
> >  acpi_physical_address __init acpi_os_get_root_pointer(void)
> >  {
> >  #ifdef CONFIG_KEXEC
> > -	if (acpi_rsdp)
> > +	if (acpi_rsdp && capable(CAP_COMPROMISE_KERNEL))
> >  		return acpi_rsdp;
> >  #endif
> >  
> > 
> 
> This does not work because capable is not usable at this early point.

Right.

> Josh, could you update your fix here?

I have.  Twice.  Matthew sent out a stale patch.

josh
