From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: efisubsys_init takes more than a few milliseconds
Date: Thu, 23 Aug 2018 16:50:45 +0200
Message-ID: <CAKv+Gu_8kUV_EkeLfm986TPggQZKo40xgBS_1ab3eycDAfYzfA@mail.gmail.com>
References: <305249de-7892-fca4-b462-a493aa65d177@molgen.mpg.de>
 <CAKv+Gu84h2+zofb4v-QrVE7rqCrGC7MaHEw7tB+z2J8DczjoKw@mail.gmail.com>
 <f94af2ed-3492-4db5-c1bc-30c4c1855947@molgen.mpg.de> <676c44ce-6909-f002-4ea3-0c6f68b6b781@molgen.mpg.de>
 <13ebec39-6656-ee60-58be-afe56adfde7f@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <13ebec39-6656-ee60-58be-afe56adfde7f@molgen.mpg.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Menzel <pmenzel+linux-efi@molgen.mpg.de>
Cc: linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 22 August 2018 at 15:18, Paul Menzel <pmenzel+linux-efi@molgen.mpg.de> w=
rote:
> Dear Ard,
>
>
> On 03/25/18 17:21, Paul Menzel wrote:
>
>> On 03/25/2018 09:41 AM, Paul Menzel wrote:
>>
>>> On 03/24/2018 11:35 PM, Ard Biesheuvel wrote:
>>>
>>>> On 24 March 2018 at 22:10, Paul Menzel wrote:
>>
>>>>> According to `initcall_debug`, `efisubsys_init` takes more than a few
>>>>> milliseconds to execute on a Dell XPS 13 9370 (Intel(R) Core(TM) i7-8=
550U CPU @ 1.80GHz).
>>>>>
>>>>>> ```
>>>>>> [=E2=80=A6]
>>>>>> [ 0.144474] calling  efisubsys_init+0x0/0x2cf @ 1
>>>>>> [ 0.144474] Registered efivars operations
>>>>>> [ 0.173690] initcall efisubsys_init+0x0/0x2cf returned 0 after 27343=
 usecs
>>>>>> [=E2=80=A6]
>>>>>> ```
>>>>>
>>>>>
>>>>> To get a vanilla Linux kernel to boot in well under one second, it=E2=
=80=99d be nice
>>>>> if the time could be improved. Do you know, why it takes so long?
>>>>>
>>>>> According to `bootgraph.py` from pm-graph [1][2] it takes even a litt=
le
>>>>> longer.
>>>>>
>>>>>> efisubsys_init: start=3D690.841, end=3D720.493, length(w/o overhead)=
=3D31.250
>>>>>> ms, return=3D0
>>>>>
>>>>> There are several dozen calls to `virt_efi_get_next_variable()` all b=
ut one
>>>>> taking around 0.335 ms. This path needs to be optimized. Is that poss=
ible?
>>>>
>>>> That depends. These are firmware calls, so to make these calls faster,
>>>> you need to modify the firmware, not the kernel.
>>>
>>> Yeah, unfortunately, no free firmware runs on this laptop, and Dell doe=
sn=E2=80=99t respond to these kind of reports, as they think, it=E2=80=99s =
not important.
>>>
>>>> We may be able to make more intrusive changes to get rid of this
>>>> delay, e.g., spin up a special kernel thread, but I'd have to check in
>>>> more detail.
>>>
>>> That=E2=80=99d be great.
>
> On the MSI B350M MORTAR (MS-7A37) it takes even longer, almost 50 ms.
>
> ```
> [    0.204009] calling  efisubsys_init+0x0/0x30a @ 1
> [    0.204009] Registered efivars operations
> [    0.252262] initcall efisubsys_init+0x0/0x30a returned 0 after 46875 u=
secs
> ```
>
> If a solution could be found to move this out of the hotpath, that=E2=80=
=99d be great.
> But I am not sure, if threads can be used that early.
>

Could you narrow this down? Which call in efisubsys_init() is taking
up all this time?
