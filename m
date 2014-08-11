From: Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH 1/2] UEFI arm64: add noefi boot param
Date: Mon, 11 Aug 2014 17:00:14 +0800
Message-ID: <20140811090013.GD1834@darkstar.nay.redhat.com>
References: <20140806083825.GA31711@dhcp-16-198.nay.redhat.com>
 <20140806130623.GI4179@bivouac.eciton.net>
 <20140806132021.GB15082@console-pimps.org>
 <20140806132941.GJ4179@bivouac.eciton.net>
 <20140806140155.GC15082@console-pimps.org>
 <CAKv+Gu8ey1iKu-_wS6yYaEXQaQMDXa+PF5Kiw+edA9a_OE1EAw@mail.gmail.com>
 <20140806141814.GD15082@console-pimps.org>
 <20140807061945.GE20295@darkstar.nay.redhat.com>
 <20140807202620.GI15082@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140807202620.GI15082@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Leif Lindholm <leif.lindholm@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Matt Fleming <matt.fleming@intel.com>, Mark Salter <msalter@redhat.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 08/07/14 at 09:26pm, Matt Fleming wrote:
> On Thu, 07 Aug, at 02:19:45PM, Dave Young wrote:
> > 
> > The current efi_runtime_init() enables the bit after getting the efi
> > callback phyaddr of SetVirtualAddressMap.
> > 
> > Thinking more about it, since SetVirtualAddressMap() could fail
> > somehow it seems better to set EFI_RUNTIME_SERIVCES bit only when
> > enter virtual mode return EFI_SUCCESS.
> > 
> > Does it make sense to you, Matt?
> 
> If you're going ahead with the scheme I proposed yesterday you'd
> actually want to *clear* the EFI_RUNTIME_SERVICES bit if
> SetVirtualAddressMap() fails, since we would have set it by default for
> EFI_BOOT.

There's one concern about the noefi early param handling in your proposal.
Your patch depends on the parse_early_param() being called after setting
EFI_RUNTIME_SERVICES bit. It's true in X86 setup.c, but it's not in arm64
setup.c so I'm afraid there's other piece of code need early params and it
will not work.

How about using a variable like runtime_disabled, then add a global function
efi_runtime_disabled() to get the status. 


> 
> However, I still think we want to panic() if SetVirtualAddressMap()
> fails because we really never expect that function to return an error
> under normal circumstances. Also, I'm not sure it's safe to make any
> assumptions about the state of the system if SetVirtualAddressMap()
> fails.

Ok, so the panic is reasonable to me as well.

Thanks
Dave
