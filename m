From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] efi/cper: Fix endianness of PCI class code
Date: Wed, 10 May 2017 09:03:11 +0100
Message-ID: <CAKv+Gu_4xHhX8oK847k8=s5S7Mx3sALPTtX8Eo=2+9uZyQoEAQ@mail.gmail.com>
References: <771bc335fb5856792d086ae7db288dcf244cb4cd.1493964354.git.lukas@wunner.de>
 <CAKv+Gu9PpmTBbSMKUsx6svm6fodV8x=i4b1j8QGapnEoCFcrNA@mail.gmail.com> <20170506090755.GB19740@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20170506090755.GB19740@wunner.de>
Sender: linux-pci-owner@vger.kernel.org
To: Lukas Wunner <lukas@wunner.de>, Arnd Bergmann <arnd@arndb.de>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Ashok Raj <ashok.raj@intel.com>, linux-pci <linux-pci@vger.kernel.org>, Huang Ying <ying.huang@intel.com>
List-Id: linux-efi@vger.kernel.org

(+ Arnd)

Full patch here: http://marc.info/?l=linux-pci&m=149400953408528

On 6 May 2017 at 10:07, Lukas Wunner <lukas@wunner.de> wrote:
> On Sat, May 06, 2017 at 08:46:07AM +0100, Ard Biesheuvel wrote:
>> On 5 May 2017 at 19:38, Lukas Wunner <lukas@wunner.de> wrote:
>> > The CPER parser assumes that the class code is big endian, but at least
>> > on this edk2-derived Intel Purley platform it's little endian:
> [snip]
>> > --- a/include/linux/cper.h
>> > +++ b/include/linux/cper.h
>> > @@ -416,7 +416,7 @@ struct cper_sec_pcie {
>> >         struct {
>> >                 __u16   vendor_id;
>> >                 __u16   device_id;
>> > -               __u8    class_code[3];
>> > +               __u32   class_code:24;
>>
>> I'd like to avoid this change if we can. Couldn't we simply invert the
>> order of p[] above?
>
> Hm, why would you like to avoid it?

Because we shouldn't use bitfields in structs in code that should be
portable across archs with different endiannesses.

>  The class_code element isn't
> referenced anywhere else in the kernel and this isn't a uapi header,
> so the change would only impact out-of-tree drivers.  Not sure if
> any exist which might be interested in CPER parsing.
>

The point is that the change in the struct definition is simply not
necessary, given that inverting the order of p[] already achieves
exactly what we want.
