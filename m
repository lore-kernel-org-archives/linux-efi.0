From: Arend van Spriel <arend.vanspriel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] firmware: efi: add NULL pointer checks in efivars api
 functions
Date: Wed, 14 Nov 2018 00:04:10 +0100
Message-ID: <524197b4-4f2b-00d6-2509-22ed4b3b3f5d@broadcom.com>
References: <1542142278-14352-1-git-send-email-arend.vanspriel@broadcom.com>
 <CAKv+Gu8FK7=gcRVg--GX3LMA9fmGtvMkxDuXF8UEWuGpKq4HTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu8FK7=gcRVg--GX3LMA9fmGtvMkxDuXF8UEWuGpKq4HTA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "<linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>" <linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kalle Valo <kvalo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 11/13/2018 11:50 PM, Ard Biesheuvel wrote:
> Hi Arend,
>
> On Tue, 13 Nov 2018 at 12:51, Arend van Spriel
> <arend.vanspriel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org> wrote:
>>
>> Since commit ce2e6db554fa ("brcmfmac: Add support for getting nvram
>> contents from EFI variables") we have a device driver accessing the
>> efivars api (since next-20181107). Several functions in efivars api
>> assume __efivars is set, ie. will be accessed after efivars_register()
>> has been called. However, following NULL pointer access was reported
>> calling efivar_entry_size() from the brcmfmac device driver.
>>
>> [   14.177769] Unable to handle kernel NULL pointer dereference at
>>                 virtual address 00000008
>> [   14.197303] pgd = 60bfa5f1
>> [   14.211842] [00000008] *pgd=00000000
>> [   14.227373] Internal error: Oops: 5 [#1] SMP ARM
>> [   14.244244] Modules linked in: brcmfmac sha256_generic sha256_arm snd cfg80211 brcmutil soundcore snd_soc_tegra30_ahub tegra_wdt
>> [   14.269109] CPU: 1 PID: 114 Comm: kworker/1:2 Not tainted 4.20.0-rc1-next-20181107-gd881de3 #1
>> [   14.269114] Hardware name: NVIDIA Tegra SoC (Flattened Device Tree)
>> [   14.269154] Workqueue: events request_firmware_work_func
>> [   14.269177] PC is at efivar_entry_size+0x28/0x90
>> [   14.269362] LR is at brcmf_fw_complete_request+0x3f8/0x8d4 [brcmfmac]
>> [   14.269369] pc : [<c0c40718>]    lr : [<bf2a3ef4>]    psr: a00d0113
>> [   14.269374] sp : ede7fe28  ip : ee983410  fp : c1787f30
>> [   14.269378] r10: 00000000  r9 : 00000000  r8 : bf2b2258
>> [   14.269384] r7 : ee983000  r6 : c1604c48  r5 : ede7fe88  r4 : edf337c0
>> [   14.269389] r3 : 00000000  r2 : 00000000  r1 : ede7fe88  r0 : c17712c8
>> [   14.269398] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
>> [   14.269404] Control: 10c5387d  Table: ad16804a  DAC: 00000051
>>
>> Disassembly showed that the local static variable __efivars is NULL. Likely
>> because efivars_register() is not called on this Tegra platform. So adding
>> a NULL pointer check in efivar_entry_size() and similar functions while at
>> it. In efivars_register() a couple of sanity checks have been added.
>>
>> Cc: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Reported-by: Jon Hunter <jonathanh-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: Arend van Spriel <arend.vanspriel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>> ---
>>  drivers/firmware/efi/vars.c | 108 +++++++++++++++++++++++++++++++++++---------
>>  1 file changed, 87 insertions(+), 21 deletions(-)
>>
>> diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
>> index 9336ffd..5fbd8e7 100644
>> --- a/drivers/firmware/efi/vars.c
>> +++ b/drivers/firmware/efi/vars.c
>> @@ -318,7 +318,12 @@ struct variable_validate {
>>  static efi_status_t
>>  check_var_size(u32 attributes, unsigned long size)
>>  {
>> -       const struct efivar_operations *fops = __efivars->ops;
>> +       const struct efivar_operations *fops;
>> +
>> +       if (!__efivars)
>> +               return EFI_UNSUPPORTED;
>> +
>> +       fops = __efivars->ops;
>>
>>         if (!fops->query_variable_store)
>>                 return EFI_UNSUPPORTED;
>> @@ -329,7 +334,12 @@ struct variable_validate {
>>  static efi_status_t
>>  check_var_size_nonblocking(u32 attributes, unsigned long size)
>>  {
>> -       const struct efivar_operations *fops = __efivars->ops;
>> +       const struct efivar_operations *fops;
>> +
>> +       if (!__efivars)
>> +               return EFI_UNSUPPORTED;
>> +
>> +       fops = __efivars->ops;
>>
>>         if (!fops->query_variable_store)
>>                 return EFI_UNSUPPORTED;
>> @@ -429,13 +439,18 @@ static void dup_variable_bug(efi_char16_t *str16, efi_guid_t *vendor_guid,
>>  int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
>>                 void *data, bool duplicates, struct list_head *head)
>>  {
>> -       const struct efivar_operations *ops = __efivars->ops;
>> +       const struct efivar_operations *ops;
>>         unsigned long variable_name_size = 1024;
>>         efi_char16_t *variable_name;
>>         efi_status_t status;
>>         efi_guid_t vendor_guid;
>>         int err = 0;
>>
>> +       if (!__efivars)
>> +               return -EFAULT;
>> +
>> +       ops = __efivars->ops;
>> +
>>         variable_name = kzalloc(variable_name_size, GFP_KERNEL);
>>         if (!variable_name) {
>>                 printk(KERN_ERR "efivars: Memory allocation failed.\n");
>> @@ -583,12 +598,14 @@ static void efivar_entry_list_del_unlock(struct efivar_entry *entry)
>>   */
>>  int __efivar_entry_delete(struct efivar_entry *entry)
>>  {
>> -       const struct efivar_operations *ops = __efivars->ops;
>>         efi_status_t status;
>>
>> -       status = ops->set_variable(entry->var.VariableName,
>> -                                  &entry->var.VendorGuid,
>> -                                  0, 0, NULL);
>> +       if (!__efivars)
>> +               return -EINVAL;
>> +
>> +       status = __efivars->ops->set_variable(entry->var.VariableName,
>> +                                             &entry->var.VendorGuid,
>> +                                             0, 0, NULL);
>>
>>         return efi_status_to_err(status);
>>  }
>> @@ -607,12 +624,17 @@ int __efivar_entry_delete(struct efivar_entry *entry)
>>   */
>>  int efivar_entry_delete(struct efivar_entry *entry)
>>  {
>> -       const struct efivar_operations *ops = __efivars->ops;
>> +       const struct efivar_operations *ops;
>>         efi_status_t status;
>>
>>         if (down_interruptible(&efivars_lock))
>>                 return -EINTR;
>>
>
> Any reason in particular you put the check after the lock is taken? Is
> this to ensure that __efivars does not change under your feet?

That was my reasoning although I am not sure if that is likely. Is 
efivars_register() always called before any drivers are started?

Regards,
Arend
