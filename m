From: Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] lib: Always NUL terminate ucs2_as_utf8
Date: Mon, 25 Apr 2016 12:17:12 +0200
Message-ID: <571DEEA8.7000305@redhat.com>
References: <1461141427-16361-1-git-send-email-chris@chris-wilson.co.uk>
 <5717834C.6070802@redhat.com> <20160421121827.GE2829@codeblueprint.co.uk>
 <5718FDF7.4030309@redhat.com> <20160422185210.GG2829@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160422185210.GG2829-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Jason Andryuk <jandryuk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matthew Garrett <mjg59-JW9irJGTvgXQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 04/22/16 20:52, Matt Fleming wrote:
> On Thu, 21 Apr, at 06:21:11PM, Laszlo Ersek wrote:
>>
>> ... How about this instead?
> 
> Your patch looks fine to me. I've gone ahead and stuck it in the
> urgent EFI queue.

I intended to probe for opinions first, and then (if appropriate) submit
the patch stand-alone second, but apparently on linux-efi it's Workflow
deLuxe for contributors! ;)

Thank you, Matt!
Laszlo

> Thanks everyone!
> 
