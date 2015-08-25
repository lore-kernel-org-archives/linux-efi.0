From: "dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: memleak on efi_enter_virtual_mode()
Date: Tue, 25 Aug 2015 13:18:56 +0800
Message-ID: <20150825051856.GA20225@dhcp-129-120.nay.redhat.com>
References: <BA6F50564D52C24884F9840E07E32DEC2A8F10F0@CDSMSX102.ccr.corp.intel.com>
 <20150824055558.GA15397@dhcp-129-120.nay.redhat.com>
 <BA6F50564D52C24884F9840E07E32DEC2A8F1D68@CDSMSX102.ccr.corp.intel.com>
 <1440414057.5713.19.camel@intel.com>
 <BA6F50564D52C24884F9840E07E32DEC2A8F2306@CDSMSX102.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BA6F50564D52C24884F9840E07E32DEC2A8F2306-NNgA2WnScMOiAffOGbnezLfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Zhang, Tianfei" <tianfei.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "bp-l3A5Bk7waGM@public.gmane.org" <bp-l3A5Bk7waGM@public.gmane.org>, "mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 08/25/15 at 01:57am, Zhang, Tianfei wrote:
> Hi dy:
> When free the memory ( efi_runtime_map) krealloc in save_runtime_map() function?

It will be never freed, kexec_file syscall will use it while loading bzImage.

Thanks
Dave
