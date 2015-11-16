From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2 11/12] ARM: wire up UEFI init and runtime support
Date: Mon, 16 Nov 2015 20:04:00 +0100
Message-ID: <CAKv+Gu8w+2GA5tV4roYtEsza+mkCZKYX_=tT2t=+eh-ZO1Y2fA@mail.gmail.com>
References: <1447698757-8762-1-git-send-email-ard.biesheuvel@linaro.org>
	<1447698757-8762-12-git-send-email-ard.biesheuvel@linaro.org>
	<20151116190156.GH8644@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20151116190156.GH8644@n2100.arm.linux.org.uk>
Sender: owner-linux-mm@kvack.org
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Will Deacon <will.deacon@arm.com>, Grant Likely <grant.likely@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Leif Lindholm <leif.lindholm@linaro.org>, Roy Franz <roy.franz@linaro.org>, Mark Salter <msalter@redhat.com>, Ryan Harkin <ryan.harkin@linaro.org>, Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>
List-Id: linux-efi@vger.kernel.org

On 16 November 2015 at 20:01, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Nov 16, 2015 at 07:32:36PM +0100, Ard Biesheuvel wrote:
>> +static inline void efi_set_pgd(struct mm_struct *mm)
>> +{
>> +     if (unlikely(mm->context.vmalloc_seq != init_mm.context.vmalloc_seq))
>> +             __check_vmalloc_seq(mm);
>> +
>> +     cpu_switch_mm(mm->pgd, mm);
>> +
>> +     flush_tlb_all();
>> +     if (icache_is_vivt_asid_tagged())
>> +             __flush_icache_all();
>> +}
>
> I don't think that's sufficient.  There's a gap between switching the mm
> and flushing the TLBs where we could have different global TLB entries
> from those in the page tables - and that can cause problems with CPUs
> which speculatively prefetch.  Some CPUs raise exceptions for this...
>

OK. So you mean set TTBR to the zero page, perform the TLB flush and
only then switch to the new page tables?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
