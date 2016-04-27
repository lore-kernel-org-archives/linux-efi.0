From: Josh Boyer <jwboyer@fedoraproject.org>
Subject: Re: [PATCH] x86/efi-bgrt: Switch all pr_err() to pr_debug() for
 invalid BGRT
Date: Wed, 27 Apr 2016 09:56:59 -0400
Message-ID: <CA+5PVA71vCaf+a=6cEqQxe4iUQeAK5NN-s09bMDa6_NbXZfMNw@mail.gmail.com>
References: <1461761412-16046-1-git-send-email-jwboyer@fedoraproject.org>
	<5720BE0B.8080605@moshe.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5720BE0B.8080605@moshe.nl>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?Q?M=C3=B4she_van_der_Sterre?= <me@moshe.nl>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>, Josh Triplett <josh@joshtriplett.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Apr 27, 2016 at 9:26 AM, M=C3=B4she van der Sterre <me@moshe.nl=
> wrote:
> (additionally CC-ing Josh Triplett)

Thanks for doing so.  I completely forgot.

> On 04/27/2016 02:50 PM, Josh Boyer wrote:
>>
>> The promise of pretty boot splashes from firmware via BGRT was at
>> best only that; a promise.  The kernel diligently checks to make
>> sure the BGRT data firmware gives it is valid, and dutifully warns
>> the user when it isn't.  However, it does so via the pr_err log
>> level which seems unnecessary.  The user cannot do anything about
>> this and there really isn't an error on the part of Linux to
>> correct.
>>
>> This lowers the log level by using pr_debug instead.  Users will
>> no longer have their boot process uglified by the kernel reminding
>> us that firmware can and often is broken.  Ironic, considering
>> BGRT is supposed to make boot pretty to begin with.
>
> Hi Josh Boyer,
>
> Are you seeing these errors somewhere? I recently fixed the error "Ig=
noring

We have a user that reports seeing:

"Ignoring BGRT: Invalid version 0 (expected 1)"

on a Lenovo T430 machine.  We've had a few other scattered reports on
various machine types since BGRT went into the kernel as well.

> BGRT: invalid status 0 (expected 1)" because Linux apparently interpr=
eted
> that part of the specification differently than others.
> If that's the error you are seeing, perhaps your problem is already s=
olved
> in recent kernels? (fixed in commit 66dbe99)
>
> Personally I agree that BGRT messages should not annoy actual users o=
f
> production firmwares.
> However I also agree with the previous consensus that these checks (f=
or
> actual spec violations) should remain pr_err unless some production f=
irmware
> is triggering them. What do you think?

Production firmware is literally the only firmware end users will ever
see.  I don't see much point in leaving scary error messages in the
kernel to complain about things the user has no chance of fixing or in
almost all cases even reporting to people who could fix it.

josh

>> Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
>> ---
>>   arch/x86/platform/efi/efi-bgrt.c | 18 +++++++++---------
>>   1 file changed, 9 insertions(+), 9 deletions(-)
>>
>> diff --git a/arch/x86/platform/efi/efi-bgrt.c
>> b/arch/x86/platform/efi/efi-bgrt.c
>> index a2433817c987..6f70d2ac8029 100644
>> --- a/arch/x86/platform/efi/efi-bgrt.c
>> +++ b/arch/x86/platform/efi/efi-bgrt.c
>> @@ -43,40 +43,40 @@ void __init efi_bgrt_init(void)
>>                 return;
>>         if (bgrt_tab->header.length < sizeof(*bgrt_tab)) {
>> -               pr_err("Ignoring BGRT: invalid length %u (expected
>> %zu)\n",
>> +               pr_debug("Ignoring BGRT: invalid length %u (expected
>> %zu)\n",
>>                        bgrt_tab->header.length, sizeof(*bgrt_tab));
>>                 return;
>>         }
>>         if (bgrt_tab->version !=3D 1) {
>> -               pr_err("Ignoring BGRT: invalid version %u (expected =
1)\n",
>> +               pr_debug("Ignoring BGRT: invalid version %u (expecte=
d
>> 1)\n",
>>                        bgrt_tab->version);
>>                 return;
>>         }
>>         if (bgrt_tab->status & 0xfe) {
>> -               pr_err("Ignoring BGRT: reserved status bits are non-=
zero
>> %u\n",
>> +               pr_debug("Ignoring BGRT: reserved status bits are no=
n-zero
>> %u\n",
>>                        bgrt_tab->status);
>>                 return;
>>         }
>>         if (bgrt_tab->image_type !=3D 0) {
>> -               pr_err("Ignoring BGRT: invalid image type %u (expect=
ed
>> 0)\n",
>> +               pr_debug("Ignoring BGRT: invalid image type %u (expe=
cted
>> 0)\n",
>>                        bgrt_tab->image_type);
>>                 return;
>>         }
>>         if (!bgrt_tab->image_address) {
>> -               pr_err("Ignoring BGRT: null image address\n");
>> +               pr_debug("Ignoring BGRT: null image address\n");
>>                 return;
>>         }
>>         image =3D memremap(bgrt_tab->image_address, sizeof(bmp_heade=
r),
>> MEMREMAP_WB);
>>         if (!image) {
>> -               pr_err("Ignoring BGRT: failed to map image header
>> memory\n");
>> +               pr_debug("Ignoring BGRT: failed to map image header
>> memory\n");
>>                 return;
>>         }
>>         memcpy(&bmp_header, image, sizeof(bmp_header));
>>         memunmap(image);
>>         if (bmp_header.id !=3D 0x4d42) {
>> -               pr_err("Ignoring BGRT: Incorrect BMP magic number 0x=
%x
>> (expected 0x4d42)\n",
>> +               pr_debug("Ignoring BGRT: Incorrect BMP magic number =
0x%x
>> (expected 0x4d42)\n",
>>                         bmp_header.id);
>>                 return;
>>         }
>> @@ -84,14 +84,14 @@ void __init efi_bgrt_init(void)
>>         bgrt_image =3D kmalloc(bgrt_image_size, GFP_KERNEL | __GFP_N=
OWARN);
>>         if (!bgrt_image) {
>> -               pr_err("Ignoring BGRT: failed to allocate memory for=
 image
>> (wanted %zu bytes)\n",
>> +               pr_debug("Ignoring BGRT: failed to allocate memory f=
or
>> image (wanted %zu bytes)\n",
>>                        bgrt_image_size);
>>                 return;
>>         }
>>         image =3D memremap(bgrt_tab->image_address, bmp_header.size,
>> MEMREMAP_WB);
>>         if (!image) {
>> -               pr_err("Ignoring BGRT: failed to map image memory\n"=
);
>> +               pr_debug("Ignoring BGRT: failed to map image memory\=
n");
>>                 kfree(bgrt_image);
>>                 bgrt_image =3D NULL;
>>                 return;
>
>
