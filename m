From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 12/12] efi: make const array 'apple' static
Date: Fri, 9 Mar 2018 07:52:34 +0000
Message-ID: <CAKv+Gu-JmM3F0=XCDZFAkK+6pRgmp=7HK2dhY9La9tKbNYFBEg@mail.gmail.com>
References: <20180308080020.22828-1-ard.biesheuvel@linaro.org>
 <20180308080020.22828-13-ard.biesheuvel@linaro.org> <20180309074719.y33xe4bjkjsjsaa3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180309074719.y33xe4bjkjsjsaa3@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-efi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Colin Ian King <colin.king@canonical.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 9 March 2018 at 07:47, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> Don't populate the const read-only array 'buf' on the stack but instead
>> make it static. Makes the object code smaller by 64 bytes:
>>
>> Before:
>>    text          data     bss     dec     hex filename
>>    9264             1      16    9281    2441 arch/x86/boot/compressed/eboot.o
>>
>> After:
>>    text          data     bss     dec     hex filename
>>    9200             1      16    9217    2401 arch/x86/boot/compressed/eboot.o
>>
>> (gcc version 7.2.0 x86_64)
>>
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> ---
>>  arch/x86/boot/compressed/eboot.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
>> index 886a9115af62..f2251c1c9853 100644
>> --- a/arch/x86/boot/compressed/eboot.c
>> +++ b/arch/x86/boot/compressed/eboot.c
>> @@ -423,7 +423,7 @@ static void retrieve_apple_device_properties(struct boot_params *boot_params)
>>
>>  static void setup_quirks(struct boot_params *boot_params)
>>  {
>> -     efi_char16_t const apple[] = { 'A', 'p', 'p', 'l', 'e', 0 };
>> +     static efi_char16_t const apple[] = { 'A', 'p', 'p', 'l', 'e', 0 };
>>       efi_char16_t *fw_vendor = (efi_char16_t *)(unsigned long)
>>               efi_table_attr(efi_system_table, fw_vendor, sys_table);
>
> As a general policy, please don't put 'static' variables into the local scope,
> use file scope instead - right before setup_quirks() would be fine.
>
> This makes it abundantly clear that it's not on the stack.
>

Fair enough. I didn't know there was such a policy, but since these
have local scope by definition, it doesn't pollute the global
namespace so it's fine

> Also, would it make sense to rename it to something more descriptive like
> "apple_unicode_str[]" or so?
>
> Plus an unicode string literal initializer would be pretty descriptive as well,
> instead of the weird looking character array, i.e. something like:
>
>   static efi_char16_t const apple_unicode_str[] = u"Apple";
>
> ... or so?
>

is u"xxx" the same as L"xxx"?

In any case, this is for historical reasons: at some point (and I
don't remember the exact details) we had a conflict at link time with
objects using 4 byte wchar_t, so we started using this notation to be
independent of the size of wchar_t. That issue no longer exists so we
should be able to get rid of this.
