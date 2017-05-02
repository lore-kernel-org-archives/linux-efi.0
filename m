From: Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 0/3 v2] xen: Implement EFI reset_system callback
Date: Tue, 2 May 2017 11:30:14 +0200
Message-ID: <f7bfc07d-ae10-09fb-9fce-a2ef93460459@suse.com>
References: <20170424175839.5262-1-julien.grall@arm.com>
 <33472949-4748-f03e-cae9-65bd5f54c2f7@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <33472949-4748-f03e-cae9-65bd5f54c2f7-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Julien Grall <julien.grall-5wv7dgnIgG8@public.gmane.org>, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, sstabellini-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 02/05/17 11:08, Julien Grall wrote:
> Hi all,
> 
> It looks like the series has fully been acked, can someone merge this
> into xentip?

As I already wrote: patch 1 doesn't apply any longer.

As there were other conflicts between xentip and Linus' tree I'm doing
a rebase of for-linus-4.12 right now, so I can do the rebase of this
patch for you.


Juergen

> 
> Cheers,
> 
> On 04/24/2017 06:58 PM, Julien Grall wrote:
>> Hi all,
>>
>> This small patch series implements EFI reset_system callback when
>> using EFI
>> Xen. Without this, it will not be possible to reboot/power off ARM64 DOM0
>> when using ACPI.
>>
>> Cheers,
>>
>> Cc: Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> Cc: Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>
>>
>> Julien Grall (3):
>>   xen: Export xen_reboot
>>   arm/xen: Consolidate calls to shutdown hypercall in a single helper
>>   xen: Implement EFI reset_system callback
>>
>>  arch/arm/xen/efi.c       |  2 +-
>>  arch/arm/xen/enlighten.c | 16 ++++++++++------
>>  arch/x86/xen/efi.c       |  2 +-
>>  arch/x86/xen/enlighten.c |  2 +-
>>  drivers/xen/efi.c        | 18 ++++++++++++++++++
>>  include/xen/xen-ops.h    |  5 +++++
>>  6 files changed, 36 insertions(+), 9 deletions(-)
>>
> 
