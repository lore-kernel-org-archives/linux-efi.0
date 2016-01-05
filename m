From: =?UTF-8?Q?M=c3=b4she_van_der_Sterre?= <me-A/3C56C7qwM@public.gmane.org>
Subject: Re: [PATCH] x86/efi-bgrt: Don't ignore the BGRT if the 'valid' bit is
 0
Date: Tue, 5 Jan 2016 17:38:54 +0100
Message-ID: <568BF19E.3040701@moshe.nl>
References: <1450648391-4631-1-git-send-email-me@moshe.nl>
 <20160105154640.GB2714@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160105154640.GB2714-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 01/05/2016 04:46 PM, Matt Fleming wrote:
> On Sun, 20 Dec, at 10:53:11PM, M=F4she van der Sterre wrote:
>> Unintuitively, the BGRT graphic is apparently meant to be usable if
>> the valid bit in not set. The valid bit only conveys uncertainty
>> about the validity in relation to the screen state.
>>
>> Windows 10 actually uses the BGRT image for its boot screen even if
>> not 'valid', for example when the user triggered the boot menu.
>> Because it is unclear if all firmwares will provide a usable graphic
>> in this case, we now look at the BMP magic number as an additional
>> check.
>> ---
>>   arch/x86/platform/efi/efi-bgrt.c | 10 +++++-----
>>   1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/ef=
i/efi-bgrt.c
>> index b097066..a243381 100644
>> --- a/arch/x86/platform/efi/efi-bgrt.c
>> +++ b/arch/x86/platform/efi/efi-bgrt.c
>> @@ -57,11 +57,6 @@ void __init efi_bgrt_init(void)
>>   		       bgrt_tab->status);
>>   		return;
>>   	}
>> -	if (bgrt_tab->status !=3D 1) {
>> -		pr_debug("Ignoring BGRT: invalid status %u (expected 1)\n",
>> -			 bgrt_tab->status);
>> -		return;
>> -	}
>>   	if (bgrt_tab->image_type !=3D 0) {
>>   		pr_err("Ignoring BGRT: invalid image type %u (expected 0)\n",
>>   		       bgrt_tab->image_type);
>> @@ -80,6 +75,11 @@ void __init efi_bgrt_init(void)
>>  =20
>>   	memcpy(&bmp_header, image, sizeof(bmp_header));
>>   	memunmap(image);
>> +	if (bmp_header.id !=3D 0x4d42) {
>> +		pr_err("Ignoring BGRT: Incorrect BMP magic number 0x%x (expected =
0x4d42)\n",
>> +			bmp_header.id);
>> +		return;
>> +	}
>>   	bgrt_image_size =3D bmp_header.size;
>>  =20
>>   	bgrt_image =3D kmalloc(bgrt_image_size, GFP_KERNEL | __GFP_NOWARN=
);
>
> Shouldn't this be pr_debug() instead of pr_err()?

It is an actual error for the image to be anything else. I did look at=20
your commit "x86/efi-bgrt: Switch pr_err() to pr_debug() for invalid=20
BGRT", and actually intentionally chose pr_err() instead of pr_debug()=20
because of it.

 From that commit message:
     However, Josh points that out it still makes sense to test the
     validity of the upper 7 bits of the 'status' field, since
     they're marked as "reserved" in the spec and must be zero. If
     firmware violates this it really *is* an error.

 From the ACPI spec:
     If the value is 0, the Image Type is Bitmap. The format for a=20
Bitmap is defined at the reference located in the ACPI Link Document=20
under the heading "Types of Bitmaps". All other values not defined in=20
the table are reserved for future use.
and also:
     Implementations must present the image in a 24 bit bitmap with=20
pixel format 0xRRGGBB, or a 32-bit bitmap with the pixel format=20
0xrrRRGGBB, where =91rr=92 is reserved.
=46ollowing the link to MSDN, the header id is definitely also required=
 to=20
be "BM" for those types,


That said, I'm not 100% sure if pr_err() is right for any of the errors=
=20
in efi-bgrt.c. I don't really feel knowledgeable enough to suggest=20
anything about that, so I tried to follow the previous discussion=20
outcome as closely as possible.

By the way... Now I'm thinking about the ID, what about endianness? Thi=
s=20
code is under "arch/x86", does this always imply a little-endian=20
architecture? The new check will probably fail on big-endian but that=20
should never happen, right?

Greetings,
M=F4she van der Sterre
