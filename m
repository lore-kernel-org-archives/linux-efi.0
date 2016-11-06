From: Andreas Noever <andreas.noever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 0/3] Apple device properties
Date: Mon, 7 Nov 2016 00:13:18 +0100
Message-ID: <CAMxnaaXF2F=v=HAefZ724bJSub3=0nVYV7KkCOrhE6TMb4OrZA@mail.gmail.com>
References: <cover.1478145888.git.lukas@wunner.de> <20161103233458.GD8845@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161103233458.GD8845-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Nov 4, 2016 at 12:34 AM, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Thu, 03 Nov, at 11:18:48AM, Lukas Wunner wrote:
>> Retrieve device properties from EFI on Macs before ExitBootServices is
>> called and assign them to devices (patch [2/3]). The devices that
>> properties pertain to are encoded as EFI Device Paths, so add a parser
>> for these (patch [1/3]). As a first use case, amend the Thunderbolt driver
>> to take advantage of the Device ROM supplied by EFI (patch [3/3]).
>>
>> Changes since v2:
>>
>> - Renamed get_device_by_efi_path() to efi_get_device_by_path() in
>>   patch [1/3]. (Matt Fleming)
>>
>> - Support multiple instance device paths in patch [1/3]. (Peter Jones)
>>
>> - Validate the size specified in the properties payload in patch [2/3].
>>
>> - Other than that, just some minor polishing and rebasing.
>>
>> Link to v2:
>> http://www.spinics.net/lists/linux-efi/msg09498.html
>>
>> Browseable on GitHub:
>> https://github.com/l1k/linux/commits/apple_properties_v3
>
> Apart from the minor comments I made, I think this is now ready for
> merging.
>
> Andreas, once Lukas spins a v4 of this series, how would you like to
> handle the merging since there are both EFI and thunderbolt changes?
>
> If you'd like me to take this through the EFI tree, that's fine, but
> I'll need an ACK for the thunderbolt changes (PATCH 3).

Hi Matt,

PATCH 3 is acked by me (with one minor comment). I'm fine with pushing
this series through the EFI tree (I'm not expecting many changes on
the tb side, so the should be no conflicts).

Thanks,
Andreas
