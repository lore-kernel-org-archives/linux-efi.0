From: Richard Ruigrok <rruigrok-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH 0/2] Make capsules in a contiguous virtual space
Date: Thu, 21 Dec 2017 14:47:13 -0700
Message-ID: <5851a90c-b334-9b28-d3b3-8eba7c933222@codeaurora.org>
References: <1513680554-5682-1-git-send-email-ge.song@hxt-semitech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1513680554-5682-1-git-send-email-ge.song-PT9Dzx9SjPiXmMXjJBpWqg@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ge Song <ge.song-PT9Dzx9SjPiXmMXjJBpWqg@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Please tested-by
Tested on Centiq, applied on v4.15-rc4.
This fixes the regression introduced in 4.13 where the capsule is no longer passed in contiguous virtual memory.

On 12/19/2017 3:49 AM, Ge Song wrote:
> Recently we found it failed to update firmware through capsule update
> mechanism in linux-4.14 and later version.
>
> After some investigation, the reason is firmware expects capsules in a
> contiguous virtual space and this assumption is not satisfied in recent
> linux versions.
>
> Ge Song (2):
>   Revert "efi/capsule-loader: Use page addresses rather than struct page
>     pointers"
>   efi/capsule-loader: Request a contiguous virtual space for capsules
>
>  drivers/firmware/efi/capsule-loader.c | 23 ++++++++++++++---------
>  drivers/firmware/efi/capsule.c        |  7 +++----
>  include/linux/efi.h                   |  4 ++--
>  3 files changed, 19 insertions(+), 15 deletions(-)
>

-- 
Qualcomm Datacenter Technologies as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
