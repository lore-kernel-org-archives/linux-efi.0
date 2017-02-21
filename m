From: "Baicar, Tyler" <tbaicar@codeaurora.org>
Subject: Re: [PATCH V10 07/10] efi: print unrecognized CPER section
Date: Tue, 21 Feb 2017 12:39:28 -0700
Message-ID: <9b8aee3f-9ab6-121a-cad0-96a39743de55@codeaurora.org>
References: <1487188282-2568-1-git-send-email-tbaicar@codeaurora.org>
 <1487188282-2568-8-git-send-email-tbaicar@codeaurora.org>
 <58AC9093.5020303@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <58AC9093.5020303@arm.com>
Sender: linux-acpi-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, nkaje@codeaurora.org, zjzhang@codeaurora.org, mark.rutland@arm.com, akpm@linux-foundation.org, eun.taik.lee@samsung.com, sandeepa.s.prabhu@gmail.com, labbott@redhat.com, shijie.huang@arm.com, rruigrok@codeaurora.org, paul.gortmaker@windriver.com, tn@semihalf.com, fu.wei@linaro.org, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, devel@acpica.org, Suzuki.Po
List-Id: linux-efi@vger.kernel.org

Hello James,


On 2/21/2017 12:10 PM, James Morse wrote:
> Hi Tyler,
>
> On 15/02/17 19:51, Tyler Baicar wrote:
>> UEFI spec allows for non-standard section in Common Platform Error
>> Record. This is defined in section N.2.3 of UEFI version 2.5.
>>
>> Currently if the CPER section's type (UUID) does not match with
>> one of the section types that the kernel knows how to parse, the
>> section is skipped. Therefore, user is not able to see
>> such CPER data, for instance, error record of non-standard section.
>>
>> For above mentioned case, this change prints out the raw data in
>> hex in dmesg buffer. Data length is taken from Error Data length
>> field of Generic Error Data Entry.
>>
>> Following is a sample output from dmesg:
>> [  115.771702] {1}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 2
>> [  115.779042] {1}[Hardware Error]: It has been corrected by h/w and requires no further action
>> [  115.787456] {1}[Hardware Error]: event severity: corrected
>> [  115.792927] {1}[Hardware Error]:  Error 0, type: corrected
>> [  115.798415] {1}[Hardware Error]:  fru_id: 00000000-0000-0000-0000-000000000000
>> [  115.805596] {1}[Hardware Error]:  fru_text:
>> [  115.816105] {1}[Hardware Error]:  section type: d2e2621c-f936-468d-0d84-15a4ed015c8b
>> [  115.823880] {1}[Hardware Error]:  section length: 88
>> [  115.828779] {1}[Hardware Error]:   00000000: 01000001 00000002 5f434345 525f4543
>> [  115.836153] {1}[Hardware Error]:   00000010: 0000574d 00000000 00000000 00000000
>> [  115.843531] {1}[Hardware Error]:   00000020: 00000000 00000000 00000000 00000000
>> [  115.850908] {1}[Hardware Error]:   00000030: 00000000 00000000 00000000 00000000
>> [  115.858288] {1}[Hardware Error]:   00000040: fe800000 00000000 00000004 5f434345
>> [  115.865665] {1}[Hardware Error]:   00000050: 525f4543 0000574d
> The use-case for this is to capture the data and decode it with a vendor tool?
> (if so, please mention that in the commit message!)
Yes, that is the intention here. I will add that to the commit message.
>> diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
>> index c2b0a12..48cb8ee 100644
>> --- a/drivers/firmware/efi/cper.c
>> +++ b/drivers/firmware/efi/cper.c
>> @@ -591,8 +591,16 @@ static void cper_estatus_print_section(
>>   			cper_print_proc_arm(newpfx, arm_err);
>>   		else
>>   			goto err_section_too_small;
>> -	} else
>> -		printk("%s""section type: unknown, %pUl\n", newpfx, sec_type);
> Nit: Its odd that you remove the 'unknown' from this, but we don't get told what
> it is, so surely its still unknown.
>
I'll add the unknown print back in.
>> +	} else {
>> +		const void *unknown_err;
>> +
>> +		unknown_err = acpi_hest_generic_data_payload(gdata);
>> +		printk("%ssection type: %pUl\n", newpfx, sec_type);
>> +		printk("%ssection length: %d\n", newpfx,
> Nit: please use the "%s""section... that this file consistently uses. This means
> this code will still work as expected when someone adds '%ss' support to printk!
Will do.
>> +		       gdata->error_data_length);
>> +		print_hex_dump(newpfx, "", DUMP_PREFIX_OFFSET, 16, 4,
>> +			       unknown_err, gdata->error_data_length, 0);
>> +	}
>>   
>>   	return;
>
> FWIW:
> Reviewed-by: James Morse <james.morse@arm.com>
Thanks!
Tyler

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.

