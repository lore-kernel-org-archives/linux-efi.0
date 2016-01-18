From: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
Subject: Re: [PATCH v2 01/16] Xen: ACPI: Hide UART used by Xen
Date: Mon, 18 Jan 2016 11:38:08 +0000
Message-ID: <alpine.DEB.2.02.1601181135260.16178@kaball.uk.xensource.com>
References: <1452840929-19612-1-git-send-email-zhaoshenglong@huawei.com>
 <1452840929-19612-2-git-send-email-zhaoshenglong@huawei.com>
 <20160118103216.GB21067@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160118103216.GB21067@leverpostej>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "open list:ACPI" <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 18 Jan 2016, Mark Rutland wrote:
> On Fri, Jan 15, 2016 at 02:55:14PM +0800, Shannon Zhao wrote:
> > From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > 
> > ACPI 6.0 introduces a new table STAO to list the devices which are used
> > by Xen and can't be used by Dom0. On Xen virtual platforms, the physical
> > UART is used by Xen. So here it hides UART from Dom0.
> > 
> > Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > ---
> > CC: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org> (supporter:ACPI)
> > CC: Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> (supporter:ACPI)
> > CC: linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (open list:ACPI)
> > ---
> >  drivers/acpi/bus.c | 30 ++++++++++++++++++++++++++++++
> >  1 file changed, 30 insertions(+)
> > 
> > diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
> > index a212cef..d7a559f 100644
> > --- a/drivers/acpi/bus.c
> > +++ b/drivers/acpi/bus.c
> > @@ -46,6 +46,7 @@ ACPI_MODULE_NAME("bus");
> >  struct acpi_device *acpi_root;
> >  struct proc_dir_entry *acpi_root_dir;
> >  EXPORT_SYMBOL(acpi_root_dir);
> > +static u64 spcr_uart_addr;
> >  
> >  #ifdef CONFIG_X86
> >  #ifdef CONFIG_ACPI_CUSTOM_DSDT
> > @@ -93,6 +94,17 @@ acpi_status acpi_bus_get_status_handle(acpi_handle handle,
> >  {
> >  	acpi_status status;
> >  
> > +	if (spcr_uart_addr != 0xffffffffffffffff) {
> 
> The SPCR spec says that the Base Address fields being zero means that
> console redirection is disabled (though I'm not clear on whether or not
> that requires the whole acpi_generic_address to be zero).
> 
> Can we not use that here?

Shannon changed the code from 0 to 0xffffffffffffffff following my
suggestion to his previous series, but I didn't realize that the SPCR
spec says 0 means no console redirection. In that case using 0 is
better.
