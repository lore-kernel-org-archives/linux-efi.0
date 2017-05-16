From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH V16 08/11] efi: print unrecognized CPER section
Date: Tue, 16 May 2017 18:55:40 +0200
Message-ID: <20170516165540.xnbxdhrqeiorqhc5@pd.tnic>
References: <1494883680-25551-1-git-send-email-tbaicar@codeaurora.org>
 <1494883680-25551-9-git-send-email-tbaicar@codeaurora.org>
 <20170516142927.guxwc3gdgpqshpks@pd.tnic>
 <5a4a5b58-3e31-9fa5-091d-bb63437da9ab@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5a4a5b58-3e31-9fa5-091d-bb63437da9ab@codeaurora.org>
Sender: linux-acpi-owner@vger.kernel.org
To: "Baicar, Tyler" <tbaicar@codeaurora.org>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, nkaje@codeaurora.org, zjzhang@codeaurora.org, mark.rutland@arm.com, james.morse@arm.com, akpm@linux-foundation.org, eun.taik.lee@samsung.com, sandeepa.s.prabhu@gmail.com, labbott@redhat.com, shijie.huang@arm.com, rruigrok@codeaurora.org, paul.gortmaker@windriver.com, tn@semihalf.com, fu.wei@linaro.org, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Tue, May 16, 2017 at 10:44:43AM -0600, Baicar, Tyler wrote:
> I meant to respond to this comment after I sent the v16 patch series, but
> you beat me to it :)
> 
> These prefixes are common to all the GHES/CPER printing to the kernel logs.

I don't mean that - I meant to remove them from this particular example
in the commit message along with the timestamps. Because they are simply
useless there.

Of course they should stay in the actual printk calls.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
