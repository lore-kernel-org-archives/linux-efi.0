From: Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [RFC Part1 PATCH v3 16/17] X86/KVM: Provide support to create
 Guest and HV shared per-CPU variables
Date: Sat, 2 Sep 2017 21:34:48 -0500
Message-ID: <870ff11e-2ba0-22ce-51d5-450124ae1111@amd.com>
References: <20170724190757.11278-1-brijesh.singh@amd.com>
 <20170724190757.11278-17-brijesh.singh@amd.com>
 <20170829102258.gxk227js4yw47qi3@pd.tnic>
 <0810a732-9c77-a543-ffeb-7fd2d8f46266@amd.com>
 <20170830174655.ehrnmynotmp7laka@pd.tnic>
 <8155b5b2-b2b3-bc8f-33ae-b81b661a2e38@amd.com>
 <CALCETrV+rv=9Rg5V1z8vHtVDW64eCNtZHQMW8DipRADvm+qP5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrV+rv=9Rg5V1z8vHtVDW64eCNtZHQMW8DipRADvm+qP5A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: brijesh.singh-5C7GfCeVMHo@public.gmane.org, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linuxppc-dev <linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>, kvm list <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Piotr Luc <piotr.luc-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Reza Arbab <arbab-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Laura Abbott <labbott@redha>
List-Id: linux-efi@vger.kernel.org



On 9/1/17 10:21 PM, Andy Lutomirski wrote:
> On Fri, Sep 1, 2017 at 3:52 PM, Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org> wrote:
>> Hi Boris,
>>
>> On 08/30/2017 12:46 PM, Borislav Petkov wrote:
>>> On Wed, Aug 30, 2017 at 11:18:42AM -0500, Brijesh Singh wrote:
>>>> I was trying to avoid mixing early and no-early set_memory_decrypted()
>>>> but if
>>>> feedback is: use early_set_memory_decrypted() only if its required
>>>> otherwise
>>>> use set_memory_decrypted() then I can improve the logic in next rev.
>>>> thanks
>>>
>>> Yes, I think you should use the early versions when you're, well,
>>> *early* :-) But get rid of that for_each_possible_cpu() and do it only
>>> on the current CPU, as this is a per-CPU path anyway. If you need to
>>> do it on *every* CPU and very early, then you need a separate function
>>> which is called in kvm_smp_prepare_boot_cpu() as there you're pre-SMP.
>>>
>> I am trying to implement your feedback and now remember why I choose to
>> use early_set_memory_decrypted() and for_each_possible_cpu loop. These
>> percpu variables are static. Hence before clearing the C-bit we must
>> perform the in-place decryption so that original assignment is preserved
>> after we change the C-bit. Tom's SME patch [1] added sme_early_decrypt()
>> -- which can be used to perform the in-place decryption but we do not have
>> similar routine for non-early cases. In order to address your feedback,
>> we have to add similar functions. So far, we have not seen the need for
>> having such functions except this cases. The approach we have right now
>> works just fine and not sure if its worth adding new functions.
>>
>> Thoughts ?
>>
>> [1] Commit :7f8b7e7 x86/mm: Add support for early encryption/decryption of
>> memory
> Shouldn't this be called DEFINE_PER_CPU_UNENCRYPTED?  ISTM the "HV
> shared" bit is incidental.

Thanks for the suggestion, we could call it DEFINE_PER_CPU_UNENCRYPTED.
I will use it in next rev.

-Brijesh
