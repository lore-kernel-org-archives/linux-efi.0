From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V2 1/2] efi: move ARM CPER code to new file
Date: Mon, 11 Dec 2017 23:17:05 +0000
Message-ID: <CAKv+Gu9=e+rMPrSs+F4e3=RiNzjsOUc7-W_1EOkEUJ5DqdbUAQ@mail.gmail.com>
References: <1512674727-25770-1-git-send-email-tbaicar@codeaurora.org>
 <1512674727-25770-2-git-send-email-tbaicar@codeaurora.org>
 <CAKv+Gu_kM1NLWcOtQSEwEVnncBbrgJ5MP4VrYQVHBoCwSf_FRQ@mail.gmail.com>
 <972fe421-696b-cd26-9145-20081fb733c9@codeaurora.org> <1bcd0462-5df9-fd90-c487-4e8958a9e27d@codeaurora.org>
 <CAKv+Gu_VWjw6E0GHc1edLAc-NVjy6CtDU2fSR5o7-Q+W40Fbug@mail.gmail.com> <6c9da127-f210-3f14-32b7-c38ad5e0e1d6@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6c9da127-f210-3f14-32b7-c38ad5e0e1d6-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 11 December 2017 at 21:29, Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org> wrote:
> On 12/11/2017 4:09 PM, Ard Biesheuvel wrote:
>>
>> On 11 December 2017 at 21:06, Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org> wrot=
e:
>>>
>>> On 12/7/2017 3:07 PM, Tyler Baicar wrote:
>>>>
>>>> On 12/7/2017 2:38 PM, Ard Biesheuvel wrote:
>>>>>>
>>>>>> diff --git a/include/linux/cper.h b/include/linux/cper.h
>>>>>> index 723e952..0a2d5c5 100644
>>>>>> --- a/include/linux/cper.h
>>>>>> +++ b/include/linux/cper.h
>>>>>> @@ -494,6 +494,13 @@ struct cper_sec_pcie {
>>>>>>    /* Reset to default packing */
>>>>>>    #pragma pack()
>>>>>>
>>>>>> +static const char * const proc_error_type_strs[] =3D {
>>>>>> +       "cache error",
>>>>>> +       "TLB error",
>>>>>> +       "bus error",
>>>>>> +       "micro-architectural error",
>>>>>> +};
>>>>>> +
>>>>>
>>>>> Could we keep this in cper.c, and replace this with
>>>>>
>>>>> extern const char * const cper_proc_error_type_strs[];
>>>>>
>>>>> instead? I'm not too keen on putting definitions (other than static
>>>>> inline functions) in header files.
>>>>>
>>>> Yes, I will make this change.
>>>
>>> Hello Ard,
>>>
>>> This actually won't work because of the ARRAY_SIZE use. If this
>>> definition
>>> is in cper.c, then cper-arm.c won't be able to use ARRAY_SIZE even with
>>> the
>>> extern statement in cper.h.
>>>
>>> drivers/firmware/efi/cper-arm.c: In function =E2=80=98cper_print_proc_a=
rm=E2=80=99:
>>> ./include/linux/kernel.h:71:32: error: invalid application of =E2=80=98=
sizeof=E2=80=99 to
>>> incomplete type =E2=80=98const char * const[]=E2=80=99
>>>   #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) +
>>> __must_be_array(arr))
>>>                                  ^
>>> drivers/firmware/efi/cper-arm.c:103:21: note: in expansion of macro
>>> =E2=80=98ARRAY_SIZE=E2=80=99
>>>      err_info->type < ARRAY_SIZE(cper_proc_error_type_strs) ?
>>>                       ^~~~~~~~~~
>>>
>>> Any other suggestions?
>>>
>> Add '4' between the square brackets?
>
> That works if you'd prefer it that way.
>

Yes please
