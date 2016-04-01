From: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 10/10] acpi: add support for loading SSDTs via configfs
Date: Fri, 1 Apr 2016 13:01:30 +0300
Message-ID: <CAE1zotLgjfKvFr0W9CjFbbkxqM6erLGwv-aHzTt=qwdCPzGOhw@mail.gmail.com>
References: <1459417026-6697-1-git-send-email-octavian.purdila@intel.com>
	<1459417026-6697-11-git-send-email-octavian.purdila@intel.com>
	<1AE640813FDE7649BE1B193DEA596E883BB66233@SHSMSX101.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-spi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E883BB66233-0J0gbvR4kThpB2pF5aRoyrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-spi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Zheng, Lv" <lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>, Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-spi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-spi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Tirdea, Irina" <irina.tirdea-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Apr 1, 2016 at 7:55 AM, Zheng, Lv <lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> Hi,

Hi Lv,

>> Add support for acpi_user_table configfs items that allows the user to
>> load new tables. The data attributes contains the table data and once it
>> is filled from userspace the table is loaded and ACPI devices are
>> enumerated.
> [Lv Zheng]
> We've been considering to implement this facility before.
> The 2 alternative solutions are:
> 1. implement LOAD/UNLOAD ioctl for /sys/kernel/debug/acpi/acpidbg - this will be useful for extracting AML byte stream from kernel to be used by a userspace disassembler.

AFAIK adding new ioctls is discouraged.

> 2. transition /sys/firmware/acpi/tables/xxx into directory and implement /sys/firmware/acpi/tables/load, /sys/firmware/acpi/tables/unload - this should be able to meet your requirement.

We can't do that as it would break the ABI.

> So my first question is:
> Why do you use configfs rather than the existing mechanisms?

sysfs is not a good choice for dealing with objects created from
userspace, configfs was created to address this specific need. Since
we want to be able to create and load new tables from userspace this
use-case fits very well with configfs.
--
To unsubscribe from this list: send the line "unsubscribe linux-spi" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
