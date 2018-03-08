From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH V2 2/3] efi: Introduce efi_rts_workqueue and some
 infrastructure to invoke all efi_runtime_services()
Date: Thu, 8 Mar 2018 15:08:31 +0100
Message-ID: <20180308140830.GE21166@pd.tnic>
References: <1520292190-5027-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1520292190-5027-3-git-send-email-sai.praneeth.prakhya@intel.com>
 <20180307121047.GG23662@pd.tnic>
 <FFF73D592F13FD46B8700F0A279B802F2E5818E4@ORSMSX114.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <FFF73D592F13FD46B8700F0A279B802F2E5818E4@ORSMSX114.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Chun-Yi Lee <jlee@suse.com>, "Luck, Tony" <tony.luck@intel.com>, Will Deacon <will.deacon@arm.com>, "Hansen, Dave" <dave.hansen@intel.com>, Mark Rutland <mark.rutland@arm.com>, Bhupesh Sharma <bhsharma@redhat.com>, "Neri, Ricardo" <ricardo.neri@intel.com>, "Shankar, Ravi V" <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Zijlstra, Peter" <peter.zijlstra@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-efi@vger.kernel.org

On Thu, Mar 08, 2018 at 05:31:03AM +0000, Prakhya, Sai Praneeth wrote:
> Another warning by checkpatch is "use of in_atomic() in drivers code"

I'm assuming it warns because you're touching files in drivers/ but the
efi fun is not really a driver...

But looking at patch 3, that thing looks like a real mess. Some of the
things - pstore, it seems - do stuff in atomic context and yet you want
to do efi stuff in a workqueue which doesn't stomach atomic context to
begin with.

So if you wanna do workqueue, you should make sure all efi stuff gets
delayed to process context and queued properly. For example, we log
MCEs from atomic context by putting them on a lockless buffer and then
kicking irq_work to queue the work when we return to process context.
Can you do something like that?

"Hence, pstore calls efi_runtime_services() without using efi_rts_wq" -
that doesn't sound like optimal design to me. I would try to shove them
all through the workqueue - not have exceptions.

Then this:

> A potential issue could be, for instance, an NMI interrupt (like perf)
> trying to profile some user data while in efi_pgd.

I can't understand.

How did we handle this until now and why is it a problem all of a
sudden?

Because I don't recall being unable to run perf while efi runtime
services are happening.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
