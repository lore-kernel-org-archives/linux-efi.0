From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/2] Make capsules in a contiguous virtual space
Date: Fri, 22 Dec 2017 15:50:23 +0000
Message-ID: <CAKv+Gu9opEvgTt1X9NyH+npwka246gwGpY2e_H6r14ee0L7rwQ@mail.gmail.com>
References: <1513680554-5682-1-git-send-email-ge.song@hxt-semitech.com> <5851a90c-b334-9b28-d3b3-8eba7c933222@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5851a90c-b334-9b28-d3b3-8eba7c933222-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Ruigrok <rruigrok-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: Ge Song <ge.song-PT9Dzx9SjPiXmMXjJBpWqg@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 21 December 2017 at 21:47, Richard Ruigrok <rruigrok-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org> wrote:
> Please tested-by
> Tested on Centiq, applied on v4.15-rc4.
> This fixes the regression introduced in 4.13 where the capsule is no longer passed in contiguous virtual memory.
>
> On 12/19/2017 3:49 AM, Ge Song wrote:
>> Recently we found it failed to update firmware through capsule update
>> mechanism in linux-4.14 and later version.
>>
>> After some investigation, the reason is firmware expects capsules in a
>> contiguous virtual space and this assumption is not satisfied in recent
>> linux versions.
>>
>> Ge Song (2):
>>   Revert "efi/capsule-loader: Use page addresses rather than struct page
>>     pointers"
>>   efi/capsule-loader: Request a contiguous virtual space for capsules
>>


Thanks for the patches (and for the tested-by). I will look into this,
but I'd like to try to fix this without breaking the quirk we did for
Quark.



>>  drivers/firmware/efi/capsule-loader.c | 23 ++++++++++++++---------
>>  drivers/firmware/efi/capsule.c        |  7 +++----
>>  include/linux/efi.h                   |  4 ++--
>>  3 files changed, 19 insertions(+), 15 deletions(-)
>>
>
> --
> Qualcomm Datacenter Technologies as an affiliate of Qualcomm Technologies, Inc.
> Qualcomm Technologies, Inc. is a member of the
> Code Aurora Forum, a Linux Foundation Collaborative Project.
>
