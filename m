From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efi: stub: call get_memory_map() to obtain map and desc
 sizes
Date: Mon, 12 Jan 2015 11:09:57 +0000
Message-ID: <20150112110957.GD26589@codeblueprint.co.uk>
References: <1420739507-1708-1-git-send-email-ard.biesheuvel@linaro.org>
 <20150108190426.GC31280@leverpostej>
 <CAKv+Gu9tVjfU5S=3oLTznUFnv0WAbGcKueNjKtDtYqGQ+cxtxw@mail.gmail.com>
 <20150109101950.GA27421@leverpostej>
 <20150109105529.GP3827@bivouac.eciton.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150109105529.GP3827-t77nlHhSwNqAroYi2ySoxKxOck334EZe@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org" <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 09 Jan, at 10:55:29AM, Leif Lindholm wrote:
> 
> I disagree.
> The intent is clear, and you can not follow the current text and
> provide a version that does not do the right thing. Only the MapKey
> return is conditional on success.

Tianocore does in fact appear to set the descriptor version and size
even with a zero sized memory map buffer, so that's encouraging.

The real test will be to see how this patch performs in the wild, so
let's get it in linux-next?

-- 
Matt Fleming, Intel Open Source Technology Center
