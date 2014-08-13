From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4] efi: implement mandatory locking for UEFI Runtime Services
Date: Wed, 13 Aug 2014 18:20:17 +0200
Message-ID: <CAKv+Gu-OTHZ+-xd-gsTshv_WT2c14wS76_8o07cvFuOY51PAsg@mail.gmail.com>
References: <1407168960-30128-1-git-send-email-ard.biesheuvel@linaro.org>
	<20140805120332.GO15082@console-pimps.org>
	<CAKv+Gu8tdHE_iE-1nv6d0TuuUTmpL5-rB3+Exht7jAdE+1jW=A@mail.gmail.com>
	<20140805141417.GQ15082@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140805141417.GQ15082-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 5 August 2014 16:14, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> On Tue, 05 Aug, at 02:14:38PM, Ard Biesheuvel wrote:
>>
>> """
>> Some of the assumptions underlying the decision whether locks are
>> needed or not (e.g., SetVariable() against ResetSystem()) may not
>> apply universally to all [new] architectures that implement UEFI.
>> Rather than try to reason our way out of this, let's just implement at
>> least what the spec requires in terms of locking.
>> """
>
> Thanks Ard, I've picked this commit up for the 'next' branch.
>

Did I miss a #define efi_in_nmi() for IA-64? The spec mentions Machine
Check and INIT, but it is difficult for me to judge whether that is a
case that would need to be addressed as well.

-- 
Ard.
