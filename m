From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efi: Add esrt support.
Date: Thu, 30 Apr 2015 11:42:34 +0100
Message-ID: <20150430104234.GB3014@codeblueprint.co.uk>
References: <1430261071-14005-1-git-send-email-pjones@redhat.com>
 <1430261071-14005-2-git-send-email-pjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1430261071-14005-2-git-send-email-pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 28 Apr, at 06:44:31PM, Peter Jones wrote:
> Add sysfs files for the EFI System Resource Table (ESRT) under
> /sys/firmware/efi/esrt and for each EFI System Resource Entry under
> entries/ as a subdir.
> 
> The EFI System Resource Table (ESRT) provides a read-only catalog of
> system components for which the system accepts firmware upgrades via
> UEFI's "Capsule Update" feature.  This module allows userland utilities
> to evaluate what firmware updates can be applied to this system, and
> potentially arrange for those updates to occur.
> 
> The ESRT is described as part of the UEFI specification, in version 2.5
> which should be available from http://uefi.org/specifications in early
> 2015.  If you're a member of the UEFI Forum, information about its
> addition to the standard is available as UEFI Mantis 1090.
> 
> For some hardware platforms, additional restrictions may be found at
> http://msdn.microsoft.com/en-us/library/windows/hardware/jj128256.aspx ,
> and additional documentation may be found at
> http://download.microsoft.com/download/5/F/5/5F5D16CD-2530-4289-8019-94C6A20BED3C/windows-uefi-firmware-update-platform.docx
> .
> 
> Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  Documentation/ABI/testing/sysfs-firmware-efi-esrt |  81 ++++
>  arch/x86/platform/efi/efi.c                       |   2 +
>  drivers/firmware/efi/Makefile                     |   2 +-
>  drivers/firmware/efi/efi.c                        |  82 +++-
>  drivers/firmware/efi/esrt.c                       | 464 ++++++++++++++++++++++
>  include/linux/efi.h                               |   8 +
>  6 files changed, 637 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-firmware-efi-esrt
>  create mode 100644 drivers/firmware/efi/esrt.c

Thanks Peter, applied!

-- 
Matt Fleming, Intel Open Source Technology Center
