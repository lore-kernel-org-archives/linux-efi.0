From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH V2 2/3] efi: Introduce efi_rts_workqueue and some
 infrastructure to invoke all efi_runtime_services()
Date: Fri, 9 Mar 2018 11:57:35 +0100
Message-ID: <20180309105735.GB10753@pd.tnic>
References: <1520292190-5027-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1520292190-5027-3-git-send-email-sai.praneeth.prakhya@intel.com>
 <20180307121047.GG23662@pd.tnic>
 <FFF73D592F13FD46B8700F0A279B802F2E5818E4@ORSMSX114.amr.corp.intel.com>
 <20180308140830.GE21166@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F7B392450@ORSMSX110.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F7B392450@ORSMSX110.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Chun-Yi Lee <jlee@suse.com>, Will Deacon <will.deacon@arm.com>, "Hansen, Dave" <dave.hansen@intel.com>, Mark Rutland <mark.rutland@arm.com>, Bhupesh Sharma <bhsharma@redhat.com>, "Neri, Ricardo" <ricardo.neri@intel.com>, "Shankar, Ravi V" <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Zijlstra, Peter" <peter.zijlstra@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-efi@vger.kernel.org

On Thu, Mar 08, 2018 at 05:05:44PM +0000, Luck, Tony wrote:
> > "Hence, pstore calls efi_runtime_services() without using efi_rts_wq" -
> > that doesn't sound like optimal design to me. I would try to shove them
> > all through the workqueue - not have exceptions.
> 
> But pstore is trying to save the last gasp dying words from a kernel that
> has paniced. There isn't any guarantee that work queue will run. I think
> it is reasonable to have some special case to make sure that we do save
> the information.  But perhaps that special case should be to have pstore
> call directly into the guts of the EFI code and not worry about all these
> fancy switches of "mm" etc.

I guess...

> This is true for the machine check logging case too, but the mitigation is
> that the details of the error persist in the machine check banks across the
> reset ... so all is not lost if the work queue isn't run here.

Well, I'm still hoping to have this wonderful and reliable
logging facility one day where we can dump bytes into a
persistent-across-reboots buffer and analyze them later. And yap, in
that case, I don't mind if the code simply bypasses all the dancing in
the OS and writes those bytes. Even switching pagetables would be too
much for that case - just fire'n'forget writing from ring 0.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
