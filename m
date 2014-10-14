From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH] dmi: add support for SMBIOS 3.0 64-bit entry point
Date: Tue, 14 Oct 2014 16:19:16 +0200
Message-ID: <CAKv+Gu95g=wUtQOJtx4kNVOZ6qJmcZTVukNNQQ_vJNW074tQwQ@mail.gmail.com>
References: <1413208113-16374-1-git-send-email-ard.biesheuvel@linaro.org>
	<543BDB38.6030807@amd.com>
	<543D3019.1020404@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <543D3019.1020404-5C7GfCeVMHo@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suravee Suthikulanit <suravee.suthikulpanit-5C7GfCeVMHo@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 14 October 2014 16:15, Suravee Suthikulanit
<suravee.suthikulpanit-5C7GfCeVMHo@public.gmane.org> wrote:
> On 10/13/2014 9:01 AM, Suravee Suthikulanit wrote:
>>
>> On 10/13/2014 8:48 AM, Ard Biesheuvel wrote:
>>>
>>> +#define SMBIOS3_TABLE_GUID    \
>>> +    EFI_GUID(  0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00,
>>> 0x00, 0x00, 0x00, 0x00 )
>>> +
>>
>>
>> Ard,
>>
>> I believe the new SMBIOS3_TABLE_GUILD has already been accepted by the
>> USWG.
>>
>> #define SMBIOS3_TABLE_GUID \
>>     {0xf2fd1544, 0x9794, 0x4a2c, 0x99, 0x2e, 0xe5, 0xbb, 0xcf, 0x20,
>> 0xe3, 0x94}
>>
>> Thanks,
>>
>> Suravee
>
>
> Hi All,
>
> With Yi's original patch + this patch + changes for the the ID above, I am
> able to parse the SMBIOS information (shown below).
>

Great news! May I add your tested-by to the patches?

Regards,
Ard.

> bios_date = 12/12/2012
> bios_vendor = American Megatrends Inc.
> bios_version = 5.6.5
> board_asset_tag = Defaultstring
> board_name = Defaultstring
> board_serial = Defaultstring
> board_vendor = Defaultstring
> board_version = Defaultstring
> chassis_asset_tag = Defaultstring
> chassis_serial = Defaultstring
> chassis_type = 3
> chassis_vendor = Defaultstring
> chassis_version = Defaultstring
> modalias =
> dmi:bvnAmericanMegatrendsInc.:bvr5.6.5:bd12/12/2012:svnDefaultstring:pnDefaultstring:pvrDefaultstring:rvnDefaultstring:rnDefaultstring:rvrDefaultstring:cvnDefaultstring:ct3:cvrDefaultstring:
> cat: power: Is a directory
> power =
> product_name = Defaultstring
> product_serial = Defaultstring
> product_uuid = 00020003-0004-0005-0006-000700080009
> product_version = Defaultstring
> cat: subsystem: Is a directory
> subsystem =
> sys_vendor = Defaultstring
> uevent =
> MODALIAS=dmi:bvnAmericanMegatrendsInc.:bvr5.6.5:bd12/12/2012:svnDefaultstring:pnDefaultstring:pvrDefaultstring:rvnDefaultstring:rnDefaultstring:rvrDefaultstring:cvnDefaultstring:ct3:cvrDefaultstring:
>
> Also:
>
> [root@acadia-snap4 sys]# find . | grep dmi
> ./devices/virtual/dmi
> ./devices/virtual/dmi/id
> ./devices/virtual/dmi/id/product_name
> ./devices/virtual/dmi/id/product_uuid
> ./devices/virtual/dmi/id/board_name
> ./devices/virtual/dmi/id/board_asset_tag
> ./devices/virtual/dmi/id/power
> ./devices/virtual/dmi/id/chassis_serial
> ./devices/virtual/dmi/id/product_version
> ./devices/virtual/dmi/id/chassis_vendor
> ./devices/virtual/dmi/id/modalias
> ./devices/virtual/dmi/id/chassis_version
> ./devices/virtual/dmi/id/bios_date
> ./devices/virtual/dmi/id/bios_version
> ./devices/virtual/dmi/id/product_serial
> ./devices/virtual/dmi/id/sys_vendor
> ./devices/virtual/dmi/id/subsystem
> ./devices/virtual/dmi/id/bios_vendor
> ./devices/virtual/dmi/id/board_serial
> ./devices/virtual/dmi/id/uevent
> ./devices/virtual/dmi/id/chassis_asset_tag
> ./devices/virtual/dmi/id/chassis_type
> ./devices/virtual/dmi/id/board_vendor
> ./devices/virtual/dmi/id/board_version
> ./class/dmi
> ./class/dmi/id
> ./firmware/dmi
> ./firmware/dmi/entries
> ./firmware/dmi/entries/0-0
> ./firmware/dmi/entries/0-0/raw
> ./firmware/dmi/entries/0-0/type
> ./firmware/dmi/entries/0-0/position
> ./firmware/dmi/entries/0-0/handle
> ./firmware/dmi/entries/0-0/length
> ./firmware/dmi/entries/0-0/instance
> ./firmware/dmi/entries/1-0
> ./firmware/dmi/entries/1-0/raw
> ./firmware/dmi/entries/1-0/type
> ./firmware/dmi/entries/1-0/position
> ./firmware/dmi/entries/1-0/handle
> ./firmware/dmi/entries/1-0/length
> ./firmware/dmi/entries/1-0/instance
> .....
>
> Thanks for working on adding this support.
>
> Suravee
>
