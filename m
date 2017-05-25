From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] efi/cper: Fix endianness of PCI class code
Date: Thu, 25 May 2017 05:36:01 -0700
Message-ID: <CAKv+Gu_3vYKGOrzC8+Y3QwXOtV8Tbm8HC7nzQCdKVB1Qbdoriw@mail.gmail.com>
References: <771bc335fb5856792d086ae7db288dcf244cb4cd.1493964354.git.lukas@wunner.de>
 <CAKv+Gu9PpmTBbSMKUsx6svm6fodV8x=i4b1j8QGapnEoCFcrNA@mail.gmail.com>
 <20170506090755.GB19740@wunner.de> <CAKv+Gu_4xHhX8oK847k8=s5S7Mx3sALPTtX8Eo=2+9uZyQoEAQ@mail.gmail.com>
 <20170510084143.GA16261@wunner.de> <CAKv+Gu81gvNL1jkb3T35=-5fr_x-BmSg9X2CcQ97xv5JTZ-c1A@mail.gmail.com>
 <20170525123047.GA4172@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170525123047.GA4172-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ashok Raj <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-pci <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 25 May 2017 at 05:30, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org> wrote:
> On Thu, May 11, 2017 at 03:06:42PM +0100, Ard Biesheuvel wrote:
>> On 10 May 2017 at 09:41, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org> wrote:
>> > On Wed, May 10, 2017 at 09:03:11AM +0100, Ard Biesheuvel wrote:
>> >> On 6 May 2017 at 10:07, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org> wrote:
>> >> > On Sat, May 06, 2017 at 08:46:07AM +0100, Ard Biesheuvel wrote:
>> >> >> On 5 May 2017 at 19:38, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org> wrote:
>> >> >> > The CPER parser assumes that the class code is big endian, but at least
>> >> >> > on this edk2-derived Intel Purley platform it's little endian:
>> >> > [snip]
>> >> >> > --- a/include/linux/cper.h
>> >> >> > +++ b/include/linux/cper.h
>> >> >> > @@ -416,7 +416,7 @@ struct cper_sec_pcie {
>> >> >> >         struct {
>> >> >> >                 __u16   vendor_id;
>> >> >> >                 __u16   device_id;
>> >> >> > -               __u8    class_code[3];
>> >> >> > +               __u32   class_code:24;
>> >> >>
>> >> >> I'd like to avoid this change if we can. Couldn't we simply invert the
>> >> >> order of p[] above?
>> >> >
>> >> > Hm, why would you like to avoid it?
>> >>
>> >> Because we shouldn't use bitfields in structs in code that should be
>> >> portable across archs with different endiannesses.
>> >
>> > The CPER header is defined in the UEFI spec and UEFI mandates that the
>> > arch is little endian (UEFI r2.6, sec. 2.3.5, 2.3.6).
>> >
>>
>> No it does not mandate that at all. It mandates how the core should be
>> configured when running in UEFI, but the OS can do anything it likes.
>>
>> We are still interested in adding limited UEFI support to big endian
>> arm64 in the future (i.e., access to a limited set of firmware tables
>> but no runtime services), and I am not going to merge anything that
>> moves us away from that goal.
>>
>> > So your argument seems moot to me.  Am I missing something?  Do you
>> > have another argument?
>> >
>> > Moreover, the vendor_id and device_id fields are little endian as well
>> > (PCI r3.0, sec. 6.1), yet there are no provisions in our CPER parser in
>> > drivers/firmware/efi/cper.c to convert them to the endianness of the host.
>> >
>>
>> Indeed. I am aware we will need to add various endian-neutral
>> accessors in the future.
>>
>> >> >  The class_code element isn't
>> >> > referenced anywhere else in the kernel and this isn't a uapi header,
>> >> > so the change would only impact out-of-tree drivers.  Not sure if
>> >> > any exist which might be interested in CPER parsing.
>> >> >
>> >>
>> >> The point is that the change in the struct definition is simply not
>> >> necessary, given that inverting the order of p[] already achieves
>> >> exactly what we want.
>> >
>> > It seems clumsy and unnecessary to me so I'd prefer the bitfield.
>> > Please excuse my stubbornness.
>> >
>>
>> Stubbornness alone is not going to convince me. What *could* convince
>> me (although unlikely) is a quote from the C spec which explains why
>> it is 100% legal to make assumptions about how bitfields are projected
>> onto byte locations in memory.
>
> All structs in cper.h are declared "packed", so what you're asking for
> isn't defined in the C spec but in the GCC documentation:
>
>    "The packed attribute specifies that a variable or structure field
>     should have the smallest possible alignment -- one byte for a variable,
>     and one bit for a field, unless you specify a larger value with the
>     aligned attribute."
>
> So I maintain that the patch is fine, but you'll need to use le32_to_cpu(),
> le16_to_cpu() etc both for the class_code changed by the patch as well as
> all the other members of the struct not touched by the patch when adding
> "endianness mixed mode" for aarch64.
>

I'm not talking about the 'packed' attribute but about the fact that
the C spec does not guarantee that bitfields are projected onto byte
locations in memory in the way you expect.
