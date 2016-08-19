From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2] x86/efi: defer efi_esrt_init until after
 memblock_x86_fill
Date: Fri, 19 Aug 2016 13:17:05 +0100
Message-ID: <20160819121705.GU30909@codeblueprint.co.uk>
References: <1471393951-28804-1-git-send-email-ricardo.neri-calderon@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1471393951-28804-1-git-send-email-ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Scott Lawson <scott.lawson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 16 Aug, at 05:32:31PM, Ricardo Neri wrote:
> Commit 7b02d53e7852 ("efi: Allow drivers to reserve boot services forever")
> introduced a new efi_mem_reserve to reserve the boot services memory
> regions forever. This reservation involves allocating a new EFI memory
> range descriptor. However, allocation can only succeed if there is memory
> available for the allocation. Otherwise, error such as the following may
> occur:
> 
> esrt: Reserving ESRT space from 0x000000003dd6a000 to 0x000000003dd6a010.
> Kernel panic - not syncing: ERROR: Failed to allocate 0x9f0 bytes below \
>  0x0.
 
Thanks Ricardo. Applied to 'next'.
