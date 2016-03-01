From: David Daney <ddaney@caviumnetworks.com>
Subject: Re: [PATCH v11 08/10] dt, numa: Add NUMA dt binding implementation.
Date: Tue, 1 Mar 2016 08:57:35 -0800
Message-ID: <56D5C9FF.8020500@caviumnetworks.com>
References: <1455930799-5371-1-git-send-email-ddaney.cavm@gmail.com> <1455930799-5371-9-git-send-email-ddaney.cavm@gmail.com> <20160223193651.GA8491@rob-hp-laptop> <56CFA9CA.6090803@caviumnetworks.com> <CAL_JsqLoTh_ZTUT26g4wz=6sofuRpFDCc_Aw+Oq66p8cGMp19g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAL_JsqLoTh_ZTUT26g4wz=6sofuRpFDCc_Aw+Oq66p8cGMp19g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Herring <robh@kernel.org>
Cc: David Daney <ddaney.cavm@gmail.com>, Will Deacon <will.deacon@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Frank Rowand <frowand.list@gmail.com>, Grant Likely <grant.likely@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Ganapatrao Kulkarni <gkulkarni@caviumnetworks.com>, Robert Richter <rrichter@cavium.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, David Daney <david.daney@cavium.com>
List-Id: linux-efi@vger.kernel.org

On 03/01/2016 08:47 AM, Rob Herring wrote:
> On Thu, Feb 25, 2016 at 7:26 PM, David Daney <ddaney@caviumnetworks.com> wrote:
>> On 02/23/2016 11:36 AM, Rob Herring wrote:
>>>
>>> On Fri, Feb 19, 2016 at 05:13:17PM -0800, David Daney wrote:
>>>>
>>>> From: Ganapatrao Kulkarni <gkulkarni@caviumnetworks.com>
>>>>
>>>> ADD device tree node parsing for NUMA topology using device
>>>> "numa-node-id" property distance-map.
>>>
>>>
>>> I still want an adequate explanation why NUMA setup cannot be done with
>>> an unflattened tree. PowerPC manages to do that and should have a
>>> similar init flow being memblock based, so I would expect arm64 can too.
>>
>>
>> Many things could be done.  Really, we want to know what *should* be done.
>>
>> In the context of the current arm64 memory initialization we (more or less)
>> do:
>>
>>   1) early_init_fdt_scan_reserved_mem();
>>   2) memory_present()
>>   3) sparse_init()
>>   4) other things
>>   5) unflatten_device_tree()
>>
>> We are already reading information out of the FDT at #1.
>>
>> This patch set adds a step between 1 and 2 where we read NUMA information
>> out of the FDT.
>
> The dependency on unflattening is that memblock is up and we can
> allocate a chunk from it. Isn't that dependency met by step 1

No.

> or is
> there a dependency on sparsemem (or something else)?

Will Deacon talked about this over here:

https://lkml.org/lkml/2016/2/26/782

I am happy to modify the patch set, but I don't want to get stuck as an 
intermediary between two opposing blocs.

David Daney
