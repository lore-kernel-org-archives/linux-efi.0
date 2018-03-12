From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 2/5] x86/efi: Replace efi_pgd with efi_mm.pgd
Date: Mon, 12 Mar 2018 09:28:06 +0000
Message-ID: <CAKv+Gu8QOo67fg2Hgxz3C4bgm3Oeunf1hpdW=rrtNGUJLK4a9w@mail.gmail.com>
References: <20180312084500.10764-1-ard.biesheuvel@linaro.org>
 <20180312084500.10764-3-ard.biesheuvel@linaro.org> <20180312090220.lmohpvj62v7l2qsc@gmail.com>
 <20180312092650.nbvidgia5s5r5t7b@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180312092650.nbvidgia5s5r5t7b@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>, linux-efi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Sai Praneeth <sai.praneeth.prakhya@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Lee, Chun-Yi" <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>, "Michael S . Tsirkin" <mst@redhat.com>, Bhupesh Sharma <bhsharma@redhat.com>, Ricardo Neri <ricardo.neri@intel.com>, Ravi Shankar <ravi.v.shankar@intel.com>
List-Id: linux-efi@vger.kernel.org

On 12 March 2018 at 09:26, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Ingo Molnar <mingo@kernel.org> wrote:
>
>> > -static pgd_t *efi_pgd;
>> > -
>>
>> Hm, so there's some interaction here with:
>>
>>   116fef640859: x86/mm/dump_pagetables: Add the EFI pagetable to the debugfs 'page_tables' directory
>>
>> which is in tip:x86/mm.
>>
>> Could you please resolve that conflict? I'll sort out the topic branches
>> afterwards.
>
> So I've resolved it the following way, I merged the conflicting commit into
> tip:efi/core and applied the 3 unrelated patches from your series:
>
>  36b649760e94: efi: Use string literals for efi_char16_t variable initializers
>  136d5d57e35c: efi/esrt: Fix handling of early ESRT table mapping
>  7e904a91bf60: efi: Use efi_mm in x86 as well as ARM
>  b0599e2801df: Merge branch 'x86/mm' into efi/core
>
> and pushed it out.
>
> So if you could resolve the two conflicting patches on top of 36b649760e94 then we
> should be good going forward.
>

By 'resolve' you mean rebase and resend, right?
