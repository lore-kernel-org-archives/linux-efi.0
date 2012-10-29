From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] efivars: disable seeking on efivarfs files
Date: Mon, 29 Oct 2012 18:55:36 +0000
Message-ID: <1351536936.14888.42.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1351461188.69188.706774060048.1.gpush@pororo>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351461188.69188.706774060048.1.gpush@pororo>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>
Cc: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, Chun-Yi Lee <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sun, 2012-10-28 at 22:53 +0100, Jeremy Kerr wrote:
> Use no_llseek as the llseek callback for efivarfs files, as we don't
> support writes to arbitrary locations.
> 
> Signed-off-by: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> 
> ---
>  drivers/firmware/efivars.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks!

-- 
Matt Fleming, Intel Open Source Technology Center
