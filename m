From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v6 26/34] iommu/amd: Allow the AMD IOMMU to work with
 memory encryption
Date: Thu, 15 Jun 2017 11:33:41 -0500
Message-ID: <3db2c52d-5e63-a1df-edd4-975bce7f29c2@amd.com>
References: <20170607191309.28645.15241.stgit@tlendack-t1.amdoffice.net>
 <20170607191745.28645.81756.stgit@tlendack-t1.amdoffice.net>
 <20170614174208.p2yr5exs4b6pjxhf@pd.tnic>
 <0611d01a-19f8-d6ae-2682-932789855518@amd.com>
 <20170615094111.wga334kg2bhxqib3@pd.tnic>
 <921153f5-1528-31d8-b815-f0419e819aeb@amd.com>
 <20170615153322.nwylo3dzn4fdx6n6@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170615153322.nwylo3dzn4fdx6n6@pd.tnic>
Content-Language: en-US
Sender: owner-linux-mm@kvack.org
To: Borislav Petkov <bp@alien8.de>
Cc: linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, x86@kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, iommu@lists.linux-foundation.org, Rik van Riel <riel@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Toshimitsu Kani <toshi.kani@hpe.com>, Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, "Michael S. Tsirkin" <mst@redhat.com>, Joerg Roedel <joro@8bytes.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, Larry Woodman <lwoodman@redhat.com>, Brijesh Singh <brijesh.singh@amd.com>, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander
List-Id: linux-efi@vger.kernel.org

On 6/15/2017 10:33 AM, Borislav Petkov wrote:
> On Thu, Jun 15, 2017 at 09:59:45AM -0500, Tom Lendacky wrote:
>> Actually the detection routine, amd_iommu_detect(), is part of the
>> IOMMU_INIT_FINISH macro support which is called early through mm_init()
>> from start_kernel() and that routine is called before init_amd().
> 
> Ah, we do that there too:
> 
> 	for (p = __iommu_table; p < __iommu_table_end; p++) {
> 
> Can't say that that code with the special section and whatnot is
> obvious. :-\
> 
> Oh, well, early_init_amd() then. That is called in
> start_kernel->setup_arch->early_cpu_init and thus before mm_init().
> 
>>> If so, it did work fine until now, without the volatile. Why is it
>>> needed now, all of a sudden?
>>
>> If you run checkpatch against the whole amd_iommu.c file you'll see that
> 
> I'm, of course, not talking about the signature change: I'm *actually*
> questioning the need to make this argument volatile, all of a sudden.

Understood.

> 
> If there's a need, please explain why. It worked fine until now. If it
> didn't, we would've seen it.

The original reason for the change was to try and make the use of
iommu_virt_to_phys() straight forward.  Removing the cast and changing
build_completion_wait() to take a u64 * (without volatile) resulted in a
warning because cmd_sem is defined in the amd_iommu struct as volatile,
which required a cast on the call to iommu_virt_to_phys() anyway. Since
it worked fine previously and the whole volatile thing is beyond the
scope of this patchset, I'll change back to the original method of how
the function was called.

> 
> If it is a bug, then it needs a proper explanation, a *separate* patch
> and so on. But not like now, a drive-by change in an IOMMU enablement
> patch.
> 
> If it is wrong, then wait_on_sem() needs to be fixed too. AFAICT,
> wait_on_sem() gets called in both cases with interrupts disabled, while
> holding a lock so I'd like to pls know why, even in that case, does this
> variable need to be volatile

Changing the signature back reverts to the original way, so this can be
looked at separate from this patchset then.

Thanks,
Tom

> 

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
