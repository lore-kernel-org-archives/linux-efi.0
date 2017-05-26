From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] efi/cper: Fix endianness of PCI class code
Date: Fri, 26 May 2017 11:16:55 +0200
Message-ID: <CAKv+Gu_fbNSK+LuWmQGqLHtu3rF9BdYwNB+K-myNXS=X+goXkQ@mail.gmail.com>
References: <20170506090755.GB19740@wunner.de> <CAKv+Gu_4xHhX8oK847k8=s5S7Mx3sALPTtX8Eo=2+9uZyQoEAQ@mail.gmail.com>
 <20170510084143.GA16261@wunner.de> <CAKv+Gu81gvNL1jkb3T35=-5fr_x-BmSg9X2CcQ97xv5JTZ-c1A@mail.gmail.com>
 <20170525123047.GA4172@wunner.de> <CAKv+Gu_3vYKGOrzC8+Y3QwXOtV8Tbm8HC7nzQCdKVB1Qbdoriw@mail.gmail.com>
 <20170525124445.GA4181@wunner.de> <CAKv+Gu-7dr=upMcs2SsE+7+LRA2q82=exDrtt6CMniiMjZU2YA@mail.gmail.com>
 <20170525125650.GA4196@wunner.de> <CAKv+Gu_==Q5L+w2ihZ6u-=_AKZJun8D=sUWhgx6Pvzt-K99fTA@mail.gmail.com>
 <20170526060843.GA4446@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20170526060843.GA4446@wunner.de>
Sender: linux-pci-owner@vger.kernel.org
To: Lukas Wunner <lukas@wunner.de>
Cc: Arnd Bergmann <arnd@arndb.de>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Ashok Raj <ashok.raj@intel.com>, linux-pci <linux-pci@vger.kernel.org>, Huang Ying <ying.huang@intel.com>
List-Id: linux-efi@vger.kernel.org

