From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2] efi: Introduce EFI bootloader control driver
Date: Fri, 18 Mar 2016 16:15:05 +0000
Message-ID: <20160318161505.GU2619@codeblueprint.co.uk>
References: <1458295910-26557-1-git-send-email-daniel.baluta@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1458295910-26557-1-git-send-email-daniel.baluta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Baluta <daniel.baluta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stefan.stanacar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matthew.k.gumbel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mohamed.abbas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, constantin.musca-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 18 Mar, at 12:11:50PM, Daniel Baluta wrote:
> From: Matt Gumbel <matthew.k.gumbel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> This driver intercepts system reboot requests and populates the
> LoaderEntryOneShot EFI variable with the user-supplied reboot
> argument. EFI bootloaders such as Gummiboot will consume this
> variable and use it to control which OS is booted next.
> 
> We use this with Android where reboot() tells the kernel that
> we want to boot into recovery or other non-default OS environment.
> 
> It is the bootloader's job to guard against this variable being
> uninitialzed or containing invalid data, and just boot normally
> if that is the case.
> 
> Signed-off-by: Matt Gumbel <matthew.k.gumbel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Mohamed Abbas <mohamed.abbas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Constantin Musca <constantin.musca-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Daniel Baluta <daniel.baluta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
> Changes since v1:
> 	* updated Makefile after changing source name from efibc.c -> efi-bc.c
> 	to comply with naming rules in drivers/firmware/efi/
> 
>  drivers/firmware/efi/Kconfig  |  11 ++
>  drivers/firmware/efi/Makefile |   1 +
>  drivers/firmware/efi/efi-bc.c | 251 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 263 insertions(+)
>  create mode 100644 drivers/firmware/efi/efi-bc.c

Why does this require a driver? Why is it not possible to solve this
problem by creating the variable in userspace before invoking
reboot(2)?
