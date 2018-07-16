From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH] x86/efi: Access EFI MMIO data as unencrypted when SEV is
 active
Date: Mon, 16 Jul 2018 14:15:32 -0500
Message-ID: <3b48a62e-8a5c-3e83-2935-03c9ab011403@amd.com>
References: <1530624720-32004-1-git-send-email-brijesh.singh@amd.com>
 <CAKv+Gu_3kD+7O4oR9751VH2CsG=+NmBY-Gypc25LFo9eT6m3RQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu_3kD+7O4oR9751VH2CsG=+NmBY-Gypc25LFo9eT6m3RQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: brijesh.singh@amd.com, the arch/x86 maintainers <x86@kernel.org>, linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@suse.de>, KVM devel mailing list <kvm@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Andy Lutomirski <luto@kernel.org>, "# 4 . 15 . x" <stable@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

Hi Ard,


On 07/11/2018 05:00 AM, Ard Biesheuvel wrote:
> On 3 July 2018 at 15:32, Brijesh Singh <brijesh.singh@amd.com> wrote:
>> SEV guest fails to update the UEFI runtime variables stored in the
>> flash. commit 1379edd59673 ("x86/efi: Access EFI data as encrypted
>> when SEV is active") unconditionally maps all the UEFI runtime data
>> as 'encrypted' (C=1). When SEV is active the UEFI runtime data marked
>> as EFI_MEMORY_MAPPED_IO should be mapped as 'unencrypted' so that both
>> guest and hypervisor can access the data.
>>
>> Fixes: 1379edd59673 (x86/efi: Access EFI data as encrypted ...)
>> Cc: Tom Lendacky <thomas.lendacky@amd.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Borislav Petkov <bp@suse.de>
>> Cc: linux-efi@vger.kernel.org
>> Cc: kvm@vger.kernel.org
>> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> Cc: Matt Fleming <matt@codeblueprint.co.uk>
>> Cc: Andy Lutomirski <luto@kernel.org>
>> Cc: <stable@vger.kernel.org> # 4.15.x
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> ---
>>   arch/x86/platform/efi/efi_64.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
>> index 77873ce..5f2eb32 100644
>> --- a/arch/x86/platform/efi/efi_64.c
>> +++ b/arch/x86/platform/efi/efi_64.c
>> @@ -417,7 +417,7 @@ static void __init __map_region(efi_memory_desc_t *md, u64 va)
>>          if (!(md->attribute & EFI_MEMORY_WB))
>>                  flags |= _PAGE_PCD;
>>
>> -       if (sev_active())
>> +       if (sev_active() && md->type != EFI_MEMORY_MAPPED_IO)
>>                  flags |= _PAGE_ENC;
>>
>>          pfn = md->phys_addr >> PAGE_SHIFT;
> 
> Is it safe to only update this occurrence and not the one in
> efi_runtime_update_mappings() ?
> 


It's safe to update this occurrence only. The SEV support is added
in recent EDK2 bios, and the version of bios provides the
EFI_MEMORY_ATTRIBUTE_TABLE. Hence the efi_enabled(EFI_MEM_ATTR) check in 
efi_runtime_update_mappings() will always be true. When EFI_MEM_ATTR is
set the code updates the mapping and returns (see below)

void __init efi_runtime_update_mappings(void)
{
    .....
    .....

    /*
     * Use the EFI Memory Attribute Table for mapping permissions if it
     * exists, since it is intended to supersede EFI_PROPERTIES_TABLE.
     */
     if (efi_enabled(EFI_MEM_ATTR)) {
	efi_memattr_apply_permissions(NULL, efi_update_mem_attr);
	return;
     }


    ...

}

The EFI_MEMORY_ATTRIBUTE_TABLE table does not include MMIO regions, the
table describes the memory protections to EFI runtime code and data
regions only. Both EFI runtime code and data should be mapped as
encrypted. Hence I skipped updating the efi_runtime_update_mappings().


thanks
