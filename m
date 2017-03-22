From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: [PATCH v2] efifb: avoid reconfiguration of BAR that covers the
 framebuffer
Date: Wed, 22 Mar 2017 14:10:05 +0000
Message-ID: <20170322141005.GA4221@red-moon>
References: <1490123810-12383-1-git-send-email-ard.biesheuvel@linaro.org>
 <20170322102939.GB3519@red-moon>
 <35F65528-FC1F-4813-A0C6-641CF864212A@linaro.org>
 <20170322113500.GA3940@red-moon>
 <CAKv+Gu-XJK8bJvPrjfHbFHsOmuJ96RRgdsg2E7vgC0HZDemyFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-XJK8bJvPrjfHbFHsOmuJ96RRgdsg2E7vgC0HZDemyFg@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Peter Jones <pjones@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Hanjun Guo <hanjun.guo@linaro.org>, Heyi Guo <heyi.guo@linaro.org>, linux-pci <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Mar 22, 2017 at 12:39:57PM +0000, Ard Biesheuvel wrote:

[...]

> >> Well, it turned out that this does not actually work: the BAR is not
> >> reassigned, but the same range ends up being given to another device
> >> in some cases.
> >
> > Ok, that's because the PCI core just prevent assigning that resource
> > but it does not request it (ie insert it in the resource tree) which
> > is what you do when claiming it.
> >
> 
> Yes, that seems to be what is happening.
> 
> > I wonder how IORESOURCE_PCI_FIXED works on eg x86, I think it is time
> > to have a proper look into resources allocation code because there
> > are bits and pieces that are quite obscure to me.
> >
> 
> I did a quick test with calling request_mem_region(), in which case we
> end up with something like
> 
> 10000000-3efeffff : PCI Bus 0000:00
>   10000000-101d4bff : efifb:pci
>   101d5000-101d5fff : 0000:00:01.0
>   101d6000-101d6fff : 0000:00:02.0
>   101d7000-101d7fff : 0000:00:04.0
>     101d7000-101d7fff : ehci_hcd
>   101d8000-101d8fff : 0000:00:05.0
>   101e0000-101effff : 0000:00:05.0
>   10200000-1023ffff : 0000:00:02.0
> 
> which works, because the region is no longer assigned to another BAR.
> 
> But I think claiming the resource via the PCI subsystem is probably
> more appropriate, because then we get

Yes it is.

> 10000000-3efeffff : PCI Bus 0000:00
>   10000000-10ffffff : 0000:00:05.0
>     10000000-101d4fff : efifb
>   11000000-1103ffff : 0000:00:02.0
>   11040000-1104ffff : 0000:00:05.0
>   11050000-11050fff : 0000:00:01.0
>   11051000-11051fff : 0000:00:02.0
>   11052000-11052fff : 0000:00:04.0
>     11052000-11052fff : ehci_hcd
>   11053000-11053fff : 0000:00:05.0
> 
> (Note that efifb does not use the entire BAR resource)
> 
> > I think I would reverse the order in which you carry out the BAR
> > reservation anyway (first check if the device is enabled second request
> > the resource ie claim it).
> >
> 
> I will spin a v3 with the check and the claim in reverse order. But I
> think we should keep the pci_claim() call.

Agreed.

Thanks,
Lorenzo
