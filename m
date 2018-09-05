From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH V3 3/5] x86/efi: Permanently save the EFI_MEMORY_MAP
 passed by the firmware
Date: Wed, 5 Sep 2018 14:56:45 +0200
Message-ID: <20180905125645.GX24082@hirez.programming.kicks-ass.net>
References: <1536099149-12564-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1536099149-12564-4-git-send-email-sai.praneeth.prakhya@intel.com>
 <CAKv+Gu9mfWYww49OmBETutSsaTDfE6VFJjbf+LWAoXF=mNmDBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9mfWYww49OmBETutSsaTDfE6VFJjbf+LWAoXF=mNmDBA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, "Neri, Ricardo" <ricardo.neri@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Al Stone <astone@redhat.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Bhupesh Sharma <bhsharma@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-efi@vger.kernel.org

On Wed, Sep 05, 2018 at 02:27:49PM +0200, Ard Biesheuvel wrote:
> On 5 September 2018 at 00:12, Sai Praneeth Prakhya
> <sai.praneeth.prakhya@intel.com> wrote:
> > From: Sai Praneeth <sai.praneeth.prakhya@intel.com>
> >
> > The efi page fault handler that recovers from page faults caused by the
> > firmware needs the original memory map passed by the firmware. It looks
> > up this memory map to find the type of the memory region at which the
> > page fault occurred. Presently, EFI subsystem discards the original
> > memory map passed by the firmware and replaces it with a new memory map
> > that has only EFI_RUNTIME_SERVICES_<CODE/DATA> regions. But illegal
> > accesses by firmware can occur at any region. Hence, _only_ if
> > CONFIG_EFI_WARN_ON_ILLEGAL_ACCESS is defined, create a backup of the
> > original memory map passed by the firmware, so that efi page fault
> > handler could detect/recover from illegal accesses to *any* efi region.
> >
> 
> Why do we care about the memory map at all when a fault occurs during
> the invocation of a EFI runtime service?
> 
> I think reasoning about what went wrong and why, and distinguishing
> between allowable and non-allowable faults is a slippery slope, so
> [taking Thomas's feedback into account], I think we can simplify this
> series further and just block all subsequent EFI runtime services
> calls if any permission or page fault occurs while executing them.
> 
> Would we still need to preserve the old memory map in that case?

I thought the reason for having this was being able to know the fault is
in an EFI area. But of course, I'm not wel versed in this whole EFI
crapola.
