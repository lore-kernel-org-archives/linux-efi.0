From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v11 08/10] dt, numa: Add NUMA dt binding implementation.
Date: Tue, 1 Mar 2016 10:56:19 -0600
Message-ID: <CAL_JsqKASAdfM_s=G3Bd+cGrQz7f914FYFuL3r=sdhscGjx9SQ@mail.gmail.com>
References: <1455930799-5371-1-git-send-email-ddaney.cavm@gmail.com>
 <1455930799-5371-9-git-send-email-ddaney.cavm@gmail.com> <20160223193651.GA8491@rob-hp-laptop>
 <56CFA9CA.6090803@caviumnetworks.com> <20160226182734.GM29125@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160226182734.GM29125@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: David Daney <ddaney@caviumnetworks.com>, David Daney <ddaney.cavm@gmail.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Frank Rowand <frowand.list@gmail.com>, Grant Likely <grant.likely@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Ganapatrao Kulkarni <gkulkarni@caviumnetworks.com>, Robert Richter <rrichter@cavium.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, David Daney <david.daney@cavium.com>
List-Id: linux-efi@vger.kernel.org

On Fri, Feb 26, 2016 at 12:27 PM, Will Deacon <will.deacon@arm.com> wrote:
> On Thu, Feb 25, 2016 at 05:26:34PM -0800, David Daney wrote:
>> On 02/23/2016 11:36 AM, Rob Herring wrote:
>> >On Fri, Feb 19, 2016 at 05:13:17PM -0800, David Daney wrote:
>> >>From: Ganapatrao Kulkarni <gkulkarni@caviumnetworks.com>
>> >>
>> >>ADD device tree node parsing for NUMA topology using device
>> >>"numa-node-id" property distance-map.
>> >
>> >I still want an adequate explanation why NUMA setup cannot be done with
>> >an unflattened tree. PowerPC manages to do that and should have a
>> >similar init flow being memblock based, so I would expect arm64 can too.
>>
>> Many things could be done.  Really, we want to know what *should* be done.
>>
>> In the context of the current arm64 memory initialization we (more or less)
>> do:
>>
>>  1) early_init_fdt_scan_reserved_mem();
>>  2) memory_present()
>>  3) sparse_init()
>>  4) other things
>>  5) unflatten_device_tree()
>>
>> We are already reading information out of the FDT at #1.
>>
>> This patch set adds a step between 1 and 2 where we read NUMA information
>> out of the FDT.
>>
>> Hypothetically, it might be possible to rewrite the arm64 setup code so that
>> the ordering was different, and the NUMA setup was done on the unflattened
>> tree, but that would certainly be a much more invasive patch.
>
> I just looked at what PPC get up to, and there's really not an obvious
> way we could do that on arm64. They run whole swathes of the kernel
> with the MMU off directly from head.S to parse the flattened tree and
> get memblock up really early. On arm64, the head.S environment is
> considerably more hostile, and I don't think we'd want to do that (not
> to mention the interaction with EFI stub).
>
> So I'm perfectly happy for this to operate on the flattened tree.

Of course you are. The code is not in your tree. I'm all for keeping
things out of /arch, but just want to understand what are the
dependencies which aren't clearly spelled out here.

Rob
