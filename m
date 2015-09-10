From: "Jan Beulich" <JBeulich@suse.com>
Subject: Re: [Xen-devel] [PATCH] efi/libstub/fdt: Standardize the names
 of EFI stub parameters
Date: Thu, 10 Sep 2015 07:08:50 -0600
Message-ID: <55F19D0202000078000A1B54@prv-mh.provo.novell.com>
References: <1441874516-11364-1-git-send-email-zhaoshenglong@huawei.com>
 <20150910095208.GA29293@leverpostej>
 <alpine.DEB.2.02.1509101116580.2672@kaball.uk.xensource.com>
 <20150910112418.GC29293@leverpostej>
 <alpine.DEB.2.02.1509101223580.2672@kaball.uk.xensource.com>
 <20150910121514.GE29293@leverpostej>
 <1441889905.24450.382.camel@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1441889905.24450.382.camel@citrix.com>
Content-Disposition: inline
Sender: linux-doc-owner@vger.kernel.org
To: Ian Campbell <ian.campbell@citrix.com>
Cc: Mark Rutland <mark.rutland@arm.com>, "julien.grall@citrix.com" <julien.grall@citrix.com>, Stefano Stabellini <stefano.stabellini@eu.citrix.com>, "freebsd-arm@freebsd.org" <freebsd-arm@freebsd.org>, "peter.huangpeng@huawei.com" <peter.huangpeng@huawei.com>, Shannon Zhao <zhaoshenglong@huawei.com>, "matt.fleming@intel.com" <matt.fleming@intel.com>, "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "leif.lindholm@linaro.org" <leif.lindholm@linaro.org>, "shannon.zhao@linaro.org" <shannon.zhao@linaro.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>, "daniel.kiper@oracle.com" <daniel.kiper@oracle.com>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

>>> On 10.09.15 at 14:58, <ian.campbell@citrix.com> wrote:
> On Thu, 2015-09-10 at 13:15 +0100, Mark Rutland wrote:
> 
>> > In any case this should be separate from the shim ABI discussion.
>> 
>> I disagree; I think this is very much relevant to the ABI discussion.
>> That's not to say that I insist on a particular approach, but I think
>> that they need to be considered together.
> 
> Taking a step back, the reason for using the EFI stub parameters is only
> (AFAIK) in order to be able to locate the ACPI RDSP (the root table
> pointer), which as it happens is normally passed via one of the EFI
> firmware tables.
> 
> If there was a way to achieve that goal (i.e. another way to find the RSDP)
> without opening the can of UEFI worms then we could consider that opiton
> too.
> 
> a way != the legacy x86 thing of scanning low memory of the signature, of
> course.

But even x86 doesn't do that (other than as a fallback) on EFI. The
configuration table is available to Dom0 (via XENPF_firmware_info:
XEN_FW_EFI_INFO:XEN_FW_EFI_CONFIG_TABLE).

Jan

