From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v9 1/1] efi: a misc char interface for user to update efi
 firmware
Date: Wed, 16 Dec 2015 12:26:10 +0100
Message-ID: <20151216112610.GC29775@pd.tnic>
References: <F54AEECA5E2B9541821D670476DAE19C4A879BFE@PGSMSX102.gar.corp.intel.com>
 <20151103195934.GC3620@pd.tnic>
 <F54AEECA5E2B9541821D670476DAE19C4A890F50@PGSMSX102.gar.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <F54AEECA5E2B9541821D670476DAE19C4A890F50@PGSMSX102.gar.corp.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Cc: Matt Fleming <matt@console-pimps.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Ong, Boon Leong" <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Sam Protsenko <semen.protsenko@linaro.org>, Peter Jones <pjones@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Roy Franz <roy.franz@linaro.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "Anvin, H Peter" <h.peter.anvin@intel.com>, 'Matt Fleming' <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

On Wed, Dec 16, 2015 at 11:09:50AM +0000, Kweh, Hock Leong wrote:
> So, my conclusion is that this module is not able to be tested on QEMU
> environment.

That's not the point.

The module should better handle writing to the device file gracefully
and not explode. Regardless of whether it is running on an EFI system or
not.

efi_capsule_loader_init() simply loads the driver on *any* system,
even a !UEFI one. And when I write some garbage to the device file, it
explodes.

What it should do instead is check whether it is being loaded on en EFI
system and whether all it needs to function properly is initialized
already, like runtime services. If not, it should refuse to load.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
