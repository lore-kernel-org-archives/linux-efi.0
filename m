From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/5] Add ucs2 -> utf8 helper functions
Date: Fri, 12 Feb 2016 10:07:13 -0500
Message-ID: <20160212150713.GB31573@redhat.com>
References: <1454600074-14854-1-git-send-email-pjones@redhat.com>
 <1454600074-14854-2-git-send-email-pjones@redhat.com>
 <56BDDC95.8030608@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56BDDC95.8030608-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, efi kernel list <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Feb 12, 2016 at 02:22:29PM +0100, Laszlo Ersek wrote:
> (I imported these messages from the gmane archive, after reading about
> this work on LWN. Sorry if I'm not looking at the latest patches.)
> 
> On 02/04/16 16:34, Peter Jones wrote:
> > This adds ucs2_utf8size(), which tells us how big our ucs2 string is in
> > bytes, and ucs2_as_utf8, which translates from ucs2 to utf8..
> > 
> > Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA-XMD5yJDbdMReXY1tMh2IBg@public.gmane.org>
> > Tested-by: Lee, Chun-Yi <jlee-IBi9RG/b67k-XMD5yJDbdMReXY1tMh2IBg@public.gmane.org>
> > Acked-by: Matthew Garrett <mjg59-JW9irJGTvgXQT0dZR+AlfA-XMD5yJDbdMReXY1tMh2IBg@public.gmane.org>
> > ---
> >  include/linux/ucs2_string.h |  4 +++
> >  lib/ucs2_string.c           | 62 +++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 66 insertions(+)
> > 
> > diff --git a/include/linux/ucs2_string.h b/include/linux/ucs2_string.h
> > index cbb20af..bb679b4 100644
> > --- a/include/linux/ucs2_string.h
> > +++ b/include/linux/ucs2_string.h
> > @@ -11,4 +11,8 @@ unsigned long ucs2_strlen(const ucs2_char_t *s);
> >  unsigned long ucs2_strsize(const ucs2_char_t *data, unsigned long maxlength);
> >  int ucs2_strncmp(const ucs2_char_t *a, const ucs2_char_t *b, size_t len);
> >  
> > +unsigned long ucs2_utf8size(const ucs2_char_t *src);
> > +unsigned long ucs2_as_utf8(u8 *dest, const ucs2_char_t *src,
> > +			   unsigned long maxlength);
> > +
> >  #endif /* _LINUX_UCS2_STRING_H_ */
> > diff --git a/lib/ucs2_string.c b/lib/ucs2_string.c
> > index 6f500ef..17dd74e 100644
> > --- a/lib/ucs2_string.c
> > +++ b/lib/ucs2_string.c
> > @@ -49,3 +49,65 @@ ucs2_strncmp(const ucs2_char_t *a, const ucs2_char_t *b, size_t len)
> >          }
> >  }
> >  EXPORT_SYMBOL(ucs2_strncmp);
> > +
> > +unsigned long
> > +ucs2_utf8size(const ucs2_char_t *src)
> > +{
> > +	unsigned long i;
> > +	unsigned long j = 0;
> > +
> > +	for (i = 0; i < ucs2_strlen(src); i++) {
> > +		u16 c = src[i];
> > +
> > +		if (c > 0x800)
> > +			j += 3;
> > +		else if (c > 0x80)
> > +			j += 2;
> > +		else
> > +			j += 1;
> > +	}
> > +
> > +	return j;
> > +}
> > +EXPORT_SYMBOL(ucs2_utf8size);
> > +
> > +/*
> > + * copy at most maxlength bytes of whole utf8 characters to dest from the
> > + * ucs2 string src.
> > + *
> > + * The return value is the number of characters copied, not including the
> > + * final NUL character.
> > + */
> > +unsigned long
> > +ucs2_as_utf8(u8 *dest, const ucs2_char_t *src, unsigned long maxlength)
> > +{
> > +	unsigned int i;
> > +	unsigned long j = 0;
> > +	unsigned long limit = ucs2_strnlen(src, maxlength);
> > +
> > +	for (i = 0; maxlength && i < limit; i++) {
> > +		u16 c = src[i];
> > +
> > +		if (c > 0x800) {
> > +			if (maxlength < 3)
> > +				break;
> > +			maxlength -= 3;
> > +			dest[j++] = 0xe0 | (c & 0xf000) >> 12;
> > +			dest[j++] = 0x80 | (c & 0x0fc0) >> 8;
> > +			dest[j++] = 0x80 | (c & 0x003f);
> > +		} else if (c > 0x80) {
> > +			if (maxlength < 2)
> > +				break;
> > +			maxlength -= 2;
> > +			dest[j++] = 0xc0 | (c & 0xfe0) >> 5;
> > +			dest[j++] = 0x80 | (c & 0x01f);
> > +		} else {
> > +			maxlength -= 1;
> > +			dest[j++] = c & 0x7f;
> > +		}
> > +	}
> > +	if (maxlength)
> > +		dest[j] = '\0';
> > +	return j;
> > +}
> > +EXPORT_SYMBOL(ucs2_as_utf8);
> > 
> 
> Since this code is being added to a generic library, I have two comments
> / questions:
> 
> (1) shouldn't we handle the endianness of ucs2_char_t explicitly?
> 
> https://en.wikipedia.org/wiki/UTF-16#Byte_order_encoding_schemes

TBH I've explicitly ignored this because EFI is always LE.  If somebody
else decides they're using this code for something else, then either a)
we'll need to add some cpu_to_le16() and whatnot, or declare it a
prerequisite on the input.

> (2) Code *units* that stand for low or high halves of surrogate pairs
> (0xD800 to 0xDFFF) are not treated specially; meaning the unicode code
> *point* they represent (from U+10000 to U+10FFFF) is not decoded, and
> then separately encoded to UTF-8. Instead, the above will transcode the
> surrogates individually to UTF-8, which looks invalid.
> 
> https://en.wikipedia.org/wiki/UTF-16#U.2B10000_to_U.2B10FFFF
> 
> https://en.wikipedia.org/wiki/UTF-8#Invalid_code_points
> 
> Has this been considered?
> 
> Again, the above two questions don't seem relevant for UEFI
> specifically: first, UEFI is little-endian only; second, UEFI does not
> support surrogate characters -- I found a hint about this in the HII
> chapter of the spec, "31.2.6.2.2 Surrogate Area".
>
> But since this code is being added to a generic library, the UEFI
> assumptions may not hold for other (future) callers.
> 
> Or does "ucs2" -- as opposed to "utf16" -- imply that the caller is
> responsible for not passing in code units from the surrogate area? If
> so, I think this should be spelled out in a comment as well, and maybe
> even WARN'd about.

UCS-2 means /there are no surrogates/.  Everything directly maps to the
16-bit subset set of unicode characters.

-- 
        Peter
