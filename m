From: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Subject: RE: [PATCH V3 3/5] x86/efi: Permanently save the EFI_MEMORY_MAP
 passed by the firmware
Date: Wed, 5 Sep 2018 17:53:22 +0000
Message-ID: <FFF73D592F13FD46B8700F0A279B802F485B9A69@ORSMSX114.amr.corp.intel.com>
References: <1536099149-12564-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1536099149-12564-4-git-send-email-sai.praneeth.prakhya@intel.com>
 <CAKv+Gu9mfWYww49OmBETutSsaTDfE6VFJjbf+LWAoXF=mNmDBA@mail.gmail.com>
 <20180905125645.GX24082@hirez.programming.kicks-ass.net>
 <CAKv+Gu_DC=+7_YmDGGJ9fYJkGSNbUK-eXOAGMuZ2B7XXPWvZ9g@mail.gmail.com>
 <alpine.DEB.2.21.1809051505030.1416@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1809051505030.1416@nanos.tec.linutronix.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, "Neri, Ricardo" <ricardo.neri@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Al Stone <astone@redhat.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Bhupesh Sharma <bhsharma@redhat.com>
List-Id: linux-efi@vger.kernel.org

> On Wed, 5 Sep 2018, Ard Biesheuvel wrote:
> > On 5 September 2018 at 14:56, Peter Zijlstra <peterz@infradead.org> wrote:
> > > On Wed, Sep 05, 2018 at 02:27:49PM +0200, Ard Biesheuvel wrote:
> > >> Would we still need to preserve the old memory map in that case?
> > >
> > > I thought the reason for having this was being able to know the
> > > fault is in an EFI area. But of course, I'm not wel versed in this
> > > whole EFI crapola.
> >
> > I'm not entirely sure whether that really matters. The EFI services
> > access the stack and can access byref/pointer arguments which are not
> > covered by the EFI memory map as runtime services code/data, and so
> > they can trigger page faults by running off the vmapped stack or
> > writing to const byref arguments.
> >
> > EFI runtime services using boot services regions after they are no
> > longer available are a known source of headaches, but I don't see why
> > we should restrict ourselves to such cases if we bother to wire up
> > fault handling specifically for EFI services calls.
> >
> > So any page or permission fault occurring in the context of a EFI
> > runtime services invocation should be treated the same, I think.
> 
> I agree. Keep it simple. If the EFI crap fails, then assist with the reboot and
> otherwise just kill it.

The reasons for saving old memory map are
(in my view, these are the less important ones because they are very unlikely to happen)

1. Make sure that a memory descriptor exists for the physical address that was 
faulted on (EFI Memory Map could sometime have holes). Assuming a case that the 
physical address that caused page fault doesn't have a valid efi memory descriptor, the 
efi page fault handler shouldn't take any action because it hasn't triaged the problem yet.

2. Make sure that the faulted physical address is _not_ efi runtime service code/data region.
Efi runtime service code/data regions are always mapped by kernel in efi_pgd and accesses 
to these regions should _never_ page fault. Assuming that something like this happens, 
efi page fault handler shouldn't take any action because it's not any illegal access by firmware 
but it's a kernel bug.

Generally, the above two scenarios should never happen. I am just being paranoid and wanted 
to make sure that the efi page fault handler is fixing the right firmware bug that I came across 
and not something else. I also agree that, we could make the patch set and efi page fault handler 
much simpler by not saving old memory map. So, I am OK if we are not checking for the above 
two scenarios. If they are really needed, we could add them later.

That said, a more important reason (in my view) is to print out the memory descriptor that 
we faulted on. This is a *proof* showing that it's buggy firmware that caused page fault and 
hence is not a kernel bug. This proof is important because whenever a stack trace is printed 
with some efi function, kernel is the usual suspect and hence we need to show that it's not 
kernel fault. It could also help firmware engineers to fix the bug easily.

dmesg would show something like this when buggy efi_reset_system() accesses reserved region:

[  296.141511] efi: EFI Memory Descriptor for offending PA is:
[  296.141844] efi: [Reserved           |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x000000007e915000-0x000000007e933fff] (0MB)
[  296.142522] efi: efi_reset_system() buggy! Reboot through BIOS

So, I would be concerned if we miss this proof.

Regards,
Sai