On 25 May 2017 at 23:08, Lukas Wunner <lukas@wunner.de> wrote:
> On Thu, May 25, 2017 at 06:07:35AM -0700, Ard Biesheuvel wrote:
>> On 25 May 2017 at 05:56, Lukas Wunner <lukas@wunner.de> wrote:
>> > On Thu, May 25, 2017 at 05:47:59AM -0700, Ard Biesheuvel wrote:
>> >> On 25 May 2017 at 05:44, Lukas Wunner <lukas@wunner.de> wrote:
>> >> > On Thu, May 25, 2017 at 05:36:01AM -0700, Ard Biesheuvel wrote:
>> >> >> On 25 May 2017 at 05:30, Lukas Wunner <lukas@wunner.de> wrote:
>> >> >> > On Thu, May 11, 2017 at 03:06:42PM +0100, Ard Biesheuvel wrote:
>> >> >> >> On 10 May 2017 at 09:41, Lukas Wunner <lukas@wunner.de> wrote:
>> >> >> >> > On Wed, May 10, 2017 at 09:03:11AM +0100, Ard Biesheuvel wrote:
>> >> >> >> >> On 6 May 2017 at 10:07, Lukas Wunner <lukas@wunner.de> wrote:
>> >> >> >> >> > On Sat, May 06, 2017 at 08:46:07AM +0100, Ard Biesheuvel wrote:
>> >> >> >> >> >> On 5 May 2017 at 19:38, Lukas Wunner <lukas@wunner.de> wrote:
>> >> >> >> >> >> > The CPER parser assumes that the class code is big endian, but at least
>> >> >> >> >> >> > on this edk2-derived Intel Purley platform it's little endian:
>> >> >> >> >> > [snip]
>> >> >> >> >> >> > --- a/include/linux/cper.h
>> >> >> >> >> >> > +++ b/include/linux/cper.h
>> >> >> >> >> >> > @@ -416,7 +416,7 @@ struct cper_sec_pcie {
>> >> >> >> >> >> >         struct {
>> >> >> >> >> >> >                 __u16   vendor_id;
>> >> >> >> >> >> >                 __u16   device_id;
>> >> >> >> >> >> > -               __u8    class_code[3];
>> >> >> >> >> >> > +               __u32   class_code:24;
>> >> >> >> >> >>
>> >> >> >> >> >> I'd like to avoid this change if we can. Couldn't we simply invert the
>> >> >> >> >> >> order of p[] above?
>> >> >> >> >> >
>> >> >> >> >> > Hm, why would you like to avoid it?
>> >> >> >> >>
>> >> >> >> >> Because we shouldn't use bitfields in structs in code that should be
>> >> >> >> >> portable across archs with different endiannesses.
>> >> >> >> >
>> >> >> >> > The CPER header is defined in the UEFI spec and UEFI mandates that the
>> >> >> >> > arch is little endian (UEFI r2.6, sec. 2.3.5, 2.3.6).
>> >> >> >> >
>> >> >> >>
>> >> >> >> No it does not mandate that at all. It mandates how the core should be
>> >> >> >> configured when running in UEFI, but the OS can do anything it likes.
>> >> >> >>
>> >> >> >> We are still interested in adding limited UEFI support to big endian
>> >> >> >> arm64 in the future (i.e., access to a limited set of firmware tables
>> >> >> >> but no runtime services), and I am not going to merge anything that
>> >> >> >> moves us away from that goal.
>> >> >> >>
>> >> >> >> > So your argument seems moot to me.  Am I missing something?  Do you
>> >> >> >> > have another argument?
>> >> >> >> >
>> >> >> >> > Moreover, the vendor_id and device_id fields are little endian as well
>> >> >> >> > (PCI r3.0, sec. 6.1), yet there are no provisions in our CPER parser in
>> >> >> >> > drivers/firmware/efi/cper.c to convert them to the endianness of the host.
>> >> >> >> >
>> >> >> >>
>> >> >> >> Indeed. I am aware we will need to add various endian-neutral
>> >> >> >> accessors in the future.
>> >> >> >>
>> >> >> >> >> >  The class_code element isn't
>> >> >> >> >> > referenced anywhere else in the kernel and this isn't a uapi header,
>> >> >> >> >> > so the change would only impact out-of-tree drivers.  Not sure if
>> >> >> >> >> > any exist which might be interested in CPER parsing.
>> >> >> >> >> >
>> >> >> >> >>
>> >> >> >> >> The point is that the change in the struct definition is simply not
>> >> >> >> >> necessary, given that inverting the order of p[] already achieves
>> >> >> >> >> exactly what we want.
>> >> >> >> >
>> >> >> >> > It seems clumsy and unnecessary to me so I'd prefer the bitfield.
>> >> >> >> > Please excuse my stubbornness.
>> >> >> >> >
>> >> >> >>
>> >> >> >> Stubbornness alone is not going to convince me. What *could* convince
>> >> >> >> me (although unlikely) is a quote from the C spec which explains why
>> >> >> >> it is 100% legal to make assumptions about how bitfields are projected
>> >> >> >> onto byte locations in memory.
>> >> >> >
>> >> >> > All structs in cper.h are declared "packed", so what you're asking for
>> >> >> > isn't defined in the C spec but in the GCC documentation:
>> >> >> >
>> >> >> >    "The packed attribute specifies that a variable or structure field
>> >> >> >     should have the smallest possible alignment -- one byte for a variable,
>> >> >> >     and one bit for a field, unless you specify a larger value with the
>> >> >> >     aligned attribute."
>> >> >> >
>> >> >> > So I maintain that the patch is fine, but you'll need to use le32_to_cpu(),
>> >> >> > le16_to_cpu() etc both for the class_code changed by the patch as well as
>> >> >> > all the other members of the struct not touched by the patch when adding
>> >> >> > "endianness mixed mode" for aarch64.
>> >> >>
>> >> >> I'm not talking about the 'packed' attribute but about the fact that
>> >> >> the C spec does not guarantee that bitfields are projected onto byte
>> >> >> locations in memory in the way you expect.
>> >> >
>> >> > What relevance does that have as long as the header file uses a pragma
>> >> > specific to gcc (or other compilers that are compatible to gcc with
>> >> > respect to that pragma (such as clang)), and gcc guarantees the
>> >> > correct layout regardless of endianness?
>> >>
>> >> The relevance is that we should not add GCC specific code because you
>> >> think it looks prettier.
>> >
>> > The code already *is* gcc-specific.
>> >
>>
>> The entire kernel is GCC specific. But that does not justify adding
>> more GCC-isms throughout the code.
>
> How is the patch adding a GCC-ism?
>

Because you rely on behavior which is not defined by the C spec.

>
>> >> And where does GCC guarantee the correct layout? Did you find an
>> >> unambiguous GCC documentation reference that explains how bitfields
>> >> are mapped onto byte locations?
>> >
>> > See the excerpt I quoted above.
>> >
>>
>> 'packed' has nothing to do with it. This is about bitfields in structs.
>
> 'packed' has *everything* to do with it. :-)
>
> The struct contains a *single* bitfield surrounded by non-bitfields.
> If there were multiple consecutive bitfields, then yes, things wouldn't
> be as clear.
>
> The bitfield as well as all surrounding non-bitfields have a size which
> is a multiple of full bytes.  And this is where the 'packed' attribute
> comes into play, it guarantees that there's no padding as long as all
> members of the struct are byte-aligned.
>

No, it does not guarantee that at all. Observed behavior != guarantee.
'Guarantee' implies that it is documented in a pertinent spec, and
that we can file a bug with the GCC/Clang projects if the behavior
changes at any point.

Nobody is asking you to theorize and make inferences about how
attribute X and behavior Y offer guarantee Z. All it takes is an
unambiguous quote from the C spec that describes how the struct
definition is mapped onto bits in memory. You have offered no such
quote, for which I don't blame you because I am convinced that the C
spec does not define this in sufficient detail.

>
>>
>> >
>> >> Or does 'guarantee' mean 'I tested it and it works'?
>> >
>> > I tested it with x86_64 (le) and ppc32 (be) and it works.
>> > I don't have an aarch64 machine available here.
>> >
>>
>> Good.
>
> Good to merge then?
>

No. For the last time, this patch will not be merged. The only
approach that will be merged is keeping the char[3] array and
inverting the order of the printk() arguments.

-- 
Ard.
