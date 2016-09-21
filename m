From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: Re: EFI co-maintainer
Date: Wed, 21 Sep 2016 19:59:51 +0200
Message-ID: <20160921175951.GA3387@wunner.de>
References: <20160921150912.GM2892@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160921150912.GM2892-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Matt, Hi Ard,

On Wed, Sep 21, 2016 at 04:09:12PM +0100, Matt Fleming wrote:
> I've asked, and Ard has agreed to step up and help me co-maintain the
> EFI subsystem.
> 
> Given that there are now two maintainers, we're moving to a shared git
> repository on kernel.org, hosted at,
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git
> 
> Expect a MAINTAINERS patch soon.
> 
> I do plan on keeping the existing tree in sync for the time being, so
> it won't actually matter which repository people base their patches
> on. Hopefully the disruption to patch submitters will be minimal.
> 
> Thanks again Ard!

That is great to hear, thanks a lot from me as well.

Just curious, are there any plans to integrate the new repo into
linux-next?  It would be great to have testing as early as possible.

Also, if this isn't too much trouble, would it be possible to merge
urgent into next when patches are added in the future?  When I tested
my patches during this release cycle, I tried to pull in everything
from efi/urgent + efi/next into my development branch but hit some
non-trivial merge conflicts in portions of the EFI code I wasn't
familiar with.  And ISTR that efi/next was based on 4.7, not 4.8-rc.
In the end I just rebased my patches on efi/next, but felt a bit uneasy
as I wasn't testing what the code would eventually look like.

Thanks again,

Lukas
