From: okaya@codeaurora.org
Subject: Re: [PATCH v3] efifb: avoid reconfiguration of BAR that covers the
 framebuffer
Date: Thu, 30 Mar 2017 07:42:12 -0400
Message-ID: <0c8ba1ac389560358458c10915d85526@codeaurora.org>
References: <1490196629-28088-1-git-send-email-ard.biesheuvel@linaro.org>
 <20170322193111.GA8190@wunner.de>
 <CAKv+Gu_X-SEnz7h9J8boqqjOQGHQawwdSAq4haH-OGu8zdfNfA@mail.gmail.com>
 <20170323084819.GA23281@h08.hostsharing.net>
 <CAKv+Gu93eJ-js3g7M6Jdm6XGMaWMswFmzBG2qNT4rn+3=1+EyA@mail.gmail.com>
 <20170323105727.GA2441@red-moon>
 <466dcd2b-a781-2fe7-6ef0-5a3767c793e0@codeaurora.org>
 <CAKv+Gu9LbwpnJNi1OL25MWvYPxEOfKRHcs2jA2121BPaQWPzow@mail.gmail.com>
 <27f50de3-721e-e8ec-00c8-b7a9d3cff0d6@codeaurora.org>
 <CAKv+Gu-qRg8-YRCairppKrEfeLcW+OwVF8qZHp7vxXJA_AwPOw@mail.gmail.com>
 <20170330100524.GA22801@red-moon>
 <CAKv+Gu-ff98HrPK3f+E8soGJUXaaMxPLs2AuJ+rvXd0HWX-jXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu-ff98HrPK3f+E8soGJUXaaMxPLs2AuJ+rvXd0HWX-jXw@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Lukas Wunner <lukas@wunner.de>, linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Peter Jones <pjones@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Hanjun Guo <hanjun.guo@linaro.org>, Heyi Guo <heyi.guo@linaro.org>, linux-pci <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>
List-Id: linux-efi@vger.kernel.org

On 2017-03-30 06:09, Ard Biesheuvel wrote:
> On 30 March 2017 at 11:05, Lorenzo Pieralisi 
> <lorenzo.pieralisi@arm.com> wrote:
>> On Thu, Mar 30, 2017 at 09:46:39AM +0100, Ard Biesheuvel wrote:
>> 
>> [...]
>> 
>>> > I'm asking why we don't fix the actual problem in PCIe ARM64 adaptation instead
>>> > of working around it by quirks.
>>> >
>>> > I don't see any reason why ACPI ARM64 should carry the burden of legacy systems.
>>> >
>>> > Legacy only applies to DT based systems.
>>> >
>>> 
>>> I fully agree with this point: ACPI implies firmware, and so we 
>>> should
>>> be able to rely on firmware to have initialized the PCIe subsystem by
>>> the time the kernel gets to access it.
>> 
>> https://lkml.org/lkml/2016/3/3/458
>> 
> 
> I don't think the fact that at least one system existed over a year
> ago whose UEFI assigned resources incorrectly should prevent us from
> being normative in this case.

My suggestion is to try to reuse the resources if possible. Otherwise, 
reassign the resources.

There were implementation problems by the time you proposed your patch 
and it was delaying progess. That was my objection.

Now that base pci support is in and everybody is  somewhat happy, let's 
figure out the bugs and get this done.

I am ready to test/debug.
