From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efivars: use to_efivar_entry
Date: Fri, 8 Jan 2016 11:47:51 +0000
Message-ID: <20160108114751.GF2532@codeblueprint.co.uk>
References: <044a291472c1df670c9b1247071f7af3a2c49a7d.1452003358.git.geliangtang@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <044a291472c1df670c9b1247071f7af3a2c49a7d.1452003358.git.geliangtang-9Onoh4P/yGk@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Geliang Tang <geliangtang-9Onoh4P/yGk@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 05 Jan, at 10:17:17PM, Geliang Tang wrote:
> Use to_efivar_entry() instead of open-coding it.
> 
> Signed-off-by: Geliang Tang <geliangtang-9Onoh4P/yGk@public.gmane.org>
> ---
>  drivers/firmware/efi/efivars.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks, applied for v4.6.
