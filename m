From: Matthias Brugger <mbrugger-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] efi/libstub: arm: omit sorting of the UEFI memory map
Date: Fri, 27 Oct 2017 18:30:00 +0200
Message-ID: <6f9788e9-a0a4-0678-1dcc-4c99d2b0a52a@suse.com>
References: <20171022141457.28769-1-ard.biesheuvel@linaro.org>
 <fe35c87c-8fd0-b33f-3a6f-2bd759726667@suse.com>
 <20171027152850.GK20805@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171027152850.GK20805-l+eeeJia6m9URfEZ8mYm6t73F7V6hmMc@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Russell King - ARM Linux <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, zyw-TNX95d0MmH7DzftRWevZcw@public.gmane.org, jeffy.chen-TNX95d0MmH7DzftRWevZcw@public.gmane.org, gregory.clement-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
List-Id: linux-efi@vger.kernel.org



On 10/27/2017 05:28 PM, Russell King - ARM Linux wrote:
> On Fri, Oct 27, 2017 at 05:12:58PM +0200, Matthias Brugger wrote:
>> Hi Ard,
>>
>> On 10/22/2017 04:14 PM, Ard Biesheuvel wrote:
>>> ARM shares its EFI stub implementation with arm64, which has some
>>> special handling in the virtual remapping code to
>>> a) make sure that we can map everything even if the OS executes
>>>    with 64k page size, and
>>> b) make sure that adjacent regions with the same attributes are not
>>>    reordered or moved apart in memory.
>>>
>>> The latter is a workaround for a 'feature' that was shortly recommended
>>> by UEFI spec v2.5, but deprecated shortly after, due to the fact that
>>> it broke many OS installers, including non-Linux ones, and it was never
>>> widely implemented for ARM systems. Before implementing b), the arm64
>>> code simply rounded up all regions to 64 KB granularity, but given that
>>> that results in moving adjacent regions apart, it had to be refined when
>>> b) was implemented.
>>>
>>> The adjacency check requires a sort() pass, due to the fact that the
>>> UEFI spec does not mandate any ordering, and the inclusion of the
>>> lib/sort.c code into the ARM EFI stub is causing some trouble with
>>> the decompressor build due to the fact that its EXPORT_SYMBOL() call
>>> triggers the creation of ksymtab/kcrctab sections.
>>>
>>> So let's simply do away with the adjacency check for ARM, and simply put
>>> all UEFI runtime regions together if they have the same memory attributes.
>>> This is guaranteed to work, given that ARM only supports 4 KB pages,
>>> and allows us to remove the sort() call entirely.
>>>
>>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>> ---
>>>  drivers/firmware/efi/libstub/Makefile   | 6 +++---
>>>  drivers/firmware/efi/libstub/arm-stub.c | 7 +++++--
>>>  2 files changed, 8 insertions(+), 5 deletions(-)
>>>
>>
>> I thought I already provided my tag, but just in case:
>> This fixes the boot problems I had on the bananapi-r2.
>>
>> Tested-by: Matthias Brugger <matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> Please test my "fixes" branch - that has all three patches merged.
> 
> We don't have linux-next running at the moment, so folk need to be
> manually fetching the appropriate git trees for testing.
> 

I gave your branch a shot, feel free to add my:

Tested-by: Matthias Brugger <mbrugger-IBi9RG/b67k@public.gmane.org>

Especially for commit
4c2b35b71ea3 ARM: verify size of zImage

Regards,
Matthias
