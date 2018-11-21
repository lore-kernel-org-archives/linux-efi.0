From: John Garry <john.garry@huawei.com>
Subject: Re: [RFT PATCH] efi: map memreserve table before first use
Date: Wed, 21 Nov 2018 13:33:34 +0000
Message-ID: <d754166a-7c5e-9673-1052-9d433f5593eb@huawei.com>
References: <20181120173542.31444-1-ard.biesheuvel@linaro.org>
 <20181121095648.GA11514@hc>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20181121095648.GA11514@hc>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Jan Glauber <Jan.Glauber@cavium.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On 21/11/2018 09:56, Jan Glauber wrote:
> On Tue, Nov 20, 2018 at 06:35:42PM +0100, Ard Biesheuvel wrote:
>> Mapping the MEMRESERVE EFI configuration table from an early initcall
>> is too late: the GICv3 ITS code that creates persistent reservations
>> for the boot CPU's LPI tables is invoked from init_IRQ(), which runs
>> much earlier than the handling of the initcalls.
>>
>> So instead, move the initialization performed by the initcall into
>> efi_mem_reserve_persistent() itself.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> ---
>>  drivers/firmware/efi/efi.c | 26 ++++++++++----------------
>>  1 file changed, 10 insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
>> index fad7c62cfc0e..40de2f6734cc 100644
>> --- a/drivers/firmware/efi/efi.c
>> +++ b/drivers/firmware/efi/efi.c
>> @@ -967,15 +967,23 @@ bool efi_is_table_address(unsigned long phys_addr)
>>  }
>>
>>  static DEFINE_SPINLOCK(efi_mem_reserve_persistent_lock);
>> -static struct linux_efi_memreserve *efi_memreserve_root __ro_after_init;
>> +static struct linux_efi_memreserve *efi_memreserve_root;
>>
>>  int efi_mem_reserve_persistent(phys_addr_t addr, u64 size)
>>  {
>>         struct linux_efi_memreserve *rsv;
>>
>> -       if (!efi_memreserve_root)
>> +       if (efi.mem_reserve == EFI_INVALID_TABLE_ADDR)
>>                 return -ENODEV;
>>
>> +       if (!efi_memreserve_root) {
>> +               efi_memreserve_root = memremap(efi.mem_reserve,
>> +                                              sizeof(*efi_memreserve_root),
>> +                                              MEMREMAP_WB);
>> +               if (WARN_ON_ONCE(!efi_memreserve_root))
>> +                       return -ENOMEM;
>> +       }
>> +
>>         rsv = kmalloc(sizeof(*rsv), GFP_ATOMIC);
>>         if (!rsv)
>>                 return -ENOMEM;
>> @@ -991,20 +999,6 @@ int efi_mem_reserve_persistent(phys_addr_t addr, u64 size)
>>         return 0;
>>  }
>>
>> -static int __init efi_memreserve_root_init(void)
>> -{
>> -       if (efi.mem_reserve == EFI_INVALID_TABLE_ADDR)
>> -               return -ENODEV;
>> -
>> -       efi_memreserve_root = memremap(efi.mem_reserve,
>> -                                      sizeof(*efi_memreserve_root),
>> -                                      MEMREMAP_WB);
>> -       if (!efi_memreserve_root)
>> -               return -ENOMEM;
>> -       return 0;
>> -}
>> -early_initcall(efi_memreserve_root_init);
>> -
>>  #ifdef CONFIG_KEXEC
>>  static int update_efi_random_seed(struct notifier_block *nb,
>>                                   unsigned long code, void *unused)
>> --
>> 2.17.1
>
> Hi Ard,
>
> thanks for the patch, it works fine for me.
>
> If you want:
> Tested-by: Jan Glauber <jglauber@cavium.com>

FWIW, the splat is gone:

Tested-by: John Garry <john.garry@huawei.com>

>
> --Jan
>
>
