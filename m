From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efi/reboot: Fall back to original power-off method if
 EFI_RESET_SHUTDOWN returns
Date: Thu, 25 May 2017 12:11:26 +0100
Message-ID: <20170525111126.GB3546@codeblueprint.co.uk>
References: <20170423123655.13015-1-hdegoede@redhat.com>
 <CAKv+Gu-qSMK6YTh5O=w-6mOSdAkMzNn945M+TAC0CAMRfgVhmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-qSMK6YTh5O=w-6mOSdAkMzNn945M+TAC0CAMRfgVhmw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 19 May, at 04:45:49PM, Ard Biesheuvel wrote:
> 
> This does not look unreasonable to me, but this is more Matt's turf so
> I will let him handle this one.

I was hoping that either Len or Rafael would have chimed in by now,
but they were probably waiting for me...

Doesn't ACPI reduced require that EFI power off be supported? I can't
find anything in the spec that makes that connection.

Unless the ACPI folks provide a reason that falling back to ACPI
poweroff doesn't make sense for ACPI reduced hardware, I think we
should apply this patch.
