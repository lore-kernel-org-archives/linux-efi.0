From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v3] efivars,efi-pstore: Hold off deletion of sysfs entry
 until, the scan is completed
Date: Thu, 17 Oct 2013 14:18:21 +0100
Message-ID: <20131017131821.GH10834@console-pimps.org>
References: <52584373.3010202@hds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <52584373.3010202-7rDLJAbr9SE@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tomoki.sekiyama-7rDLJAbr9SE@public.gmane.org, dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 11 Oct, at 02:29:07PM, Seiji Aguchi wrote:
> Change from v2:
> - Move dynamic memory allocation to efi_pstore_read() before holding
>   efivars->lock to protect entry->var.Data.
> - Access to entry->scanning while holding efivars->lock.
> - Move a comment about a returned value from efi_pstore_read_func() to
>   efi_pstore_read() because "size < 0" case may happen in efi_pstore_read().

It seems to me that because you're no longer dropping __efivars->lock
when reading from the EFI variable store, you actually don't need all
the ->scanning and ->deleting logic because anything that sets those
flags runs to completion while holding the lock.

Can't the patch be simplified to just allocating data.buf at the
beginning of efi_pstore_read()? Also, it would be a good idea to
introduce a #define for the 1024 magic number, e.g.

#define EFIVARS_DATA_SIZE_MAX	1024

-- 
Matt Fleming, Intel Open Source Technology Center
