From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH V2 2/3] efi: Introduce efi_rts_workqueue and some
 infrastructure to invoke all efi_runtime_services()
Date: Wed, 14 Mar 2018 18:40:27 +0100
Message-ID: <20180314174027.GF16605@pd.tnic>
References: <1520292190-5027-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1520292190-5027-3-git-send-email-sai.praneeth.prakhya@intel.com>
 <20180307121047.GG23662@pd.tnic>
 <FFF73D592F13FD46B8700F0A279B802F2E5818E4@ORSMSX114.amr.corp.intel.com>
 <20180308140830.GE21166@pd.tnic>
 <FFF73D592F13FD46B8700F0A279B802F2E581D28@ORSMSX114.amr.corp.intel.com>
 <20180309111157.GC10753@pd.tnic>
 <FFF73D592F13FD46B8700F0A279B802F2E5821F9@ORSMSX114.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <FFF73D592F13FD46B8700F0A279B802F2E5821F9@ORSMSX114.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Chun-Yi Lee <jlee@suse.com>, "Luck, Tony" <tony.luck@intel.com>, Will Deacon <will.deacon@arm.com>, "Hansen, Dave" <dave.hansen@intel.com>, Mark Rutland <mark.rutland@arm.com>, Bhupesh Sharma <bhsharma@redhat.com>, "Neri, Ricardo" <ricardo.neri@intel.com>, "Shankar, Ravi V" <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Zijlstra, Peter" <peter.zijlstra@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-efi@vger.kernel.org

On Sat, Mar 10, 2018 at 12:33:35AM +0000, Prakhya, Sai Praneeth wrote:
> Although the discussions were off my understanding, the present issue
> I see is, (and also the motivation for me to do the patch is) when a
> thread tries to execute any efi_runtime_service() we switch to efi_pgd
> (which doesn't have user space mappings) and all other subsystems in
> kernel aren't aware of this switch. This looks like a perfect case for
> kthread.

That's all fine and good but you need to be prepared and handle properly
an NMI while EFI is running.

I have no clue whether the platform delays delivery of NMIs during EFI
runtime services or whatever happens but you need to have all those
cases covered so that no monkey business happens.

Thx.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
