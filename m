From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v5 06/32] x86/mm: Add Secure Memory Encryption (SME)
 support
Date: Tue, 16 May 2017 14:28:42 -0500
Message-ID: <6d266f5b-c28d-fe19-24b5-5133532f9eea@amd.com>
References: <20170418211612.10190.82788.stgit@tlendack-t1.amdoffice.net>
 <20170418211727.10190.18774.stgit@tlendack-t1.amdoffice.net>
 <20170427154631.2tsqgax4kqcvydnx@pd.tnic>
 <d9d9f10a-0ce5-53e8-41f5-f8690dbd7362@amd.com>
 <20170504143622.zy2f66e4mkm6xvsq@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170504143622.zy2f66e4mkm6xvsq@pd.tnic>
Sender: owner-linux-mm@kvack.org
To: Borislav Petkov <bp@alien8.de>
Cc: linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, x86@kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, iommu@lists.linux-foundation.org, Rik van Riel <riel@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Toshimitsu Kani <toshi.kani@hpe.com>, Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, "Michael S.
 Tsirkin" <mst@redhat.com>, Joerg Roedel <joro@8bytes.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, Larry Woodman <lwoodman@redhat.com>, Brijesh Singh <brijesh.singh@amd.com>, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@kernel.org>, "H. Peter
 Anvin" <hpa@zytor.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>
List-Id: linux-efi@vger.kernel.org

On 5/4/2017 9:36 AM, Borislav Petkov wrote:
> On Thu, May 04, 2017 at 09:24:11AM -0500, Tom Lendacky wrote:
>> I did this so that an the include order wouldn't cause issues (including
>> asm/mem_encrypt.h followed by later by a linux/mem_encrypt.h include).
>> I can make this a bit clearer by having separate #defines for each
>> thing, e.g.:
>>
>> #ifndef sme_me_mask
>> #define sme_me_mask 0UL
>> #endif
>>
>> #ifndef sme_active
>> #define sme_active sme_active
>> static inline ...
>> #endif
>>
>> Is that better/clearer?
>
> I guess but where do we have to include both the asm/ and the linux/
> version?

It's more of the sequence of various includes.  For example,
init/do_mounts.c includes <linux/module.h> that eventually gets down
to <asm/pgtable_types.h> and then <asm/mem_encrypt.h>.  However, a
bit further down <linux/nfs_fs.h> is included which eventually gets
down to <linux/dma-mapping.h> and then <linux/mem_encyrpt.h>.

>
> IOW, can we avoid these issues altogether by partitioning symbol
> declarations differently among the headers?

It's most problematic when CONFIG_AMD_MEM_ENCRYPT is not defined since
we never include an asm/ version from the linux/ path.  I could create
a mem_encrypt.h in include/asm-generic/ that contains the info that
is in the !CONFIG_AMD_MEM_ENCRYPT path of the linux/ version. Let me
look into that.

Thanks,
Tom

>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
