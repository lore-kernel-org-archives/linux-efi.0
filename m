From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 3/3] efi/arm64: clean up efi_get_fdt_params() interface
Date: Wed, 26 Aug 2015 16:16:24 +0200
Message-ID: <CAKv+Gu_jVAq0CGh1J+H3Yufwd2Gx3kU=8ZsVfawoi2VKjYxE9A@mail.gmail.com>
References: <1440595498-30630-1-git-send-email-leif.lindholm@linaro.org>
	<1440595498-30630-4-git-send-email-leif.lindholm@linaro.org>
	<CAKv+Gu9KwJfr6x8A607CsbAvpLUG2pqLPzcXsqhvmQnrcGy_ug@mail.gmail.com>
	<1440598503.13044.1.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1440598503.13044.1.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Salter <msalter@redhat.com>
Cc: Leif Lindholm <leif.lindholm@linaro.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Matt Fleming <matt.fleming@intel.com>
List-Id: linux-efi@vger.kernel.org

On 26 August 2015 at 16:15, Mark Salter <msalter@redhat.com> wrote:
> On Wed, 2015-08-26 at 16:04 +0200, Ard Biesheuvel wrote:
>> On 26 August 2015 at 15:24, Leif Lindholm <leif.lindholm@linaro.org>
>> wrote:
>> > As we now have a common debug infrastructure between core and arm64
>> > efi,
>> > drop the bit of the interface passing verbose output flags around.
>> >
>> > Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
>> > ---
>> >  arch/arm64/kernel/efi.c    | 2 +-
>> >  drivers/firmware/efi/efi.c | 6 ++----
>> >  include/linux/efi.h        | 2 +-
>> >  3 files changed, 4 insertions(+), 6 deletions(-)
>> >
>> > diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
>> > index 612ad5e..ab5eeb6 100644
>> > --- a/arch/arm64/kernel/efi.c
>> > +++ b/arch/arm64/kernel/efi.c
>> > @@ -201,7 +201,7 @@ void __init efi_init(void)
>> >         struct efi_fdt_params params;
>> >
>>
>> Actually, one nit: struct efi_fdt_params has a verbose field that was
>
> No it doesn't. :)
>

OK, must have been something I added myself locally then.
Never mind.
