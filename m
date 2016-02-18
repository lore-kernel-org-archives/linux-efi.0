From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] efi: libstub: add strnlen() implementation
Date: Thu, 18 Feb 2016 15:01:28 +0100
Message-ID: <CAKv+Gu_tFqPRbAux1vD1+7ieV3J_VnicAeLUh1zOdjQ_OnUScA@mail.gmail.com>
References: <1455636559-7542-1-git-send-email-ard.biesheuvel@linaro.org>
	<20160218110446.GD2651@codeblueprint.co.uk>
	<CAKv+Gu_bhat3RjoLDqUtUBG7bB0ECAdS1i4GF_AU9h=YfWz=tw@mail.gmail.com>
	<20160218133337.GF2651@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160218133337.GF2651-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 18 February 2016 at 14:33, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Thu, 18 Feb, at 12:05:51PM, Ard Biesheuvel wrote:
>> On 18 February 2016 at 12:04, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
>> > On Tue, 16 Feb, at 04:29:19PM, Ard Biesheuvel wrote:
>> >> Commit 91feabc2e224 ("scripts/dtc: Update to upstream commit
>> >> b06e55c88b9b") introduces references to the strnlen() string function,
>> >> which is not currently defined in the EFI stub. So add it to our string.c
>> >>
>> >> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> >> ---
>> >>  drivers/firmware/efi/libstub/string.c | 16 ++++++++++++++++
>> >>  1 file changed, 16 insertions(+)
>> >
>> > Does this patch fix a build failure for ARM? Which tree is the above
>> > commit in?
>>
>> It is in -next, and it will break the build once it hits upstream.
>
> OK, could you resend and include the build failure in the commit log
> and make a reference to fixing a build issue?

Actually, I spoke too soon. While the issue does exist on arm64, ARM
already has a special version of strnlen() in its decompressor.

Sorry for the noise.
