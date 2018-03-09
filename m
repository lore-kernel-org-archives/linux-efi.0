From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH V2 2/3] efi: Introduce efi_rts_workqueue and some
 infrastructure to invoke all efi_runtime_services()
Date: Fri, 9 Mar 2018 12:11:57 +0100
Message-ID: <20180309111157.GC10753@pd.tnic>
References: <1520292190-5027-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1520292190-5027-3-git-send-email-sai.praneeth.prakhya@intel.com>
 <20180307121047.GG23662@pd.tnic>
 <FFF73D592F13FD46B8700F0A279B802F2E5818E4@ORSMSX114.amr.corp.intel.com>
 <20180308140830.GE21166@pd.tnic>
 <FFF73D592F13FD46B8700F0A279B802F2E581D28@ORSMSX114.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <FFF73D592F13FD46B8700F0A279B802F2E581D28@ORSMSX114.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Chun-Yi Lee <jlee@suse.com>, "Luck, Tony" <tony.luck@intel.com>, Will Deacon <will.deacon@arm.com>, "Hansen, Dave" <dave.hansen@intel.com>, Mark Rutland <mark.rutland@arm.com>, Bhupesh Sharma <bhsharma@redhat.com>, "Neri, Ricardo" <ricardo.neri@intel.com>, "Shankar, Ravi V" <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Zijlstra, Peter" <peter.zijlstra@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-efi@vger.kernel.org

On Fri, Mar 09, 2018 at 02:37:59AM +0000, Prakhya, Sai Praneeth wrote:
> But, I guess, we have some downsides with this design:
> 1. We are doing this to have "no exceptions to use efi_rts_wq", but we will be making
> the common case complicated. i.e. When a user requests to write some efi variable,

So if the pstore use case is so important and special, I think we should
make the EFI path as fast as possible as getting that data to the pstore
is a priority.

> Alternatively, instead of playing around with in_atomic(), we could have wrapper
> functions like efi_write_var_non_wq() which will only be used by pstore. This function
> will not use efi_rts_wq and directly invoke efi_runtime_service. Just an attempt to
> make the code not look messy.

I guess.

If the write-to-pstore case is such a critical one, I guess the
exception is justified.

> That's true! AFAIK, we don't have any issues handling NMI while in efi_pgd.
> We might have issues only when, we are already in efi_pgd, NMI comes along

Can you trigger this? Or is it something hypothetical?

> and NMI handler tries to touch the regions that are not mapped in efi_pgd

If it is not hypothetical, the NMI handler should learn to look at CR3
first and return if CR3 has the efi pgd.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
