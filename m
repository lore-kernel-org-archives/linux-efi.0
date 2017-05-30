From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v5 29/32] x86/mm: Add support to encrypt the kernel
 in-place
Date: Tue, 30 May 2017 11:39:07 -0500
Message-ID: <33c075b1-71f6-b5d0-b1fa-d742d0659d38@amd.com>
References: <20170418211612.10190.82788.stgit@tlendack-t1.amdoffice.net>
 <20170418212149.10190.70894.stgit@tlendack-t1.amdoffice.net>
 <20170518124626.hqyqqbjpy7hmlpqc@pd.tnic>
 <7e2ae014-525c-76f2-9fce-2124596db2d2@amd.com>
 <20170526162522.p7prrqqalx2ivfxl@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20170526162522.p7prrqqalx2ivfxl@pd.tnic>
Content-Language: en-US
Sender: linux-arch-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, x86@kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, iommu@lists.linux-foundation.org, Rik van Riel <riel@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Toshimitsu Kani <toshi.kani@hpe.com>, Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, "Michael S. Tsirkin" <mst@redhat.com>, Joerg Roedel <joro@8bytes.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, Larry Woodman <lwoodman@redhat.com>, Brijesh Singh <brijesh.singh@amd.com>, Ingo Molnar <mingo@>
List-Id: linux-efi@vger.kernel.org

On 5/26/2017 11:25 AM, Borislav Petkov wrote:
> On Thu, May 25, 2017 at 05:24:27PM -0500, Tom Lendacky wrote:
>> I guess I could do that, but this will probably only end up clearing a
>> single PGD entry anyway since it's highly doubtful the address range
>> would cross a 512GB boundary.
> 
> Or you can compute how many 512G-covering, i.e., PGD entries there are
> and clear just the right amnount. :^)
> 
>> I can change the name. As for the use of ENTRY... without the
>> ENTRY/ENDPROC combination I was receiving a warning about a return
>> instruction outside of a callable function. It looks like I can just
>> define the "sme_enc_routine:" label with the ENDPROC and the warning
>> goes away and the global is avoided. It doesn't like the local labels
>> (.L...) so I'll use the new name.
> 
> Is that warning from objtool or where does it come from?

Yes, it's from objtool:

arch/x86/mm/mem_encrypt_boot.o: warning: objtool: .text+0xd2: return 
instruction outside of a callable function

> 
> How do I trigger it locally

I think having CONFIG_STACK_VALIDATION=y will trigger it.

> 
>> The hardware will try to optimize rep movsb into large chunks assuming
>> things are aligned, sizes are large enough, etc. so we don't have to
>> explicitly specify and setup for a rep movsq.
> 
> I thought the hw does that for movsq too?

It does.

Thanks,
Tom

> 
