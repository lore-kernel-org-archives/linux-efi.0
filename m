From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 0/2] Add EFI capsule pstore backend support
Date: Mon, 26 Jun 2017 15:07:22 +0000
Message-ID: <CAKv+Gu-tEYgK3zPYKf_ekwcfpnGFoYFF6om9PBjWgp0wp=KAuw@mail.gmail.com>
References: <20170622163434.95704-1-qiuxu.zhuo@intel.com> <CAGXu5jLzd8PdH3mGS_+kYA3-nZwmJCYkeQXH2crJr5LqYGoHaQ@mail.gmail.com>
 <CAKv+Gu_HDjfRUCrJfmuvqD6t=+=a_QjBdj4FyGpH3Q5cMyfGwA@mail.gmail.com>
 <CAKv+Gu-j0hc6o6LLPPESbpmhpGY5=qX=fsD6B15on=VGx51qog@mail.gmail.com> <E6AF1AFDEA62A94A97508F458CBDD47F6F5A5C24@SHSMSX101.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E6AF1AFDEA62A94A97508F458CBDD47F6F5A5C24-0J0gbvR4kThpB2pF5aRoyrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Zhuo, Qiuxu" <qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 26 June 2017 at 04:09, Zhuo, Qiuxu <qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> From: Ard Biesheuvel [mailto:ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org]
>>
>> Actually, no, The issue I raised the last time around was not addressed =
anywhere, and is not even mentioned in the commit log.
>>
>> The problem is that there is an ambiguity in the implementation of the c=
onfiguration table entries that represent capsule with the EFI_CAPSULE_PERS=
IST_ACROSS_RESET and EFI_CAPSULE_POPULATE_SYSTEM_TABLE flags set.
>>
>> First of all, there is the padding issue:
>>
>> typedef struct {
>>       u32 capsule_array_number;
>>       void *capsule_addr[];
>> } __packed efi_capsule_table_t;
>>
>> This deviates from the implementation used by EDK2 (which does not pack =
the array), which means this code is currently broken on 64-bit implementat=
ions.
>> Then, there is the issue of the capsule_addr member, > which is describe=
d by the spec as follows:
>>
>> """
>> The EFI System Table entry must point to an array of capsules that conta=
in the same CapsuleGuid value.
>> """
>>
>> This is open to interpretation, but an 'array of capsules' is not the sa=
me as an 'array of pointers to capsules'.
>>
>> I have reminded the USWG again that this needs to be clarified.
>>
>
> It looks like that my test BIOS on Intel Kabylake board interprets it *po=
inter" and pack the array, so my patch can work on that board.

Are you running 64-bit firmware on this board? Because the EDK2 side
lacks the 'packed' attribute, which means there is 4 bytes of padding
after the first member of EFI_CAPSULE_TABLE.

> Yes, the spec is ambiguous that  the description[1] in spec treats it as =
*pointer", and description[2] treats it as *capsule* (header + data ???)
> [1] "Firmware that processes a capsule that has the CAPSULE_FLAGS_POPULAT=
E_SYSTEM_TABLE Flag set in
> its header will coalesce the contents of the capsule from the ScatterGath=
erList into a contiguous
> buffer and must then place a *pointer* to this coalesced capsule in the E=
FI System Table after the
> system has been reset. Agents searching for this capsule will look in the=
 EFI_CONFIGURATION_TABLE
> and search for the capsule=E2=80=99s GUID and associated *pointer* to ret=
rieve the data after the reset."
> [2] " The EFI System Table entry must point to an array of *capsules* tha=
t contain the same CapsuleGuid value."
>
> I tend to [1] :-), and it seems to me that [2] has a disadvantage that it=
 must have a contiguous physical memory large enough for all capsules.
>

Ah yes, I missed that bit before. So yes, it probably makes most sense
to keep your definition, and update the EDK2 side so it works on
64-bit as well.

>> https://lists.01.org/pipermail/edk2-devel/2017-March/008141.html
>> +      CapsuleTable->CapsuleArraySize =3D Size - sizeof(EFI_CAPSULE_TABL=
E);
>    I think 'CapsuleTable->CapsuleArraySize =3D Size - sizeof (U32)' prese=
nts the size of capsule array.
>
>> +      for (Index =3D 0; Index < CapsuleNumber; Index++) {
>> +        CopyMem(&CapsuleTable->Capsule[Index], CapsulePtrCache[Index], =
sizeof(EFI_CAPSULE_TABLE));
>> +      }
>  Here it only copies the capsule headers (EFI_CAPSULE_TABLE) to ' Capsule=
Table->Capsule[Index]'.
>  Should it also copy capsule data for each capsule here?  Otherwise OS ca=
n only get the capsule header I think.
>
> Ard if you get clarification (capsule pointer or capsule header+data in E=
FI System Table entry) from USWG, would you please notify me and I can upda=
te my patch accordingly.
> Thanks!
>

I hope we can settle this by the end of this week, and if the
clarification aligns with your definition, I will queue the patches as
they are.

Thanks,
Ard.
