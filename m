From: ivanhu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH] efi: add efi_test driver for exporting UEFI runtime
 service interfaces
Date: Fri, 22 Jul 2016 16:30:03 +0800
Message-ID: <5791D98B.1000002@canonical.com>
References: <1468569498-9889-1-git-send-email-ivan.hu@canonical.com>
 <20160722072658.GE12939@linux-rxt1.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160722072658.GE12939-empE8CJ7fzk2xCFIczX1Fw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Cc: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi Joey,

Thanks for your comments.

On 2016=E5=B9=B407=E6=9C=8822=E6=97=A5 15:26, joeyli wrote:
> Hi Ivan,
>
> On Fri, Jul 15, 2016 at 03:58:18PM +0800, Ivan Hu wrote:
>> This driver is used by the Firmware Test Suite (FWTS) for testing th=
e UEFI
>> runtime interfaces readiness of the firmware.
>>
>> This driver exports UEFI runtime service interfaces into userspace,
>> which allows to use and test UEFI runtime services provided by the
>> firmware.
>>
>> This driver uses the efi.<service> function pointers directly instea=
d of
>> going through the efivar API to allow for direct testing of the UEFI
>> runtime service interfaces provided by the firmware.
>>
>> Details for FWTS are available from,
>> <https://wiki.ubuntu.com/FirmwareTestSuite>
>>
>> Signed-off-by: Ivan Hu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
>> ---
>>   MAINTAINERS                              |   6 +
>>   drivers/firmware/efi/Kconfig             |  15 +
>>   drivers/firmware/efi/Makefile            |   1 +
>>   drivers/firmware/efi/efi_test/Makefile   |   1 +
>>   drivers/firmware/efi/efi_test/efi_test.c | 713 +++++++++++++++++++=
++++++++++++
>>   drivers/firmware/efi/efi_test/efi_test.h | 110 +++++
>>   6 files changed, 846 insertions(+)
>>   create mode 100644 drivers/firmware/efi/efi_test/Makefile
>>   create mode 100644 drivers/firmware/efi/efi_test/efi_test.c
>>   create mode 100644 drivers/firmware/efi/efi_test/efi_test.h
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 1209323..1f888cc 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -4471,6 +4471,12 @@ M:	Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>   S:	Maintained
>>   F:	drivers/video/fbdev/efifb.c
>>
>> +EFI TEST DRIVER
>> +L:	linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> +M:      Ivan Hu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
>> +S:      Maintained
>> +F:      drivers/firmware/efi/efi_test/
>> +
>>   EFS FILESYSTEM
>>   W:	http://aeschi.ch.eu.org/efs/
>>   S:	Orphan
>> diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kco=
nfig
>> index 6394152..1cc02bd 100644
>> --- a/drivers/firmware/efi/Kconfig
>> +++ b/drivers/firmware/efi/Kconfig
>> @@ -112,6 +112,21 @@ config EFI_CAPSULE_LOADER
>>
>>   	  Most users should say N.
>>
>> +config EFI_TEST
>> +	tristate "EFI Runtime Services Support"
>
> Because this is a driver for debugging tool, I suggest that it doesn'=
t need to
> allow user to build-in to kernel.

Right now, fwts is a defacto standard test suite and efi_runtime driver=
=20
is packed as dkms package. We would like to make it as part of the=20
kernel which removes a lot of dkms hassles, such as dkms can not be use=
d=20
when secureboot is enabled.

And you are right, this driver is for fwts test and that's why we set=20
kernel build as "default n".

>
> Please considering to put this driver to tools/testing folder. Or you=
 have
> a reason to put this testing driver to drivers/firmware/efi ?

I think drivers/firmware/efi is right place since it is a driver which=20
exports efi.<service> functions.

>
>> +	depends on EFI
>> +	default n
>> +	help
>> +	  Say Y here to enable the runtime services support via /dev/efi_t=
est.
> 								^^^^^^^^^^^^^^
>
> I have tried this testing driver with the master branch of fwts git. =
But I
> found that fwts tries to load efi_runtime kernel module and tries to =
use
> /dev/efi_runtime.
>
> I cloned fwts code from "http://kernel.ubuntu.com/git/hwe/fwts.git" t=
hat it
> is written on FirmwareTestSuite wiki page. And, I found there have a
> efi_runtime driver in fwts/efi_runtime folder.
>
> Did I miss anything for the module name doesn't match?

A patch had been sent out and under reviewing for the developer.
https://lists.ubuntu.com/archives/fwts-devel/2016-July/008168.html

I believe it will be on the branch very soon and will be included in th=
e=20
fwts version V16.07.00 next week.

Cheers,
Ivan
>
>
> Thanks a lot!
> Joey Lee
>
