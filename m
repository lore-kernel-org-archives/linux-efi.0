From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efibc: EFI Bootloader Control
Date: Fri, 22 Apr 2016 23:44:12 +0100
Message-ID: <20160422224412.GJ2829@codeblueprint.co.uk>
References: <87bn5tlbkw.fsf@jcompost-MOBL1.tl.intel.com>
 <20160414160006.GR2829@codeblueprint.co.uk>
 <87r3e383v7.fsf@jcompost-MOBL1.tl.intel.com>
 <87mvor83tl.fsf@jcompost-MOBL1.tl.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87mvor83tl.fsf-e2kLcBBGnpIIbNWpFUBdLQzuBQEzu/OPQQ4Iyu8u01E@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Compostella, Jeremy" <jeremy.compostella-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Stanacar, Stefan" <stefan.stanacar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 18 Apr, at 03:05:42PM, Jeremy Compostella wrote:
> This module installs a reboot hook, such that if reboot() is invoked
> with a string argument NNN, "NNN" is copied to the
> "LoaderEntryOneShot" EFI variable, to be read by the bootloader. If
> the string matches one of the boot labels defined in its
> configuration, the bootloader will boot once to that label.  The
> "LoaderEntryRebootReason" EFI variable is set with the reboot reason:
> "reboot", "shutdown".  The bootloader reads this reboot reason and
> takes particular action according to its policy.
> 
> There are reboot implementations that do "reboot <reason>", such as
> Android's reboot command and Upstart's reboot replacement, which pass
> the reason as an argument to the reboot syscall.  There is no
> platform-agnostic way how those could be modified to pass the reason
> to the bootloader, regardless of platform or bootloader.
> 
> Signed-off-by: Jeremy Compostella <jeremy.compostella-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/firmware/efi/Kconfig  |  15 +++++++
>  drivers/firmware/efi/Makefile |   1 +
>  drivers/firmware/efi/efibc.c  | 101 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/efi.h           |   4 ++
>  4 files changed, 121 insertions(+)
>  create mode 100644 drivers/firmware/efi/efibc.c
 
It's difficult to have any concerns with a driver that's so small, so
I've applied this. Please note a couple of things I fixed up,

 - Add 'const' qualifier to char *reason
 - Change EFI_LOADER_GUID to LINUX_EFI_LOADER_ENTRY_GUID

Shout if you've issues with the change of name for the guid. It is
important to make it clear that this guid is not found in the UEFI
spec, which we've done in the past by prefixing guid names with LINUX_
(though presumably the Loader Entry GUID isn't necessarily Linux
specific).
