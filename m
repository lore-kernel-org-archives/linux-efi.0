From: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/4] UEFI: EFI_MEMORY_ATTRIBUTES_TABLE support for x86
Date: Wed, 07 Dec 2016 11:01:06 -0800
Message-ID: <1481137266.15606.131.camel@intel.com>
References: <1481051763-8705-1-git-send-email-sai.praneeth.prakhya@intel.com>
         <20161207135646.GC17720@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161207135646.GC17720-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jlee-IBi9RG/b67k@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 2016-12-07 at 13:56 +0000, Matt Fleming wrote:
> On Tue, 06 Dec, at 11:15:59AM, Sai Praneeth Prakhya wrote:
> > From: Sai Praneeth <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > 
> > UEFI v2.6 introduces EFI_MEMORY_ATTRIBUTES_TABLE which describes memory 
> > protections that may be applied to EFI Runtime code and data regions by 
> > kernel. This helps kernel to map efi runtime regions more strictly and 
> > hence allowing only appropriate accesses to these regions. Please refer 
> > to "EFI_MEMORY_ATTRIBUTES_TABLE" in section 4.6 of UEFI specification 
> > v2.6 for more information on this table.
> > 
> > This patch set relies on commit a604af075a32 ("efi: Add support for the 
> > EFI_MEMORY_ATTRIBUTES_TABLE config table"), commit 10f0d2f57705 ("efi: 
> > Implement generic support for the Memory Attributes table") and hence 
> > implements support for only x86.
> > 
> > Since the above commits have already implemented early discovery and 
> > validation of table, the following patches implement a call back 
> > function for x86 which is called only when EFI_MEMORY_ATTRIBUTES_TABLE 
> > is detected.
> > 
> > Patch #1 makes the efi_memory_attributes table detection code generic 
> > across all architectures
> > 
> > Patch #2 adds EFI_MEM_ATTR bit to keep track of this feature
> > 
> > Patch #3 Implements call back function that does stricter mappings based 
> > on this table
> > 
> > Patch #4 Skip parsing of EFI_PROPERTIES_TABLE if EFI_MEMORY_ATTRIBUTES_TABLE 
> > is detected
> > 
> > Sai Praneeth (4):
> >   efi: Make EFI_MEMORY_ATTRIBUTES_TABLE initialization common across all
> >     architectures
> >   efi: Introduce EFI_MEM_ATTR bit and set it from memory attributes
> >     table
> >   x86/efi: Add support for EFI_MEMORY_ATTRIBUTES_TABLE
> >   efi: Skip parsing of EFI_PROPERTIES_TABLE if
> >     EFI_MEMORY_ATTRIBUTES_TABLE is detected
> > 
> >  arch/x86/platform/efi/efi_64.c  | 64 ++++++++++++++++++++++++++++++++++-------
> >  drivers/firmware/efi/arm-init.c |  1 -
> >  drivers/firmware/efi/efi.c      | 13 +++++++++
> >  drivers/firmware/efi/memattr.c  |  6 +++-
> >  include/linux/efi.h             |  1 +
> >  5 files changed, 73 insertions(+), 12 deletions(-)
> 
> Thanks Sai, I've queued this up for v4.11.

Thanks Matt!

Would you like to see a new version of these patch series addressing
your comments? Like
1. Dropping of patch #4
2. Adding Reviewed-by tag of Joey (Sorry for that)
3. This time with correct version number

Regards,
Sai
