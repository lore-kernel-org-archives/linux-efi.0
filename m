From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 2/6] efivars: Keep a private global pointer to efivars
Date: Thu, 11 Apr 2013 14:10:07 +0100
Message-ID: <5166B62F.4000206@console-pimps.org>
References: <1365077935-6859-1-git-send-email-matt@console-pimps.org> <1365077935-6859-3-git-send-email-matt@console-pimps.org> <CAGTjWtAhLQVrpJSUWU=HgxuBkcjfPj_o4hN9o-ELK1g89eGA_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGTjWtAhLQVrpJSUWU=HgxuBkcjfPj_o4hN9o-ELK1g89eGA_Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 09/04/13 23:07, Mike Waychison wrote:
>> +config EFI_VARS_GENERIC_OPS
>> +       bool
>> +       depends on EFI
>> +       depends on !GOOGLE_SMI
>> +       default y
>> +
> 
> So while we have no need to support both the gsmi and real efi
> entrypoints on any given machine, we still need to be able to support
> the operation of both from the same kernel build.  How do you feel
> about removing this bit and leaving it such that efivars_init
> continues to register the "generic" efivars regardless of
> CONFIG_GOOGLE_SMI?  The rest of the patch seems fine to me.

OK sure, we can do that. Thanks for the review.

-- 
Matt Fleming, Intel Open Source Technology Center
