From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 0/2] efi: Enhance capsule loader to support signed Quark images
Date: Sat, 18 Feb 2017 21:48:27 +0000
Message-ID: <CAKv+Gu_2edBA++6ywE4FE2NSbkCWjEULPmriS1iBifsRCgA+OA@mail.gmail.com>
References: <cover.1487182480.git.jan.kiszka@siemens.com> <CAHp75VeVZo8f_aXZ=R8Y+++RSQeT=tFZmL6NNfekKJTkJc-nZA@mail.gmail.com>
 <1bf3c9d8-56aa-818b-350f-deb62ad14e08@siemens.com> <4014c5e6-b5a0-7552-166f-a42992532c09@siemens.com>
 <F54AEECA5E2B9541821D670476DAE19C5DE533B3@PGSMSX102.gar.corp.intel.com> <b95b71b7-6b5f-f9cc-79e4-3600e9a3f7e5@siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b95b71b7-6b5f-f9cc-79e4-3600e9a3f7e5@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>, Andy Shevchenko <andy.shevchenko@gmail.com>, Matt Fleming <matt@codeblueprint.co.uk>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Bryan O'Donoghue <pure.logic@nexus-software.ie>, Sascha Weisenberger <sascha.weisenberger@siemens.com>, Daniel Wagner <daniel.wagner@siemens.com>
List-Id: linux-efi@vger.kernel.org

On 16 February 2017 at 07:29, Jan Kiszka <jan.kiszka@siemens.com> wrote:
> On 2017-02-16 04:00, Kweh, Hock Leong wrote:
>>> -----Original Message-----
>>> From: Jan Kiszka [mailto:jan.kiszka@siemens.com]
>>> Sent: Thursday, February 16, 2017 3:00 AM
>>> To: Andy Shevchenko <andy.shevchenko@gmail.com>
>>> Cc: Matt Fleming <matt@codeblueprint.co.uk>; Ard Biesheuvel
>>> <ard.biesheuvel@linaro.org>; linux-efi@vger.kernel.org; Linux Kernel Mailing
>>> List <linux-kernel@vger.kernel.org>; Borislav Petkov <bp@alien8.de>; Kweh,
>>> Hock Leong <hock.leong.kweh@intel.com>; Bryan O'Donoghue
>>> <pure.logic@nexus-software.ie>
>>> Subject: Re: [PATCH 0/2] efi: Enhance capsule loader to support signed Quark
>>> images
>>>
>>> On 2017-02-15 19:50, Jan Kiszka wrote:
>>>> On 2017-02-15 19:46, Andy Shevchenko wrote:
>>>>> On Wed, Feb 15, 2017 at 8:14 PM, Jan Kiszka <jan.kiszka@siemens.com>
>>> wrote:
>>>>>> See patch 2 for the background.
>>>>>>
>>>>>> Series has been tested on the Galileo Gen2, to exclude regressions,
>>>>>> with a firmware.cap without security header and the SIMATIC IOT2040
>>>>>> which requires the header because of its mandatory secure boot.
>>>>>
>>>>> Briefly looking to the code it looks like a real hack.
>>>>> Sorry, but it would be carefully (re-)designed.
>>>>
>>>> The interface that the firmware provides us? That should have been
>>>> done differently, I agree, but I'm not too much into those firmware
>>>> details, specifically when it comes to signatures.
>>>>
>>>> The Linux code was designed around that suboptimal situation. If there
>>>> are better ideas, I'm all ears.
>>>>
>>>
>>> Expanding CC's as requested by Andy.
>>>
>>> Jan
>>>
>>
>> Hi Jan,
>>
>> While I upstreaming the capsule loader patches, I did work with maintainer
>> Matt and look into this security header created for Quark. Eventually both
>> of us agreed that this will not be upstream to mainline as it is really a Quark
>> specific implementation.
>
> This is ... [swallowing down a lengthy rant about Quark upstreaming]
> unfortunate given that Intel hands out firmware and BSPs to their
> customers without further explanations on this "minor detail".
>
> I have no idea what other integrators of the X102x did with that, but my
> customer has now thousands and thousands of devices in the field with
> firmware that works exactly this way. Only for that feature, we will now
> have to provide a non-upstream kernel in order to keep the installed
> devices updatable. Or create and maintain a different mechanism. Beautiful.
>

OK, so you shipped thousands and thousands of devices with mainline
kernels and never tested the capsule update feature, which now turns
out to require modifications to support the non-UEFI compliant
firmware on these devices.

I'm sorry, but that puts it firmly in the 'not our problem' category,
simply because I refuse to believe that you would seriously consider
performing this kind of firmware update on that many devices in the
field if you never tested it in development.

So while I fully agree that
a) it is quite unfortunate that Intel, which has such a dominant
presence in all aspects of UEFI and PI standardization, ships a
non-compliant BSP, and
b) it is useful to be able to sign capsules,
I think we should push back on random, unstandardized signature headers.

The argument that Quark is the only working implementation of capsule
updates, and so we should support it, does not hold. First of all,
arm64 servers are shipping with working capsule update based on the
current kernel implementation, but what is currently shipping is not
really the point for mainline imo, but what is intended to be shipped
with the next kernel release.

I would not object strongly to having conditionally compiled code in
mainline that adds support for this, but bodging the default code path
like this for a Quark quirk is out of the question imo.

Thanks,
Ard.



>>
>> The proper implementation may require to work with UEFI community
>> to expand its capsule spec to support signed binary.
>>
>
> Are you working on this? How is this solved on other platforms that
> require signatures? No one tried that yet? In any case, this sounds like
> a lengthy, way too late considered process that will not solve our issue
> in the foreseeable future.
>
> Don't get me wrong, I'm not intending to push this into the kernel
> because "What the heck?!" was my first reaction as well once I found out
> how this update interface is actually working. But maybe you can bring
> this topic up on your side as well so that we come to an upstreamable
> solution in all affected projects.
>
> Thanks,
> Jan
>
> PS: @Daniel, another example for your presentation. ;)
>
> --
> Siemens AG, Corporate Technology, CT RDA ITP SES-DE
> Corporate Competence Center Embedded Linux
