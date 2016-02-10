From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v4 01/17] Xen: ACPI: Hide UART used by Xen
Date: Wed, 10 Feb 2016 23:29:31 +0100
Message-ID: <44113385.2QnPtvxQx0@vostro.rjw.lan>
References: <1454641552-12576-1-git-send-email-zhaoshenglong@huawei.com> <2213954.ztOe55fprN@vostro.rjw.lan> <alpine.DEB.2.02.1602091116240.27008@kaball.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1602091116240.27008@kaball.uk.xensource.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, Shannon Zhao <zhaoshenglong@huawei.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, ard.biesheuvel@linaro.org, stefano.stabellini@citrix.com, david.vrabel@citrix.com, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, julien.grall@citrix.com, xen-devel@lists.xen.org, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, linux-efi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, ian.campbell@citrix.com, Shannon Zhao <shannon.zhao@linaro.org>, peter.huangpeng@huawei.com, Len Brown <lenb@kernel.org>, "open list:ACPI" <linux-acpi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Tuesday, February 09, 2016 11:19:02 AM Stefano Stabellini wrote:
> On Mon, 8 Feb 2016, Rafael J. Wysocki wrote:
> > On Monday, February 08, 2016 10:57:01 AM Stefano Stabellini wrote:
> > > On Sat, 6 Feb 2016, Rafael J. Wysocki wrote:
> > > > On Fri, Feb 5, 2016 at 4:05 AM, Shannon Zhao <zhaoshenglong@huawei.com> wrote:
> > > > > From: Shannon Zhao <shannon.zhao@linaro.org>
> > > > >
> > > > > ACPI 6.0 introduces a new table STAO to list the devices which are used
> > > > > by Xen and can't be used by Dom0. On Xen virtual platforms, the physical
> > > > > UART is used by Xen. So here it hides UART from Dom0.
> > > > >
> > > > > Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> > > > > Reviewed-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > > > 
> > > > Well, this doesn't look right to me.
> > > > 
> > > > We need to find a nicer way to achieve what you want.
> > > 
> > > I take that you are talking about how to honor the STAO table in Linux.
> > > Do you have any concrete suggestions?
> > 
> > I do.
> > 
> > The last hunk of the patch is likely what it needs to be, although I'm
> > not sure if the place it is added to is the right one.  That's a minor thing,
> > though.
> > 
> > The other part is problematic.  Not that as it doesn't work, but because of
> > how it works.  With these changes the device will be visible to the OS (in
> > fact to user space even), but will never be "present".  I'm not sure if
> > that's what you want?
> > 
> > It might be better to add a check to acpi_bus_type_and_status() that will
> > evaluate the "should ignore?" thing and return -ENODEV if this is true.  This
> > way the device won't be visible at all.
> 
> Something like below?  Actually your suggestion is better, thank you!
> 
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index 78d5f02..4778c51 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -1455,6 +1455,9 @@ static int acpi_bus_type_and_status(acpi_handle handle, int *type,
>  	if (ACPI_FAILURE(status))
>  		return -ENODEV;
>  
> +	if (acpi_check_device_is_ignored(handle))
> +		return -ENODEV;
> +
>  	switch (acpi_type) {
>  	case ACPI_TYPE_ANY:		/* for ACPI_ROOT_OBJECT */
>  	case ACPI_TYPE_DEVICE:
> 

I thought about doing that under ACPI_TYPE_DEVICE, because it shouldn't be
applicable to the other types.  But generally, yes.

Plus I'd move the table checks to acpi_scan_init(), so the UART address can
be a static variable in scan.c.

Also maybe rename acpi_check_device_is_ignored() to something like
acpi_device_should_be_hidden().

Thanks,
Rafael

