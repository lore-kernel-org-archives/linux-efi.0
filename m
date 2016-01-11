From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efi: fix out-of-bounds null overwrite vulnerability
Date: Mon, 11 Jan 2016 14:16:05 +0000
Message-ID: <20160111141605.GC2644@codeblueprint.co.uk>
References: <1452193530-76672-1-git-send-email-wuninsu@gmail.com>
 <20160108101323.GA2532@codeblueprint.co.uk>
 <3908561D78D1C84285E8C5FCA982C28F39FA7208@ORSMSX114.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F39FA7208-8oqHQFITsIE64kNsxIetb7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Insu Yun <wuninsu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "taesoo-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org" <taesoo-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org>, "yeongjin.jang-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org" <yeongjin.jang-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org>, "insu-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org" <insu-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org>, "changwoo-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org" <changwoo-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 08 Jan, at 04:47:17PM, Luck, Tony wrote:
> > But this function doesn't use snprintf(), it uses scnprintf() which
> > returns the number of characters written into buf and, because
> > scnprintf() largely follows vnsprintf(), it will never write more than
> > 'size' bytes into the buffer.
> 
>         if (bank && device)
>                 n = snprintf(msg, len, "DIMM location: %s %s ", bank, device);
> 
> That looks like "snprintf", not "scnprintf" to me :-)
 
Oops! Can you believe I looked at the wrong function?

> What about using:
> 
> 	msg[len] = '\0';
> 
> to guarantee NUL termination?

But that may leave garbage bytes in 'rcd_decode_str' in the case where
the string isn't as long as 'len'.

How about memset()'ing the buffer to zero and deleting the NUL
termination line?
