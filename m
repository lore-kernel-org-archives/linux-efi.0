From: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2 0/7] efi: Enhance capsule loader to support signed
 Quark images
Date: Mon, 27 Mar 2017 13:01:38 +0200
Message-ID: <7cff4583-d417-7107-80a3-34eb63d43be1@siemens.com>
References: <cover.1490376860.git.jan.kiszka@siemens.com>
 <d3c887cb-fede-bfc6-8b1d-a6dca262b5bc@nexus-software.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <d3c887cb-fede-bfc6-8b1d-a6dca262b5bc-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hock Leong Kweh <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Sascha Weisenberger <sascha.weisenberger-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 2017-03-27 12:29, Bryan O'Donoghue wrote:
> 
> 
> On 24/03/17 17:34, Jan Kiszka wrote:
>> This addresses the review feedback provided on round 1, specifically
>> - refactored queue to keep the Quark mess in
>> - only check for CSH on Quark CPUs
>> - added some smaller cleanups of the capsule loader
>> - documented capsule header / linked to original code
>>
>> See last patch for the background of the series.
>>
>> The series has been tested on the Galileo Gen2, to exclude regressions,
>> with a firmware.cap with AND without security header and the SIMATIC
>> IOT2040 which requires the header because of its mandatory secure boot.
>>
>> Jan
>>
>> Jan Kiszka (7):
>>   efi/capsule: Fix return code on failing kmap/vmap
>>   efi/capsule: Remove pr_debug on ENOMEM or EFAULT
>>   efi/capsule: Clean up pr_err/info messages
>>   efi/capsule: Adjust return type of efi_capsule_setup_info
>>   efi/capsule: Prepare for loading images with security header
>>   efi/capsule: Factor out overloadable efi_capsule_identify_image
>>   efi/capsule: Add support for Quark security header
>>
>>  arch/x86/platform/efi/quirks.c        |  95 ++++++++++++++++++++++++
>>  drivers/firmware/efi/capsule-loader.c | 136
>> +++++++++++++++++++---------------
>>  drivers/firmware/efi/capsule.c        |  21 +++++-
>>  include/linux/efi.h                   |  19 +++++
>>  4 files changed, 208 insertions(+), 63 deletions(-)
>>
> 
> BTW,
> 
> Thanks for taking the time to remove the __func__ stuff all over the place.
> 
> I'll try to test this out for you. I found that the current BSP Intel is
> releasing has some sort of GUI that downloads an image to a board (which
> completely fails for me on the Galileo I have)... not sure if you have
> different results with the stuff from the Intel website but it's
> non-functional for me :(

I found the Galileo capsules *.cap in the jar archives of the Galileo
firmware update packages, and they work.
> 
> I'd like to suggest to you adding something to Documentation describing
> how to load and trigger a capsule update. For example on Quark you need
> to use the EFI reset method to cause capsule update to work.

cat /path/to/capsule.cap > /dev/efi_capsule_loader

The reset method is auto-adjusted by the kernel when an update is
pending. So firmware update is now seriously simple. But I can write a 2
or 3-lines readme if it's preferred.

> 
> Could you add a patch to your series for Documentation detailing:
> 
> 1. Entry criteria (needing to boot in EFI reset mode)
> 1. Description of loading a capsule
> 3. Description of triggering the update (reboot)
> 4. Verifying the update succeeded (actually is this possible right now?)

dmidecode -> check BIOS version information (vendor-specific)

Jan
