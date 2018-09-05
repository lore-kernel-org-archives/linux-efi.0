From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH V3 3/5] x86/efi: Permanently save the EFI_MEMORY_MAP
 passed by the firmware
Date: Wed, 5 Sep 2018 15:06:06 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1809051505030.1416@nanos.tec.linutronix.de>
References: <1536099149-12564-1-git-send-email-sai.praneeth.prakhya@intel.com> <1536099149-12564-4-git-send-email-sai.praneeth.prakhya@intel.com> <CAKv+Gu9mfWYww49OmBETutSsaTDfE6VFJjbf+LWAoXF=mNmDBA@mail.gmail.com> <20180905125645.GX24082@hirez.programming.kicks-ass.net>
 <CAKv+Gu_DC=+7_YmDGGJ9fYJkGSNbUK-eXOAGMuZ2B7XXPWvZ9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu_DC=+7_YmDGGJ9fYJkGSNbUK-eXOAGMuZ2B7XXPWvZ9g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, "Neri, Ricardo" <ricardo.neri@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Al Stone <astone@redhat.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Bhupesh Sharma <bhsharma@redhat.com>
List-Id: linux-efi@vger.kernel.org

On Wed, 5 Sep 2018, Ard Biesheuvel wrote:
> On 5 September 2018 at 14:56, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Wed, Sep 05, 2018 at 02:27:49PM +0200, Ard Biesheuvel wrote:
> >> Would we still need to preserve the old memory map in that case?
> >
> > I thought the reason for having this was being able to know the fault is
> > in an EFI area. But of course, I'm not wel versed in this whole EFI
> > crapola.
> 
> I'm not entirely sure whether that really matters. The EFI services
> access the stack and can access byref/pointer arguments which are not
> covered by the EFI memory map as runtime services code/data, and so
> they can trigger page faults by running off the vmapped stack or
> writing to const byref arguments.
> 
> EFI runtime services using boot services regions after they are no
> longer available are a known source of headaches, but I don't see why
> we should restrict ourselves to such cases if we bother to wire up
> fault handling specifically for EFI services calls.
> 
> So any page or permission fault occurring in the context of a EFI
> runtime services invocation should be treated the same, I think.

I agree. Keep it simple. If the EFI crap fails, then assist with the reboot
and otherwise just kill it.

Thanks,

	tglx
