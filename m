From: Bhupesh Sharma <bhsharma@redhat.com>
Subject: Re: [PATCH V4 3/3] x86/efi: Introduce EFI_PAGE_FAULT_HANDLER
Date: Sat, 8 Sep 2018 00:19:34 +0530
Message-ID: <e10acaa8-f5d8-85f3-219c-86fafd793a87@redhat.com>
References: <1536276468-28499-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1536276468-28499-4-git-send-email-sai.praneeth.prakhya@intel.com>
 <20180907112207.GS24106@hirez.programming.kicks-ass.net>
 <FFF73D592F13FD46B8700F0A279B802F485BA5C1@ORSMSX114.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <FFF73D592F13FD46B8700F0A279B802F485BA5C1@ORSMSX114.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "Neri, Ricardo" <ricardo.neri@intel.com>, "matt@codeblueprint.co.uk" <matt@codeblueprint.co.uk>, Al Stone <astone@redhat.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-efi@vger.kernel.org

On 09/07/2018 11:53 PM, Prakhya, Sai Praneeth wrote:
> >> There may exist some buggy UEFI firmware implementations that might
> >> access efi regions other than EFI_RUNTIME_SERVICES_<CODE/DATA> even
> >> after the kernel has assumed control of the platform. This violates
> >> UEFI specification.
> >>
> >> If selected, this debug option will print a warning message if the
> >> UEFI firmware tries to access any memory region which it shouldn't.
> >> Along with the warning, the efi page fault handler will also try to
> >> recover from the page fault triggered by the firmware so that the
> >> machine doesn't hang.
> >
> > Why make this optional?
>
> I made it as a config option in RFC because the page fault handler was
> complicated and touching many parts (it had lots of code change and I didn't want
> to break any existing functionality). Now that it's simple, I don't think we need
> the config option.
>
> Without efi page fault handler, any page fault caused by firmware should panic
> kernel but with this patch I think we are just improving existing condition (ideally).
>
> So, if Thomas, Ingo, Andy, Ard and Boris are ok.. I will make it as default (i.e. without
> config).
>
> Regards,
> Sai
>
Also, some distributions already have specific ways to handle buggy firmwares which can be at times dependent on the underlying hardware and the firmware versions.

I would suggest that we enable this under a CONFIG for the first round and once it is tested with wider variety of x86 machines which have buggy or orphaned firmware and linux (and reboot) works fine with them, we can drop the CONFIG option in future and enable this by default.

Regards,
Bhupesh
