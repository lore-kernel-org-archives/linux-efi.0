From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] efi: Use LocateHandleBuffer instead of LocateHandle
Date: Wed, 12 Oct 2016 13:35:34 +0100
Message-ID: <CAKv+Gu9bQY-uoY8ra_BFgPUnLaoCDjA-Nu+1O75Mx8QRA2VqrA@mail.gmail.com>
References: <1d7915dc0dd328ca04088f6b8b3fcfad5cec55a0.1473275006.git.lukas@wunner.de>
 <CAKv+Gu_kfnHfiBH__Wnvh39KMPj_-s39YyY=pT3roNv7iPPzrA@mail.gmail.com>
 <20160909115951.GA29385@wunner.de> <20161003193220.GI16071@codeblueprint.co.uk>
 <CAKv+Gu-UKr0bPjy_0tO0ThB6F4E1q-uKtktg+z5CRP=gX-oewg@mail.gmail.com>
 <20161004165349.GA5019@wunner.de> <CAKv+Gu-6yB_ZVC38S8yFZtB7vPfDZe1wp47bT+WxwpSSUN4OgA@mail.gmail.com>
 <20161006093200.GA6925@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161006093200.GA6925-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 6 October 2016 at 10:32, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org> wrote:
> On Fri, Sep 09, 2016 at 11:52:32AM +0100, Ard Biesheuvel wrote:
>> What is the oldest UEFI version we claim to support? For ARM, this is
>> not an issue, but it appears that LocateHandleBuffer () was introduced
>> in v1.10
>
> UGA was apparently introduced with v1.10, GOP was introduced later
> than v1.10, it follows that availability of LocateHandleBuffer()
> can be assumed at least when searching for these two protocols.
>
> Would a patch be entertained which uses LocateHandleBuffer for these
> two but leaves the PCI ROM retrieval unchanged?
>

Thanks, but no thanks.

> On Wed, Oct 05, 2016 at 05:25:44PM +0100, Ard Biesheuvel wrote:
>> However, we've had our share of breakage with
>> the stub code, which is difficult to debug on anything except
>> development hardware, and so I think we should not take this change
>> (and Matt appears to agree).
>
> Thanks for the clarification, however I don't quite follow:
> Is the rejection of the patch based on the intent to maintain
> support for EFI v1.0+ (which isn't an argument for UGA + GOP
> as lined out above) or is it based on a gut feeling that the
> patch might cause breakage for whatever reason.
> (Perhaps firmware bugs?  Not sure what is meant here.)
>

The fact that LocateHandleBuffer() should be implemented by fairly old
versions of UEFI does not guarantee that all UEFI systems that we
currently support implement it correctly. So in that sense, we face a
non-zero risk of regressions, which is not justifiable for a simple
code cleanup.
