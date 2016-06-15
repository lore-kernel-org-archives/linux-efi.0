From: Octavian Purdila <octavian.purdila@intel.com>
Subject: Re: [PATCH v3 7/8] acpi: add support for configfs
Date: Wed, 15 Jun 2016 13:20:51 +0300
Message-ID: <CAE1zotJFg6xWexm0WbxOwU0JFsQ5NJUvo-Tw=hFmqXpNMuwYbA@mail.gmail.com>
References: <201606150617.OKhb5WCs%fengguang.wu@intel.com>
	<3209646.novQQXrKbd@vostro.rjw.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3209646.novQQXrKbd@vostro.rjw.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: kbuild test robot <lkp@intel.com>, kbuild-all@01.org, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Mark Brown <broonie@kernel.org>, Wolfram Sang <wsa@the-dreams.de>, Joel Becker <jlbec@evilplan.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, linux-efi@vger.kernel.org, linux-i2c <linux-i2c@vger.kernel.org>, linux-spi <linux-spi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Irina Tirdea <irina.tirdea@intel.com>
List-Id: linux-efi@vger.kernel.org

On Wed, Jun 15, 2016 at 1:59 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> Hi Octavian,
>
> On Wednesday, June 15, 2016 06:43:21 AM kbuild test robot wrote:
>> Hi,
>>
>> [auto build test ERROR on pm/linux-next]
>> [also build test ERROR on v4.7-rc3]
>> [cannot apply to next-20160614]
>> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>>
>> url:    https://github.com/0day-ci/linux/commits/Octavian-Purdila/ACPI-overlays/20160614-202312
>> base:   https://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git linux-next
>> config: x86_64-allyesconfig (attached as .config)
>> compiler: gcc-6 (Debian 6.1.1-1) 6.1.1 20160430
>> reproduce:
>>         # save the attached .config to linux build tree
>>         make ARCH=x86_64
>>
>> Note: the linux-review/Octavian-Purdila/ACPI-overlays/20160614-202312 HEAD 042f716a165ffa274684c787377acddfc1f34e3f builds fine.
>>       It only hurts bisectibility.
>>
>> All errors (new ones prefixed by >>):
>>
>>    drivers/acpi/configfs.c: In function 'acpi_configfs_init':
>> >> drivers/acpi/configfs.c:19:31: error: 'acpi_configfs' undeclared (first use in this function)
>>      struct config_group *root = &acpi_configfs.su_group;
>>                                   ^~~~~~~~~~~~~
>>    drivers/acpi/configfs.c:19:31: note: each undeclared identifier is reported only once for each function it appears in
>>    drivers/acpi/configfs.c: In function 'acpi_configfs_exit':
>>    drivers/acpi/configfs.c:33:33: error: 'acpi_configfs' undeclared (first use in this function)
>>      configfs_unregister_subsystem(&acpi_configfs);
>>                                     ^~~~~~~~~~~~~
>>
>> vim +/acpi_configfs +19 drivers/acpi/configfs.c
>>
>>     13        #include <linux/configfs.h>
>>     14        #include <linux/acpi.h>
>>     15
>>     16        static int __init acpi_configfs_init(void)
>>     17        {
>>     18                int ret;
>>   > 19                struct config_group *root = &acpi_configfs.su_group;
>>     20
>>     21                config_group_init(root);
>>     22
>>
>> ---
>
> Any chance to send an updated patch with this fixed?
>
> No need to resend the whole series, just this single patch, please.
>

Oops, sorry about that. I will have to resend at least the last two
patches to fix this issue, but since I have missed to add the
Reviewed-by from Mika for another two patches, its probably best to
resend the whole series?
