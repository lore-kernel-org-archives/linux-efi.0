From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] lib/ucs2_string: Correct ucs2 -> utf8 conversion
Date: Mon, 15 Feb 2016 11:12:49 +0000
Message-ID: <20160215111249.GD2591@codeblueprint.co.uk>
References: <1455318813-30667-1-git-send-email-jandryuk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1455318813-30667-1-git-send-email-jandryuk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Andryuk <jandryuk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg59-JW9irJGTvgXQT0dZR+AlfA@public.gmane.org>, Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

(Cc'ing Laszlo and linux-efi)

On Fri, 12 Feb, at 11:13:33PM, Jason Andryuk wrote:
> The comparisons should be >= since 0x800 and 0x80 require an additional bit
> to store.
> 
> For the 3 byte case, the existing shift would drop off 2 more bits than
> intended.
> 
> For the 2 byte case, there should be 5 bits bits in byte 1, and 6 bits in
> byte 2.
> 
> Signed-off-by: Jason Andryuk <jandryuk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> 
> Tested in user space, but not in the kernel.  Conversions now match
> python's unicode conversions.
> 
>  lib/ucs2_string.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
 
Thanks Jason. Peter, Laszlo, any comments?

> diff --git a/lib/ucs2_string.c b/lib/ucs2_string.c
> index 17dd74e..f0b323a 100644
> --- a/lib/ucs2_string.c
> +++ b/lib/ucs2_string.c
> @@ -59,9 +59,9 @@ ucs2_utf8size(const ucs2_char_t *src)
>  	for (i = 0; i < ucs2_strlen(src); i++) {
>  		u16 c = src[i];
>  
> -		if (c > 0x800)
> +		if (c >= 0x800)
>  			j += 3;
> -		else if (c > 0x80)
> +		else if (c >= 0x80)
>  			j += 2;
>  		else
>  			j += 1;
> @@ -88,19 +88,19 @@ ucs2_as_utf8(u8 *dest, const ucs2_char_t *src, unsigned long maxlength)
>  	for (i = 0; maxlength && i < limit; i++) {
>  		u16 c = src[i];
>  
> -		if (c > 0x800) {
> +		if (c >= 0x800) {
>  			if (maxlength < 3)
>  				break;
>  			maxlength -= 3;
>  			dest[j++] = 0xe0 | (c & 0xf000) >> 12;
> -			dest[j++] = 0x80 | (c & 0x0fc0) >> 8;
> +			dest[j++] = 0x80 | (c & 0x0fc0) >> 6;
>  			dest[j++] = 0x80 | (c & 0x003f);
> -		} else if (c > 0x80) {
> +		} else if (c >= 0x80) {
>  			if (maxlength < 2)
>  				break;
>  			maxlength -= 2;
> -			dest[j++] = 0xc0 | (c & 0xfe0) >> 5;
> -			dest[j++] = 0x80 | (c & 0x01f);
> +			dest[j++] = 0xc0 | (c & 0x7c0) >> 6;
> +			dest[j++] = 0x80 | (c & 0x03f);
>  		} else {
>  			maxlength -= 1;
>  			dest[j++] = c & 0x7f;
> -- 
> 2.4.3
> 
