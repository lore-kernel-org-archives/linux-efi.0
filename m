From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [RFC PATCH v3 04/20] x86: Handle reduction in physical address
 size with SME
Date: Tue, 15 Nov 2016 08:40:05 -0600
Message-ID: <a4cc5b07-89e1-aaa0-1977-1de95883ba62@amd.com>
References: <20161110003426.3280.2999.stgit@tlendack-t1.amdoffice.net>
 <20161110003513.3280.12104.stgit@tlendack-t1.amdoffice.net>
 <20161115121035.GD24857@8bytes.org> <20161115121456.f4slpk4i2jl3e2ke@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20161115121456.f4slpk4i2jl3e2ke@pd.tnic>
Sender: owner-linux-mm@kvack.org
To: Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>
Cc: linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, iommu@lists.linux-foundation.org, Rik van Riel <riel@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, Larry Woodman <lwoodman@redhat.com>, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@kernel.org>, "H. Peter
 Anvin" <hpa@zytor.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Thomas Gleixner <tglx@linutronix.de>, Dmitry Vyukov <dvyukov@google.com>
List-Id: linux-efi@vger.kernel.org

On 11/15/2016 6:14 AM, Borislav Petkov wrote:
> On Tue, Nov 15, 2016 at 01:10:35PM +0100, Joerg Roedel wrote:
>> Maybe add a comment here why you can't use cpu_has (yet).
> 
> So that could be alleviated by moving this function *after*
> init_scattered_cpuid_features(). Then you can simply do *cpu_has().

Yes, I can move it after init_scattered_cpuid_features() and then use
the cpu_has() function.  I'll make sure to include a comment that the
function needs to be called after init_scattered_cpuid_features().

> 
> Also, I'm not sure why we're checking CPUID for the SME feature when we
> have sme_get_me_mask() et al which have been setup much earlier...
> 

The feature may be present and enabled even if it is not currently
active.  In other words, the SYS_CFG MSR bit could be set but we aren't
actually using encryption (sme_me_mask is 0).  As long as the SYS_CFG
MSR bit is set we need to take into account the physical reduction in
address space.

Thanks,
Tom

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
