From: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 0/2] efi: Enhance capsule loader to support signed Quark
 images
Date: Wed, 15 Feb 2017 19:47:11 +0100
Message-ID: <63c7f925-869e-1053-2f80-0fbb680dcc2f@siemens.com>
References: <cover.1487182480.git.jan.kiszka@siemens.com>
 <CAKv+Gu_4UVAVp0WJT4drY8MijD7-CuhLUghVNhoLA-1VjQ_m4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu_4UVAVp0WJT4drY8MijD7-CuhLUghVNhoLA-1VjQ_m4w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 2017-02-15 19:17, Ard Biesheuvel wrote:
> On 15 February 2017 at 18:14, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org> wrote:
>> See patch 2 for the background.
>>
>> Series has been tested on the Galileo Gen2, to exclude regressions, with
>> a firmware.cap without security header and the SIMATIC IOT2040 which
>> requires the header because of its mandatory secure boot.
>>
> 
> Hello Jan,
> 
> What is a Quark? Is it in the UEFI spec?

http://ark.intel.com/products/79084/Intel-Quark-SoC-X1000-16K-Cache-400-MHz

I didn't find any obvious reference to this format in the UEFI spec.
This might be specific to the Quark UEFI EDK2 that Intel ships (it's not
in upstream edk2) and that was used as foundation for the IOT2000
series. The capsule driver that Intel includes in their Galileo BSP does
something similar (I don't have a browsable reference to that at hand,
sorry, must be in this nice package
https://downloadcenter.intel.com/download/24702/Intel-Galileo-Board-GPL-Compliance-files-1-0-4?product=83137).

Jan

> 
>> Jan Kiszka (2):
>>   efi/capsule: Prepare for loading images with security header
>>   efi/capsule: Add support for Quark security header
>>
>>  drivers/firmware/efi/capsule-loader.c | 73 ++++++++++++++++++++++++++++++-----
>>  drivers/firmware/efi/capsule.c        | 19 +++++++--
>>  include/linux/efi.h                   |  2 +-
>>  3 files changed, 79 insertions(+), 15 deletions(-)
>>
>> --
>> 2.1.4
>>


-- 
Siemens AG, Corporate Technology, CT RDA ITP SES-DE
Corporate Competence Center Embedded Linux
