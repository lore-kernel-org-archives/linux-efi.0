From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v6 0/2] Enable capsule loader interface for efi firmware
 updating
Date: Fri, 2 Oct 2015 19:37:04 +0200
Message-ID: <20151002173704.GD16538@pd.tnic>
References: <1443733554-22743-1-git-send-email-hock.leong.kweh@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1443733554-22743-1-git-send-email-hock.leong.kweh@intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Cc: Matt Fleming <matt@console-pimps.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ong Boon Leong <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org, Sam Protsenko <semen.protsenko@linaro.org>, Peter Jones <pjones@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Roy Franz <roy.franz@linaro.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Fleming Matt <matt.fleming@intel.com>
List-Id: linux-efi@vger.kernel.org

On Fri, Oct 02, 2015 at 05:05:52AM +0800, Kweh, Hock Leong wrote:
> From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
> 
> Dear maintainers & communities,
> 
> This patchset is created on top of Matt's patchset:
> 1.)https://lkml.org/lkml/2014/10/7/390
> "[PATCH 1/2] efi: Move efi_status_to_err() to efi.h"
> 2.)https://lkml.org/lkml/2014/10/7/391
> "[PATCH 2/2] efi: Capsule update support"
> 
> It expose a misc char interface for user to upload the capsule binary and
> calling efi_capsule_update() API to pass the binary to EFI firmware.
> 
> The steps to update efi firmware are:
> 1.) cat firmware.cap > /dev/efi_capsule_loader
> 2.) reboot
> 
> Any failed upload error message will be returned while doing "cat" through
> Write() function call.
> 
> Tested the code with Intel Quark Galileo platform.

What does the error case look like? A standard glibc message about
write(2) failing?

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
