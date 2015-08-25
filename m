From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] efi: Add EFI_MEMORY_MORE_RELIABLE support to efi_md_typeattr_format()
Date: Tue, 25 Aug 2015 16:23:10 +0200
Message-ID: <CAKv+Gu81+bPKYAmSUtJ1fEF_9Tc8bOfmPSE8Kx4Ymv-HVojmdQ@mail.gmail.com>
References: <1440090902-15157-1-git-send-email-izumi.taku@jp.fujitsu.com>
	<1440090952-15211-1-git-send-email-izumi.taku@jp.fujitsu.com>
	<20150825141819.GA3013@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150825141819.GA3013-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Taku Izumi <izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org" <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, qiuxishi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 25 August 2015 at 16:18, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Fri, 21 Aug, at 02:15:52AM, Taku Izumi wrote:
>> UEFI spec 2.5 introduces new Memory Attribute Definition named
>> EFI_MEMORY_MORE_RELIABLE. This patch adds this new attribute
>> support to efi_md_typeattr_format().
>>
>> Signed-off-by: Taku Izumi <izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>> ---
>>  drivers/firmware/efi/efi.c | 6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
>> index d6144e3..aadc1c4 100644
>> --- a/drivers/firmware/efi/efi.c
>> +++ b/drivers/firmware/efi/efi.c
>> @@ -589,12 +589,14 @@ char * __init efi_md_typeattr_format(char *buf, size_t size,
>>       attr = md->attribute;
>>       if (attr & ~(EFI_MEMORY_UC | EFI_MEMORY_WC | EFI_MEMORY_WT |
>>                    EFI_MEMORY_WB | EFI_MEMORY_UCE | EFI_MEMORY_WP |
>> -                  EFI_MEMORY_RP | EFI_MEMORY_XP | EFI_MEMORY_RUNTIME))
>> +                  EFI_MEMORY_RP | EFI_MEMORY_XP | EFI_MEMORY_RUNTIME |
>> +                  EFI_MEMORY_MORE_RELIABLE))
>>               snprintf(pos, size, "|attr=0x%016llx]",
>>                        (unsigned long long)attr);
>>       else
>> -             snprintf(pos, size, "|%3s|%2s|%2s|%2s|%3s|%2s|%2s|%2s|%2s]",
>> +             snprintf(pos, size, "|%3s|%4s|%2s|%2s|%2s|%3s|%2s|%2s|%2s|%2s]",
>>                        attr & EFI_MEMORY_RUNTIME ? "RUN" : "",
>> +                      attr & EFI_MEMORY_MORE_RELIABLE ? "RELY" : "",
>>                        attr & EFI_MEMORY_XP      ? "XP"  : "",
>>                        attr & EFI_MEMORY_RP      ? "RP"  : "",
>>                        attr & EFI_MEMORY_WP      ? "WP"  : "",
>
> I'm not keen on using "RELY" because I don't think it's at all obvious
> what it means. "RELI" would be closer, but still could use some
> improvement.
>
> Since we turned off this kernel output by default (at least on x86)
> because the line length had grown quite long, maybe we should just
> embrace it and print "RELIABLE" in full?
>

Since its meaning is not at all obvious even when printing RELIABLE in
full, couldn't we simply use 'MR' instead? You need the UEFI spec to
make sense of this anyway ... (Same goes for RUN btw, perhaps RT would
even be clearer there)

-- 
Ard.
