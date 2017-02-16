From: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 0/2] efi: Enhance capsule loader to support signed Quark
 images
Date: Thu, 16 Feb 2017 08:29:21 +0100
Message-ID: <b95b71b7-6b5f-f9cc-79e4-3600e9a3f7e5@siemens.com>
References: <cover.1487182480.git.jan.kiszka@siemens.com>
 <CAHp75VeVZo8f_aXZ=R8Y+++RSQeT=tFZmL6NNfekKJTkJc-nZA@mail.gmail.com>
 <1bf3c9d8-56aa-818b-350f-deb62ad14e08@siemens.com>
 <4014c5e6-b5a0-7552-166f-a42992532c09@siemens.com>
 <F54AEECA5E2B9541821D670476DAE19C5DE533B3@PGSMSX102.gar.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <F54AEECA5E2B9541821D670476DAE19C5DE533B3-j2khPEwRog0FyVwBAnZdSLfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>, Sascha Weisenberger <sascha.weisenberger-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, Daniel Wagner <daniel.wagner-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 2017-02-16 04:00, Kweh, Hock Leong wrote:
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

This is ... [swallowing down a lengthy rant about Quark upstreaming]
unfortunate given that Intel hands out firmware and BSPs to their
customers without further explanations on this "minor detail".

I have no idea what other integrators of the X102x did with that, but my
customer has now thousands and thousands of devices in the field with
firmware that works exactly this way. Only for that feature, we will now
have to provide a non-upstream kernel in order to keep the installed
devices updatable. Or create and maintain a different mechanism. Beautiful.

> 
> The proper implementation may require to work with UEFI community
> to expand its capsule spec to support signed binary. 
> 

Are you working on this? How is this solved on other platforms that
require signatures? No one tried that yet? In any case, this sounds like
a lengthy, way too late considered process that will not solve our issue
in the foreseeable future.

Don't get me wrong, I'm not intending to push this into the kernel
because "What the heck?!" was my first reaction as well once I found out
how this update interface is actually working. But maybe you can bring
this topic up on your side as well so that we come to an upstreamable
solution in all affected projects.

Thanks,
Jan

PS: @Daniel, another example for your presentation. ;)

-- 
Siemens AG, Corporate Technology, CT RDA ITP SES-DE
Corporate Competence Center Embedded Linux
