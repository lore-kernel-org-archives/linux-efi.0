From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] efivars: Allow disabling use as a pstore backend
Date: Thu, 07 Mar 2013 14:17:29 -0800
Message-ID: <513911F9.8050308@zytor.com>
References: <1362678017-2862-1-git-send-email-seth.forshee@canonical.com>  <5138FAD9.7050504@zytor.com> <20130307205915.GF24233@thinkpad-t410> <1362694529.15011.211.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1362694529.15011.211.camel-ZqTwcBeJ+wsBof6jY8KHXm7IUlhRatedral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 03/07/2013 02:15 PM, Matt Fleming wrote:
>>>
>>> What about a command line option?
>>
>> That could be done. I'm assuming you want this instead of a config
>> option, defaulted to on?
>>
>> How would you feel about a config option for the default value of the
>> command line option? I intend to default this to off in Ubuntu for a
>> while as a colleague's machine was recently bricked on two different
>> occasions after the kernel oopsed. The config option would simplify
>> things a bit for us, though we could always carry a patch changing the
>> default value.
> 
> Not sure why a command line option would be a more natural solution to
> this problem? The original patch looked fine to me. All other pstore
> backends are guarded by Kconfig options.
> 
> Though I could see an argument for a kernel parameter to turn off the
> EFI pstore backend code, even if it's compiled into the kernel. But that
> would be better as an additional patch.
> 

That way it can be enabled if needed, without the user having to build
their own kernel.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
