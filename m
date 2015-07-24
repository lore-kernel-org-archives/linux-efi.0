From: Haojian Zhuang <haojian.zhuang-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [edk2] [PATCH v3] arm64/efi: prefer AllocatePages() over
 efi_low_alloc() for vmlinux
Date: Fri, 24 Jul 2015 09:13:38 +0800
Message-ID: <1437700418.25022.1.camel@linaro.org>
References: <55B0D4E4.9030403@redhat.com>
	 <1437657906-20034-1-git-send-email-ard.biesheuvel@linaro.org>
	 <1437660329.23817.1.camel@linaro.org>
	 <CAKv+Gu-vLtVQmHT+0BzBh0wq2AKDWxJZdJNBHFStd-AbMb0u9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu-vLtVQmHT+0BzBh0wq2AKDWxJZdJNBHFStd-AbMb0u9g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "edk2-devel-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <edk2-devel-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 2015-07-23 at 16:52 +0200, Ard Biesheuvel wrote:
> On 23 July 2015 at 16:05, Haojian Zhuang <haojian.zhuang-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> > On Thu, 2015-07-23 at 15:25 +0200, Ard Biesheuvel wrote:
> >> Hello Haojian,
> >>
> >> Apologies for the noise ...
> >>
> >> Could you please try *this* version v3 instead? v2 is just the same patch as
> >> before ...
> >>
> >> --
> >> Ard.
> >>
> >
> > Hi Ard,
> >
> > Thanks for your patch. It fixes the issue when DRAM_BASE is 0x0.
> >
> 
> Thanks for verifying. May I add your Tested-by ?
> 

Of course. Please feel free to add my Tested-by.

Best Regards
Haojian
