From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [GIT PULL] x86/mm changes for v4.4
Date: Fri, 6 Nov 2015 11:39:43 +0000
Message-ID: <20151106113943.GB2651@codeblueprint.co.uk>
References: <20151103111649.GA3477@gmail.com>
 <CA+55aFzcwO+RSLeHOwAYvjZ5AcVvD9Th2=G3R=ZQY1xf+MkDow@mail.gmail.com>
 <20151104233907.GA25925@codemonkey.org.uk>
 <CA+55aFxb14eM6b=ctq65Dx-Ujehj2dbtsVM9rrVOVfLgT=EoHg@mail.gmail.com>
 <20151105021710.GA22941@codemonkey.org.uk>
 <CA+55aFyXNFu_TfmBjGedCRujoAbhqiBcia7XOtzSq0uxbVv6MA@mail.gmail.com>
 <CA+55aFyC7L85SYen3Uz6e1cvH0jXzQ9_MddHJ=7PxvpOR2U23w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFyC7L85SYen3Uz6e1cvH0jXzQ9_MddHJ=7PxvpOR2U23w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@codemonkey.org.uk>, Ingo Molnar <mingo@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Denys Vlasenko <dvlasenk@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Thu, 05 Nov, at 01:33:10PM, Linus Torvalds wrote:
> 
> And if this turns out to be due to EFI wanting those permissions, what
> should we do? People have talked about running the EFI callbacks in
> their own private page table setup, which sounds like the right idea,
> but until that actually *happens*....

We have separate page tables today, for a few reasons, but mainly it's
so that we can have an identity mapping of memory present in the
region usually used by user processes - broken firmware still uses
those identity mappings even after the kernel tells it they're
invalid.

Note that when I say "separate" I'm talking about trampoline_pgd[]
which is also used by the x86 suspend/resume code.

However, turns out that the issue with the current scheme is the fact
that trampoline_pgd[] actually shares a couple of PGD entries with
swapper_pg_dir as can be seen in setup_real_mode(),


        trampoline_pgd = (u64 *)__va(real_mode_header->trampoline_pgd);
        trampoline_pgd[0] = init_level4_pgt[pgd_index(__PAGE_OFFSET)].pgd;
        trampoline_pgd[511] = init_level4_pgt[511].pgd;


So when we map the EFI regions in efi_map_regions() we're inserting
them into swapper_pg_dir also, which is why you're seeing the
warnings.

If I remember correctly the rationale for using trampoline_pgd[] was
that it already did what we wanted (provided the identity mapping) and
would save us the overhead of maintaining more page tables for no good
reason. Obviously this entire thread is a good reason.

I suggest we stop using trampoline_pgd[] (since it has a good reason
for sharing the kernel mapping PGD entries) and create our own so that
we can isolate EFI completely.

For the immediate problem of the warnings spewing forth on all UEFI
machines, at the very least the config options needs to be disabled by
default, if not the patch reverted.
