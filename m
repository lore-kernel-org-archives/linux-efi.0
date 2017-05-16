From: "Baicar, Tyler" <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH V16 08/11] efi: print unrecognized CPER section
Date: Tue, 16 May 2017 10:44:43 -0600
Message-ID: <5a4a5b58-3e31-9fa5-091d-bb63437da9ab@codeaurora.org>
References: <1494883680-25551-1-git-send-email-tbaicar@codeaurora.org>
 <1494883680-25551-9-git-send-email-tbaicar@codeaurora.org>
 <20170516142927.guxwc3gdgpqshpks@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170516142927.guxwc3gdgpqshpks-fF5Pk5pvG8Y@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, nkaje-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, james.morse-5wv7dgnIgG8@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, eun.taik.lee-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, sandeepa.s.prabhu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, shijie.huang-5wv7dgnIgG8@public.gmane.org, rruigrok-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org, tn-nYOzD4b6Jr9Wk0Htik3J/w@public.gmane.org, fu.wei-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 5/16/2017 8:29 AM, Borislav Petkov wrote:
> On Mon, May 15, 2017 at 03:27:57PM -0600, Tyler Baicar wrote:
>> UEFI spec allows for non-standard section in Common Platform Error
>> Record. This is defined in section N.2.3 of UEFI version 2.5.
>>
>> Currently if the CPER section's type (UUID) does not match with
>> one of the section types that the kernel knows how to parse, the
>> section is skipped. Therefore, user is not able to see
>> such CPER data, for instance, error record of non-standard section.
>>
>> This change prints out the raw data in hex in the dmesg buffer so
>> that non-standard sections are reported to the user. Non-standard
>> section type errors should be reported to the user because these
>> can include errors which are vendor specific. The data length is
>> taken from Error Data length field of Generic Error Data Entry.
>>
>> The following is a sample output from dmesg:
>> [  140.739180] {1}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 2
>> [  140.739182] {1}[Hardware Error]: It has been corrected by h/w and requires no further action
>> [  140.739191] {1}[Hardware Error]: event severity: corrected
>> [  140.739196] {1}[Hardware Error]:  time: precise 2017-03-15 20:37:35
>> [  140.739197] {1}[Hardware Error]:  Error 0, type: corrected
>> [  140.739203] {1}[Hardware Error]:   section type: unknown, d2e2621c-f936-468d-0d84-15a4ed015c8b
>> [  140.739205] {1}[Hardware Error]:   section length: 0x238
>> [  140.739210] {1}[Hardware Error]:   00000000: 4d415201 4d492031 453a4d45 435f4343  .RAM1 IMEM:ECC_C
>> [  140.739214] {1}[Hardware Error]:   00000010: 53515f45 44525f42 00000000 00000000  E_QSB_RD........
>> [  140.739217] {1}[Hardware Error]:   00000020: 00000000 00000000 00000000 00000000  ................
>> [  140.739220] {1}[Hardware Error]:   00000030: 00000000 00000000 01010000 01010000  ................
>> [  140.739223] {1}[Hardware Error]:   00000040: 00000000 00000000 00000005 00000000  ................
>> [  140.739226] {1}[Hardware Error]:   00000050: 01010000 00000000 00000001 00dddd00  ................
> Let me repeat myself from the last time:
>
> "Kill all those prefixes:
>
> " Hardware error from APEI Generic Hardware Error Source: 2
>    It has been corrected by h/w and requires no further action
>    event severity: corrected
>     time: precise 2017-03-15 20:37:35
>     Error 0, type: corrected
>      section type: unknown, d2e2621c-f936-468d-0d84-15a4ed015c8b
>      section length: 568 (0x238)
>      00000000: 4d415201 4d492031 453a4d45 435f4343  .RAM1 IMEM:ECC_C
>      00000010: 53515f45 44525f42 00000000 00000000  E_QSB_RD........
>      00000020: 00000000 00000000 00000000 00000000  ................
>      00000030: 00000000 00000000 01010000 01010000  ................
>      00000040: 00000000 00000000 00000005 00000000  ................
>      00000050: 01010000 00000000 00000001 00dddd00  ................
> "
>
> to the important info only."
Hello Boris,

I meant to respond to this comment after I sent the v16 patch series, 
but you beat me to it :)

These prefixes are common to all the GHES/CPER printing to the kernel 
logs. The first value here '{1}' is an increment based on the number of 
error records that have been printed during the current boot. This value 
can be very helpful when trying to parse the log which could have 
hundreds or thousands of these errors. Just yesterday I saw a log with 
~250 records printed. It was a lot easier to see that incremented number 
and know how many were in the log than to actually parse the log to 
count that information.

The '[Hardware Error]' print I could see doing away with, but it does 
actually have value when you're looking through the logs. It helps these 
errors stand out especially to people who aren't looking for them. These 
hardware errors shouldn't be happening, so it makes sense for them to 
stand out in the logs. And it also helps to find all these records in a 
log that could be littered with a lot of other prints. I find myself 
doing "dmesg | grep 'Hardware error'" all the time.

Hopefully that is enough justification to keep these. If not, then I can 
add a separate patch in this series to remove them.

Thanks,
Tyler

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
