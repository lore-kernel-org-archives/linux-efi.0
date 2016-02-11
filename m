From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v4 0/6] arm64 UEFI early FDT handling
Date: Thu, 11 Feb 2016 13:14:45 +0100
Message-ID: <CAKv+Gu-KpasM9QZ8qrZEk_pUJpf3TceaenLYTx_eAHW6AUmutA@mail.gmail.com>
References: <1455026026-11571-1-git-send-email-rrichter@caviumnetworks.com>
	<CAKv+Gu-osoi53cpikDtZitJJX2gtZyhOMuvYf=cfeZi8zJ-LDg@mail.gmail.com>
	<20160211114204.GO24726@rric.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160211114204.GO24726@rric.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Robert Richter <robert.richter@caviumnetworks.com>
Cc: Grant Likely <grant.likely@linaro.org>, Will Deacon <will.deacon@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>, Catalin Marinas <catalin.marinas@arm.com>, Leif Lindholm <leif.lindholm@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Mark Salter <msalter@redhat.com>, Ganapatrao Kulkarni <gkulkarni@caviumnetworks.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Rob Herring <robh@kernel.org>
List-Id: linux-efi@vger.kernel.org

On 11 February 2016 at 12:42, Robert Richter
<robert.richter@caviumnetworks.com> wrote:
> (+RobH and MarkR)
>
> On 09.02.16 15:35:42, Ard Biesheuvel wrote:
>> (+ Grant)
>>
>> On 9 February 2016 at 14:53, Robert Richter <rrichter@caviumnetworks.com> wrote:
>> > From: Robert Richter <rrichter@cavium.com>
>> >
>> > Reposting an updated version of this patches ported to 4.5-rc1. It is
>> > a followup to the version 3 from:
>> >
>> >  http://lkml.kernel.org/r/1442881288-13962-1-git-send-email-ard.biesheuvel@linaro.org
>> >
>> > The series is essential for NUMA on arm64. Early FDT handling is
>> > required to make system topology data from firmware, esp. for cpus and
>> > memory available to the early boot process. Ganapat's numa patches
>> > depend on it. This series has been tested with his series v10 posted
>> > here:
>> >
>> >  http://lkml.kernel.org/r/1454407763-1017-1-git-send-email-gkulkarni@caviumnetworks.com
>> >
>>
>> Hello Robert,
>>
>> This series does not reflect anymore what we think is the best way to
>> deal with memory nodes and memreserves on UEFI systems.
>> Please refer to this thread:
>> http://thread.gmane.org/gmane.linux.kernel.efi/6464
>>
>> As far as the memory nodes are concerned, if it is the best place to
>> store these NUMA annotations, then we should indeed preserve them, but
>> I think the discussion stalled without any conclusion having been
>> reached. As far as the /reserved-memory node is concerned, that one we
>> should really keep, so at least patch 6/6 of this series should be
>> replaced with something based on the series above.
>
> Ard,
>
> Mark R and Rob have agreed for numa dt binding for mem nodes. So do
> you think we can at least reuse parts of this series to solve the NUMA
> issue and try to find a solution for patch #6 which aligns with your
> alternative approach?
>

OK, if we are all in agreement that NUMA annotations belong in memory
nodes, which are otherwise ignored completely on UEFI systems, I am
fine with this as well.

However, we have to think about what it means if the memory nodes are
out of sync with the UEFI memory map, both on NUMA and ordinary
systems. I know very little about NUMA, but I could imagine that on
any UEFI system, the UEFI memory map remains authoritative, and memory
nodes are only used to annotate regions that are already known to
exist. Alternatively, some sanity check could be appropriate (such as
the one I proposed for the /reserved-memory node in the link above),
but we need to consider carefully how the firmware is supposed to
produce memory nodes and a UEFI memory map that are mutually
consistent.

I think we can replace 6/6 with the series above, i.e., honour the
allocations after establishing that the fixed allocations are either
still available, or entirely disjoint from what the UEFI memory map
describes.

-- 
Ard.
