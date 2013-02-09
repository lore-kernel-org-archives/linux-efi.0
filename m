From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v5 -next 2/2]efi_pstore: Introducing workqueue updating
 sysfs entries
Date: Sat, 09 Feb 2013 20:12:35 +0000
Message-ID: <1360440755.7515.322.camel@mfleming-mobl1.ger.corp.intel.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A541C8@USINDEM103.corp.hds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D414A541C8-ohthHghroY0jroPwUH3sq+6wyyQG6/Uh@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Luck, Tony (tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org)" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "cbouatmailru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <cbouatmailru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "dzickus-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dzickus-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Satoru Moriya <satoru.moriya-7rDLJAbr9SE@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 2013-01-24 at 00:41 +0000, Seiji Aguchi wrote:
> [Problem]
> efi_pstore creates sysfs entries, which enable users to access to NVRAM,
> in a write callback. If a kernel panic happens in an interrupt context,
> it may fail because it could sleep due to dynamic memory allocations during
> creating sysfs entries.
> 
> [Patch Description]
> This patch removes sysfs operations from a write callback by introducing 
> a workqueue updating sysfs entries which is scheduled after the write
> callback is called.
> 
> Also, the workqueue is kicked in a just oops case.
> A system will go down in other cases such as panic, clean shutdown and emergency 
> restart. And we don't need to create sysfs entries because there is no chance for 
> users to access to them.
> 
> efi_pstore will be robust against a kernel panic in an interrupt context with this patch.
> 
> Signed-off-by: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
> ---
>  drivers/firmware/efivars.c |   85 +++++++++++++++++++++++++++++++++++++++++---
>  include/linux/efi.h        |    3 +-
>  2 files changed, 82 insertions(+), 6 deletions(-)

Acked-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

-- 
Matt Fleming, Intel Open Source Technology Center
