From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 0/2] Add EFI capsule pstore backend support
Date: Sat, 24 Jun 2017 12:14:55 +0000
Message-ID: <CAKv+Gu-j0hc6o6LLPPESbpmhpGY5=qX=fsD6B15on=VGx51qog@mail.gmail.com>
References: <20170622163434.95704-1-qiuxu.zhuo@intel.com> <CAGXu5jLzd8PdH3mGS_+kYA3-nZwmJCYkeQXH2crJr5LqYGoHaQ@mail.gmail.com>
 <CAKv+Gu_HDjfRUCrJfmuvqD6t=+=a_QjBdj4FyGpH3Q5cMyfGwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu_HDjfRUCrJfmuvqD6t=+=a_QjBdj4FyGpH3Q5cMyfGwA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Qiuxu Zhuo <qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 23 June 2017 at 23:03, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> On 23 June 2017 at 20:42, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
>> On Thu, Jun 22, 2017 at 9:34 AM, Qiuxu Zhuo <qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>>> Change Log v3->v4:
>>>  - Add comment 'the number of config tables' for 'nr_config_table' in efi structure
>>>  - Initialize 'efi.nr_config_table' to 0 in default
>>>  - Set 'efi.nr_config_table' to 'efi.systab->nr_tables' in drivers/firmware/efi/arm-init.c -> uefi_init()
>>>  - Mark 'efi_capsule_pstore_disable' as __ro_after_init
>>>  - Use timestamp value passed from pstore API rather than using get_seconds()
>>>  - Pass page physcial addresses rather than struct page pointers to efi_capsule_update()
>>
>> Thanks for the updates!
>>
>> Reviewed-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
>>
>
>
> Thanks Qiuxu, Kees.
>
> I will queue these on the EFI -next branch.
>

Actually, no, The issue I raised the last time around was not
addressed anywhere, and is not even mentioned in the commit log.

The problem is that there is an ambiguity in the implementation of the
configuration table entries that represent capsule with the
EFI_CAPSULE_PERSIST_ACROSS_RESET and EFI_CAPSULE_POPULATE_SYSTEM_TABLE
flags set.

First of all, there is the padding issue:

typedef struct {
       u32 capsule_array_number;
       void *capsule_addr[];
} __packed efi_capsule_table_t;

This deviates from the implementation used by EDK2 (which does not
pack the array), which means this code is currently broken on 64-bit
implementations. Then, there is the issue of the capsule_addr member,
which is described by the spec as follows:

"""
The EFI System Table entry must point to an array of capsules that
contain the same CapsuleGuid value.
"""

This is open to interpretation, but an 'array of capsules' is not the
same as an 'array of pointers to capsules'.

I have reminded the USWG again that this needs to be clarified.

For more info, please refer to
https://lists.01.org/pipermail/edk2-devel/2017-March/008141.html

Regards,
Ard.
