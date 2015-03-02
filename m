From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [GIT PULL] EFI urgent fixes
Date: Mon, 2 Mar 2015 13:35:14 +0000
Message-ID: <20150302133514.GE24476@codeblueprint.co.uk>
References: <20150302125104.GC24476@codeblueprint.co.uk>
 <20150302132410.GA4300@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150302132410.GA4300@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>, Yinghai Lu <yinghai@kernel.org>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Mon, 02 Mar, at 02:24:10PM, Ingo Molnar wrote:
> 
> Pulled, thanks Matt!
> 
> For future reference, plase leave out unreadable commit messages like 
> this:
> 
>   While adding support loading kernel and initrd above 4G to grub2 in 
>   legacy mode, I was referring to efi_high_alloc(). That will allocate 
>   buffer for kernel and then initrd, and initrd will use kernel buffer 
>   start as limit.
> 
>   During testing found two buffers will be overlapped when initrd size 
>   is very big like 400M.
> 
> I pulled it, because you do explain the commit in the second half of 
> the changelog, in parentheses - but instead of forcing readers through 
> the crappy part, please just drop the crappy explanation and fix it 
> up, or require your contributors to submit proper changelogs. (Yinghai 
> Lu is a repeat offender in that area.)

Noted, I'll be sure to do this in the future. Thanks Ingo!

-- 
Matt Fleming, Intel Open Source Technology Center
