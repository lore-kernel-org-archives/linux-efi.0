From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] efi: Use LocateHandleBuffer instead of LocateHandle
Date: Tue, 4 Oct 2016 13:56:42 +0100
Message-ID: <CAKv+Gu-UKr0bPjy_0tO0ThB6F4E1q-uKtktg+z5CRP=gX-oewg@mail.gmail.com>
References: <1d7915dc0dd328ca04088f6b8b3fcfad5cec55a0.1473275006.git.lukas@wunner.de>
 <CAKv+Gu_kfnHfiBH__Wnvh39KMPj_-s39YyY=pT3roNv7iPPzrA@mail.gmail.com>
 <20160909115951.GA29385@wunner.de> <20161003193220.GI16071@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161003193220.GI16071-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 3 October 2016 at 12:32, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Fri, 09 Sep, at 01:59:51PM, Lukas Wunner wrote:
>>
>> I vaguely recall that Apple was among the first vendors adopting EFI
>> for x86 in 2005, but I could be wrong.
>
> I'm fairly sure my old Macbook 2.1 is EFI 1.10, yeah.

Indeed. But the Macs are a little weird in this respect, it does not
necessarily mean they don't implement LocateHandleBuffer(). Since
Lukas uses a Mac himself (IIRC), I'd assume it works on his system and
so their UEFI does implement this boot service. That does not
necessarily tell us anything about other Macs, though.

So I'm a bit on the fence here: we could mandate a more recent version
of UEFI if the Mac is the only 'older' implementation we intend to
support, but it is not a very clean approach imo, and this particular
patch, while useful, does not use a critical piece of functionality
that is only implemented by newer spec revisions.

I am leaning towards not taking the patch, although we could revisit
this in the future.

-- 
Ard.
