From: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Subject: RE: [PATCH V4 3/3] x86/efi: Introduce EFI_PAGE_FAULT_HANDLER
Date: Fri, 7 Sep 2018 18:23:48 +0000
Message-ID: <FFF73D592F13FD46B8700F0A279B802F485BA5C1@ORSMSX114.amr.corp.intel.com>
References: <1536276468-28499-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1536276468-28499-4-git-send-email-sai.praneeth.prakhya@intel.com>
 <20180907112207.GS24106@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180907112207.GS24106@hirez.programming.kicks-ass.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "Neri, Ricardo" <ricardo.neri@intel.com>, "matt@codeblueprint.co.uk" <matt@codeblueprint.co.uk>, Al Stone <astone@redhat.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Bhupesh Sharma <bhsharma@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

> > There may exist some buggy UEFI firmware implementations that might
> > access efi regions other than EFI_RUNTIME_SERVICES_<CODE/DATA> even
> > after the kernel has assumed control of the platform. This violates
> > UEFI specification.
> >
> > If selected, this debug option will print a warning message if the
> > UEFI firmware tries to access any memory region which it shouldn't.
> > Along with the warning, the efi page fault handler will also try to
> > recover from the page fault triggered by the firmware so that the
> > machine doesn't hang.
> 
> Why make this optional?

I made it as a config option in RFC because the page fault handler was 
complicated and touching many parts (it had lots of code change and I didn't want 
to break any existing functionality). Now that it's simple, I don't think we need 
the config option.

Without efi page fault handler, any page fault caused by firmware should panic 
kernel but with this patch I think we are just improving existing condition (ideally).

So, if Thomas, Ingo, Andy, Ard and Boris are ok.. I will make it as default (i.e. without
config).

Regards,
Sai
