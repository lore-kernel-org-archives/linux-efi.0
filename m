From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] efi: Remove global 'memmap'
Date: Wed, 13 Apr 2016 10:12:56 +0200
Message-ID: <CAKv+Gu_zjJ08HwwrtL5Mqd5AzHTVwDG2VxJv2DdX1+Jk8vyuow@mail.gmail.com>
References: <1460379809-18490-1-git-send-email-matt@codeblueprint.co.uk>
	<1460379809-18490-3-git-send-email-matt@codeblueprint.co.uk>
	<CAKv+Gu-xUzbxzpTa_E_HjZcSXW+DdhasFDP1n-w-AzuDjvp6FA@mail.gmail.com>
	<20160412200119.GH2829@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160412200119.GH2829-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tony Luck <tony.luck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 12 April 2016 at 22:01, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Mon, 11 Apr, at 03:17:55PM, Ard Biesheuvel wrote:
>> > diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
>> > index 1cfbfaf57a2d..0416d5d33e74 100644
>> > --- a/drivers/firmware/efi/arm-runtime.c
>> > +++ b/drivers/firmware/efi/arm-runtime.c
>> > @@ -89,6 +89,7 @@ static bool __init efi_virtmap_init(void)
>> >   */
>> >  static int __init arm_enable_runtime_services(void)
>> >  {
>> > +       phys_addr_t phys_map;
>>
>> Is the sole purpose of this variable to prevent breaking the 80-column rule?
>
> Indeed it is.
>
>> If so, please be aware that I intend to propose a patch that replaces
>> the ioremap_cache() below with a call to memremap(), but this is
>> another change that is gated by Russell merging my memremap patches
>> for ARM
>
> OK. Would you like me to drop this particular hunk and just go with,
>
>         efi.memmap.map = (__force void *)ioremap_cache(efi.memmap.phys_map,
>                                                        mapsize);
>
> if you're going to rewrite it soon anyway?

Yes, please. Russell seems to be dragging his feet a bit, but I should
still be able to get that patch out in time for v4.7 (and the memattr
stuff for ARM relies on it anyway)
