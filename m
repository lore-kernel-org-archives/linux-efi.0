From: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Subject: RE: [PATCH V2 1/2] x86/efi: Unmap EFI boot services code/data
 regions from efi_pgd
Date: Mon, 29 Oct 2018 18:32:36 +0000
Message-ID: <FFF73D592F13FD46B8700F0A279B802F485E5588@ORSMSX114.amr.corp.intel.com>
References: <20181026213845.28166-1-sai.praneeth.prakhya@intel.com>
 <20181026213845.28166-2-sai.praneeth.prakhya@intel.com>
 <alpine.DEB.2.21.1810291809490.5984@nanos.tec.linutronix.de>
 <alpine.DEB.2.21.1810291820250.5984@nanos.tec.linutronix.de>
 <FFF73D592F13FD46B8700F0A279B802F485E5549@ORSMSX114.amr.corp.intel.com>
 <alpine.DEB.2.21.1810291907320.5984@nanos.tec.linutronix.de>
 <alpine.DEB.2.21.1810291911570.5984@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1810291911570.5984@nanos.tec.linutronix.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, "Hansen, Dave" <dave.hansen@intel.com>, Bhupesh Sharma <bhsharma@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

> > In general it's good to do on list because others can learn from the
> > answers as well.
> 
> So you somehow managed to keep everyone and the lists in CC nevertheless.
> Did not pay attention to the CC list until I got my reply on the list :)

Sorry! my bad.. yes, the conversation did happen on the list and it's by accident.
> 
> > > > > > +	retval = __change_page_attr_set_clr(&cpa, 0);

[........]

> > > So some questions I have are,
> > > 1. What did Peter Z mean here? "How is that not a TLB invalidation bug ?"
> >
> > __flush_tlb_all() flushes only the mapping on the current CPU. So in a
> > SMP environment it's not sufficient.

Thanks for the explanation. The issue makes sense to me now.

[.........]

> > I'll have a second look at the whole thing and reply on list.
> 
> So actually for the problem at hand __flush_tlb_all() works, because that is
> called way before the secondary CPUs are up.
> 
> Ditto for kernel_map_pages_in_pgd().

Yes, you are right. Both the functions are *always* called before SMP initialization
and as you rightly pointed out they should be marked with __init.

> But both functions want to be marked
> __init and aside of that they both should contain a warning when they are called
> after the secondary CPUs have been brought up.

Makes sense too.. I will include these changes in V3.

Regards,
Sai
