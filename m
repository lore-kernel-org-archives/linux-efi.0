From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [RFC] memory corruption caused by efi driver?
Date: Sun, 25 Jun 2017 15:31:49 +0200
Message-ID: <20170625133149.GA5611@kroah.com>
References: <9372b781-62ed-fcad-6306-42a0da1a37ca@huawei.com>
 <20170624111205.GA16218@kroah.com>
 <594FB572.4000506@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <594FB572.4000506-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Xishi Qiu <qiuxishi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Yisheng Xie <xieyisheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hanjun Guo <guohanjun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sun, Jun 25, 2017 at 09:06:58PM +0800, Xishi Qiu wrote:
> On 2017/6/24 19:12, Greg KH wrote:
> 
> > On Sat, Jun 24, 2017 at 05:52:23PM +0800, Yisheng Xie wrote:
> >> hi all,
> >>
> >> I met an Oops problem with linux-3.10. The RIP is sysfs_open_file+0x46/0x2b0 (I will and the full
> >> crash log in the end of this mail).
> > 
> > 3.10 is _very_ old and obsolete, can you duplicate this on a modern
> > kernel, like 4.11?
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > .
> > 
> 
> Hi, if I disable CONFIG_EFI_VARS, it seems OK now.
> 
> And I cann't reproduce the problem on mainline(v4.12).
> 
> Here is my test, run some stress test, then
> cat /sys/firmware/efi/efivars/*
> or
> cat /sys/firmware/efi/vars/*/*
> 
> 1) 3.10, get warning
> CONFIG_EFI_VARS=y
> CONFIG_EFIVAR_FS=y
> 
> 2) 3.10, get warning
> CONFIG_EFI_VARS=y
> CONFIG_EFIVAR_FS=n
> 
> 3) 3.10, ok
> CONFIG_EFI_VARS=n
> CONFIG_EFIVAR_FS=y
> 
> 4) mainline, ok
> CONFIG_EFI_VARS=y
> CONFIG_EFIVAR_FS=y

Then use mainline :)
