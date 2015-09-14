From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH] efi/libstub/fdt: Standardize the names of
	EFI stub parameters
Date: Mon, 14 Sep 2015 17:31:33 +0800
Message-ID: <55F693F5.8030203@huawei.com>
References: <20150910112418.GC29293@leverpostej>	<alpine.DEB.2.02.1509101223580.2672@kaball.uk.xensource.com>	<20150910121514.GE29293@leverpostej>	<alpine.DEB.2.02.1509101429480.2672@kaball.uk.xensource.com>	<20150910144938.GI29293@leverpostej>	<alpine.DEB.2.02.1509101655020.2672@kaball.uk.xensource.com>	<20150910162302.GN29293@leverpostej>	<20150911124643.GB4530@olila.local.net-space.pl>	<alpine.DEB.2.02.1509111410180.2672@kaball.uk.xensource.com>	<CAKv+Gu9rN7_mxk0huX+34HSCC_aTWVTkUZKQMB1+9U56fRnwsA@mail.gmail.com>	<20150911154534.GD4530@olila.local.net-space.pl>	<55F6886D.1090900@huawei.com>
	<CAKv+Gu-xAAd=xTOh+qZvPDthgbRPLy=YwT4xfi4dS53EgJRh1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xen.org>
In-Reply-To: <CAKv+Gu-xAAd=xTOh+qZvPDthgbRPLy=YwT4xfi4dS53EgJRh1Q@mail.gmail.com>
List-Unsubscribe: <http://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <http://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Sender: xen-devel-bounces@lists.xen.org
Errors-To: xen-devel-bounces@lists.xen.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>, Stefano Stabellini <stefano.stabellini@eu.citrix.com>, Daniel Kiper <daniel.kiper@oracle.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "leif.lindholm@linaro.org" <leif.lindholm@linaro.org>, "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>, "julien.grall@citrix.com" <julien.grall@citrix.com>, "freebsd-arm@freebsd.org" <freebsd-arm@freebsd.org>, "matt.fleming@intel.com" <matt.fleming@intel.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "jbeulich@suse.com" <jbeulich@suse.com>, "peter.huangpeng@huawei.com" <peter.huangpeng@huawei.com>, linux-arm-kernel@lists.infradead
List-Id: linux-efi@vger.kernel.org



On 2015/9/14 17:09, Ard Biesheuvel wrote:
> On 14 September 2015 at 10:42, Shannon Zhao <zhaoshenglong@huawei.com> wrote:
> [..]
> 
>>
>> It only needs to apply following patch to fix a bug in Linux kernel when
>> mapping EFI_MEMORY_RUNTIME memory.
>>
> 
> Could you explain why you think efi_virtmap_init() should fail if
> there are no EFI_MEMORY_RUNTIME regions?
> 

My understanding is that if there are no EFI_MEMORY_RUNTIME regions, it
means we can't use runtime services and should not set the bit
EFI_RUNTIME_SERVICES of efi.flags. But if efi_virtmap_init() return
true, the bit will be set.

> The absence of such regions is allowed by the spec, so
> efi_virtmap_init() is correct imo to return success.
> 
Sorry, not well know about the spec. Could you point out where the spec
says this?

> If you are trying to work around the issue where Xen does not expose
> any Runtime Services regions, there is simply no way to do that and be
> still UEFI compliant. I have suggested before that we should perhaps
> tolerate this anyway, by considering the case where the EFI System
> Table has a NULL runtime services pointer. But rigging
> efi_virtmap_init() like this is really not the way to achieve that.
> 

-- 
Shannon
