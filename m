From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] efi: fix pointer type errors in fdt_uefi_find_params()
Date: Wed, 18 Jun 2014 11:06:09 +0200
Message-ID: <CAKv+Gu-PKHx8Z64W0v2jA8p2w6whewhgVdYaQyBfJRZrPSFLyA@mail.gmail.com>
References: <1402671299-22493-1-git-send-email-ard.biesheuvel@linaro.org>
	<20140618090245.GC24049@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140618090245.GC24049-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 18 June 2014 11:02, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> On Fri, 13 Jun, at 04:54:59PM, Ard Biesheuvel wrote:
>> Fix two instances of pointer type errors, a harmless one where a const void*
>> value is assigned to a non-const void* variable, and a not-so-harmless one where
>> we pass a pointer to unsigned long where a pointer to int is expected.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  drivers/firmware/efi/efi.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
>> index cd36deb619fa..fe737832a882 100644
>> --- a/drivers/firmware/efi/efi.c
>> +++ b/drivers/firmware/efi/efi.c
>> @@ -353,8 +353,8 @@ static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
>>                                      int depth, void *data)
>>  {
>>       struct param_info *info = data;
>> -     void *prop, *dest;
>> -     unsigned long len;
>> +     void const *prop, *dest;
>> +     int len;
>>       u64 val;
>>       int i;
>
> const void *?
>

You say potato, I say po-tah-to?
But seriously, whichever you prefer ...

Regards,
Ard.
