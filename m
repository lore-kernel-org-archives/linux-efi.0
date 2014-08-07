From: Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH 1/2] UEFI arm64: add noefi boot param
Date: Thu, 7 Aug 2014 14:19:45 +0800
Message-ID: <20140807061945.GE20295@darkstar.nay.redhat.com>
References: <20140806083825.GA31711@dhcp-16-198.nay.redhat.com>
 <20140806130623.GI4179@bivouac.eciton.net>
 <20140806132021.GB15082@console-pimps.org>
 <20140806132941.GJ4179@bivouac.eciton.net>
 <20140806140155.GC15082@console-pimps.org>
 <CAKv+Gu8ey1iKu-_wS6yYaEXQaQMDXa+PF5Kiw+edA9a_OE1EAw@mail.gmail.com>
 <20140806141814.GD15082@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20140806141814.GD15082@console-pimps.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Matt Fleming <matt@console-pimps.org>
Cc: Matt Fleming <matt.fleming@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Leif Lindholm <leif.lindholm@linaro.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Mark Salter <msalter@redhat.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On 08/06/14 at 03:18pm, Matt Fleming wrote:
> On Wed, 06 Aug, at 04:10:45PM, Ard Biesheuvel wrote:
> > 
> > Shouldn't we clear the bit here if we failed to enable runtime
> > services for some reason? Other code may test the bit assuming that it
> > signifies that runtime services have been enabled successfully, while
> > this patch changes it to mean that we /intended/ to enable them, which
> > is not quite the same thing.
> 
> Yep, good catch. We need to do something similar for efi_runtime_init()
> on x86 too.

The current efi_runtime_init() enables the bit after getting the efi callback
phyaddr of SetVirtualAddressMap.

Thinking more about it, since SetVirtualAddressMap() could fail somehow it
seems better to set EFI_RUNTIME_SERIVCES bit only when enter virtual mode
return EFI_SUCCESS.

Does it make sense to you, Matt?

Thanks
Dave
