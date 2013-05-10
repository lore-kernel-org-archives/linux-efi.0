From: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Subject: RE: [PATCH v2]Move kzalloc() just before memset() to avoid
 initializing new sysfs entries
Date: Fri, 10 May 2013 20:34:50 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D41AFF1B1F@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D41AFF1A87@USINDEM103.corp.hds.com>
 <1368217492.2024.31.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1368217492.2024.31.camel@dabdike>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Tomoki Sekiyama <tomoki.sekiyama-7rDLJAbr9SE@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> the problem isn't anything to
> do with memset, it's because we're not getting a new allocation each
> time we call efivar_create_sysfs_entries(). 

I see. I agree with you.
I will update my patch with your explanation below.

Seiji

> 
> ---
> Subject: [PATCH] efivar: fix oops in efivar_update_sysfs_entries() caused by memory reuse
> 
> The loop in efivar_update_sysfs_entries() reuses the same allocation for
> entries each time it calls efivar_create_sysfs_entry(entry).  This is
> wrong because efivar_create_sysfs_entry() expects to keep the memory it
> was passed, so the caller may not free it (and may not pass the same
> memory in multiple times).  This leads to the oops below.  Fix by
> getting a new allocation each time we go around the loop.
> 
> [insert oops report here]
> ---
> 
> James
> 
