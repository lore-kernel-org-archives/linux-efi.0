From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] x86: move parse_early_param to earlier code for
 add_efi_memmap
Date: Sat, 16 Dec 2017 15:03:26 +0100
Message-ID: <20171216140326.sbel3qfe4fbhaybl@gmail.com>
References: <20171130052327.GA3500@dhcp-128-65.nay.redhat.com>
 <20171214104119.GA2437@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171214104119.GA2437-0VdLhd/A9Pl+NNSt+8eSiB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
List-Id: linux-efi@vger.kernel.org


* Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> Another way is move "efi_memblock_x86_reserve_range" to later code
> Maybe below is better?

Yeah, that's much lower risk, if the affected EFI code does not mind being called 
later. We had trouble from trying to move early param parsing wholesale.

I've applied your v2 patch tip:efi/core.

Thanks,

	Ingo
