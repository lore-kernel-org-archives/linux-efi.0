From: "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] efi: fix out-of-bounds null overwrite vulnerability
Date: Fri, 8 Jan 2016 16:47:17 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F39FA7208@ORSMSX114.amr.corp.intel.com>
References: <1452193530-76672-1-git-send-email-wuninsu@gmail.com>
 <20160108101323.GA2532@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160108101323.GA2532-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Insu Yun <wuninsu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "taesoo-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org" <taesoo-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org>, "yeongjin.jang-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org" <yeongjin.jang-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org>, "insu-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org" <insu-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org>, "changwoo-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org" <changwoo-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> But this function doesn't use snprintf(), it uses scnprintf() which
> returns the number of characters written into buf and, because
> scnprintf() largely follows vnsprintf(), it will never write more than
> 'size' bytes into the buffer.

        if (bank && device)
                n = snprintf(msg, len, "DIMM location: %s %s ", bank, device);

That looks like "snprintf", not "scnprintf" to me :-)

What about using:

	msg[len] = '\0';

to guarantee NUL termination?

-Tony
