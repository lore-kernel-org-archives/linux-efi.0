From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v5 14/32] efi: Add an EFI table address match function
Date: Tue, 16 May 2017 16:53:33 -0500
Message-ID: <2364b148-5168-1583-51c2-0beaa7230235@amd.com>
References: <20170418211612.10190.82788.stgit@tlendack-t1.amdoffice.net>
 <20170418211848.10190.65062.stgit@tlendack-t1.amdoffice.net>
 <20170515180913.lhma7xw52irrdtvr@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170515180913.lhma7xw52irrdtvr@pd.tnic>
Sender: owner-linux-mm@kvack.org
To: Borislav Petkov <bp@alien8.de>
Cc: linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, x86@kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, iommu@lists.linux-foundation.org, Rik van Riel <riel@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Toshimitsu Kani <toshi.kani@hpe.com>, Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, "Michael S.
 Tsirkin" <mst@redhat.com>, Joerg Roedel <joro@8bytes.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, Larry Woodman <lwoodman@redhat.com>, Brijesh Singh <brijesh.singh@amd.com>, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@kernel.org>, "H. Peter
 Anvin" <hpa@zytor.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>
List-Id: linux-efi@vger.kernel.org

On 5/15/2017 1:09 PM, Borislav Petkov wrote:
> On Tue, Apr 18, 2017 at 04:18:48PM -0500, Tom Lendacky wrote:
>> Add a function that will determine if a supplied physical address matches
>> the address of an EFI table.
>>
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> ---
>>  drivers/firmware/efi/efi.c |   33 +++++++++++++++++++++++++++++++++
>>  include/linux/efi.h        |    7 +++++++
>>  2 files changed, 40 insertions(+)
>>
>> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
>> index b372aad..8f606a3 100644
>> --- a/drivers/firmware/efi/efi.c
>> +++ b/drivers/firmware/efi/efi.c
>> @@ -55,6 +55,25 @@ struct efi __read_mostly efi = {
>>  };
>>  EXPORT_SYMBOL(efi);
>>
>> +static unsigned long *efi_tables[] = {
>> +	&efi.mps,
>> +	&efi.acpi,
>> +	&efi.acpi20,
>> +	&efi.smbios,
>> +	&efi.smbios3,
>> +	&efi.sal_systab,
>> +	&efi.boot_info,
>> +	&efi.hcdp,
>> +	&efi.uga,
>> +	&efi.uv_systab,
>> +	&efi.fw_vendor,
>> +	&efi.runtime,
>> +	&efi.config_table,
>> +	&efi.esrt,
>> +	&efi.properties_table,
>> +	&efi.mem_attr_table,
>> +};
>> +
>>  static bool disable_runtime;
>>  static int __init setup_noefi(char *arg)
>>  {
>> @@ -854,6 +873,20 @@ int efi_status_to_err(efi_status_t status)
>>  	return err;
>>  }
>>
>> +bool efi_table_address_match(unsigned long phys_addr)
>
> efi_is_table_address() reads easier/better in the code.

Will do.

Thanks,
Tom

>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
