From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v5 13/32] x86/boot/e820: Add support to determine the E820
 type of an address
Date: Sat, 6 May 2017 08:48:22 +0100
Message-ID: <CAKv+Gu-h+1UWPCUwvJT2AD=JtPqYQRRrrUCFjWNiAOCKfHh7rg@mail.gmail.com>
References: <20170418211612.10190.82788.stgit@tlendack-t1.amdoffice.net>
 <20170418211831.10190.80158.stgit@tlendack-t1.amdoffice.net> <20170505171155.4fm22ks6m5j7lpjm@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170505171155.4fm22ks6m5j7lpjm@pd.tnic>
Sender: owner-linux-mm@kvack.org
To: Borislav Petkov <bp@alien8.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, KVM devel mailing list <kvm@vger.kernel.org>, linux-doc@vger.kernel.org, "x86@kernel.org" <x86@kernel.org>, "kexec@lists.infradead.org" <kexec@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, kasan-dev <kasan-dev@googlegroups.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, iommu@lists.linux-foundation.org, Rik van Riel <riel@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Toshimitsu Kani <toshi.kani@hpe.com>, Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, "Michael S. Tsirkin" <mst@redhat.com>, Joerg Roedel <joro@8bytes.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Paolo Bonzini <pbonzini>
List-Id: linux-efi@vger.kernel.org

On 5 May 2017 at 18:11, Borislav Petkov <bp@alien8.de> wrote:
> On Tue, Apr 18, 2017 at 04:18:31PM -0500, Tom Lendacky wrote:
>> Add a function that will return the E820 type associated with an address
>> range.
>
> ...
>
>> @@ -110,9 +111,28 @@ bool __init e820__mapped_all(u64 start, u64 end, enum e820_type type)
>>                * coverage of the desired range exists:
>>                */
>>               if (start >= end)
>> -                     return 1;
>> +                     return entry;
>>       }
>> -     return 0;
>> +
>> +     return NULL;
>> +}
>> +
>> +/*
>> + * This function checks if the entire range <start,end> is mapped with type.
>> + */
>> +bool __init e820__mapped_all(u64 start, u64 end, enum e820_type type)
>> +{
>> +     return __e820__mapped_all(start, end, type) ? 1 : 0;
>
>         return !!__e820__mapped_all(start, end, type);
>

Even the !! double negation is redundant, given that the function returns bool.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
