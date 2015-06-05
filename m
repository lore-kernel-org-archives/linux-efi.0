From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] efi: Work around ia64 build problem with ESRT driver.
Date: Fri, 5 Jun 2015 15:13:29 -0400
Message-ID: <20150605191329.GA23480@redhat.com>
References: <20150605171115.GA22534@roeck-us.net>
 <1433530475-23814-1-git-send-email-pjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1433530475-23814-1-git-send-email-pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Jun 05, 2015 at 02:54:35PM -0400, Peter Jones wrote:
> Note that I've only actually tried to build this patch on x86_64, but
> esrt.o still gets built there, and that would seem to demonstrate that
> the conditional building is working correctly at all the places the code
> built before.  I no longer have any ia64 machines handy to test that the
> exclusion actually works there.

This, of course, is a total lie.  I'll send a reply patch in which it's
actually true.

> Acked-by: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

So sorry, Tony.

-- 
        Peter
