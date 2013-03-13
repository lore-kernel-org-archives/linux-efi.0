From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] efivars: Allow disabling use as a pstore backend
Date: Wed, 13 Mar 2013 10:25:08 -0700
Message-ID: <5140B674.8070308@zytor.com>
References: <1362678017-2862-1-git-send-email-seth.forshee@canonical.com> <5138FAD9.7050504@zytor.com> <20130307205915.GF24233@thinkpad-t410> <1362694529.15011.211.camel@mfleming-mobl1.ger.corp.intel.com> <513911F9.8050308@zytor.com> <20130311211750.GB8440@thinkpad-t410> <1363118073.15011.275.camel@mfleming-mobl1.ger.corp.intel.com> <20130312211417.GC16558@thinkpad-t410> <1363189770.15011.300.camel@mfleming-mobl1.ger.corp.intel.com> <20130313170724.GB12157@thinkpad-t410>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130313170724.GB12157@thinkpad-t410>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 03/13/2013 10:07 AM, Seth Forshee wrote:
>>
>> Granted, this change does mean that your decision at compile time may be
>> final, and you can't enable the pstore code at runtime if you built your
>> kernel/efivars module with CONFIG_EFI_VARS_PSTORE=n. Arguably, I think
>> that's a feature that some people will want, e.g. "Don't allow enabling
>> the efivars pstore backend at all... no, srsly!".
> 
> Hmm. Since my original patch was to compile pstore support out
> completely, I interpreted Peter's suggestion to be allowing the user
> override the default even if the default is disabled. That's the
> assumption my implementation was based off of, but maybe I
> misunderstood.
> 
> But if Peter agrees with your changes then I'm fine with them too.
> 

I think there should be two compile-time options (one to compile in the
EFI pstore code at all, and one to set its default.)

	-hpa
