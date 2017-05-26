From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH] efi/cper: Fix endianness of PCI class code
Date: Fri, 26 May 2017 12:43:23 +0200
Message-ID: <20170526104323.GA4744@wunner.de>
References: <20170510084143.GA16261@wunner.de>
 <CAKv+Gu81gvNL1jkb3T35=-5fr_x-BmSg9X2CcQ97xv5JTZ-c1A@mail.gmail.com>
 <20170525123047.GA4172@wunner.de>
 <CAKv+Gu_3vYKGOrzC8+Y3QwXOtV8Tbm8HC7nzQCdKVB1Qbdoriw@mail.gmail.com>
 <20170525124445.GA4181@wunner.de>
 <CAKv+Gu-7dr=upMcs2SsE+7+LRA2q82=exDrtt6CMniiMjZU2YA@mail.gmail.com>
 <20170525125650.GA4196@wunner.de>
 <CAKv+Gu_==Q5L+w2ihZ6u-=_AKZJun8D=sUWhgx6Pvzt-K99fTA@mail.gmail.com>
 <20170526060843.GA4446@wunner.de>
 <CAKv+Gu_fbNSK+LuWmQGqLHtu3rF9BdYwNB+K-myNXS=X+goXkQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_fbNSK+LuWmQGqLHtu3rF9BdYwNB+K-myNXS=X+goXkQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ashok Raj <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-pci <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, May 26, 2017 at 11:16:55AM +0200, Ard Biesheuvel wrote:
> No. For the last time

Alright, don't get mad at me.

I was hoping that we could have a technical discussion on whether the
proposed patch is technically correct, on all arches.  You seem to
dispute that, I maintain it.  I'd like to learn something new and was
hoping I'm not alone there.


