From: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>
Subject: Re: [PATCH v3 7/8] acpi: add support for configfs
Date: Wed, 15 Jun 2016 00:59 +0200
Message-ID: <3209646.novQQXrKbd@vostro.rjw.lan>
References: <201606150617.OKhb5WCs%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201606150617.OKhb5WCs%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, kbuild-all-JC7UmRfGjtg@public.gmane.org, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>, Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-spi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, irina.tirdea-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi Octavian,

On Wednesday, June 15, 2016 06:43:21 AM kbuild test robot wrote:
> Hi,
> 
> [auto build test ERROR on pm/linux-next]
> [also build test ERROR on v4.7-rc3]
> [cannot apply to next-20160614]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Octavian-Purdila/ACPI-overlays/20160614-202312
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git linux-next
> config: x86_64-allyesconfig (attached as .config)
> compiler: gcc-6 (Debian 6.1.1-1) 6.1.1 20160430
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
> 
> Note: the linux-review/Octavian-Purdila/ACPI-overlays/20160614-202312 HEAD 042f716a165ffa274684c787377acddfc1f34e3f builds fine.
>       It only hurts bisectibility.
> 
> All errors (new ones prefixed by >>):
> 
>    drivers/acpi/configfs.c: In function 'acpi_configfs_init':
> >> drivers/acpi/configfs.c:19:31: error: 'acpi_configfs' undeclared (first use in this function)
>      struct config_group *root = &acpi_configfs.su_group;
>                                   ^~~~~~~~~~~~~
>    drivers/acpi/configfs.c:19:31: note: each undeclared identifier is reported only once for each function it appears in
>    drivers/acpi/configfs.c: In function 'acpi_configfs_exit':
>    drivers/acpi/configfs.c:33:33: error: 'acpi_configfs' undeclared (first use in this function)
>      configfs_unregister_subsystem(&acpi_configfs);
>                                     ^~~~~~~~~~~~~
> 
> vim +/acpi_configfs +19 drivers/acpi/configfs.c
> 
>     13	#include <linux/configfs.h>
>     14	#include <linux/acpi.h>
>     15	
>     16	static int __init acpi_configfs_init(void)
>     17	{
>     18		int ret;
>   > 19		struct config_group *root = &acpi_configfs.su_group;
>     20	
>     21		config_group_init(root);
>     22	
> 
> ---

Any chance to send an updated patch with this fixed?

No need to resend the whole series, just this single patch, please.

Thanks,
Rafael
