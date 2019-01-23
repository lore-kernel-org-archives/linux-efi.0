From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH v9 11/26] efi: Let architectures decide the flags that
 should be saved/restored
Date: Wed, 23 Jan 2019 09:04:46 +0000
Message-ID: <29fd5a40-e5ad-b430-c28b-57120f7dc312@arm.com>
References: <1548084825-8803-1-git-send-email-julien.thierry@arm.com>
 <1548084825-8803-12-git-send-email-julien.thierry@arm.com>
 <CAKv+Gu8w1cgrqpoL2n2Q=Jbjt_ZruF=oH0-cDyy-LuJUo8YBEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu8w1cgrqpoL2n2Q=Jbjt_ZruF=oH0-cDyy-LuJUo8YBEA@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Daniel Thompson <daniel.thompson@linaro.org>, Joel Fernandes <joel@joelfernandes.org>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, James Morse <james.morse@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org



On 21/01/2019 15:42, Ard Biesheuvel wrote:
> On Mon, 21 Jan 2019 at 16:34, Julien Thierry <julien.thierry@arm.com> wrote:
>>
>> Currently, irqflags are saved before calling runtime services and
>> checked for mismatch on return.
>>
>> Provide a pair of overridable macros to save and restore (if needed) the
>> state that need to be preserved on return from a runtime service.
>> This allows to check for flags that are not necesarly related to
>> irqflags.
>>
>> Signed-off-by: Julien Thierry <julien.thierry@arm.com>
>> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> Cc: linux-efi@vger.kernel.org
>> ---
>>  drivers/firmware/efi/runtime-wrappers.c | 17 +++++++++++++++--
>>  include/linux/efi.h                     |  5 +++--
>>  2 files changed, 18 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
>> index 8903b9c..2f4b68b 100644
>> --- a/drivers/firmware/efi/runtime-wrappers.c
>> +++ b/drivers/firmware/efi/runtime-wrappers.c
>> @@ -89,11 +89,24 @@
>>         efi_rts_work.status;                                            \
>>  })
>>
>> +#ifndef arch_efi_save_flags
>> +#define arch_efi_save_flags(state_flags)       local_save_flags(state_flags)
>> +#define arch_efi_restore_flags(state_flags)    local_irq_restore(state_flags)
>> +#endif
>> +
>> +inline unsigned long efi_call_virt_save_flags(void)
> 
> If you drop the 'inline' here,
> 

Sure, I'll drop it in the next version.

> Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> 

Thanks,

Julien

>> +{
>> +       unsigned long flags;
>> +
>> +       arch_efi_save_flags(flags);
>> +       return flags;
>> +}
>> +
>>  void efi_call_virt_check_flags(unsigned long flags, const char *call)
>>  {
>>         unsigned long cur_flags, mismatch;
>>
>> -       local_save_flags(cur_flags);
>> +       cur_flags = efi_call_virt_save_flags();
>>
>>         mismatch = flags ^ cur_flags;
>>         if (!WARN_ON_ONCE(mismatch & ARCH_EFI_IRQ_FLAGS_MASK))
>> @@ -102,7 +115,7 @@ void efi_call_virt_check_flags(unsigned long flags, const char *call)
>>         add_taint(TAINT_FIRMWARE_WORKAROUND, LOCKDEP_NOW_UNRELIABLE);
>>         pr_err_ratelimited(FW_BUG "IRQ flags corrupted (0x%08lx=>0x%08lx) by EFI %s\n",
>>                            flags, cur_flags, call);
>> -       local_irq_restore(flags);
>> +       arch_efi_restore_flags(flags);
>>  }
>>
>>  /*
>> diff --git a/include/linux/efi.h b/include/linux/efi.h
>> index 45ff763..bd80b7e 100644
>> --- a/include/linux/efi.h
>> +++ b/include/linux/efi.h
>> @@ -1607,6 +1607,7 @@ efi_status_t efi_setup_gop(efi_system_table_t *sys_table_arg,
>>
>>  bool efi_runtime_disabled(void);
>>  extern void efi_call_virt_check_flags(unsigned long flags, const char *call);
>> +extern unsigned long efi_call_virt_save_flags(void);
>>
>>  enum efi_secureboot_mode {
>>         efi_secureboot_mode_unset,
>> @@ -1652,7 +1653,7 @@ enum efi_secureboot_mode {
>>                                                                         \
>>         arch_efi_call_virt_setup();                                     \
>>                                                                         \
>> -       local_save_flags(__flags);                                      \
>> +       __flags = efi_call_virt_save_flags();                           \
>>         __s = arch_efi_call_virt(p, f, args);                           \
>>         efi_call_virt_check_flags(__flags, __stringify(f));             \
>>                                                                         \
>> @@ -1667,7 +1668,7 @@ enum efi_secureboot_mode {
>>                                                                         \
>>         arch_efi_call_virt_setup();                                     \
>>                                                                         \
>> -       local_save_flags(__flags);                                      \
>> +       __flags = efi_call_virt_save_flags();                           \
>>         arch_efi_call_virt(p, f, args);                                 \
>>         efi_call_virt_check_flags(__flags, __stringify(f));             \
>>                                                                         \
>> --
>> 1.9.1
>>

-- 
Julien Thierry
