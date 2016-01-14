From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] efi: fix out-of-bounds null overwrite vulnerability
Date: Thu, 14 Jan 2016 11:12:00 +0000
Message-ID: <20160114111200.GA2810@codeblueprint.co.uk>
References: <1452193530-76672-1-git-send-email-wuninsu@gmail.com>
 <20160108101323.GA2532@codeblueprint.co.uk>
 <3908561D78D1C84285E8C5FCA982C28F39FA7208@ORSMSX114.amr.corp.intel.com>
 <20160111141605.GC2644@codeblueprint.co.uk>
 <3908561D78D1C84285E8C5FCA982C28F39FA9B5C@ORSMSX114.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F39FA9B5C@ORSMSX114.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Insu Yun <wuninsu@gmail.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "taesoo@gatech.edu" <taesoo@gatech.edu>, "yeongjin.jang@gatech.edu" <yeongjin.jang@gatech.edu>, "insu@gatech.edu" <insu@gatech.edu>, "changwoo@gatech.edu" <changwoo@gatech.edu>
List-Id: linux-efi@vger.kernel.org

On Mon, 11 Jan, at 06:16:14PM, Luck, Tony wrote:
> >> What about using:
> >> 
> >> 	msg[len] = '\0';
> >> 
> >> to guarantee NUL termination?
> >
> > But that may leave garbage bytes in 'rcd_decode_str' in the case where
> > the string isn't as long as 'len'.
> >
> > How about memset()'ing the buffer to zero and deleting the NUL
> > termination line?
> 
> Looks like overkill to me.  We only use this function in two places:
> 
>         if (cper_dimm_err_location(cmem, rcd_decode_str))
>                 trace_seq_printf(p, "%s", rcd_decode_str);
> 
>         if (cper_dimm_err_location(&cmem, rcd_decode_str))
>                 printk("%s%s\n", pfx, rcd_decode_str);
> 
> Neither would care if there were garbage after the NUL and before the
> end of the rcd_decode_str[] array.
> 
> This buffer isn't visible to user space, so we aren't leaking data by having
> garbage bytes after the NUL.

What about *before* the NUL? That was the point I was trying to make.
If the string you print into the buffer isn't 'len' bytes in size the
buffer will look like,

  "DIMM location: Foo bar"<garbage.....>\0

Doing the memset() before the call to snprintf() guarantees this won't
happen and means you don't have to try and calculate where the NUL
needs to be placed.
