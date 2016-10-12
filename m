From: "Baicar, Tyler" <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH V3 02/10] ras: acpi/apei: cper: generic error data entry
 v3 per ACPI 6.1
Date: Wed, 12 Oct 2016 16:18:58 -0600
Message-ID: <dfdf5c92-52a7-a641-42aa-c230f5ebc0b2@codeaurora.org>
References: <1475875882-2604-1-git-send-email-tbaicar@codeaurora.org>
 <1475875882-2604-3-git-send-email-tbaicar@codeaurora.org>
 <20161011185236.GC1041@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161011185236.GC1041-l+eeeJia6m9URfEZ8mYm6t73F7V6hmMc@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Russell King - ARM Linux <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>
Cc: christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, james.morse-5wv7dgnIgG8@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, sandeepa.s.prabhu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shijie.huang-5wv7dgnIgG8@public.gmane.org, paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org, tomasz.nowicki-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, fu.wei-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, Dkvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-E0kO6a4B6psdnm+yROfE0A@public.gmane.org, "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Richard Ruigrok <rruigrok-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Naveen
List-Id: linux-efi@vger.kernel.org

Hello Russell,

Thank you for the feedback! Responses below


On 10/11/2016 12:52 PM, Russell King - ARM Linux wrote:
> On Fri, Oct 07, 2016 at 03:31:14PM -0600, Tyler Baicar wrote:
>> +static void cper_estatus_print_section_v300(const char *pfx,
>> +	const struct acpi_hest_generic_data_v300 *gdata)
>> +{
>> +	__u8 hour, min, sec, day, mon, year, century, *timestamp;
>> +
>> +	if (gdata->validation_bits & ACPI_HEST_GEN_VALID_TIMESTAMP) {
>> +		timestamp = (__u8 *)&(gdata->time_stamp);
>> +		memcpy(&sec, timestamp, 1);
>> +		memcpy(&min, timestamp + 1, 1);
>> +		memcpy(&hour, timestamp + 2, 1);
>> +		memcpy(&day, timestamp + 4, 1);
>> +		memcpy(&mon, timestamp + 5, 1);
>> +		memcpy(&year, timestamp + 6, 1);
>> +		memcpy(&century, timestamp + 7, 1);
> This is utterly silly.  Why are you using memcpy() to access individual
> bytes of a u8 pointer?  What's wrong with:
>
> 		sec = timestamp[0];
> 		min = timestamp[1];
> 		hour = timestamp[2];
> 		day = timestamp[4];
> 		mon = timestamp[5];
> 		year = timestamp[6];
> 		century = timestamp[7];
>
> or even do the conversion here:
>
> 		sec = bcd2bin(timestamp[0]);
> ... etc ...
Yes, that will be a lot cleaner especially with moving the conversion here.
>
>> +		printk("%stime: ", pfx);
>> +		printk("%7s", 0x01 & *(timestamp + 3) ? "precise" : "");
>> +		printk(" %02d:%02d:%02d %02d%02d-%02d-%02d\n",
>> +			bcd2bin(hour), bcd2bin(min), bcd2bin(sec),
>> +			bcd2bin(century), bcd2bin(year), bcd2bin(mon),
>> +			bcd2bin(day));
>> +	}
> It's also a good idea to (as much as possible) keep to single printk()
> statements - which makes the emission of the string more atomic wrt
> other CPUs and contexts.  So, this should probably become (with the
> conversion being done at the assignment of sec etc):
>
> 		printk("%stime: %7s %02d:%02d:%02d %02d%02d-%02d-%02d\n",
> 			pfx, 0x01 & timestamp[3] ? "precise" : "",
> 			hour, min, sec, century, year, mon, day);
>
> which, IMHO, looks a lot nicer and doesn't risk some other printk()
> getting between each individual part of the line.
I will make this change in the next version. This printk does look a lot 
nicer and avoids other prints from getting in the middle (I actually 
just saw that happen in testing a couple days ago)
>> +}
>> +
>>   static void cper_estatus_print_section(
>> -	const char *pfx, const struct acpi_hest_generic_data *gdata, int sec_no)
>> +	const char *pfx, struct acpi_hest_generic_data *gdata, int sec_no)
>>   {
>>   	uuid_le *sec_type = (uuid_le *)gdata->section_type;
>>   	__u16 severity;
>>   	char newpfx[64];
>>   
>> +	if ((gdata->revision >> 8) >= 0x03)
>> +		cper_estatus_print_section_v300(pfx,
>> +			(const struct acpi_hest_generic_data_v300 *)gdata);
>> +
>>   	severity = gdata->error_severity;
>>   	printk("%s""Error %d, type: %s\n", pfx, sec_no,
>>   	       cper_severity_str(severity));
> Not sure why you have the "" here - %sError works just as well and the
> "" is just obfuscation - the compiler will eliminate the double-double
> quote and merge the strings anyway.
>
I will remove the "" in the next version.

Thanks,
Tyler

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
