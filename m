From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH] efi/fdt: Indentation fix
Date: Mon, 29 Oct 2018 09:45:44 +0000
Message-ID: <d7d0641b-f2a5-a51b-f52e-3db3b873f209@arm.com>
References: <1538389776-8432-1-git-send-email-julien.thierry@arm.com>
 <61d7bd590527166c58670b4c0ab65a08710f81cf.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <61d7bd590527166c58670b4c0ab65a08710f81cf.camel@perches.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>, linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

Hi Joe,

On 02/10/18 17:05, Joe Perches wrote:
> On Mon, 2018-10-01 at 11:29 +0100, Julien Thierry wrote:
>> Closing bracket seems to end a for statement when it is actually ending
>> the contained if.
>>
>> No functional change/fix, just fix the indentation.
> []
>> diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
> []
>> @@ -381,7 +381,7 @@ void *get_fdt(efi_system_table_t *sys_table, unsigned long *fdt_size)
>>   			}
>>   			*fdt_size = fdt_totalsize(fdt);
>>   			break;
>> -	 }
>> +		}
>>
>>   	return fdt;
>>   }
> 
> Hello Julian.
> 
> [trivial style bikeshedding follows]
> 
> I think it better to add braces to the for loop so
> this stands out better.
> 
> Also, I would generally write this so the if test is
> reversed and uses a continue so the match block saves
> an indent level.
> 
> This is the only use efi_guidcmp with a == test in
> drivers/firmware, so perhaps remove that and use ! as
> the other uses have no == or != test.
> 
> Lastly, a direct return might be better and the return
> fdt could be removed and converted to return NULL.
> 

The suggestions make sense, I'll respin this taking your remarks into 
account.

Thanks,

> Something like:
> ---
>   drivers/firmware/efi/libstub/fdt.c | 29 +++++++++++++++--------------
>   1 file changed, 15 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
> index 8830fa601e45..2d0b895e2f67 100644
> --- a/drivers/firmware/efi/libstub/fdt.c
> +++ b/drivers/firmware/efi/libstub/fdt.c
> @@ -366,22 +366,23 @@ void *get_fdt(efi_system_table_t *sys_table, unsigned long *fdt_size)
>   {
>   	efi_guid_t fdt_guid = DEVICE_TREE_GUID;
>   	efi_config_table_t *tables;
> -	void *fdt;
>   	int i;
>   
> -	tables = (efi_config_table_t *) sys_table->tables;
> -	fdt = NULL;
> +	tables = (efi_config_table_t *)sys_table->tables;
>   
> -	for (i = 0; i < sys_table->nr_tables; i++)
> -		if (efi_guidcmp(tables[i].guid, fdt_guid) == 0) {
> -			fdt = (void *) tables[i].table;
> -			if (fdt_check_header(fdt) != 0) {
> -				pr_efi_err(sys_table, "Invalid header detected on UEFI supplied FDT, ignoring ...\n");
> -				return NULL;
> -			}
> -			*fdt_size = fdt_totalsize(fdt);
> -			break;
> -	 }
> +	for (i = 0; i < sys_table->nr_tables; i++) {
> +		void *fdt;
> +
> +		if (efi_guidcmp(tables[i].guid, fdt_guid))
> +			continue;
> +		fdt = (void *)tables[i].table;
> +		if (fdt_check_header(fdt) != 0) {
> +			pr_efi_err(sys_table, "Invalid header detected on UEFI supplied FDT, ignoring ...\n");
> +			return NULL;
> +		}
> +		*fdt_size = fdt_totalsize(fdt);
> +		return fdt;
> +	}
>   
> -	return fdt;
> +	return NULL;
>   }
> 
> 

-- 
Julien Thierry
