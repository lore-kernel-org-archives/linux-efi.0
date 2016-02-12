From: "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 01/17] Xen: ACPI: Hide UART used by Xen
Date: Fri, 12 Feb 2016 13:57:44 +0100
Message-ID: <CAJZ5v0j7Vv5B-+CYt=ZAvO+YTj6-0Cm0Bi=1AjG5JbTeNLW3EQ@mail.gmail.com>
References: <1454641552-12576-1-git-send-email-zhaoshenglong@huawei.com>
	<44113385.2QnPtvxQx0@vostro.rjw.lan>
	<alpine.DEB.2.02.1602111557430.27008@kaball.uk.xensource.com>
	<1667812.hY9vsC2epc@vostro.rjw.lan>
	<alpine.DEB.2.02.1602121138090.27008@kaball.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.02.1602121138090.27008-7Z66fg9igcxYtxbxJUhB2Dgeux46jI+i@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
Cc: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ian Campbell <ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "open list:ACPI" <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Feb 12, 2016 at 12:50 PM, Stefano Stabellini
<stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org> wrote:
> On Thu, 11 Feb 2016, Rafael J. Wysocki wrote:
>> On Thursday, February 11, 2016 04:04:14 PM Stefano Stabellini wrote:
>> > On Wed, 10 Feb 2016, Rafael J. Wysocki wrote:
>> > > On Tuesday, February 09, 2016 11:19:02 AM Stefano Stabellini wrote:
>> > > > On Mon, 8 Feb 2016, Rafael J. Wysocki wrote:
>> > > > > On Monday, February 08, 2016 10:57:01 AM Stefano Stabellini wrote:
>> > > > > > On Sat, 6 Feb 2016, Rafael J. Wysocki wrote:
>> > > > > > > On Fri, Feb 5, 2016 at 4:05 AM, Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>> > > > > > > > From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> > > > > > > >
>> > > > > > > > ACPI 6.0 introduces a new table STAO to list the devices which are used
>> > > > > > > > by Xen and can't be used by Dom0. On Xen virtual platforms, the physical
>> > > > > > > > UART is used by Xen. So here it hides UART from Dom0.
>> > > > > > > >
>> > > > > > > > Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> > > > > > > > Reviewed-by: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
>> > > > > > >
>> > > > > > > Well, this doesn't look right to me.
>> > > > > > >
>> > > > > > > We need to find a nicer way to achieve what you want.
>> > > > > >
>> > > > > > I take that you are talking about how to honor the STAO table in Linux.
>> > > > > > Do you have any concrete suggestions?
>> > > > >
>> > > > > I do.
>> > > > >
>> > > > > The last hunk of the patch is likely what it needs to be, although I'm
>> > > > > not sure if the place it is added to is the right one.  That's a minor thing,
>> > > > > though.
>> > > > >
>> > > > > The other part is problematic.  Not that as it doesn't work, but because of
>> > > > > how it works.  With these changes the device will be visible to the OS (in
>> > > > > fact to user space even), but will never be "present".  I'm not sure if
>> > > > > that's what you want?
>> > > > >
>> > > > > It might be better to add a check to acpi_bus_type_and_status() that will
>> > > > > evaluate the "should ignore?" thing and return -ENODEV if this is true.  This
>> > > > > way the device won't be visible at all.
>> > > >
>> > > > Something like below?  Actually your suggestion is better, thank you!
>> > > >
>> > > > diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
>> > > > index 78d5f02..4778c51 100644
>> > > > --- a/drivers/acpi/scan.c
>> > > > +++ b/drivers/acpi/scan.c
>> > > > @@ -1455,6 +1455,9 @@ static int acpi_bus_type_and_status(acpi_handle handle, int *type,
>> > > >         if (ACPI_FAILURE(status))
>> > > >                 return -ENODEV;
>> > > >
>> > > > +       if (acpi_check_device_is_ignored(handle))
>> > > > +               return -ENODEV;
>> > > > +
>> > > >         switch (acpi_type) {
>> > > >         case ACPI_TYPE_ANY:             /* for ACPI_ROOT_OBJECT */
>> > > >         case ACPI_TYPE_DEVICE:
>> > > >
>> > >
>> > > I thought about doing that under ACPI_TYPE_DEVICE, because it shouldn't be
>> > > applicable to the other types.  But generally, yes.
>> >
>> > I was pondering about it myself. Maybe an ACPI_TYPE_PROCESSOR object
>> > could theoretically be hidden with the STAO?
>>
>> But this patch won't check for it anyway, will it?
>>
>> It seems to be only checking against the UART address or have I missed
>> anything?
>
> You are right, this patch only checks for the UART address, which is
> critical.
>
> However the STAO also has a "Name List" field with a list of paths in
> ACPI namespace to hide. If not implementing proper "Name List" support,
> at least, as part of this patch, it would be nice to check for the
> presence of the Name List field in the table, and print a warning such
> as "STAO Name List not yet supported" when the field is present.

That would be fine, but anyway it belongs to the table parsing part IMO.

And the check can be moved when adding proper support for the name list part.

Thanks,
Rafael
