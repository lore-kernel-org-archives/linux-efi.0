From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v1] efi/apple-properties: Device core takes care of empty properties
Date: Tue, 23 Jan 2018 18:50:07 +0000
Message-ID: <CAKv+Gu_iBRFFuDJATLfwK5Fq8=DU=mV3g56y+YCWKEwi91_zjQ@mail.gmail.com>
References: <20180122141709.41898-1-andriy.shevchenko@linux.intel.com> <20180122214609.GA18579@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180122214609.GA18579-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Cc: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 22 January 2018 at 21:46, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org> wrote:
> On Mon, Jan 22, 2018 at 04:17:09PM +0200, Andy Shevchenko wrote:
>> There is no need to artificially supply a property length and fake data
>> if property has type of boolean.
>
> You're right, I just didn't know better.
>
> I've verified that with this patch applied, boolean properties are
> still listed with the "dump_apple_properties" command line option
> and I've also tested that it's still possible to test presence of
> boolean properties with device_property_present(), so FWIW:
>
> Reviewed-and-tested-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
>
> Thanks Andy!  Ard, could you pick this up please?
>

Applied, thanks.
