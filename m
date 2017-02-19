From: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 0/2] efi: Enhance capsule loader to support signed Quark
 images
Date: Sun, 19 Feb 2017 05:33:31 -0800
Message-ID: <3641f43d-ecfd-03dd-9e5d-ca32d587d318@siemens.com>
References: <cover.1487182480.git.jan.kiszka@siemens.com>
 <CAHp75VeVZo8f_aXZ=R8Y+++RSQeT=tFZmL6NNfekKJTkJc-nZA@mail.gmail.com>
 <1bf3c9d8-56aa-818b-350f-deb62ad14e08@siemens.com>
 <4014c5e6-b5a0-7552-166f-a42992532c09@siemens.com>
 <F54AEECA5E2B9541821D670476DAE19C5DE533B3@PGSMSX102.gar.corp.intel.com>
 <b95b71b7-6b5f-f9cc-79e4-3600e9a3f7e5@siemens.com>
 <CAKv+Gu_2edBA++6ywE4FE2NSbkCWjEULPmriS1iBifsRCgA+OA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu_2edBA++6ywE4FE2NSbkCWjEULPmriS1iBifsRCgA+OA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>, Sascha Weisenberger <sascha.weisenberger-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, Daniel Wagner <daniel.wagner-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 2017-02-18 13:48, Ard Biesheuvel wrote:
> On 16 February 2017 at 07:29, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org> wrote:
>> On 2017-02-16 04:00, Kweh, Hock Leong wrote:
>>>> -----Original Message-----
>>>> From: Jan Kiszka [mailto:jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org]
>>>> Sent: Thursday, February 16, 2017 3:00 AM
>>>> To: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>>> Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>; Ard Biesheuvel
>>>> <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>; linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Linux Kernel Mailing
>>>> List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>; Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>; Kweh,
>>>> Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Bryan O'Donoghue
>>>> <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
>>>> Subject: Re: [PATCH 0/2] efi: Enhance capsule loader to support signed Quark
>>>> images
>>>>
>>>> On 2017-02-15 19:50, Jan Kiszka wrote:
>>>>> On 2017-02-15 19:46, Andy Shevchenko wrote:
>>>>>> On Wed, Feb 15, 2017 at 8:14 PM, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
>>>> wrote:
>>>>>>> See patch 2 for the background.
>>>>>>>
>>>>>>> Series has been tested on the Galileo Gen2, to exclude regressions,
>>>>>>> with a firmware.cap without security header and the SIMATIC IOT2040
>>>>>>> which requires the header because of its mandatory secure boot.
>>>>>>
>>>>>> Briefly looking to the code it looks like a real hack.
>>>>>> Sorry, but it would be carefully (re-)designed.
>>>>>
>>>>> The interface that the firmware provides us? That should have been
>>>>> done differently, I agree, but I'm not too much into those firmware
>>>>> details, specifically when it comes to signatures.
>>>>>
>>>>> The Linux code was designed around that suboptimal situation. If there
>>>>> are better ideas, I'm all ears.
>>>>>
>>>>
>>>> Expanding CC's as requested by Andy.
>>>>
>>>> Jan
>>>>
>>>
>>> Hi Jan,
>>>
>>> While I upstreaming the capsule loader patches, I did work with maintainer
>>> Matt and look into this security header created for Quark. Eventually both
>>> of us agreed that this will not be upstream to mainline as it is really a Quark
>>> specific implementation.
>>
>> This is ... [swallowing down a lengthy rant about Quark upstreaming]
>> unfortunate given that Intel hands out firmware and BSPs to their
>> customers without further explanations on this "minor detail".
>>
>> I have no idea what other integrators of the X102x did with that, but my
>> customer has now thousands and thousands of devices in the field with
>> firmware that works exactly this way. Only for that feature, we will now
>> have to provide a non-upstream kernel in order to keep the installed
>> devices updatable. Or create and maintain a different mechanism. Beautiful.
>>
> 
> OK, so you shipped thousands and thousands of devices with mainline
> kernels and never tested the capsule update feature, which now turns
> out to require modifications to support the non-UEFI compliant
> firmware on these devices.

We are shipping an open platform. The users can download a reference
image with Yocto-Linux that comes with a Yocto kernel plus some enabling
patches. One of them is currently a forward-port of the original Intel
capsule loader driver that does a similar thing like these patches and
therefore works fine (of course firmware update has been tested before
the release).

But in order to overcome the dependencies on Yocto kernels as well our
own patch queue, we are in the process of upstreaming necessary changes
(and upstream cleanups as well, some are already merged). In the end,
our users should have the possibility to chose mainline or Yocto or some
other kernel flavour without having the need for additional BSP patches.
That will ensure long-term support for the hardware, software-wise.
Users already asked us if they will eventually be stuck with a patch
queue and, thus, an outdated kernel like it is a sad standard in this
domain. But that is not our plan.

Yes, in an ideal world, this discussion had happened earlier and
prevented at least our deployment of the non-standard firmware. But the
world is not always working ideally.

> 
> I'm sorry, but that puts it firmly in the 'not our problem' category,
> simply because I refuse to believe that you would seriously consider
> performing this kind of firmware update on that many devices in the
> field if you never tested it in development.

I would recommend reading my email completely (see below) to understand
who I was targeting.

> 
> So while I fully agree that
> a) it is quite unfortunate that Intel, which has such a dominant
> presence in all aspects of UEFI and PI standardization, ships a
> non-compliant BSP, and
> b) it is useful to be able to sign capsules,
> I think we should push back on random, unstandardized signature headers.
> 
> The argument that Quark is the only working implementation of capsule
> updates, and so we should support it, does not hold. First of all,
> arm64 servers are shipping with working capsule update based on the
> current kernel implementation, but what is currently shipping is not
> really the point for mainline imo, but what is intended to be shipped
> with the next kernel release.
> 
> I would not object strongly to having conditionally compiled code in
> mainline that adds support for this, but bodging the default code path
> like this for a Quark quirk is out of the question imo.

I'm open for any consensus that avoids bending mainline too much and
still helps us (and maybe also other Quark X1020 integrators) getting
rid of additional patches.

Thanks,
Jan

> 
> Thanks,
> Ard.
> 
> 
> 
>>>
>>> The proper implementation may require to work with UEFI community
>>> to expand its capsule spec to support signed binary.
>>>
>>
>> Are you working on this? How is this solved on other platforms that
>> require signatures? No one tried that yet? In any case, this sounds like
>> a lengthy, way too late considered process that will not solve our issue
>> in the foreseeable future.
>>
>> Don't get me wrong, I'm not intending to push this into the kernel
>> because "What the heck?!" was my first reaction as well once I found out
>> how this update interface is actually working. But maybe you can bring
>> this topic up on your side as well so that we come to an upstreamable
>> solution in all affected projects.
>>
>> Thanks,
>> Jan
>>
>> PS: @Daniel, another example for your presentation. ;)
>>
>> --
>> Siemens AG, Corporate Technology, CT RDA ITP SES-DE
>> Corporate Competence Center Embedded Linux

-- 
Siemens AG, Corporate Technology, CT RDA ITP SES-DE
Corporate Competence Center Embedded Linux
