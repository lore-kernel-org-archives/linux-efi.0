From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [RFC PATCH v4 03/28] x86: Add the Secure Memory Encryption CPU
 feature
Date: Thu, 16 Feb 2017 13:42:13 -0600
Message-ID: <a1a6a6d7-3aac-3138-1e75-6160f0427a6b@amd.com>
References: <20170216154158.19244.66630.stgit@tlendack-t1.amdoffice.net>
 <20170216154236.19244.7580.stgit@tlendack-t1.amdoffice.net>
 <20170216181355.bjxo2h6vlhukz4ih@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170216181355.bjxo2h6vlhukz4ih@pd.tnic>
Sender: owner-linux-mm@kvack.org
To: Borislav Petkov <bp@alien8.de>
Cc: linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, iommu@lists.linux-foundation.org, Rik van Riel <riel@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Toshimitsu Kani <toshi.kani@hpe.com>, Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, "Michael S.
 Tsirkin" <mst@redhat.com>, Joerg Roedel <joro@8bytes.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, Brijesh Singh <brijesh.singh@amd.com>, Ingo Molnar <mingo@redhat.com>, Alexander Potapenko <glider@google.com>, Andy Lutomirski <luto@kernel.org>, "H. Peter
 Anvin" <hpa@zytor.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Thomas Gleixner <tglx@li>
List-Id: linux-efi@vger.kernel.org

On 02/16/2017 12:13 PM, Borislav Petkov wrote:
> On Thu, Feb 16, 2017 at 09:42:36AM -0600, Tom Lendacky wrote:
>> Update the CPU features to include identifying and reporting on the
>> Secure Memory Encryption (SME) feature.  SME is identified by CPUID
>> 0x8000001f, but requires BIOS support to enable it (set bit 23 of
>> SYS_CFG MSR).  Only show the SME feature as available if reported by
>> CPUID and enabled by BIOS.
>>
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> ---
>>  arch/x86/include/asm/cpufeature.h        |    7 +++++--
>>  arch/x86/include/asm/cpufeatures.h       |    5 ++++-
>>  arch/x86/include/asm/disabled-features.h |    3 ++-
>>  arch/x86/include/asm/msr-index.h         |    2 ++
>>  arch/x86/include/asm/required-features.h |    3 ++-
>>  arch/x86/kernel/cpu/common.c             |   19 +++++++++++++++++++
>>  6 files changed, 34 insertions(+), 5 deletions(-)
> 
> What happened here?
> 
> You had it already:
> 
> https://lkml.kernel.org/r/20161110003459.3280.25796.stgit@tlendack-t1.amdoffice.net
> 
> The bit in get_cpu_cap() with checking the MSR you can add at the end of
> init_amd() for example.

I realize it's a bit more code and expands the changes but I thought it
would be a bit clearer as to what was going on this way. And then the
follow on patch for the physical address reduction goes in nicely, too.

If you prefer I stay with the scattered feature approach and then clear
the bit based on the MSR at the end of init_amd() I can do that. I'm
not attached to either method.

Thanks,
Tom

> 

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
