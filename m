From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH V6 2/2] x86/efi: Add efi page fault handler to recover
 from page faults caused by the firmware
Date: Wed, 12 Sep 2018 20:58:36 +0200
Message-ID: <CAKv+Gu9yDEfUFkTK0orYLjRfs+=WXwPvr44a2q0ALiWMNEpmDg@mail.gmail.com>
References: <1536693322-8335-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1536693322-8335-3-git-send-email-sai.praneeth.prakhya@intel.com> <alpine.DEB.2.21.1809122055190.1473@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1809122055190.1473@nanos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Al Stone <astone@redhat.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Bhupesh Sharma <bhsharma@redhat.com>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-efi@vger.kernel.org

On 12 September 2018 at 20:56, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Tue, 11 Sep 2018, Sai Praneeth Prakhya wrote:
>> diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
>> index b18b2d864c2c..7455277a3b65 100644
>> --- a/drivers/firmware/efi/runtime-wrappers.c
>> +++ b/drivers/firmware/efi/runtime-wrappers.c
>> @@ -61,6 +61,11 @@ struct efi_runtime_work efi_rts_work;
>>  ({                                                                   \
>>       efi_rts_work.status = EFI_ABORTED;                              \
>>                                                                       \
>> +     if (!efi_enabled(EFI_RUNTIME_SERVICES)) {                       \
>> +             pr_info("Aborting! EFI Runtime Services disabled\n");   \
>
> This probaby wants to be pr_info_ince().
>

I can fix that up when applying.

> Other than that:
>
>       Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

Thanks! I will queue this up in efi/next
