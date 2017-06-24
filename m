From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [RFC] memory corruption caused by efi driver?
Date: Sat, 24 Jun 2017 13:12:05 +0200
Message-ID: <20170624111205.GA16218@kroah.com>
References: <9372b781-62ed-fcad-6306-42a0da1a37ca@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9372b781-62ed-fcad-6306-42a0da1a37ca-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yisheng Xie <xieyisheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hanjun Guo <guohanjun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Xishi Qiu <qiuxishi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, Jun 24, 2017 at 05:52:23PM +0800, Yisheng Xie wrote:
> hi all,
> 
> I met an Oops problem with linux-3.10. The RIP is sysfs_open_file+0x46/0x2b0 (I will and the full
> crash log in the end of this mail).

3.10 is _very_ old and obsolete, can you duplicate this on a modern
kernel, like 4.11?

thanks,

greg k-h
