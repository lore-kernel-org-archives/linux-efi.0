From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v15 1/6] efi: ARM/arm64: ignore DT memory nodes instead of
 removing them
Date: Fri, 18 Mar 2016 13:31:59 +0100
Message-ID: <CAKv+Gu8STa=tF0o1qje6LorYxzBon704Q_O2U=cvigg9v53hZw@mail.gmail.com>
References: <1457481587-8976-1-git-send-email-ddaney.cavm@gmail.com>
	<1457481587-8976-2-git-send-email-ddaney.cavm@gmail.com>
	<20160318122609.GS2619@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160318122609.GS2619@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: David Daney <ddaney.cavm@gmail.com>, Will Deacon <will.deacon@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>, Grant Likely <grant.likely@linaro.org>, Pawel Moll <pawel.moll@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Ganapatrao Kulkarni <gkulkarni@caviumnetworks.com>, Robert Richter <rrichter@cavium.com>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, David Daney <david.daney@cavium.com>
List-Id: linux-efi@vger.kernel.org

On 18 March 2016 at 13:26, Matt Fleming <matt@codeblueprint.co.uk> wrote:
> On Tue, 08 Mar, at 03:59:42PM, David Daney wrote:
>> From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>>
>> There are two problems with the UEFI stub DT memory node removal
>> routine:
>> - it deletes nodes as it traverses the tree, which happens to work
>>   but is not supported, as deletion invalidates the node iterator;
>> - deleting memory nodes entirely may discard annotations in the form
>>   of additional properties on the nodes.
>>
>> Since the discovery of DT memory nodes occurs strictly before the
>> UEFI init sequence, we can simply clear the memblock memory table
>> before parsing the UEFI memory map. This way, it is no longer
>> necessary to remove the nodes, so we can remove that logic from the
>> stub as well.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> Signed-off-by: David Daney <david.daney@cavium.com>
>> ---
>>  drivers/firmware/efi/arm-init.c    |  8 ++++++++
>>  drivers/firmware/efi/libstub/fdt.c | 24 +-----------------------
>>  2 files changed, 9 insertions(+), 23 deletions(-)
>
> I've not delved into the rest of the series too deeply, but this looks
> like a straight forward change.
>
> Reviewed-by: Matt Fleming <matt@codeblueprint.co.uk>
>
>> diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
>> index 9e15d57..40c9d85 100644
>> --- a/drivers/firmware/efi/arm-init.c
>> +++ b/drivers/firmware/efi/arm-init.c
>> @@ -143,6 +143,14 @@ static __init void reserve_regions(void)
>>       if (efi_enabled(EFI_DBG))
>>               pr_info("Processing EFI memory map:\n");
>>
>> +     /*
>> +      * Discard memblocks discovered so far: if there are any at this
>> +      * point, they originate from memory nodes in the DT, and UEFI
>> +      * uses its own memory map instead.
>> +      */
>> +     memblock_dump_all();
>> +     memblock_remove(0, ULLONG_MAX);
>> +
>>       for_each_efi_memory_desc(&memmap, md) {
>>               paddr = md->phys_addr;
>>               npages = md->num_pages;
>
> Out of curiosity, could some kind person explain (or point me at a
> previous explanation for) why we may have both DT memory nodes and a
> UEFI memory map and why they're not compatible enough to co-exist?

Typically, the UEFI memory map is more restrictive, since it does not
only describe where the memory lives, but also which parts of it the
firmware has claimed for its own use. So if both memory nodes and the
UEFI memory map are available, we must use the latter anyway, and so
it makes sense to ignore the former. Alternatively, we could sanity
check the memory nodes against the memory map, but it is simpler just
to ignore them.

However, that caused some problems in the past, since discovering the
memory nodes occurs before the EFI entry point is invoked, and so it
was decided that we strip the memory nodes rather than ignore them.
