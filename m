From: Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH] efi/cper: Fix endianness of PCI class code
Date: Sat, 6 May 2017 11:07:55 +0200
Message-ID: <20170506090755.GB19740@wunner.de>
References: <771bc335fb5856792d086ae7db288dcf244cb4cd.1493964354.git.lukas@wunner.de>
 <CAKv+Gu9PpmTBbSMKUsx6svm6fodV8x=i4b1j8QGapnEoCFcrNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9PpmTBbSMKUsx6svm6fodV8x=i4b1j8QGapnEoCFcrNA@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Ashok Raj <ashok.raj@intel.com>, linux-pci <linux-pci@vger.kernel.org>, Huang Ying <ying.huang@intel.com>
List-Id: linux-efi@vger.kernel.org

On Sat, May 06, 2017 at 08:46:07AM +0100, Ard Biesheuvel wrote:
> On 5 May 2017 at 19:38, Lukas Wunner <lukas@wunner.de> wrote:
> > The CPER parser assumes that the class code is big endian, but at least
> > on this edk2-derived Intel Purley platform it's little endian:
[snip]
> > --- a/include/linux/cper.h
> > +++ b/include/linux/cper.h
> > @@ -416,7 +416,7 @@ struct cper_sec_pcie {
> >         struct {
> >                 __u16   vendor_id;
> >                 __u16   device_id;
> > -               __u8    class_code[3];
> > +               __u32   class_code:24;
> 
> I'd like to avoid this change if we can. Couldn't we simply invert the
> order of p[] above?

Hm, why would you like to avoid it?  The class_code element isn't
referenced anywhere else in the kernel and this isn't a uapi header,
so the change would only impact out-of-tree drivers.  Not sure if
any exist which might be interested in CPER parsing.

Thanks,

Lukas
