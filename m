From: Andrew Cooper <andrew.cooper3@citrix.com>
Subject: Re: [Xen-devel] [PATCH v6 10/34] x86, x86/mm, x86/xen, olpc: Use
 __va() against just the physical address in cr3
Date: Thu, 8 Jun 2017 23:01:37 +0100
Message-ID: <d37917b1-8e49-e8a8-b9ac-59491331640f@citrix.com>
References: <20170607191309.28645.15241.stgit@tlendack-t1.amdoffice.net>
 <20170607191453.28645.92256.stgit@tlendack-t1.amdoffice.net>
 <b15e8924-4069-b5fa-adb2-86c164b1dd36@oracle.com>
 <4a7376fb-abfc-8edd-42b7-38de461ac65e@amd.com>
 <67fe69ac-a213-8de3-db28-0e54bba95127@oracle.com>
 <fcb196c8-f1eb-a38c-336c-7bd3929b029e@amd.com>
 <12c7e511-996d-cf60-3a3b-0be7b41bd85b@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <12c7e511-996d-cf60-3a3b-0be7b41bd85b@oracle.com>
Content-Language: en-GB
Sender: owner-linux-mm@kvack.org
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>, Tom Lendacky <thomas.lendacky@amd.com>, linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, x86@kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, iommu@lists.linux-foundation.org
Cc: Brijesh Singh <brijesh.singh@amd.com>, Toshimitsu Kani <toshi.kani@hpe.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, Alexander Potapenko <glider@google.com>, "H. Peter Anvin" <hpa@zytor.com>, Larry Woodman <lwoodman@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Joerg Roedel <joro@8bytes.org>, "Michael S. Tsirkin" <mst@redhat.com>, Ingo Molnar <mingo@redhat.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Dave Young <dyoung@redhat.com>, Rik van Riel <riel@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Dmitry Vyukov <dvyukov@google.com>, Juergen Gross <jgross@suse.com>, xen-devel <xen-devel@lists.xen.org>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: linux-efi@vger.kernel.org

On 08/06/2017 22:17, Boris Ostrovsky wrote:
> On 06/08/2017 05:02 PM, Tom Lendacky wrote:
>> On 6/8/2017 3:51 PM, Boris Ostrovsky wrote:
>>>>> What may be needed is making sure X86_FEATURE_SME is not set for PV
>>>>> guests.
>>>> And that may be something that Xen will need to control through either
>>>> CPUID or MSR support for the PV guests.
>>>
>>> Only on newer versions of Xen. On earlier versions (2-3 years old) leaf
>>> 0x80000007 is passed to the guest unchanged. And so is MSR_K8_SYSCFG.
>> The SME feature is in leaf 0x8000001f, is that leaf passed to the guest
>> unchanged?
> Oh, I misread the patch where X86_FEATURE_SME is defined. Then all
> versions, including the current one, pass it unchanged.
>
> All that's needed is setup_clear_cpu_cap(X86_FEATURE_SME) in
> xen_init_capabilities().

AMD processors still don't support CPUID Faulting (or at least, I
couldn't find any reference to it in the latest docs), so we cannot
actually hide SME from a guest which goes looking at native CPUID. 
Furthermore, I'm not aware of any CPUID masking support covering that leaf.

However, if Linux is using the paravirtual cpuid hook, things are
slightly better.

On Xen 4.9 and later, no guests will see the feature.  On earlier
versions of Xen (before I fixed the logic), plain domUs will not see the
feature, while dom0 will.

For safely, I'd recommend unilaterally clobbering the feature as Boris
suggested.  There is no way SME will be supportable on a per-PV guest
basis, although (as far as I am aware) Xen as a whole would be able to
encompass itself and all of its PV guests inside one single SME instance.

~Andrew

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
