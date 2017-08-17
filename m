From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 0/2] Add EFI capsule pstore backend support
Date: Thu, 17 Aug 2017 17:20:52 +0100
Message-ID: <CAKv+Gu8CEgCYpAf6v31Bwhgycg4KKo7d6NtKtE5vxYzcjj1SJA@mail.gmail.com>
References: <20170626153859.36880-1-qiuxu.zhuo@intel.com> <E6AF1AFDEA62A94A97508F458CBDD47F6F5B7613@SHSMSX101.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E6AF1AFDEA62A94A97508F458CBDD47F6F5B7613-0J0gbvR4kThpB2pF5aRoyrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Zhuo, Qiuxu" <qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org" <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org" <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 17 August 2017 at 03:29, Zhuo, Qiuxu <qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> -----Original Message-----
>> From: Zhuo, Qiuxu
>> Sent: Monday, June 26, 2017 11:39 PM
>> To: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org; ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org;
>> keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
>> Cc: Luck, Tony <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Zhuo, Qiuxu
>> <qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Subject: [PATCH v5 0/2] Add EFI capsule pstore backend support
>>
>> Change Log v4->v5:
>>  - 0001 patch: No change.
>>  - 0002 patch: Fix up all "line over 80 characters" warnings reported by
>> checkpatch.pl tool.
>>
>> Qiuxu Zhuo (2):
>>   efi: Add 'nr_config_table' variable in efi structure
>>   eif/capsule-pstore: Add capsule pstore backend
>>
>>  arch/x86/platform/efi/efi.c           |   1 +
>>  drivers/firmware/efi/Kconfig          |  21 +
>>  drivers/firmware/efi/Makefile         |   1 +
>>  drivers/firmware/efi/arm-init.c       |   4 +-
>>  drivers/firmware/efi/capsule-pstore.c | 698
>> ++++++++++++++++++++++++++++++++++
>>  drivers/firmware/efi/efi.c            |   1 +
>>  include/linux/efi.h                   |   1 +
>>  7 files changed, 726 insertions(+), 1 deletion(-)  create mode 100644
>> drivers/firmware/efi/capsule-pstore.c
>>
>
> Hi Ard,
>     Do you have some updates? If any question please let me know.
>     Thanks!
>

Hi,

Please check with Michael Rothman inside your own organization. I have
tried to get clarification a couple of times, but I am getting no
response.
