From: "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] efi: fix out-of-bounds null overwrite vulnerability
Date: Mon, 11 Jan 2016 18:16:14 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F39FA9B5C@ORSMSX114.amr.corp.intel.com>
References: <1452193530-76672-1-git-send-email-wuninsu@gmail.com>
 <20160108101323.GA2532@codeblueprint.co.uk>
 <3908561D78D1C84285E8C5FCA982C28F39FA7208@ORSMSX114.amr.corp.intel.com>
 <20160111141605.GC2644@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160111141605.GC2644-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Insu Yun <wuninsu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "taesoo-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org" <taesoo-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org>, "yeongjin.jang-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org" <yeongjin.jang-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org>, "insu-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org" <insu-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org>, "changwoo-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org" <changwoo-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

>> What about using:
>> 
>> 	msg[len] = '\0';
>> 
>> to guarantee NUL termination?
>
> But that may leave garbage bytes in 'rcd_decode_str' in the case where
> the string isn't as long as 'len'.
>
> How about memset()'ing the buffer to zero and deleting the NUL
> termination line?

Looks like overkill to me.  We only use this function in two places:

        if (cper_dimm_err_location(cmem, rcd_decode_str))
                trace_seq_printf(p, "%s", rcd_decode_str);

        if (cper_dimm_err_location(&cmem, rcd_decode_str))
                printk("%s%s\n", pfx, rcd_decode_str);

Neither would care if there were garbage after the NUL and before the
end of the rcd_decode_str[] array.

This buffer isn't visible to user space, so we aren't leaking data by having
garbage bytes after the NUL.

-Tony
