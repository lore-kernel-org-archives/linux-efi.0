From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2 10/12] ARM: only consider memblocks with NOMAP cleared
 for linear mapping
Date: Mon, 16 Nov 2015 20:02:38 +0100
Message-ID: <CAKv+Gu8_AUX9FAUhLKvsuC=iuD0bqt+ZvXCRyxkC_BjFjvSspQ@mail.gmail.com>
References: <1447698757-8762-1-git-send-email-ard.biesheuvel@linaro.org>
	<1447698757-8762-11-git-send-email-ard.biesheuvel@linaro.org>
	<20151116190003.GG8644@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20151116190003.GG8644@n2100.arm.linux.org.uk>
Sender: owner-linux-mm@kvack.org
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Will Deacon <will.deacon@arm.com>, Grant Likely <grant.likely@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Leif Lindholm <leif.lindholm@linaro.org>, Roy Franz <roy.franz@linaro.org>, Mark Salter <msalter@redhat.com>, Ryan Harkin <ryan.harkin@linaro.org>, Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>
List-Id: linux-efi@vger.kernel.org

On 16 November 2015 at 20:00, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Nov 16, 2015 at 07:32:35PM +0100, Ard Biesheuvel wrote:
>> Take the new memblock attribute MEMBLOCK_NOMAP into account when
>> deciding whether a certain region is or should be covered by the
>> kernel direct mapping.
>
> It's probably worth looking at this as a replacement to the way
> arm_memblock_steal() works, provided NOMAP doesn't result in the
> memory being passed to the kernel allocators.  Thoughts?
>

Yes. The primary reason for NOMAP is that the memory is not removed,
so we don't lose the annotation that it is memory (which might be
useful, for instance, for /dev/mem attribute handling)

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
