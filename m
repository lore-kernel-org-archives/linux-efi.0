From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 2/2] arm64/efi: Don't pad between EFI_MEMORY_RUNTIME
 regions
Date: Thu, 1 Oct 2015 12:44:55 +0200
Message-ID: <20151001104455.GA14061@gmail.com>
References: <1443218539-7610-1-git-send-email-matt@codeblueprint.co.uk>
 <1443218539-7610-3-git-send-email-matt@codeblueprint.co.uk>
 <20150926060159.GB25877@gmail.com>
 <CAKv+Gu_JRCmx5qKq7SDDq73BegVs3LKZwe+OdvTKb4YD_CURyw@mail.gmail.com>
 <20150927070644.GC26125@gmail.com>
 <560B34EF.8040408@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <560B34EF.8040408@zytor.com>
Sender: stable-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Fleming <matt@codeblueprint.co.uk>, Thomas Gleixner <tglx@linutronix.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Leif Lindholm <leif.lindholm@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, Matt Fleming <matt.fleming@intel.com>, Mark Rutland <mark.rutland@arm.com>, Mark Salter <msalter@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, Denys Vlasenko <dvlasenk@redhat.com>, Brian Gerst <brgerst@gmail.com>
List-Id: linux-efi@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 09/27/2015 12:06 AM, Ingo Molnar wrote:
> > 
> > * Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> > 
> >>> If we allocate the EFI runtime as a single virtual memory block then issues 
> >>> like rounding between sections does not even come up as a problem: we map the 
> >>> original offsets and sizes byte by byte.
> >>
> >> Well, by that reasoning, we should not call SetVirtualAddressMap() in the first 
> >> place, and just use the 1:1 mapping UEFI uses natively. This is more than 
> >> feasible on arm64, and I actually fought hard against using 
> >> SetVirtualAddressMap() at all, but I was overruled by others. I think this is 
> >> also trivially possible on X64, since the 1:1 mapping is already active 
> >> alongside the VA mapping.
> > 
> > Could we please re-list all the arguments pro and contra of 1:1 physical mappings, 
> > in a post that also explains the background so that more people can chime in, not 
> > just people versed in EFI internals? It's very much possible that a bad decision 
> > was made.
> > 
> 
> Pro: by far the sanest way to map the UEFI tables.
> Con: doesn't actually work (breaks on several known platforms.)

You knew this next question was coming: in what way does it break on known 
platforms?

I.e. do those platforms require a SetVirtualAddressMap() call and break if one 
does not come?

Note that there's 3 models possible:

 - pure 1:1
 - 1:1 plus offset, with SetVirtualAddressMap(offset)
 - bottom up allocator

I don't think we want 'pure' 1:1 physical/virtual (for security reasons, etc.).

So the question is, in what way does our current proposed bottom-up allocator 
differ from 1:1 plus offset? My impression is that they are mostly identical.

Thanks,

	Ingo
