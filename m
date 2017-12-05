From: "Tobin C. Harding" <me@tobin.cc>
Subject: Re: [PATCH] efi: move some sysfs files to be read-only by root
Date: Wed, 6 Dec 2017 07:50:41 +1100
Message-ID: <20171205205041.GE11064@eros>
References: <20171205101343.GA5416@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171205101343.GA5416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Young <dyoung@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Dec 05, 2017 at 11:13:43AM +0100, Greg Kroah-Hartman wrote:
> Thanks to the scripts/leaking_addresses.pl script, it was found that
> some EFI values should not be readable by non-root users.
> 
> So make them root-only, and to do that, add a __ATTR_RO_MODE() macro to
> make this easier, and use it in other places at the same time.
> 
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Tested-by: Dave Young <dyoung@redhat.com>
> Cc: Matt Fleming <matt@codeblueprint.co.uk>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  drivers/firmware/efi/efi.c         |    3 +--
>  drivers/firmware/efi/esrt.c        |   15 ++++++---------
>  drivers/firmware/efi/runtime-map.c |   10 +++++-----
>  include/linux/sysfs.h              |    5 +++++
>  4 files changed, 17 insertions(+), 16 deletions(-)
> 
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -143,8 +143,7 @@ static ssize_t systab_show(struct kobjec
>  	return str - buf;
>  }

Greg, do you add the CC's here in the commit log for a technical reason?
Is it so that future investigation that leads to this commit can see who
to involve in any further discussion?

As an example, for the patch that added the %p hashing should I have
CC'd Jason A. Donenfeld since he was the brains behind the SipHash
stuff and gave loads of suggestions/direction?

thanks,
Tobin.
