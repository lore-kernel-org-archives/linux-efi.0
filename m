From: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 10/10] acpi: add support for loading SSDTs via configfs
Date: Tue, 5 Apr 2016 11:21:48 +0300
Message-ID: <CAE1zotKDFLNP5JTnMiWOstE4DYBHVeyP902J9ixD+fJbFqSZ6Q@mail.gmail.com>
References: <1459417026-6697-1-git-send-email-octavian.purdila@intel.com>
	<1459417026-6697-11-git-send-email-octavian.purdila@intel.com>
	<1AE640813FDE7649BE1B193DEA596E883BB66233@SHSMSX101.ccr.corp.intel.com>
	<CAE1zotLgjfKvFr0W9CjFbbkxqM6erLGwv-aHzTt=qwdCPzGOhw@mail.gmail.com>
	<1AE640813FDE7649BE1B193DEA596E883BB6677B@SHSMSX101.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-spi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E883BB6677B-0J0gbvR4kThpB2pF5aRoyrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-spi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Zheng, Lv" <lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>, Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-spi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-spi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Tirdea, Irina" <irina.tirdea-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Apr 5, 2016 at 6:11 AM, Zheng, Lv <lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> Hi,
>
>> From: Octavian Purdila [mailto:octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org]
>> Subject: Re: [RFC PATCH 10/10] acpi: add support for loading SSDTs via configfs
>>
>> On Fri, Apr 1, 2016 at 7:55 AM, Zheng, Lv <lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> > Hi,
>>
>> Hi Lv,
>>
>> >> Add support for acpi_user_table configfs items that allows the user to
>> >> load new tables. The data attributes contains the table data and once it
>> >> is filled from userspace the table is loaded and ACPI devices are
>> >> enumerated.
>> > [Lv Zheng]
>> > We've been considering to implement this facility before.
>> > The 2 alternative solutions are:
>> > 1. implement LOAD/UNLOAD ioctl for /sys/kernel/debug/acpi/acpidbg - this
>> will be useful for extracting AML byte stream from kernel to be used by a
>> userspace disassembler.
>>
>> AFAIK adding new ioctls is discouraged.
> [Lv Zheng]
> Tools/power/acpi/tools/acpidbg is a file descriptor based utility.
> And it needs a method to obtain an AML byte stream from kernel.
> Using ioctl is a best fit design for acpidbg so that it needn't to access any other files.
>
>>
>> > 2. transition /sys/firmware/acpi/tables/xxx into directory and implement
>> /sys/firmware/acpi/tables/load, /sys/firmware/acpi/tables/unload - this should
>> be able to meet your requirement.
>>
>> We can't do that as it would break the ABI.
> [Lv Zheng]
> The only user of this directory hierarchy is acpidump.

Some systems (e.g. Android, Brillo) do not ship acpidump and in this
case the only way to dump tables is by accessing sysfs directly.

> And the user of this tool are all developers/reporters on the kernel bugzilla.
> We've been asking the Bugzilla users to use the up-to-date acpidump instead of the distribution vendor provided one for so many years.
> So IMO, this is not a serious problem you should consider.
> You only need to think about an acceptable way for the distribution vendors to synchronize the kernel change and the acpidump change.
>

I guess the perf model where you have a perf package build together
with the kernel will work. But right now distributions are not using
this model and a kernel change will break the userspace tool.

> IMO:
> You may expose a version file from /sys/firmware/acpi.
> acpidump can be changed accordingly by referencing the version file.
> And old directory hierarchy support could be kept in acpidump.
>

That will still break if you upgrade the kernel and use the old tool.

> Note that acpidump is also a part of the kernel, so your change could be consistent.
> For example,
> If you changed acpidump prior than making the kernel change, the distribution vendors might have already released the new acpidump for all old kernels before you transitioned the directory hierarchy.

To me this still looks like breaking userspace, patches have been
reverted for less :) But I can see how this could be considered a gray
area.

ABI aside, see below for why configfs is better then sysfs.

>
>>
>> > So my first question is:
>> > Why do you use configfs rather than the existing mechanisms?
>>
>> sysfs is not a good choice for dealing with objects created from
>> userspace, configfs was created to address this specific need. Since
>> we want to be able to create and load new tables from userspace this
>> use-case fits very well with configfs.
> [Lv Zheng]
> Was the table binary stream still maintained by the userspace?
> If not, I couldn't see the difference/advantages from using /sys/firmware/acpi/tables to using configfs.
>

It is hard to create new kernel objects from sysfs. You need to resort
to hacks like using new_table sysfs entries which does not map to a
kernel object. Writes larger then PAGE_SIZE are impossible to handle
with multiple open files because you have no open callback to create a
file context. It is also not possible to do any clean-up because there
is no close callback and if something goes wrong for example when
trying to install the table you will leak the allocated memory.

configfs was designed for the specific purpose of creating kernel
objects from userspace and addresses all of the limitations above (and
some more).

Initially I started to implement this functionality via sysfs but I
run into the issues mentioned above and decided to use configfs.
--
To unsubscribe from this list: send the line "unsubscribe linux-spi" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
