From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3] efifb: avoid reconfiguration of BAR that covers the framebuffer
Date: Sun, 2 Apr 2017 16:16:27 +0100
Message-ID: <CAKv+Gu8x0rQUnTUorknW-mW9LFgrxFYsXyy4LU_w9JbA-m_sjA@mail.gmail.com>
References: <1490196629-28088-1-git-send-email-ard.biesheuvel@linaro.org>
 <20170322193111.GA8190@wunner.de> <CAKv+Gu_X-SEnz7h9J8boqqjOQGHQawwdSAq4haH-OGu8zdfNfA@mail.gmail.com>
 <20170323084819.GA23281@h08.hostsharing.net> <CAKv+Gu93eJ-js3g7M6Jdm6XGMaWMswFmzBG2qNT4rn+3=1+EyA@mail.gmail.com>
 <20170323105727.GA2441@red-moon> <466dcd2b-a781-2fe7-6ef0-5a3767c793e0@codeaurora.org>
 <CAKv+Gu9LbwpnJNi1OL25MWvYPxEOfKRHcs2jA2121BPaQWPzow@mail.gmail.com>
 <27f50de3-721e-e8ec-00c8-b7a9d3cff0d6@codeaurora.org> <CAKv+Gu-qRg8-YRCairppKrEfeLcW+OwVF8qZHp7vxXJA_AwPOw@mail.gmail.com>
 <20170330100524.GA22801@red-moon> <CAKv+Gu-ff98HrPK3f+E8soGJUXaaMxPLs2AuJ+rvXd0HWX-jXw@mail.gmail.com>
 <CAKv+Gu8YjySTDMgsrtGqEPMOtVhHc8gvTHZ4C5Ga8OTYdC9R3A@mail.gmail.com> <ae87ae28-f50d-095f-576e-f3fd7f96dea2@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ae87ae28-f50d-095f-576e-f3fd7f96dea2-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sinan Kaya <okaya-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hanjun Guo <hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Heyi Guo <heyi.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-pci <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 30 March 2017 at 14:50, Sinan Kaya <okaya-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org> wrote:
> On 3/30/2017 9:38 AM, Ard Biesheuvel wrote:
>> On 30 March 2017 at 11:09, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>>> On 30 March 2017 at 11:05, Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org> wrote:
>>>> On Thu, Mar 30, 2017 at 09:46:39AM +0100, Ard Biesheuvel wrote:
>>>>
>>>> [...]
>>>>
>>>>>> I'm asking why we don't fix the actual problem in PCIe ARM64 adaptation instead
>>>>>> of working around it by quirks.
>>>>>>
>>>>>> I don't see any reason why ACPI ARM64 should carry the burden of legacy systems.
>>>>>>
>>>>>> Legacy only applies to DT based systems.
>>>>>>
>>>>>
>>>>> I fully agree with this point: ACPI implies firmware, and so we should
>>>>> be able to rely on firmware to have initialized the PCIe subsystem by
>>>>> the time the kernel gets to access it.
>>>>
>>>> https://lkml.org/lkml/2016/3/3/458
>>>>
>>>
>>> I don't think the fact that at least one system existed over a year
>>> ago whose UEFI assigned resources incorrectly should prevent us from
>>> being normative in this case.
>>
>> In any case, given that EFIFB is enabled by default on some distros,
>> and the fact that DT boot is affected as well, I should get this patch
>> in to prevent serious potential issues that could arise when someone
>> with a graphical UEFI stack updates to such a new kernel.
>>
>> So I think we are in agreement that this is needed on both ARM and
>> arm64, since their PCI configuration is usually not preserved. The
>> open question is whether there is any harm in enabling it for x86 as
>> well.
>>
>
> Agreed, the other issue is about compatibility with UEFI and future
> proofing Linux for other potential issues like hotplug reservation.
>

OK, given the lack of feedback regarding the suitability of this patch
for x86, I am going to rework it as a ARM/arm64 only patch, and queue
it as a fix for v4.11. This way, we can backport it to stable (which
is arguably appropriate, given that upgrading to a EFIFB enabled
kernel may cause severe breakage for existing systems that implement
the GOP protocol), and easily change the patch to apply to x86 going
forwards, by removing the #ifdefs

-- 
Ard.
