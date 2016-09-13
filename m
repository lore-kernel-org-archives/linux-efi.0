From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 2/3] efi: add firmware version information to sysfs
Date: Tue, 13 Sep 2016 14:24:34 +0100
Message-ID: <20160913132434.GJ3872@codeblueprint.co.uk>
References: <20160907122339.GB28333@wunner.de>
 <1473260186-4500-1-git-send-email-pjones@redhat.com>
 <1473260186-4500-2-git-send-email-pjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1473260186-4500-2-git-send-email-pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 07 Sep, at 10:56:25AM, Peter Jones wrote:
> This adds the EFI Spec version from the system table to sysfs as
> /sys/firmware/efi/spec_version .
> 
> Userland tools need this information in order to work around
> specification deficiencies in 2.4 and earlier firmwares.  Specifically,
> UEFI 2.4 and 2.5+ treat management of BootOrder very differently (See
> UEFI 2.4 section 3.1.1 vs UEFI 2.5 section 3.1), which means on older
> firmware we'll want to work around BDS's boot order management by adding
> fwupdate entries to BootOrder.  We'd prefer not to do this on newer
> firmware, as it is both non-sensical in terms of what it expresses, and
> it results in more relatively failure prone flash writes.
> 
> Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
> ---
>  Documentation/ABI/testing/sysfs-firmware-efi |  6 +++
>  drivers/firmware/efi/efi.c                   | 65 ++++++++++++++++++++++++++++
>  2 files changed, 71 insertions(+)

Looks fine to me.
