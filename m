From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v10 37/38] compiler-gcc.h: Introduce __nostackp function
 attribute
Date: Tue, 18 Jul 2017 08:56:56 -0500
Message-ID: <b9b7d092-cb15-bc2e-6675-a36a78a5db6f@amd.com>
References: <cover.1500319216.git.thomas.lendacky@amd.com>
 <0576fd5c74440ad0250f16ac6609ecf587812456.1500319216.git.thomas.lendacky@amd.com>
 <20170718093631.pnamvdrkmzcjz64j@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170718093631.pnamvdrkmzcjz64j@gmail.com>
Content-Language: en-US
Sender: owner-linux-mm@kvack.org
To: Ingo Molnar <mingo@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, kasan-dev@googlegroups.com, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, Alexander Potapenko <glider@google.com>, Thomas Gleixner <tglx@linutronix.de>, Dmitry Vyukov <dvyukov@google.com>, Rik van Riel <riel@redhat.com>, Larry Woodman <lwoodman@redhat.com>, Dave Young <dyoung@redhat.com>, Toshimitsu Kani <toshi.kani@hpe.com>, Michael
List-Id: linux-efi@vger.kernel.org

On 7/18/2017 4:36 AM, Ingo Molnar wrote:
> 
> * Tom Lendacky <thomas.lendacky@amd.com> wrote:
> 
>> Create a new function attribute, __nostackp, that can used to turn off
>> stack protection on a per function basis.
>>
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> ---
>>   include/linux/compiler-gcc.h | 2 ++
>>   include/linux/compiler.h     | 4 ++++
>>   2 files changed, 6 insertions(+)
>>
>> diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
>> index cd4bbe8..682063b 100644
>> --- a/include/linux/compiler-gcc.h
>> +++ b/include/linux/compiler-gcc.h
>> @@ -166,6 +166,8 @@
>>   
>>   #if GCC_VERSION >= 40100
>>   # define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
>> +
>> +#define __nostackp	__attribute__((__optimize__("no-stack-protector")))
>>   #endif
>>   
>>   #if GCC_VERSION >= 40300
>> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
>> index 219f82f..63cbca1 100644
>> --- a/include/linux/compiler.h
>> +++ b/include/linux/compiler.h
>> @@ -470,6 +470,10 @@ static __always_inline void __write_once_size(volatile void *p, void *res, int s
>>   #define __visible
>>   #endif
>>   
>> +#ifndef __nostackp
>> +#define __nostackp
>> +#endif
> 
> So I changed this from the hard to read and ambiguous "__nostackp" abbreviation
> (does it mean 'no stack pointer?') to "__nostackprotector", plus added this detail
> to the changelog:
> 
> | ( This is needed by the SME in-place kernel memory encryption feature,
> |   which activates encryption in its sme_enable() function and thus changes the
> |   visible value of the stack protection cookie on function return. )
> 
> Agreed?

Hi Ingo,

I debugged this to needing "__nostackprotector" because sme_enable()
is called very early in the boot process before everything is properly
setup to fully support stack protection when KASLR is enabled. Without
this attribute the call to sme_enable() would fail even if encryption
was disabled with the "mem_encrypt=off" command line option.

If KASLR wasn't enabled, then everything worked fine without the
"__nostackprotector" attribute, encryption enabled or not.

The stack protection support is activated because of the 16-byte
character buffer in the sme_enable() routine.  I think we'll find that
if a character buffer greater than 8 bytes is added to, for example,
__startup_64, then this attribute will need to be added to that routine.

Thanks,
Tom

> 
> Thanks,
> 
> 	Ingo
> 

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
