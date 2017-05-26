From: Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH] efi/cper: Fix endianness of PCI class code
Date: Fri, 26 May 2017 12:45:55 +0200
Message-ID: <20170526104555.GB4744@wunner.de>
References: <20170510084143.GA16261@wunner.de>
 <CAKv+Gu81gvNL1jkb3T35=-5fr_x-BmSg9X2CcQ97xv5JTZ-c1A@mail.gmail.com>
 <20170525123047.GA4172@wunner.de>
 <CAKv+Gu_3vYKGOrzC8+Y3QwXOtV8Tbm8HC7nzQCdKVB1Qbdoriw@mail.gmail.com>
 <20170525124445.GA4181@wunner.de>
 <CAKv+Gu-7dr=upMcs2SsE+7+LRA2q82=exDrtt6CMniiMjZU2YA@mail.gmail.com>
 <20170525125650.GA4196@wunner.de>
 <CAKv+Gu_==Q5L+w2ihZ6u-=_AKZJun8D=sUWhgx6Pvzt-K99fTA@mail.gmail.com>
 <20170526060843.GA4446@wunner.de>
 <CAK8P3a0YthR69OFGzVqsPoGv3UEGFA9jnedubwQtZj-v0LzQQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK8P3a0YthR69OFGzVqsPoGv3UEGFA9jnedubwQtZj-v0LzQQA@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Ashok Raj <ashok.raj@intel.com>, linux-pci <linux-pci@vger.kernel.org>, Huang Ying <ying.huang@intel.com>
List-Id: linux-efi@vger.kernel.org

On Fri, May 26, 2017 at 10:01:28AM +0200, Arnd Bergmann wrote:
> On Fri, May 26, 2017 at 8:08 AM, Lukas Wunner <lukas@wunner.de> wrote:
> > On Thu, May 25, 2017 at 06:07:35AM -0700, Ard Biesheuvel wrote:
> >> On 25 May 2017 at 05:56, Lukas Wunner <lukas@wunner.de> wrote:
> >> >> Or does 'guarantee' mean 'I tested it and it works'?
> >> >
> >> > I tested it with x86_64 (le) and ppc32 (be) and it works.
> >> > I don't have an aarch64 machine available here.
> >>
> >> Good.
> >
> > Good to merge then?
> 
> Please remove the bit fields and find a way to do the patch without them.
> We really don't want any bitfields in structures that are interpreted by
> hardware:

This structure is not interpreted by hardware.

Thanks,

Lukas