> On 25 May 2017 at 23:08, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org> wrote:
> > On Thu, May 25, 2017 at 06:07:35AM -0700, Ard Biesheuvel wrote:
> >> On 25 May 2017 at 05:56, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org> wrote:
> >> > On Thu, May 25, 2017 at 05:47:59AM -0700, Ard Biesheuvel wrote:
> >> >> On 25 May 2017 at 05:44, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org> wrote:
> >> >> > On Thu, May 25, 2017 at 05:36:01AM -0700, Ard Biesheuvel wrote:
> >> >> >> On 25 May 2017 at 05:30, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org> wrote:
> >> >> >> > On Thu, May 11, 2017 at 03:06:42PM +0100, Ard Biesheuvel wrote:
> >> >> >> >> On 10 May 2017 at 09:41, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org> wrote:
> >> >> >> >> > On Wed, May 10, 2017 at 09:03:11AM +0100, Ard Biesheuvel wrote:
> >> >> >> >> >> On 6 May 2017 at 10:07, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org> wrote:
> >> >> >> >> >> > On Sat, May 06, 2017 at 08:46:07AM +0100, Ard Biesheuvel wrote:
> >> >> >> >> >> >> On 5 May 2017 at 19:38, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org> wrote:
> >> >> >> >> >> >> > The CPER parser assumes that the class code is big endian, but at least
> >> >> >> >> >> >> > on this edk2-derived Intel Purley platform it's little endian:
> >> >> >> >> >> > [snip]
> >> >> >> >> >> >> > --- a/include/linux/cper.h
> >> >> >> >> >> >> > +++ b/include/linux/cper.h
> >> >> >> >> >> >> > @@ -416,7 +416,7 @@ struct cper_sec_pcie {
> >> >> >> >> >> >> >         struct {
> >> >> >> >> >> >> >                 __u16   vendor_id;
> >> >> >> >> >> >> >                 __u16   device_id;
> >> >> >> >> >> >> > -               __u8    class_code[3];
> >> >> >> >> >> >> > +               __u32   class_code:24;
> >> >> >> >> >> >>
> >> >> >> >> >> >> I'd like to avoid this change if we can. Couldn't we simply invert the
> >> >> >> >> >> >> order of p[] above?
> >> >> >> >> >> >
> >> >> >> >> >> > Hm, why would you like to avoid it?
> >> >> >> >> >>
> >> >> >> >> >> Because we shouldn't use bitfields in structs in code that should be
> >> >> >> >> >> portable across archs with different endiannesses.
> >> >> >> >> >
> >> >> >> >> > The CPER header is defined in the UEFI spec and UEFI mandates that the
> >> >> >> >> > arch is little endian (UEFI r2.6, sec. 2.3.5, 2.3.6).
> >> >> >> >> >
> >> >> >> >>
> >> >> >> >> No it does not mandate that at all. It mandates how the core should be
> >> >> >> >> configured when running in UEFI, but the OS can do anything it likes.
> >> >> >> >>
> >> >> >> >> We are still interested in adding limited UEFI support to big endian
> >> >> >> >> arm64 in the future (i.e., access to a limited set of firmware tables
> >> >> >> >> but no runtime services), and I am not going to merge anything that
> >> >> >> >> moves us away from that goal.
> >> >> >> >>
> >> >> >> >> > So your argument seems moot to me.  Am I missing something?  Do you
> >> >> >> >> > have another argument?
> >> >> >> >> >
> >> >> >> >> > Moreover, the vendor_id and device_id fields are little endian as well
> >> >> >> >> > (PCI r3.0, sec. 6.1), yet there are no provisions in our CPER parser in
> >> >> >> >> > drivers/firmware/efi/cper.c to convert them to the endianness of the host.
> >> >> >> >> >
> >> >> >> >>
> >> >> >> >> Indeed. I am aware we will need to add various endian-neutral
> >> >> >> >> accessors in the future.
> >> >> >> >>
> >> >> >> >> >> >  The class_code element isn't
> >> >> >> >> >> > referenced anywhere else in the kernel and this isn't a uapi header,
> >> >> >> >> >> > so the change would only impact out-of-tree drivers.  Not sure if
> >> >> >> >> >> > any exist which might be interested in CPER parsing.
> >> >> >> >> >> >
> >> >> >> >> >>
> >> >> >> >> >> The point is that the change in the struct definition is simply not
> >> >> >> >> >> necessary, given that inverting the order of p[] already achieves
> >> >> >> >> >> exactly what we want.
> >> >> >> >> >
> >> >> >> >> > It seems clumsy and unnecessary to me so I'd prefer the bitfield.
> >> >> >> >> > Please excuse my stubbornness.
> >> >> >> >> >
> >> >> >> >>
> >> >> >> >> Stubbornness alone is not going to convince me. What *could* convince
> >> >> >> >> me (although unlikely) is a quote from the C spec which explains why
> >> >> >> >> it is 100% legal to make assumptions about how bitfields are projected
> >> >> >> >> onto byte locations in memory.
> >> >> >> >
> >> >> >> > All structs in cper.h are declared "packed", so what you're asking for
> >> >> >> > isn't defined in the C spec but in the GCC documentation:
> >> >> >> >
> >> >> >> >    "The packed attribute specifies that a variable or structure field
> >> >> >> >     should have the smallest possible alignment -- one byte for a variable,
> >> >> >> >     and one bit for a field, unless you specify a larger value with the
> >> >> >> >     aligned attribute."
> >> >> >> >
> >> >> >> > So I maintain that the patch is fine, but you'll need to use le32_to_cpu(),
> >> >> >> > le16_to_cpu() etc both for the class_code changed by the patch as well as
> >> >> >> > all the other members of the struct not touched by the patch when adding
> >> >> >> > "endianness mixed mode" for aarch64.
> >> >> >>
> >> >> >> I'm not talking about the 'packed' attribute but about the fact that
> >> >> >> the C spec does not guarantee that bitfields are projected onto byte
> >> >> >> locations in memory in the way you expect.
> >> >> >
> >> >> > What relevance does that have as long as the header file uses a pragma
> >> >> > specific to gcc (or other compilers that are compatible to gcc with
> >> >> > respect to that pragma (such as clang)), and gcc guarantees the
> >> >> > correct layout regardless of endianness?
> >> >>
> >> >> The relevance is that we should not add GCC specific code because you
> >> >> think it looks prettier.
> >> >
> >> > The code already *is* gcc-specific.
> >>
> >> The entire kernel is GCC specific. But that does not justify adding
> >> more GCC-isms throughout the code.
> >
> > How is the patch adding a GCC-ism?
> >
> 
> Because you rely on behavior which is not defined by the C spec.

I'm relying on the same behavior that the existing code relies on:

That 'packed' guarantees no padding if all struct members have a
size which is a multiple of full bytes.

So I'm not *adding* a GCC-ism.


> >> >> And where does GCC guarantee the correct layout? Did you find an
> >> >> unambiguous GCC documentation reference that explains how bitfields
> >> >> are mapped onto byte locations?
> >> >
> >> > See the excerpt I quoted above.
> >> >
> >>
> >> 'packed' has nothing to do with it. This is about bitfields in structs.
> >
> > 'packed' has *everything* to do with it. :-)
> >
> > The struct contains a *single* bitfield surrounded by non-bitfields.
> > If there were multiple consecutive bitfields, then yes, things wouldn't
> > be as clear.
> >
> > The bitfield as well as all surrounding non-bitfields have a size which
> > is a multiple of full bytes.  And this is where the 'packed' attribute
> > comes into play, it guarantees that there's no padding as long as all
> > members of the struct are byte-aligned.
> >
> 
> No, it does not guarantee that at all. Observed behavior != guarantee.
> 'Guarantee' implies that it is documented in a pertinent spec, and
> that we can file a bug with the GCC/Clang projects if the behavior
> changes at any point.

I did quote the pertinent spec above, the source is:

https://gcc.gnu.org/onlinedocs/gcc-7.1.0/gcc/Common-Variable-Attributes.html


> Nobody is asking you to theorize and make inferences about how
> attribute X and behavior Y offer guarantee Z. All it takes is an
> unambiguous quote from the C spec that describes how the struct
> definition is mapped onto bits in memory. You have offered no such
> quote, for which I don't blame you because I am convinced that the C
> spec does not define this in sufficient detail.

I thought I did prove that, let me try again:

C99 sec. 6.7.2.1:
	An implementation may allocate any addressable storage unit large
	enough to hold a bit-field.

=> So the bit-field could occupy more than 3 bytes.  Why doesn't it do
   that?  Because GCC's 'packed' attribute guarantees "the smallest
   possible alignment -- one byte for a variable, and one bit for a field".
   The existing declaration "__u8 class_code[3]" leverages that same
   guarantee.

Further in 6.7.2.1:

	If enough space remains, a bit-field that immediately follows
	another bit-field in a structure shall be packed into adjacent
	bits of the same unit. If insufficient space remains, whether
	a bit-field that does not fit is put into the next unit or
	overlaps adjacent units is implementation-defined. The order of
	allocation of bit-fields within a unit (high-order to low-order
	or low-order to high-order) is implementation-defined.

=> That's what I meant when I said it would be a different story if there
   were multiple consecutive bit-fields.  But in this case there's just
   a single bit-field surrounded by non-bit-fields.

Further in 6.7.2.1:

	Each non-bit-field member of a structure or union object is
	aligned in an implementation-defined manner appropriate to
	its type.

=> So the alignment of all the non-bit-field members is likewise
   solely enforced by gcc's 'packed' attribute.

Further in 6.7.2.1:

	Within a structure object, the non-bit-field members and the
	units in which bit-fields reside have addresses that increase
	in the order in which they are declared.

=> This should answer your question how struct members are projected
   onto byte locations in memory.

=> Bottom line is that the behavior both of the existing code, as well
   as of the proposed patch, relies on the semantics of gcc's 'packed'
   attribute.  Agree or disagree?


> >> >> Or does 'guarantee' mean 'I tested it and it works'?
> >> >
> >> > I tested it with x86_64 (le) and ppc32 (be) and it works.
> >> > I don't have an aarch64 machine available here.

Forgot to mention, I tested with both clang and gcc.


> > Good to merge then?
> 
> this patch will not be merged. The only
> approach that will be merged is keeping the char[3] array and
> inverting the order of the printk() arguments.

Fine by me.

However I note that your original objection was based on the allegation
that the patch would move you away from your goal of implementing
endianness-mixed-mode on aarch64.

After I've shown that it does not, you're unconditionally saying no.

I respectfully submit that moving the goal posts like that may not be
the best approach to maintainership.

Thanks,

Lukas
