From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efibc: EFI Bootloader Control
Date: Fri, 22 Apr 2016 22:38:21 +0100
Message-ID: <20160422213821.GI2829@codeblueprint.co.uk>
References: <87bn5tlbkw.fsf@jcompost-MOBL1.tl.intel.com>
 <20160414160006.GR2829@codeblueprint.co.uk>
 <87r3e383v7.fsf@jcompost-MOBL1.tl.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87r3e383v7.fsf-e2kLcBBGnpIIbNWpFUBdLQzuBQEzu/OPQQ4Iyu8u01E@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Compostella, Jeremy" <jeremy.compostella-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Stanacar, Stefan" <stefan.stanacar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 18 Apr, at 03:04:44PM, Compostella, Jeremy wrote:
> Done.  But I'm not sure if EFI_LOADER_GUID constant name is
> appropriate.  However, I'd like to avoid naming it after Kernelflinger
> or Gummiboot.

Yeah. What about EFI_LOADER_ENTRY_GUID ?

> Agreed.  I removed all the panic handler related code.  Though, I'd
> like to keep the LoaderEntryRebootReason filled with "shutdown" or
> "reboot" if that's okay with you.

Fine by me!
