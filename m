From: Matt Fleming <matt@console-pimps.org>
Subject: Re: Patch "efi: Build EFI stub with EFI-appropriate options" has
 been added to the 3.6-stable tree
Date: Wed, 03 Apr 2013 11:28:11 +0100
Message-ID: <515C043B.4070401@console-pimps.org>
References: <13511021101759@kroah.org> <CAA7rmPF4oZjvwQ5LU1pJAydWhbwmCmzgUudUvQ5_YPpS_Rnjvg@mail.gmail.com> <1364614121.3557.11.camel@deadeye.wl.decadent.org.uk> <CAA7rmPFxzoOgcrYRetyx3hY-Y_cj0jzuY=sGAj-v2X59vCrrDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CAA7rmPFxzoOgcrYRetyx3hY-Y_cj0jzuY=sGAj-v2X59vCrrDg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Daniel Vacek <neelx.g@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, matt.fleming@intel.com, linux-efi@vger.kernel.org, ben@decadent.org.uk, linux-kernel@vger.kernel.org, x86@kernel.org, stable@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On 30/03/13 10:04, Daniel Vacek wrote:
> On Sat, Mar 30, 2013 at 4:28 AM, Ben Hutchings <ben@decadent.org.uk> wrote:
>> Daniel, this is an obvious fix but I noticed it still hasn't been
>> applied.  Please can you re-send with the proper Signed-off-by line?
> 
> Resending patch. It got lost somewhere. Thanks for pushing Ben.
> 
> From 53864fe932aa87be62f1c70944c386cff9bb9130 Mon Sep 17 00:00:00 2001
> From: Daniel Vacek <neelx.g@gmail.com>
> Date: Thu, 18 Oct 2012 22:06:26 +0200
> Subject: [PATCH] efi: fix typo in Makefile
> 
> Fix a little typo.
> 
> Signed-off-by: Daniel Vacek <neelx.g@gmail.com>
> Acked-by: Matthew Garrett <mjg@redhat.com>
> ---
>  arch/x86/boot/compressed/Makefile |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

I applied this by hand. Your patch appears to be whitespace damaged. Also, I
expanded the commit message and turned it into,

  efi: fix typo in Makefile

  commit 9dead5bbb825 ("efi: Build EFI stub with EFI-appropriate options")
  contains a typo which means that the efi_stub_$(BITS).o code is still not
  compiled with -fshort-wchar and -mno-red-zone.

  Fix it with s/KBUILD_CLFAGS/KBUILD_CFLAGS/

-- 
Matt Fleming, Intel Open Source Technology Center
