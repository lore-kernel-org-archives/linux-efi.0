From: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 01/17] Xen: ACPI: Hide UART used by Xen
Date: Mon, 29 Feb 2016 10:02:36 +0800
Message-ID: <56D3A6BC.8020005@huawei.com>
References: <1454641552-12576-1-git-send-email-zhaoshenglong@huawei.com> <44113385.2QnPtvxQx0@vostro.rjw.lan> <alpine.DEB.2.02.1602111557430.27008@kaball.uk.xensource.com> <1667812.hY9vsC2epc@vostro.rjw.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1667812.hY9vsC2epc-sKB8Sp2ER+y1GS7QM15AGw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
Cc: "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, ACPI <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org



On 2016/2/12 6:22, Rafael J. Wysocki wrote:
> On Thursday, February 11, 2016 04:04:14 PM Stefano Stabellini wrote:
>> > On Wed, 10 Feb 2016, Rafael J. Wysocki wrote:
>>> > > On Tuesday, February 09, 2016 11:19:02 AM Stefano Stabellini wrote:
>>>> > > > On Mon, 8 Feb 2016, Rafael J. Wysocki wrote:
>>>>> > > > > On Monday, February 08, 2016 10:57:01 AM Stefano Stabellini wrote:
>>>>>> > > > > > On Sat, 6 Feb 2016, Rafael J. Wysocki wrote:
>>>>>>> > > > > > > On Fri, Feb 5, 2016 at 4:05 AM, Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>>>>>>>> > > > > > > > From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>>>>>>> > > > > > > >
>>>>>>>> > > > > > > > ACPI 6.0 introduces a new table STAO to list the devices which are used
>>>>>>>> > > > > > > > by Xen and can't be used by Dom0. On Xen virtual platforms, the physical
>>>>>>>> > > > > > > > UART is used by Xen. So here it hides UART from Dom0.
>>>>>>>> > > > > > > >
>>>>>>>> > > > > > > > Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>>>>>>> > > > > > > > Reviewed-by: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
>>>>>>> > > > > > > 
>>>>>>> > > > > > > Well, this doesn't look right to me.
>>>>>>> > > > > > > 
>>>>>>> > > > > > > We need to find a nicer way to achieve what you want.
>>>>>> > > > > > 
>>>>>> > > > > > I take that you are talking about how to honor the STAO table in Linux.
>>>>>> > > > > > Do you have any concrete suggestions?
>>>>> > > > > 
>>>>> > > > > I do.
>>>>> > > > > 
>>>>> > > > > The last hunk of the patch is likely what it needs to be, although I'm
>>>>> > > > > not sure if the place it is added to is the right one.  That's a minor thing,
>>>>> > > > > though.
>>>>> > > > > 
>>>>> > > > > The other part is problematic.  Not that as it doesn't work, but because of
>>>>> > > > > how it works.  With these changes the device will be visible to the OS (in
>>>>> > > > > fact to user space even), but will never be "present".  I'm not sure if
>>>>> > > > > that's what you want?
>>>>> > > > > 
>>>>> > > > > It might be better to add a check to acpi_bus_type_and_status() that will
>>>>> > > > > evaluate the "should ignore?" thing and return -ENODEV if this is true.  This
>>>>> > > > > way the device won't be visible at all.
>>>> > > > 
>>>> > > > Something like below?  Actually your suggestion is better, thank you!
>>>> > > > 
>>>> > > > diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
>>>> > > > index 78d5f02..4778c51 100644
>>>> > > > --- a/drivers/acpi/scan.c
>>>> > > > +++ b/drivers/acpi/scan.c
>>>> > > > @@ -1455,6 +1455,9 @@ static int acpi_bus_type_and_status(acpi_handle handle, int *type,
>>>> > > >  	if (ACPI_FAILURE(status))
>>>> > > >  		return -ENODEV;
>>>> > > >  
>>>> > > > +	if (acpi_check_device_is_ignored(handle))
>>>> > > > +		return -ENODEV;
>>>> > > > +
>>>> > > >  	switch (acpi_type) {
>>>> > > >  	case ACPI_TYPE_ANY:		/* for ACPI_ROOT_OBJECT */
>>>> > > >  	case ACPI_TYPE_DEVICE:
>>>> > > > 
>>> > > 
>>> > > I thought about doing that under ACPI_TYPE_DEVICE, because it shouldn't be
>>> > > applicable to the other types.  But generally, yes.
>> > 
>> > I was pondering about it myself. Maybe an ACPI_TYPE_PROCESSOR object
>> > could theoretically be hidden with the STAO?
> But this patch won't check for it anyway, will it?
> 
> It seems to be only checking against the UART address or have I missed
> anything?
> 
>> > I added the check before
>> > the switch because I thought that there would be no harm in being
>> > caution about it.
>> > 
>> > 
>>> > > Plus I'd move the table checks to acpi_scan_init(), so the UART address can
>>> > > be a static variable in scan.c.
>>> > >
>>> > > Also maybe rename acpi_check_device_is_ignored() to something like
>>> > > acpi_device_should_be_hidden().
>> > 
>> > Both make sense. Shannon, are you happy to make these changes?
> Plus maybe make acpi_device_should_be_hidden() print a (KERN_INFO) message
> when it decides to hide something?
Ok, will update this patch. Thanks a lot!

-- 
Shannon
