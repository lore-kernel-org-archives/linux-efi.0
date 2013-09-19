From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 09/17] Move unicode to ASCII conversion to shared function.
Date: Wed, 18 Sep 2013 22:46:39 -0500
Message-ID: <523A739F.9050103@zytor.com>
References: <1379391093-27948-1-git-send-email-roy.franz@linaro.org> <1379391093-27948-10-git-send-email-roy.franz@linaro.org> <20130919034406.GA26385@angband.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130919034406.GA26385-b9QjgO8OEXPVItvQsEIGlw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adam Borowski <kilobyte-b9QjgO8OEXPVItvQsEIGlw@public.gmane.org>
Cc: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 09/18/2013 10:44 PM, Adam Borowski wrote:
> 
> In fact, these days it's 8-bit encodings that are more likely to be Unicode
> than 16-bit ones: UTF-8 is ubiquitous, while you usually get UCS2 at most.
> In either case, though, we have here is a 7-bit charset encoded as either
> 8-bit or 16-bit units.  What this function does is blindly truncating upper
> byte.  The supported payload is in both cases ASCII.
> 
> I'd thus rename the function to what it already does: truncating u16 to u8,
> and adjust comments accordingly.
> 
> Replacing values above 126 with a token character like '?' would be good
> too: that'd avoid producing corrupted characters and/or random ASCII chars.
> 
> Your commit only moves things around, so it might be out of scope for now,
> but I wonder: what if the kernel actually supported Unicode here?  Few
> cmdline arguments take values where non-ASCII makes sense, but at least some
> do: for example, a Russian guy is not unlikely to name subvolumes using
> cyrillic.  Supporting that would be easy (estimating the length then
> utf16s_to_utf8s()).  There's just one problem: which encoding to use, but
> these days, most distributions have either dropped non-UTF8 or hardly pay
> lip service, so we could get away with hard-coding UTF-8: those few who
> use ancient charsets can stick to ASCII.  Would this be ok?  If so, shout,
> I can code this if you don't care enough.
> 

We should, indeed, do proper conversion to UTF-8 here.

I also suspect we should assume the input is UTF-16 rather than UCS-2,
although that is a bit more exotic.

	-hpa
