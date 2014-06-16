From: Juergen Gross <jgross@suse.com>
Subject: Re: [Xen-devel] [PATCH v5 7/7] arch/x86: Comment out efi_set_rtc_mmss()
Date: Mon, 16 Jun 2014 13:54:17 +0200
Message-ID: <539EDAE9.7000605@suse.com>
References: <1402678823-24589-1-git-send-email-daniel.kiper@oracle.com>	<1402678823-24589-8-git-send-email-daniel.kiper@oracle.com> <alpine.DEB.2.02.1406161242050.13771@kaball.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1406161242050.13771@kaball.uk.xensource.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>, Daniel Kiper <daniel.kiper@oracle.com>
Cc: mjg59@srcf.ucam.org, jeremy@goop.org, linux-efi@vger.kernel.org, ian.campbell@citrix.com, andrew.cooper3@citrix.com, x86@kernel.org, linux-kernel@vger.kernel.org, matt.fleming@intel.com, tglx@linutronix.de, david.vrabel@citrix.com, jbeulich@suse.com, hpa@zytor.com, xen-devel@lists.xenproject.org, boris.ostrovsky@oracle.com, mingo@redhat.com, eshelton@pobox.com
List-Id: linux-efi@vger.kernel.org

On 06/16/2014 01:43 PM, Stefano Stabellini wrote:
> On Fri, 13 Jun 2014, Daniel Kiper wrote:
>> efi_set_rtc_mmss() is never used to set RTC due to bugs found
>> on many EFI platforms. It is set directly by mach_set_rtc_mmss().
>>
>> Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
>> ---
>>   arch/x86/platform/efi/efi.c |    6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
>> index deb4f05..bd3e080 100644
>> --- a/arch/x86/platform/efi/efi.c
>> +++ b/arch/x86/platform/efi/efi.c
>> @@ -244,6 +244,11 @@ static efi_status_t __init phys_efi_set_virtual_address_map(
>>   	return status;
>>   }
>>
>> +#if 0
>> +/*
>> + * efi_set_rtc_mmss() is never used to set RTC due to bugs found
>> + * on many EFI platforms. It is set directly by mach_set_rtc_mmss().
>> + */
>>   int efi_set_rtc_mmss(const struct timespec *now)
>>   {
>>   	unsigned long nowtime = now->tv_sec;
>> @@ -279,6 +284,7 @@ int efi_set_rtc_mmss(const struct timespec *now)
>>   	}
>>   	return 0;
>>   }
>> +#endif
>
> "Commenting out" code like that is not a good idea: it leaves
> dead-rotting functions in the middle of your source file.
>
> If the function is not used, just go ahead and remove it. We can use git
> to get it back.

And shouldn't it be removed from include/linux/efi.h as well?

Juergen
