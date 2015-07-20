From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efi: Check for null efi kernel parameters
Date: Mon, 20 Jul 2015 11:11:28 +0100
Message-ID: <20150720101128.GA2734@codeblueprint.co.uk>
References: <1435706013-20375-1-git-send-email-ricardo.neri-calderon@linux.intel.com>
 <20150701131919.GK28334@codeblueprint.co.uk>
 <1435772254.1784.40.camel@ranerica-desk01>
 <20150720093401.GA9763@dhcp-129-220.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150720093401.GA9763-sa4SJRhfYT7GSfWCAtytT/XAX3CI6PSWQQ4Iyu8u01E@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Glenn P. Williamson" <glenn.p.williamson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 20 Jul, at 05:34:01PM, Dave Young wrote:
> 
> Ricardo, I agree to fix it in parse_option_str. Do you have sent any
> update ?

Ricardo actually went with a different solution to fixing
parse_option_str(),

  http://article.gmane.org/gmane.linux.kernel.efi/5865

-- 
Matt Fleming, Intel Open Source Technology Center
