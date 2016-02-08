From: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>
Subject: Re: [PATCH v4 01/17] Xen: ACPI: Hide UART used by Xen
Date: Mon, 08 Feb 2016 23:25:37 +0100
Message-ID: <2213954.ztOe55fprN@vostro.rjw.lan>
References: <1454641552-12576-1-git-send-email-zhaoshenglong@huawei.com> <CAJZ5v0id-035AtyQ_SccPuCxD7+pa6GCgj3WBAojM+rFqssGQQ@mail.gmail.com> <alpine.DEB.2.02.1602081054350.27008@kaball.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7Bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.02.1602081054350.27008-7Z66fg9igcxYtxbxJUhB2Dgeux46jI+i@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
Cc: "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "open list:ACPI" <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Monday, February 08, 2016 10:57:01 AM Stefano Stabellini wrote:
> On Sat, 6 Feb 2016, Rafael J. Wysocki wrote:
> > On Fri, Feb 5, 2016 at 4:05 AM, Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> > > From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > >
> > > ACPI 6.0 introduces a new table STAO to list the devices which are used
> > > by Xen and can't be used by Dom0. On Xen virtual platforms, the physical
> > > UART is used by Xen. So here it hides UART from Dom0.
> > >
> > > Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > > Reviewed-by: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
> > 
> > Well, this doesn't look right to me.
> > 
> > We need to find a nicer way to achieve what you want.
> 
> I take that you are talking about how to honor the STAO table in Linux.
> Do you have any concrete suggestions?

I do.

The last hunk of the patch is likely what it needs to be, although I'm
not sure if the place it is added to is the right one.  That's a minor thing,
though.

The other part is problematic.  Not that as it doesn't work, but because of
how it works.  With these changes the device will be visible to the OS (in
fact to user space even), but will never be "present".  I'm not sure if
that's what you want?

It might be better to add a check to acpi_bus_type_and_status() that will
evaluate the "should ignore?" thing and return -ENODEV if this is true.  This
way the device won't be visible at all.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
