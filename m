From: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 10/10] acpi: add support for loading SSDTs via configfs
Date: Wed, 6 Apr 2016 21:46:51 +0300
Message-ID: <CAE1zotKa+t5cxznWfPyQ599k9ZB=akOuEDZusWcJgzux8wqp5A@mail.gmail.com>
References: <1459417026-6697-1-git-send-email-octavian.purdila@intel.com>
	<1459417026-6697-11-git-send-email-octavian.purdila@intel.com>
	<1AE640813FDE7649BE1B193DEA596E883BB66233@SHSMSX101.ccr.corp.intel.com>
	<CAE1zotLgjfKvFr0W9CjFbbkxqM6erLGwv-aHzTt=qwdCPzGOhw@mail.gmail.com>
	<1AE640813FDE7649BE1B193DEA596E883BB6677B@SHSMSX101.ccr.corp.intel.com>
	<CAE1zotKDFLNP5JTnMiWOstE4DYBHVeyP902J9ixD+fJbFqSZ6Q@mail.gmail.com>
	<1AE640813FDE7649BE1B193DEA596E883BB66B8C@SHSMSX101.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-spi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E883BB66B8C-0J0gbvR4kThpB2pF5aRoyrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-spi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Zheng, Lv" <lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>, Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-spi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-spi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Tirdea, Irina" <irina.tirdea-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Apr 6, 2016 at 9:05 AM, Zheng, Lv <lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

>> It is hard to create new kernel objects from sysfs. You need to resort
>> to hacks like using new_table sysfs entries which does not map to a
>> kernel object. Writes larger then PAGE_SIZE are impossible to handle
>> with multiple open files because you have no open callback to create a
>> file context. It is also not possible to do any clean-up because there
>> is no close callback and if something goes wrong for example when
>> trying to install the table you will leak the allocated memory.
>>
>> configfs was designed for the specific purpose of creating kernel
>> objects from userspace and addresses all of the limitations above (and
>> some more).
>>
>> Initially I started to implement this functionality via sysfs but I
>> run into the issues mentioned above and decided to use configfs.
> [Lv Zheng]
> I can sense different difficulties from your descriptions.
> Let me break it down into details.
>
> We already have acpi_table_handler working there for creating new ACPI table entries for us.
> Based on this facility, let's think about the following solution:
> 1. sysfs presenting change
> We can change the table file to a table directory whose name is in the following format:
> TableSignature-OemId-OemTableId
> Then we can get rid of the annoying numbered table name suffix first.
> The numbered table name suffix cannot be kept consistent to reflect the real index if we allow tables to be dynamically loaded/unloaded.
>
> This is the first design difficulty we need to solve.
>
> 2. acpi_table_handler change
> Now we can append 2 new events to acpi_table_handler - ACPI_TABLE_INSTALL/ACPI_TABLE_UNINSTALL.
> With which, the sysfs entries can be created/deleted when the table is added to/removed from the global table list.
> And this should be the working mechanism for us
> So we actually don't have the trouble to deal with the new kernel object creation/deletion from sysfs.
>
> I agree the dynamic kernel object creation/deletion need special care.
> But this actually is what a kernel engineer should do because this kind of things happen here and there throughout the kernel.
> We should have already been used to that.
>
> This is the second engineering difficulty we need to face.
>
> 3. load/unload commanding
> Now we need a character device in sysfs to handle load/unload command.
> Well, there are many such kind of files in sysfs, for example, device nodes.
> So this is not a non-achievable task, but just a difficult engineering task.
> The system engineers need to be skillful enough to implement this.
> Like the dynamic kernel object handling, we should have already been used to this.
>
>
> If you still think this is difficult, the alternative choice is to use acpidbg char device's ioctl interface.
> That could simplifies this task.
> And since the ioctl interface is required by ACPICA disassembler, the work on that will be inherited by the disassembler porting.
>

Why can't the dissembler access the tables through the existing sysfs interface?

> This is the last engineering difficulty we need to face.
>
> So why can't these solutions work for us?
>

It can be done, but it is not the right way to do it, IMO.
--
To unsubscribe from this list: send the line "unsubscribe linux-spi" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
