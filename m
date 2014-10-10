From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v3] arm64/efi: efistub: jump to 'stext' directly, not
 through the header
Date: Fri, 10 Oct 2014 17:52:43 +0200
Message-ID: <CAKv+Gu-FiDmC2zJkNKDMet_pTDMKzysbhfaVCzu5ZGdDWt=Ocg@mail.gmail.com>
References: <1412777487-13636-1-git-send-email-ard.biesheuvel@linaro.org>
 <20141009172354.GA466@leverpostej>
 <CAKv+Gu-D812Rn32rm5wQJfSM+NzPXZWbxDcDkZ8mBzbi5RQJXQ@mail.gmail.com>
 <20141010104923.GD4076@leverpostej>
 <CAKv+Gu_mx3uWqnRESAjqz6MdUJqBSjgeMCdnpzKiRQ+1FxUjCQ@mail.gmail.com>
 <20141010121918.GA5294@leverpostej>
 <CAKv+Gu-Kk=hZ78T+_ePceTgb9m4KmvpLcYOwvxEWuUcT+ScK_Q@mail.gmail.com>
 <20141010130302.GC5294@leverpostej>
 <CAKv+Gu-OJ+byitcYSsajgEhgPOwP2ooF4Ro1QgJzXw1Z_VX1Ow@mail.gmail.com>
 <CAFECyb8+J0-NGR9Qd8wavUja+9pHq2UOUk1FJMrk3F3Aqc_-ig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CAFECyb8+J0-NGR9Qd8wavUja+9pHq2UOUk1FJMrk3F3Aqc_-ig@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Roy Franz <roy.franz@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Catalin Marinas <Catalin.Marinas@arm.com>, "matt.fleming@intel.com" <matt.fleming@intel.com>, "leif.lindholm@linaro.org" <leif.lindholm@linaro.org>, "pjones@redhat.com" <pjones@redhat.com>, "msalter@redhat.com" <msalter@redhat.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On 10 October 2014 17:38, Roy Franz <roy.franz@linaro.org> wrote:
> On Fri, Oct 10, 2014 at 6:27 AM, Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
>> On 10 October 2014 15:03, Mark Rutland <mark.rutland@arm.com> wrote:
>>> [...]
>>>
>>>> >> > But if the EFI loader is allowed to load stext at the precise start of
>>>> >> > RAM (or anywhere not in the idmap), in attempting the copy we'd try to
>>>> >> > access unmapped addresses.
>>>> >> >
>>>> >> > So if that's a possibility, we need to shrink the copy to cover stext
>>>> >> > to _edata rather than _text to edata.
>>>> >> >
>>>> >> > Does that make sense?
>>>> >> >
>>>> >>
>>>> >> That cannot happen. The PE/COFF .text section's positive relative
>>>> >> virtual offset ensures that the memory image has room for the header,
>>>> >> it's just not guaranteed that anything gets copied there.
>>>> >
>>>> > Ok. If we're guaranteed to have some space there, we're fine.
>>>> >
>>>> > I'm probably being a bit thick here, but where is the "positive relative
>>>> > virtual offset" in the header? Which field defines that?
>>>> >
>>>>
>>>> The fields VirtualSize, VirtualAddress (the field I was referring to),
>>>> SizeOfRawData and PointerToRawData define the relation between the
>>>> file layout and the memory layout of the .text section (line 219 and
>>>> up in head.S)
>>>
>>> I guess my confusion is over the semantics of the VirtualAddress field.
>>> If it's treated as an offset, what is that offset relative to in memory?
>>> And what defines that the space covered by that offset is accessible?
>>>
>>
>> The PE/COFF spec 8.3 describes VirtualAddress as
>>
>> """
>> For executable images, the address of the first byte of the section
>> relative to the image base when the section is loaded into memory.
>> """
>>
>> ImageBase is a field itself in the PE/COFF header, described as
>>
>> """
>> The preferred address of the first byte of image when loaded into
>> memory; must be a multiple of 64 K.
>> """
>
> This seems to strongly suggest that the header should be loaded into memory.
> "The first byte of the image" is the header we are talking about.
>

Perhaps it does, but look at it this way:
the header is a recipe for how to turn a chunk of memory into an
executable image, i.e it has headers for relocation sections,
text/data sections and bss sections, all of which are used in a
different way to populate or manipulate the memory image. The fact
that our file looks *exactly* like this memory image (or almost
exactly, now that we added some zero padding to the .text section) is
purely coincidental. There is a reason a section header has both a
'PointerToRawData' and a 'VirtualAddress': it is because they are
allowed to be *different*, i.e., a file image and a memory image are
not necessarily identical, and things that have /no/ virtual address
(such as the header) cannot be expected to be present in the memory
image at all, let alone at precisely the same negative offset from
some arbitrary section as it appears in the file.


>>
>> The SizeOfImage field is described as
>>
>> """
>> The size (in bytes) of the image, including all headers, as the image
>> is loaded in memory.
>> """
>>
>> My interpretation is that memory needs to be allocated for the header
>> as well as all sections that have a VirtualSize (including sections
>> like BSS which don't have a payload in the file)
>
> It does seem odd to require allocation for the header, but not copying the
> data.
>
> That said, your patch will handle the case of space being allocated
> for the header,
> but the header not copied, and it doesn't complicate anything, so I'm
> fine with it.
> Maybe we should add a comment that we still require memory to be allocated for
> where they header would be.
>
>
>>
>>>> In our current definition, the memory offset and the file offset are
>>>> identical (which this patch redefines as 'stext_offset'). The virtual
>>>> size covers the entire static memory footprint of Image (minus the
>>>> header). whereas the SizeOfRawData contains the size of the payload in
>>>> the file (again, minus the header). The balance is zero initialized by
>>>> the loader.
>>>
>>> I can see why this guarantees there is space for stext to _end, but I
>>> don't understand how this guarantees there is a valid mapping for the
>>> region that would otherwise be _head to stext.
>>>
>>
>> The allocation itself is defined in terms of ImageBase/SizeOfImage
>> (although ImageBase is only a preferred offset)
>> How this allocation is populated with data (and where the holes are)
>> is described by the sections.
>>
>> --
>> Ard.
