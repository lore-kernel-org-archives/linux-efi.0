From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 3.10 ~ 3.14] efi: fix the efi 32bit boot failed problem
Date: Thu, 30 Jul 2015 17:45:44 +0100
Message-ID: <20150730164544.GL2725@codeblueprint.co.uk>
References: <1438078879-24705-1-git-send-email-fupan.li@windriver.com>
 <20150730150428.GJ2725@codeblueprint.co.uk>
 <20150730163102.GA19943@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150730163102.GA19943-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: fupan.li-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fupanli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Luis Henriques <luis.henriques-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 30 Jul, at 09:31:02AM, Greg KH wrote:
> 
> Why isn't this an issue in newer kernel releases?  Did this already get
> fixed by some other patch?  If so, why can't we just take that patch?
> If not, why not?
 
The commit 35d5134b7d5a ("x86/efi: Correct EFI boot stub use of
code32_start") only exists in the stable trees in that form because
there was quite a lot of churn in that area in Linus tree that didn't
get backported.

So the code in Linus' tree never looked like the code in the stable does
right now.

> I _REALLY_ don't like taking patches that are not already in Linus's
> tree, as it almost always turns out to be the wrong solution.

Yeah, I think this issue verifies that.

-- 
Matt Fleming, Intel Open Source Technology Center
