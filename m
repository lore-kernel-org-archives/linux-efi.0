From: Tony Luck <tony.luck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] efi: fix out-of-bounds null overwrite vulnerability
Date: Thu, 14 Jan 2016 18:06:53 -0800
Message-ID: <CA+8MBb+qpjMJNxWA8FCwNwrPUTZK1gU=GaXMEO3YKUaGo3qLUQ@mail.gmail.com>
References: <1452193530-76672-1-git-send-email-wuninsu@gmail.com>
	<20160108101323.GA2532@codeblueprint.co.uk>
	<3908561D78D1C84285E8C5FCA982C28F39FA7208@ORSMSX114.amr.corp.intel.com>
	<20160111141605.GC2644@codeblueprint.co.uk>
	<3908561D78D1C84285E8C5FCA982C28F39FA9B5C@ORSMSX114.amr.corp.intel.com>
	<20160114111200.GA2810@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160114111200.GA2810-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Insu Yun <wuninsu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "taesoo-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org" <taesoo-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org>, "yeongjin.jang-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org" <yeongjin.jang-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org>, "insu-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org" <insu-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org>, "changwoo-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org" <changwoo-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Jan 14, 2016 at 3:12 AM, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> What about *before* the NUL? That was the point I was trying to make.
> If the string you print into the buffer isn't 'len' bytes in size the
> buffer will look like,
>
>   "DIMM location: Foo bar<garbage.....>\0"

Doesn't that actually look like:

    "DIMM location: Foo bar\0<garbage.....>\0"

snprintf() will NUL terminate what it writes into the buffer
if the buffer is big enough for what you were trying to
write there.  The problem happens when what you want
to write is too big. Then you have

    "DIMM location: ReallyLongFoo AlsoBar"


at which point "msg[len] = '\0'; will zap that 'r'
at the end to make sure printk() will stop at the
end of the valid part of buffer.

-Tony
