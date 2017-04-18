From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 7/8] efi/capsule-loader: use page addresses rather than
 struct page pointers
Date: Tue, 18 Apr 2017 14:01:21 +0100
Message-ID: <CAKv+Gu9kz89EVh3s0e+uaQ6AZd_5U6xzos+cXdsGvXyR4aogJQ@mail.gmail.com>
References: <20170405092317.27921-1-ard.biesheuvel@linaro.org>
 <20170405092317.27921-8-ard.biesheuvel@linaro.org> <20170418125631.GI24360@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170418125631.GI24360-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>, Kweh Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Sascha Weisenberger <sascha.weisenberger-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 18 April 2017 at 13:56, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Wed, 05 Apr, at 10:23:16AM, Ard Biesheuvel wrote:
>> To give some leeway to code that handles non-standard capsule headers,
>> let's keep an array of page addresses rather than struct page pointers.
>>
>> This gives special implementations of efi_capsule_setup_info() the
>> opportunity to mangle the payload a bit before it is presented to the
>> firmware, without putting any knowledge of the nature of such quirks
>> into the generic code.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  drivers/firmware/efi/capsule-loader.c | 12 ++++++++----
>>  drivers/firmware/efi/capsule.c        |  7 ++++---
>>  include/linux/efi.h                   |  4 ++--
>>  3 files changed, 14 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
>> index d68a1ecebbf3..22b2bb73176c 100644
>> --- a/drivers/firmware/efi/capsule-loader.c
>> +++ b/drivers/firmware/efi/capsule-loader.c
>> @@ -20,6 +20,10 @@
>>
>>  #define NO_FURTHER_WRITE_ACTION -1
>>
>> +#ifndef phys_to_page
>> +#define phys_to_page(x)              virt_to_page((unsigned long)__va(x))
>> +#endif
>
> Is this going to work with highmem pages, which presumably, is a
> possibility for the 32-bit Quark?

Good point. Given that we don't really care about the virtual address
anyway, what is the best way to translate physical addresses to struct
page pointers on x86? i suppose pfn_to_page(pa >> PAGE_SHIFT) always
does the trick?
