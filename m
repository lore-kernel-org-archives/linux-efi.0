From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v3] efi/arm64: handle missing virtual mapping for UEFI
 System Table
Date: Fri, 18 Jul 2014 20:31:41 +0100
Message-ID: <20140718193141.GA27099@console-pimps.org>
References: <1404487509-26084-1-git-send-email-ard.biesheuvel@linaro.org>
 <1404492756.19665.57.camel@deneb.redhat.com>
 <20140704170110.GM16404@arm.com>
 <CAKv+Gu_-=NtVNFLEh35Pv8OO6nLe1YhPjS13MYZa93YOXFOh6Q@mail.gmail.com>
 <09C85B92-02BB-45C4-A461-D4E0CD4F7203@arm.com>
 <20140707201103.GB27474@console-pimps.org>
 <CAKv+Gu9aksvu3kOVt9GAA8jGdR0DkUUJ2iT3RMS-kEZ-OOkH2w@mail.gmail.com>
 <CAKv+Gu8PW2C3=Y5+fwQbCttLp7S4a=qD5n_CRK-FM9cN84kzOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8PW2C3=Y5+fwQbCttLp7S4a=qD5n_CRK-FM9cN84kzOA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 18 Jul, at 08:42:27PM, Ard Biesheuvel wrote:
> 
> Hey Matt,
> 
> I was wondering if you're on track to queue up your -next branch for 3.17?
> 
> If so, could you please include $subject? And if you don't mind, could
> you squash the following fixup into "efi: efistub: Convert into static
> library" as well?
 
Umm, well crap, how did I manage to drop this patch?

I've picked this up now (with all the Acks), thanks. Please could you go
through the EFI 'next' branch and just make sure there's nothing missing
for v3.17?

I was really hoping to get my queue sent to tip today, but I can always
send a second pull if it turns out I did miss something.

> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
> index cdaedad3afe5..afaeb734295a 100644
> --- a/arch/arm64/kernel/Makefile
> +++ b/arch/arm64/kernel/Makefile
> @@ -4,8 +4,7 @@
> 
>  CPPFLAGS_vmlinux.lds   := -DTEXT_OFFSET=$(TEXT_OFFSET)
>  AFLAGS_head.o          := -DTEXT_OFFSET=$(TEXT_OFFSET)
> -CFLAGS_efi-stub.o      := -DTEXT_OFFSET=$(TEXT_OFFSET) \
> -                          -I$(src)/../../../scripts/dtc/libfdt
> +CFLAGS_efi-stub.o      := -DTEXT_OFFSET=$(TEXT_OFFSET)
> 
>  CFLAGS_REMOVE_ftrace.o = -pg
>  CFLAGS_REMOVE_insn.o = -pg

Sure, I've fixed this up.

-- 
Matt Fleming, Intel Open Source Technology Center
