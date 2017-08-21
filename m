From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 3/3] x86/efi: Use efi_switch_mm() rather than manually
 twiddling with cr3
Date: Mon, 21 Aug 2017 19:24:25 +0200
Message-ID: <20170821172425.5axqiwnef5gkaz23@hirez.programming.kicks-ass.net>
References: <20170816095338.GB17270@leverpostej>
 <20170816100709.GG12845@arm.com>
 <20170816110321.GC17270@leverpostej>
 <20170816125715.GB3384@codeblueprint.co.uk>
 <CALCETrVSHuz=hcAgGxYHBmpiNcP4ECrJh885cR4X17QsJVj8+w@mail.gmail.com>
 <20170815223541.GA25778@remoulade>
 <20170817103514.GC27872@arm.com>
 <CALCETrVhLmntPArQiuOcQeNf9Y2kDxa+mUY=v1P8rVOkeCZn4Q@mail.gmail.com>
 <20170821103359.jt2xf2cx5wxjldau@hirez.programming.kicks-ass.net>
 <E5C753C8-1B92-4B4F-B95D-32DCC5C0AF5F@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <E5C753C8-1B92-4B4F-B95D-32DCC5C0AF5F@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andy Lutomirski <luto@kernel.org>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, joeyli <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, "Michael S. Tsirkin" <mst@redhat.com>, "Neri, Ricardo" <ricardo.neri@intel.com>, "Ravi V. Shankar" <ravi.v.shankar@intel.com>
List-Id: linux-efi@vger.kernel.org

On Mon, Aug 21, 2017 at 06:56:01AM -0700, Andy Lutomirski wrote:
> There are two ways this could be a problem.  One is that u privileged
> user apps shouldn't be able to read from EFI memory.  The other is
> that, if EFI were to have IO memory mapped at a "user" address, perf
> could end up reading it.

So assuming the efi_switch_mm() case from the calling thread context, I
don't see how we can avoid it at all.

Suppose we have a free running PEBS counter (PEBS puts samples in DS
buffer and only raises PMI when 'full'). This can easily cover the
entire efi_switch_mm() and back swizzle, and then we have 'userspace'
samples that don't correspond to actual userspace.

EFI (pretending to be userspace) is a giant trainwreck.
