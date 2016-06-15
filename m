From: "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 7/8] acpi: add support for configfs
Date: Wed, 15 Jun 2016 23:02:20 +0200
Message-ID: <CAJZ5v0ip=GuF041dR3m4mMSOqxMU7BDMYC2YTpKtCsjL6pXM+w@mail.gmail.com>
References: <201606150617.OKhb5WCs%fengguang.wu@intel.com> <3209646.novQQXrKbd@vostro.rjw.lan>
 <CAE1zotJFg6xWexm0WbxOwU0JFsQ5NJUvo-Tw=hFmqXpNMuwYbA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAE1zotJFg6xWexm0WbxOwU0JFsQ5NJUvo-Tw=hFmqXpNMuwYbA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, kbuild-all-JC7UmRfGjtg@public.gmane.org, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>, Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>, "linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-i2c <linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-spi <linux-spi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Irina Tirdea <irina.tirdea-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Jun 15, 2016 at 12:20 PM, Octavian Purdila
<octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> On Wed, Jun 15, 2016 at 1:59 AM, Rafael J. Wysocki <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org> wrote:
>> Hi Octavian,
>>
>> On Wednesday, June 15, 2016 06:43:21 AM kbuild test robot wrote:
>>> Hi,
>>>
>>> [auto build test ERROR on pm/linux-next]
>>> [also build test ERROR on v4.7-rc3]
>>> [cannot apply to next-20160614]
>>> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>>>
>>> url:    https://github.com/0day-ci/linux/commits/Octavian-Purdila/ACPI-overlays/20160614-202312
>>> base:   https://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git linux-next
>>> config: x86_64-allyesconfig (attached as .config)
>>> compiler: gcc-6 (Debian 6.1.1-1) 6.1.1 20160430
>>> reproduce:
>>>         # save the attached .config to linux build tree
>>>         make ARCH=x86_64
>>>
>>> Note: the linux-review/Octavian-Purdila/ACPI-overlays/20160614-202312 HEAD 042f716a165ffa274684c787377acddfc1f34e3f builds fine.
>>>       It only hurts bisectibility.
>>>
>>> All errors (new ones prefixed by >>):
>>>
>>>    drivers/acpi/configfs.c: In function 'acpi_configfs_init':
>>> >> drivers/acpi/configfs.c:19:31: error: 'acpi_configfs' undeclared (first use in this function)
>>>      struct config_group *root = &acpi_configfs.su_group;
>>>                                   ^~~~~~~~~~~~~
>>>    drivers/acpi/configfs.c:19:31: note: each undeclared identifier is reported only once for each function it appears in
>>>    drivers/acpi/configfs.c: In function 'acpi_configfs_exit':
>>>    drivers/acpi/configfs.c:33:33: error: 'acpi_configfs' undeclared (first use in this function)
>>>      configfs_unregister_subsystem(&acpi_configfs);
>>>                                     ^~~~~~~~~~~~~
>>>
>>> vim +/acpi_configfs +19 drivers/acpi/configfs.c
>>>
>>>     13        #include <linux/configfs.h>
>>>     14        #include <linux/acpi.h>
>>>     15
>>>     16        static int __init acpi_configfs_init(void)
>>>     17        {
>>>     18                int ret;
>>>   > 19                struct config_group *root = &acpi_configfs.su_group;
>>>     20
>>>     21                config_group_init(root);
>>>     22
>>>
>>> ---
>>
>> Any chance to send an updated patch with this fixed?
>>
>> No need to resend the whole series, just this single patch, please.
>>
>
> Oops, sorry about that. I will have to resend at least the last two
> patches to fix this issue, but since I have missed to add the
> Reviewed-by from Mika for another two patches, its probably best to
> resend the whole series?

Yes, please.
