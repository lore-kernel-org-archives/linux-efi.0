From: Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
Subject: Re: [PATCH 0/2] efi: Enhance capsule loader to support signed Quark
 images
Date: Fri, 17 Feb 2017 00:53:46 +0000
Message-ID: <f4f63644-e099-b192-5337-15c07d761fb4@nexus-software.ie>
References: <cover.1487182480.git.jan.kiszka@siemens.com>
 <CAHp75VeVZo8f_aXZ=R8Y+++RSQeT=tFZmL6NNfekKJTkJc-nZA@mail.gmail.com>
 <1bf3c9d8-56aa-818b-350f-deb62ad14e08@siemens.com>
 <4014c5e6-b5a0-7552-166f-a42992532c09@siemens.com>
 <F54AEECA5E2B9541821D670476DAE19C5DE533B3@PGSMSX102.gar.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <F54AEECA5E2B9541821D670476DAE19C5DE533B3-j2khPEwRog0FyVwBAnZdSLfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org



On 16/02/17 03:00, Kweh, Hock Leong wrote:
>> -----Original Message-----
>> From: Jan Kiszka [mailto:jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org]
>> Sent: Thursday, February 16, 2017 3:00 AM
>> To: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>; Ard Biesheuvel
>> <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>; linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Linux Kernel Mailing
>> List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>; Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>; Kweh,
>> Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Bryan O'Donoghue
>> <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
>> Subject: Re: [PATCH 0/2] efi: Enhance capsule loader to support signed Quark
>> images
>>
>> On 2017-02-15 19:50, Jan Kiszka wrote:
>>> On 2017-02-15 19:46, Andy Shevchenko wrote:
>>>> On Wed, Feb 15, 2017 at 8:14 PM, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
>> wrote:
>>>>> See patch 2 for the background.
>>>>>
>>>>> Series has been tested on the Galileo Gen2, to exclude regressions,
>>>>> with a firmware.cap without security header and the SIMATIC IOT2040
>>>>> which requires the header because of its mandatory secure boot.
>>>>
>>>> Briefly looking to the code it looks like a real hack.
>>>> Sorry, but it would be carefully (re-)designed.
>>>
>>> The interface that the firmware provides us? That should have been
>>> done differently, I agree, but I'm not too much into those firmware
>>> details, specifically when it comes to signatures.
>>>
>>> The Linux code was designed around that suboptimal situation. If there
>>> are better ideas, I'm all ears.
>>>
>>
>> Expanding CC's as requested by Andy.
>>
>> Jan
>>
>
> Hi Jan,
>
> While I upstreaming the capsule loader patches, I did work with maintainer
> Matt and look into this security header created for Quark. Eventually both
> of us agreed that this will not be upstream to mainline as it is really a Quark
> specific implementation.

What's the logic of that ?

It should be possible to provide a hook (or a custom function).

>
> The proper implementation may require to work with UEFI community
> to expand its capsule spec to support signed binary.

Are you volunteering to do that with - getting the CSH into the UEFI spec ?

If not then we should have a method to load/ignore a capsule including 
the CSH, if so then we should have a realistic timeline laid out for 
getting that spec work done.

Hint: I don't believe integrating the CSH into the UEFI standard will 
happen...

>
>
> Regards,
> Wilson
>
