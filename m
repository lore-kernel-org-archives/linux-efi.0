From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 0/6] arm64 UEFI early FDT handling
Date: Mon, 16 Nov 2015 11:57:22 +0100
Message-ID: <CAKv+Gu8PNfv9Hh8o6bOs5S_4i2Nd3wFx9MEZdm6+nVdLK_PWsw@mail.gmail.com>
References: <1442881288-13962-1-git-send-email-ard.biesheuvel@linaro.org>
	<CAKv+Gu8m2M9920yPRcrjmPeJPXKj=xd7ypH+ZFcYEm+_t5a5ig@mail.gmail.com>
	<20151116104352.GB1719@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151116104352.GB1719-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 16 November 2015 at 11:43, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org> wrote:
> Hi Ard,
>
> On Tue, Sep 29, 2015 at 08:38:57AM +0100, Ard Biesheuvel wrote:
>> (+ Grant)
>>
>> On 22 September 2015 at 02:21, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>> > This is a followup to the "arm64: update/clarify/relax Image and FDT placement
>> > rules" series I sent a while ago:
>> > (http://article.gmane.org/gmane.linux.ports.arm.kernel/407148)
>> >
>> > This has now been split in two series: this first series deals with the
>> > early FDT handling, primarily in the context of UEFI, but not exclusively.
>> >
>> > A number of minor issues exist in the early UEFI/FDT handling path, such as:
>> > - when booting via UEFI, memreserve entries are removed from the device tree but
>> >   the /reserved-memory node is not
>>
>> After reading Documentation/devicetree/bindings/reserved-memory/reserved-memory.txt
>> again, I think simply ignoring the reserved-memory node is not the way
>> to go. The reason is that it may contain dynamic allocations that are
>> referenced by other nodes in the DT, and there is no good technical
>> reason IMO to disallow those. OTOH, static allocations may conflict
>> with the UEFI memory map, so those need to be dropped or at least
>> checked against the memory map. The problem here is that static nodes
>> may also be referenced by phandle, so we need to handle the referring
>> node in some way as well.
>>
>> So I think we have a number of options:
>> - ignore /memreserve/s and reject static allocations in
>> /reserved-memory (*) but honor dynamic ones
>> - ignore /memreserve/s and honor all of /reserved-memory after
>> checking that static allocations don't conflict
>> - honor all /memreserve/s and /reserved-memory nodes and check all for conflicts
>> - ...
>>
>> (*) static allocations for regions that the UEFI memory map does not
>> describe should be OK, though
>>
>> I personally prefer the first one, since a dynamic allocation
>> implicitly conveys that the region does not contain anything special
>> when coming out of boot, and there is very little we need to do other
>> than perform the actual reservation. Static allocations are ambiguous
>> in the sense that there is no annotation that explains the choice of
>> address.
>>
>> Thoughts, please?
>
> What's the status of this series? It was on my "list of patches to watch"
> that I'm just refreshing for 4.5, but I can't see any comments on-list
> about it.
>

Good question. I got very little feedback (except from Ganapatrao) so
I didn't think people actually cared about this.
I followed up with a series that validates the /reserved-memory node
rather than removes it (which means we can keep both static and
dynamic allocations) but no response to that one either, apart from
some comments on implementation details

So we need to have the discussion first before looking at patches
again, I think, since the way we deal with these nodes should be based
on a comprehensive approach regarding memory nodes, memreserves and
/reserved-memory when booting via UEFI.

-- 
Ard.
