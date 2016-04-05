From: Octavian Purdila <octavian.purdila@intel.com>
Subject: Re: [RFC PATCH 02/10] acpi: install SSDT tables from initrd
Date: Tue, 5 Apr 2016 10:23:08 +0300
Message-ID: <CAE1zotJL9QW0V+k-4VJBBFuQ+kCcjGNUJ8W1LKd54Xdp++z3SQ@mail.gmail.com>
References: <1459417026-6697-1-git-send-email-octavian.purdila@intel.com>
	<1459417026-6697-3-git-send-email-octavian.purdila@intel.com>
	<1AE640813FDE7649BE1B193DEA596E883BB66258@SHSMSX101.ccr.corp.intel.com>
	<CAE1zotJ1fa4m-_FO3PUQK8_p0vHcfWD5TmuMdxOSHDjku421pA@mail.gmail.com>
	<CAE1zotLX8L=jpJRYtUddtpYmgc0NxqmtdDjcQPWWg8KTO8PH5A@mail.gmail.com>
	<1AE640813FDE7649BE1B193DEA596E883BB66700@SHSMSX101.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E883BB66700@SHSMSX101.ccr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Zheng, Lv" <lv.zheng@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Mark Brown <broonie@kernel.org>, Wolfram Sang <wsa@the-dreams.de>, Joel Becker <jlbec@evilplan.org>, Christoph Hellwig <hch@lst.de>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>, "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Tirdea, Irina" <irina.tirdea@intel.com>
List-Id: linux-efi@vger.kernel.org

On Tue, Apr 5, 2016 at 3:49 AM, Zheng, Lv <lv.zheng@intel.com> wrote:
> Hi,
>
>> From: Octavian Purdila [mailto:octavian.purdila@intel.com]
>> Subject: Re: [RFC PATCH 02/10] acpi: install SSDT tables from initrd
>>
>> On Fri, Apr 1, 2016 at 1:11 PM, Octavian Purdila
>> <octavian.purdila@intel.com> wrote:
>> > On Fri, Apr 1, 2016 at 8:05 AM, Zheng, Lv <lv.zheng@intel.com> wrote:
>> >> Hi,
>> >>
>> >> IMO, there is already a similar function upstreamed:
>> >>
>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=c85c
>> c81
>> >> Could it work for your use case?
>> >
>> > Yes, it is basically the same.
>> >
>> > The only difference is on how we handle taint. I think we should use a
>> > new taint for overlays and that we don't need to disable lockdep.
>> >
>> > BTW, why is lockdep disabled when we override?
>>
>> The other thing I forgot to mention is that I think we should allow
>> installing new tables even if CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not
>> selected. IMO the override and overlay functionality is different,
>> with the latter being more then a debug option.
> [Lv Zheng]
> I don't think so. The initrd override mechanism is not dependent on CONFIG_ACPI_DEBUG.
> According to the spec, we can allow a higher versioning same table (same table sig, table id, table oem id) to override the old tables as a patching functionality.
> So both the functionalities are not debug options and serve for the same purpose from this point of view.
> And IMO that's why the initrd override mechanism needn't be dependent on CONFIG_ACPI_DEBUG.
>

The problem is that CONFIG_ACPI_INITRD_TABLE_OVERRIDE is presented as
a debug option in Documentation/initrd_table_override.txt and most
distributions are not selecting it which makes it hard to use it in
practice.

> I'm really OK with removing the acpi_table_taint() for CONFIG_ACPI_INITRD_TABLE_OVERRIDE but leaving some info messages indicating the table upgrades.
> I don't think this mechanism is unsafe.
> It happens during a initialization step occurring before the table is loaded and hence should be safe even the synchronization is not so robust in ACPICA.
> And with the revision support added, we should be able to allow vendors to update the buggy tables.
> That means the tables may be originated from the safe sources - the vendors.
>
>>
>> I will prepare a patch for the next version of the series to decouple
>> installing new tables from CONFIG_ACPI_INITRD_TABLE_OVERRIDE.
> [Lv Zheng]
> I don't think they need to be decoupled.
> The use case is:
> If there is an ACPI table in initrd image and:
> 1. if the table's revision is higher than the existing one, override the existing one;
> 2. if the table is a brand new one, install it.
>

The implementation will stay the same of course, I was just suggesting
to move CONFIG_ACPI_INITRD_TABLE_OVERRIDE in
acpi_os_physical_table_override to allow new tables to be loaded even
if the option is not selected.
